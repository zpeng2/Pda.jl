# abstract type AbstractDensity end


# struct LineDensity{T} <: AbstractDensity
#     x::Vector{T}
#     N::Int
#     bins::Int
#     function LineDensity(x::Vector{<:Real}; bins::Int=100)
#         T = eltype(x)
#         N = length(x)
#         return new{T}(x, N, bins)
#     end
# end

"""
    polar1d(y::AbstractVector, theta::AbstractVector, grid::AbstractVector; normalize::Bool=True)
Compute polar order across channel. Normalized such that int n dy =1.
"""
function polar1d(y::AbstractVector, theta::AbstractVector, grid::AbstractVector; normalize::Bool=true)
    bins = length(grid) -1
    # initialize array to store number
    n = zeros(bins); np = zeros(bins);
    m = zeros(bins); mp = zeros(bins);
    # in a cell [a,b], particles that has a<=y<b is counted.
    # for the last cell, y==b is also counted.
    for i in 1:bins
        for (position, angle) in zip(y, theta)
            if grid[i] <=position <grid[i+1]
                n[i] += 1; m[i] += sin(angle);
                if angle<pi
                    np[i] += 1; mp[i] += sin(angle);
                end
            end
        end
    end
    # last cell: add particles on the right boundary
    ind=findall(y->y==grid[end], y)
    for angle in y[ind]
        m[end] += sin(angle);
        if angle<pi
            np[i] += 1; mp[i] += sin(angle);
        end
    end
    n[end] += length(ind)

    # use bin centers as representative locations.
    dy = diff(grid)
    bin_centers = grid[1:end-1] + dy/2
    ind = findall(n->n>0, n)
    m[ind] ./= n[ind]
    ind = findall(np->np>0, np)
    mp[ind] ./= np[ind]
    if normalize
        n ./= dy *length(y)
        np ./= dy*length(y)
    end
    return bin_centers, n, np, m, mp
end


"""
    polar1d(y::AbstractVector, theta::AbstractVector, ymin::Real, ymax::Real; bins::Int=100)
Compute polar order across channel. Normalized such that int n dy =1.
"""
function polar1d(y::AbstractVector, theta::AbstractVector, ymin::Real, ymax::Real; bins::Int=100, normalize::Bool=true)
    ymin < ymax ||throw(ArgumentError("ymin>=ymax"))
    grid = LinRange(ymin, ymax, bins+1)
    return polar1d(y, grid, normalize=normalize)
end


"""
    polar1d(y::AbstractVector, theta::AbstractVector; bins::Int=100, normalize::Bool=true)
Compute polar order across channel.
"""
function polar1d(y::AbstractVector, theta::AbstractVector; bins::Int=100, normalize::Bool=true)
    ymin = minimum(y)
    ymax = maximum(y)
    return polar1d(y, ymin, ymax, bins=bins, normalize=normalize)
end
