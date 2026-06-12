@testset "Dmrg" begin
    @testset "dmrg!" begin
        h = QubitPauli"-XX" + QubitPauli"-ZZ" + QubitPauli"XI"

        camps = QubitCAMPS(2)
        energy, (num, gain, info) = dmrg!(camps, h; nsweeps=1, cutoff=1e-12, outputlevel=0)
        @test energy ≈ -(1+√(2))
        @test gain ≈ 0.6033545263082

        camps = QubitCAMPS(2)
        disentangler = IterativeDmrgDisentangler(
            GreedySweepDisentangler(QubitCliffordGateSet(2,:entangle); cutoff=1e-12),
            1;
            min_energy_gain=1e-10,
            warn_max_iter=true)
        
        @test_logs (:warn,) begin
            energy, (num, gain, info) = 
                dmrg!(disentangler, camps, h; nsweeps=1, cutoff=1e-12, outputlevel=0)
        end 
    end
end
