function Result = sorted_by_column (matrix, column, order)
% Sort `matrix' by `column' by `order', return the sorted matrix in Result.
%
[old_rows, new_rows] = sort (matrix(:, column), order);
Result = matrix(new_rows, :);
