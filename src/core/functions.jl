# -- Abstract Functions --------------------------------------------------------------------

"""
    apply!

TODO
"""
function apply! end

"""
    apply_and_disentangle!
TODO
"""
function apply_and_disentangle! end

"""
    apply_to_clifford!
TODO
"""
function apply_to_clifford! end

"""
    apply_to_clifford_dagger!
TODO
"""
function apply_to_clifford_dagger! end

"""
    apply_to_mps!
TODO
"""
function apply_to_mps! end

"""
    conjugate(P, C) -> Q

Returns the conjugation of an Pauli string or Pauli sum by a Clifford unitary.

# Description
Computes `Q = C P C†`, where `C` is a Clifford unitary and `P` is a Pauli string or Pauli
sum. The result `Q` is a Pauli string or Pauli sum of the same type as `P`.

# Arguments
- `P::Union{AbstractPauli, AbstractPauliSum}`: -- A Pauli string or Pauli sum to be
    conjugated.
- `C::AbstractCliffordUnitary`: -- A Clifford unitary to conjugate with.

# Returns
- `Q::Union{AbstractPauli, AbstractPauliSum}`: -- The conjugated Pauli string or Pauli sum
    `C P C†`.

# See also
- [`AbstractCliffordUnitary`](@ref), [`AbstractPauli`](@ref), [`AbstractPauliSum`](@ref)
"""
function conjugate end

"""
    disentangle!

TODO
"""
function disentangle! end

"""
    dmrg!

TODO
"""
function dmrg! end

"""
    embed

TODO
"""
function embed end

"""
    entanglement_entropy

TODO
"""
function entanglement_entropy end

"""
    expectation
TODO
"""
function expectation end

"""
    get_clifford
TODO
"""
function get_clifford end

"""
    get_clifford_copy
TODO
"""
function get_clifford_copy end

"""
    get_mps
TODO
"""
function get_mps end


"""
    nsites(obj) -> n

Returns the number of qubit or qudit sites `n` in an object.

# Description
Returns the number of qubits or qudits in an object `obj`.

Objects `obj` may be any of the following types:
    - `AbstractCAMPS`
    - `AbstractCliffordGate`
    - `AbstractCliffordGateSet`
    - `AbstractCliffordUnitary`
    - `AbstractPauli`
    - `AbstractPauliSum`
    - `ITensorMPS.MPS`

# Arguments
- `obj`: -- Object acting on or representing a certain number of qubits or qudits.

# Returns
- `n::Int`: -- Number of qubits or qudits in object `obj`.

# See also 
- [`AbstractCAMPS`](@ref), [`AbstractCliffordGate`](@ref),
    [`AbstractCliffordGateSet`](@ref), [`AbstractCliffordUnitary`](@ref),
    [`AbstractPauli`](@ref), [`AbstractPauliSum`](@ref),
"""
function nsites end

"""
    stabilizer_entropy

TODO
"""
function stabilizer_entropy end

"""
    transform!

TODO: write docstring.
"""
function transform! end


# -- Interface Methods ---------------------------------------------------------------------

function apply!(
    x, y::Union{AbstractPauliSum, AbstractPauli}, sites::AbstractVector{<:Int}; kwargs...)
    return apply!(x, embed(y,nsites(x),sites); kwargs...)
end

function expectation(
    x, y::Union{AbstractPauliSum, AbstractPauli}, sites::AbstractVector{<:Int}; kwargs...)
    return expectation(x, embed(y,nsites(x),sites); kwargs...)
end

# ------------------------------------------------------------------------------------------
