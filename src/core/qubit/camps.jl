# -- Concrete Structs ----------------------------------------------------------------------

"""
    QubitCAMPS <: CAMPS

Implementation of [`AbstractCAMPS`](@ref) for qubit systems.

# See also
- [`AbstractCAMPS`](@ref)
"""
mutable struct QubitCAMPS <: AbstractCAMPS
    mps::MPS
    clifford::QubitCliffordUnitary
    daggered::Bool
    function QubitCAMPS(mps::MPS, clifford::QubitCliffordUnitary, daggered::Bool)
        if length(mps) != nsites(clifford)
            error("MPS and Clifford must have the same number of sites.")
        end
        new(mps, clifford, daggered)
    end
end


# -- Constructors --------------------------------------------------------------------------

QubitCAMPS(mps::MPS, C::QubitCliffordUnitary) =  QubitCAMPS(mps, C, false)

QubitCAMPS(mps::MPS) = 
    QubitCAMPS(mps, one(QubitCliffordUnitary, length(mps)), false)

QubitCAMPS(C::QubitCliffordUnitary) =
    QubitCAMPS(ITensorMPS.MPS(ITensorMPS.siteinds("Qubit",nsites(C)), "0"), C, false)

QubitCAMPS(N::Int) =
    QubitCAMPS(ITensorMPS.MPS(ITensorMPS.siteinds("Qubit",N), "0"),
        one(QubitCliffordUnitary, N), false)


# -- Base Methods --------------------------------------------------------------------------

function Base.show(io::IO, camps::QubitCAMPS)
    dag = _clifford_is_daggered(camps)
    clifford = _get_clifford(camps, dag)
    mps = get_mps(camps)

    C_string = dag ? "C†" : "C" 
    print(io, typeof(camps), ", |ψ⟩ = C |MPS⟩, with\n")
    print(io, "  |MPS⟩ with bond dimensions:\n")
    print(io, "    ", ITensorMPS.linkdims(mps), "\n")
    print(io, "  ", C_string, ":\n")
    _indent_print(io, clifford; indent=4)
end

# -- Interface Methods ---------------------------------------------------------------------

get_mps(camps::QubitCAMPS) = camps.mps
get_clifford_copy(camps::QubitCAMPS; daggered=false) =
    deepcopy(_get_clifford(camps, daggered))

apply_to_clifford!(camps::QubitCAMPS, args...; kwargs...) =
    apply!(_get_clifford(camps, false), args...; kwargs...)

apply_to_clifford_dagger!(camps::QubitCAMPS,  args...; kwargs...) =
    apply!(_get_clifford(camps, true), args...; kwargs...)

apply_to_mps!(camps::QubitCAMPS, args...; kwargs...) =
    apply!(get_mps(camps), args...; kwargs...)

function LinearAlgebra.mul!(camps::QubitCAMPS, α::Number)
    camps.mps = α * camps.mps
    return camps
end


# -- Private Functions ---------------------------------------------------------------------

_clifford_is_daggered(camps::QubitCAMPS) = camps.daggered

function _get_clifford(camps::QubitCAMPS, daggered)
    if xor(daggered, camps.daggered)
        _dagger_clifford!(camps)
    end
    return camps.clifford
end

function _dagger_clifford!(camps::QubitCAMPS)
    camps.daggered = !camps.daggered
    camps.clifford = inv(camps.clifford)
    return nothing
end

function _indent_print(io::IO, x...; indent=4)
    buf = IOBuffer()
    print(buf, x...)
    str = String(take!(buf))
    pad = " "^indent
    for (i, line) in enumerate(split(str, '\n'))
        i > 1 && print(io, '\n')
        print(io, pad, line)
    end
end
# ------------------------------------------------------------------------------------------
