note
	description: "Summary description for {ES_ADB_FIX_CONTRACT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIX_CONTRACT

inherit
	ES_ADB_FIX_AUTOMATIC

create
	make

feature{NONE} -- Initialization

	make (a_fault: ES_ADB_FAULT; a_id_string: STRING; a_fix_text: STRING; a_nature_str: STRING; a_ranking: REAL)
			-- Initialization.
		require
			a_fault /= Void
			a_id_string /= Void and then not a_id_string.is_empty
			is_valid_nature_of_change (nature_of_change_from_string (a_nature_str))
			Ranking_maximum >= a_ranking and then a_ranking >= Ranking_minimum
		local
		do
			make_automatic (a_fault, a_id_string)
			fix_text := a_fix_text.twin
			set_nature_of_change (nature_of_change_from_string (a_nature_str))
			has_change_to_implementation := False
			has_change_to_contract := True
			has_been_applied := False
			type := Type_contract_fix
			set_ranking (a_ranking)

			a_fault.add_fix (Current)
		end

feature -- Access

	code_before_fix: STRING
			-- <Precursor>
		do
			if code_before_fix_internal = Void then
				initialize_code_before_and_after_fix
			end
			Result := code_before_fix_internal
		end

	code_after_fix: STRING
			-- <Precursor>
		do
			if code_after_fix_internal = Void then
				initialize_code_before_and_after_fix
			end
			Result := code_after_fix_internal
		end

feature -- Status report

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- <Precursor>
		do
			Result := Nature_strengthen <= a_nature and then a_nature <= Nature_weaken_and_strengthen
		end

feature -- Query

	nature_of_change_strings: DS_HASH_TABLE [STRING_8, INTEGER]
			-- <Precursor>
		do
			if nature_of_change_strings_internal = Void then
				create nature_of_change_strings_internal.make_equal (10)
				nature_of_change_strings_internal.force ("Strengthen", Nature_strengthen)
				nature_of_change_strings_internal.force ("Weaken", Nature_weaken)
				nature_of_change_strings_internal.force ("Weaken and strengthen", Nature_weaken_and_strengthen)
			end
			Result := nature_of_change_strings_internal
		end

feature -- Operation

	apply
			-- Set `has_been_applied' to True.
			-- WARNING: changes to contracts need to be applied manually.
		require
			not has_been_applied and then not fault.is_fixed
		do
			set_has_been_applied
		ensure
			has_been_applied
			fault.is_candidate_fix_accepted
		end

feature{NONE} -- Initialization implementation

	initialize_code_before_and_after_fix
			-- Initialize code before and after fix from `fix_text'.
		local
			l_lines: LIST [STRING]
			l_line_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
			l_line: STRING
			l_first_dot_index, l_second_dot_index: INTEGER
			l_class_name, l_feature_name: STRING
			l_is_pre: BOOLEAN
			l_feature: AFX_FEATURE_TO_MONITOR
			l_contracts: TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_old_contracts, l_new_contracts, l_to_add, l_to_remove: EPA_HASH_SET [EPA_EXPRESSION]
			l_expr_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_clause: EPA_EXPRESSION
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_clauses: LINKED_LIST [EPA_EXPRESSION]
			l_headline_for_feature: STRING
		do
			create l_contract_extractor
			create code_before_fix_internal.make (1024)
			create code_after_fix_internal.make (1024)

			l_lines := fix_text.split ('%N')
			from
				l_line_cursor := l_lines.new_cursor
				l_line_cursor.start
			until
				l_line_cursor.after
			loop
				l_line := l_line_cursor.item
				l_line.prune_all ('%R')

				if l_line.starts_with ("++:") then
					l_expr_text := l_line.substring (4, l_line.count)
					create l_expr.make_with_text (l_feature.context_class, l_feature.feature_, l_expr_text, l_feature.written_class)
					l_to_add.force (l_expr)

				elseif l_line.starts_with ("--:") then
					l_expr_text := l_line.substring (4, l_line.count)
					create l_expr.make_with_text (l_feature.context_class, l_feature.feature_, l_expr_text, l_feature.written_class)
					l_to_remove.force (l_expr)

				elseif l_line.starts_with ("<< ") then
					l_first_dot_index := l_line.index_of ('.', 1)
					l_second_dot_index := l_line.index_of ('.', l_first_dot_index + 1)
					l_is_pre := l_line.ends_with (".pre.")
					l_class_name := l_line.substring (4, l_first_dot_index - 1)
					l_feature_name := l_line.substring (l_first_dot_index + 1, l_second_dot_index - 1)

					create l_feature.make_from_feature_with_context_class (create {EPA_FEATURE_WITH_CONTEXT_CLASS}.make_from_names (l_feature_name, l_class_name))
					create l_to_add.make_equal (5)
					create l_to_remove.make_equal (5)

				elseif l_line.starts_with (">>") then
					if l_is_pre then
						l_clauses := l_contract_extractor.precondition_of_feature (l_feature.feature_, l_feature.context_class)
						l_headline_for_feature := l_feature.qualified_feature_name + " (Precondition)"
					else
						l_clauses := l_contract_extractor.postcondition_of_feature (l_feature.feature_, l_feature.context_class)
						l_headline_for_feature := l_feature.qualified_feature_name + " (Postcondition)"
					end
					code_before_fix_internal.append ("%T-- " + l_headline_for_feature + "%N")
					code_after_fix_internal.append ("%T-- " + l_headline_for_feature + "%N")

					from
						l_clauses.start
					until
						l_clauses.after
					loop
						l_clause := l_clauses.item_for_iteration
						if l_to_remove.has (l_clause) then
							code_before_fix_internal.append (l_clause.text + "%N")
						else
							code_before_fix_internal.append (l_clause.text + "%N")
							code_after_fix_internal.append (l_clause.text + "%N")
						end
						l_clauses.forth
					end
					from
						l_to_add.start
					until
						l_to_add.after
					loop
						l_clause := l_to_add.item_for_iteration

						code_after_fix_internal.append (l_clause.text + "%N")

						l_to_add.forth
					end
					code_before_fix_internal.append ("%N")
					code_after_fix_internal.append ("%N")
				end
				l_line_cursor.forth
			end
		end

feature{NONE} -- Implementation

	Nature_strengthen: INTEGER = 5
	Nature_weaken: INTEGER = 6
	Nature_weaken_and_strengthen: INTEGER = 7

feature{NONE} -- Cache

	nature_of_change_strings_internal: like nature_of_change_strings
	code_before_fix_internal: STRING
	code_after_fix_internal:  STRING


;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
