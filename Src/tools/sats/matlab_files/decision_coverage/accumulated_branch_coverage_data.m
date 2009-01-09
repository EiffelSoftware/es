function [acc_faults, acc_branches] = accumulated_branch_coverage_data (faults, branches, start_time, end_time, time_unit)
% Accumulated branch coverage data from `faults' and `branches.
% 
% `faults' is a row cell array, each element in this array is a table of the
% form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is a row cell array, each element in this array is a table of the
% form [branch_id, visited_times, first_visit_time, first_visit_test_case_index].
% 
% `acc_faults' is a row cell array, each element in this array is a table of
% the form [time, number_of_found_faults_until_time].
% `acc_branches' is a row cell array, each element in this array is a table of
% the form [time, number_of_visited_branches_until_time].

[fault_rows, fault_columns] = size (faults);
[branch_rows, branch_columns] = size (branches);

acc_faults = {};
acc_branches = {};

% Only proceed when the size of `faults' and `branches' match.
if fault_rows ==1 && branch_rows ==1 && fault_columns == branch_columns
    session_count = fault_columns;
    for i = 1:session_count
        % Get faults for current test session.
        curr_faults = faults{i};
        fid = find (curr_faults(:,2)>0);
        curr_faults = curr_faults(fid, [1, 3]);
%        curr_faults = curr_faults(:, [1, 3]);
        acc_faults = horzcat (acc_faults, accumulated_event_time_table (curr_faults, start_time, end_time, time_unit));
        
        % Get branches for current test session.
        curr_branches = branches{i};
        visited_branches = curr_branches (find(curr_branches(:,2)>0), [1, 3]);
        acc_branches = horzcat (acc_branches, accumulated_event_time_table (visited_branches, start_time, end_time, time_unit));        
    end
end

Result = [acc_faults, acc_branches];


