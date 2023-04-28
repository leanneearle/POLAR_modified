
function obj = ObjectiveFunction(~, action)


% x = torque magnitude
x = action(:,1);
mu_x = 14;
sigma_x = 1.7;

% y = torque timing
y = action(:,2);
mu_y = 54;
sigma_y = 1.5;

% covariance
cov = 5;


% calculate bivariate gaussian distribution

rho = cov/(sigma_x*sigma_y);

z = (x - mu_x).^2 / sigma_x^2 + (y - mu_y).^2 / sigma_y^2 ...
    - (2 * rho * (x - mu_x) .* (y - mu_y)) / (sigma_x * sigma_y);

obj = 1 / (2 * pi * sigma_x * sigma_y * sqrt(1 - rho^2)) * exp(-z ./ (2 * (1 - rho^2)));


end

