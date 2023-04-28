function predictedLabels = predictLabels(alg,gp_mean)
% Description: get predicted ordinal labels
% Inputs:
%   alg = preference-based learning algorithm object
%   gp_mean = (<|A|)x1 posterior distribution mean (depends if subset is
%   used)

if alg.settings.feedback.num_ord_categories == 0
    predictedLabels = [];
else
    ord_thresh = alg.settings.gp_settings.ordinal_thresholds;
    num_actions = size(gp_mean,1);
    labels = zeros(num_actions,1);
    for i = 1:num_actions
        temp = find(gp_mean(i) > ord_thresh);
        labels(i) = temp(end);
    end
    predictedLabels = labels;
end

end

