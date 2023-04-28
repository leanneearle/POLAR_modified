function obj = ObjectiveFunction(~,action)

% Important: action must be nxdim where n is the number of actions being
% evaluated and dim is the dimensionality of each action

% Description of Objective Function:
%   Bivariate Gaussian distribution - 3D bell curve with covariance

x = action(:,1);
y = action(:,2);

mu_x = 14; 
sigma_x = 5; 

mu_y = 54; 
sigma_y = 5; 

cov = 0.5;

rho = cov/(sigma_x*sigma_y);

z = (x - mu_x).^2 / sigma_x^2 + (y - mu_y).^2 / sigma_y^2 ...
    - (2 * rho * (x - mu_x) .* (y - mu_y)) / (sigma_x * sigma_y);

obj = exp(-z ./ (2 * (1 - rho^2)));

end