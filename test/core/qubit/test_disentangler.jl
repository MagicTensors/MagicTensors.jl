@testset "Qubit Disentangler" begin
    # create a CAMPS = |000⟩
    # with an MPS with a Bell pair between 1-3
    camps = QubitCAMPS(3)
    transform!(camps, QubitCliffordGate(QC.tHadamard), [1])
    transform!(camps, QubitCliffordGate(QC.tCNOT), [1,2])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [2,3])

    @testset "Default Qubit Disentangler" begin
        a = deepcopy(camps)
        res = disentangle!(a)
        @test length(res) == 3
        @test res[1] > 0 
        @test res[2] > 0.0
    end

end
