# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractCAMPS

Interface for Clifford Augmented Matrix Product States (CAMPS).

# Description
`AbstractCAMPS` defines an supertype for Clifford Augmented Matrix Product States (CAMPS).
A CAMPS is a ansatz for a pure quantum state of the form `|ψ⟩ = C |MPS⟩`, where `C` is a
Clifford unitary, and `|MPS⟩` is a matrix product state [TODO]. 

# Required methods
For a CAMPS `x` implementations must support:
- `apply_to_mps!(x, args...; kwargs...)`: -- applies `args...`, with `kwargs...` to the MPS part of the CAMPS.
- `apply_to_clifford!(x, args...; kwargs...`: -- applies `args...`, with `kwargs...` to the Clifford part C of the CAMPS.
- `apply_to_clifford_dagger!(x, args...; kwargs...`: -- applies `args...`, with `kwargs...` to the daggered Clifford part C† of the CAMPS.
- `get_clifford(x)`: -- returns (by reference) the Clifford unitary `C`, which should be of
    the type `<:AbstractCliffordUnitary`.
- `get_clifford_copy(x)`: -- returns a copy of the Clifford unitary `C`, which should be of
    the type `<:AbstractCliffordUnitary`.
- `get_mps(x)`: -- returns (by reference) the matrix product state part of the CAMPS as an
    `ITensorMPS.MPS` object.

# References
1. TODO

# See also
- [`QubitCAMPS`](@ref), [`AbstractCliffordUnitary`](@ref)
- [`apply!`](@ref), [`apply_to_clifford!`](@ref), [`apply_to_clifford_dagger!`](@ref), [`apply_to_mps!`](@ref), [`get_clifford`](@ref), [`get_clifford_copy`](@ref), [`get_mps`](@ref)

"""
abstract type AbstractCAMPS end


# -- Interface Methods ---------------------------------------------------------------------

function apply!(camps::AbstractCAMPS, V::AbstractCliffordGate, sites::AbstractVector{<:Int})
    apply_to_clifford!(camps, V, sites)
    return camps
end

function apply!(camps::AbstractCAMPS, U::AbstractCliffordUnitary)
    apply_to_clifford!(camps, U)
    return camps
end

function apply!(camps::AbstractCAMPS, x::AbstractPauliSum; kwargs...)
    x_conj = conjugate(x, get_clifford(camps; daggered=true))
    apply_to_mps!(camps, x_conj; kwargs...)
    return camps
end

apply!(camps::AbstractCAMPS, x::AbstractPauli; kwargs...) = apply!(camps, 1*x)

function expectation(camps::AbstractCAMPS, x::AbstractPauliSum; normalized=false)
    x_conj = conjugate(x, get_clifford(camps; daggered=true))
    mps = get_mps(camps)
    return expectation(mps, x_conj; normalized)
end

expectation(camps::AbstractCAMPS, x::AbstractPauli; normalized=false) =
    expectation(camps, 1*x; normalized)

LinearAlgebra.norm(camps::AbstractCAMPS) = LinearAlgebra.norm(get_mps(camps))

nsites(camps::AbstractCAMPS) = nsites(get_mps(camps))

stabilizer_entropy(camps::AbstractCAMPS, args...; kwargs...) = 
    stabilizer_entropy(get_mps(camps), args...; kwargs...)

function transform!(camps::AbstractCAMPS, gate::AbstractCliffordGate,
    sites::AbstractVector{<:Int}; kwargs...)
    
    mps = get_mps(camps)
    apply!(mps, gate, sites; kwargs...)
    apply_to_clifford_dagger!(camps, gate, sites)
    return camps
end

# ------------------------------------------------------------------------------------------
