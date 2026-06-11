# -- Abstract Functions --------------------------------------------------------------------

"""
    apply!

TODO: update docstring.
Applies a Clifford unitary or gate to a matrix product state, another Clifford unitary, or a
sum of Pauli strings. This is a generic function that should be implemented for the concrete
types involved.

The following methods should be implemented for the concrete subtypes of
`AbstractCliffordGate`, `AbstractCliffordUnitary`, and `AbstractPauliSum`:
- `apply!(state::MPS, gate::AbstractCliffordGate, sites)`:
    applies the gate to the given state in-place.
- `apply!(C::AbstractCliffordUnitary, gate::AbstractCliffordGate, sites)`:
    applies the gate to the given state in-place.
- `apply!(C::AbstractCliffordUnitary,V::AbstractCliffordUnitary)`:
    applies the Clifford unitary V to the Clifford unitary C in-place.
- `apply!(x::AbstractPauliSum, C::AbstractCliffordUnitary)`:
    applies the Clifford unitary to the given Pauli sum in-place.
"""
function apply! end

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

# disentangle!

"""
    embed

TODO: write docstring.
"""
function embed end

# entanglement_entropy

"""
    expectation
TODO
"""
function expectation end

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

TODO: Update docstring.
Returns the number of qubit or qudit sites `n` in an object.

# Description
Returns the number of qubits or qudits in an object `obj`.

- Objects `obj` include:
    - `AbstractCAMPS`
    - `AbstractCliffordGate`
    - `AbstractCliffordGateSet`
    - `AbstractCliffordUnitary`
    - `AbstractPauli`
    - `AbstractPauliSum`
    - `MPS`

# Arguments
- `obj`: -- Object acting on or representing a certain number of qubits or qudits.

# Returns
- `n::Int`: -- Number of qubits or qudits in object `obj`.

# See also 
- TODO
"""
function nsites end
# - [`AbstractCAMPS`](@ref), [`AbstractCliffordGate`](@ref),
#     [`AbstractCliffordGateSet`](@ref), [`AbstractCliffordUnitary`](@ref),
#     [`AbstractPauli`](@ref), [`AbstractPauliSum`](@ref),


# site_type
# stabilizer_entropy


"""
    transform!

TODO: write docstring.
"""
function transform! end


# -- Interface Methods ---------------------------------------------------------------------

function expectation(
    x, y::Union{AbstractPauliSum, AbstractPauli}, sites::AbstractVector{<:Int})
    return expectation(x, embed(y,nsites(x),sites))
end

# ------------------------------------------------------------------------------------------
