function f = plotFinal(obj, imageName)
% Description: plots the posterior mean
% Inputs: 
%   obj = preference-based learning algorithm object
%   imageName = name to save the image file with

% Use plotting code in GP class:
f = obj.gp.plotGP;

latexify;
fontsize(22);

% Save if desired
if nargin == 2
    imageLocation = obj.settings.save_folder;
    
    % Check if dir exists
    if ~isfolder(imageLocation)
        mkdir(imageLocation);
    end
    print(f, fullfile(imageLocation,imageName),'-dpng');
end

end
