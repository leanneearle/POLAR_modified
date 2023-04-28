% -------------- NORTHEASTERN --------------------------------------------

function strong_pref_label = getUserStrongPreference(feedback, alg, iteration)
% Query human for strong pairwise preference
% Inputs: 
%   feedback = 1x1 structure containing 1x1 structures for each of the feedback
%               methods 
%   alg = preference-based learning algorithm object
%   iteration = iteration #
% Output:
%   pref_label = 1x1 value representing the user's preference
%               = 0, 1, 2, 11, or 22

if nargin < 2
    iteration = length(alg.iteration);
end


%------------------------ query user for feedback -------------------------

% query for preference feedback
if isempty(alg.iteration(iteration).feedback.sp_x_subset)
    strong_pref_input = input('Ready to continue? (y/1):   ','s');
        while ~((strcmpi(strong_pref_input,'y')) || (strcmpi(strong_pref_input,'1')))
            strong_pref_input = input('Incorrect input given. Please enter 1 or y:   ');
        end
    strong_pref_label = [];
else
    if length(alg.iteration(iteration).feedback.visitedInds) == 2
        
        % send question to user
        strong_pref_input = input('Which gait do you prefer? (1, 2, 11, 22 (for strongly prefer), or 0 (for no preference)):   ');
        while ~any([strong_pref_input == 0, strong_pref_input == 1, strong_pref_input == 2, strong_pref_input == 11, strong_pref_input == 22, strong_pref_input == -1]);
            strong_pref_input = input('Incorrect input given. Please enter 0, 1, 2, 11, or 22:   ');
        end
        strong_pref_label = strong_pref_input;
    else

        strong_pref_input = ("only built for two pairwise preferences")
        
        
    end
end

end

% -------------- NORTHEASTERN --------------------------------------------
