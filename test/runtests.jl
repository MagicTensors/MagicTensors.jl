using MagicTensors
using Test
using JET

import ITensorMPS
import QuantumClifford

const MT = MagicTensors
const IT = ITensorMPS
const QC = QuantumClifford
@testset "MagicTensors.jl" begin
    @testset "Code Quality" begin
        # @testset "Code linting (JET.jl)" begin
        #     JET.test_package(MagicTensors; target_modules=(MagicTensors,))
        # end
    end

    @testset "Abstract Core" begin
        include("core/test_pauli.jl")
        include("core/test_paulisum.jl")
        include("core/test_cliffordunitary.jl")
        include("core/test_cliffordgate.jl")
        include("core/test_cliffordgateset.jl")
    end

    @testset "Qubit Core" begin
        include("core/qubit/test_pauli.jl")
        include("core/qubit/test_paulisum.jl")
        include("core/qubit/test_cliffordunitary.jl")
        include("core/qubit/test_cliffordgate.jl")
        include("core/qubit/test_cliffordgateset.jl")
    end

end
