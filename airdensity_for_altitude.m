function [density] = airdensity_for_altitude(altitude)
%function [density] = airdensity_for_altitude(altitude)
%Uses Spline to calculate density for a given altitude from a table
%Input:
%   altitude: Altitude in meters to find density at
%Output:
%   density: Air density at the input altitude 

global M;
density = spline(M(:,1), M(:,2), altitude);

end

