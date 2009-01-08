function Result = session_branch_data (branches, start_time, end_time, time_unit, graph_title)
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
Result = zeros(number_of_session, number_of_branches);

for i=1:number_of_session
    bch=branches{i}(:,3);
    bch_id = find (bch>=start_time * time_unit & bch<=end_time * time_unit);
    Result(i,bch_id) = 1; %branches{i}(bch_id, 2);
end

h = pcolor (Result)
Xlabel ('Branch ID');
Ylabel ('Test Session ID');
colormap summer;

if time_unit == 1
    tunit = 'second';
elseif time_unit == 60
    tunit = 'minute';
end

if start_time == 0
    s1 = int2str(end_time);
    str= [' by the end of ', s1, ' ',  tunit];
else
    s1 = int2str(start_time);
    s2 = int2str(end_time);
    str= strcat (' from ', s1, tunit, ' to ', s2, tunit);
end
t=['Branch coverage (', graph_title, ') ', str];
title (t);


