%% Script: run_simulation
%
% Description: demonstrate POLAR toolbox on a 2D function through
% simulations
%
% ________________________________________

clear all; clc

%% Setup Learning

% Load settings
settings = setupLearning;

% override or add new settings if desired
%   save folder
settings.save_folder = '2D_results';  % subfolder to save results to
%   parameters
settings.feedback.types = 4;  % feedback method: 1 = preference, 4 = strong preference
settings.simulation.simulated_pref_noise = 0.1;  % simulated noise for preference and strong preference feedback (ie. percent likelihood of incorrect simulated pref)
settings.simulation.simulated_strong_pref_threshold = 0.5;  % difference in reward threshold for strong preferences
settings.maxIter = 50;  % choose max number of iterations to run

% instanteate toolbox class object
alg = PBL(settings); 


%% Run Simulations
alg.reset;
isPlotting = 0; isSave = 1;
alg.runSimulation(isPlotting,isSave); %run simulation

%% PLotting

% Plot Underlying Objective Function
plotting.plotTrueObjective(alg,3);

% Plot Metrics of Learning Performance for Synthetic Results
plotting.plotMetrics(alg);

% Plot Learned Underlying Landscape (only the last iteration estimate)
plotting.plotPosterior(alg, isSave);

% Plot Learned Underlying Landscape for each iteration
plotting.plotPosterior(alg,isSave,length(alg.iteration));


%% run comparisons 
% examples for all comparisons relevant to preference feedback
% comment out the comparisons you don't wish to run

% comparison setting parameters
num_runs = 25;  % number of runs to simulate then average over
max_iters = 25;  % number of iterations per run

% compare effect of feedback type
settings.save_folder = 'compare_feedback_types';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'feedback_types',{1,4});

% compare effect of lengthscale
lengthscales = [0.5 2 6 10 15]; % values to test
settings.save_folder = 'compare_lengthscales';
compObj = Compare( settings,num_runs,...
                  'iters',max_iters,...
                  'lengthscales', num2cell(lengthscales));

% compare effect of GP preference noise hyperparameter
GP_pref_noises = [0.05 0.1 0.2 0.25];  % values to test
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
