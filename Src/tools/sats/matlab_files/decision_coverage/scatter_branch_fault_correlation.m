function [X,Y] = scatter_branch_fault_correlation (classes, faults, branches, normalized_faults, normalized_branches, start_time, end_time, time_unit)
% Scatter the correlation between branch coverage and detected faults.

X=[];
Y=[];

%Calculate number of class.
sz = size(classes);
number_of_class = sz(1,2);

%Calculate number of sessions for each class.
sz = size(faults{1});
number_of_session = sz(1,2);

%Calculate number of time.
number_of_time = end_time - start_time + 1;

for i=1:number_of_class
    nfault_tbl = zeros (number_of_time, number_of_session);  
    nbranch_tbl = zeros (number_of_time, number_of_session);
    
    [acc_faults, acc_branches] = accumulated_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit);
    fb_tbl = fault_branch_table (acc_faults, acc_branches);    
    for j=1:number_of_session                
        nfault_tbl(:, j) = fb_tbl{j}(:,2)./normalized_faults{i};
        nbranch_tbl(:, j) = fb_tbl{j}(:, 3)./normalized_branches{i};        
    end
    mm = median (nbranch_tbl, 2);
    X = horzcat (X, mm);
    
    mm = median (nfault_tbl, 2);
    Y = horzcat (Y, mm);
end
 
figure ('Position', [0, 0, 500, 500]);
cols = 3;
rows = 3;
for i=1:number_of_class
    subplot (rows, cols, i);
    scatter (X(:, i), Y(:,i), '.');
    xlim([0.6, 1]);
    xlabel (classes{i});
end



