function [accel] = skydiving_accel(x, v, Cd, A, m)
%function [accel] = skydiving_accel(x, v, Cd, A, m)
%Calculate acceleration for a given altitude and velocity
%Inputs:
%   x: position
%   v: velocity
%   Cd: Drag Coefficient
%   A: Area
%   m: mass of skydiver
%Output:
%   accel: acceleration

% Constants
r_earth = 6.371 * 10^6; %m
m_earth = 5.9722 * 10^24;%kg
G = 6.67384 * 10^-11; %m^3/kg*s^2

accel = -G .* m_earth ./ (r_earth + x).^2 + ...
    (airdensity_for_altitude(x) .* v.^2 .* Cd .* A) ./ (2.*m);

end

