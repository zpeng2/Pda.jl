
"""
    cart2radial(x, y, args...)

Compute radial coordinate from Cartesian.
"""
function cart2radial(x, y, args...)
	r2 = x^2 + y^2
	for arg in args
		r2 += arg^2
	end
	return sqrt(r2)
end
