using FourMomentumBase
using Test
using Aqua
using JET

@testset "FourMomentumBase.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(FourMomentumBase)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(FourMomentumBase; target_defined_modules = true)
    end
    # Write your tests here.
end
