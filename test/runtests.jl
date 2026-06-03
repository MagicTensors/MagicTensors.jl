using MagicTensors
using Test
using JET
using QuantumClifford
using ITensorMPS

@testset "MagicTensors.jl" begin
    @testset "Code Quality" begin
        @testset "Code linting (JET.jl)" begin
            JET.test_package(MagicTensors; target_modules=(MagicTensors,))
        end
    end

    @testset "check wizarding skills" begin
        @test MagicTensors.MAGIC == 42
    end

end
