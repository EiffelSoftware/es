indexing
	description: "Summary description for {SAT_DECORATED_OUTPUT_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DECORATED_OUTPUT_STRATEGY

inherit
	AST_DECORATED_OUTPUT_STRATEGY
		redefine
			process_inline_agent_creation_as,
			process_if_as,
			process_elseif_as,
			process_inspect_as,
			process_case_as,
			process_loop_as,
			process_external_as,
			process_do_as,
			process_once_as
		end

	SAT_SHARED_EDITOR_TOKEN_CONSTANTS

	SAT_SHARED_NAMES

create
	make, make_for_inline_agent

feature -- Process

	process_external_as (l_as: EXTERNAL_AS) is
		do
			check
				not_expr_type_visiting: not expr_type_visiting
			end
			text_formatter_decorator.process_keyword_text (ti_external_keyword, Void)
			text_formatter_decorator.indent
			text_formatter_decorator.put_new_line
			l_as.language_name.process (Current)
			text_formatter_decorator.exdent
			text_formatter_decorator.put_new_line

				-- Check slot coverage.	
			local_slot_index := -1
			check_slot_entry

			if l_as.alias_name_literal /= Void then
				text_formatter_decorator.process_keyword_text (ti_alias_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				l_as.alias_name_literal.process (Current)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit
		end

	process_do_as (l_as: DO_AS) is
		do
			check
				not_expr_type_visiting: not expr_type_visiting
			end
			text_formatter_decorator.process_keyword_text (ti_do_keyword, Void)
			text_formatter_decorator.put_new_line

				-- Check slot coverage.	
			local_slot_index := -1
			check_slot_entry

			if l_as.compound /= Void then
				text_formatter_decorator.indent
				format_compound (l_as.compound)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit
		end

	process_once_as (l_as: ONCE_AS) is
		do
			check
				not_expr_type_visiting: not expr_type_visiting
			end
			text_formatter_decorator.process_keyword_text (ti_once_keyword, Void)
			text_formatter_decorator.put_new_line

				-- Check slot coverage.	
			local_slot_index := -1
			check_slot_entry

			if l_as.compound /= Void then
				text_formatter_decorator.indent
				format_compound (l_as.compound)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit
		end

	process_if_as (l_as: IF_AS) is
		do
			put_breakable
			text_formatter_decorator.process_keyword_text (ti_if_keyword, Void)
			text_formatter_decorator.put_space
			text_formatter_decorator.new_expression
			l_as.condition.process (Current)
			text_formatter_decorator.put_space
			text_formatter_decorator.set_without_tabs
			text_formatter_decorator.process_keyword_text (ti_then_keyword, Void)
			text_formatter_decorator.put_new_line

				-- Check slot coverage.
			check_slot_entry

			if l_as.compound /= Void then
				text_formatter_decorator.indent
				format_compound (l_as.compound)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit

			if l_as.elsif_list /= Void then
				text_formatter_decorator.set_separator (ti_empty)
				text_formatter_decorator.set_no_new_line_between_tokens
				l_as.elsif_list.process (Current)
				text_formatter_decorator.set_separator (Void)
			end

			if l_as.else_part /= Void then
				text_formatter_decorator.process_keyword_text (ti_else_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line

				check_slot_entry

				text_formatter_decorator.set_new_line_between_tokens
				format_compound (l_as.else_part)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			else
					-- We always display an "else" part even though it is not present in the original code.
				text_formatter_decorator.process_keyword_text (ti_else_keyword, Void)
				text_formatter_decorator.put_new_line

					-- Check slot coverage.
				check_slot_entry
			end

				-- Check slot coverage.
			check_slot_exit

			text_formatter_decorator.process_keyword_text (ti_end_keyword, Void)
		end

	process_elseif_as (l_as: ELSIF_AS) is
		do
				-- Check slot coverage.
			check_slot_entry

			check
				not_expr_type_visiting: not expr_type_visiting
			end
			put_breakable
			text_formatter_decorator.process_keyword_text (ti_elseif_keyword, Void)
			text_formatter_decorator.put_space
			text_formatter_decorator.new_expression
			l_as.expr.process (Current)
			text_formatter_decorator.put_space
			text_formatter_decorator.set_without_tabs
			text_formatter_decorator.process_keyword_text (ti_then_keyword, Void)
			text_formatter_decorator.put_new_line
			if l_as.compound /= Void then
				text_formatter_decorator.indent
				format_compound (l_as.compound)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit
		end

	process_inspect_as (l_as: INSPECT_AS) is
		do
			check
				not_expr_type_visiting: not expr_type_visiting
			end
			put_breakable
			text_formatter_decorator.process_keyword_text (ti_inspect_keyword, Void)
			text_formatter_decorator.put_space
			text_formatter_decorator.indent
			l_as.switch.process (Current)
			text_formatter_decorator.exdent
			text_formatter_decorator.put_new_line
			if l_as.case_list /= Void then
				text_formatter_decorator.set_separator (ti_empty)
				text_formatter_decorator.set_no_new_line_between_tokens
				l_as.case_list.process (Current)
			end

			if l_as.else_part /= Void then
				text_formatter_decorator.process_keyword_text (ti_else_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line

				check_slot_entry

				text_formatter_decorator.set_separator (Void)
				text_formatter_decorator.set_new_line_between_tokens
				if not l_as.else_part.is_empty then
					format_compound (l_as.else_part)
					text_formatter_decorator.put_new_line
				end
				text_formatter_decorator.exdent
			else
					-- We always display an "else" part even though it is not present in the original code.
				text_formatter_decorator.process_keyword_text (ti_else_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line

					-- Check slot coverage.
				check_slot_entry
			end
			text_formatter_decorator.process_keyword_text (ti_end_keyword, Void)

				-- Check slot coverage.
			check_slot_exit
		end

	process_case_as (l_as: CASE_AS) is
		do
				-- Check slot coverage.
			check_slot_entry

			check
				not_expr_type_visiting: not expr_type_visiting
			end
			text_formatter_decorator.process_keyword_text (ti_when_keyword, Void)
			text_formatter_decorator.put_space
			text_formatter_decorator.set_separator (ti_comma)
			text_formatter_decorator.set_space_between_tokens
			l_as.interval.process (Current)
			text_formatter_decorator.put_space
			text_formatter_decorator.set_without_tabs
			text_formatter_decorator.process_keyword_text (ti_then_keyword, Void)
			text_formatter_decorator.put_space
			text_formatter_decorator.put_new_line
			if l_as.compound /= Void then
				text_formatter_decorator.indent
				format_compound (l_as.compound)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end

				-- Check slot coverage.
			check_slot_exit
		end

	process_loop_as (l_as: LOOP_AS) is
		do
			check
				not_expr_type_visiting: not expr_type_visiting
			end
			text_formatter_decorator.process_keyword_text (ti_from_keyword, Void)
			text_formatter_decorator.set_separator (Void)
			text_formatter_decorator.set_new_line_between_tokens
			if l_as.from_part /= Void then
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				format_compound (l_as.from_part)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			else
				text_formatter_decorator.put_new_line
			end
			if l_as.invariant_part /= Void then
				text_formatter_decorator.process_keyword_text (ti_invariant_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				l_as.invariant_part.process (Current)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end
			if l_as.variant_part /= Void and then not current_class.lace_class.is_syntax_standard then
				text_formatter_decorator.process_keyword_text (ti_variant_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				l_as.variant_part.process (Current)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end
			text_formatter_decorator.process_keyword_text (ti_until_keyword, Void)
			text_formatter_decorator.indent
			text_formatter_decorator.put_new_line
			text_formatter_decorator.new_expression
			put_breakable
			l_as.stop.process (Current)
			text_formatter_decorator.exdent
			text_formatter_decorator.put_new_line

			text_formatter_decorator.process_keyword_text (ti_loop_keyword, Void)

				-- Check slot coverage.
			text_formatter_decorator.put_new_line
			check_slot_entry

			if l_as.compound /= Void then
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				format_compound (l_as.compound)
				text_formatter_decorator.exdent
			end
			text_formatter_decorator.put_new_line
			if l_as.variant_part /= Void and then current_class.lace_class.is_syntax_standard then
				text_formatter_decorator.process_keyword_text (ti_variant_keyword, Void)
				text_formatter_decorator.indent
				text_formatter_decorator.put_new_line
				l_as.variant_part.process (Current)
				text_formatter_decorator.put_new_line
				text_formatter_decorator.exdent
			end
			text_formatter_decorator.process_keyword_text (ti_end_keyword, Void)
			text_formatter_decorator.put_new_line

				-- Check slot coverage.
			check_slot_exit

				-- Check slot coverage.
			check_slot_entry
			check_slot_exit
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS) is
		local
			l_strategy: SAT_DECORATED_OUTPUT_STRATEGY
			l_old_feature_comments: EIFFEL_COMMENTS
			l_old_arguments: AST_EIFFEL
			l_old_target_feature: FEATURE_I
			l_old_source_feature: FEATURE_I
			l_old_e_feature: E_FEATURE
			l_old_breakpoint_index: INTEGER
			l_feat: FEATURE_I
			l_leaf_list: LEAF_AS_LIST
		do
			if not expr_type_visiting then
				if l_as.inl_rout_id > 0 then
					text_formatter_decorator.process_keyword_text (ti_agent_keyword, Void)

					create l_strategy.make_for_inline_agent (Current, l_as)

					l_old_feature_comments := text_formatter_decorator.feature_comments
					l_old_arguments := text_formatter_decorator.arguments
					l_old_target_feature := text_formatter_decorator.target_feature
					l_old_source_feature := text_formatter_decorator.source_feature
					l_old_e_feature := text_formatter_decorator.e_feature
					l_old_breakpoint_index := text_formatter_decorator.breakpoint_index

					l_feat := l_strategy.current_feature

					text_formatter_decorator.restore_attributes ( Void, l_as.body.arguments, l_feat,
																  l_strategy.source_feature, l_strategy, 0,
																  l_feat.api_feature (l_feat.written_in))

					l_as.body.process (l_strategy)

					text_formatter_decorator.restore_attributes ( l_old_feature_comments, l_old_arguments,
																  l_old_target_feature, l_old_source_feature, Current,
																  l_old_breakpoint_index, l_old_e_feature)

					if l_as.operands /= Void then
						reset_last_class_and_type
						text_formatter_decorator.process_symbol_text (ti_space)
						text_formatter_decorator.begin
						text_formatter_decorator.process_symbol_text (ti_l_parenthesis)
						text_formatter_decorator.set_separator (ti_comma)
						text_formatter_decorator.set_space_between_tokens
						l_as.operands.process (Current)
						text_formatter_decorator.process_symbol_text (ti_r_parenthesis)
						text_formatter_decorator.commit
					end
					last_type := expr_type (l_as)
				else
					has_error_internal := True
					l_leaf_list	:= match_list_server.item (current_class.class_id)
					if l_leaf_list /= Void and then l_as.is_text_available (l_leaf_list) then
						text_formatter_decorator.add (l_as.text (l_leaf_list))
					else
						text_formatter_decorator.add ("unable_to_show_inline_agent")
					end
				end
			else
				if not has_error_internal then
					last_type := agent_type (l_as)
				end
			end
		end

feature{NONE} -- Implicaiton

	visited_flag_stack: LINKED_STACK [INTEGER] is
			-- Stack of visited flags
		do
			if visited_flag_stack_internal = Void then
				create visited_flag_stack_internal.make
			end
			Result := visited_flag_stack_internal
		end

	visited_flag_stack_internal: like visited_flag_stack
			-- Implementation of `visited_flag_stack'

	local_slot_index: INTEGER
			-- Local slot_index

	slot_coverage_table: SAT_DCS_SLOT_TABLE is
			-- Table for instrumented log information:
			-- 1. The location of slots in source code
			-- 2. The coverage information for each slots.
		local
			l_map_file_name: STRING
			l_slot_file_name: STRING
		do
			if slot_coverage_table_internal = Void then
				l_map_file_name := path_name_in_sats_directory (map_file_name)
				l_slot_file_name := path_name_in_sats_directory (slot_file_name)
				create slot_coverage_table_internal.make (l_map_file_name, l_slot_file_name)
			end
			Result := slot_coverage_table_internal
		end

	slot_coverage_table_internal: like slot_coverage_table
			-- Implementation of `slot_coverage_table'

	path_name_in_sats_directory (a_file_name: STRING): STRING is
			-- Full path of file `a_file_name' in SATS directory
		require
			a_file_name_attached: a_file_name /= Void
			not_a_file_is_empty: not a_file_name.is_empty
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (workbench.project_location.testing_results_path)
			l_path.extend (sats_directory_name)
			l_path.set_file_name (a_file_name)
			Result := l_path
		ensure
			result_attached: Result /= Void
		end

	is_file_exist (a_path: STRING): BOOLEAN is
			-- Does `a_path' exist in file system?
		require
			a_path_attached: a_path /= Void
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make (a_path)
			Result := l_file.exists
		end

	process_visit_status_entry is
			-- Process when a slot is entered.
		local
			l_class_name: STRING
			l_feature_name: STRING
			l_slot_table: like slot_coverage_table
			l_global_index: INTEGER
			l_visited_times: INTEGER
		do
			local_slot_index := local_slot_index + 1
				-- Check the original feature, to make sure the inherited feature and
				-- feature renaming is resolved.
			l_class_name := source_class.name.as_upper
			l_feature_name := source_feature.feature_name.as_lower

				-- Check if current slot is visited.
			l_slot_table := slot_coverage_table
			if l_slot_table.has_feature (l_class_name, l_feature_name) then
				l_global_index := l_slot_table.global_slot_index (l_class_name, l_feature_name, local_slot_index)
				l_visited_times := l_slot_table.visited_times (l_global_index)
				visited_flag_stack.extend (l_visited_times)
			else
				l_global_index := -1
				visited_flag_stack.extend (0)
			end
			set_visited (l_visited_times > 0)

				-- Insert some comments indicating the global slot index.
			if l_global_index >= 0 then
				text_formatter_decorator.process_comment_text  ("-- Slot No." + l_global_index.out, Void)
				text_formatter_decorator.put_new_line
			end
		end

	process_visit_status_exit is
			-- Process when a slot is exited.
		do
			check not visited_flag_stack.is_empty end
			visited_flag_stack.remove
			set_visited (not (visited_flag_stack.is_empty or else visited_flag_stack.item = 0))
		end

	check_slot_entry is
			-- Check slot information on feature entry.
		do
			text_formatter_decorator.indent
			process_visit_status_entry
			text_formatter_decorator.exdent
		end

	check_slot_exit is
			-- Check slot information on feature exit.
		do
			process_visit_status_exit
		end

	increase_local_slot_index is
			-- Increase `local_slot_index' by 1.
		do
			local_slot_index := local_slot_index + 1
		ensure
			local_slot_index_increased: local_slot_index = old local_slot_index + 1
		end

indexing
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
