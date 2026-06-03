@testset "QubitPauli" begin
    @testset "constructor and nsites" begin
        a = QubitPauli"-iIXYZ"
        @test isa(a, QubitPauli)
        @test nsites(a) == 4

        b = QubitPauli(QuantumClifford.P"III")
        @test isa(b, QubitPauli)
        @test nsites(b) == 3

        c = zero(QubitPauli, 7)
        @test isa(c, QubitPauli)
        @test nsites(c) == 7
    end


    @testset "simple comparison and arithmatic" begin
        a = QubitPauli"-iIXYZ"
        b = QubitPauli(QuantumClifford.P"i_XYZ")
        c = zero(QubitPauli, 7)
        @test a==a
        @test a==-b
        @test a!=b
        @test a≈b
    end

    @testset "embed" begin
        a = QubitPauli"-iIXYZ"
        b = QubitPauli(QuantumClifford.P"-iZXY")
        @test a == embed(b,4,[4,2,3])
    end

    @testset "show" begin
        a = QubitPauli"-iIXYZ"
        s = sprint(io -> show(IOContext(io), a))
        @test occursin("XYZ", s)
    end

    @testset "QuantumClifford.PauliOperator" begin
        a = QubitPauli"-iIXYZ"
        p = QuantumClifford.PauliOperator(a)
        @test isa(p, QuantumClifford.PauliOperator)
        @test p == QuantumClifford.P"-i_XYZ"
    end
end



