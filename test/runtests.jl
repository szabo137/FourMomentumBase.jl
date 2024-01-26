using FourMomentumBase
using Test
using JET

@testset "FourMomentumBase.jl" begin
    @testset "Code linting (JET.jl)" begin
        JET.test_package(FourMomentumBase; target_defined_modules=true)
    end
    # Write your tests here.
end
