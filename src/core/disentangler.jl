# -- Abstract Types ------------------------------------------------------------------------

"""
    AbstractDisentangler

TODO
"""
abstract type AbstractDisentangler end

"""
    AbstractStandAloneDisentangler <: AbstractDisentangler

TODO

# Required methods
Implementations `ConcreteStandAloneDisentangler<:AbstractStandAloneDisentangler` must
support:
- `disentangle!(de::ConcreteStandAloneDisentangler, camps::AbstractCAMPS) ->
  num, gain, info`: -- Lower the entanglement in the MPS part of `camps` by finding a 
  transformation using the `de` method. 
"""
abstract type AbstractStandAloneDisentangler <: AbstractDisentangler end

"""
    AbstractSweepDisentangler <: AbstractStandAloneDisentangler

TODO

# Required methods
Implementations `ConcreteSweepDisentangler<:AbstractSweepDisentangler` must
support:
- `disentangle!(de::ConcreteSweepDisentangler, camps::AbstractCAMPS, bond::Int, r::Bool) -> 
  num, gain, info`: -- Lower the entanglement in the MPS part of `camps` between site `bond`
  and `bond +1` by finding a transformation using the `de` method. Also, move the mps
  orthogonality center to site `bond+1` when `r==true` and to `bond` otherwise.
"""
abstract type AbstractSweepDisentangler <: AbstractStandAloneDisentangler end


# -- Interface Methods ---------------------------------------------------------------------

function apply_and_disentangle!(
    disentangler::AbstractStandAloneDisentangler,
    camps::AbstractCAMPS,
    args...;
    kwargs...)
    apply!(camps, args...; kwargs...)
    return disentangle!(disentangler, camps)
end

function disentangle!(
    disentangler::AbstractSweepDisentangler,
    camps::AbstractCAMPS)

    N = nsites(camps)
    mps = get_mps(camps)

    res_info = Tuple{typeof(1),typeof(1.0),Any}[]
    
    ITensorMPS.orthogonalize!(mps, 1)
    left_to_right = zip(collect(1:N-2), ones(Bool, N - 2))
    right_to_left = zip(collect(N-1:-1:1), zeros(Bool, N - 1))
    for (n, move_ortho_right) in vcat(collect(left_to_right), collect(right_to_left))
        num, gain, info =
            disentangle!(disentangler, camps, n, move_ortho_right)
        if num == 0
            ITensorMPS.orthogonalize!(mps, move_ortho_right ? n+1 : n)
            continue
        end
        push!(res_info, (num, gain, info))
    end

    res_num = sum([x[1] for x in res_info])
    res_gain = sum([x[2] for x in res_info])
    return res_num, res_gain, res_info
end

# -- List Entries --------------------------------------------------------------------------

# -- TrivialDisentangler --

"""
    TrivialDisentangler

TODO
"""
struct TrivialDisentangler <: AbstractStandAloneDisentangler end

disentangle!(::TrivialDisentangler, ::AbstractCAMPS) = 0, 0.0, Any[]


# -- IterativeDisentangler --

"""
    IterativeDisentangler

TODO
"""
struct IterativeDisentangler <: AbstractStandAloneDisentangler
    disentangler::AbstractStandAloneDisentangler
    max_iter::Int
    min_num::Int
    min_gain::Real
end

IterativeDisentangler(disentangler::AbstractStandAloneDisentangler,
    max_iter::Int; min_num = 1, min_gain = 0.0) = 
    return IterativeDisentangler(disentangler, max_iter, min_num, min_gain)

function disentangle!(
    disentangler::IterativeDisentangler,
    camps::AbstractCAMPS)
    res_info = Tuple{typeof(1),typeof(1.0),Any}[]
    for iter in 1:disentangler.max_iter
        num, gain, info = disentangle!(disentangler.disentangler, camps)
        push!(res_info, (num, gain, info))
        if num < disentangler.min_num || gain < disentangler.min_gain
            break
        end
    end
    res_num = sum([x[1] for x in res_info])
    res_gain = sum([x[2] for x in res_info])
    return res_num, res_gain, res_info
end


# -- GreedySweepDisentangler --

"""
    GreedySweepDisentangler

TODO
"""
struct GreedySweepDisentangler <: AbstractSweepDisentangler 
    gateset::AbstractCliffordGateSet
    α::Real
    ϵ::Real
    svd_kwargs::Dict{Symbol, Any}
end

function GreedySweepDisentangler(
    gateset::AbstractCliffordGateSet;
    α=1::Real, ϵ=1.0e-12::Real, svd_kwargs...)
    return GreedySweepDisentangler(gateset, α, ϵ, svd_kwargs)
end

function disentangle!(
    disentangler::GreedySweepDisentangler,
    camps::AbstractCAMPS,
    site::Int,
    move_orto_right::Bool)
    
    n = site
    gateset = disentangler.gateset
    svd_kwargs = disentangler.svd_kwargs

    applied_nothing = true
    id = one(gateset)
    mps = get_mps(camps)

    U, S, V = apply_and_svd(mps, Matrix(id), n; svd_kwargs...)
    start_entanglement = renyi_entropy(Vector(LinearAlgebra.diag(S)).^2; α=disentangler.α)
    best = (start_entanglement, U, S, V, 0)
    for (k, gate) in enumerate(gateset)
        U, S, V = apply_and_svd(mps, Matrix(gate), n; svd_kwargs...)
        new_entanglement = renyi_entropy(Vector(LinearAlgebra.diag(S)).^2; α=disentangler.α)
        if new_entanglement < best[1] - disentangler.ϵ
            applied_nothing = false
            best = (new_entanglement, U, S, V, k)
        end
    end

    if applied_nothing
        return 0, 0.0, 0
    else
        (best_entanglement, U, S, V, k) = best
        if move_orto_right
            mps[n] = U
            mps[n+1] = S*V
            ITensorMPS.set_ortho_lims!(mps, n+1:n+1)
        else
            mps[n] = U*S
            mps[n+1] = V
            ITensorMPS.set_ortho_lims!(mps, n:n)
        end
        apply_to_clifford_dagger!(camps, gateset[k], [n,n+1])
        gain = start_entanglement - best_entanglement
        return 1, gain, k
    end
end

# ------------------------------------------------------------------------------------------
