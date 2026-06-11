# -- Interface Methods ---------------------------------------------------------------------

function apply!(mps::MPS, gate::AbstractMatrix, sites::AbstractVector{<:Int}; kwargs...)
    if length(sites) == 1
        return _apply_mps_single_site!(mps, gate, sites[1]; kwargs...)
    elseif length(sites) == 2
        if sites[2] == sites[1] + 1
            return _apply_mps_nearest_neighbor!(mps::MPS, gate::Matrix, sites[1]; kwargs...)
        end
    end
    return error("not implemented") # TODO
end

apply!(mps::MPS, gate::AbstractCliffordGate, sites::AbstractVector{<:Int}; kwargs...) =
    apply!(mps, Matrix(gate), sites; kwargs...)

function apply!(mps::MPS, x::AbstractPauliSum; svd_kwargs...)
    @assert nsites(mps) == nsites(x)
    mpo = ITensorMPS.MPO(ITensorMPS.OpSum(x),ITensorMPS.siteinds(mps))

    # TODO: make this more memory efficient.
    new_mps = ITensorMPS.apply(mpo, mps; svd_kwargs...)
    for j in eachindex(mps)
        mps[j] = new_mps[j]
    end
    return mps
end

apply!(mps::MPS, x::AbstractPauliSum, sites::AbstractVector{<:Int}; svd_kwargs...) =
    apply!(mps, embed(x, nsites(mps), sites); svd_kwargs...)

function expectation(mps::MPS, x::AbstractPauliSum; normalized=false)
    sites = ITensorMPS.siteinds(mps)
    inner_prod = ITensorMPS.inner(mps',ITensorMPS.MPO(ITensorMPS.OpSum(x),sites),mps)
    if normalized
        return inner_prod / LinearAlgebra.norm(mps)^2
    end
    return inner_prod
end

expectation(mps::MPS, x::AbstractPauli; normalized=false) =
    expectation(mps, 1.0*x; normalized)

nsites(mps::MPS) = length(mps)

function singular_values(mps::MPS, bond::Int; svd_kwargs...) 
    ψ = ITensorMPS.orthogonalize(mps, bond)
    U, S, V = ITensors.svd(
        ψ[bond],
        ITensors.uniqueinds(ψ[bond],ψ[bond+1]);
        svd_kwargs...)
    return Vector(LinearAlgebra.diag(S))
end


function singular_values(mps::MPS; svd_kwargs...)
    svals = Vector{Vector{Float64}}(undef, length(mps) - 1)
    ψ = copy(mps)
    for b in 1:length(ψ)-1
        ITensorMPS.orthogonalize!(ψ, b)
        U, S, V = ITensors.svd(ψ[b], ITensorMPS.linkind(ψ, b); svd_kwargs...)
        svals[b] = Vector(LinearAlgebra.diag(S))
    end

    return svals
end


# -- Additional Functions ------------------------------------------------------------------

function apply_and_svd(
    mps::MPS,
    matrix::AbstractMatrix,
    site::Int;
    kwargs...)

    @assert 1 ≤ site < length(mps)
    s = ITensorMPS.siteinds(mps)

    lims = ITensorMPS.ortho_lims(mps)
    if first(lims) < site || last(lims) > site+1
        error("MPS must have its orthogonality center within $site:$(site+1)")
    end

    U = ITensors.itensor(matrix,
        ITensors.prime(s[site+1]), ITensors.prime(s[site]), s[site+1], s[site])
    θ = mps[site] * mps[site + 1]
    θ = ITensors.noprime(U * θ)
    leftinds = ITensors.uniqueinds(mps[site], mps[site + 1])
    Uten, Sten, Vten =  ITensors.svd(θ, leftinds; kwargs...)

    return Uten, Sten, Vten
end

# -- Private Functions ---------------------------------------------------------------------

function _apply_mps_single_site!(mps::MPS, matrix::AbstractMatrix, site::Int; kwargs...) 
    s = ITensorMPS.siteind(mps, site)
    s === nothing && throw(ArgumentError("No site index found at site $site"))

    U = ITensors.itensor(matrix, ITensors.prime(s), s)
    mps[site] =  ITensors.noprime(mps[site] * U)
    
    return mps
end

function _apply_mps_nearest_neighbor!(
    mps::MPS,
    matrix::AbstractMatrix,
    site::Int;
    move_orthogonality_right=true,
    kwargs...)
    
    @assert 1 ≤ site < length(mps)

    lims = ITensorMPS.ortho_lims(mps)
    if first(lims) < site || last(lims) > site+1
        ITensorMPS.orthogonalize!(mps, site)
    end

    U, S, V = apply_and_svd(mps::MPS, matrix::AbstractMatrix, site::Int; kwargs...)

    if move_orthogonality_right
        mps[site] = U
        mps[site+1] = S*V
        ITensorMPS.set_ortho_lims!(mps, site+1:site+1)
    else 
        mps[site] = U*S
        mps[site+1] = V
        ITensorMPS.set_ortho_lims!(mps, site:site)
    end
    
    return mps
end


# ------------------------------------------------------------------------------------------
