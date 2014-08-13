note
	description: "Summary description for {AT_HINTER_PROCESSING_ORACLE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_PROCESSING_ORACLE

inherit {NONE}
	AT_COMMON

create
	make_with_options

--feature -- Oracle

--	must_skip_feature: BOOLEAN
--			-- Should we skip the feature we are processing in the current status?
--		do
--			Result := (not local_feature_visibility).imposed_on_bool (False)
--		end

--	must_show_routine_arguments: BOOLEAN
--			-- Should we hide the arguments of the routine we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_routine_arguments_visibility
--			l_local_content_policy := local_feature_content_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_arguments, options.hint_level).visibility
--			Result := l_local_policy.imposed_on (l_local_content_policy).imposed_on_bool (l_global_policy)
--		end

--	must_show_precondition: BOOLEAN
--			-- Should we hide the precondition we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_precondition_visibility
--			l_local_content_policy := local_feature_content_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_precondition, options.hint_level).visibility
--			Result := l_local_policy.imposed_on (l_local_content_policy).imposed_on_bool (l_global_policy)
--		end

--	must_show_locals: BOOLEAN
--			-- Should we hide the locals of the routine we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_locals_visibility
--			l_local_content_policy := local_feature_content_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_locals, options.hint_level).visibility
--			Result := l_local_policy.imposed_on (l_local_content_policy).imposed_on_bool (l_global_policy)
--		end

--	must_show_routine_body: BOOLEAN
--			-- Should we hide the body of the routine we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_routine_body_visibility
--			l_local_content_policy := local_feature_content_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_routine_body, options.hint_level).visibility
--			Result := l_local_policy.imposed_on (l_local_content_policy).imposed_on_bool (l_global_policy)
--		end

--	must_show_postcondition: BOOLEAN
--			-- Should we hide the postcondition we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_postcondition_visibility
--			l_local_content_policy := local_feature_content_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_postcondition, options.hint_level).visibility
--			Result := l_local_policy.imposed_on (l_local_content_policy).imposed_on_bool (l_global_policy)
--		end

--	must_show_class_invariant: BOOLEAN
--			-- Should we hide the class invariant we are processing in the current status?
--		local
--			l_local_policy: AT_TRI_STATE_BOOLEAN
--			l_local_content_policy: AT_TRI_STATE_BOOLEAN
--			l_global_policy: BOOLEAN
--		do
--			l_local_policy := local_class_invariant_visibility
--			l_global_policy := options.hint_table.entry (enum_block_type.bt_class_invariant, options.hint_level).visibility
--			Result := l_local_policy.imposed_on_bool (l_global_policy)
--		end

--	output_enabled: BOOLEAN
--			-- Should the current section be output or not?

feature -- Status signaling

	begin_process_class
			-- Signal that a class is about to be processed.
		do
--			local_feature_content_visibility := tri_undefined
--			local_feature_visibility := tri_undefined
--			local_routine_arguments_visibility := tri_undefined
--			local_precondition_visibility := tri_undefined
--			local_locals_visibility := tri_undefined
--			local_routine_body_visibility := tri_undefined
--			local_postcondition_visibility := tri_undefined
--			local_class_invariant_visibility := tri_undefined
		end

	end_process_class
			-- Signal that a class has been processed.
		do
			options.restore_from (original_options)
		end

--	begin_process_feature
--			-- Signal that a feature is about to be processed.
--		do
--			if must_skip_feature then
--				processing_skipped_feature := True
--			end
--		end

--	end_process_feature
--			-- Signal that a feature has been processed.
--		do
--			local_feature_content_visibility := tri_undefined
--			local_feature_visibility := tri_undefined
--			processing_skipped_feature := False
--		end

--	begin_process_routine_arguments
--			-- Signal that routine arguments are about to be processed.
--		do
--		end

--	end_process_routine_arguments
--			-- Signal that routine arguments have been processed.
--		do
--			local_routine_arguments_visibility := tri_undefined
--		end

--	begin_process_precondition
--			-- Signal that a precondition is about to be processed.
--		do
--		end

--	end_process_precondition
--			-- Signal that a precondition has been processed.
--		do
--			local_precondition_visibility := tri_undefined
--		end

--	begin_process_locals
--			-- Signal that a block of locals is about to be processed.
--		do
--		end

--	end_process_locals
--			-- Signal that a block of locals has been processed.
--		do
--			local_locals_visibility := tri_undefined
--		end

--	begin_process_routine_body
--			-- Signal that a routine body is about to be processed.
--		do
--		end

--	end_process_routine_body
--			-- Signal that a routine body has been processed.
--		do
--			local_routine_body_visibility := tri_undefined
--		end

--	begin_process_postcondition
--			-- Signal that a postcondition is about to be processed.
--		do
--		end

--	end_process_postcondition
--			-- Signal that a postcondition has been processed.
--		do
--			local_postcondition_visibility := tri_undefined
--		end

--	begin_process_class_invariant
--			-- Signal that a class invariant is about to be processed.
--		do
--		end

--	end_process_class_invariant
--			-- Signal that a class invariant has been processed.
--		do
--			local_class_invariant_visibility := tri_undefined
--		end

feature -- Meta-command processing interface

	is_meta_command (a_line: STRING): BOOLEAN
			-- Does `a_line' contain a meta-command?
		local
			l_line: STRING
		do
			l_line := a_line.twin
			l_line.left_adjust
			if l_line.starts_with ("--") then
				l_line.remove_head (2)
				l_line.left_adjust
				Result := l_line.starts_with (at_strings.meta_command_prefix)
			end
		end

	process_meta_command (a_line: STRING)
			-- Process the meta-command contained in `a_line'. Case insensitive.
		require
			is_meta_command: is_meta_command (a_line)
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_line, l_argument, l_level_string, l_command_word: STRING
			l_index, l_space_index, l_tab_index, l_level: INTEGER
			l_error, l_recognized: BOOLEAN
			l_tristate: AT_TRI_STATE_BOOLEAN
		do
			last_hint := Void

			l_line := a_line.twin
			l_level := 0

			l_line.adjust

			check l_line.starts_with ("--") end
			l_line.remove_head (2)
			l_line.left_adjust

			check l_line.starts_with (at_strings.meta_command_prefix) end
			l_line.remove_head (at_strings.meta_command_prefix.count)
			l_line.left_adjust

			if l_line [1] = '[' then
				l_line.remove_head (1)
				l_index := l_line.index_of (']', 1)
				if l_index >= 2 then
					l_level_string := l_line.substring (1, l_index - 1)
					if l_level_string.is_natural_32 then
						l_level := l_level_string.to_integer_32
						l_line.remove_head (l_index)
					else
						l_error := True
					end
				else
					l_error := True
				end
			end

			l_line.left_adjust
			l_space_index := l_line.index_of (' ', 1)
			if l_space_index = 0 then
				l_space_index := l_line.count + 1
			end
			l_tab_index := l_line.index_of ('%T', 1)
			if l_tab_index = 0 then
				l_tab_index := l_line.count + 1
			end

			l_index := l_tab_index.min (l_space_index)

			l_command_word := l_line.head (l_index - 1).as_upper
			l_line.remove_head (l_index - 1)
			l_line.left_adjust

			if not l_error and options.hint_level >= l_level then
				if processing_skipped_feature then
						-- Do not execute the command. Give a warning instead.
					print_message (capitalized (at_strings.meta_command) + ": " + a_line + "%N" + at_strings.meta_command_in_skipped_routine)

						-- Pretend it has been recognized in order to suppress the "unrecognized command" warning.
					l_recognized := True
				elseif l_command_word.same_string (at_strings.hint_command) then
					last_hint := a_line.twin
					l_recognized := True
				elseif l_command_word.same_string (at_strings.shownext_command) then
					if enum_block_type.is_valid_value_name (l_line.as_lower) then
						show_block (enum_block_type.value (l_line.as_lower))
						l_recognized := True
					end
				elseif l_command_word.same_string (at_strings.hidenext_command) then
					if enum_block_type.is_valid_value_name (l_line.as_lower) then
						hide_block (enum_block_type.value (l_line.as_lower))
						l_recognized := True
					end
				elseif l_command_word.same_string (at_strings.show_content_command) then
					if is_valid_content_block_type (l_line.as_lower) then
						show_block_content (l_line.as_lower)
						l_recognized := True
					end
				elseif l_command_word.same_string (at_strings.hide_content_command) then
					if is_valid_content_block_type (l_line.as_lower) then
						hide_block_content (l_line.as_lower)
						l_recognized := True
					end
				elseif l_command_word.same_string (at_strings.placeholder_command) then
					l_tristate := on_off_to_tristate (l_line)
					if l_tristate.defined then
						options.insert_code_placeholder := l_tristate.value
						l_recognized := True
					end
				elseif l_command_word.same_string (at_strings.hint_mode_command) then
					options.hint_table := default_annotated_hint_table
					l_recognized := True
				elseif l_command_word.same_string (at_strings.unannotated_mode_command) then
					options.hint_table := default_unannotated_hint_table
					l_recognized := True
				elseif l_command_word.same_string (at_strings.custom_mode_command) then
					l_recognized := True
					if attached custom_hint_table as l_hint_table then
						options.hint_table := l_hint_table
					else
						print_message (capitalized (at_strings.meta_command) + ": " + a_line + "%N" + at_strings.no_custom_hint_table_loaded)
					end
				end
			end
			if options.hint_level >= l_level and not l_recognized then
				print_message (at_strings.unrecognized_meta_command + a_line)
			end
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

	last_hint: detachable STRING
		-- The last hint found as a meta-command.

feature {NONE} -- Meta-command processing

	show_block_content (a_block_type: STRING)
		require
			valid_block_type: is_valid_content_block_type (a_block_type)
		do
			force_block_content_visibility (a_block_type, True)
		end

	hide_block_content (a_block_type: STRING)
		require
			valid_block_type: is_valid_content_block_type (a_block_type)
		do
			force_block_content_visibility (a_block_type, False)
		end

	show_block (a_block_type: AT_BLOCK_TYPE)
		do
			force_block_visibility (a_block_type, True)
		end

	hide_block (a_block_type: AT_BLOCK_TYPE)
		do
			force_block_visibility (a_block_type, False)
		end


--feature {NONE} -- Visibility

--	blocks_visibility: HASH_TABLE [AT_HINTER_BLOCK_VISIBILITY, AT_BLOCK_TYPE]

--	global_feature_visibility: BOOLEAN

--	global_feature_content_visibility: AT_TRI_STATE_BOOLEAN

--	global_routine_arguments_visibility: AT_TRI_STATE_BOOLEAN
--	global_precondition_visibility: AT_TRI_STATE_BOOLEAN
--	global_locals_visibility: AT_TRI_STATE_BOOLEAN
--	global_routine_body_visibility: AT_TRI_STATE_BOOLEAN
--	global_postcondition_visibility: AT_TRI_STATE_BOOLEAN
--	global_class_invariant_visibility: AT_TRI_STATE_BOOLEAN

--	local_feature_visibility: AT_TRI_STATE_BOOLEAN


--	processing_skipped_feature: BOOLEAN
--		-- Set to true while processing a skipped features. All meta-commands will be ignored.


--	local_feature_content_visibility: AT_TRI_STATE_BOOLEAN

--	local_routine_arguments_visibility: AT_TRI_STATE_BOOLEAN
--	local_precondition_visibility: AT_TRI_STATE_BOOLEAN
--	local_locals_visibility: AT_TRI_STATE_BOOLEAN
--	local_routine_body_visibility: AT_TRI_STATE_BOOLEAN
--	local_postcondition_visibility: AT_TRI_STATE_BOOLEAN
--	local_class_invariant_visibility: AT_TRI_STATE_BOOLEAN

--	force_block_content_visibility (a_block_type: STRING; a_visibility: BOOLEAN)
--		require
--			valid_block_type: is_valid_content_block_type (a_block_type)
--		local
--			l_block_type: STRING
--		do
--			l_block_type := a_block_type.as_lower
--			if a_block_type.same_string (bt_feature) then
--				local_feature_content_visibility := to_tri_state (a_visibility)
--			else
--				check block_type_recognized: False end
--			end
--		end

--	force_block_visibility (a_block_type: AT_BLOCK_TYPE; a_visibility: BOOLEAN)
--		local
--			l_block_type: STRING
--		do
--			if a_block_type = enum_block_type.bt_feature then
--				local_feature_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_arguments then
--				local_routine_arguments_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_precondition then
--				local_precondition_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_locals then
--				local_locals_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_routine_body then
--				local_routine_body_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_postcondition then
--				local_postcondition_visibility := to_tri_state (a_visibility)
--			elseif a_block_type = enum_block_type.bt_class_invariant then
--				local_class_invariant_visibility := to_tri_state (a_visibility)
--			else
--				check block_type_recognized: False end
--			end
--		end

feature -- Visibility: cool new things

	blocks_visibility: HASH_TABLE [AT_HINTER_BLOCK_VISIBILITY, AT_BLOCK_TYPE]

	block_stack: STACK [AT_HINTER_BLOCK_VISIBILITY]

	hiding_stack: STACK [BOOLEAN]

	content_visibility_stack: STACK [TUPLE [status: AT_TRI_STATE_BOOLEAN; is_overridden: BOOLEAN]]

feature -- Status signaling: cool new things

	begin_process_block (a_block_type: AT_BLOCK_TYPE)
		local
			l_hiding_status: BOOLEAN
			l_content_visibility_status: AT_TRI_STATE_BOOLEAN
			l_block_visibility: AT_HINTER_BLOCK_VISIBILITY
		do
				-- We clone the block as some flags can later be changed in the block
				-- visibility table, but it should not affect blocks already being processed.
			l_block_visibility := blocks_visibility [a_block_type].twin

			block_stack.put (l_block_visibility)

			if hiding_stack.is_empty then
					-- Default values
				l_hiding_status := False
				l_content_visibility_status := tri_undefined
			else
					-- Keep the current values.
				l_hiding_status := hiding_stack.item
				l_content_visibility_status := content_visibility_stack.item
			end

			if attached {AT_HINTER_COMPLEX_BLOCK_VISIBILITY} l_block_visibility as l_complex_block_visibility then
				-- TODO: Chi va imposto su chi? Problema cruciale.
				-- l_content_visibility_status := l_content_visibility_status.subjected_to (l_complex_block_visibility.)
			end

			hiding_stack.put (l_hiding_status)
			content_visibility_stack.put (l_content_visibility_status)
		ensure
			block_on_top_of_stack: block_stack.item.block_type = a_block_type
		end

	output_enabled_revenge: BOOLEAN
		local
			l_current_value: AT_TRI_STATE_BOOLEAN
			l_top_block: AT_HINTER_BLOCK_VISIBILITY
		do
			if block_stack.is_empty then
				Result := True
			else
				l_top_block := block_stack.item

					-- Start with the default visibility (from the hint table).
				l_current_value := to_tri_state (l_top_block.default_visibility)

					-- Apply global policy (i.e. the one defined by "#SHOW_ALL something").
				l_current_value := l_top_block.global_visibility_override.imposed_on (l_current_value)

					-- Apply the current content visibility policy, e.g. if we are inside a routine with
					-- the annotation "#HIDE_CONTENT_NEXT routine" then hide the block.
					-- The current content visibility policy does not apply to complex blocks (containers).
				if not enum_block_type.is_complex_block_type (l_top_block.block_type) then
					l_current_value := content_visibility_stack.item.imposed_on (l_current_value)
				end

				l_current_value := l_top_block.local_visibility_override.imposed_on (l_current_value)

					-- If we are in a totally hidden section, then, no matter what, output is disabled.
				l_current_value := l_current_value and to_tri_state (hiding_stack.item)

				check l_current_value.defined end
				Result := l_current_value.value
			end
		end

	end_process_block (a_block_type: AT_BLOCK_TYPE)
		require
			block_on_top_of_stack: not block_stack.is_empty and then block_stack.item.block_type = a_block_type
		do
			block_stack.remove
			hiding_stack.remove
			content_visibility_stack.remove
		end

feature {NONE} -- Implementation

	options: AT_OPTIONS

	original_options: AT_OPTIONS

	make_with_options (a_options: AT_OPTIONS)
		do
			options := a_options
			original_options := a_options.twin
			initialize_block_visibility_table
			-- output_enabled := True
		end

	initialize_block_visibility_table -- TODO: get rid of this?
		local
			l_block_type: AT_BLOCK_TYPE
			l_block: AT_HINTER_BLOCK_VISIBILITY
			l_complex_block: AT_HINTER_COMPLEX_BLOCK_VISIBILITY
		do
			create blocks_visibility.make (32)

			across enum_block_type.values as ic loop
				l_block_type := ic.item
				if enum_block_type.is_complex_block_type (l_block_type) then
					create {AT_HINTER_COMPLEX_BLOCK_VISIBILITY} l_block.make_with_two_agents (l_block_type, agent block_default_visibility, agent block_content_default_visibility)
				else
					create l_block.make_with_visibility_agent (l_block_type, agent block_default_visibility)
				end
				blocks_visibility.put (l_block, ic.item)
			end
		end

	block_default_visibility (a_block_type: AT_BLOCK_TYPE): BOOLEAN
		do
			Result := options.hint_table.entry (a_block_type, options.hint_level).visibility
		end

	block_content_default_visibility (a_block_type: AT_BLOCK_TYPE): AT_TRI_STATE_BOOLEAN
		require
			implemented: False
		do
			-- Result := options.hint_table.entry (a_block_type, options.hint_level).visibility
		end

	message_output_action: detachable PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]
			-- The action to be called for outputting messages.

	print_message (a_string: READABLE_STRING_GENERAL)
			-- Prints a line to output, if a message output action has been specified.
		do
			if attached message_output_action as l_message_output_action then
				l_message_output_action.call (a_string + "%N")
			end
		end

invariant

	all_visibility_keys: across enum_block_type.values as ic all blocks_visibility.has_key (ic.item)  end
	only_visibility_keys: across blocks_visibility.current_keys as ic all enum_block_type.is_valid_numerical_value (ic.item.numerical_value) end
	stacks_same_size: block_stack.count = hiding_stack.count and hiding_stack.count = content_visibility_stack.count

end
