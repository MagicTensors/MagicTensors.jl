
@testset "AbstractCliffordGateSet" begin
    @testset "identity gate" begin
        set = QubitCliffordGateSet(3,:all)
        @test one(set) == QubitCliffordGate(one(QC.CliffordOperator,3))
    end

    @testset "iterator" begin
        set = QubitCliffordGateSet(1,:all)
        @test eltype(set) == QubitCliffordGate
        gates = [gate for gate∈set]
        @test length(gates) == length(gates)
        @test gates[1] == set[1]
        @test gates[2] == set[2]
        @test gates[3] == set[3]

        set = QubitCliffordGateSet(2,:empty)
        gates = [gate for gate∈set]
        @test length(gates) == 0
    end
end
