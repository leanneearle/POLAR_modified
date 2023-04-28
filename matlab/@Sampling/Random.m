function [newSamples, rewards] = Random(obj,alg)
% Description: randomly sample an action to test next 
% Inputs: 
%   obj, alg = preference-based learning algorithm object
% Outputs:
%  newSamples = vx1 vector of new samples to test where v is the number of
%  parameters

% Load number of samples to draw from settings
num_samples = alg.settings.n;
newSamples = obj.getRandAction(alg,num_samples);
rewards = [];

end