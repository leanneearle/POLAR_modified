function ord_label = getSyntheticLabel(feedback,alg, iteration)
% Generates synthetic ordinal label responses
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

noise = alg.settings.simulation.simulated_ord_noise;
ordinal_threshold = alg.settings.simulation.true_ord_threshold;
if nargin < 2
    iteration = length(alg.iteration);
end
 
if ~any(alg.settings.feedback.types == 3)
    ord_label = [];
else  
    queried_actions = alg.iteration(iteration).samples.globalInds;
    trueObj = alg.settings.simulation.true_objectives(queried_actions);
    ord_label = zeros(length(queried_actions),1);
    if noise
        for i = 1:length(queried_actions)
            z1 = (ordinal_threshold(2:end) - trueObj(i))/noise;
            z2 = (ordinal_threshold(1:end-1) - trueObj(i))/noise;
            switch alg.settings.linkfunction
                case 'sigmoid'
                    prob = sigmoid(z1) -sigmoid(z2);
                case 'gaussian'
                    prob = normcdf(z1) -normcdf(z2);
            end
%             norm_prob = prob./sum(prob);
            ord_label(i) = randsample(alg.settings.feedback.num_ord_categories,1,true,prob);
        end
    else
        for i = 1:length(queried_actions)
            lessThanCat = find(trueObj(i) <= ordinal_threshold);
            ord_label(i) = max(lessThanCat(1)-1,1);
        end
    end
    
end

end
