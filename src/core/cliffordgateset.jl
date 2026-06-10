# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractCliffordGateSet

Abstract supertype for a list of `AbstractCliffordGate` objects.

# Description
`AbstractCliffordGateSet` defines an abstract interface for an iterable and enumerated list
of Clifford gates (each acting on the same number of sites). Clifford gate sets are useful,
for example, for brute force searches for disentangling Clifford circuits.

# Required methods
For a Clifford gate set `x` implementations must support:
- `Base.getindex(x, i) -> gᵢ`: -- returns the `i`th Clifford gate `gᵢ` in the set `x`.
- `Base.length(x) -> K`: -- returns the number of gates `K` in the set `x`.
- `Base.one(x) -> I`: -- return the identity gate w.r.t. set `x`; the identity `I` need not
    be in `x`.
- `nsites(x) -> n`: -- returns the number of sites `n` on which the gates in the set act.

# See also
- [`AbstractCliffordGate`](@ref), [`QubitCliffordGateSet`](@ref)
- [`nsites`](@ref)
"""
abstract type AbstractCliffordGateSet end

# -- Base Methods --------------------------------------------------------------------------

function Base.iterate(gs::AbstractCliffordGateSet)
    if length(gs) == 0
        return nothing
    else 
        return (gs[1], 2)
    end
end

function Base.iterate(gs::AbstractCliffordGateSet, state)
    state > length(gs) && return nothing
    return (gs[state], state + 1)
end

# ------------------------------------------------------------------------------------------
