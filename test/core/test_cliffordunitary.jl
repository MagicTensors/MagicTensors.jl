@testset "AbstractCliffordUnitary" begin
    @testset "Base.one()" begin
        a = one(QubitCliffordUnitary, 7)
        @test isa(a, AbstractCliffordUnitary)
        @test nsites(a) == 7
    end

    @testset "conjugate" begin
        ps = QubitPauliSum([QubitPauli"XI", QubitPauli"ZI"],[0.2, 0.3im])
        C = QubitCliffordUnitary(QC.tCNOT)
        qs = QubitPauliSum([QubitPauli"XX", QubitPauli"ZI"],[0.2, 0.3im])
        @test conjugate(ps,C) == qs
    end

end
