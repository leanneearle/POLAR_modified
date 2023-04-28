function feedback = getUserFeedback(feedback,alg,iteration)
% Description: uses functions in the UserFeedback class to get the subjects
% feedback responses
% Inputs: 
%   feedback = 1x1 structure containing 1x1 structures for each of the feedback
%               methods, where each has:
                %     1) c_x_subset: nx2 index comparisons in terms of subset indices
                %     2) c_x_full: nx2 index comparisons in terms of global indices
                %     3) c_y = nx1 preferences corresponding to coactive comparisons
                %           (always 2 to signify that second index in comparisons is
                %           suggested action);
%   alg = preference-based learning algorithm object
%   iteration = iteration #
% Output:
%   feedback = updated 1x1 structure

% Queries the user for feedback

% print feedback:
feedback.printActionInformation(alg, iteration);

% Get preferences
if any(alg.settings.feedback.types == 1)
    pref_feedback = feedback.getUserPreference(alg,iteration);
else
    pref_feedback = [];
end

% Get user suggestions
if any(alg.settings.feedback.types == 2)
    coac_data = feedback.getUserSuggestion(alg,iteration);
else
    coac_data = [];
end

% Get user labels
if any(alg.settings.feedback.types == 3)
    ordinal_feedback = feedback.getUserLabel(alg,iteration);
else
    ordinal_feedback = [];
end

% ---------- NORTHEASTERN -----------------------------------------------
% Get strong preferences
if any(alg.settings.feedback.types == 4)
    strong_pref_feedback = feedback.getUserStrongPreference(alg,iteration);
else
    strong_pref_feedback = [];
end
% ---------- NORTHEASTERN -----------------------------------------------


feedback.preference = pref_feedback;
feedback.coactive = coac_data;
feedback.ordinal = ordinal_feedback;
feedback.strong_preference = strong_pref_feedback;  % --- NORTHEASTERN ---


end

