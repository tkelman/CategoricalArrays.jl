function CategoricalPool{V, S, T <: Integer}(index::Vector{S}, invindex::Dict{S, T}, order::Vector{RefType})
    invindex = convert(Dict{S, RefType}, invindex)
    CategoricalPool{V, S}(index, invindex, order)
end

function CategoricalPool{V, T}(index::Vector{T})
    invindex = buildinvindex(index)
    order = buildorder(index)
    return CategoricalPool{V}(index, invindex, order)
end

function CategoricalPool{V, S, T <: Integer}(invindex::Dict{S, T})
    invindex = convert(Dict{S, RefType}, invindex)
    index = buildindex(invindex)
    order = buildorder(index)
    return CategoricalPool{V}(index, invindex, order)
end

# TODO: Add tests for this
function CategoricalPool{V, S, T <: Integer}(index::Vector{S}, invindex::Dict{S, T})
    invindex = convert(Dict{S, RefType}, invindex)
    order = buildorder(index)
    return CategoricalPool{V}(index, invindex, order)
end

function CategoricalPool{V, T}(index::Vector{T}, ordered::Vector{T})
    invindex = buildinvindex(index)
    order = buildorder(invindex, ordered)
    return CategoricalPool{V}(index, invindex, order)
end

function CategoricalPool{V, S, T <: Integer}(invindex::Dict{S, T}, ordered::Vector{S})
    invindex = convert(Dict{S, RefType}, invindex)
    index = buildindex(invindex)
    order = buildorder(invindex, ordered)
    return CategoricalPool{V}(index, invindex, order)
end

# TODO: Add tests for this
function CategoricalPool{V, S, T <: Integer}(index::Vector{S},
                                             invindex::Dict{S, T},
                                             ordered::Vector{S})
    invindex = convert(Dict{S, RefType}, invindex)
    index = buildindex(invindex)
    order = buildorder(invindex, ordered)
    return CategoricalPool{V}(index, invindex, order)
end

function Base.convert{V, S, T}(::Type{CategoricalPool{S}}, opool::CategoricalPool{T})
    indexS = convert(Vector{S}, opool.index)
    invindexS = convert(Dict{S, RefType}, opool.invindex)
    return CategoricalPool{V}(indexS, invindexS, opool.order)
end

Base.convert{T}(::Type{CategoricalPool}, opool::CategoricalPool{T}) = opool
Base.convert{V}(::Type{CategoricalPool{V}}, opool::CategoricalPool{V}) = opool
Base.convert{V, T}(::Type{CategoricalPool{V, T}}, opool::CategoricalPool{V, T}) = opool

function Base.show{V, T}(io::IO, opool::CategoricalPool{V, T})
    @printf(io, "CategoricalPool{%s, %s}([%s])", V, T,
            join(map(repr, levels(opool)[opool.order]), ","))
end

Base.length(opool::CategoricalPool) = length(opool.index)

Base.getindex(opool::CategoricalPool, i::Integer) = opool.valindex[i]
Base.get(opool::CategoricalPool, level::Any) = opool.invindex[level]

levels(opool::CategoricalPool) = opool.index

function Base.get!(f, opool::CategoricalPool, level)
    get!(opool.invindex, level) do
        f()
        i = length(opool) + 1
        push!(opool.index, level)
        push!(opool.order, i)
        push!(opool.valindex, OrdinalValue(i, opool))
        i
    end
end
Base.get!(opool::CategoricalPool, level) = get!(Void, opool, level)

Base.push!(opool::CategoricalPool, level) = (get!(opool, level); opool)

function Base.append!(opool::CategoricalPool, levels)
    for level in levels
        push!(opool, level)
    end
    return opool
end

function Base.delete!{V, S}(opool::CategoricalPool{V, S}, level)
    levelS = convert(S, level)
    if haskey(opool.invindex, levelS)
        ind = opool.invindex[levelS]
        delete!(opool.invindex, levelS)
        deleteat!(opool.index, ind)
        deleteat!(opool.order, ind)
        deleteat!(opool.valindex, ind)
        for i in ind:length(opool)
            opool.invindex[opool.index[i]] -= 1
        end
    end
    return opool
end

function Base.delete!(opool::CategoricalPool, levels...)
    for level in levels
        delete!(opool, level)
    end
    return opool
end

function levels!{V, S, T}(opool::CategoricalPool{V, S}, newlevels::Vector{T})
    for (k, v) in opool.invindex
        delete!(opool.invindex, k)
    end
    n = length(newlevels)
    resize!(opool.index, n)
    resize!(opool.valindex, n)
    order = buildorder(newlevels)
    resize!(order, n)
    for i in 1:n
        v = newlevels[i]
        opool.index[i] = v
        opool.valindex[i] = OrdinalValue(i, opool)
        opool.invindex[v] = i
        opool.order[i] = order[i]
    end
    return newlevels
end

function levels!{V, S, T}(opool::CategoricalPool{V, S},
                          newlevels::Vector{T},
                          ordered::Vector{T})
    if !allunique(newlevels)
        throw(ArgumentError(string("duplicated levels found: ",
                                   join(unique(filter(x->sum(newlevels.==x)>1, newlevels)), ", "))))
    end

    order = buildorder(opool.invindex, ordered)
    n = length(newlevels)
    resize!(order, n)
    for i in 1:n
        opool.order[i] = order[i]
    end
    buildvalues!(opool)
    return newlevels
end

order{T}(opool::CategoricalPool{T}) = opool.order

function order!{V, S, T}(opool::CategoricalPool{V, S}, ordered::Vector{T})
    if !allunique(ordered)
        throw(ArgumentError(string("duplicated levels found: ",
                                   join(unique(filter(x->sum(ordered.==x)>1, ordered)), ", "))))
    end
    d = symdiff(ordered, levels(opool))
    if length(d) > 0
        throw(ArgumentError(string("found levels not in existing levels or vice-versa: ",
                                   join(d, ", "))))
    end
    updateorder!(opool.order, opool.invindex, ordered)
    return ordered
end
