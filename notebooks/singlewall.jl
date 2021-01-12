### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ f38a5752-3e3e-11eb-256c-eb1f8de56937
begin
	import Pda
	using Plots
	using PlutoUI
	using HDF5
	using Statistics
end

# ╔═╡ 09068b50-3e3f-11eb-330c-ab8cf9ce1600
file = "/media/HDD1/singlewall/U2.154singlewall.h5"

# ╔═╡ 14f7b2da-3e40-11eb-1aca-593125a5c40c
frame =99

# ╔═╡ a7c0b072-3e3f-11eb-1498-4343ce3bfccc
begin
	t = Pda.get_h5data(file, "config/$(frame)/t")
	x = Pda.get_h5data(file, "config/$(frame)/x")
end

# ╔═╡ be7aa564-3e41-11eb-343a-6f8d2a3367e9
function average_density()
	bins=100
	n = zeros(bins)
	loc = zeros(bins)
	for i in 0:99
		loc, n_ = Pda.density1d(Pda.get_h5data(file, "config/$(i)/x"),
			bins=bins,
			normalize=false)
		n += n_
	end
	return loc, n
end

# ╔═╡ 2bed370c-3e41-11eb-1fb8-c7f187b21521
loc,n = average_density()

# ╔═╡ 7e1e3a7a-3e42-11eb-06c8-679cebbbc9ec
function density_Qclosure(x, Pel::Real)
	laml = sqrt(Pel+0.5*Pel^2)
	n = 1 + 0.5*Pel*exp(-laml*x)
	return n
end

# ╔═╡ abfa5be6-3e41-11eb-0c1a-4d5d565887d3
begin
	scatter(loc[2:end-1],n[2:end-1]/(n[end-10:end-1] |>mean),
		framestyle=:box,
		label="BD")
	U0 = Pda.get_h5attr(file, "U0")
	tauR = Pda.get_h5attr(file, "tauR")
	DT = Pda.get_h5attr(file,"DT")
	Pel = (U0*tauR/sqrt(DT*tauR))^2
	plot!(loc, density_Qclosure.(loc, Pel),
		lw=2,
		label="Q closure")
end

# ╔═╡ Cell order:
# ╠═f38a5752-3e3e-11eb-256c-eb1f8de56937
# ╠═09068b50-3e3f-11eb-330c-ab8cf9ce1600
# ╠═14f7b2da-3e40-11eb-1aca-593125a5c40c
# ╠═a7c0b072-3e3f-11eb-1498-4343ce3bfccc
# ╠═be7aa564-3e41-11eb-343a-6f8d2a3367e9
# ╠═2bed370c-3e41-11eb-1fb8-c7f187b21521
# ╠═7e1e3a7a-3e42-11eb-06c8-679cebbbc9ec
# ╠═abfa5be6-3e41-11eb-0c1a-4d5d565887d3
