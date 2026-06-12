@testset "Disentangler" begin
    # create a CAMPS = |000000⟩
    # with an MPS with two Bell pairs between 1-6, 2-5, and 3-4
    # (i.e. a rainbow state)
    camps = QubitCAMPS(6)
    transform!(camps, QubitCliffordGate(QC.tHadamard), [1])
    transform!(camps, QubitCliffordGate(QC.tCNOT), [1,2])
    transform!(camps, QubitCliffordGate(QC.tHadamard), [3])
    transform!(camps, QubitCliffordGate(QC.tCNOT), [3,4])
    transform!(camps, QubitCliffordGate(QC.tHadamard), [5])
    transform!(camps, QubitCliffordGate(QC.tCNOT), [5,6])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [2,3])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [3,4])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [4,5])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [5,6])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [3,4])
    transform!(camps, QubitCliffordGate(QC.tSWAP), [4,5])
    
    @testset "TrivialDisentangler" begin
        a = deepcopy(camps)
        res = disentangle!(a, TrivialDisentangler())
        @test length(res) == 3
        @test res[1] == 0
        @test res[2] == 0.0
    end

    @testset "GreedySweepDisentangler" begin
        a = deepcopy(camps)
        res = disentangle!(
            a,
            GreedySweepDisentangler(QubitCliffordGateSet(2,:entangle); cutoff=1e-12))
        @test length(res) == 3
        @test res[1] == 6
        @test res[2] ≈ 6.0

        @test begin
            expectation(a,QubitPauli"ZIIIII") ≈ 1 &&
            expectation(a,QubitPauli"IZIIII") ≈ 1 &&
            expectation(a,QubitPauli"IIZIII") ≈ 1 &&
            expectation(a,QubitPauli"IIIZII") ≈ 1 &&
            expectation(a,QubitPauli"IIIIZI") ≈ 1 &&
            expectation(a,QubitPauli"IIIIIZ") ≈ 1 
        end
    end

    @testset "IterativeDisentangler" begin
        a = deepcopy(camps)
        greedy_disentangler = GreedySweepDisentangler(
            QubitCliffordGateSet(2,:entangle); cutoff=1e-12)
        iter_disentangler = IterativeDisentangler(greedy_disentangler, 10)
        res = disentangle!(a, iter_disentangler)
        @test length(res) == 3
        @test res[1] == 9
        @test res[2] ≈ 9.0

        @test begin
            expectation(a,QubitPauli"ZIIIII") ≈ 1 &&
            expectation(a,QubitPauli"IZIIII") ≈ 1 &&
            expectation(a,QubitPauli"IIZIII") ≈ 1 &&
            expectation(a,QubitPauli"IIIZII") ≈ 1 &&
            expectation(a,QubitPauli"IIIIZI") ≈ 1 &&
            expectation(a,QubitPauli"IIIIIZ") ≈ 1 
        end
    end

    @testset "apply_and_disentangle!" begin
        a = deepcopy(camps)
        res = apply_and_disentangle!(TrivialDisentangler(), a, QubitPauli"X",[1])
        @test length(res) == 3
        @test res[1] == 0
        @test res[2] == 0.0
        @test expectation(a,QubitPauli"ZIIIII") ≈ -1
    end

end

