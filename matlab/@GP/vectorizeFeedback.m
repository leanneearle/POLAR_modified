function obj = vectorizeFeedback(obj)
% Description: construct vectorized feedback indices and labels
% Inputs:
%   obj = preference-based learning algorithm object

%% Preference Feedback:
if ~isempty(obj.pref_data)

    % note: pref_data = two actions being compared
    % pref_label = input

    % get vector of all preferred vs non preferred action indices
    preferred_first = obj.pref_labels == 1;  % returns 1 if true, 0 if false
    obj.pref_pos_ind = [obj.pref_data(preferred_first,1);...
        obj.pref_data(~preferred_first,2)];
    obj.pref_neg_ind = [obj.pref_data(preferred_first,2);...
        obj.pref_data(~preferred_first,1)];
    
    % get unique feedback indices
    [obj.pref_pos_unique_inds,~,~] = unique(obj.pref_pos_ind);
    [obj.pref_neg_unique_inds,~,~] = unique(obj.pref_neg_ind);
    
    % get positions of repeating data to be added together
    obj.pref_pos_repeating_inds = obj.pref_pos_ind == obj.pref_pos_unique_inds';
    obj.pref_neg_repeating_inds = obj.pref_neg_ind == obj.pref_neg_unique_inds';
    
    % convert [x,y] subscripts to linear indices for vectorization
    sz = size(obj.prior_cov_inv);
    pospos = sub2ind(sz,obj.pref_pos_ind,obj.pref_pos_ind);
    negneg = sub2ind(sz,obj.pref_neg_ind,obj.pref_neg_ind);
    posneg = sub2ind(sz,obj.pref_pos_ind,obj.pref_neg_ind);
    negpos = sub2ind(sz,obj.pref_neg_ind,obj.pref_pos_ind);
    
    % get repeated indices
    [obj.pref_pospos_unique_inds,~,~] = unique(pospos);
    [obj.pref_negneg_unique_inds,~,~] = unique(negneg);
    [obj.pref_posneg_unique_inds,~,~] = unique(posneg);
    [obj.pref_negpos_unique_inds,~,~] = unique(negpos);
    obj.pref_pospos_repeating_inds = pospos == obj.pref_pospos_unique_inds';
    obj.pref_negneg_repeating_inds = negneg == obj.pref_negneg_unique_inds';
    obj.pref_posneg_repeating_inds = posneg == obj.pref_posneg_unique_inds';
    obj.pref_negpos_repeating_inds = negpos == obj.pref_negpos_unique_inds';
end
%% Coactive Feedback:
if ~isempty(obj.coac_data)
% get vector of all preferred vs non preferred action indices
preferred_first = obj.coac_labels == 1;
obj.coac_pos_ind = [obj.coac_data(preferred_first,1);...
    obj.coac_data(~preferred_first,2)];
obj.coac_neg_ind = [obj.coac_data(preferred_first,2);...
    obj.coac_data(~preferred_first,1)];

% get unique feedback indices
[obj.coac_pos_unique_inds,~,~] = unique(obj.coac_pos_ind);
[obj.coac_neg_unique_inds,~,~] = unique(obj.coac_neg_ind);

% get positions of repeating data to be added together
obj.coac_pos_repeating_inds = obj.coac_pos_ind == obj.coac_pos_unique_inds';
obj.coac_neg_repeating_inds = obj.coac_neg_ind == obj.coac_neg_unique_inds';

% convert [x,y] subscripts to linear indices for vectorization
sz = size(obj.prior_cov_inv);
pospos = sub2ind(sz,obj.coac_pos_ind,obj.coac_pos_ind);
negneg = sub2ind(sz,obj.coac_neg_ind,obj.coac_neg_ind);
posneg = sub2ind(sz,obj.coac_pos_ind,obj.coac_neg_ind);
negpos = sub2ind(sz,obj.coac_neg_ind,obj.coac_pos_ind);

% get repeated indices
[obj.coac_pospos_unique_inds,~,~] = unique(pospos);
[obj.coac_negneg_unique_inds,~,~] = unique(negneg);
[obj.coac_posneg_unique_inds,~,~] = unique(posneg);
[obj.coac_negpos_unique_inds,~,~] = unique(negpos);
obj.coac_pospos_repeating_inds = pospos == obj.coac_pospos_unique_inds';
obj.coac_negneg_repeating_inds = negneg == obj.coac_negneg_unique_inds';
obj.coac_posneg_repeating_inds = posneg == obj.coac_posneg_unique_inds';
obj.coac_negpos_repeating_inds = negpos == obj.coac_negpos_unique_inds';
end
%% Ordinal Feedback:
[obj.ord_data_unique_inds,~,~] = unique(obj.ord_data);
obj.ord_data_repeating_inds = obj.ord_data == obj.ord_data_unique_inds';

%% Strong Preference Feedback:
% -------------- NORTHEASTERN -----------------------------------------
if ~isempty(obj.strong_pref_data)
  
% % method 1 = reduce noise -----------------------------------------------
%     % get vector of all preferred vs non preferred action indices
%     obj.extra_pref = (obj.strong_pref_labels == 11 | obj.strong_pref_labels == 22); % get vector of if strong or normal preference
%     strong_preferred_first = (obj.strong_pref_labels == 1 | obj.strong_pref_labels == 11);
% 
%     obj.strong_pref_pos_ind = [obj.strong_pref_data(strong_preferred_first,1);...
%         obj.strong_pref_data(~strong_preferred_first,2)];
%     obj.strong_pref_neg_ind = [obj.strong_pref_data(strong_preferred_first,2);...
%         obj.strong_pref_data(~strong_preferred_first,1)];
% % method 1 ----------------------------------------------------------


    % method 2 = repeat the strong preferences w amount of times -------------
    num_repeats = 99;
    % vectors for classification
    obj.extra_pref = (obj.strong_pref_labels == 11 | obj.strong_pref_labels == 22); % get vector of if strong or normal preference
    strong_preferred_first = (obj.strong_pref_labels == 1 | obj.strong_pref_labels == 11);  % vector of if preferred first, generally
    strong_preferred_first_extra = obj.strong_pref_labels == 11;  % vector of if preferred first and strong
    strong_preferred_second_extra = obj.strong_pref_labels == 22;  % vector of if preferred second and strong
    
    % get the data comparisons for when the strong preferences are given
    strong_prefs_first = [obj.strong_pref_data(strong_preferred_first_extra,:)];
    strong_prefs_second = [obj.strong_pref_data(strong_preferred_second_extra,:)];
    
    % dupicate strong preferences 
    data_extra_first = [strong_prefs_first(:,1), strong_prefs_first(:,2); ...
        strong_prefs_first(:,1) - 1, strong_prefs_first(:,2)];
    data_extra_second = [strong_prefs_second(:,1), strong_prefs_second(:,2); ...
        strong_prefs_second(:,1), strong_prefs_second(:,2) - 1];
    
    % repeat the data x amount of times 
    data_extra_first_repeated = repmat(data_extra_first, num_repeats, 1);
    data_extra_second_repeated = repmat(data_extra_second, num_repeats, 1);
    
    % append all positive and negative preference indexes, respectively
    obj.strong_pref_pos_ind = [obj.strong_pref_data( ...
        strong_preferred_first,1);...
        data_extra_first_repeated(:,1); ...
        obj.strong_pref_data(~strong_preferred_first,2); ...
        data_extra_second_repeated(:,2)];
    
    obj.strong_pref_neg_ind = [obj.strong_pref_data( ...
        strong_preferred_first,2);...
        data_extra_first_repeated(:,2); ...
        obj.strong_pref_data(~strong_preferred_first,1);
        data_extra_second_repeated(:,1)];
    % method 2 -------------------------------------------------

    
    % get unique feedback indices
    [obj.strong_pref_pos_unique_inds,~,~] = unique(obj.strong_pref_pos_ind);
    [obj.strong_pref_neg_unique_inds,~,~] = unique(obj.strong_pref_neg_ind);
    
    % get positions of repeating data to be added together
    obj.strong_pref_pos_repeating_inds = obj.strong_pref_pos_ind == obj.strong_pref_pos_unique_inds';
    obj.strong_pref_neg_repeating_inds = obj.strong_pref_neg_ind == obj.strong_pref_neg_unique_inds';
    
    % convert [x,y] subscripts to linear indices for vectorization
    sz = size(obj.prior_cov_inv);
    strong_pospos = sub2ind(sz,obj.strong_pref_pos_ind,obj.strong_pref_pos_ind);
    strong_negneg = sub2ind(sz,obj.strong_pref_neg_ind,obj.strong_pref_neg_ind);
    strong_posneg = sub2ind(sz,obj.strong_pref_pos_ind,obj.strong_pref_neg_ind);
    strong_negpos = sub2ind(sz,obj.strong_pref_neg_ind,obj.strong_pref_pos_ind);
    
    % get repeated indices
    [obj.strong_pref_pospos_unique_inds,~,~] = unique(strong_pospos);
    [obj.strong_pref_negneg_unique_inds,~,~] = unique(strong_negneg);
    [obj.strong_pref_posneg_unique_inds,~,~] = unique(strong_posneg);
    [obj.strong_pref_negpos_unique_inds,~,~] = unique(strong_negpos);
    obj.strong_pref_pospos_repeating_inds = strong_pospos == obj.strong_pref_pospos_unique_inds';
    obj.strong_pref_negneg_repeating_inds = strong_negneg == obj.strong_pref_negneg_unique_inds';
    obj.strong_pref_posneg_repeating_inds = strong_posneg == obj.strong_pref_posneg_unique_inds';
    obj.strong_pref_negpos_repeating_inds = strong_negpos == obj.strong_pref_negpos_unique_inds';
end
% -------------- NORTHEASTERN -----------------------------------------
end

