# MagicTensors' Core Package

`TODO`

## Qubit Types
- [`QubitPauli`](@ref) (see also: [`AbstractPauli`](@ref))
- [`QubitPauliSum`](@ref) (see also: [`AbstractPauliSum`](@ref))
- [`QubitCliffordUnitary`](@ref) (see also: [`AbstractCliffordUnitary`](@ref))
- [`QubitCliffordGate`](@ref) (see also: [`AbstractCliffordGate`](@ref))
- [`QubitCliffordGateSet`](@ref) (see also: [`AbstractCliffordGateSet`](@ref))
- [`QubitCAMPS`](@ref) (see also: [`AbstractCAMPS`](@ref))

## Disentanglers
- [`AbstractDisentangler`](@ref) 
  - [`AbstractStandAloneDisentangler`](@ref)
    - [`TrivialDisentangler`](@ref)
    - [`IterativeDisentangler`](@ref)
    - [`AbstractSweepDisentangler `](@ref)
      - [`GreedySweepDisentangler`](@ref)
  
## Functions
- [`apply!`](@ref)
- [`apply_and_disentangle!`](@ref)
- [`apply_to_clifford!`](@ref)
- [`apply_to_clifford_dagger!`](@ref)
- [`apply_to_mps!`](@ref)
- [`conjugate`](@ref)
- [`disentangle!`](@ref)
- [`embed`](@ref)
- [`entanglement_entropy`](@ref)
- [`expectation`](@ref)
- [`get_clifford_copy`](@ref)
- [`get_mps`](@ref)
- [`nsites`](@ref)
- [`stabilizer_entropy`](@ref)
- [`transform!`](@ref)
