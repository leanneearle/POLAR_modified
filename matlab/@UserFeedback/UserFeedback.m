classdef UserFeedback < handle
    %FEEDBACK This class queries either the user for feedback

    
    properties
        preference
        coactive
        ordinal
        strong_preference % ----- NORTHEASTER ---------------------------
    end
    
    methods
        function feedback = UserFeedback(alg,iteration)
                   
            if nargin < 2
                iteration = length(alg.iteration);
            end
            
            % Get user feedback
            feedback = feedback.getUserFeedback(alg,iteration);

        end
    end
    
    methods (Access = private)
        
        % Feedback
        feedback = getUserFeedback(feedback,alg,iteration);
        disp(feedback)
        
        % Types of user feedback;
        pref_label = getUserPreference(feedback, alg, iteration);
        coac_data = getUserSuggestion(feedback, alg, iteration);
        ord_label  = getUserLabel(feedback, alg, iteration);
        strong_pref_label = getUserStrongPreference(feedback, alg, iteration); % ---- NORTHEASTERN ------
    end 
    
    methods (Static)
        printActionInformation(alg,iteration)
    end
end

