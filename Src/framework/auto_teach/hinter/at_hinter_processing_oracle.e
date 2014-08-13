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
			l_line, l_level_string, l_command_word, l_block_type_string: STRING
			l_min_max: TUPLE [min: INTEGER; max: INTEGER]
			l_index, l_space_index, l_tab_index, l_min_level, l_max_level: INTEGER
			l_error, l_recognized: BOOLEAN
			l_tristate: AT_TRI_STATE_BOOLEAN
			l_block_type: AT_BLOCK_TYPE
		do
			last_hint := Void

			l_line := a_line.twin
			l_min_level := 0
			l_max_level := {INTEGER}.max_value

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

					l_min_max := parse_integer_range_string (l_level_string, l_max_level)
					if attached l_min_max then
						l_min_level := l_min_max.min
						l_max_level := l_min_max.max
					else
						l_error := True
					end

					l_line.remove_head (l_index)
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

			if not l_error and options.hint_level >= l_min_level and options.hint_level <= l_max_level then
				if at_strings.commands_with_block.has (l_command_word) then
					l_block_type_string := l_line.as_lower
					if not enum_block_type.is_valid_value_name (l_block_type_string) then
						l_error := true
					else
						l_block_type := enum_block_type.value (l_block_type_string)
						l_recognized := True -- Not quite yet actually...
						if l_command_word.same_string (at_strings.show_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_true)
						elseif l_command_word.same_string (at_strings.hide_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_false)
						elseif l_command_word.same_string (at_strings.reset_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_undefined)
						elseif l_command_word.same_string (at_strings.show_all_content_command) then
							set_block_content_global_visibility_override (l_block_type, Tri_true)
						elseif l_command_word.same_string (at_strings.hide_all_content_command) then
							set_block_content_global_visibility_override (l_block_type, Tri_false)
						elseif l_command_word.same_string (at_strings.reset_all_content_command) then
							set_block_content_global_visibility_override (l_block_type, Tri_undefined)
						elseif l_command_word.same_string (at_strings.shownext_command) then
							set_block_local_visibility_override (l_block_type, Tri_true)
						elseif l_command_word.same_string (at_strings.hidenext_command) then
							set_block_local_visibility_override (l_block_type, Tri_false)
						elseif l_command_word.same_string (at_strings.show_content_command) then
							set_block_content_local_visibility_override (l_block_type, Tri_true)
						elseif l_command_word.same_string (at_strings.hide_content_command) then
							set_block_content_local_visibility_override (l_block_type, Tri_false)
						else
								-- Ok, that was a joke, let's set it back to False.
							l_recognized := False
						end
					end
				elseif l_command_word.same_string (at_strings.hint_command) then
						-- TODO: This must also be changed a bit.
					last_hint := a_line.twin
					l_recognized := True
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
			if options.hint_level >= l_min_level and options.hint_level <= l_max_level and not l_recognized then
				print_message (at_strings.unrecognized_meta_command + a_line)
			end
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

		-- TODO: rename to last_command_output
	last_hint: detachable STRING
		-- The output of the last meta-command, to be printed to the output.

feature {NONE} -- Meta-command processing

	set_block_global_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
		do
			blocks_visibility [a_block_type].global_visibility_override := a_value
		end

	set_block_local_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
		do
			blocks_visibility [a_block_type].local_visibility_override := a_value
		end

	set_block_content_global_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY
		do
			l_block := blocks_visibility [a_block_type]
			check attached {AT_COMPLEX_BLOCK_VISIBILITY} l_block end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY} l_block as l_complex_block then
				l_complex_block.global_content_visibility_override := a_value
			end
		end

	set_block_content_local_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY
		do
			l_block := blocks_visibility [a_block_type]
			check attached {AT_COMPLEX_BLOCK_VISIBILITY} l_block end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY} l_block as l_complex_block then
				l_complex_block.local_content_visibility_override := a_value
			end
		end


--	show_block_content (a_block_type: AT_BLOCK_TYPE)
--		do
--			force_block_content_visibility (a_block_type, True)
--		end

--	hide_block_content (a_block_type: AT_BLOCK_TYPE)
--		do
--			force_block_content_visibility (a_block_type, False)
--		end

--	show_block (a_block_type: AT_BLOCK_TYPE)
--		do
--			force_block_visibility (a_block_type, True)
--		end

--	hide_block (a_block_type: AT_BLOCK_TYPE)
--		do
--			force_block_visibility (a_block_type, False)
--		end


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

feature -- Visibility

	block_stack: STACK [AT_BLOCK_VISIBILITY]

feature {NONE}

	blocks_visibility: HASH_TABLE [AT_BLOCK_VISIBILITY, AT_BLOCK_TYPE]

	hiding_stack: STACK [BOOLEAN]

	in_hidden_block: BOOLEAN
		do
			Result := (not hiding_stack.is_empty and then hiding_stack.item = True)
		end

	global_content_visibility_stack: STACK [AT_TRI_STATE_BOOLEAN]
	local_content_visibility_stack: STACK [AT_TRI_STATE_BOOLEAN]



feature -- Status signaling: cool new things

	current_content_visibility: AT_TRI_STATE_BOOLEAN
			-- What is the current status of content visibility?
		do
			if global_content_visibility_stack.is_empty then
				Result := Tri_undefined
			else
				Result := global_content_visibility_stack.item.subjected_to (local_content_visibility_stack.item)
			end
		end

	begin_process_block (a_block_type: AT_BLOCK_TYPE)
		local
			l_hiding_status: BOOLEAN
			l_local_content_visibility_status, l_global_content_visibility_status: AT_TRI_STATE_BOOLEAN
			l_block_visibility: AT_BLOCK_VISIBILITY
		do
				-- We clone the block and then reset the local override flags. These are single-use.
			l_block_visibility := blocks_visibility [a_block_type].twin
			blocks_visibility [a_block_type].reset_local_overrides

			if hiding_stack.is_empty then
					-- According to the invariant, all stacks are empty.

					-- Default values
				l_hiding_status := False
				l_global_content_visibility_status := Tri_undefined
				l_local_content_visibility_status := Tri_undefined
			else
					-- Keep the current values.
				l_hiding_status := hiding_stack.item
				l_global_content_visibility_status := global_content_visibility_stack.item
				l_local_content_visibility_status := local_content_visibility_stack.item
			end

			if attached {AT_COMPLEX_BLOCK_VISIBILITY} l_block_visibility as l_complex_block_visibility then
					-- For complex blocks, compute the new valid content visibility policy (to be pushed into the stack).

					-- New global policy: default (from the hint table) content visibility for this block type (if defined),
					-- overridden by the currently valid global visibility policy (coming from "#SHOW_ALL_CONTENT" applied to some parent block type),
					-- overridden by the current global visibility policy for this block type (coming from "#SHOW_ALL_CONTENT" applied to this block type).
					-- Note that the final result could still be undefined.
				l_global_content_visibility_status := l_complex_block_visibility.default_content_visibility.subjected_to (l_global_content_visibility_status).subjected_to (l_complex_block_visibility.global_content_visibility_override)


					-- New local policy: the current local visibility policy (coming from a "#SHOW_NEXT_CONTENT" command applied to a parent block),
					-- overridden by the local visibility flag of this block (coming from a "#SHOW_NEXT_CONTENT" command applied to a this block).
				l_local_content_visibility_status := l_local_content_visibility_status.subjected_to (l_complex_block_visibility.local_content_visibility_override)
			end

			block_stack.put (l_block_visibility)

			global_content_visibility_stack.put (l_global_content_visibility_status)
			local_content_visibility_stack.put (l_local_content_visibility_status)

				-- We need to put something on the hiding stack, or we will get an
				-- invariant violation when calling `current_block_logical_visibility'.
			hiding_stack.put (l_hiding_status)

			hiding_stack.replace (l_hiding_status or (not current_block_logical_visibility))

			-- TODO: test with the following line and see if I really get an invariant violation.
			-- hiding_stack.put (l_hiding_status or (not current_block_logical_visibility))

			set_output_enabled
		ensure
			block_on_top_of_stack: block_stack.item.block_type = a_block_type
		end

		-- TODO: rename
	output_enabled_revenge: BOOLEAN
			-- Should the current section be output or not?

	set_output_enabled
			-- Update the `output_enabled_revenge' with the correct up-to-date value.
		local
			l_temp: AT_BLOCK_VISIBILITY -- TODO remove
		do
			l_temp := blocks_visibility [enum_block_type.bt_instruction]
			output_enabled_revenge := current_block_effective_visibility
		end

	current_block_effective_visibility: BOOLEAN
			-- Are we inside a block which should be visible?
			-- The answer keeps into account that, even if a block is "logically visible",
			-- it cannot be shown if located inside a hidden block.
		do
				-- As a rule, we cannot show any block if its parent block (container) is not visible
				-- as well, as if we did, the block would be "detached" in the output syntax tree
				-- which doesn't make sense and would result in a synctatically-invalid output.
				-- For this reason, if we are in a totally hidden section, then, no matter what, output is disabled.
			Result := current_block_logical_visibility and not in_hidden_block
		end

	current_block_logical_visibility: BOOLEAN
			-- Are we inside a block which should be theoretically visible?
			-- Even if the answer is yes, the block will not be effectively
			-- visible if inside a block which is hidden, as it would otherwise
			-- be "detached" in the syntax tree.
		local
			l_current_value: AT_TRI_STATE_BOOLEAN
			l_top_block: AT_BLOCK_VISIBILITY
		do
			if block_stack.is_empty then
				Result := True
			else
				l_top_block := block_stack.item

					-- Start with the default visibility (from the hint table).
				l_current_value := to_tri_state (l_top_block.default_visibility)


					-- Complex blocks are not subject to the content visibility policy.
					-- Simple blocks contained in them will be subject to it.
				if not attached {AT_COMPLEX_BLOCK_VISIBILITY} l_top_block then
						-- Apply the current global content visibility policy,
						-- which is stored on the top of the respective stack.
					l_current_value := l_current_value.subjected_to (global_content_visibility_stack.item)
				end

					-- Apply global policy (i.e. the one defined by a "#SHOW_ALL" command about this block type).
				l_current_value := l_current_value.subjected_to (l_top_block.global_visibility_override)

					-- Once again, only apply the content visibility policy if this is a not a complex block.
				if not attached {AT_COMPLEX_BLOCK_VISIBILITY} l_top_block then
						-- Apply the current local content visibility policy (i.e. the one coming from
						-- the innermost #SHOW_NEXT_CONTENT command affecting the current block).
						-- It is stored on the top of the respective stack/
					l_current_value := l_current_value.subjected_to (local_content_visibility_stack.item)
				end

					-- Finally, apply the local visibility override flag for this block,
					-- coming from a "#SHOW_NEXT" command directly applied to it.
				l_current_value := l_current_value.subjected_to (l_top_block.local_visibility_override)

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
			global_content_visibility_stack.remove
			local_content_visibility_stack.remove

			set_output_enabled
		end

feature {NONE} -- Implementation

	options: AT_OPTIONS

	original_options: AT_OPTIONS

	make_with_options (a_options: AT_OPTIONS)
		do
			options := a_options
			original_options := a_options.twin
			output_enabled_revenge := True

			create {ARRAYED_STACK [AT_BLOCK_VISIBILITY]} block_stack.make (32)
			create {ARRAYED_STACK [BOOLEAN]} hiding_stack.make (32)
			create {ARRAYED_STACK [AT_TRI_STATE_BOOLEAN]} global_content_visibility_stack.make (32)
			create {ARRAYED_STACK [AT_TRI_STATE_BOOLEAN]} local_content_visibility_stack.make (32)

			initialize_block_visibility_table
			-- output_enabled := True
		end

	initialize_block_visibility_table -- TODO: get rid of this?
		local
			l_block_type: AT_BLOCK_TYPE
			l_block: AT_BLOCK_VISIBILITY
			l_complex_block: AT_COMPLEX_BLOCK_VISIBILITY
		do
			create blocks_visibility.make (32)

			across enum_block_type.values as ic loop
				l_block_type := ic.item
				if enum_block_type.is_complex_block_type (l_block_type) then
					create {AT_COMPLEX_BLOCK_VISIBILITY} l_block.make_with_two_agents (l_block_type, agent block_default_visibility, agent block_content_default_visibility)
				else
					create l_block.make_with_visibility_agent (l_block_type, agent block_default_visibility)
				end
				blocks_visibility.put (l_block, ic.item)
			end
		end

	block_default_visibility (a_block_type: AT_BLOCK_TYPE): BOOLEAN
		do
			Result := options.hint_table.visibility_for (a_block_type, options.hint_level).visibility
		end

	block_content_default_visibility (a_block_type: AT_BLOCK_TYPE): AT_TRI_STATE_BOOLEAN
		do
			Result := options.hint_table.content_visibility_for (a_block_type, options.hint_level).visibility
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

	parse_integer_range_string (a_string: READABLE_STRING_GENERAL; a_default_second: INTEGER): TUPLE [first: INTEGER; second: INTEGER]
			-- Parses a range string with format "3-8". If the string is a simple number
			-- without dash, then `a_default_second' is returned as the second number.
			-- Void is returned if parsing failed.
		local
			l_first_string, l_second_string: READABLE_STRING_GENERAL
			l_strings: LIST [READABLE_STRING_GENERAL]
			l_error: BOOLEAN
		do
			if a_string.has ('-') then
				l_strings := a_string.split ('-')
				if l_strings.count = 2 then
					create Result
					if l_strings.first.is_natural_32 then
						Result.first := l_strings.first.to_integer_32
					else
						l_error := True
					end
					if l_strings.last.is_natural_32 then
						Result.second := l_strings.last.to_integer_32
					else
						l_error := True
					end
					if l_error then
						Result := Void
					end
				end
			else
				if l_strings.first.is_natural_32 then
					create Result
					Result.first := l_strings.first.to_integer_32
					Result.second := a_default_second
				end
			end
		end

invariant

	all_visibility_keys: across enum_block_type.values as ic all blocks_visibility.has_key (ic.item)  end
	only_visibility_keys: across blocks_visibility.current_keys as ic all enum_block_type.is_valid_numerical_value (ic.item.numerical_value) end
	stacks_same_size: block_stack.count = hiding_stack.count and hiding_stack.count = global_content_visibility_stack.count and global_content_visibility_stack.count = local_content_visibility_stack.count

end
