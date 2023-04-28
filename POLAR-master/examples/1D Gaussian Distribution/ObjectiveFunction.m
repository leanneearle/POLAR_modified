function [objectives] = ObjectiveFunction(~,action)
% Important: action must be nxdim where n is the number of actions being
% evaluated and dim is the dimensionality of each action

% Description of Objective Function:
%   Gaussian distribution (ie. bell curve)


mu = 14; 
std = 5; 

objectives = 1/(std * sqrt(2 * pi)) .* exp(-(action(:,1) - mu).^2 /( 2*std^2));

end

