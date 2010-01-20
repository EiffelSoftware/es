note
	description: "Prints an extracted method given the original method	"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_EXTRACTED_METHOD_PRINTER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_instr_call_as,
			process_creation_as,
			process_nested_as,
			process_access_feat_as,
			process_expr_call_as,
			process_list_with_separator
		end
	ETR_SHARED
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
create
	make

feature -- Operation

	print_feature_body(a_body: EIFFEL_LIST[INSTRUCTION_AS])
			-- print `a_body' to output
		do
			process_child_list (a_body, void, void, 0)
		end

feature {NONE} -- Creation

	make(a_output: like output; a_result_list: like results; a_changed_args_list: like changed_arguments; a_start_path: like start_path; a_end_path: like end_path)
			-- make with `a_output', `a_result_list', `a_start_path' and `a_end_path'
		require
			none_void: a_output /= void and a_result_list /= void and a_start_path /= void and a_end_path /= void and a_changed_args_list /= void
			single_result: a_result_list.count<=1
			same_parent: a_start_path.parent_path.is_equal (a_end_path.parent_path)
		do
			make_with_output (a_output)

			changed_arguments := a_changed_args_list
			changed_arguments.compare_objects
			results := a_result_list
			results.compare_objects
			start_path := a_start_path
			end_path := a_end_path

			instr_list_parent := start_path.parent_path
		end

feature {NONE} -- Implementation

	process_list_with_separator (l_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process `l_as' and use `separator' for string output
		local
			l_cursor: INTEGER
			l_first_instr: INTEGER
			l_last_instr: INTEGER
		do
			if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_as as l_instr_list then
				-- for instruction lists
				-- print only those in range!

				-- check if parents match
				-- i.e. parent instruction list is a prefix of current path
				-- and not entirely contained
				if l_instr_list.path.is_equal(instr_list_parent) then
					from
						l_first_instr := start_path.as_array[start_path.as_array.upper]
						l_last_instr := end_path.as_array[end_path.as_array.upper]

						l_cursor := l_as.index
						l_as.go_i_th (l_first_instr)
					until
						l_as.after or l_as.index>l_last_instr
					loop
						process_child (l_as.item, l_as, l_as.index)
						if attached separator and l_as.index /= l_as.count then
							output.append_string(separator)
						end
						l_as.forth
					end
					l_as.go_i_th (l_cursor)
				else
					Precursor(l_as, separator, a_parent, a_branch)
				end
			else
				Precursor(l_as, separator, a_parent, a_branch)
			end
		end

	last_was_unqualified: BOOLEAN
			-- presently in an unqualified call

	changed_arguments: LIST[STRING]
			-- arguments that have been "converted" to locals

	results: LIST[STRING]
			-- which variables are a result

	start_path, end_path, instr_list_parent: AST_PATH
			-- range of methods to extract

feature {AST_EIFFEL} -- Roundtrip

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			last_was_unqualified := true
			process_child (l_as.call, l_as, 1)
			output.append_string(ti_new_line)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified := true
			process_child(l_as.call, l_as, 1)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			last_was_unqualified := true
			Precursor {ETR_AST_STRUCTURE_PRINTER}(l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			process_child (l_as.target, l_as, 1)
			output.append_string (ti_dot)
			last_was_unqualified := false
			process_child (l_as.message, l_as, 2)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			-- if were in an unqualified call
			-- the id might be the Result
			if last_was_unqualified and (not results.is_empty and then l_as.access_name.is_equal (results.first)) then
				output.append_string (ti_result)
			elseif changed_arguments.has (l_as.access_name) then
				output.append_string ("l_"+l_as.access_name)
			else
				output.append_string (l_as.access_name)
			end

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_space+ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
