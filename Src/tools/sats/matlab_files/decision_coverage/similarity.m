function Result = similarity (a_branches, b_branches)
% Return the similarity between two branch coverage vectors.
% The range of Result is [0, 1].
% `a_branches' and `b_branches' are a column vectors, an element in the
% i-th position in the column is the number of times that the i-th branch
% have be visited.

sz = size (a_branches);
number_of_branch = sz(1);

% 1 normalize two vectors.
abch = zeros (number_of_branch, 1);
bbch = zeros (number_of_branch, 1);
abch_id = find (a_branches > 0);
abch (abch_id, 1) = 1;
bbch_id = find (b_branches > 0);
bbch (bbch_id, 1) = 1;

% Calculate percentage of branch coverage difference as similarity
bch_dif = 0;
for i=1:number_of_branch
    bch_dif = bch_dif + xor (abch(i), bbch(i));
end
Result = (1 - bch_dif / number_of_branch);


%coef=corrcoef(abch, bbch);
%Result =coef(1,2);

% Calculate angle between two vectors as similarity
%Result = (sum(abch.*bbch)) / (sqrt(sum(abch.^2)) * sqrt(sum(bbch.^2)));