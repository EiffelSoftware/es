function [central_faults, central_branches] = central_branch_coverage_data (faults, branches, start_time, end_time, time_unit, central_method)
% Central data for `faults' and `branches'.
% `faults' is of form [fault_id, found_times, first_found_time, first_found_test_case_index].
% `branches' is of form [branch_id, visited_times, first_visit_time, first_visit_test_case_index].
% `start_time' and `end_time' defines the time zone in which result should
% be calculated.
% `time_unit' is of unit second.
% `session_index' indicates which session to plot.
% `central_method' can be string of form 'median', 'average', 'mode'
% `central_faults' is a cell array with only one cell, that cell is a matrix
% of form [time, number_of_faults_until_time].
% `central_branches' is a cell array with one one cell, that cell is a
% metrix of form [time, number_of_branches_until_time].

[acc_faults, acc_branches] = accumulated_branch_coverage_data (faults, branches, start_time, end_time, time_unit);
data = fault_branch_table (acc_faults, acc_branches);
session_size = size (acc_faults);
time_size = size (acc_faults{1});
number_of_session = session_size (2);
number_of_time = time_size (1);
time_slots=acc_faults{1}(:,1);

ccfaults = [];
ccbranches = [];
for i=1:number_of_time
    cfaults=[];
    cbranches=[];
    rfaults=[];
    rbranches=[];
    for j=1:number_of_session
         rfaults=[rfaults, acc_faults{j}(i,2)];
         rbranches=[rbranches, acc_branches{j}(i,2)];
    end
    
    if strcmp (central_method, 'mean')
        m=mean (rfaults);
        ccfaults = vertcat (ccfaults, [time_slots(i), m]);
        m=mean (rbranches);
        ccbranches = vertcat (ccbranches, [time_slots(i), m]);
        
    elseif strcmp (central_method, 'median')
        m=median(rfaults);
        ccfaults = vertcat (ccfaults, [time_slots(i), m]);
        m=median (rbranches);
        ccbranches = vertcat (ccbranches, [time_slots(i), m]);
    end
end

central_faults = {ccfaults};
central_branches = {ccbranches};

