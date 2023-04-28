%% Script: run_simulation
%
% Description: demonstrate POLAR toolbox on a 1D function through
% simulations and example experiment
%
% Author: Maegan Tucker, mtucker@caltech.edu
% Date: August 9, 2021
% 
% Modified: 
%     Modiefier: Leanne Earle
%     Date: April 27, 2023
%
% ________________________________________

clear; clc;

%% Setup Learning

% load settings from setupLearning function
settings = setupLearning;

% override or add new settings
%   save folder
settings.save_folder = '1D_results';  % subfolder to save results to
%   parameters
settings.feedback.types = 4;  % feedback method: 1 = preference, 4 = strong preference
settings.simulation.simulated_pref_noise = 0.02;  % simulated noise for preference and strong preference feedback (ie. percent likelihood of incorrect simulated pref)
settings.simulation.simulated_strong_pref_threshold = 0.5;  % difference in reward threshold for strong preferences
settings.maxIter = 50;  % choose max number of iterations to run


settings.sampling.type = 1;
%instanteate toolbox class object
alg = PBL(settings); 

% plot the true objective function, define in ObjectiveFunction.m
plotting.plotTrueObjective(alg,3);


%% run simulations

% override or add new settings if desired
alg.settings.maxIter = 15; % number of iterations to run

% run the simulations
isPlotting = 0; % flag for plotting each iteration during simulation run
isSave = 0; % flag for saving the results in folder
alg.runSimulation(isPlotting,isSave); %run simulation


%% plotting options

% Plot Underlying Objective Function
plotting.plotTrueObjective(alg,3);

% Plot Metrics of Learning Performance for Synthetic Results
plotting.plotMetrics(alg);

% Plot Learned Underlying Landscape
plotting.plotPosterior(alg);


%% run comparisons 
% examples for all comparisons relevant to preference feedback
% comment out the comparisons you don't wish to run

% comparison setting parameters
num_runs = 50;  % number of runs to simulate then average over
max_iters = 20;  % number of iterations per run

% compare effect of feedback type
settings.save_folder = 'compare_feedback_types';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'feedback_types',{1,4});

% compare effect of lengthscale
lengthscales = [0.1 4 8 12];  % values to test
settings.save_folder = 'compare_lengthscales';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'lengthscales', num2cell(lengthscales));

% compare effect of GP preference noise hyperparameter
GP_pref_noises = [0.02 0.1 0.2];  % values to test
settings.save_folder = 'compare_GP_pref_noise';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'post_pref_noise', num2cell(GP_pref_noises));

% compare effect of simulated preference noise
sim_pref_noises = [0.02 0.1 0.2 0.3];  % values to test
settings.save_folder = 'compare_sim_pref_noise';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'post_pref_noise', num2cell(sim_pref_noises));


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






