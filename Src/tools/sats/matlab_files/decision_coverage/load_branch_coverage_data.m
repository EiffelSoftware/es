function [classes, faults, branches, normalized_faults, normalized_branches] = load_branch_coverage_data (base_directory_name, number_of_session)
% Load branch coverage data.
% `base_directory_name' is the directory where result files are stored.
% `number_of_session' is an integer indicating how many sessions per class.
% `classes' is a cell array containing the list of names of classes.
% `faults' is a cell array containing the fault data of corresponding class in `classes'.
% `branches' is a cell array containing the branch data of corresponding class in `classes'.
% `normalized_faults' is a cell array, each element in this array is a
% number indicating the total number of faults found for the corresponding
% class.
% `normalized_branches' is a cell array, each element in this array is a
% number indicating the total number of branches exercised for the
% corresponding class.

is_original_faults=true;
start_index=1;
end_index=number_of_session;
classes={'ACTIVE_LIST', 'ARRAY', 'ARRAYED_LIST', 'ARRAYED_SET', 'ARRAYED_STACK', 'BINARY_SEARCH_TREE', 'BINARY_SEARCH_TREE_SET', 'BINARY_TREE', 'FIXED_LIST', 'HASH_TABLE', 'HEAP_PRIORITY_QUEUE', 'LINKED_CIRCULAR', 'LINKED_LIST', 'PART_SORTED_TWO_WAY_LIST'}
faults={};
branches={};
normalized_faults={};
normalized_branches={};

sz = size (classes);
number_of_class = sz(2);

for i=1:number_of_class
    [f, b, nf, nb] = branch_coverage_data_from_files ([base_directory_name, filesep, classes{i}], start_index, end_index, is_original_faults); 
    faults = horzcat (faults, {f});
    branches = horzcat (branches, {b});
    normalized_faults = horzcat (normalized_faults, {nf});
    normalized_branches = horzcat (normalized_branches, {nb});    
end
classes={'ACTIVE\_LIST', 'ARRAY', 'ARRAYED\_LIST', 'ARRAYED\_SET', 'ARRAYED\_STACK', 'BINARY\_SEARCH\_TREE', 'BINARY\_SEARCH\_TREE\_SET', 'BINARY\_TREE', 'FIXED\_LIST', 'HASH\_TABLE', 'HEAP\_PRIORITY\_QUEUE', 'LINKED\_CIRCULAR', 'LINKED\_LIST', 'PART\_SORTED\_TWO\_WAY\_LIST'}


