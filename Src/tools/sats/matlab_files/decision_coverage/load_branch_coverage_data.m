function [classes, faults, branches] = load_branch_coverage_data (base_directory_name, number_of_session)
% Load branch coverage data.
% `base_directory_name' is the directory where result files are stored.
% `number_of_session' is an integer indicating how many sessions per class.
% `classes' is a cell array containing the list of names of classes.
% `faults' is a cell array containing the fault data of corresponding class in `classes'.
% `branches' is a cell array containing the branch data of corresponding class in `classes'.

is_original_faults=true;
start_index=1;
end_index=number_of_session;

classes={'HASH_TABLE', 'FIXED_LIST', 'ARRAYED_STACK', 'LINKED_LIST', 'ARRAYED_LIST', 'BINARY_TREE', 'ACTIVE_LIST', 'ARRAYED_SET', 'BINARY_SEARCH_TREE', 'BINARY_SEARCH_TREE_SET', 'LINKED_CIRCULAR'};
faults={};
branches={};

sz = size (classes);
number_of_class = sz(2);

for i=1:number_of_class
    [f, b] = branch_coverage_data_from_files ([base_directory_name, filesep, classes{i}], start_index, end_index, is_original_faults); 
    faults = horzcat (faults, {f});
    branches = horzcat (branches, {b});
end
classes={'HASH\_TABLE', 'FIXED\_LIST', 'ARRAYED\_STACK', 'LINKED\_LIST', 'ARRAYED\_LIST', 'BINARY\_TREE', 'ACTIVE\_LIST', 'ARRAYED\_SET', 'BINARY\_SEARCH\_TREE', 'BINARY\_SEARCH\_TREE\_SET', 'LINKED\_CIRCULAR'};

