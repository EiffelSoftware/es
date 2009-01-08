function Result = plot_fault_over_time(classes, faults, branches, start_time, end_time, time_unit, central_method)
% Load branch coverage data.
% `classes' is a cell array containing the list of names of classes.
% `faults' is a cell array containing the fault data of corresponding class in `classes'.
% `branches' is a cell array containing the branch data of corresponding class in `classes'.

sz = size (classes);
number_of_class = sz(2);


X=[];
Y=[];

central_faults = {};
central_branches = {};
max_number_of_fault = 0;
for i=1:number_of_class
    [cf, cb] = central_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit, central_method);
    sz = size (cf{1});
    number_of_fault = sz(1);
    max_number_of_fault = max (max_number_of_fault, number_of_fault);
    
    X = horzcat (X, cf{1}(:, 1));
    Y = horzcat (Y, cf{1}(:, 2));
end

handles = plot (X, Y);

%Setup legends.
legend (handles, classes, 'Location', 'EastOutside');

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

%Setup Y-axis label.
ylabel ('Number of faults');
set(gca,'YTick',0:0.05:1.2);
Result = 0;




