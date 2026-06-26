"""
    MagicTensors

TODO
"""
module MagicTensors

using Printf

using ITensorMPS: MPS
using QuantumClifford: CliffordOperator, PauliOperator, Stabilizer

import LinearAlgebra
import ITensors
import ITensorMPS
import QuantumClifford
import QuantumOpticsBase


# -- Abstract ---------------------

include("core/pauli.jl")
export AbstractPauli

include("core/paulisum.jl")
export AbstractPauliSum

include("core/cliffordunitary.jl")
export AbstractCliffordUnitary

include("core/cliffordgate.jl")
export AbstractCliffordGate

include("core/cliffordgateset.jl")
export AbstractCliffordGateSet

include("core/mps.jl")
export singular_values

include("core/camps.jl")
export AbstractCAMPS

include("core/entropy.jl")

include("core/disentangler.jl")
export AbstractDisentangler
export AbstractStandAloneDisentangler
export AbstractLocalDisentangler
export TrivialDisentangler
export IterativeDisentangler
export SweepDisentangler
export GreedyDisentangler
export MetropolisDisentangler

include("core/dmrg.jl")
export AbstractDmrgDisentangler
export IterativeDmrgDisentangler

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

include("core/qubit/cliffordgateset.jl")
export QubitCliffordGateSet

include("core/qubit/camps.jl")
export QubitCAMPS

include("core/qubit/disentangler.jl")

include("core/qubit/dmrg.jl")

# -- Functions ------------------------

include("core/functions.jl")
export apply!
export apply_and_disentangle!
export apply_to_clifford!
export apply_to_clifford_dagger!
export apply_to_mps!
export conjugate
export disentangle!
export dmrg!
export embed
export entanglement_entropy
export expectation
export get_clifford_copy
export get_mps
export nsites
export stabilizer_entropy
export transform!

end
