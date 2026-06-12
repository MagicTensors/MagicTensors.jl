# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractDmrgDisentangler <: AbstractDisentangler

TODO
"""
abstract type AbstractDmrgDisentangler <: AbstractDisentangler end


# -- List Entries --------------------------------------------------------------------------

# -- AbstractStandAloneDisentangler --

function dmrg!(
    disentangler::AbstractStandAloneDisentangler,
    camps::AbstractCAMPS,
    H::AbstractPauliSum;
    kwargs...)

    @assert nsites(H) == nsites(camps)

    H_conj = conjugate(H, get_clifford(camps; daggered=true))
    psi0 = get_mps(camps)
    H_conj_mpo = ITensorMPS.MPO(ITensorMPS.OpSum(H_conj),ITensorMPS.siteinds(psi0))
    energy, psi = ITensorMPS.dmrg(H_conj_mpo, psi0; kwargs...)

    mps = get_mps(camps)
    for j in eachindex(mps)
        mps[j] = psi[j]
    end

    return energy, disentangle!(camps, disentangler)
end

# -- IterativeDmrgDisentangler --

"""
    IterativeDmrgDisentangler

TODO
"""
struct IterativeDmrgDisentangler <: AbstractDisentangler
    disentangler::AbstractStandAloneDisentangler
    max_iter::Int
    min_energy_gain::Real
    warn_max_iter::Bool
end

function IterativeDmrgDisentangler(
    disentangler::AbstractStandAloneDisentangler,
    max_iter::Int;
    min_energy_gain = -Inf,
    warn_max_iter=false)
    return IterativeDmrgDisentangler(disentangler, max_iter, min_energy_gain, warn_max_iter)
end

function dmrg!(
    disentangler::IterativeDmrgDisentangler,
    camps::AbstractCAMPS,
    H::AbstractPauliSum;
    kwargs...)

    @assert nsites(H) == nsites(camps)
    
    res_info = Tuple{typeof(1),typeof(1.0),Any}[]
    prev_energy = Inf
    energy = NaN
    
    for iter in 1:disentangler.max_iter
        energy, (num, gain, info) = dmrg!(disentangler.disentangler, camps, H; kwargs...)
        push!(res_info, (num, gain, info))

        if real(prev_energy) - real(energy) < disentangler.min_energy_gain
            break
        else
            prev_energy = energy
        end

        if disentangler.warn_max_iter && (iter == disentangler.max_iter)
            @warn "Maxmum DMRG iterations reached!" max_iter=disentangler.max_iter
        end
    end

    res_num = sum([x[1] for x in res_info])
    res_gain = sum([x[2] for x in res_info])
    return energy, (res_num, res_gain, res_info)
end

# ------------------------------------------------------------------------------------------
