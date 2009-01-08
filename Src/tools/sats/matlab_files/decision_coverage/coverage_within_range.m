function Result = coverage_within_range(coverage, start_time, end_time)
% Return coverage from `coverage' within time zone [start_time, end_time]
% start_time and end_time is of second unit.
% coverage can be either a 2 dimentional matrix (for a single test session) or
% a three dimentitional matrix (for a list of test session)

csize = size(coverage);
[r,c]=size(csize)

if c==3 
    % Three dimentional matrix
    data = coverage;
    layers = csize (3);
else
    % Two dimentional matrix
    data(:, :, 1) = coverage;
    layers = 1;
end

rows = csize(1);

temp = [];
visited_times_column  = 2;
first_visit_time_column = 3;
first_visit_test_case_index = 4;

for i = 1:layers
    % Get original coverage data for one layer (test session).
    temp (:, :, i) = data (:, :, i);
    for r = 1:rows
        time = temp(r, first_visit_time_column, i);
        if time >= 0 && (time < start_time || time > end_time)
            % If coverage is out of the time zone, clear it.
            temp (r, visited_times_column, i) = 0;
            temp (r, first_visit_time_column, i) = -1;
            temp (r, first_visit_test_case_index, i) = -1;
        end
    end    
end

if c == 3
    Result = temp;
else
    Result = temp (:, :, 1);
end




