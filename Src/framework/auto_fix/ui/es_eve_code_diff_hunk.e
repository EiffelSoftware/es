note
	description: "Code diff hunk"

class
	ES_EVE_CODE_DIFF_HUNK

create
	make

feature	{NONE} -- Initialization

	make (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_base_code, a_diff_code: STRING)
			-- Initialization.
		require
			context_attached: a_context_class /= Void
			context_feature_attached: a_context_feature /= Void
			code_attached: a_base_code /= Void and then a_diff_code /= Void
		do
			context_class := a_context_class
			context_feature := a_context_feature
			base_code := a_base_code.twin
			diff_code := a_diff_code.twin
		end

feature -- Access

	context_class: CLASS_C
			-- Context class.

	context_feature: FEATURE_I
			-- Context feature.

	base_code: STRING
			-- Base code fragment.

	diff_code: STRING
			-- Diff code fragment.

feature -- Access

	base_code_with_padding: STRING
			-- Base code fragment, with extra empty padding lines to align with `diff_code_with_padding'.
		do
			if base_code_with_padding_cache = Void then
				compute_difference
			end
			Result := base_code_with_padding_cache
		end

	diff_code_with_padding: STRING
			-- Diff code fragment, with extra empty padding lines to align with `base_code_with_padding'.
		do
			if diff_code_with_padding_cache = Void then
				compute_difference
			end
			Result := diff_code_with_padding_cache
		end

	different_line_segments: LINKED_LIST [TUPLE[start: INTEGER; finish: INTEGER]]
			-- Different line segments between `base_code_with_padding' and `diff_code_with_padding'.
		do
			if different_line_segments_cache = Void then
				compute_difference
			end
			Result := different_line_segments_cache
		end

feature {NONE} -- Implementation

	compute_difference
			-- Compute the difference between `base_code' and `diff_code',
			-- Make the results available in `base_code_with_padding', `diff_code_with_padding',
			--		`base_different_line_segments', and `diff_different_line_segments'.
		local
			l_tmp_base, l_tmp_diff: STRING
			l_base_lines, l_diff_lines: ARRAY [TUPLE[orig: STRING; core: STRING]]
			l_table: ARRAY [ARRAY [INTEGER]]
			l_LCS: ARRAYED_LIST [STRING]
		do
			l_base_lines := string_to_line_array (base_code)
			l_diff_lines := string_to_line_array (diff_code)
			l_table := compute_LCS_length (l_base_lines, l_diff_lines)
			l_lcs := one_lcs (l_table, l_base_lines, l_diff_lines, l_base_lines.upper, l_diff_lines.upper)
			compute_difference_with_paddings (l_lcs, l_base_lines, l_diff_lines)
		end

	string_to_line_array (a_string: STRING): ARRAY [TUPLE[orig: STRING; core: STRING]]
			-- Split `a_string' to an array of lines
			-- 		orig: original line
			-- 		core: line without leading/trailing white space characters.
			-- 		Result index starts from 1.
		require
			string_attached: a_string /= Void
		local
			i: INTEGER
			l_new_count: INTEGER
			l_tmp, l_line: STRING
			l_lines: LIST [STRING]
		do
			l_tmp := a_string.twin
			l_tmp.prune_all ('%R')
			l_lines := l_tmp.split ('%N')
			if l_lines.is_empty then
				l_new_count := 1
			else
				l_new_count := l_lines.count
			end
			create Result.make (1, l_new_count)
			from
				l_lines.start
				i := 1
			until l_lines.after
			loop
				l_tmp := l_lines.item_for_iteration
				l_line := l_tmp.twin
				l_line.prune_all_leading (' ')
				l_line.prune_all_leading ('%T')
				l_line.prune_all_trailing (' ')
				l_line.prune_all_trailing ('%T')
				Result.put ([l_tmp, l_line], i)
				i := i + 1

				l_lines.forth
			end
		end

	compute_LCS_length (l_lhs, l_rhs: ARRAY [TUPLE[orig: STRING; core: STRING]]): ARRAY [ARRAY [INTEGER]]
			-- Compute the length of the longest-common-subsequence between `l_lhs' and `l_rhs',
			-- return the LCS-table.
		require
			lists_attached: l_lhs /= Void and then l_rhs /= Void
		local
			i, j: INTEGER
		do
				-- Initialize the result table.
			create Result.make (0, l_lhs.count)
			from i := 0
			until i > l_lhs.count
			loop
				Result.put (create {ARRAY [INTEGER]}.make (0, l_rhs.count), i)
				i := i + 1
			end

			from i := 1
			until i > l_lhs.count
			loop
				from j := 1
				until j > l_rhs.count
				loop
					if l_lhs[i].core ~ l_rhs[j].core then
						Result[i].put (Result[i-1].item(j-1) + 1, j)
					else
						Result[i].put(Result[i].item(j-1).max (Result[i-1].item(j)), j)
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	one_LCS (a_LCS_table: ARRAY [ARRAY [INTEGER]]; l_lhs, l_rhs: ARRAY [TUPLE[orig: STRING; core: STRING]]; i, j: INTEGER): ARRAYED_LIST [STRING]
			-- One LCS between `l_lhs'[1..i] and `l_rhs'[1..j].
		local
			l_list: ARRAYED_LIST [STRING]
		do
			if i = 0 or j = 0 then
				create Result.make (1)
			elseif l_lhs[i].core ~ l_rhs[j].core then
				Result := one_LCS (a_LCS_table, l_lhs, l_rhs, i - 1, j - 1)
				Result.extend (l_lhs[i].core.twin)
			else
				if a_LCS_table[i].item (j-1) > a_LCS_table[i-1].item (j) then
					Result := one_LCS (a_LCS_table, l_lhs, l_rhs, i, j-1)
				else
					Result := one_LCS (a_LCS_table, l_lhs, l_rhs, i-1, j)
				end
			end
		end

	compute_difference_with_paddings (a_LCS: ARRAYED_LIST [STRING]; l_lhs, l_rhs: ARRAY [TUPLE[orig: STRING; core: STRING]])
			-- Compute the difference between `base_code' and `diff_code',
			-- Store the results in attributes.
		local
			pre_line_index, line_index: INTEGER
			l_lindex, l_rindex, l_cindex: INTEGER
			l_seg_start, l_seg_end: INTEGER
			l_is_sync: BOOLEAN
			l_current_core: STRING
		do
			from
				create base_code_with_padding_cache.make (256)
				create diff_code_with_padding_cache.make (256)
				create different_line_segments_cache.make
				pre_line_index := 1
				line_index := 1
				l_lindex := l_lhs.lower
				l_rindex := l_rhs.lower
				l_seg_start := 1
				l_seg_end := 1
				a_LCS.start
			until
				a_LCS.after
			loop
				l_current_core := a_LCS.item_for_iteration

					-- Adding lines from `l_lhs' to `base_code_with_padding', and empty lines to `diff_code_with_padding', until `l_current_core' is found.
				from
				until l_lindex > l_lhs.upper or else l_lhs[l_lindex].core ~ l_current_core
				loop
					base_code_with_padding_cache.append (l_lhs[l_lindex].orig + "%N")
					diff_code_with_padding_cache.append ("%N")
					l_lindex := l_lindex + 1
					line_index := line_index + 1
				end

					-- Adding lines from `l_rhs' to `diff_code_with_padding', and empty lines to `base_code_with_padding', until `l_current_core' is found.
				from
				until l_rindex > l_rhs.upper or else l_rhs[l_rindex].core ~ l_current_core
				loop
					diff_code_with_padding_cache.append (l_rhs[l_rindex].orig + "%N")
					base_code_with_padding_cache.append ("%N")
					l_rindex := l_rindex + 1
					line_index := line_index + 1
				end

				if line_index /= pre_line_index then
					different_line_segments_cache.extend ([pre_line_index, line_index])
				end

				if l_lindex <= l_lhs.upper then
					base_code_with_padding_cache.append (l_lhs[l_lindex].orig + "%N")
					l_lindex := l_lindex + 1
				end
				if l_rindex <= l_rhs.upper then
					diff_code_with_padding_cache.append (l_rhs[l_rindex].orig + "%N")
					l_rindex := l_rindex + 1
				end
				line_index := line_index + 1
				pre_line_index := line_index

				a_LCS.forth
			end

				-- Everything left at the tails of lhs and rhs.
			from until l_lindex > l_lhs.upper
			loop
				base_code_with_padding_cache.append (l_lhs[l_lindex].orig + "%N")
				diff_code_with_padding_cache.append ("%N")
				l_lindex := l_lindex + 1
				line_index := line_index + 1
			end
			from until l_rindex > l_rhs.upper
			loop
				diff_code_with_padding_cache.append (l_rhs[l_rindex].orig + "%N")
				base_code_with_padding_cache.append ("%N")
				l_rindex := l_rindex + 1
				line_index := line_index + 1
			end
			if line_index /= pre_line_index then
				different_line_segments_cache.extend ([pre_line_index, line_index])
			end
		end

feature {NONE} -- Cache

	base_code_with_padding_cache: STRING
			-- Cache for `base_code_with_padding'.

	diff_code_with_padding_cache: STRING
			-- Cache for `diff_code_with_padding'.

	different_line_segments_cache: like different_line_segments
			-- Cache for `different_line_segments'.

invariant
	context_attached: context_class /= Void
	base_code_attached: base_code /= Void
	diff_code_attached: diff_code /= Void

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
