function settings = setupLearning

% ------------------------ Feedback Settings  -----------------------------

% feedback method to use: 1 = preference, 4 = strong preference
settings.feedback.types = 1;


% -------------- Learning Algorithm Settings ------------------------------

settings.maxIter = 50;  % choose max number of iterations to run

settings.b = 1;  % Number of previous actions to compare against - generally use 1
settings.n = 1;  % Number of actions to sample - generally use 1

settings.sampling.type = 1;  % 1 for regret minimization, 2 for information gain
settings.useSubset = 0;  % 0 = no subset (for low dimensional cases), 1 = subset (for high dimensional applications)
settings.isNormalize = 1; % 1 = reward is normalized, 0 = not normalized


% -------------- Action Space Properties (need to be selected) ------------

% Define the parameter's proprties
settings.parameters(1).name = 'torque';  % Parameter name
settings.parameters(1).discretization = 1;  % How far apart is each action 
settings.parameters(1).lower = 6;  % Parameter lower bound
settings.parameters(1).upper = 26; % Parameter upper bound
settings.parameters(1).lengthscale = 8; % How smooth do you expect the reward function to be? 


% --------------------- Learning Hyperparameters --------------------------
settings.gp_settings.linkfunction = 'sigmoid';
settings.gp_settings.signal_variance = 1;   % Gaussian process amplitude parameter
settings.gp_settings.pref_noise = 0.02;    % How noisy are the user's preferences?
settings.gp_settings.GP_noise_var = 1e-3;        % GP model noise-- need at least very small, 1e-3 is good

% --------------------- Simulation Settings ----------------------------------
settings.useSyntheticObjective = 1;  % use the define reward function in ObjectiveFunction.m
settings.maxIter = 25;  % The number of iterations used in the simulations


