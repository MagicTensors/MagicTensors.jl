@testset "MPS" begin
    @testset "apply!" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",5),"0")
        IT.orthogonalize!(mps,1)

        hadamard = (QubitPauli"X" + QubitPauli"Z")/√(2)
        apply!(mps, hadamard, [2]) 
        @test IT.expect(mps,"Z") ≈ [1,0,1,1,1]

        apply!(mps, QubitCliffordGate(QC.tCNOT), [2,3])
        @test IT.expect(mps,"Z") ≈ [1,0,0,1,1]
        @test IT.orthocenter(mps) == 3

        apply!(mps, QubitCliffordGate(QC.tSWAP), [1,2]; move_orthogonality_right=false)
        @test IT.expect(mps,"Z") ≈ [0,1,0,1,1]
        @test expectation(mps,QubitPauli"XIXII") ≈ 1
        @test IT.orthocenter(mps) == 1

        @test expectation(mps, (QubitPauli"ZIZII"+QubitPauli"XIXII")/2) ≈ 1

        mps = √(0.5)*mps
        @test expectation(mps,QubitPauli"XIXII") ≈ 0.5
        @test expectation(mps,QubitPauli"XIXII"; normalized=true) ≈ 1.0

        @test nsites(mps) == 5
    end

    @testset "singular_values" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",7),"0")
        IT.orthogonalize!(mps,1)

        apply!(mps, QubitCliffordGate(QC.tHadamard), [2])
        apply!(mps, QubitCliffordGate(QC.tCNOT), [2,3])
        @test singular_values(mps,2) ≈ [√(0.5), √(0.5)]
        apply!(mps, QubitCliffordGate(QC.tSWAP), [3,4])
        apply!(mps, QubitCliffordGate(QC.tSWAP), [4,5])
        @test IT.expect(mps,"Z") ≈ [1,0,1,1,0,1,1]

        @test singular_values(mps,3) ≈ [√(0.5), √(0.5)]

        @test singular_values(mps, cutoff=1e-12) ≈ [
            [1.0],
            [√(0.5), √(0.5)],
            [√(0.5), √(0.5)],
            [√(0.5), √(0.5)],
            [1.0],
            [1.0],
        ]

        apply!(mps, QubitCliffordGate(QC.tHadamard), [1])

        @test singular_values(mps, cutoff=1e-12) ≈ [
            [1.0],
            [√(0.5), √(0.5)],
            [√(0.5), √(0.5)],
            [√(0.5), √(0.5)],
            [1.0],
            [1.0],
        ]
    end

    @testset "apply_and_svd" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",3),"0")
        IT.orthogonalize!(mps,1)
        @test_throws ErrorException MT.apply_and_svd(mps, zeros(4,4), 2)
    end

end
