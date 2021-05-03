
"""
    density1d(x::AbstractVector, grid::AbstractVector; normalize::Bool=True)
Compute number density on a line. Normalized such that int n dx =1.
"""
function density1d(x::AbstractVector, grid::AbstractVector; normalize::Bool=true)
    bins = length(grid) -1
    # initialize array to store number
    n = zeros(bins)
    # in a cell [a,b], particles that has a<=x<b is counted.
    # for the last cell, x==b is also counted.
    for i in 1:bins
        for position in x
            if grid[i] <=position <grid[i+1]
                n[i] += 1
            end
        end
    end
    # last cell: add particles on the right boundary
    n[end] += sum(x .== grid[end])
    # use bin centers as representative locations.
    dx = diff(grid)
    bin_centers = grid[1:end-1] + dx/2
    if normalize
        n ./= dx *length(x)
    end
    return bin_centers, n
end


"""
    density1d(x::AbstractVector, xmin::Real, xmax::Real; bins::Int=100)
Compute number density on a line. Normalized such that int n dx =1.
"""
function density1d(x::AbstractVector, xmin::Real, xmax::Real; bins::Int=100, normalize::Bool=true)
    xmin < xmax ||throw(ArgumentError("xmin>=xmax"))
    grid = LinRange(xmin, xmax, bins+1)
    return density1d(x, grid, normalize=normalize)
end


"""
    density1d(x::AbstractVector; bins::Int=100, normalize::Bool=true)
Compute number density on a line.
"""
function density1d(x::AbstractVector; bins::Int=100, normalize::Bool=true)
    xmin = minimum(x)
    xmax = maximum(x)
    return density1d(x, xmin, xmax, bins=bins, normalize=normalize)
end
