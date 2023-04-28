%% Function: setupLearning
%
% Description: This script establishes the parameters and settings of the
%   learning problem.

% Experiment: 2D Parameters on a treadmill while walking at a constant
% speed
%       Parameter 1 = BPM the subject must walk at (using a metronome)
%       Parameter 2 = Treadmill speed & incline combination number, as
%       defined in the papaer
%
% ________________________________________

function [ settings ] = setupLearning()


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

% Dimension 1 
ind = 1;
settings.parameters(ind).name = 'bpm';  % Parameter name
settings.parameters(ind).discretization = 4;  % How far apart is each action
settings.parameters(ind).lower = 90;  % Parameter lower bound
settings.parameters(ind).upper = 116;  % Parameter upper bound 
settings.parameters(ind).lengthscale = 8; % How smooth do you expect the reward function to be

% Dimension 1 
ind = ind+1;
settings.parameters(ind).name = 'speed_incline';  % Parameter name
settings.parameters(ind).discretization = 1;  % How far apart is each action
settings.parameters(ind).lower = 1;  % Parameter lower bound
settings.parameters(ind).upper = 10;  % Parameter upper bound
settings.parameters(ind).lengthscale = 8;  % How smooth do you expect the reward to be


% --------------------- Learning Hyperparameters --------------------------

settings.gp_settings.linkfunction = 'sigmoid';
settings.gp_settings.signal_variance = 1;   % Gaussian process amplitude parameter
settings.gp_settings.pref_noise = 0.05;    % How noisy are the user's preferences?
settings.gp_settings.GP_noise_var = 1e-3;        % GP model noise--need at least a very small


% -------------------- Posterior Sampling Settings  -----------------------

% choose regret minimization (1) or active learning (2)
settings.sampling.type = 1 %2;

% choose settings of regret minimization
switch settings.sampling.type
    case 1
        settings.gp_settings.cov_scale = 0.5;
        settings.sampling.useSubset = 0; % 0 = no, 1 = yes
        settings.sampling.isCoordinateAligned = 0; %choose if random linear subspace is coordinate aligned
    case 2
        settings.sampling.useSubset = 1; %true or false
        settings.sampling.subsetSize = 100; %choose subset size
        
        % Region of Avoidance (ordinal categories to avoid)
        settings.roa.use_roa = 0; %true or false
end


% --------------------- CUSTOM SETTINGS -----------------------------------
settings.objective_settings = [];
end