
abstract type AbstractCoordinateSystem end

"""
    coordinate_names(::AbstractCoordinateSystem)::Tuple{Symbols}

"""
function coordinate_names end

"""

    coordinate_system(::MomType)::CS where {CS <: AbstractCoordinateSystem}

"""
function coordinate_system end

pt(mom) = pt(coordinate_system(mom), mom)
pseudorapidity(mom) = pseudorapidity(coordinate_system(mom), mom)
const eta = pseudorapidity
rapidity(mom) = rapidity(coordinate_system(mom), mom)
phi(mom) = phi(coordinate_system(mom), mom)
energy(mom) = energy(coordinate_system(mom), mom)
mass(mom) = mass(coordinate_system(mom), mom)
px(mom) = px(coordinate_system(mom), mom)
py(mom) = py(coordinate_system(mom), mom)
pz(mom) = pz(coordinate_system(mom), mom)
