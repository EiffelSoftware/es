function Result = plot_accumulated_fault_branch_time (acc_faults, acc_branches, branches, session_index, start_time, end_time, time_unit)
% Draw number of faults, number of covered branches against time in a 2D plot.
% `faults' is of form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is of form [branch_id, visited_times, first_visit_time, first_visit_test_case_index].
% `start_time' and `end_time' defines the time zone in which result should
% be calculated.
% `time_unit' is of unit second.
% `session_index' indicates which session to plot.
% Result is the correlation coefficient matrix of faults and branches.

% Draw curves in current active figure.
data = fault_branch_table (acc_faults, acc_branches);
fault_branch_tbl = data{session_index};

% Calculate the number of branches.
s = size (branches{session_index});
number_of_branches = s(1);

% Calculate the number of faults.
s = size (acc_faults{session_index});
number_of_faults = acc_faults{session_index}(s(1), 2);

[AX,H1,H2] = plotyy (fault_branch_tbl (:, 1), fault_branch_tbl (:, 2), fault_branch_tbl (:, 1), fault_branch_tbl (:, 3)/number_of_branches * 100);

xlim (AX(1), [start_time, end_time]);
xlim (AX(2), [start_time, end_time]);
ylim (AX(2), [0, 100]);
ylim (AX(1), [0, number_of_faults + 1]);
set(AX(1), 'YTick', 0:number_of_faults + 1);
set(AX(2), 'YTick', 0:10:100);

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
set(get(AX(1),'Ylabel'),'String','Number of faults');
set(get(AX(2),'Ylabel'),'String','Percentage of covered branches');
set(H1,'LineWidth', 2);
set(H2,'LineWidth', 2);
legend ('Faults', 'Branches', 'Location', 'SouthEast');
Result = corrcoef (fault_branch_tbl (:, 2), fault_branch_tbl (:, 3));
text (end_time / 10, 1, ['correlation coeffcient: ', num2str(Result(1, 2))]);
