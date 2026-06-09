@testset "QubitCliffordGate" begin
    using QuantumClifford: ⊗

    CNOT_TIMES_H_S_MATRIX = [
        1.0+0.0im  0.0+0.0im   1.0+0.0im  0.0+0.0im
        0.0+0.0im  0.0+1.0im   0.0+0.0im  0.0+1.0im
        0.0+0.0im  0.0+1.0im   0.0+0.0im  0.0-1.0im
        1.0+0.0im  0.0+0.0im  -1.0+0.0im  0.0+0.0im
    ] ./ sqrt(2)
    CNOT_TIMES_H_S_TABLEAU =
        QC.CliffordOperator(QC.tab(QC.S"ZI ZY XX ZZ"))

    @testset "show" begin
        a = QubitCliffordGate(QC.tCNOT)
        s = sprint(io -> show(IOContext(io), a))
        @test occursin("QubitCliffordGate", s)
    end
    
    @testset "two qubit clifford gate" begin
        gate = QubitCliffordGate(QC.apply!(QC.tHadamard⊗QC.tPhase,QC.tCNOT))
        @test nsites(gate) == 2
        @test QC.CliffordOperator(gate) == CNOT_TIMES_H_S_TABLEAU
        @test gate == QubitCliffordGate(CNOT_TIMES_H_S_TABLEAU)
        @test Matrix(gate) ≈ CNOT_TIMES_H_S_MATRIX
    end

    @testset "apply!" begin
        x = QubitCliffordUnitary(3)
        start = QubitCliffordUnitary(QC.tId1 ⊗ QC.tCNOT)
        res = QubitCliffordUnitary(QC.tCNOT ⊗ QC.tId1)
        g = QubitCliffordGate(QC.tSWAP)
        a = apply!(x, g, [2,3])
        b = apply!(x, g, [1,2])
        c = apply!(x, start)
        d = apply!(x, g, [1,2])
        e = apply!(x, g, [2,3])
        @test x == res
        @test a === x
        @test e === x
    end
end
