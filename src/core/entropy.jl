# -- Constants -----------------------------------------------------------------------------

const WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD_DEFAULT = 6
const WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD = Ref(WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD_DEFAULT)

set_warn_exact_stabilizer_entropy_threshold!(n::Integer) =
    (WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD[] = n)
set_warn_exact_stabilizer_entropy_threshold!() =
    set_warn_exact_stabilizer_entropy_threshold!(WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD_DEFAULT)

# -- Interface Methods ---------------------------------------------------------------------

# -- entanglement entropy --

function von_neumann_entropy(p::AbstractVector{<:Real})
    v = filter(x->x>0, p) 
    return -sum(v .* log2.(v))
end

function linear_entropy(p::AbstractVector{<:Real})
    return 1-sum(p.^2)
end

function renyi_entropy(p::AbstractVector{<:Real}; α=2::Real)
    if α == 1
        return von_neumann_entropy(p)
    elseif α == -1
        return linear_entropy(p)
    end
    return log2(sum(p.^α)) / (1 - α)
end

function entanglement_entropy(mps::MPS, b::Int; α=1::Real, svd_kwargs...)
    return renyi_entropy(singular_values(mps, b; svd_kwargs...).^2; α)
end

function entanglement_entropy(mps::MPS; α=1::Real, svd_kwargs...)
    return [renyi_entropy(svals.^2; α) for svals in singular_values(mps; svd_kwargs...)]
end


# -- stabilizer entropy --

abstract type AbstractStabilizerEntropyMethod end
struct StabilizerEntropyMethod{x} <: AbstractStabilizerEntropyMethod end
StabilizerEntropyMethod(x) = StabilizerEntropyMethod{x}()

function stabilizer_entropy(method::Symbol, args...; kwargs...)
    return stabilizer_entropy(StabilizerEntropyMethod(method), args...; kwargs...)
end

function stabilizer_entropy(::StabilizerEntropyMethod{:exact}, mps::MPS; α=2::Real)
    warn_threshold = WARN_EXACT_STABILIZER_ENTROPY_THRESHOLD[]
    if nsites(mps) > warn_threshold
        @warn "The exact `stabilizer_entropy(:exact, mps)` method may be very slow for large system sizes" system_size=nsites(mps) threshold=warn_threshold
    end
    return _stabilizer_entropy_exact(mps, [α,])[1]
end

function stabilizer_entropy(::StabilizerEntropyMethod{:sampled}, mps::MPS, samples::Int;
     α=2::Real, kwargs...)
    return _stabilizer_entropy_sampled(mps, samples, [α,])[1]
end

function stabilizer_entropy(mps::MPS; kwargs...)
    return stabilizer_entropy(StabilizerEntropyMethod(:exact), mps; kwargs...)
end

function stabilizer_entropy(mps::MPS, samples::Int; kwargs...)
    return stabilizer_entropy(StabilizerEntropyMethod(:sampled), mps, samples; kwargs...)
end

# -- Private Functions ---------------------------------------------------------------------

function _stabilizer_entropy_exact(mps::MPS, α::AbstractVector{<:Real})
    mps = ITensorMPS.orthogonalize(mps, 1)
    ITensorMPS.normalize!(mps)

    N = length(mps)
    sites = ITensorMPS.siteinds(mps)

    if any([ITensors.dim(s)!=2 for s in sites])
        error("Exact stabilizer entropy is currently implemented only for qubits.")
    end

    d = 2^N
    paulibasis = ["I" "X" "Y" "Z"]
    paulistrings = [""]
    for n in 1:N
        paulistrings = kron(paulistrings, paulibasis)
    end

    Ξ = []
    for paulistring in paulistrings
        paulioperator = ITensors.op(paulistring[1:1],sites[1])
        for n in 2:N
            paulioperator *= ITensors.op(paulistring[n:n],sites[n])
        end
        val = real(ITensorMPS.inner(mps',ITensorMPS.MPO(paulioperator, ITensorMPS.siteinds(mps)),mps))
        push!(Ξ, val^2 / d)
    end

    results = []
    Ξ = filter(x->x>0, Ξ) 
    for a in α
        if a == 1.0
            push!(results,-sum(Ξ .* log2.(Ξ)) - N)
        elseif a == -1.0
            push!(results,1 - 2^N * sum(Ξ.^2))
        else
            push!(results,log2(sum(Ξ.^a))/(1-a) - N)
        end
    end

    return results
end

function _stabilizer_entropy_sampled(mps::MPS, samples::Integer, α::AbstractVector{<:Real})
    # Compute the stabilizer α-Renyi entropy by sampling the Paulistring distribution [1].
    # For α=-1.0 cumputes the stabilizer linear entropy.
    # [1] ... Lami, Collura; arXiv:2303.05536; DOI: 10.48550/arXiv.2303.05536

    mps = ITensorMPS.orthogonalize(mps,1)
    ITensorMPS.normalize!(mps)
    s = ITensorMPS.siteinds(mps)
    N = length(s)

    Π = []
    for i in 1:samples
        push!(Π, _get_pauli_sample(mps::MPS))
    end

    results = []

    Π = Π[findall(>(0.0),Π)]
    for a in α
        if a == 1.0
            push!(results,-sum(log2.(Π))/samples - N)
        elseif a == -1.0
            push!(results,1-2^N*(sum(Π)/samples))
        else
            push!(results, 1/(1-a)*log2(sum(Π.^(a-1))/samples) - N)
        end
    end

    return results
end

function _get_pauli_sample(psi::MPS)
    # Sample a pauli string [1]. The MPS psi has to be normalized and the orthogonality has
    # to be at site 1.
    # [1] ... Lami, Collura; arXiv:2303.05536; DOI: 10.48550/arXiv.2303.05536

    s = ITensorMPS.siteinds(psi)
    N = length(s)

    paulis = ["I", "X", "Y", "Z"]
    L = ITensors.ITensor(ComplexF64, 1.0)
    Π = 1.0

    for n ∈ 1:N
        r = rand()
        for pauli in paulis
            l = L
            l = l * psi[n] * ITensorMPS.op(pauli,s[n]) * ITensorMPS.prime(
                ITensorMPS.dag(psi[n]))
            p = real(Array(l * ITensorMPS.dag(l))[1,1]) / 2.0
            r -= p
            if r ≤ 0.0
                L = l / √(2.0*p)
                Π *= p
                break
            end
        end
    end
    return Π
end
