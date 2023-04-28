function actions = getRandAction(alg,num_actions)
% Description: get non-unique random actions from action space
% Inputs: 
%   alg = preference-based learning algorithm object
% Outputs:
%  num_actions = 1x1 # of new actions to pick

% get random action based on number of actions in each dimension
bins = alg.settings.bin_sizes;
actions = zeros(num_actions,length(bins));
for i = 1:length(bins)
    actions(:,i) = randsample(alg.settings.parameters(i).actions,num_actions,true);
end

end