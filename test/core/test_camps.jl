@testset "QubitCAMPS" begin
    siteinds = IT.siteinds("Qubit", 4)
    mps = IT.MPS(ComplexF64, siteinds, "+")

    C = QubitCliffordUnitary(4)
    apply!(C, QubitCliffordGate(QC.tHadamard),[2])
    apply!(C, QubitCliffordGate(QC.tCNOT),[1,2])
    apply!(C, QubitCliffordGate(QC.tSWAP),[2,3])

    camps = QubitCAMPS(mps, C)

    @testset "apply!" begin
        a = QubitCAMPS(deepcopy(mps))
        hadamard = (QubitPauli"X" + QubitPauli"Z")/√(2)
        apply!(a, hadamard, [2])
        apply!(a, QubitCliffordGate(QC.tCNOT),[1,2])
        apply!(a, QubitCliffordGate(QC.tSWAP),[2,3])
        @test expectation(a, QubitPauli"ZIZI") ≈ 1.0

        apply!(a, QubitPauli"Z", [4])
        @test expectation(a, QubitPauli"IIIX") ≈ -1.0

        b = QubitCAMPS(mps)
        apply!(b, C)
        @test expectation(b, QubitPauli"ZIZI") ≈ 1.0
    end

    @testset "expectation, norm, transform!" begin
        a = deepcopy(camps)
        @test expectation(a, QubitPauli"ZIZI") ≈ 1.0
        a.mps = √(0.5) * a.mps
        @test expectation(a, QubitPauli"ZIZI") ≈ 0.5
        @test expectation(a, QubitPauli"ZIZI"; normalized=true) ≈ 1.0    
        @test LA.norm(a) ≈  √(0.5)  
        @test nsites(a) == 4

        @test expectation(MT.get_mps(a), QubitPauli"XIII") ≈ 0.5
        transform!(a, QubitCliffordGate(QC.tPhase), [1])
        @test expectation(MT.get_mps(a), QubitPauli"YIII") ≈ 0.5
        @test expectation(a, QubitPauli"ZIZI"; normalized=true) ≈ 1.0    

        @test stabilizer_entropy(a) + 1  ≈ 1.0
        @test stabilizer_entropy(a,100) + 1  ≈ 1.0
        
    end
end
