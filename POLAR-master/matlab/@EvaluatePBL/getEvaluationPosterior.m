function [eval_gp_mean,eval_gp_inds] = getEvaluationPosterior(alg,evaluation_posterior_size)
% Description: compute new posterior over more actions in order to evaluate the
%   metrics associated with the learned posterior
% Inputs:
%   alg = preference-based learning algorithm object
%   evaluation_posterior_size = 1x1 = min(100,alg.settings.num_actions);
% Outputs:
%   eval_gp_mean = (num_new_actions)x1 estimated reward function
%   eval_gp_mean = (num_new_actions)x1 vector

%% Get posterior over existing actions and new actions
num_new_points = min(evaluation_posterior_size,alg.settings.num_actions);
randInds = randsample(1:alg.settings.num_actions,num_new_points);
actions = [alg.unique_visited_actions; alg.settings.points_to_sample(randInds,:)];

% get feedback and get posterior
pref_data = alg.feedback.preference.x_subset;
pref_labels = alg.feedback.preference.y;
coac_data = alg.feedback.coactive.x_subset;
coac_labels = alg.feedback.coactive.y;
ord_data = alg.feedback.ordinal.x_subset;
ord_labels = alg.feedback.ordinal.y;
strong_pref_data = alg.feedback.strong_preference.x_subset;  % -- NORTHEASTERN --
strong_pref_labels = alg.feedback.strong_preference.y;  % -- NORTHEASTERN --

% Compute GP
gp = GP(alg.settings.gp_settings,...
    actions, ...
    [],...
    pref_data, pref_labels,...
    coac_data, coac_labels,...
    ord_data, ord_labels,...
    strong_pref_data, strong_pref_labels,...  % -- NORTHEASTERN --
    [], [], []);

%% Restrict GP to only the new actions
eval_gp_mean = gp.mean(end-num_new_points+1:end);
eval_gp_inds = randInds;

end

