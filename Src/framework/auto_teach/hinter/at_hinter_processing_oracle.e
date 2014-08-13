note
	description: "Summary description for {AT_HINTER_PROCESSING_ORACLE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_PROCESSING_ORACLE

inherit
	AT_COMMON

create
	make_with_options

feature -- Oracle

	must_skip_feature: BOOLEAN
			-- Should we skip the feature we are processing in the current status?
		do
			Result := (not forced_feature_visibility).imposed_on_bool (False)
		end

	must_hide_routine_arguments: BOOLEAN
			-- Should we hide the arguments of the routine we are processing in the current status?
		do
			Result := (not forced_routine_arguments_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_routine_arguments)
		end

	must_hide_precondition: BOOLEAN
			-- Should we hide the precondition we are processing in the current status?
		do
			Result := (not forced_precondition_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_preconditions)
		end

	must_hide_locals: BOOLEAN
			-- Should we hide the locals of the routine we are processing in the current status?
		do
			Result := (not forced_locals_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_locals)
		end

	must_hide_routine_body: BOOLEAN
			-- Should we hide the body of the routine we are processing in the current status?
		do
			Result := (not forced_routine_body_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_routine_bodies)
		end

	must_hide_postcondition: BOOLEAN
			-- Should we hide the postcondition we are processing in the current status?
		do
			Result := (not forced_postcondition_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_postconditions)
		end

	must_hide_class_invariant: BOOLEAN
			-- Should we hide the class invariant we are processing in the current status?
		do
			Result := (not forced_class_invariant_visibility).imposed_on (forced_feature_content_visibility).imposed_on_bool (options.hide_class_invariants)
		end


feature -- Status signaling

	begin_process_class
			-- Signal that a class is about to be processed.
		do
			forced_feature_content_visibility := tri_undefined
			forced_feature_visibility := tri_undefined
			forced_routine_arguments_visibility := tri_undefined
			forced_precondition_visibility := tri_undefined
			forced_locals_visibility := tri_undefined
			forced_routine_body_visibility := tri_undefined
			forced_postcondition_visibility := tri_undefined
			forced_class_invariant_visibility := tri_undefined
		end

	end_processing_class
			-- Signal that a class has been processed.
		do
			options.restore_from (original_options)
		end

	begin_process_feature
			-- Signal that a feature is about to be processed.
		do
		end

	end_process_feature
			-- Signal that a feature has been processed.
		do
			forced_feature_content_visibility := tri_undefined
			forced_feature_visibility := tri_undefined
		end

	begin_process_routine_arguments
			-- Signal that routine arguments are about to be processed.
		do
		end

	end_process_routine_arguments
			-- Signal that routine arguments have been processed.
		do
			forced_routine_arguments_visibility := tri_undefined
		end

	begin_process_precondition
			-- Signal that a precondition is about to be processed.
		do
		end

	end_process_precondition
			-- Signal that a precondition has been processed.
		do
			forced_precondition_visibility := tri_undefined
		end

	begin_process_locals
			-- Signal that a block of locals is about to be processed.
		do
		end

	end_process_locals
			-- Signal that a block of locals has been processed.
		do
			forced_locals_visibility := tri_undefined
		end

	begin_process_routine_body
			-- Signal that a routine body is about to be processed.
		do
		end

	end_process_routine_body
			-- Signal that a routine body has been processed.
		do
			forced_routine_body_visibility := tri_undefined
		end

	begin_process_postcondition
			-- Signal that a postcondition is about to be processed.
		do
		end

	end_process_postcondition
			-- Signal that a postcondition has been processed.
		do
			forced_postcondition_visibility := tri_undefined
		end

	begin_process_class_invariant
			-- Signal that a class invariant is about to be processed.
		do
		end

	end_process_class_invariant
			-- Signal that a class invariant has been processed.
		do
			forced_class_invariant_visibility := tri_undefined
		end

feature -- Meta-command processing interface

	is_meta_command (a_line: STRING): BOOLEAN
			-- Does `a_line' contain a meta-command?
		local
			l_line: STRING
		do
			l_line := a_line.twin
			l_line.adjust
			Result := l_line.starts_with ("-- #")
		end

	process_meta_command (a_line: STRING)
			-- Process the meta-command contained in `a_line'. Case insensitive.
		require
			is_meta_command: is_meta_command (a_line)
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_line, l_argument, l_level_string: STRING
			l_index, l_level: INTEGER
			l_error, l_recognized: BOOLEAN
			l_tristate: AT_TRI_STATE_BOOLEAN
		do
			last_hint := Void

			l_line := a_line.twin
			l_level := 0

			l_line.adjust
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
			if not l_error and options.hint_level >= l_level then
				if l_line.as_upper.starts_with (at_strings.hint_command) then
					last_hint := a_line.twin
					l_recognized := True
				elseif l_line.as_upper.starts_with (at_strings.show_command) then
					l_line.remove_head (at_strings.show_command.count)
					l_line.left_adjust
					if is_valid_block_type (l_line.as_lower) then
						show_block (l_line.as_lower)
						l_recognized := True
					end
				elseif l_line.as_upper.starts_with (at_strings.hide_command) then
					l_line.remove_head (at_strings.hide_command.count)
					l_line.left_adjust
					if is_valid_block_type (l_line.as_lower) then
						hide_block (l_line.as_lower)
						l_recognized := True
					end
				elseif l_line.as_upper.starts_with (at_strings.show_content_command) then
					l_line.remove_head (at_strings.show_content_command.count)
					l_line.left_adjust
					if is_valid_content_block_type (l_line.as_lower) then
						show_block_content (l_line.as_lower)
						l_recognized := True
					end
				elseif l_line.as_upper.starts_with (at_strings.hide_content_command) then
					l_line.remove_head (at_strings.hide_content_command.count)
					l_line.left_adjust
					if is_valid_content_block_type (l_line.as_lower) then
						hide_block_content (l_line.as_lower)
						l_recognized := True
					end
				elseif l_line.as_upper.starts_with (at_strings.placeholder_command) then
					l_line.remove_head (at_strings.placeholder_command.count)
					l_line.left_adjust
					l_tristate := on_off_to_tristate (l_line)
					if l_tristate.defined then
						options.insert_code_placeholder := l_tristate.value
						l_recognized := True
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

	show_block (a_block_type: STRING)
		require
			valid_block_type: is_valid_block_type (a_block_type)
		do
			force_block_visibility (a_block_type, True)
		end

	hide_block (a_block_type: STRING)
		require
			valid_block_type: is_valid_block_type (a_block_type)
		do
			force_block_visibility (a_block_type, False)
		end


feature {NONE} -- Visibility

	forced_feature_visibility: AT_TRI_STATE_BOOLEAN

	forced_feature_content_visibility: AT_TRI_STATE_BOOLEAN
	forced_routine_arguments_visibility: AT_TRI_STATE_BOOLEAN
	forced_precondition_visibility: AT_TRI_STATE_BOOLEAN
	forced_locals_visibility: AT_TRI_STATE_BOOLEAN
	forced_routine_body_visibility: AT_TRI_STATE_BOOLEAN
	forced_postcondition_visibility: AT_TRI_STATE_BOOLEAN
	forced_class_invariant_visibility: AT_TRI_STATE_BOOLEAN

	force_block_content_visibility (a_block_type: STRING; a_visibility: BOOLEAN)
		require
			valid_block_type: is_valid_content_block_type (a_block_type)
		local
			l_block_type: STRING
		do
			l_block_type := a_block_type.as_lower
			if a_block_type.same_string (bt_feature) then
				forced_feature_content_visibility := to_tri_state (a_visibility)
			else
				check block_type_recognized: False end
			end
		end

	force_block_visibility (a_block_type: STRING; a_visibility: BOOLEAN)
		require
			valid_block_type: is_valid_block_type (a_block_type)
		local
			l_block_type: STRING
		do
			l_block_type := a_block_type.as_lower
			if a_block_type.same_string (bt_feature) then
				forced_feature_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_arguments) then
				forced_routine_arguments_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_precondition) then
				forced_precondition_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_locals) then
				forced_locals_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_routine_body) then
				forced_routine_body_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_postcondition) then
				forced_postcondition_visibility := to_tri_state (a_visibility)
			elseif a_block_type.same_string (bt_class_invariant) then
				forced_class_invariant_visibility := to_tri_state (a_visibility)
			else
				check block_type_recognized: False end
			end
		end

feature {NONE} -- Implementation

	options: AT_OPTIONS

	original_options: AT_OPTIONS

	make_with_options (a_options: AT_OPTIONS)
		do
			options := a_options
			original_options := a_options.twin
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

end
