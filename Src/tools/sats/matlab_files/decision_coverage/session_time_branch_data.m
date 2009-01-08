function [sessions, times, branch_coverage]= session_time_branch_data (branches, start_time, end_time, time_unit)
% Load data stored in files named `file_name' in subdirectories defined by
% `start_index' and `end_index', all subdirectories are located in `base_directory_name'.
% If `original' is true, load original faults, otherwise load faults.
% `faults' is a cell array, each element of the array is a table of the
% form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is a cell array, each element of the array is a table of the
% form [branch_id, visited_times, first_visit_time, first_visit_]

% Loop through all indexes,


sb=size(branches);
number_of_session = sb(2);

sb=size(branches{1});
number_of_branches = sb(1); 

number_of_time=end_time - start_time + 1;

total_num = number_of_session * number_of_branches * number_of_time;
sessions=zeros(1, total_num);
times=zeros(1, total_num);
branch_coverage = zeros(1, total_num);

number_of_dot = 1;

for i=1:number_of_session
    for j=start_time:end_time
        time_now = j * time_unit;
        bch=branches{i}(:,3);
        bch_id = find (bch>=0 & bch<=time_now);
        visited_branches = branches{i}(bch_id, 1);
        s=size(visited_branches);
        for k=1:s(1)
            sessions(number_of_dot) = i;
            times (number_of_dot) = j;
            branch_coverage (number_of_dot) = visited_branches(k);
            number_of_dot = number_of_dot + 1;
        end
    end
end
sessions = sessions(1, 1:number_of_dot-1)';
times = times(1, 1:number_of_dot-1)';
branch_coverage = branch_coverage (1, 1:number_of_dot-1)';


