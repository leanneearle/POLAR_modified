function newSampleVisitedInds = appendVisitedInd(obj,samples,isCoac)
% Description: appends action and corresponding index to obj.unique_visited_actions,
% obj.unique_visited_action_globalInds, and obj.unique_visited_isCoac

% Inputs:
%    obj = preference-based learning algorithm object
%   samples: n x d matrix with each row corresponding to an action
%   isCoac: scalar flag indicating if samples are coactive actions
% Outputs:
%   n x 1 matrix of the sampled  visitied indices

num_samples = size(samples,1);
newSampleVisitedInds = zeros(num_samples,1);

for i = 1:num_samples
    
    currentSample = samples(i,:);
    
    if ~isempty(obj.unique_visited_actions)
        if min(vecnorm(currentSample - obj.unique_visited_actions,2,2)) < 1e-4
            [~,ind] = min(vecnorm(currentSample - obj.unique_visited_actions,2,2));
            newSampleVisitedInds(i) = ind(1);
        else
            obj.unique_visited_actions = cat(1,obj.unique_visited_actions,currentSample);
            obj.unique_visited_action_globalInds = ...
                cat(1,obj.unique_visited_action_globalInds,...
                obj.getGlobalInd(currentSample));
            obj.unique_visited_isCoac = cat(1,obj.unique_visited_isCoac, isCoac);
            newSampleVisitedInds(i) = size(obj.unique_visited_actions,1);
        end
    else
        obj.unique_visited_actions = currentSample;
        obj.unique_visited_action_globalInds = obj.getGlobalInd(currentSample);
        obj.unique_visited_isCoac = isCoac;
        newSampleVisitedInds(i) = 1;
    end
    
%     Store non-coactive actions in frequency data
%     tstart = tic;
    for j = 1:length(obj.settings.parameters)
        [~,bin_number] = min(vecnorm(currentSample(j) - obj.settings.parameters(j).actions,2,1));
        obj.sample_table = [obj.sample_table; {j, bin_number}];
    end
%     fprintf('Table took %f \n',toc(tstart));

end
