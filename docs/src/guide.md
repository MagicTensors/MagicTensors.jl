# MagicTensors' User Guide

The following user guide is only an outline of the types and functions of the
`MagicTensors` package.

`TODO: Write user guide introduction.`

## Installation

The MagicTensors package is not yet available through the Julia package system. It can,
however be added to the current Julia environment using the url of the git repository.

```julia
julia> using Pkg
julia> Pkg.add(url="https://github.com/MagicTensors/MagicTensors.jl")
```

!!! info
    MagicTensors is continousely tested against the current stabil Julia 1 version.
    Using [`juliaup`](https://github.com/JuliaLang/juliaup) this is available through the 
    channel `julia +1`.


## Pauli Strings

- [`QubitPauli`](@ref) (see also: [`AbstractPauli`](@ref)):
  Pauli strings, including the ±1 ±i prefactor.
- [`QubitPauliSum`](@ref) (see also: [`AbstractPauliSum`](@ref)):
  An unordered weighted sum of Pauli strings.
- [`embed`](@ref): Function that expands a Pauli string to more qubits by padding it with 
  identities.
- [`nsites`](@ref): Returns the number of qubits (i.e. length of the Pauli string).

`TODO: Write user guide Pauli string section.`


## Cliffords

- [`QubitCliffordUnitary`](@ref) (see also: [`AbstractCliffordUnitary`](@ref)): TODO
- [`QubitCliffordGate`](@ref) (see also: [`AbstractCliffordGate`](@ref))
- [`QubitCliffordGateSet`](@ref) (see also: [`AbstractCliffordGateSet`](@ref))
- [`apply!`](@ref)
- [`nsites`](@ref)
- [`conjugate`](@ref)

`TODO: Write user guide Cliffords section.`


## MPS

- [`apply!`](@ref)
- [`entanglement_entropy`](@ref)
- [`stabilizer_entropy`](@ref)
- [`expectation`](@ref)
- [`nsites`](@ref)

`TODO: Write user guide MPS section.`


## CAMPS

- [`QubitCAMPS`](@ref) (see also: [`AbstractCAMPS`](@ref))
- [`apply!`](@ref)
- [`apply_and_disentangle!`](@ref)
- [`apply_to_clifford!`](@ref)
- [`apply_to_clifford_dagger!`](@ref)
- [`apply_to_mps!`](@ref)
- [`get_clifford_copy`](@ref)
- [`get_mps`](@ref)
- [`nsites`](@ref)
- [`disentangle!`](@ref)
- [`expectation`](@ref)
- [`transform!`](@ref)
- [`stabilizer_entropy`](@ref)

`TODO: Write user guide CAMPS section.`


`TODO: Write user guide CAMPS section.`

## DMRG

- [`dmrg!`](@ref)

`TODO: Write user guide DMRG section.`


## Disentanglers

- [`AbstractDisentangler`](@ref) 
  - [`AbstractStandAloneDisentangler`](@ref)
    - [`TrivialDisentangler`](@ref)
    - [`IterativeDisentangler`](@ref)
    - [`SweepDisentangler `](@ref)
  - [`AbstractLocalDisentangler`](@ref)
      - [`GreedyDisentangler`](@ref)
  - [`AbstractDmrgDisentangler`](@ref)
    - [`IterativeDmrgDisentangler`](@ref)

`TODO: Write user guide Disentanglers section.`
