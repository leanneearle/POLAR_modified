%% Description:
%   Example showing the influence of lengthscales on the learning
%   performance


%% Description:
%   Example showing the influence of lengthscales on the learning
%   performance

%% Setup:
toolbox_addpath
settings = setupLearning;
settings.save_folder = 'compare_lengthscales';
settings.feedback.types = 1; % does not matter here which feedback is used

%% Visualize three different lengthscales

l_choices = [0.1 1 3 6 9];  % lengthscales to compare
l_choices = [6];

for i = 1:length(l_choices)
   settings.parameters.lengthscale = l_choices(i);
   alg = PBL(settings);
   f = figure(i);
   alg.testLengthscales(f);
   f.Children.Children.Title.String = sprintf('lengthscale = %2.1f',l_choices(i));
end

%% Run learning for three different lengthscales:
n_iters = 50;
n_runs = 50;

settings.save_folder = 'compare_lengthscales';
compObj = Compare( settings,n_runs,...
                  'iters',n_iters,...
                  'lengthscales',num2cell(l_choices));

