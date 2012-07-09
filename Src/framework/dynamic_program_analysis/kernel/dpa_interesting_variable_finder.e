note
	description: "Finds interesting variables with respect to data flow."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_INTERESTING_VARIABLE_FINDER

inherit
	AST_ITERATOR
		redefine
			process_access_id_as,
			process_create_creation_as,
			process_nested_as,
			process_assign_as,
			process_assigner_call_as,
			process_access_feat_as,
			process_if_as,
			process_loop_as,
			process_result_as
		end

	EPA_UTILITY

create
	default_create, make

feature -- Initialization

	make (a_ast: like ast; a_program_locations: like program_locations)
			-- Sets `ast' to `a_ast' and `program_locations' to `a_program_locations'.
		require
			a_ast_not_void: a_ast /= Void
			a_program_locations_not_void: a_program_locations /= Void
		do
			set_ast (a_ast)
			set_program_locations (a_program_locations)
		ensure
			ast_set: ast = a_ast
			program_locations_set: program_locations = a_program_locations
		end

feature -- Basic operations

	find
			-- Find all interesting variables and make them available
			-- in `interesting_variables' and in
			-- `interesting_variables_from_assignments'
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)

			create interesting_variables_from_assignments.make_default
			interesting_variables_from_assignments.set_equality_tester (string_equality_tester)

			ast.process (Current)
		end

feature -- Process operations

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Process `l_as'.
		do
			if program_locations.has (l_as.breakpoint_slot) then
				if is_nested then
					if not l_as.access_name_8.is_equal (io_string) then
						interesting_variables.force_last (l_as.access_name_8)
					end
				else
					interesting_variables.force_last (ti_current)
				end
			end
			process_access_feat_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
			if program_locations.has (l_as.breakpoint_slot) then
				interesting_variables.force_last (l_as.target.access_name)
			end
		end

	process_nested_as (l_as: NESTED_AS)
			-- Process `l_as'.
		do
			is_nested := True
			if is_assigner_call then
				interesting_variables_from_assignments.force_last (text_from_ast (l_as))
			end
			l_as.target.process (Current)
			is_nested := False
		end

	process_assign_as (l_as: ASSIGN_AS)
			-- Process `l_as'.
		do
			interesting_variables_from_assignments.force_last (l_as.target.access_name)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
			-- Process `l_as'.
		do
			is_assigner_call := True
			l_as.target.process (Current)
			is_assigner_call := False
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- Process `l_as'.
		do
			-- Nothing to be done
		end

	process_if_as (l_as: IF_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_loop_as (l_as: LOOP_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.compound)
		end

	process_result_as (l_as: RESULT_AS)
			-- Process `l_as'.
		do
			if program_locations.has (l_as.breakpoint_slot) then
				interesting_variables.force_last (ti_result)
			end
		end

feature -- Access

	interesting_variables: DS_HASH_SET [STRING]
			-- Contains all found interesting variables
			-- with respect to data flow.

	interesting_variables_from_assignments: DS_HASH_SET [STRING]
			-- Contains all found interesting variables from assignments
			-- with respect to data flow.

	ast: AST_EIFFEL
			-- AST which is used to collect interesting variables

	program_locations: DS_HASH_SET [INTEGER]
			-- Program locations at which variables should be found.

feature -- Setting

	set_ast (a_ast: like ast)
			-- Set `ast' to `a_ast'
		require
			a_ast_not_void: a_ast /= Void
		local
			l_bp_slot_initializer: ETR_BP_SLOT_INITIALIZER
		do
			ast := a_ast
			create l_bp_slot_initializer
			l_bp_slot_initializer.init_from (ast)
		ensure
			ast_set: ast = a_ast
		end

	set_program_locations (a_program_locations: like program_locations)
			-- Set `program_locations' to `a_program_locations'
		require
			a_program_locations_not_void: a_program_locations /= Void
		do
			program_locations := a_program_locations
		ensure
			program_locations_set: program_locations = a_program_locations
		end

feature {NONE} -- Implementation

	is_nested: BOOLEAN
			-- Is the current node part of a NESTED_AS node?

	is_assigner_call: BOOLEAN
			-- Is the current node part of a ASSIGNER_CALL_AS node?

	io_string: STRING = "io"
			-- Constant string representing "io"

end
