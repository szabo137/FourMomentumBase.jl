struct PT_ETA_PHI_M <: AbstractCoordinateSystem end

coordinate_names(::PT_ETA_PHI_M) = (:pt,:eta,:phi,:mass)

function pt end
function eta end
function phi end
function mass end

px(::PT_ETA_PHI_M,mom) = pt(mom) * cos(phi(mom))
py(::PT_ETA_PHI_M,mom) = pt(mom) * sin(phi(mom))
pz(::PT_ETA_PHI_M,mom) = pt(mom) * sinh(eta(mom))
energy(::PT_ETA_PHI_M,mom) = sqrt(px(mom)^2 + py(mom)^2 + pz(mom)^2 + mass(mom)^2)

function rapidity(::PT_ETA_PHI_M,mom)
    num = sqrt(mass(mom)^2 + pt(mom)^2 * cosh(eta(mom))^2) + pt(mom) * sinh(eta(mom))
    den = sqrt(mass(mom)^2 + pt(mom)^2)
    return log(num/den)
end

