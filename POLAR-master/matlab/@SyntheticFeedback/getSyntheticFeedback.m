function feedback = getSyntheticFeedback(feedback,alg,iteration)
% Generates automatic synthetic feedback based on predefined objective
% function in ObjectiveFunction.m
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

% print feedback:
if alg.settings.printInfo
    feedback.printActionInformation(alg,iteration);
end

% Get preferences
if any(alg.settings.feedback.types == 1)
    preference_feedback = feedback.getSyntheticPreference(alg,iteration);
else
    preference_feedback = [];
end

% Get suggestions
if any(alg.settings.feedback.types == 2)
    coac_data = feedback.getSyntheticSuggestion(alg,iteration);
else
    coac_data = [];
end

% Get ordinal labels
if any(alg.settings.feedback.types == 3)
    ordinal_feedback = feedback.getSyntheticLabel(alg,iteration);
else
    ordinal_feedback = [];
end

% ---------- NORTHEASTERN -------------------------------------------------
% Get strong preferences
if any(alg.settings.feedback.types == 4)
    strong_preference_feedback = feedback.getSyntheticStrongPreference(alg,iteration);
else
    strong_preference_feedback = [];
end
% ---------- NORTHEASTERN -------------------------------------------------


feedback.preference = preference_feedback;
feedback.coactive = coac_data;
feedback.ordinal = ordinal_feedback;
feedback.strong_preference = strong_preference_feedback; % --- NORTHEASTERN ---

end

