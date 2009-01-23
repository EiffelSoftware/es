function [X,Y] = scatter_branch_fault_correlation (classes, faults, branches, normalized_faults, normalized_branches, start_time, end_time, time_unit, selected_classes, is_normalized_fault, is_normalized_branch)
% Scatter the correlation between branch coverage and detected faults.

X={};
Y={};

%Calculate number of class.
sz = size (selected_classes);
number_of_class = sz(1,2);

%Calculate number of sessions for each class.
sz = size(faults{1});
number_of_session = sz(1,2);

%Calculate number of time.
number_of_time = end_time - start_time + 1;

for v=1:number_of_class
    i = selected_classes(v);
    nfault_tbl = zeros (number_of_time, number_of_session);  
    nbranch_tbl = zeros (number_of_time, number_of_session);
    
    sz = size(branches{i}{1});
    number_of_branch = sz(1);
    
    [acc_faults, acc_branches] = accumulated_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit);
    fb_tbl = fault_branch_table (acc_faults, acc_branches);    
    for j=1:number_of_session          
        if is_normalized_fault == true
            nfault_tbl(:, j) = fb_tbl{j}(:,2)./normalized_faults{i};
        else
            nfault_tbl(:, j) = fb_tbl{j}(:,2);
        end
        
        if is_normalized_branch == true
            nbranch_tbl(:, j) = fb_tbl{j}(:, 3)./normalized_branches{i};
        else
            nbranch_tbl(:, j) = fb_tbl{j}(:, 3)./number_of_branch;      
        end
    end
    mb = median (nbranch_tbl, 2);
    mf = median (nfault_tbl, 2);
    X = horzcat (X, mb);
    Y = horzcat (Y, mf);
        
%    cmf = zeros (101, 1);
%     
%    ss = size (mb);
%    for k=1:ss(1)
%        bl = round(mb(k)*100);
%        if bl>0
%            cmf (bl) = mf(k);        
%        end
%    end
%    d = cmf (find (cmf>0),:);
%    
%    X = horzcat (X, {find(cmf>0)./100});    
%    Y = horzcat (Y, {d});
end
 
figure;
cols = 4;
rows = number_of_class / cols;
rows = round(rows)
if rows < 1 
    rows = 1;
end

for i=1:number_of_class
    subplot (rows, cols, i);    
    r = corrcoef (X{i}(:,1), Y{i}(:,1));
    r = round(r*100) / 100;
    scatter (X{i}(:, 1), Y{i}(:,1), '.');
    if is_normalized_branch == true
        xlim([0, 1]);
    end
    if is_normalized_fault == true
        ylim([0, 1]);
    end    
    text (0.1, 0.8, ['r=', num2str(r(1, 2))]);

    title (classes{selected_classes(i)});
    xlabel ('Branch');
    ylabel ('Faults');
end

%subplotspace('horizantal', 10);
%subplotspace('vertical', 10);




