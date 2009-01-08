function Result = plot_sd_data (faults, branches, start_time, end_time, time_unit, plot_data, central_method, graph_title)
% Plot the relation faults and branches (faults in y-axis and branches in x-axis, if swap=true, swap these two axis).
% `faults' is of form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is of form [branch_id, visited_times, first_visit_time, first_visit_test_case_index].
% `start_time' and `end_time' defines the time zone in which result should
% be calculated.
% `time_unit' is of unit second.
% % Result is the correlation coefficient matrix of faults and branches.

% Draw curves in current active figure.
[acc_faults, acc_branches] = accumulated_branch_coverage_data (faults, branches, start_time, end_time, time_unit);
data = fault_branch_table (acc_faults, acc_branches);

if strcmp(plot_data, 'branch')
    is_plot_branch = true;
    index = 3;
elseif strcmp (plot_data, 'fault')
    is_plot_branch = false;
    index = 2;
end
ss=size(faults);
number_of_session = ss (2);

time_vec = data{1}(:, 1);
st = size (time_vec);
number_of_time = st (1);

Xs = [];
Ys = [];
maxnum = 0;
cd = zeros (number_of_time, number_of_session);
for i=1:number_of_session
    Xs=horzcat (Xs, time_vec);
    cr = data{i}(:, index);
    scr = size(cr);
    if cr(scr(1)) > maxnum
        maxnum = cr(scr(1));
    end
    Ys=horzcat (Ys, cr);
    cd(:, i) = data{i}(:, index);
end

if strcmp (central_method, 'median')
   ccd = median (cd, 2); 
elseif strcmp (central_method, 'mean')
   ccd = mean (cd, 2);
end

sdd = std (cd, 0, 2) ./ ccd * 100;

Xs = horzcat (Xs, Xs(:,1));
Ys = horzcat (Ys, ccd(:,1));
[AX,H1,H2] = plotyy (Xs, Ys, Xs(:,1), sdd(:,1));

xlim (AX(1), [start_time, end_time]);
xlim (AX(2), [start_time, end_time]);
ylim (AX(2), [0, 100]);
if is_plot_branch == true  
else
    number_of_faults = maxnum;
    ylim (AX(1), [0, number_of_faults + 1]);
    set(AX(1), 'YTick', 0:1:number_of_faults + 1);
end

%set(AX(1), 'YTick', 0:number_of_faults + 1);
set(AX(2), 'YTick', 0:10:100);

%h = plot (Xs, Ys, Xs(:,1), ccd(:, 1), Xs(:,1), sdd(:,1));
%set(h(number_of_session+1),'LineWidth', 2);
%set(h(number_of_session+1),'Color', 'k');

%set(h(number_of_session+2),'LineWidth', 2);
%set(h(number_of_session+2),'Color', 'r');

set(H1(number_of_session+1),'LineWidth', 2);
set(H1(number_of_session+1),'Color', 'k');

set(H2(1),'LineWidth', 2);
set(H2(1),'Color', 'r');

title (graph_title);

%Setup X-axis label.
if time_unit == 1
    time_label = 'Time (seconds)';
elseif time_unit == 60
    time_label = 'Time (minutes)';
elseif time_unit == 3600 
    time_label = 'Time (hours)';
else
    time_label = 'Time';
end
xlabel (time_label);
h = [H1(number_of_session + 1), H2(1)];
if is_plot_branch == true
    set(get(AX(1),'Ylabel'),'String','Number of branches');  
    l1 = 'Mean of No. branches';
    l2 = 'CV of Mean of No. branches';    
else
    set(get(AX(1),'Ylabel'),'String','Number of faults');    
    l1 = 'Mean of No. faults';
    l2 = 'CV of Mean of No. faults';
end

legend (h, l1, l2, 'Location', 'Best');

set(get(AX(2),'Ylabel'),'String','Coefficient of Variation (CV)');

Result = size(H2);





