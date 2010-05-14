note
	description: "Utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UTILITY

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

feature

	principal_variable_from_anon_content (a_string: STRING): INTEGER
			-- Returns the index of the principal variable by taking the most frequent one
			-- occuring in `a_string'
		local
			l_counts: HASH_TABLE[INTEGER,INTEGER]
			l_pos: INTEGER
			l_in_index: BOOLEAN
			l_cur_index_str: STRING
			l_cur_index: INTEGER
			l_max_count: INTEGER
			l_max: INTEGER
		do
			from
				create l_counts.make (10)
				l_max_count := -1
				l_max := -1
				l_pos := 1
			until
				l_pos > a_string.count
			loop
				if a_string.item (l_pos) = '{' then
					l_in_index := true
					create l_cur_index_str.make (3)
				elseif l_in_index and a_string.item (l_pos) = '}' then
					l_in_index := false
					l_cur_index := l_cur_index.to_integer
					-- Keep track how often a variable occured
					if l_counts.has (l_cur_index) then
						l_counts[l_cur_index] := l_counts[l_cur_index]+1
					else
						l_counts[l_cur_index] := 1
					end

					if l_counts[l_cur_index]>l_max_count then
						l_max_count := l_counts[l_cur_index]
						l_max := l_cur_index
					end
				else
					if l_in_index then
						l_cur_index_str.extend (a_string.item (l_pos))
					end
				end
				l_pos := l_pos + 1
			end

			Result := l_max
		end

end
