# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitCliffordGateSet{K, S} <: AbstractCliffordGateSet

Implementation of `AbstractCliffordGateSet` for `K` qubits using the `QuantumClifford`
package. The symbol `S` specifies the gate set variant:

- `QubitCliffordGateSet{K, :empty}`:
    The empty `K`-qubit Clifford gates set.
- `QubitCliffordGateSet{K, :all}`:
    All `K`-qubit Clifford gates without phases.
- `QubitCliffordGateSet{K, :full}`:
    All `K`-qubit Clifford gates with `4^K` phase variants.
- `QubitCliffordGateSet{2, :entangle}`:
    19 two-qubit Clifford gates with entangling properties, excluding the identity.
"""
struct QubitCliffordGateSet{K,S} <: AbstractCliffordGateSet
    function QubitCliffordGateSet{K,S}() where {K,S}
        K isa Int || error("K must be an Int")
        S isa Symbol || error("S must be a Symbol")
        new{K,S}()
    end
end


# -- Constructors --------------------------------------------------------------------------

QubitCliffordGateSet(K::Int, S::Symbol) = QubitCliffordGateSet{K,S}()


# -- Base Methods --------------------------------------------------------------------------

Base.eltype(::Type{QubitCliffordGateSet{K,S}}) where {K,S} = QubitCliffordGate
Base.IteratorSize(::Type{<:QubitCliffordGateSet}) = Base.HasLength()
Base.one(::QubitCliffordGateSet{K,S}) where {K,S} =
    QubitCliffordGate(one(CliffordOperator,K))


# -- Interface Methods ---------------------------------------------------------------------

nsites(::QubitCliffordGateSet{K,S}) where {K,S} = K


# -- List Entries --------------------------------------------------------------------------

# -- QubitCliffordGateSet{K,:empty} --

Base.length(::QubitCliffordGateSet{K,:empty}) where {K} = 0

# -- QubitCliffordGateSet{K,:all} --

Base.length(::QubitCliffordGateSet{K,:all}) where {K} =
    length(QuantumClifford.enumerate_cliffords(K))
Base.getindex(::QubitCliffordGateSet{K,:all}, i) where {K} =
    QubitCliffordGate(QuantumClifford.enumerate_cliffords(K, i))

# -- QubitCliffordGateSet{2,:full} --
Base.length(::QubitCliffordGateSet{K,:full}) where {K} =
    4^K * length(QuantumClifford.enumerate_cliffords(2))

function Base.getindex(::QubitCliffordGateSet{K,:full}, i) where {K}
    n = div(i - 1, 4^K) + 1
    r = (i - 1) % 4^K
    clifford = QuantumClifford.enumerate_cliffords(K, n)

    # TODO: Remove dependency on private QuantumClifford.Tableau.phase field.
    for (i, flip) in enumerate(BitVector(digits(r, base=2, pad=2K)))
        if flip
            QuantumClifford.tab(clifford).phases[i] = 0x02
        end
    end
    return QubitCliffordGate(clifford)
end

# -- QubitCliffordGateSet{2,:entangle} --

const QUBIT_TWO_ENTANGLING_GATES =
    Int[2, 3, 9, 12, 18, 24, 27, 31, 32, 42, 57, 61, 62, 91, 92, 252, 267, 282, 297]
Base.length(::QubitCliffordGateSet{2,:entangle}) =
    length(QUBIT_TWO_ENTANGLING_GATES)
Base.getindex(::QubitCliffordGateSet{2,:entangle}, i) =
    QubitCliffordGateSet(2, :all)[QUBIT_TWO_ENTANGLING_GATES[i]]

# ------------------------------------------------------------------------------------------
