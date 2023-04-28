% ----------------- NORTHESASTERN --------------------------------------

function pref_label = getSyntheticStrongPreference(feedback,alg, iteration)
% Generates synthetic preference responses, automatically prefer action with maximal value
% generates a strong preference when the reward is greater than the
% difference in reward theshold set
% Inputs:
%   feedback = 1x1 structure containing 1x1 structures for each of the feedback
%               methods, where each has:
                %     1) c_x_subset: nx2 index comparisons in terms of subset indices
                %     2) c_x_full: nx2 index comparisons in terms of global indices
                %     3) c_y = nx1 preferences corresponding to coactive comparisons
                %           (always 2 to signify that second index in comparisons is
                %           suggested action);
% alg = preference-based learning algorithm object
% iteration = iteration #

if nargin < 2
    iteration = length(alg.iteration);
end

if isempty(alg.iteration(iteration).feedback.sp_x_full)
    pref_label = [];
else
    compared_actions = alg.iteration(iteration).feedback.globalInds;
    trueObjectives = alg.settings.simulation.true_objectives(compared_actions);
    
    % case when all objectives are equal
    if all(trueObjectives == trueObjectives(1))
        if length(compared_actions) == 2
            pref_label = 0;
        else
            num_prefs = nchoosek(length(compared_actions),2);
            pref_label = zeros(num_prefs,1);
        end
        
    % if there is at least one different objective value
    else
        % if finding the maximum
        [~,ranking] = sort(trueObjectives','descend');   % ex. [1, 2] is 1 is preferred, [2, 1] if 2 is preferred
        % corrupt preferences with noise
        prefnoise = alg.settings.simulation.simulated_pref_noise;

        if length(compared_actions) == 2
            if prefnoise == 0 
                pref_prob = 1;
            else
                % assume sigmoid link function for preference feedback
                tempx = (trueObjectives(ranking(1)) - trueObjectives(ranking(2)))/prefnoise;
%                 pref_prob = sigmoid(tempx);
                pref_prob = 1/(1+exp(-tempx));
            end
            pref = ranking(1);
            
            % strong preference case: substantial difference between the
            % objective values
            
            threshold = alg.settings.simulation.simulated_strong_pref_threshold;

            if abs(diff(trueObjectives)) >= threshold
                strong_pref = pref * 11;
                pref_label = randsample([strong_pref,pref],1,'true',[pref_prob,1-pref_prob]);
                if pref_label == pref
                    pref_label = randsample([pref,3-pref],1,'true',[pref_prob,1-pref_prob]);
                    if pref_label == 3-pref
                        pref_label = randsample([3-pref,(3-pref)*11],1,'true',[pref_prob,1-pref_prob]);
                    end
                end
            else
                % normal preference case
                pref_label = randsample([pref,3-pref],1,'true',[pref_prob,1-pref_prob]);
            end
            
        elseif length(compared_actions) > 2
            [~, pref_label] = rankingToPreferences(ranking, prefnoise, trueObjectives);
        end
    end
end

end

% ----------------- NORTHESASTERN --------------------------------------