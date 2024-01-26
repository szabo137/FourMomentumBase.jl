
using Random
using FourMomentumBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomMom
    x
    y
    z
    e
end

coordinate_system(::CustomMom) = FourMomentumBase.XYZE()
px(mom::CustomMom) = mom.x
py(mom::CustomMom) = mom.y
pz(mom::CustomMom) = mom.z
energy(mom::CustomMom) = mom.e

x, y, z = rand(RNG, 3)
m = rand(RNG)
E = sqrt(x^2 + y^2 + z^2 + m^2)
mom_onshell = CustomMom(x, y, z, E)
mom_zero = CustomMom(0.0, 0.0, 0.0, 0.0)
mom_offshell = CustomMom(m, 0.0, 0.0, 0.0)

@testset "momentum components" begin
    @test energy(mom_onshell) == E
    @test px(mom_onshell) == x
    @test py(mom_onshell) == y
    @test pz(mom_onshell) == z

    @test energy(mom_zero) == 0.0
    @test px(mom_zero) == 0.0
    @test py(mom_zero) == 0.0
    @test pz(mom_zero) == 0.0
end
