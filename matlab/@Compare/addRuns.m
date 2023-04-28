function addRuns(obj,new_runs)
% Description: 
% Inputs:
%   alg = preference-based learning algorithm object
%   new_runs = the new run added to the comparison 

% Parse new inputs
p = inputParser;
p.addRequired('runs',@(x)isscalar(x)&&(x>0));
p.parse(new_runs);
obj.new_runs = p.Results.runs;

% Run PBL for number of new_runs
obj.runPBL;
         
% Compile mean and stds of PBL metrics
obj.compileMetrics;      

% Plot results
obj.plotComparisons;

% Save Figures
obj.saveFigures;

end