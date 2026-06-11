@testset "Core" begin
    @testset "MPS" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",5),"0")
        @test_throws ErrorException apply!(mps, QubitCliffordGate(QC.tCNOT), [2,4])
    end
end
