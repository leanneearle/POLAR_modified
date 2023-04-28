%% Script: run_experiment
%
% Description: demonstrate POLAR toolbox on a 2D function through
% an example experiment
%
% ________________________________________

clear all; clc;


%% Setup Learning

% Load settings
settings = setupLearning;

% override or add new settings if desired
%   save folder
settings.save_folder = '2D_experiment_results';  % subfolder to save results to
%   parameters
settings.feedback.types = 4;  % feedback method: 1 = preference, 4 = strong preference
settings.maxIter = 50;  % choose max number of iterations to run

% instanteate toolbox class object
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
