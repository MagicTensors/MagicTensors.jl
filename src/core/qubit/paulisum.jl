# -- Constants -----------------------------------------------------------------------------

const QUBIT_PAULI_SUM_SCALAR_TYPE_DEFAULT = ComplexF64
const QUBIT_PAULI_SUM_SCALAR_TYPE = Ref(QUBIT_PAULI_SUM_SCALAR_TYPE_DEFAULT)

set_qubit_pauli_sum_scalar_type!(type) =
    (QUBIT_PAULI_SUM_SCALAR_TYPE[] = type)
set_qubit_pauli_sum_scalar_type!() =
    set_qubit_pauli_sum_scalar_type!(QUBIT_PAULI_SUM_SCALAR_TYPE_DEFAULT)

# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitPauliSum <: AbstractPauliSum

Implementation of `AbstractPauliSum` for qubit systems using the `QuantumClifford` package.

# Constructors
- `QubitPauliSum(n::Int)`: -- return an empty (complex) sum for a given number of qubits
    `n`.
- `QubitPauliSum(pauli::QubitPauli)`: -- return a `QubitPauliSum` with only a single Pauli 
    string.
- `QubitPauliSum(paulis::Vector{<:QubitPauli}, coeffs::Vector{<:Number})`: -- return a
    the sum of `QubitPauli`s `pauli` with coefficients `coeffs`.

# Examples
- Basic `QubitPauliSum` constructors and operations:
```julia
julia> QubitPauliSum(3)
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 0 terms:

julia> QubitPauliSum(QubitPauli"XXI")
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 1 terms:
(+1.000000e+00 +0.000000e+00im) + XX_

julia> x = QubitPauliSum([QubitPauli(3), QubitPauli"XXI"], [0.5, -0.5])
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 2 terms:
(+5.000000e-01 +0.000000e+00im) + ___
(-5.000000e-01 +0.000000e+00im) + XX_

julia> embed(x,5,[1,3,5])
QubitPauliSum{ComplexF64, Vector{UInt64}} on 5 sites, with 2 terms:
(+5.000000e-01 +0.000000e+00im) + _____
(-5.000000e-01 +0.000000e+00im) + X_X__

julia> nsites(x)
3

julia> length(x)
2
```

- Arithmetic
```julia
julia> x = 0.5 *(QubitPauli(3) + QubitPauli"XXI")
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 2 terms:
(+5.000000e-01 +0.000000e+00im) + ___
(+5.000000e-01 +0.000000e+00im) + XX_

julia> push!(x, QubitPauli"IIZ", 0.1im)
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 3 terms:
(+5.000000e-01 +0.000000e+00im) + ___
(+0.000000e+00 +1.000000e-01im) + __Z
(+5.000000e-01 +0.000000e+00im) + XX_

julia> x = x + 0.3*QubitPauli"IIZ"
QubitPauliSum{ComplexF64, Vector{UInt64}} on 3 sites, with 3 terms:
(+5.000000e-01 +0.000000e+00im) + ___
(+3.000000e-01 +1.000000e-01im) + __Z
(+5.000000e-01 +0.000000e+00im) + XX_

julia> 2*x-QubitPauli(3) ≈ (0.6+0.2im)*QubitPauli"IIZ" + QubitPauli"XXI"
true
```

- Convert to `ITensorMPS.OpSum`:
```julia
julia> using ITensorMPS: OpSum

julia> OpSum((0.6+0.2im)*QubitPauli"IIZ" + QubitPauli"XXI")
sum(
  0.6 + 0.2im Z(3,)
  1.0 X(1,) X(2,)
)
```

# See also
- [`AbstractPauli`](@ref), [`AbstractPauliSum`](@ref), [`QubitPauli`](@ref)
- [`embed`](@ref), [`nsites`](@ref)
"""
mutable struct QubitPauliSum{Tₛ<:Number,Tₚ<:AbstractVector{<:Unsigned}} <: AbstractPauliSum
    nsites::Int
    paulis::Dict{Tₚ,Tₛ}
end


# -- Constructors --------------------------------------------------------------------------

function QubitPauliSum{Tₛ,Tₚ}(n::Int) where 
    {Tₛ<:Number, Tₚ<:AbstractVector{<:Unsigned}}
    return QubitPauliSum{Tₛ,Tₚ}(n, Dict{Tₚ,Tₛ}())
end


function QubitPauliSum(n::Int)
    Tₛ = QUBIT_PAULI_SUM_SCALAR_TYPE[]
    Tₚ = typeof(zero(PauliOperator, n).xz)
    return QubitPauliSum{Tₛ,Tₚ}(n)
end

function QubitPauliSum(paulis::Vector{<:QubitPauli}, coeffs::Vector{<:Number})
    ps = QubitPauliSum(nsites(paulis[1]))
    for (coeff, pauli) in zip(coeffs, paulis)
        push!(ps, pauli, coeff)
    end
    return ps
end

QubitPauliSum(pauli::QubitPauli) = QubitPauliSum([pauli],[1])


# -- Base Methods --------------------------------------------------------------------------

function Base.iterate(x::QubitPauliSum, state...)
    next = iterate(x.paulis, state...)
    next === nothing && return nothing

    pair, newstate = next
    key, coeff = pair
    pauli = QubitPauli(PauliOperator(0x00, nsites(x), key))
    return ((pauli, coeff), newstate)
end

Base.length(x::QubitPauliSum) = length(x.paulis)

function Base.push!(x::QubitPauliSum, P::QubitPauli, α::Number)
    @assert nsites(P) == nsites(x)

    p = PauliOperator(P)
    xz = p.xz
    coeff = α * _phase_to_number(p.phase[1])
    if haskey(x.paulis, xz)
        x.paulis[xz] += coeff
    else
        x.paulis[xz] = coeff
    end
    return x
end

Base.push!(x::QubitPauliSum, P::QubitPauli) = push!(x, P, 1)

function Base.:(==)(x::QubitPauliSum, y::QubitPauliSum) 
    if nsites(x) != nsites(y) return false end
    return x.paulis == y.paulis
end

Base.:(==)(x::QubitPauli, y::QubitPauliSum) = (QubitPauliSum(x) == y)
Base.:(==)(x::QubitPauliSum, y::QubitPauli) = (x == QubitPauliSum(y))

function Base.isapprox(x::QubitPauliSum, y::QubitPauliSum; kwargs...) 
    if x === y return true end
    if isa(y,IdDict) != isa(x,IdDict) return false end
    if nsites(x) != nsites(y) return false end
    for (key, val) in x.paulis
        if !haskey(y.paulis, key)
            if !(isapprox(val, 0; kwargs...)) return false end
        elseif !(isapprox(y.paulis[key],val;kwargs...))
            return false
        end
    end
    for (key, val) in y.paulis
        if !haskey(x.paulis, key)
            if !(isapprox(val, 0; kwargs...)) return false end
        end
    end
    return true
end

Base.:≈(x::QubitPauliSum, y::QubitPauli) = x ≈ QubitPauliSum(y)
Base.:≈(x::QubitPauli, y::QubitPauliSum) = QubitPauliSum(x) ≈ y

function Base.:-(x::QubitPauliSum)
    res = deepcopy(x)
    for (xz, coeff) in res.paulis
        res.paulis[xz] = -coeff
    end
    return res
end

function Base.:+(x::QubitPauliSum, y::QubitPauliSum)
    if length(x) < length(y) x,y = y,x end
    res = deepcopy(x)
    for (pauli, coeff) in y
        push!(res, pauli, coeff)
    end
    return res
end

Base.:+(x::QubitPauliSum, y::QubitPauli) = x + QubitPauliSum(y)
Base.:+(x::QubitPauli, y::QubitPauliSum) = QubitPauliSum(x) + y
Base.:+(x::QubitPauli, y::QubitPauli) = QubitPauliSum(x) + QubitPauliSum(y)

Base.:-(x::Union{QubitPauli,QubitPauliSum}, y::Union{QubitPauli,QubitPauliSum}) = x + (-y)

function Base.:*(α::Number, x::QubitPauliSum)
    res = deepcopy(x)
    for (xz, coeff) in res.paulis
        res.paulis[xz] = α*coeff
    end
    return res
end

Base.:*(x::QubitPauliSum, α::Number) = α*x
Base.:*(α::Number, x::QubitPauli) = α*QubitPauliSum(x)
Base.:*(x::QubitPauli, α::Number) = α*QubitPauliSum(x)

Base.:/(x::QubitPauliSum, α::Number) = (1/α)*x
Base.:/(x::QubitPauli, α::Number) = (1/α)*QubitPauliSum(x)


# -- Interface Methods ---------------------------------------------------------------------

function embed(x::QubitPauliSum, n::Int, sites::AbstractVector{<:Int})
    res = QubitPauliSum(n)
    for (pauli, coeff) in x
        push!(res, embed(pauli, n, sites), coeff)
    end
    return res
end

nsites(x::QubitPauliSum) = x.nsites

function ITensorMPS.OpSum(ps::QubitPauliSum)
    ops = ITensorMPS.OpSum()
    opNames = ["I", "X", "Y", "Z"]
    N = nsites(ps)

    for (xz, coeff) in ps.paulis
        pauli = PauliOperator(0x00, N, xz)
        l = Any[]
        push!(l, coeff)
        for n in 1:N
            num = _int_from_xz(pauli[n]...)
            if num > 0
                push!(l, opNames[num+1])
                push!(l, n)
            end
        end
        if length(l) < 3
            push!(l, opNames[1])
            push!(l, 1)
        end
        ITensorMPS.add!(ops, l...)
    end
    return ops
end


# -- Private Functions ---------------------------------------------------------------------

function _phase_to_number(phase::UInt8)
    phase == 0x00 && return  1.0
    phase == 0x01 && return  0.0 + 1.0im
    phase == 0x02 && return  -1.0
    phase == 0x03 && return  0.0 - 1.0im
end

function _int_from_xz(x::Bool, z::Bool)
    i = nothing
    if !x && !z
        i = 0
    elseif x && !z
        i = 1
    elseif x && z
        i = 2
    elseif !x && z
        i = 3
    end
    return i
end

# ------------------------------------------------------------------------------------------
