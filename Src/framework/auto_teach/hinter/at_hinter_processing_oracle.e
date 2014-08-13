note
	description: "Summary description for {AT_HINTER_PROCESSING_ORACLE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_PROCESSING_ORACLE

inherit
	AT_COMMON

	AT_TRI_STATE_BOOLEAN_CONSTANTS

create
	make_with_options

feature -- Oracle

	must_hide_routine_arguments: BOOLEAN
			-- Should we hide the arguments of the routine we are processing in the current status?
		do
			Result := (not forced_routine_visibility).imposed_over_bool (options.hide_routine_arguments)
		end

	must_hide_precondition: BOOLEAN
			-- Should we hide the precondition we are processing in the current status?
		do
			Result := (not forced_precondition_visibility).imposed_over_bool (options.hide_preconditions)
		end

	must_hide_locals: BOOLEAN
			-- Should we hide the locals of the routine we are processing in the current status?
		do
			Result := (not forced_locals_visibility).imposed_over_bool (options.hide_locals)
		end

	must_hide_routine_body: BOOLEAN
			-- Should we hide the body of the routine we are processing in the current status?
		do
			Result := (not forced_routine_body_visibility).imposed_over_bool (options.hide_routine_bodies)
		end

	must_hide_postcondition: BOOLEAN
			-- Should we hide the postcondition we are processing in the current status?
		do
			Result := (not forced_postcondition_visibility).imposed_over_bool (options.hide_postconditions)
		end

	must_hide_class_invariant: BOOLEAN
			-- Should we hide the class invariant we are processing in the current status?
		do
			Result := (not forced_class_invariant_visibility).imposed_over_bool (options.hide_class_invariants)
		end


feature -- Status signaling

	begin_process_new_class
			-- Signal that a class is about to be processed.
		do
			options := original_options.twin
			forced_routine_visibility := tri_undefined
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
		end

	begin_process_routine
			-- Signal that a routine is about to be processed.
		do
		end

	end_process_routine
			-- Signal that a routine has been processed.
		do
			forced_routine_visibility := tri_undefined
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

feature -- Policy signaling

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

feature {NONE} -- Implementation

	forced_routine_visibility: AT_TRI_STATE_BOOLEAN
	forced_routine_arguments_visibility: AT_TRI_STATE_BOOLEAN
	forced_precondition_visibility: AT_TRI_STATE_BOOLEAN
	forced_locals_visibility: AT_TRI_STATE_BOOLEAN
	forced_routine_body_visibility: AT_TRI_STATE_BOOLEAN
	forced_postcondition_visibility: AT_TRI_STATE_BOOLEAN
	forced_class_invariant_visibility: AT_TRI_STATE_BOOLEAN

	force_block_visibility (a_block_type: STRING; a_visibility: BOOLEAN)
		require
			valid_block_type: is_valid_block_type (a_block_type)
		local
			l_block_type: STRING
		do
			l_block_type := a_block_type.as_lower
			if a_block_type.same_string (bt_routine) then
				forced_routine_visibility := to_tri_state (a_visibility)
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
			original_options := a_options
			options := original_options.twin
		end


end
