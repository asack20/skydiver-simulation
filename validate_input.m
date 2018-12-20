function [isValid] = validate_input(height, mass, Cd1, A1, Cd2, A2, h_dep)
%function [isValid] = validate_input(height, mass, Cd1, A1, Cd2, A2, h_dep)
%Checks that all user inputs are valid
%Inputs:
%   height - user inputed height
%   mass - user inputed mass
%   Cd1 - user inputed Cd_man
%   A1 - user inputed area_man
%   Cd2 - user inputed Cd_par
%   A2 - user inputed area_par
%   h_dep - user inputed h_deploy
%Output:
%   isValid - True if all inputs are valid, else false
isValid = true;

% Check everything is a number
if isempty(height) || isempty(mass) || isempty(Cd1) || isempty(A1) || ...
        isempty(Cd2) || isempty(A2) || isempty(h_dep)
    isValid = false;
    return;
% Check everything is positive
elseif height <= 0 || mass <= 0 || Cd1 <= 0 || A1 <= 0 ||...
        Cd2 <= 0 || A2 <= 0 || h_dep <=0
    isValid = false;
% Check heights are valid
elseif height > 85000 || h_dep >= height
    isValid = false;
end

end

