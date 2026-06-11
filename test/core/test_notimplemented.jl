@testset "Core" begin
    @testset "MPS" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("Qubit",5),"0")
        @test_throws ErrorException apply!(mps, QubitCliffordGate(QC.tCNOT), [2,4])
    end

    @testset "entropy" begin
        mps = IT.MPS(ComplexF64, IT.siteinds("S=1",5),"0")
        @test_throws ErrorException stabilizer_entropy(:exact, mps)
    end
end
