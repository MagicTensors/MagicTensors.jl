@testset "QubitCAMPS" begin
    siteinds = IT.siteinds("Qubit", 5)
    mps = IT.MPS(ComplexF64, siteinds, "0")
    C = QubitCliffordUnitary(5)
    gate = QubitCliffordGateSet(3,:all)[1234]
    sites = [1,4,5]
    apply!(C,gate,sites)

    camps = QubitCAMPS(mps, C)

    @testset "constructor" begin
        @test isa(QubitCAMPS(mps, QubitCliffordUnitary(5), false), QubitCAMPS)
        @test isa(QubitCAMPS(mps, QubitCliffordUnitary(5)), QubitCAMPS)
        @test isa(QubitCAMPS(mps), QubitCAMPS)
        @test isa(QubitCAMPS(QubitCliffordUnitary(5)), QubitCAMPS)
        @test_throws Exception QubitCAMPS(mps, QubitCliffordUnitary(4), false)
    end

    @testset "show" begin
        s = sprint(io -> show(IOContext(io), camps))
        @test occursin("QubitCAMPS", s)
    end

    @testset "get mps & clifford" begin
        @test MT.get_mps(camps) === mps
        @test MT.get_clifford_copy(camps) == C
        @test MT.get_clifford_copy(camps) !== C
    end

    @testset "apply!" begin
        c = QubitCAMPS(5)
        MT.apply_to_clifford!(c, gate, sites)
        @test MT.get_clifford_copy(c) == MT.get_clifford_copy(camps)

        c = QubitCAMPS(5)
        MT.apply_to_clifford_dagger!(c, gate, sites)
        @test MT.get_clifford_copy(c) == inv(MT.get_clifford_copy(camps))
        @test MT.get_clifford_copy(c;daggered=true) == MT.get_clifford_copy(camps)
        MT.apply_to_clifford!(c, gate, sites)
        @test MT.get_clifford_copy(c) == QubitCliffordUnitary(5)

        c = QubitCAMPS(5)
        MT.apply_to_clifford!(c, C)
        @test MT.get_clifford_copy(c) == MT.get_clifford_copy(camps)

    end

    @testset "norm, mul!" begin
        c = QubitCAMPS(5)
        @test LA.norm(c) ≈ 1.0
        LA.mul!(c, 0.5)
        @test LA.norm(c) ≈ 0.5
    end
end
