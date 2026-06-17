using Test
using JET

using MagicTensors

import Random
import LinearAlgebra
import ITensorMPS
import QuantumClifford

const MT = MagicTensors
const LA = LinearAlgebra
const IT = ITensorMPS
const QC = QuantumClifford

@testset "MagicTensors.jl" begin
    @testset "Code Quality" begin
        @testset "Code linting (JET.jl)" begin
            JET.test_package(MagicTensors; target_modules=(MagicTensors,))
        end
    end

    @testset "Abstract Core" begin
        include("core/test_pauli.jl")
        include("core/test_paulisum.jl")
        include("core/test_cliffordunitary.jl")
        include("core/test_cliffordgate.jl")
        include("core/test_cliffordgateset.jl")
        include("core/test_mps.jl")
        include("core/test_camps.jl")
        include("core/test_functions.jl")
        include("core/test_entropy.jl")
        include("core/test_disentangler.jl")
        include("core/test_dmrg.jl")
    end

    @testset "Qubit Core" begin
        include("core/qubit/test_pauli.jl")
        include("core/qubit/test_paulisum.jl")
        include("core/qubit/test_cliffordunitary.jl")
        include("core/qubit/test_cliffordgate.jl")
        include("core/qubit/test_cliffordgateset.jl")
        include("core/qubit/test_camps.jl")
        include("core/qubit/test_dmrg.jl")
    end

    @testset "Not Implemented" begin
        include("core/test_notimplemented.jl")
    end
end
