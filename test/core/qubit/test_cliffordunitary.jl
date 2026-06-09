@testset "QubitCliffordUnitary" begin
    @testset "Constructors" begin
        a = QubitCliffordUnitary(5)
        @test isa(a, QubitCliffordUnitary)
        @test nsites(a) == 5

        b = QubitCliffordUnitary(QC.tCNOT)
        @test isa(b, QubitCliffordUnitary)
        @test nsites(b) == 2
    end

    @testset "show" begin
        a = QubitCliffordUnitary(QC.tCNOT)
        s = sprint(io -> show(IOContext(io), a))
        @test occursin("QubitCliffordUnitary", s)
    end
    
    @testset "arithmetic" begin
        a = QubitCliffordUnitary(QC.tCNOT)
        b = QubitCliffordUnitary(QC.tSWAP)
        c = QubitCliffordUnitary(QC.tCNOT*QC.tSWAP)
        @test !(a==b)
        @test a*b == c
        @test b*a != c
    end

    @testset "inv" begin
        a = QubitCliffordUnitary(QC.tPhase)
        @test inv(a) * a == QubitCliffordUnitary(1)
    end

    @testset "apply!" begin
        x = QubitCliffordUnitary(QC.tSWAP)
        a = QubitCliffordUnitary(QC.tCNOT)
        res = QubitCliffordUnitary(QC.tCNOT*QC.tSWAP)
        c = apply!(x, a)
        @test x == res
        @test c === x
    end

    @testset "conjugate" begin
        C = QubitCliffordUnitary(QC.tCNOT)
        p1 = QubitPauli"XI"
        q1 = QubitPauli"XX"
        @test conjugate(p1,C) == q1

        p2 = QubitPauli"IZ"
        q2 = QubitPauli"ZZ"
        @test conjugate(p2,C) == q2
    end

    @testset "QuantumClifford.CliffordOperator" begin
        C = QubitCliffordUnitary(QC.tCNOT)
        @test QC.CliffordOperator(C) == QC.tCNOT
    end
end
