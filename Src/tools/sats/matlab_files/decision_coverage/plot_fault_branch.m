function Result = plot_fault_branch (faults, branches, session_index, start_time, end_time, time_unit, swap)
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
fault_branch_tbl = data{session_index};
if swap == true
    scatter (fault_branch_tbl(:, 2), fault_branch_tbl (:, 3));    
    xlabel ('Number of faults');
    ylabel ('Number of covered branches');
    title ('Correlation between faults and branches');
else
    scatter (fault_branch_tbl(:, 3), fault_branch_tbl (:, 2));
    xlabel ('Number of covered branches');
    ylabel ('Number of faults');
    title ('Correlation between branches and faults');
end

Result = corrcoef (fault_branch_tbl (:, 2), fault_branch_tbl (:, 3));
text (20, 50, ['correlation coeffcient: ', num2str(Result(1, 2))]);





