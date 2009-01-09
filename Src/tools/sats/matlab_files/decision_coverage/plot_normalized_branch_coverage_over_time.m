function [median_cov, std_cov, median_cov_over_time] = plot_normalized_branch_coverage_over_time(classes, faults, branches, normalized_faults, normalized_branches, start_time, end_time, time_unit, central_method)
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
for i=1:number_of_class
    [cf, cb] = central_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit, central_method);
    sz = size (branches{i}{1});
    number_of_branch = sz(1);
    
    X = horzcat (X, cb{1}(:, 1));
    Y = horzcat (Y, (cb{1}(:, 2) ./ normalized_branches{i}) .* 100);
end

%Calculate the median of coverage levels over classes at the end of test
%runs.
sz = size (Y);
number_of_time = sz(1);
median_cov = median (Y (number_of_time, :));
std_cov = std (Y (number_of_time, :));

%Calculate the median of branch coverage over time.
X = horzcat (X, cb{1}(:, 1));

mcov = zeros(number_of_time, 1);

for i=1:number_of_time
    mm = Y(i, :);
    mcov(i) = median (mm);
end
Y = horzcat (Y, mcov);
median_cov_over_time = mcov;

figure
handles = plot (X, Y);
set (handles(number_of_class+1), 'LineWidth', 2);
set (handles(number_of_class+1), 'Color', 'k');
%Setup legends.
lgd_names =horzcat (classes, {'Median of medians'});
legend (handles, lgd_names, 'Location', 'NortheastOutside');

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
xlim ([0, 360]);
ylim ([50, 110])
%Setup Y-axis label.
ylabel ('% of branch coverage');





