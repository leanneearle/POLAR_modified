%% Function: setupLearning
%
% Experiment: 2D Parameters on a treadmill while walking at a constant
% speed
%       Parameter 1 = BPM the subject must walk at (using a metronome)
%       Parameter 2 = Treadmill speed & incline combination number, as
%       defined in the papaer
%
% ________________________________________

clear all; clc;

%% Setup learning

% load settings
settings = setupLearning;

% save folders
settings.save_folder = 'treadmill_experiment';

%instanteate toolbox class object
alg = PBL(settings);


%% run experiment
%  will suggest a new option and prompt for feedback until the user
%  specifies to end the experiment by entering '-1' instead of a feedback
%  value 
% user inputs to the comand window:
%   standard preference feedback options = (1, 2, 0)
%   strong preference feedback options = (1, 2, 11, 22, 0)

plottingFlag = 0; %flag for showing plots during experiment 
isSave = 1; % flag for saving results
alg.runExperiment(plottingFlag,isSave);  % run


%% validate experiment (optional) 
% compares the estimated best action with another random action 
% will automatically stop after the number of validation trials is met

num_validation_trials = 3;  % number of additional trials for validation comparisons
validation = Validation(alg,num_validation_trials);  % run


%% plotting estimated reward

% Plot Learned Underlying Landscape
plotting.plotPosterior(alg);

