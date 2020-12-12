"""get_h5attr(f::AbstractString, attr::AbstractString)
Get an attribute from H5 file.
"""
function get_h5attr(f::AbstractString, attr::AbstractString)
    HDF5.h5open(f, "r") do h5io
        return HDF5.attrs(h5io)[attr] |> read
    end
end


function get_h5attr(f::AbstractString, symbol::Symbol)
    return get_attr(f, String(symbol))
end

"""get_h5data(f::AbstractString, path::AbstractString)
Get a dataset from H5 file.
"""
function get_h5data(f::AbstractString, path::AbstractString)
    HDF5.h5open(f, "r") do h5io
        return h5io[path] |> read
    end
end


