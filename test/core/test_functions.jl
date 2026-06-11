@testset "Abstract Functions" begin
    @testset "expectation" begin
        siteinds = IT.siteinds("Qubit", 4)
        mps = IT.MPS(ComplexF64, siteinds, "+")
        apply!(mps,QubitCliffordGate(QC.tHadamard),[2])
        apply!(mps,QubitCliffordGate(QC.tCNOT),[1,2])
        apply!(mps,QubitCliffordGate(QC.tSWAP),[2,3])
        @test expectation(mps, QubitPauli"Z",[3]) + 1 ≈ 1.0
        @test expectation(mps, QubitPauli"ZZ",[1,3]) ≈ 1.0
    end
end
