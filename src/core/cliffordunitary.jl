# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractCliffordUnitary 

Abstract supertype for Clifford unitaries.

# Description
`AbstractCliffordUnitary` defines an abstract interface for Clifford unitaries that operate
on qubits, qudits, or potentially other quantum systems. Clifford unitaries map Pauli
strings (`AbstractPauli`) to Pauli strings under conjugation. Implementations of 
`AbstractCliffordUnitary` should function even for a large system sizes by employing the
stabilizer formalism.

# Required methods
For a Clifford unitarys `C` and `D`, and compatible Pauli `P` (each acting on `n` sites)
implementations must support:
- `ConcreteCliffordUnitary(n) -> Iₙ`: -- constructor for the identity unitary as a Clifford unitary, where `ConcreteCliffordUnitary<:AbstractCliffordUnitary`. 
- `Base.(==)(x,y) -> x==y`: -- returns `true` if the Pauli strings `x` and `y` are
    identical, `false` otherwise.
- `Base.:*(C, D) -> C D`: -- returns the product `C D` of Clifford unitaries `C` and `D`.
- `Base.inv(C) -> C⁻¹`: -- returns the inverse of `C`.
- `apply!(D, C)`: -- applies `C` to `D` in-place, i.e. subsitutes `D → C D`.
- `conjugate(P, C) -> Q`: -- returns a Pauli `Q = C P C†` with the same type as `P`.
- `nsites(C) -> n`: -- returns the number of sites `n`.

# See also
- [`AbstractPauli`](@ref), [`QubitCliffordUnitary`](@ref)
- [`conjugate`](@ref), [`nsites`](@ref)
"""
abstract type AbstractCliffordUnitary end


# -- Base Methods --------------------------------------------------------------------------

function Base.one(::Type{T}, n::Int) where T<:AbstractCliffordUnitary
    return T(n)
end


# -- Interface Methods ---------------------------------------------------------------------

function conjugate(P::AbstractPauliSum, C::AbstractCliffordUnitary)
    Q = zero(typeof(P),nsites(P))
    for (pauli,coeff) in P
        push!(Q, conjugate(pauli,C), coeff)
    end
    return Q
end

# ------------------------------------------------------------------------------------------
