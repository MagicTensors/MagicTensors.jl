@testset "entropy" begin
    @testset "entanglement and stabilizer" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",4),"0")
        IT.orthogonalize!(mps,1)

        apply!(mps, QubitCliffordGate(QC.tHadamard), [2])
        apply!(mps, QubitCliffordGate(QC.tCNOT), [2,3])
        apply!(mps, QubitCliffordGate(QC.tSWAP), [3,4])

        @test entanglement_entropy(mps,1)+1 ≈ 1
        @test entanglement_entropy(mps) ≈ [0, 1, 1]
        @test stabilizer_entropy(mps) + 1 ≈ 1

        @test entanglement_entropy(mps,1; α=1)+1 ≈ 1
        @test entanglement_entropy(mps; α=1) ≈ [0, 1, 1]
        @test stabilizer_entropy(mps; α=1) + 1 ≈ 1

        @test entanglement_entropy(mps,1; α=2)+1 ≈ 1
        @test entanglement_entropy(mps; α=2) ≈ [0, 1, 1]
        @test stabilizer_entropy(mps; α=2) + 1 ≈ 1

        @test entanglement_entropy(mps,1; α=-1)+1 ≈ 1
        @test entanglement_entropy(mps; α=-1) ≈ [0, 0.5, 0.5]
        @test stabilizer_entropy(mps; α=-1) + 1 ≈ 1

        tgate = [1 0; 0 √(1.0im)]
        apply!(mps, tgate, [2])
        @test stabilizer_entropy(mps) ≈ 0.41503749927885
        @test stabilizer_entropy(:exact, mps; α=1) ≈ 0.5
        @test stabilizer_entropy(:exact, mps; α=2) ≈ 0.41503749927885
        @test stabilizer_entropy(:exact, mps; α=-1) ≈ 0.25

        @test isapprox(stabilizer_entropy(mps, 10000), 0.41503749927885; atol=0.01)
        @test isapprox(stabilizer_entropy(:sampled, mps, 10000; α=1), 0.5; atol=0.01)
        @test isapprox(stabilizer_entropy(:sampled, mps, 10000; α=2), 0.41503749927885; atol=0.01)
        @test isapprox(stabilizer_entropy(:sampled, mps, 10000; α=-1), 0.25; atol=0.01)

        MT.set_warn_exact_stabilizer_entropy_threshold!(4)
        @test_nowarn stabilizer_entropy(mps)
        @test_logs (:warn,) begin
            MT.set_warn_exact_stabilizer_entropy_threshold!(3)
            stabilizer_entropy(:exact, mps)
        end
        MT.set_warn_exact_stabilizer_entropy_threshold!()
    end
end
