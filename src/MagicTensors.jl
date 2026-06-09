"""
    MagicTensors

TODO: Module docstring.
"""
module MagicTensors

using Printf
using QuantumClifford: CliffordOperator, PauliOperator, Stabilizer

import ITensorMPS
import QuantumClifford
import QuantumOpticsBase


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

include("core/cliffordunitary.jl")
export AbstractCliffordUnitary

include("core/cliffordgate.jl")
export AbstractCliffordGate


# -- Qubit ------------------------

include("core/qubit/pauli.jl")
export QubitPauli
export @QubitPauli_str

include("core/qubit/paulisum.jl")
export QubitPauliSum

include("core/qubit/cliffordunitary.jl")
export QubitCliffordUnitary

include("core/qubit/cliffordgate.jl")
export QubitCliffordGate

end
