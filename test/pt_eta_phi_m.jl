
using Random
using FourMomentumBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomMom
    pt
    eta
    phi
    m
end
coordinate_system(::CustomMom) = FourMomentumBase.PT_ETA_PHI_M()
pt(mom::CustomMom) = mom.pt
eta(mom::CustomMom) = mom.eta
phi(mom::CustomMom) = mom.phi
mass(mom::CustomMom) = mom.m

_pt,_eta,_phi,_m = rand(RNG,4)
mom_offshell = CustomMom(_pt,_eta,_phi,_m)    
mom_zero = CustomMom(0.0, 0.0, 0.0, 0.0)

@testset "momentum components" begin
    @test pt(mom_offshell) == _pt
    @test eta(mom_offshell) == _eta
    @test phi(mom_offshell) == _phi
    @test mass(mom_offshell) == _m

    @test pt(mom_zero) == 0.0
    @test eta(mom_zero) == 0.0
    @test phi(mom_zero) == 0.0
    @test mass(mom_zero) == 0.0

end

