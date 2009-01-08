function Result = fault_branch_table (acc_faults, acc_branches)
% `acc_faults' is a row cell array, each element in this array is a table of
% the form [time, number_of_found_faults_until_time].
% `acc_branches' is a row cell array, each element in this array is a table of
% the form [time, number_of_visited_branches_until_time].

% Result is a row cell array, every element in this array is a table of the
% form [time, number_of_found_faults_until_time, number_of_covered_branches_until_time]

[fault_rows, fault_columns] = size (acc_faults);
[branch_rows, branch_columns] = size (acc_branches);

Result = {};

% Only proceed when the size of `faults' and `branches' match.
if fault_rows ==1 && branch_rows ==1 && fault_columns == branch_columns    
    session_count = fault_columns;
    for i = 1:session_count
        curr_acc_faults = acc_faults{i};
        curr_acc_branches = acc_branches {i};        
        Result = horzcat (Result, [curr_acc_faults, curr_acc_branches(:, 2)]);
    end
end




