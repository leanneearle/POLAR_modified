function removeLargeMatrices(obj)
% Description: Delete large matrices stored in post_model (to save on computation time)
% Inputs:
%    obj = preference-based learning algorithm object

for i = 1:length(obj.post_model)-1
    if i <= 1
        obj.post_model(i).prior_cov = [];
        obj.post_model(i).prior_cov_inv = [];
        obj.post_model(i).sigma = [];
    end
end

end