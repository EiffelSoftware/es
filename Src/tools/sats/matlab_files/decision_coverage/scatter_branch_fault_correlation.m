function [X,Y] = scatter_branch_fault_correlation (classes, faults, branches, normalized_faults, normalized_branches, start_time, end_time, time_unit, selected_classes)
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

for j=1:number_of_class
    i = selected_classes(j);
    nfault_tbl = zeros (number_of_time, number_of_session);  
    nbranch_tbl = zeros (number_of_time, number_of_session);
    
    sz = size(branches{i}{1});
    number_of_branch = sz(1);
    
    [acc_faults, acc_branches] = accumulated_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit);
    fb_tbl = fault_branch_table (acc_faults, acc_branches);    
    for j=1:number_of_session                
        nfault_tbl(:, j) = fb_tbl{j}(:,2)./normalized_faults{i};
        nbranch_tbl(:, j) = fb_tbl{j}(:, 3)./number_of_branch;        
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
if rows < 1 
    rows = 1;
end

for i=1:number_of_class
    subplot (rows, cols, i);    
    r = corrcoef (X{i}(:,1), Y{i}(:,1));
    scatter (X{i}(:, 1), Y{i}(:,1), '.');
    xlim([0, 1]);
%    set(gca,'YTick',0:0.25:1);
%    set(gca,'XTick',0:0.25:1);
    text (0.1, 0.75, ['r=', num2str(r(1, 2))]);

    title (classes{i});
    xlabel ('Branch coverage level');
    ylabel ('Normalized faults');
end



