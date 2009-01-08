function [faults, branches] = branch_coverage_data_from_file (base_dir)
% Load faults.txt in `base_dir' into `faults' in form of [fault_id, found_times, first_found_time, first_found_test_case_index]
% Load branches.txt in `base_dir' into `branches' in form of [branch_id, visited_times, first_visit_time, first_visit_test_case_index].

% Load faults.txt.
[fault_id, visited_times, fist_visit_time, first_visit_test_case_index] = textread ([base_dir, filesep, 'faults.txt'], '%d\t%d\t%d\t%d\t', 'headerlines', 1);
faults = [fault_id, visited_times, fist_visit_time, first_visit_test_case_index];

% Load branches.txt.
[branch_id, bvisited_times, bfist_visit_time, bfirst_visit_test_case_index] = textread ([base_dir, filesep, 'branches.txt'], '%d\t%d\t%d\t%d\t', 'headerlines', 1);
branches = [branch_id, bvisited_times, bfist_visit_time, bfirst_visit_test_case_index];
