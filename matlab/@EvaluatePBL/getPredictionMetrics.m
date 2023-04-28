function metrics = getPredictionMetrics(metrics,evaluation_posterior_size,alg,iteration)
% Description: get prediction fit errors
% Inputs:
%   metrics = {1x1} cell containing 8 metrics evaluations
%   evaluation_posterior_size = 1x1 = min(100,alg.settings.num_actions);
%   alg = preference-based learning algorithm object
%   iteration = iteration #

if nargin < 4
    iteration = length(alg.iteration);
end
          
% Get true objective associated with best action
if alg.settings.useSyntheticObjective
    
    %% Compute error of predicted preference landscape 
    if alg.settings.useSubset

        % get evaluation gp:
        if alg.settings.sampling.type == 2

            %  Use posterior over random subset (updated previously for IG)
            num_new_points = alg.settings.subsetSize;
            gp = alg.post_model(iteration);
            eval_gp_inds = gp.action_globalInds(end-num_new_points+1:end);
            eval_gp_mean = gp.mean(end-num_new_points+1:end);

        else

            % Get new posterior since existing one doesn't have enough
            % points
            num_new_points = evaluation_posterior_size;
            [eval_gp_mean,eval_gp_inds] = metrics.getEvaluationPosterior(alg,evaluation_posterior_size);
            
        end

        % Get true posterior mean:
        true_mean = alg.settings.simulation.true_objectives(eval_gp_inds);

        % Use GP to predict ordinal labels
        predicted_labels = metrics.predictLabels(alg,eval_gp_mean);
        true_labels = alg.settings.simulation.true_ordinal_labels(eval_gp_inds);
        
        % preference predictions
        comparisons = nchoosek(1:num_new_points,2);
        
    else 
        %%% use posterior over all points as eval gp
        
        % Use full gp from alg
        eval_gp = alg.post_model(iteration);
                
        % posterior values
        eval_gp_mean = eval_gp.mean;
        true_mean = alg.settings.simulation.true_objectives;
        
        % posterior labels
        predicted_labels = metrics.predictLabels(alg,eval_gp_mean);
        true_labels = alg.settings.simulation.true_ordinal_labels;
        
        % preference predictions
        rand_pref_inds = randsample((1:length(true_mean))',15);  % randomly pick 15 action indexes from the space
        comparisons = nchoosek(rand_pref_inds,2);  % returns all combinations of the action indexes, taken two at a time
    end
    
    %% Get Posterior Fit error
    % Normalize if needed
    isNormalize = alg.settings.gp_settings.isNormalize;
    if ~all(eval_gp_mean == 0) && isNormalize
        norm_mean = (eval_gp_mean-min(eval_gp_mean))/(max(eval_gp_mean)-min(eval_gp_mean));
    else
        norm_mean = eval_gp_mean;
    end
    metrics.fit_error = norm(norm_mean-true_mean,2);

    %% Get ordinal label prediction error
    metrics.label_error = mean(abs(true_labels-predicted_labels));
    
    %% Get preference prediction error
    true_compared_utilities = true_mean(comparisons);
    actual_compared_utilities = eval_gp_mean(comparisons);
    true_predicted_pref = zeros(size(true_compared_utilities,1),1);
    actual_predicted_pref = zeros(size(true_compared_utilities,1),1);
    for i = 1:size(true_compared_utilities,1)
        if true_compared_utilities(i,1) > true_compared_utilities(i,2)
            true_predicted_pref(i) = 1;
        elseif true_compared_utilities(i,1) < true_compared_utilities(i,2)
            true_predicted_pref(i) = 2;
        end
        if actual_compared_utilities(i,1) > actual_compared_utilities(i,2)
            actual_predicted_pref(i) = 1;
        elseif actual_compared_utilities(i,1) < actual_compared_utilities(i,2)
            actual_predicted_pref(i) = 2;
        end
    end
    metrics.pref_error = 1-mean(true_predicted_pref == actual_predicted_pref);

    %% Get strong preference prediction error
    % ----------- NORTHEASTERN -----------------------------------------
    true_compared_utilities = true_mean(comparisons);
    actual_compared_utilities = eval_gp_mean(comparisons);
    true_strong_predicted_pref = zeros(size(true_compared_utilities,1),1);
    actual_strong_predicted_pref = zeros(size(true_compared_utilities,1),1);
    strong_pref_threshold = alg.settings.simulation.simulated_strong_pref_threshold; 
    for i = 1:size(true_compared_utilities,1)
        if true_compared_utilities(i,1) > true_compared_utilities(i,2)
            if abs(true_compared_utilities(i,1) - true_compared_utilities(i,2)) >= strong_pref_threshold
                true_strong_predicted_pref(i) = 11;
            else
                true_strong_predicted_pref(i) = 1;
            end
        elseif true_compared_utilities(i,1) < true_compared_utilities(i,2)
            if abs(true_compared_utilities(i,1) - true_compared_utilities(i,2)) >= strong_pref_threshold
                true_strong_predicted_pref(i) = 22;
            else
                true_strong_predicted_pref(i) = 2;
            end
        end
        if actual_compared_utilities(i,1) > actual_compared_utilities(i,2)
            if abs(actual_compared_utilities(i,1) - actual_compared_utilities(i,2)) >= strong_pref_threshold
                actual_strong_predicted_pref(i) = 11;
            else
                actual_strong_predicted_pref(i) = 1;
            end
        elseif actual_compared_utilities(i,1) < actual_compared_utilities(i,2)
            if abs(actual_compared_utilities(i,1) - actual_compared_utilities(i,2)) >= strong_pref_threshold
                actual_strong_predicted_pref(i) = 22;
            else
                actual_strong_predicted_pref(i) = 2;
            end
        end
    end
    metrics.strong_pref_error = 1-mean(true_strong_predicted_pref == actual_strong_predicted_pref);

    % ----------- NORTHEASTERN -----------------------------------------




end

end