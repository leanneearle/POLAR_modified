function [newSampleGlobalInd,newSamples] = eval_IG(obj,alg, R, select_idx,buffer_action_idx, iteration)
% Description: get the next action to test using information gain
% Inputs: 
%   alg, obj = preference-based learning algorithm object
%  R_models = |A|x(n) matrix containing the sampled reward function used to
%       determine the next action to sample, where |A| is the number of
%       elements in the action space (or subset) and n is the number of new
%       actions to sample
%   selection_idx = 1x1 index of selected action
%   buffer_action)idx = 1x1 index of buffer action 
%   iteration = 1x1 iteration #
% Outputs:
% newSampleGlobalInd = nx1 vector of global index(es) of new samples
%  newSamples = (n)x1 vector of the next action to test, where n is the
%       parameter defined by the user of how many new actions to test at each
%       iteration (typically n=1)


num_samples = alg.settings.n;  % number of samples per iteration (ex. 1)
num_buffer = min(alg.settings.b,numel(buffer_action_idx));    % number of buffer actions (ex. 1)
M = alg.settings.sampling.IG_samp;  % ?, (ex. 1000)

if ~isfield(alg.settings.feedback,'num_ord_categories') || ~any(alg.settings.feedback.types == 3)
    num_ord_cat = 0;
else
    num_ord_cat = alg.settings.feedback.num_ord_categories;
end
ord_cat = num_ord_cat;  % number of ordinal categories
pref_choice = [1,2];  % the two options for preference choices
ord_choice = 1:ord_cat;  % the options for ordinal categories
% number of preferences: n choose 2 + n x b 
% number of ordinal labels: n

num_act = num_samples + num_buffer;  % number of actions to compare = actions just sampled + actions in buffer (memorable history)

if num_samples > 1
    comp_idx = nchoosek(1:num_samples,2);
    num_pref = nchoosek(num_samples,2) + num_samples * num_buffer; % new preferences
else
    comp_idx = [];
    num_pref = num_samples * num_buffer;  % (ex. 1 * 1 = 1)
end

% permuatation = the number of ways of arranging n objects into ordered groups of r objects
% number of permutations (order matters) of n things taken r at a time:
% P(n,r) = n!/(n-r)!

% permn(v,n) returns all permutations of n elements taken from vector v, with repetitions
pref_comb = permn(pref_choice,num_pref);  % (ex. [1; 2])

num_ord = num_samples; %new ordinal labels
ord_comb = permn(ord_choice,num_ord);
  
% re: combination of preference and ordinal feedback labels
pref_ord_comb_idx = combvec(1:size(ord_comb,1),1:size(pref_comb,1),2);
pref_ord_comb = cat(2,ord_comb(pref_ord_comb_idx(1,:),:),pref_comb(pref_ord_comb_idx(2,:),:));
% number of actions considered n + b (chosen + buffer)

% each row corresponding to a set of actions that could be sampled
% select_idx = indexes of actions that will be used 
choose_action_comb = nchoosek(select_idx,num_samples);
% # of combinations by n + b
% returns a matrix containing all possible combinations of the elements of
% vector 'select_idx' taken 'num_samples' at a time

comb_sz = nchoosek(numel(select_idx),num_samples);  % number of combinations of 'select_ind' size taken  'num_samples' at a time
all_action_comb = zeros(comb_sz,num_act); % num combinations x number of actions being compared
all_action_comb(:,1:num_samples) = choose_action_comb;
all_action_comb(:,num_samples+1:end) = repmat(buffer_action_idx',comb_sz,1);



comp_buffer_idx = combvec(1:num_samples,num_samples+1:num_samples+num_buffer)';
comp_idx_whole = cat(1,comp_idx,comp_buffer_idx);
%%

for i = 1:size(all_action_comb,1)
   new_action = choose_action_comb(i,:);
   all_action = all_action_comb(i,:);
   comp_pref_idx = all_action(comp_idx_whole);

   y = R(new_action,:);
   y_pref = cat(3,R(comp_pref_idx(:,1),:),R(comp_pref_idx(:,2),:));
   
   if any(alg.settings.feedback.types == 3) && any(alg.settings.feedback.types == 1)
        p = zeros(M, size(pref_ord_comb,1));
        for k = 1:size(pref_ord_comb,1)
            s = pref_ord_comb(k,num_samples+1:end);
            o = pref_ord_comb(k,1:num_samples);
            pref_prod = obj.eval_pref_prod(s,y_pref,alg);
            ord_prod = obj.eval_ord_prod(o,y,alg);
            p(:,k) = ord_prod .* pref_prod;
        end
   % -------- NORTHEASTERN ----------------------------------------------
   elseif any(alg.settings.feedback.types == 3) && any(alg.settings.feedback.types == 4)
        p = zeros(M, size(pref_ord_comb,1));
        for k = 1:size(pref_ord_comb,1)
            s = pref_ord_comb(k,num_samples+1:end);
            o = pref_ord_comb(k,1:num_samples);
            pref_prod = obj.eval_pref_prod(s,y_pref,alg);
            ord_prod = obj.eval_ord_prod(o,y,alg);
            p(:,k) = ord_prod .* pref_prod;
        end
   % -------- NORTHEASTERN ^ ----------------------------------------------
   elseif any(alg.settings.feedback.types == 1)
        p = zeros(M, size(pref_comb,1));
        for k = 1:size(pref_comb,1)
            s = pref_comb(k,:);
            pref_prod = obj.eval_pref_prod(s,y_pref,alg);
            p(:,k) = pref_prod;
        end
   % -------- NORTHEASTERN ----------------------------------------------
   elseif any(alg.settings.feedback.types == 4)
        p = zeros(M, size(pref_comb,1));
        for k = 1:size(pref_comb,1)
            s = pref_comb(k,:);
            pref_prod = obj.eval_pref_prod(s,y_pref,alg);
            p(:,k) = pref_prod;
        end
  % -------- NORTHEASTERN ^ ----------------------------------------------
   elseif any(alg.settings.feedback.types == 3)
       p = zeros(M, size(ord_comb,1));
       for k = 1:size(ord_comb,1)
            o = ord_comb(k,:);
            ord_prod = obj.eval_ord_prod(o,y,alg);
            p(:,k) = ord_prod;
       end
   end

    % calculate average likelihood across all combinations of s and o
    h = - sum(sum(p .* log2(p),3),2);
    p_avg = mean(p,1);
    H1 = - sum(sum(p_avg .* log2(p_avg)));
    H2 = 1/M * sum(h);
    IG(i) = H1-H2;
    
end

% load posterior model
model = alg.post_model(max(iteration-1,1));

[~,maxIndPair] = maxk(IG,1);
subsetInds = choose_action_comb(maxIndPair,:);
newSampleGlobalInd = model.action_globalInds(subsetInds);
newSamples = alg.settings.points_to_sample(newSampleGlobalInd,:);
end   
