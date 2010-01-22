note
	description: "Method extraction: Prints the old method minus the extracted part."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_OLD_METHOD_PRINTER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_type_dec_as,
			process_identifier_list,
			process_list_with_separator,
			process_routine_as
		end
create
	make

feature -- Operation

	print_feature(a_feature: FEATURE_AS)
			-- print `a_body' to output
		do
			is_locals_first_pass := false
			a_feature.process(Current)
		end

feature {NONE} -- Creation

	make(a_output: like output; a_obsolete_list: like obsolete_locals; a_start_path: like start_path; a_end_path: like end_path; a_repl_text: like replacement_text)
			-- make with `a_output', `a_obsolete_list', `a_start_path' and `a_end_path'
		require
			none_void: a_output /= void and a_obsolete_list /= void and a_start_path /= void and a_end_path /= void and a_repl_text /= void
			same_parent: a_start_path.parent_path.is_equal (a_end_path.parent_path)
		do
			make_with_output (a_output)

			obsolete_locals := a_obsolete_list
			obsolete_locals.compare_objects
			start_path := a_start_path
			end_path := a_end_path
			replacement_text := a_repl_text

			instr_list_parent := start_path.parent_path
		end

feature {NONE} -- Implementation

	replacement_text: STRING

	is_locals_first_pass: BOOLEAN

	process_list_with_separator (l_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process `l_as' and use `separator' for string output
		local
			l_cursor: INTEGER
			l_first_instr: INTEGER
			l_last_instr: INTEGER
		do
			if attached {EIFFEL_LIST[INSTRUCTION_AS]}l_as as l_instr_list then
				-- for instruction lists
				-- don't print those in range!

				-- check if parents match
				-- i.e. parent instruction list is a prefix of current path
				-- and not entirely contained
				if l_instr_list.path.is_equal(instr_list_parent) then
					from
						l_first_instr := start_path.as_array[start_path.as_array.upper]
						l_last_instr := end_path.as_array[end_path.as_array.upper]

						l_cursor := l_as.index
						l_as.start
					until
						l_as.after
					loop
						if l_as.index = l_first_instr then
							l_as.go_i_th (l_last_instr)
							output.append_string (replacement_text)
						else
							process_child (l_as.item, l_as, l_as.index)
							if attached separator and l_as.index /= l_as.count then
								output.append_string(separator)
							end
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

	obsolete_locals: LIST[STRING]
			-- locals that are no longer used

	start_path, end_path, instr_list_parent: AST_PATH
			-- range of methods to extract

	is_id_list_non_empty: BOOLEAN
	has_locals: BOOLEAN

	process_identifier_list (l_as: IDENTIFIER_LIST)
			-- process `l_as'
		local
			l_cursor: INTEGER
			l_cur_name: STRING
			l_printed: INTEGER
		do
			is_id_list_non_empty := false
			-- process the id's list
			-- which is not an ast but an array of indexes into the names heap
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				l_cur_name := names_heap.item (l_as.item)
				if not obsolete_locals.has(l_cur_name) then
					if not is_locals_first_pass then
						if l_printed>0 then
							output.append_string(ti_comma+ti_space)
						end
						output.append_string(l_cur_name)
					end

					is_id_list_non_empty := true
					l_printed := l_printed + 1
					has_locals := true
				end

				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			if processing_needed (l_as.obsolete_message, l_as, 1) then
				output.append_string (ti_obsolete_keyword+ti_New_line)
				process_block (l_as.obsolete_message, l_as, 1)
				output.append_string (ti_New_line)
			end

			process_child (l_as.precondition, l_as, 2)

			if processing_needed (l_as.locals, l_as, 3) then
				is_locals_first_pass := true
				has_locals := false
				l_as.locals.process (Current)

				is_locals_first_pass := false
				if has_locals then
					output.append_string (ti_local_keyword+ti_New_line)
					output.enter_block
					process_child_list (l_as.locals, ti_New_line, l_as, 3)
					output.append_string (ti_New_line)
					output.exit_block
				end
			end

			process_child(l_as.routine_body, l_as, 4)

			process_child (l_as.postcondition, l_as, 5)

			if processing_needed (l_as.rescue_clause, l_as, 6) then
				output.append_string(ti_rescue_keyword+ti_New_line)
				process_child_block (l_as.rescue_clause, l_as, 6)
			end

			output.append_string(ti_End_keyword+ti_New_line)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_identifier_list (l_as.id_list)
			if is_id_list_non_empty and not is_locals_first_pass then
				output.append_string(ti_colon+ti_space)
				process_child(l_as.type, l_as, 1)
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
