# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractPauliSum

Abstract supertype for weighted unordered lists of Pauli strings.

# Description
`AbstractPauliSum` defines an abstract interface for weighted unordered lists of Pauli
strings. A Pauli sum `x` represents the sum over `K` Pauli strings `Pᵢ` weighted by `αᵢ`,
i.e. `x` = ∑ `αᵢ Pᵢ`.

# Required methods
Concrete implimentations `ConcretePauliSum<:AbstractPauliSum` must support:
- `ConcretPauliSum(n)`: -- constructor returning and empty (`K=0`) Pauli sum on `n` sites.
- `Base.length(x) -> K`: -- returns the number of Pauli strings `K` in the sum.    
- `Base.push!(x, P, α)`: -- adds a Pauli string `P` with the given coefficient `α` to
    the sum.
- `Base.isapprox(x,y; kwargs...) -> x≈y`: -- returns `true` if the Pauli strings `x` and `y`
    are approximately equal (with `kwargs...` piped into the scalar `isapprox` function);
    `false` otherwise.
- `Base.(==)(x,y) -> x==y`: -- returns `true` if the Pauli sums `x` and `y` are equal,
    `false` otherwise.
- `embed(x, m, sites) -> y`: -- returns an Pauli sum on `m≥n` sites, where each Pauli on
    site `i` in `x` is put to site `site[i]` in `y`.  
- `nsites(x) -> n`: -- returns the number `n` of qubits/qudits on which the Pauli strings in
    the sum act.
 - `ITensorMPS.MPO(x, sites) -> mpo`: -- returns the Pauli sum as an ITensorMPS.MPO on the
    site indices `sites`.  

# Additional methods
For Pauli sums `x`, `y`, and scalar `α` it may be necessary for some applications to also
implement the following methods:
- Simple arithmethic: `-x`, `x+y`, `x-y`, `α*x`, and `x/α`, where `x` and `y` may also be
    plain `QubitPauli` objects.
- `Base.:*(x, y) -> x*y`: -- returns the product of two Pauli sums.
- `LinearAlgebra.adjoint(x) -> x†`: -- returns the adjoint of the Pauli sum.
- `LinearAlgebra.conj(x) -> x̅`: -- returns the complex conjugate of the Pauli sum.
- `LinearAlgebra.transpose(x) -> xᵀ`: -- returns the transpose of the Pauli sum.
- `LinearAlgebra.ishermitian(x)`: -- returns `true` if the Pauli sum is Hermitian, and
    `false` otherwise.

# See also
- [`QubitPauliSum`](@ref)
- [`embed`](@ref), [`nsites`](@ref)
"""
abstract type AbstractPauliSum end


# -- Base Methods --------------------------------------------------------------------------

function Base.show(io::IO, x::AbstractPauliSum)
    limited = get(io, :limit, false)
    cut = get(io, :cut, 32)

    count = 0 
    print(io, typeof(x), " on ", nsites(x), " sites, with ", length(x), " terms:")
    for (pauli, coeff) in x
        count += 1
        if limited && count==cut+1
            print(io, "\n ⋮ \n")
            break
        end
        @printf(io, "\n(%+4e %+4eim) ", real(coeff), imag(coeff))
        print(io, pauli)
    end
    return nothing
end

function Base.zero(::Type{T}, n::Int) where T<:AbstractPauliSum
    return T(n)
end

function Base.push!(
    x::AbstractPauliSum,
    y::Union{AbstractPauli,AbstractPauliSum},
    sites::AbstractVector{<:Int},
    args...;
    kwargs...)
    return push!(x, embed(y,nsites(x),sites), args...; kwargs...)
end

# ------------------------------------------------------------------------------------------
