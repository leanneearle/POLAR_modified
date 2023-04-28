function getRegret(metrics,alg,iteration)
% Description: calculate regret
% Inputs:
%   metrics = {1x1} cell containing 8 metrics evaluations
%   alg = preference-based learning algorithm object
%   iteration = iteration #


if nargin < 3
    iteration = length(alg.iteration);
end
          
% Get true objective associated with best action
if alg.settings.useSyntheticObjective
    
    %% Compute error of believed optimal action
    true_utility = alg.settings.simulation.true_objectives(alg.iteration(iteration).best.globalInd);
    metrics.optimal_error = alg.settings.simulation.true_bestObjective - true_utility;
    
end

end