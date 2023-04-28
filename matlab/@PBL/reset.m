function reset(obj)
% Description: delete the data below from the object
% Inputs:
%    obj = preference-based learning algorithm object

obj.iteration = struct('buffer',[],'samples',[],'best',[],...
    'subset',[],'feedback',[]);
obj.unique_visited_actions = [];
obj.unique_visited_action_globalInds = [];
obj.feedback = struct('preference',[],'coactive',[],'ordinal',[],'strong_preference',[]);  % -- NORTHEASTERN --
obj.feedback.preference = struct('x_subset',[],'x_full',[],'y',[]);
obj.feedback.coactive = struct('x_subset',[],'x_full',[],'y',[]);
obj.feedback.ordinal = struct('x_subset',[],'x_full',[],'y',[]);
obj.feedback.strong_preference = struct('x_subset',[],'x_full',[],'y',[]);  % -- NORTHEASTERN --


obj.post_model = struct('which',[], ...
    'actions',[],'action_globalInds',[],...
    'prior_cov',[], ...
    'prior_cov_inv',[], ...
    'mean',[],...
    'sigma',[],'uncertainty',[]);

obj.comp_time = struct('acquisition',[],'posterior',[]);

end