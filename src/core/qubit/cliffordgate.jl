# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitCliffordGate <: AbstractCliffordGate

Implementation of `AbstractCliffordGate` for qubits using the `QuantumClifford` package.

# See also
- [`AbstractCliffordGate`](@ref)
"""
struct QubitCliffordGate <: AbstractCliffordGate
    clifford::CliffordOperator
    function QubitCliffordGate(clifford::CliffordOperator)
        new(clifford)
    end
end


# -- Base Methods --------------------------------------------------------------------------

Base.show(io::IO, x::QubitCliffordGate) =
    print(io, "QubitCliffordGate acting on ", nsites(x), " qubits:\n", x.clifford)

function Base.:(==)(x::QubitCliffordGate, y::QubitCliffordGate)
    return CliffordOperator(x) == CliffordOperator(y)
end

function Base.Matrix(x::QubitCliffordGate)
    # TODO: remove dependence on QuantumOpticsBase
    op = QuantumOpticsBase.Operator(CliffordOperator(x))
    # TODO: remove explicit use of the data field
    return _reverse_qubit_order(Matrix(op.data))
end

# -- Interface Methods ---------------------------------------------------------------------

function apply!(C::QubitCliffordUnitary, x::QubitCliffordGate, sites::AbstractVector{<:Int})
    tab = copy(QuantumClifford.tab(C.clifford))
    QuantumClifford.apply!(Stabilizer(tab), sites, x.clifford)
    C.clifford = CliffordOperator(tab)
    return C
end

nsites(x::QubitCliffordGate) = QuantumClifford.nqubits(x.clifford)

# -- Extensions ----------------------------------------------------------------------------

QuantumClifford.CliffordOperator(x::QubitCliffordGate) = x.clifford


# -- Private Functions ---------------------------------------------------------------------

function _reverse_qubit_order(U::AbstractMatrix)
    d = size(U, 1)
    n = round(Int, log2(d))
    @assert size(U) == (d, d)
    @assert 2^n == d

    perm = [_reverse_bits(x, n) + 1 for x in 0:d-1]
    return U[perm, perm]
end

function _reverse_bits(x::Integer, n::Integer)
    y = zero(x)
    for _ in 1:n
        y = (y << 1) | (x & 1)
        x >>= 1
    end
    return y
end

# ------------------------------------------------------------------------------------------
