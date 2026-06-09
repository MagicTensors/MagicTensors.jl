
@testset "QubitCliffordGateSet" begin
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
    end

    @testset "Two Qubit Gate Set :all" begin
        set = QubitCliffordGateSet(2,:all)
        @test nsites(set) == 2
        @test length(set) == 720
        @test set[1] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"XI IZ ZI IX")))
        @test set[42] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"ZZ XX IX ZI")))
        @test set[719] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"ZY XZ ZX ZI")))
        @test set[720] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"YY XZ YX YI")))
    end

    @testset "Three Qubit Gate Set :all" begin
        set = QubitCliffordGateSet(3,:all)
        @test nsites(set) == 3
        @test length(set) == 1451520
        @test set[1] == QubitCliffordGate(QC.CliffordOperator(
            QC.tab(QC.S"XII IIZ IZI ZII IIX IXI")))
    end

    @testset "Two Qubit Gate Set :full" begin
        set = QubitCliffordGateSet(2,:full)
        @test nsites(set) == 2
        @test length(set) == 11520
        @test set[1] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"XI IZ ZI IX")))
        @test set[6] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"-XI IZ -ZI IX")))
        @test set[11520] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"-YY -XZ -YX -YI")))
    end

    @testset "Two Qubit Gate Set :entangle" begin
        set = QubitCliffordGateSet(2,:entangle)
        @test nsites(set) == 2
        @test length(set) == 19
        @test set[1] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"IX XI IZ ZI")))
        @test set[19] == QubitCliffordGate(
            QC.CliffordOperator(QC.tab(QC.S"ZZ YX ZY XX")))
    end
end
