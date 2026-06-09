# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitCliffordUnitary <: AbstractCliffordUnitary

Implementation of [`AbstractCliffordUnitary`](@ref) for qubit systems.
"""
mutable struct QubitCliffordUnitary <: AbstractCliffordUnitary
    clifford::CliffordOperator
end


# -- Constructors --------------------------------------------------------------------------

QubitCliffordUnitary(n::Int) = QubitCliffordUnitary(one(CliffordOperator, n))


# -- Base Methods --------------------------------------------------------------------------

Base.show(io::IO, C::QubitCliffordUnitary) =
    print(io, "QubitCliffordUnitary acting on ", nsites(C), " qubits:\n", C.clifford)

Base.:(==)(C::QubitCliffordUnitary, D::QubitCliffordUnitary) =  (C.clifford == D.clifford)

function Base.:*(C::QubitCliffordUnitary, D::QubitCliffordUnitary)
    @assert nsites(C) == nsites(D)
    stab = QuantumClifford.apply!(Stabilizer(copy(QuantumClifford.tab(D.clifford))),
        C.clifford)
    return QubitCliffordUnitary(CliffordOperator(QuantumClifford.tab(stab)))
end

Base.inv(C::QubitCliffordUnitary) = QubitCliffordUnitary(inv(C.clifford))


# -- Interface Methods ---------------------------------------------------------------------

function apply!(D::QubitCliffordUnitary, C::QubitCliffordUnitary)
    D.clifford = C.clifford * D.clifford
    return D
end

function conjugate(P::QubitPauli, C::QubitCliffordUnitary)
    stab = QuantumClifford.apply!(Stabilizer([PauliOperator(P)]), C.clifford)
    return QubitPauli(stab[1])
end

nsites(C::QubitCliffordUnitary) = QuantumClifford.nqubits(C.clifford)


# -- Extensions ----------------------------------------------------------------------------

QuantumClifford.CliffordOperator(C::QubitCliffordUnitary) = C.clifford

# ------------------------------------------------------------------------------------------
