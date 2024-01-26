### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# ╔═╡ 782da17e-bc42-11ee-3321-87760069d4b1
begin
	import Pkg
	Pkg.activate(@__DIR__())

	using BenchmarkTools

	Pkg.add("WhereTraits")
	using WhereTraits
end

# ╔═╡ bb69f750-360b-44cf-ae28-d93f2d92563e


# ╔═╡ 37027b1d-4ed2-40bf-87b2-71cfa0808cd1
md"## Interface using Branching"

# ╔═╡ 77c23670-49dc-4bc4-a30f-5bd2be4e2f17
begin
	function is_fourmomentum_branching end

	is_fourmomentum_branching(x::T) where T = is_fourmomentum_branching(T)

	xyze_branching(::Type{T}) where T = false
	xyze_branching(x::T) where T = xyze_branching(T)
	rhothetaphie_branching(::Type{T})  where T = false
	rhothetaphie_branching(x::T) where T = rhothetaphie_branching(T)
end

# ╔═╡ 0b17a8fb-f9a7-49e8-a5d8-c005e6a54d31


# ╔═╡ 7ba8ba77-3848-4a95-8c6e-18de2dc786fe
abstract type TestFourMomentum end

# ╔═╡ cb8e8c16-8e08-45b6-b1e8-2a422a943a0f
begin
	struct CartMomBranch{T<:Real} <: TestFourMomentum
		x::T
		y::T
		z::T
		e::T
	end

	struct SphMomBranch{T<:Real} <: TestFourMomentum
		rho::T
		theta::T
		phi::T
		e::T
	end

	is_fourmomentum_branching(::Type{M}) where M<:CartMomBranch = true
	xyze_branching(::Type{M}) where M<:CartMomBranch = true

	@inline px(p::M) where M<:CartMomBranch = p.x
	@inline py(p::M) where M<:CartMomBranch = p.y
	@inline pz(p::M) where M<:CartMomBranch = p.z
	@inline energy(p::M) where M<:CartMomBranch = p.e

	
	is_fourmomentum_branching(::Type{M}) where M<:SphMomBranch = true
	rhothetaphie_branching(::Type{M}) where M<:SphMomBranch = true

	@inline rho(p::M) where M<:SphMomBranch = p.rho
	@inline theta(p::M) where M<:SphMomBranch = p.theta
	@inline phi(p::M) where M<:SphMomBranch = p.phi
	@inline energy(p::M) where M<:SphMomBranch = p.e
	
end

# ╔═╡ 0f7f0b39-7ee2-428d-99bf-875869806e2c
@inline function _pt_cart(mom)
	x = px(mom)
	y = py(mom)
	return sqrt(x^2 + y^2)
end

# ╔═╡ 41db86da-39d1-4cd0-b192-188f28556cc1
@inline function _pt_sph(mom)
	r = rho(mom)
	t = theta(mom)
	return r*sin(t)
end

# ╔═╡ 12f23e57-f29b-4a00-95c6-c426d9d54e84
function _pt_branching(mom)
	if xyze_branching(mom)
		return _pt_cart(mom)
	end
	if rhothetaphie_branching(mom)
		return _pt_sph(mom)
	end

	raise(ArgumentError(
		"Objects of type <$(typeof(mom)) are not recognized as four-momenta."
	))
end

# ╔═╡ 349408d0-71d5-4684-b07c-12baa317bee1
cmomb = CartMomBranch(1.0,2.0,4.0,5.0)

# ╔═╡ ed4dfd96-e1fe-45bb-b2e5-f661e201919f
xyze_branching(cmomb)

# ╔═╡ 93ace14e-59e8-49cb-ad29-89c4849b5bf5
rhothetaphie_branching(cmomb)

# ╔═╡ 4c307675-1fc7-4c8a-bb2c-a36626efb655
@benchmark _pt_branching($cmomb)

# ╔═╡ 133287db-2e88-438b-a8e6-f79ca1885200
@benchmark _pt_cart($cmomb)

# ╔═╡ 7b9338fa-5cb6-475e-ae56-943e2efeed37
@code_warntype _pt_branching(cmomb)

# ╔═╡ 6427dbba-85d2-42f6-93d6-856846e16ec2
@code_lowered _pt_branching(cmomb)

# ╔═╡ baba1575-ca8a-4dae-a2fd-4a84db1a909a
@code_llvm _pt_branching(cmomb)

# ╔═╡ 28d52368-383f-41f8-9097-4d2481e240c9


# ╔═╡ bad434a7-2f02-4df6-ade2-0498faf3eb3d
smomb = SphMomBranch(3.0,0.5,0.2,4.0)

# ╔═╡ 1dd0db93-f864-43f4-b79d-e1bc9a50d610
rhothetaphie_branching(smomb)

# ╔═╡ 7c77b520-55ee-416f-9d66-604f2509917a
xyze_branching(smomb)

# ╔═╡ 3393208f-5a05-478a-8635-6e77a7832f8b
@benchmark _pt_branching($smomb)

# ╔═╡ 979a2c59-16bd-4e3a-842e-f61342986c02
@benchmark _pt_sph($smomb)

# ╔═╡ d1fdcf23-9f0a-4282-892b-5292ef83a6ef
@code_warntype _pt_branching(smomb)

# ╔═╡ fb3019a1-4c7d-48f3-8cab-2813e36196e6
@code_llvm _pt_branching(smomb)

# ╔═╡ d45d07a8-a90c-4bda-bc23-dcc6efb59f5d
md"# Interface using dispatch"

# ╔═╡ 7f62e9c8-45aa-4aa9-aad6-a5f1bce04c52
begin
	abstract type CS end

	struct XYZE <: CS end

	struct RHO_THETA_PHI_E <: CS end

	function coord_sys end

	function pt_traits end
	
end

# ╔═╡ 3768d801-7214-458c-a2da-fa886de0aaf7


# ╔═╡ eb118d88-3602-421c-9265-e86048e431bb
begin
	@inline coord_sys(::T) where T<:CartMomBranch = XYZE()
	@inline coord_sys(::T) where T<:SphMomBranch = RHO_THETA_PHI_E()
end

# ╔═╡ 8f66b5d9-14ad-445d-9705-ffd4631a8f00
begin
	pt_traits(mom) = pt_traits(coord_sys(mom),mom) # dispatch on a given coordsystem
	
	pt_traits(::XYZE, mom) =  sqrt(px(mom)^2 + py(mom)^2)
	pt_traits(::RHO_THETA_PHI_E, mom) = rho(mom)*sin(theta(mom))
end

# ╔═╡ e16b772c-344c-41b0-b898-749b8cd5c004
cmomt = CartMomBranch(2,3,4,5)

# ╔═╡ f56f99a2-3c79-4fe6-9cc3-218934731759
@benchmark pt_traits($cmomt)

# ╔═╡ 1e400535-18b4-4615-884d-351e7248f2d0
@benchmark _pt_branching($cmomb)

# ╔═╡ cea1d927-c5ee-48a0-91c0-ec20f602f2fe
@code_native pt_traits(cmomt)

# ╔═╡ e0b01d50-f302-460c-baa0-291bc5a7119c
@code_native _pt_branching(cmomt)

# ╔═╡ 242ccb36-7b56-4474-a815-1a40a3b41610
@benchmark pt_traits($smomb)

# ╔═╡ d173c9d2-ce84-42d0-8bc3-aab21ad0c40d
@benchmark _pt_branching($smomb)

# ╔═╡ Cell order:
# ╠═782da17e-bc42-11ee-3321-87760069d4b1
# ╠═bb69f750-360b-44cf-ae28-d93f2d92563e
# ╟─37027b1d-4ed2-40bf-87b2-71cfa0808cd1
# ╠═77c23670-49dc-4bc4-a30f-5bd2be4e2f17
# ╠═0f7f0b39-7ee2-428d-99bf-875869806e2c
# ╠═0b17a8fb-f9a7-49e8-a5d8-c005e6a54d31
# ╠═41db86da-39d1-4cd0-b192-188f28556cc1
# ╠═12f23e57-f29b-4a00-95c6-c426d9d54e84
# ╠═7ba8ba77-3848-4a95-8c6e-18de2dc786fe
# ╠═cb8e8c16-8e08-45b6-b1e8-2a422a943a0f
# ╠═349408d0-71d5-4684-b07c-12baa317bee1
# ╠═ed4dfd96-e1fe-45bb-b2e5-f661e201919f
# ╠═93ace14e-59e8-49cb-ad29-89c4849b5bf5
# ╠═4c307675-1fc7-4c8a-bb2c-a36626efb655
# ╠═133287db-2e88-438b-a8e6-f79ca1885200
# ╠═7b9338fa-5cb6-475e-ae56-943e2efeed37
# ╠═6427dbba-85d2-42f6-93d6-856846e16ec2
# ╠═baba1575-ca8a-4dae-a2fd-4a84db1a909a
# ╠═28d52368-383f-41f8-9097-4d2481e240c9
# ╠═bad434a7-2f02-4df6-ade2-0498faf3eb3d
# ╠═1dd0db93-f864-43f4-b79d-e1bc9a50d610
# ╠═7c77b520-55ee-416f-9d66-604f2509917a
# ╠═3393208f-5a05-478a-8635-6e77a7832f8b
# ╠═979a2c59-16bd-4e3a-842e-f61342986c02
# ╠═d1fdcf23-9f0a-4282-892b-5292ef83a6ef
# ╠═fb3019a1-4c7d-48f3-8cab-2813e36196e6
# ╠═d45d07a8-a90c-4bda-bc23-dcc6efb59f5d
# ╠═7f62e9c8-45aa-4aa9-aad6-a5f1bce04c52
# ╠═3768d801-7214-458c-a2da-fa886de0aaf7
# ╠═8f66b5d9-14ad-445d-9705-ffd4631a8f00
# ╠═eb118d88-3602-421c-9265-e86048e431bb
# ╠═e16b772c-344c-41b0-b898-749b8cd5c004
# ╠═f56f99a2-3c79-4fe6-9cc3-218934731759
# ╠═1e400535-18b4-4615-884d-351e7248f2d0
# ╠═cea1d927-c5ee-48a0-91c0-ec20f602f2fe
# ╠═e0b01d50-f302-460c-baa0-291bc5a7119c
# ╠═242ccb36-7b56-4474-a815-1a40a3b41610
# ╠═d173c9d2-ce84-42d0-8bc3-aab21ad0c40d
