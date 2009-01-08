function [faults, branches]= branch_coverage_data_from_files (base_directory_name, start_index, end_index, original)
% Load data stored in files named `file_name' in subdirectories defined by
% `start_index' and `end_index', all subdirectories are located in `base_directory_name'.
% If `original' is true, load original faults, otherwise load faults.
% `faults' is a cell array, each element of the array is a table of the
% form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is a cell array, each element of the array is a table of the
% form [branch_id, visited_times, first_visit_time, first_visit_]

% Loop through all indexes,
j = 1;
faults={};
branches={};

for i=start_index:end_index
    % Load one fault file.
    if original == true
        fault_file_name = [base_directory_name, filesep, int2str(i), filesep, 'original_faults.txt'];
    else
        fault_file_name = [base_directory_name, filesep, int2str(i), filesep, 'faults.txt'];
    end
    [fault_id, visited_times, first_visit_time, first_visit_test_case_index]=textread(fault_file_name, '%d\t%d\t%d\t%d', 'headerlines', 1);
    first_visit_time(find (first_visit_time==0), 1) = 1;
    faults = horzcat (faults, [fault_id, visited_times, first_visit_time, first_visit_test_case_index]);
    
    % Load one branch file.
    branch_file_name = [base_directory_name, filesep, int2Str(i), filesep, 'branches.txt'];
    [branch_id, bvisited_times, bfirst_visit_time, bfirst_visit_test_case_index]=textread(branch_file_name, '%d\t%d\t%d\t%d', 'headerlines', 1);    
    bfirst_visit_time(find (bfirst_visit_time==0), 1) = 1;
    branches = horzcat (branches, [branch_id, bvisited_times, bfirst_visit_time, bfirst_visit_test_case_index]);
    j = j + 1;
end

Result = [faults, branches];

