# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitPauli <: AbstractPauli

Implementation of `AbstractPauli` for qubit systems using the `QuantumClifford` package.

`QubitPauli` objects are immutable with only a single field
`pauli::QuantumClifford.PauliOperator`. 

# Constructors
- `QubitPauli(pauli::QuantumClifford.PauliOperator)`: -- return the QubitPauli for a given
    `QuantumClifford.PauliOperator`.
- `QubitPauli(n::Int)`: -- return an identity operator on `n` qubits.
- `@QubitPauli_str(s::AbstractString)`: -- macro, using the same String to Pauli conversion
    as in `QuantumClifford` (e.g. `QubitPauli"-iIXYZ").

# See also
- [`AbstractPauli`](@ref)
"""
struct QubitPauli <: AbstractPauli
    pauli::PauliOperator
end


# -- Constructors --------------------------------------------------------------------------

QubitPauli(n::Int) = QubitPauli(zero(PauliOperator,n))

macro QubitPauli_str(s::String)
    # TODO: Avoid using priviate QuantumClifford functions.
    return QubitPauli(QuantumClifford._P_str(s))
end


# -- Base Methods --------------------------------------------------------------------------

function Base.show(io::IO, x::QubitPauli)
    print(io, x.pauli)
end

Base.:(==)(x::QubitPauli, y::QubitPauli) = (x.pauli == y.pauli)

Base.:-(x::QubitPauli) = QubitPauli(-x.pauli)

Base.:≈(x::QubitPauli, y::QubitPauli) = (x.pauli.xz == y.pauli.xz)


# -- Interface Methods ---------------------------------------------------------------------

function embed(p::QubitPauli, n::Int, sites::AbstractVector{<:Int})
    x = fill(false, n)
    z = fill(false, n)
    phase = p.pauli.phase[]
    for i in 1:length(sites)
        x[sites[i]] = p.pauli[i][1]
        z[sites[i]] = p.pauli[i][2]
    end
    return QubitPauli(PauliOperator(phase, x, z))
end

nsites(x::QubitPauli) = QuantumClifford.nqubits(x.pauli)


# -- Extensions ----------------------------------------------------------------------------

QuantumClifford.PauliOperator(x::QubitPauli) = x.pauli

# ------------------------------------------------------------------------------------------
