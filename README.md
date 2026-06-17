# MagicTensors.jl
> **🚧 This package is currently under construction! 🚧**

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://magictensors.github.io/MagicTensors.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://magictensors.github.io/MagicTensors.jl/dev/)
[![Build Status](https://github.com/MagicTensors/MagicTensors.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MagicTensors/MagicTensors.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/MagicTensors/MagicTensors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/MagicTensors/MagicTensors.jl)
![Status](https://img.shields.io/badge/status-experimental-red)

**A Julia package for the classical simulation of quantum systems using a hybrid method
that combines tensor networks with the stabilizer formalism.**

TODO
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. [1]

| Resource       | Link                                               |
| ---------------|----------------------------------------------------|
| Github:        | <https://github.com/MagicTensors/MagicTensors.jl>  |
| Documentation: | <https://magictensors.github.io/MagicTensors.jl>   |

## Quickstart

### DMRG - Cluster State
H = − X₁ Z₂ − ∑ᵢ Zᵢ₋₁ Xᵢ Zᵢ₊₁ − Xₙ₋₁ Zₙ

```Julia
using MagicTensors

# -- Parameters ----------------------------------------------------------------------------
n = 5 # system size

# -- 1D Cluster State Hamiltonian ----------------------------------------------------------
H = QubitPauliSum(n) 
push!(H, QubitPauli"XZ", [1,2], -1)
for i in 2:n-1
    push!(H, QubitPauli"ZXZ", [i-1,i,i+1], -1)
end
push!(H, QubitPauli"ZX", [n-1,n], -1)
@show H
    # H = QubitPauliSum{ComplexF64, Vector{UInt64}} on 5 sites, with 5 terms:
    # (-1.000000e+00 +0.000000e+00im) + _ZXZ_
    # (-1.000000e+00 +0.000000e+00im) + __ZXZ
    # (-1.000000e+00 +0.000000e+00im) + ZXZ__
    # (-1.000000e+00 +0.000000e+00im) + ___ZX
    # (-1.000000e+00 +0.000000e+00im) + XZ___

# -- Clifford Aumented MPS - DMRG ----------------------------------------------------------
camps = QubitCAMPS(n)
energyCAMPS, _ = dmrg!(camps, H; nsweeps=1, cutoff=1e-12, outputlevel=0)
@show energyCAMPS
    # energyCAMPS = -5.0
@show camps
    # camps = QubitCAMPS, |ψ⟩ = C |MPS⟩, with
    #   |MPS⟩ with bond dimensions:
    #     [1, 1, 1, 1]
    #   C†:
    #     QubitCliffordUnitary acting on 5 qubits:
    #     X₁ ⟼ + ZX___
    #     X₂ ⟼ + XZX__
    #     X₃ ⟼ + _XZX_
    #     X₄ ⟼ + __XZZ
    #     X₅ ⟼ + ___XX
    #     Z₁ ⟼ + X____
    #     Z₂ ⟼ + _X___
    #     Z₃ ⟼ + __X__
    #     Z₄ ⟼ + ___X_
    #     Z₅ ⟼ + ____Z
@show expectation(camps, QubitPauli"-YXXXY")
    # expectation(camps, QubitPauli"-YXXXY") = 0.9999999999999997 + 0.0im
```

## References
1. [Fishman et al, arXiv:2007.14822](REFERENCES.md#2007.14822.Fishman)

