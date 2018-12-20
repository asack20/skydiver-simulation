function [dy] = skydiving_diffeq(t, y, Cd, A, m)
%function [dy] = skydiving_diffeq(t, y, Cd, A, m)
%Differential equation used by ode45 
%Inputs:
%   t: time
%   y: vector representing position and velocity
%   Cd: Drag Coefficient
%   A: Area
%   m: mass of skydiver
%Output:
%   dy: vector representing derivative of position and velocity

% Constants
r_earth = 6.371 * 10^6; %m
m_earth = 5.9722 * 10^24;%kg
G = 6.67384 * 10^-11; %m^3/kg*s^2

dy(1, 1) = y(2);
dy(2, 1) = -G .* m_earth ./ (r_earth + y(1)).^2 + ...
    (airdensity_for_altitude(y(1)) .* y(2).^2 .* Cd .* A) ./ (2.*m);

end

