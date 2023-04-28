function newSampleGlobalInds = getMapping(obj,alg,samples)
% Description: Get mapping from original action space to finer action space
% Inputs:
%   obj, alg = preference-based learning algorithm object
% Outputs: 
% newSamplesGlobalInds = |A|x1 mapping from new finer action space to original action space, |A| = # of elements in the action space

num_original_points = size(alg.settings.points_to_sample,1); % length = # of possible combination
newSampleGlobalInds = zeros(num_original_points,1);  

for i = 1:num_original_points
    [~,newSampleGlobalInds(i)] = min(vecnorm(alg.settings.points_to_sample(i,:) - samples,2,2));    
end
