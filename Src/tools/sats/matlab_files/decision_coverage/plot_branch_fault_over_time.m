function Result = plot_branch_fault_over_time(classes, faults, branches, normalized_faults, normalized_branches, start_time, end_time, time_unit, selected_classes)
% Scatter the correlation between branch coverage and detected faults.


data = {};

%Calculate number of class.
sz = size (selected_classes);
number_of_class = sz(1,2);

%Calculate number of sessions for each class.
sz = size(faults{1});
number_of_session = sz(1,2);

%Calculate number of time.
number_of_time = end_time - start_time + 1;

for j=1:number_of_class
    i = selected_classes(j);
    [cf, cb] = central_branch_coverage_data (faults{i}, branches{i}, start_time, end_time, time_unit, 'median');
    sz = size (branches{i}{1});
    number_of_branch = sz(1);

    cdata = horzcat ((start_time:end_time)', cb{1}(:,2)./ number_of_branch, cf{1}(:,2)./normalized_faults{i});
    data = horzcat (data, {cdata});
end
 
figure;
cols = 4;
rows = number_of_class / cols;
if rows < 1 
    rows = 1;
end

for i=1:number_of_class
    subplot (rows, cols, i);    
    [AX,H1,H2] = plotyy (data{i}(:,1), data{i}(:,2), data{i}(:, 1), data{i}(:, 3));
    
    %    set(gca,'YTick',0:0.25:1);
%    set(gca,'XTick',0:0.25:1);

    title (classes{i});
%    xlabel ('Branch coverage level');
%   ylabel ('Normalized faults');

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
    xlim(AX(1), [start_time, end_time]);
    xlim(AX(2), [start_time, end_time]);
    ylim(AX(1), [0, 1.1]);
    ylim(AX(2), [0, 1.1]);
    set(get(AX(1),'Ylabel'),'String','Branch'); 
    set(get(AX(2),'Ylabel'),'String','Fault');
    
    xlim ([start_time, end_time]);
    
    set (H2, 'LineWidth', 2);
    legend ('Branch', 'Fault', 'Location', 'SouthEast');

end

    
Result = 0;

