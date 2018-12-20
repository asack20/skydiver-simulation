function [detect, stopint, direct]=heightevent(t, y, offset)
%function [detect, stopint, direct]=heightevent(t, y, offset)
% Locate the time when height passes through offset
% and stop integration.
%Inputs:
%   t: time
%   y: vector of position and velocity
%   offset: height to stop ODE at
%Outputs:
%   detect: stop ODE when it equals 0. When height = offset
%   stopint: 1 to stop integration
%   direct: 0 because Direction does not matter

    detect = y(1) - offset; % stop when detect = 0
    stopint = 1; % Stop the integration
    direct = 0; % Direction does not matter
end