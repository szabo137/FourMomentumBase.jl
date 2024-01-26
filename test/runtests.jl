using FourMomentumBase
using Test
using SafeTestsets 

begin
    @time @safetestset "xyze" begin
        include("xyze.jl")
    end
        
    @time @safetestset "pt_eta_phi_m" begin
        include("pt_eta_phi_m.jl")
    end

end
