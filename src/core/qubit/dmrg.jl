
const DEFAULT_QUBIT_DMRG_DISENTANGLER = IterativeDmrgDisentangler(
    GreedySweepDisentangler(QubitCliffordGateSet(2,:entangle); cutoff=1e-12),
    32;
    min_energy_gain=1e-10,
    warn_max_iter=true)

function dmrg!(camps::QubitCAMPS, H::AbstractPauliSum; kwargs...)
    return dmrg!(DEFAULT_QUBIT_DMRG_DISENTANGLER, camps, H; kwargs...)
end
