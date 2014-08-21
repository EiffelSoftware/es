note
	description: "[
		Oracle for class processing. Constantly informed about the status of the analysis,
		can always answer the question: are we supposed to output the current block or not?
		]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_PROCESSING_ORACLE

inherit

	AT_COMMON

create
	make_with_options

feature -- Oracle

	output_enabled: BOOLEAN
			-- Should the current section be output or not?

	inside_atomic_block: BOOLEAN
			-- Are we inside an atomic block right now?
		do
			Result := (nesting_in_atomic_block > 0)
		end

	current_content_visibility: AT_TRI_STATE_BOOLEAN
			-- What is the current status of content visibility?
		do
			if content_visibility_stack.is_empty then
				Result := Tri_undefined
			else
				Result := content_visibility_stack.item.value
			end
		end

	current_placeholder_type: AT_PLACEHOLDER
			-- What type of placeholder corresponds to the currently processed block?
			-- (regardless of code placeholders currently being enabled or not)

feature -- Status signaling

	begin_process_class
			-- Signal that a class is about to be processed.
		do
			-- Nothing to do.
		end

	end_process_class
			-- Signal that a class has been processed.
		require
			stack_empty: block_type_call_stack.is_empty
		local
			l_problematic_block_types: STRING
		do
			if not undefined_visibility_warning_set.is_empty then
				create l_problematic_block_types.make (50)
				across undefined_visibility_warning_set as ic loop
					l_problematic_block_types.append (ic.item.value_name + ", ")
				end
				l_problematic_block_types.remove_tail (2)

				print_message (at_strings.undefined_visibility (l_problematic_block_types))
			end
			options.restore_from (original_options)
			initialize_visibility_descriptors_table
		end

	block_type_call_stack: STACK [AT_BLOCK_TYPE]
			-- Stack recording the calls made to begin/end_process_block.
			-- Doesn't keep anything else into account.
			-- It is exposed to clients and only exists for contracts.

		-- TODO: Refactor?
	begin_process_block (a_block_type: AT_BLOCK_TYPE)
			-- Signal the oracle that a block of type `a_block_type' is about to be processed.
		local
			l_block_type: AT_BLOCK_TYPE
			l_hiding_status, l_is_complex_block: BOOLEAN
			l_visibility_status, l_block_visibility, l_content_visibility_status, l_block_content_visibility: AT_TRI_STATE_BOOLEAN
			l_visibility_policy_type, l_content_visibility_policy_type: AT_POLICY_TYPE
			l_descriptor, l_descriptor_in_table: AT_BLOCK_VISIBILITY_DESCRIPTOR
		do
			l_block_type := a_block_type
			l_descriptor_in_table := visibility_descriptors [l_block_type]
			l_descriptor := l_descriptor_in_table.twin

				-- Now that we have cloned the block, we reset the local override flags. These are single-use.
				-- Let's do it now, before we forget.
			l_descriptor_in_table.reset_local_overrides
			if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_descriptor_in_table as l_complex_descriptor_in_table then
				l_complex_descriptor_in_table.reset_local_treatment_overrides
			end

			if hiding_stack.is_empty then
					-- According to the invariant, all stacks are empty.

					-- Default values
				l_hiding_status := False
				l_content_visibility_status := Tri_undefined
				l_content_visibility_policy_type := enum_policy_type.Pt_not_set
			else
					-- Keep the current values.
				l_hiding_status := hiding_stack.item
				l_content_visibility_status := content_visibility_stack.item.value
				l_content_visibility_policy_type := content_visibility_stack.item.policy_type
			end

			if containing_atomic_block_effective_visibility.is_defined then
					-- No need to waste a lot of time checking the rest.
					-- We are inside a block which is treated as an atomic block,
					-- thus we have to apply the same contend visibility as the
					-- said block, period.
				l_block_visibility := containing_atomic_block_effective_visibility
			else
					-- Determine if this is a complex block and if it should be treated as such or as an atomic block.
				if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_descriptor as l_complex_descriptor then
					if l_complex_descriptor.local_treat_as_complex_override.imposed_on_bool (l_complex_descriptor.global_treat_as_complex) then
						l_is_complex_block := True
					else
							-- We must treat this block as if it were an atomic block.
						l_is_complex_block := False
					end
				else
					l_is_complex_block := False
				end

					-- For all blocks: compute the visibility
				l_block_visibility := l_descriptor.effective_visibility
				l_visibility_policy_type := l_descriptor.effective_visibility_policy_type

					-- For atomic blocks only: apply the current content visibility, if defined and "stronger".
				if not l_is_complex_block and then l_content_visibility_policy_type > l_visibility_policy_type then
						-- The following check holds because `l_content_visibility_policy_type'
						-- needs to be at least 'default' in order for the condition above to
						-- be satisfied, and if it is 'default', then the value is defined.
					check defined: l_content_visibility_status.is_defined end

					l_block_visibility := l_block_visibility.subjected_to (l_content_visibility_status)
						-- Theoretically the previous instruction should be equivalent to just doing:
						-- l_block_visibility := l_content_visibility_status

					l_visibility_policy_type := l_content_visibility_policy_type
				end
			end

				-- Whatever we computed so far, this can stop the show.
				-- If we are in a hidden region, we cannot show this block in any case,
				-- otherwise it would be orphan in the syntax tree of the output code.
			if l_hiding_status then
				l_block_visibility := Tri_false
			end

				-- If after this long chain the visibility is still undefined,
				-- we will force it to true and complain with the user.
			if l_block_visibility.is_undefined then
					-- We don't like this. We will give a warning.
				undefined_visibility_warning_set.extend (a_block_type)
				l_block_visibility := Tri_true
			end

				-- Now it should really be sure that `l_block_visibility' is properly set.
				-- Let's set l_hiding_status accordingly.
			check defined: l_block_visibility.is_defined end
			l_hiding_status := not l_block_visibility.value

			if l_is_complex_block and then attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_descriptor as l_complex_descriptor then
					-- For complex blocks only, compute the new valid content visibility policy (to be pushed into the stack).
				l_block_content_visibility := l_complex_descriptor.effective_content_visibility
				if l_block_content_visibility.is_defined then
						-- This will be the new status inside this block.
					l_content_visibility_status := l_block_content_visibility
					l_content_visibility_policy_type := l_complex_descriptor.effective_content_visibility_policy_type
				else
						-- This block will inherit its content visibility from the parent block,
						-- i.e., keep the current content visibility, which means there is nothing to do here.
				end
			end

			block_type_call_stack.put (a_block_type)
			block_stack.put (l_descriptor)
			content_visibility_stack.put ([l_content_visibility_status, l_content_visibility_policy_type])
			hiding_stack.put (l_hiding_status)

			refresh

			if nesting_in_atomic_block = 0 then
				if not l_is_complex_block then
					containing_atomic_block_effective_visibility := to_tri_state (output_enabled)
					nesting_in_atomic_block := nesting_in_atomic_block + 1
				end
			else
				nesting_in_atomic_block := nesting_in_atomic_block + 1
			end
		ensure
			block_on_top_of_stack: not block_type_call_stack.is_empty and then block_type_call_stack.item = a_block_type
		end


	end_process_block (a_block_type: AT_BLOCK_TYPE)
			-- Signal the oracle that the processing of a block of type `a_block_type' is completed.
		require
			block_on_top_of_stack: not block_type_call_stack.is_empty and then block_type_call_stack.item = a_block_type
		do
			block_type_call_stack.remove
			block_stack.remove
			hiding_stack.remove
			content_visibility_stack.remove

			if nesting_in_atomic_block > 0 then
				nesting_in_atomic_block := nesting_in_atomic_block - 1
				if nesting_in_atomic_block = 0 then
					containing_atomic_block_effective_visibility := Tri_undefined
				end
			end

			refresh
		end

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


		-- TODO: Refactor this method or add comments, it's totally unreadable.
	process_meta_command (a_line: STRING)
			-- Process the meta-command contained in `a_line'. Case insensitive.
		require
			is_meta_command: is_meta_command (a_line)
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_block_type_string: STRING
			l_command: AT_COMMAND
			l_error, l_recognized, l_is_complex_block: BOOLEAN
			l_tristate: AT_TRI_STATE_BOOLEAN
			l_block_type: AT_BLOCK_TYPE
		do
			last_command_output := Void

			create l_command.make_from_line (a_line)

			if l_command.valid and options.hint_level >= l_command.min_level and options.hint_level <= l_command.max_level then

					-- Check this as the very first thing:
				if l_command.command_word.same_string (at_strings.comment_command) then
					l_recognized := True
						-- Do nothing.
				elseif at_strings.commands_with_block.has (l_command.command_word) then
					l_block_type_string := l_command.payload.as_lower
					if not enum_block_type.is_valid_value_name (l_block_type_string) then
						l_error := true
					else
						l_block_type := enum_block_type.value (l_block_type_string)
						l_is_complex_block := enum_block_type.is_complex_block_type (l_block_type)

						if l_is_complex_block then
								-- The following commands are applicable only to a complex block.
							if l_command.command_word.same_string (at_strings.show_all_content_command) then
								set_block_content_global_visibility_override (l_block_type, Tri_true)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.hide_all_content_command) then
								set_block_content_global_visibility_override (l_block_type, Tri_false)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.reset_all_content_command) then
								set_block_content_global_visibility_override (l_block_type, Tri_undefined)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.show_next_content_command) then
								set_block_content_local_visibility_override (l_block_type, Tri_true)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.hide_next_content_command) then
								set_block_content_local_visibility_override (l_block_type, Tri_false)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.treat_all_as_complex) then
								set_block_global_treat_as_complex (l_block_type, True)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.treat_all_as_atomic) then
								set_block_global_treat_as_complex (l_block_type, False)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.treat_next_as_complex) then
								set_block_local_treat_as_complex_override (l_block_type, Tri_true)
								l_recognized := True
							elseif l_command.command_word.same_string (at_strings.treat_next_as_atomic) then
								set_block_local_treat_as_complex_override (l_block_type, Tri_false)
								l_recognized := True
							end
						end -- and not 'elseif', since the following commands can also be applied to a complex block.

						if l_command.command_word.same_string (at_strings.show_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_true)
							l_recognized := True
						elseif l_command.command_word.same_string (at_strings.hide_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_false)
							l_recognized := True
						elseif l_command.command_word.same_string (at_strings.reset_all_command) then
							set_block_global_visibility_override (l_block_type, Tri_undefined)
							l_recognized := True
						elseif l_command.command_word.same_string (at_strings.show_next_command) then
							set_block_local_visibility_override (l_block_type, Tri_true)
							l_recognized := True
						elseif l_command.command_word.same_string (at_strings.hide_next_command) then
							set_block_local_visibility_override (l_block_type, Tri_false)
							l_recognized := True
						end
					end
				elseif l_command.command_word.same_string (at_strings.hint_command) then
					last_command_output := a_line.twin
					l_recognized := True
				elseif l_command.command_word.same_string (at_strings.placeholder_command) then
					if string_is_bool (l_command.payload) then
						options.insert_code_placeholder := string_to_bool (l_command.payload)
						l_recognized := True
					end
				elseif l_command.command_word.same_string (at_strings.hint_mode_command) then
					options.hint_table := hint_tables.default_annotated_hint_table
					l_recognized := True
				elseif l_command.command_word.same_string (at_strings.unannotated_mode_command) then
					options.hint_table := hint_tables.default_unannotated_hint_table
					l_recognized := True
				elseif l_command.command_word.same_string (at_strings.custom_mode_command) then
					l_recognized := True
					if attached hint_tables.custom_hint_table as l_hint_table then
						options.hint_table := l_hint_table
					else
						print_message (capitalized (at_strings.meta_command) + ": " + a_line + "%N" + at_strings.no_custom_hint_table_loaded)
					end
				end
			end
			if options.hint_level >= l_command.min_level and options.hint_level <= l_command.max_level and not l_recognized then
				print_message (at_strings.unrecognized_meta_command + a_line)
			end
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

	last_command_output: detachable STRING
			-- The output of the last meta-command, to be printed to the output.

feature {NONE} -- Implementation: meta-command processing

	set_block_global_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
			-- Sets the global visibility override flag for block type `a_block_type' to `a_value'.
		do
			visibility_descriptors [a_block_type].global_visibility_override := a_value
		end

	set_block_local_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
			-- Sets the local visibility override flag for block type `a_block_type' to `a_value'.
		do
			visibility_descriptors [a_block_type].local_visibility_override := a_value
		end

	set_block_content_global_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
			-- Sets the global content visibility override flag for block type `a_block_type' to `a_value'.
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY_DESCRIPTOR
		do
			l_block := visibility_descriptors [a_block_type]
			check
				attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block
			end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block as l_complex_block then
				l_complex_block.global_content_visibility_override := a_value
			end
		end

	set_block_content_local_visibility_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
			-- Sets the local content visibility override flag for block type `a_block_type' to `a_value'.
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY_DESCRIPTOR
		do
			l_block := visibility_descriptors [a_block_type]
			check
				attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block
			end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block as l_complex_block then
				l_complex_block.local_content_visibility_override := a_value
			end
		end

	set_block_global_treat_as_complex (a_block_type: AT_BLOCK_TYPE; a_value: BOOLEAN)
			-- Sets the (global) policy for treating blocks of type `a_block_type' as complex
			-- (as opposed to treating them as atomic blocks) to `a_value'.
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY_DESCRIPTOR
		do
			l_block := visibility_descriptors [a_block_type]
			check
				attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block
			end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block as l_complex_block then
				l_complex_block.global_treat_as_complex := a_value
			end
		end

	set_block_local_treat_as_complex_override (a_block_type: AT_BLOCK_TYPE; a_value: AT_TRI_STATE_BOOLEAN)
			-- Sets the local override flag for treating blocks of type `a_block_type' as complex
			-- (as opposed to treating them as atomic blocks) to `a_value'.
		require
			complex_block: enum_block_type.is_complex_block_type (a_block_type)
		local
			l_block: AT_BLOCK_VISIBILITY_DESCRIPTOR
		do
			l_block := visibility_descriptors [a_block_type]
			check
				attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block
			end
			if attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block as l_complex_block then
				l_complex_block.local_treat_as_complex_override := a_value
			end
		end

feature {NONE} -- Implementation: block visibility

	visibility_descriptors: HASH_TABLE [AT_BLOCK_VISIBILITY_DESCRIPTOR, AT_BLOCK_TYPE]
			-- Table containing a the block visibility descriptor
			-- corresponding to every type.

	block_stack: STACK [AT_BLOCK_VISIBILITY_DESCRIPTOR]
			-- Stack of block visibility descriptors containing
			-- descriptors of the blocks we are currently in.

	hiding_stack: STACK [BOOLEAN]
			-- Stack, parallel to `block_stack', indicating, for every
			-- level, wether we are inside an effectively hidden block.

	in_hidden_block: BOOLEAN
			-- Are we inside an effectively hidden block right now?
		do
			Result := (not hiding_stack.is_empty and then hiding_stack.item = True)
		end

	content_visibility_stack: STACK [ TUPLE [value: AT_TRI_STATE_BOOLEAN; policy_type: AT_POLICY_TYPE]]
			-- Stack, parallel to `block_stack', indicating, for
			-- every level, the current state of content visibility.

	containing_atomic_block_effective_visibility: AT_TRI_STATE_BOOLEAN
		-- If we are inside an atomic block, what was that block's effective visibility?
		-- This visibility should be applied now, overriding anything else,
		-- as a single block is the smallest customizable unit, and anything
		-- inside it should be treated as a single thing.
		-- If we are not inside an atomic block, this value must be undefined.

	nesting_in_atomic_block: NATURAL
		-- Are we inside an atomic block? If so, how deep did we descend into blocks contained in it?
		-- Please note that it is only possible to descend into an atomic block if this block is actually
		-- a complex block being treated as an atomic block.
		-- 0 means that we are not inside an atomic block.

	refresh
			-- Update `output_enabled' and `current_placeholder_type' with the correct up-to-date value.
		local
			l_current_block: AT_BLOCK_TYPE
		do
			output_enabled := not in_hidden_block

			if block_stack.is_empty then
				current_placeholder_type := enum_placeholder.Ph_standard
			else
				l_current_block := block_stack.item.block_type
				if l_current_block = enum_block_type.Bt_arguments or l_current_block = enum_block_type.Bt_argument_declaration then
					current_placeholder_type := enum_placeholder.Ph_arguments
				elseif l_current_block = enum_block_type.Bt_if_condition then
					current_placeholder_type := enum_placeholder.Ph_if_condition
				else
					current_placeholder_type := enum_placeholder.Ph_standard
				end
			end
		end


feature {NONE} -- Implementation: miscellaneous

	options: AT_OPTIONS
			-- Current processing options

	original_options: AT_OPTIONS
			-- A copy of the original options passed to the initialization procedure.
			-- This copy is restored at the end of the processing of every class.

	make_with_options (a_options: AT_OPTIONS)
			-- Initialization for `Current'.
		do
			options := a_options
			original_options := a_options.twin
			output_enabled := True
			create {ARRAYED_STACK [AT_BLOCK_TYPE]} block_type_call_stack.make (32)
			create {ARRAYED_STACK [AT_BLOCK_VISIBILITY_DESCRIPTOR]} block_stack.make (32)
			create {ARRAYED_STACK [BOOLEAN]} hiding_stack.make (32)
			create {ARRAYED_STACK [TUPLE [value: AT_TRI_STATE_BOOLEAN; policy_type: AT_POLICY_TYPE]]} content_visibility_stack.make (32)
			create undefined_visibility_warning_set.make (enum_block_type.values.count)
			initialize_visibility_descriptors_table
				-- output_enabled := True
		end

	initialize_visibility_descriptors_table
			-- Fill `visibility_descriptors' with the proper descriptors.
		local
			l_block_type: AT_BLOCK_TYPE
			l_block: AT_BLOCK_VISIBILITY_DESCRIPTOR
			l_complex_block: AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR
		do
			create visibility_descriptors.make (32)
			across
				enum_block_type.values as ic
			loop
				l_block_type := ic.item
				if enum_block_type.is_complex_block_type (l_block_type) then
					create {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block.make_with_two_agents (l_block_type, agent block_default_visibility, agent block_content_default_visibility)
				else
					create l_block.make_with_visibility_agent (l_block_type, agent block_default_visibility)
				end
				visibility_descriptors.put (l_block, ic.item)
			end
		end

	block_default_visibility (a_block_type: AT_BLOCK_TYPE): AT_TRI_STATE_BOOLEAN
			-- What is the default visibility for `a_block_type'
			-- according to the current hint table?
		do
			Result := options.hint_table.visibility_for (a_block_type, options.hint_level).visibility
		end

	block_content_default_visibility (a_block_type: AT_BLOCK_TYPE): AT_TRI_STATE_BOOLEAN
			-- What is the default content visibility for
			-- `a_block_type' according to the current hint table?
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

	is_block_visibility_table_consistent: BOOLEAN
			-- Is the `visibility_descriptors' table in a consistent state?
		do
			Result := True
			across enum_block_type.values as ic loop
					-- All values are present
				if visibility_descriptors.has_key (ic.item) and then attached visibility_descriptors [ic.item] as l_block_visibility then

						-- The block visibility descriptor is really the correct one.
					Result := Result and (l_block_visibility.block_type = ic.item)

						-- The block visibility descriptor is an instance of `AT_COMPLEX_BLOCK_VISIBILITY'
						-- if and only if this is a complex block type.
					Result := Result and (enum_block_type.is_complex_block_type (ic.item) = (attached {AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR} l_block_visibility))

				else
					Result := False
				end
			end

				-- There are no additional values:
			across visibility_descriptors.current_keys as ic loop
				if not enum_block_type.is_valid_numerical_value (ic.item.numerical_value) then
					Result := False
				end
			end
		end

	is_top_of_block_type_call_stack_consistent: BOOLEAN
			-- Is the top item of `block_type_call_stack' consistent state?
		local
			l_call_stack_top, l_block_stack_top: AT_BLOCK_TYPE
		do
			if block_type_call_stack.is_empty or block_stack.is_empty then
				Result := (block_type_call_stack.is_empty and block_stack.is_empty)
			else
				Result := (block_type_call_stack.item = block_stack.item.block_type)
			end
		end

	undefined_visibility_warning_set: ARRAYED_SET [AT_BLOCK_TYPE]

	should_process_hint_continuation: BOOLEAN
			-- If we encounter a hint continuation command right now, should we process it?
			-- The answer will be yes basically if the last processed command was a hint
			-- and if it was shown according to the current hint level.

invariant
--	The following invariant is very expensive to check.
--	block_visibility_table_consistency: is_block_visibility_table_consistent
	stacks_same_size: block_stack.count = block_type_call_stack.count and block_type_call_stack.count = hiding_stack.count and hiding_stack.count = content_visibility_stack.count
	block_type_call_stack_consistency: is_top_of_block_type_call_stack_consistent
	containing_atomic_block_visibility_consistency: containing_atomic_block_effective_visibility.is_defined = (nesting_in_atomic_block > 0)

end
