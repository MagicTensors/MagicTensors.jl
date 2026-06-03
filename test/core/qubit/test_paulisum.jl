@testset "QubitPauliSum" begin
    @testset "constructor" begin
        a = QubitPauliSum(5)
        @test isa(a,QubitPauliSum)
        @test nsites(a) == 5
        @test length(a) == 0

        b = QubitPauliSum(QubitPauli"-iIXYZ")
        @test isa(b,QubitPauliSum)
        @test nsites(b) == 4
        @test length(b) == 1

        c = QubitPauliSum([QubitPauli"X", QubitPauli"Z"],[1/√(2),1/√(2)])
        @test isa(a,QubitPauliSum)
        @test nsites(c) == 1
        @test length(c) == 2
        for (pauli, coeff) in c
            @test isa(coeff, ComplexF64)
        end

        MT.set_qubit_pauli_sum_scalar_type!(Float16)
        d = QubitPauliSum([QubitPauli"X", QubitPauli"Z"],[1/√(2),1/√(2)])
        for (pauli, coeff) in d
            @test isa(coeff, Float16)
        end
        MT.set_qubit_pauli_sum_scalar_type!()
    end

    @testset "push!" begin
        a = QubitPauliSum(5)
        @test isa(a,QubitPauliSum)
        push!(a, QubitPauli"-iXIXIX")
        push!(a, QubitPauli"XIXIX", 0.5)
        push!(a, QubitPauli"XXX", [1,3,5], 0.5im)
        push!(a, QubitPauli"iXXX", [1,3,5])
        @test length(a) == 1
    end

    @testset "arithmetic" begin
        a = QubitPauliSum([QubitPauli"XX", QubitPauli"XZ"],[0.1,0.2im])
        b = QubitPauliSum([QubitPauli"YY", QubitPauli"XZ"],[0.3,0.2im])
        c = QubitPauliSum([QubitPauli"XX"],[0.5])
        d = QubitPauliSum(QubitPauli"__")
        
        apb = QubitPauliSum([QubitPauli"XX", QubitPauli"YY", QubitPauli"XZ"],
            [0.1,0.3,0.4im])
        amb = QubitPauliSum([QubitPauli"XX", QubitPauli"YY"],
            [0.1,-0.3])
        ambpd = QubitPauliSum([QubitPauli"XX", QubitPauli"YY", QubitPauli"II"],
            [0.1,-0.3,1.0])

        @test a == a
        @test !(a==b)
        @test !(a==amb)

        @test d == QubitPauli"II"
        @test QubitPauli"II" == d

        @test a + b == apb
        @test a - b ≈ amb
        @test amb ≈ a - b
        @test a + b == apb
        @test QubitPauli"II"+QubitPauli"XX" == 2*c + d

        @test !(a - b ≈ ambpd)
        @test !(ambpd ≈ a - b)
 
        @test a - b + QubitPauli"II" ≈ ambpd
        @test QubitPauli"II" + a - b ≈ ambpd
        @test a - b ≈ ambpd - QubitPauli"II"

        @test c ≈ 0.5*QubitPauli"XX"
        @test QubitPauli"XX" ≈ 2*c
        @test c ≈ QubitPauli"XX"*0.5
        @test QubitPauli"XX" ≈ c*2

        @test c/0.5 ≈ QubitPauli"XX"
        @test QubitPauli"XX" ≈ c/0.5
        @test c ≈ QubitPauli"XX"/2.0
        @test !(c/0.6 ≈ QubitPauli"XX")
        @test !(c ≈ QubitPauli"XX"/2.1)
    end

    @testset "embed" begin
        a = QubitPauliSum([QubitPauli"XX", QubitPauli"XZ"],[0.1,0.2im])
        b = QubitPauliSum([QubitPauli"YIY", QubitPauli"XIZ"],[1.0,0.2im])

        @test embed(a, 3, [1,3]) + QubitPauli"YIY" ≈ 0.1*embed(QubitPauli"XX", 3, [1,3]) + b
    end

    @testset "show" begin
        a = QubitPauliSum([QubitPauli"XX", QubitPauli"XZ"],[0.1,0.2im])
        s1 = sprint(io -> show(IOContext(io, :limit=>true, :cut=>2), a))
        @test occursin("XX", s1)
        @test occursin("XZ", s1)
        @test !occursin("⋮", s1)

        s2 = sprint(io -> show(IOContext(io, :limit=>true, :cut=>1), a))
        @test occursin("⋮", s2)

        s3 = sprint(io -> show(IOContext(io, :limit=>false, :cut=>1), a))
        @test !occursin("⋮", s3)
    end

    @testset "ITensorsMPS.OpSum" begin
        a = QubitPauliSum(
            [QubitPauli"YIY", QubitPauli"XIZ", QubitPauli"XII", QubitPauli"III"],
            [1.0,0.2im,0.1,1])
        s = IT.OpSum(a)
        @test isa(s,IT.Sum)
        @test length(s) == 4
        @test length(s[1]) == 2
        @test length(s[2]) == 1
    end
end

@testset "PauliSum - Private Functions" begin
    @testset "_phase_to_number" begin
        # Test phase to complex number conversion
        @test MT._phase_to_number(0x00) == 1.0
        @test MT._phase_to_number(0x01) == 0.0 + 1.0im
        @test MT._phase_to_number(0x02) == -1.0
        @test MT._phase_to_number(0x03) == 0.0 - 1.0im
        
        # Test that results are correct type
        @test isa(MT._phase_to_number(0x00), Real)
        @test isa(MT._phase_to_number(0x01), Complex)
    end

    @testset "_int_from_xz" begin
        # Test encoding of Pauli operators
        @test MT._int_from_xz(false, false) == 0  # I (identity)
        @test MT._int_from_xz(true, false) == 1   # X
        @test MT._int_from_xz(true, true) == 2    # Y
        @test MT._int_from_xz(false, true) == 3   # Z
        
        # Verify all combinations
        combinations = [
            (false, false, 0),
            (true, false, 1),
            (true, true, 2),
            (false, true, 3),
        ]
        for (x, z, expected) in combinations
            @test MT._int_from_xz(x, z) == expected
        end
    end
end
