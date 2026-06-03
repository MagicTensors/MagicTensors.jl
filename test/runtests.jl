using MagicTensors
using Test
using JET
using QuantumClifford
using ITensorMPS

const MT = MagicTensors
@testset "MagicTensors.jl" begin
    @testset "Code Quality" begin
        # @testset "Code linting (JET.jl)" begin
        #     JET.test_package(MagicTensors; target_modules=(MagicTensors,))
        # end
    end

    @testset "Abstract Core" begin
        include("core/test_pauli.jl")
        include("core/test_paulisum.jl")
    end

    @testset "Qubit Core" begin
        include("core/qubit/test_pauli.jl")
        include("core/qubit/test_paulisum.jl")
    end

end
