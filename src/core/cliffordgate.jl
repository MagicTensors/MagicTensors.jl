# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractCliffordGate

Abstract supertype for few-qubit/qudit Clifford gates that can act both within the
stabilizer formalism and as explicit unitary matrices in the computational basis.

# Description
`AbstractCliffordGate` defines an abstract interface for Clifford gates that act on a few
qubit or qudit systems. While Clifford gates are in principle Clifford unitaries, they are
not a subtype of `AbstractCliffordUnitary` because they fulfil a different role in the logic
of the `MagicTensors` package. `AbstractCliffordGate` objects constitute the bridge between
tensor networks and the stabilizer formalism because they can act on a Clifford unitary
(stabilizer formalism) and they can return their explicit unitary matrix for use in tensor
networks. In practice, the latter restricts the employability of `AbstractCliffordGate`
objects to only a few sites.

# Required methods
For a Clifford gates `x`, `y` and compatible Clifford unitary `C`, implementations must
support:
- `Base.:(==)(x,y) -> x==y`: -- returns `true` if the gates `x` and `y` are identical,
    `false` otherwise.
- `Base.Matrix(x) -> M`: -- returns the gate `x` in the form of an explicit complex
    matrix `M`.
- `apply!(C, x, sites) -> C'`: -- applies gate `x` to `C` at sites `sites` in-place, i.e.
    it replaces C → x C.
- `nsites(x) -> n`: -- returns the number `n` of qubits on which the gate `x` acts.

# Notes
Types that implement this interface should be immutable.

# See also
- [`QubitCliffordGate`](@ref)
- [`apply!`](@ref), [`nsites`](@ref) 
"""
abstract type AbstractCliffordGate end

# ------------------------------------------------------------------------------------------
