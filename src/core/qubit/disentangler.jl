const DEFAULT_QUBIT_DISENTANGLER = 
    GreedySweepDisentangler(QubitCliffordGateSet(2,:entangle); cutoff=1e-12)

function disentangle!(camps::QubitCAMPS, args...; kwargs...)
    return disentangle!(DEFAULT_QUBIT_DISENTANGLER, camps, args...; kwargs...)
end
