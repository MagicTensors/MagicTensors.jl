"""
    MagicTensors

TODO: Module docstring.
"""
module MagicTensors

using Printf
using QuantumClifford: PauliOperator

import ITensorMPS
import QuantumClifford


# -- Abstract ---------------------

include("core/functions.jl")
export apply!
export conjugate
export embed
export nsites

include("core/pauli.jl")
export AbstractPauli

include("core/paulisum.jl")
export AbstractPauliSum

# -- Qubit ------------------------

include("core/qubit/pauli.jl")
export QubitPauli
export @QubitPauli_str

include("core/qubit/paulisum.jl")
export QubitPauliSum

end
