function [mdn_normalized_fault] = plot_normalized_fault_over_time(classes, faults, branches, normalized_faults, start_time, end_time, time_unit, central_method)
% Load branch coverage data.
% `classes' is a cell array containing the list of names of classes.
% `faults' is a cell array containing the fault data of corresponding class in `classes'.
% `branches' is a cell array containing the branch data of corresponding class in `classes'.

% mdn_normalized_fault is a table of form
% [time, median of medians of normalized faults over time]
sz = size (classes);
number_of_class = sz(2);


X=[];
Y=[];

central_faults = {};
central_branches = {};
max_number_of_fault = 0;
for i=1:number_of_class
    [cf, cb] = central_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit, central_method);
    cf{1}(:,2) = cf{1}(:,2) ./ normalized_faults{i};
    sz = size (cf{1});
    number_of_fault = sz(1);
    max_number_of_fault = max (max_number_of_fault, number_of_fault);
    
    X = horzcat (X, cf{1}(:, 1));
    Y = horzcat (Y, cf{1}(:, 2));
end

%Calculate median of normalized faults over classes.
number_of_time = end_time - start_time + 1;
mdn_norf = zeros (number_of_time, 1);
for i=1:number_of_time
    mm = median (Y(i,:));
    mdn_norf(i) = mm;
end

X = horzcat (X, (start_time:end_time)');
Y = horzcat (Y, mdn_norf);
mdn_normalized_fault = horzcat ((start_time:end_time)', mdn_norf);

set(gcf,'DefaultAxesColorOrder',[1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 0 0 0; 0.3216 0.1882 0.1882; 0 0.498 0; 0.4784 0.06275 0.8941; 0.04314 0.5176 0.7804; 0.8706 0.4902 0; 0.2 0.2 0; 0 0.4 0.8; 0.6 0 0.2]);
handles = plot (X, Y);
%Setup legends.
legend_names = horzcat (classes, {'Median of medians'});
legend (handles, legend_names, 'Location', 'NortheastOutside');

set (handles(number_of_class+1), 'LineWidth', 2);
set (handles(number_of_class+1), 'Color', 'k');

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
ylabel ('Number of normalized faults', 'FontSize', 12);
xlim ([0, 360]);
ylim ([0,1.1])
set(gca,'YTick',0:0.1:1.1);
set(gca,'XTick',[0:30:360]);




