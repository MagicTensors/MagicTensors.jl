# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractPauli

Abstract supertype for qubit/qudit Pauli strings that act on a system of qubits or qudits. 

# Description
`AbstractPauli` defines an abstract interface for Pauli strings acting on qubit or qudit
systems. 

# Required methods
Implementations `ConcretePauli<:AbstractPauli` must support
- `ConcretePauli(n) -> x`: -- returns an identity Pauli string `x` on `n` sites.
- `Base.(==)(x,y) -> x==y`: -- returns `true` if the Pauli strings `x` and `y` are
    identical, `false` otherwise.
- `Base.≈(x,y) -> x≈y`: -- returns `true` if the Pauli strings `x` and `y` are the same,
    ignoring their phases, `false` otherwise.
- `Base.-(x) -> -x`: -- returns the Pauli string `-x`.
- `embed(x, m, sites) -> y`: -- returns an Pauli string on `m≥n` sites, where the Pauli on
    site `i` in `x` is put to site `site[i]` in `y`.
- `nsites(x) -> n`: -- returns the number of sites `n` the Pauli string acts on.

# Additional methods
- `Base.:*(x, y) -> x*y`: -- returns the product of two Pauli strings.

# See also
- [`QubitPauli`](@ref)
- [`embed`](@ref), [`nsites`](@ref)
"""
abstract type AbstractPauli end


# -- Base Methods --------------------------------------------------------------------------

function Base.zero(::Type{T}, n::Int) where T<:AbstractPauli
    return T(n)
end

# ------------------------------------------------------------------------------------------
