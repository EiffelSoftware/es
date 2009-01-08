function Result = accumulated_event_time_table (event_table, start_time, end_time, time_unit)
% `event_table' is a two column matrix:
% [event_id, first_found_time]
% time_unit is an integer indicating the time unit in second.
% The result is a two column matrix:
% [number_of_events, time]
% For example, if `event_table' is [fault_id, first_found_time],
% and start_time is 0, end_time is 10, and time_unit is 60, this means calculate the accumulated found faults from
% 0 minute to 10 minute (because time_unit is 60s), and the result would be [number_of_faults_until_time, time]

[row_count, column_count] = size(event_table);
%TODO: Check that the size of `event_table' is N-by-2].

first_found_time_column = 2;

%Sort event_table by first found time.
sorted_event_table = sorted_by_column (event_table, first_found_time_column, 'ascend');


if start_time == 0
    Result = [0, 0];
    start_index = 1;
else
    Result = [];
    start_index = 0;
end
j = 1;
events = 0; %Counter to store the number of times that an event has happened so far.
time_point = start_time * time_unit + time_unit * start_index;

for i = start_index:end_time - start_time
    while ~(j>row_count || sorted_event_table (j, first_found_time_column) > time_point)
        events = events + 1;
        j = j + 1;
    end
	 %TODO: Here Result will get reallocated eveytime, consider reallocating it to a reasonable large enough matrix at first.
    Result = [Result; [start_time + i, events]];
    time_point = time_point + time_unit;
end
