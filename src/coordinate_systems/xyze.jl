struct XYZE <: AbstractCoordinateSystem end
coordinate_names(::XYZE) = (:px,:py,:pz,:energy)

function px end
function py end
function pz end
function energy end

@inline function _magnitude(mom)
    return px(mom)^2 + py(mom)^2 + pz(mom)^2
end

@inline function _cos_theta(mom)
    r = _magnitude(mom)
    return r == zero(r) ? one(r) : pz(mom) / r
end

function _pt2(mom)
    return px(mom)^2 + py(mom)^2
end

function pt(::XYZE, mom)
    return sqrt(pt2(mom))
end

function pseudorapidity(::XYZE,mom)
    cth = _cos_theta(mom)
    
    if cth^2 < one(cth)
        return -0.5*log((1-cth)/(1+cth))
    end

    z = pz(mom)
    if iszero(z)
        return zero(z)
    end

    @warn "Pseudorapidity: transverse momentum is zero! return +/- 10e10"
    if z > zero(z)
        return 10e10
    end
        
    return 10e-10
end

function rapidity(::XYZE,mom)
    E = energy(mom)
    z = pz(mom)
    return 0.5 * log((E + z) / (E - z))
end

function phi(::XYZE,mom) 
    n = zero(getX(mom))
    x = px(mom)
    y = py(mom)
    return x == n && y == n ? n : atan(y, x)
end

mass(::XYZE,mom) = sqrt(_magnitude(mom))
