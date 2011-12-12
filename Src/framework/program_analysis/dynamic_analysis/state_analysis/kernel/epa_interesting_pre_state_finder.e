note
	description: "Class to find interesting pre-states with respect to data flow."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTERESTING_PRE_STATE_FINDER

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

	KL_SHARED_STRING_EQUALITY_TESTER

create
	default_create, make_with

feature -- Initialization

	make_with (a_ast: like ast)
			-- Sets `ast' to `a_ast'
		require
			a_ast_not_void: a_ast /= Void
		do
			set_ast (a_ast)
		ensure
			ast_set: ast = a_ast
		end

feature -- Basic operations

	find
			-- Find all interesting pre-states and make them available
			-- in `interesting_pre_states'
		do
			create interesting_pre_states.make_default

			ast.process (Current)
		end

feature -- Process operations

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if is_nested then
				if not l_as.access_name_8.is_equal ("io") then
					interesting_pre_states.force_last (l_as.breakpoint_slot)
				end
			else
				interesting_pre_states.force_last (l_as.breakpoint_slot)
			end
			process_access_feat_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			-- Nothing to be done
		end

	process_nested_as (l_as: NESTED_AS)
		do
			is_nested := True
			l_as.target.process (Current)
			is_nested := False
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			l_as.target.process (Current)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			l_as.target.process (Current)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			-- Nothing to be done
		end

	process_if_as (l_as: IF_AS)
		do
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.compound)
		end

	process_result_as (l_as: RESULT_AS)
		do
			interesting_pre_states.force_last (l_as.breakpoint_slot)
		end

feature -- Access

	interesting_pre_states: DS_HASH_SET [INTEGER]
			-- Contains all found interesting pre-states
			-- in terms of breakpoint slots.

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

feature {NONE} -- Implementation

	ast: AST_EIFFEL assign set_ast
			-- AST which is used to collect interesting variables

	is_nested: BOOLEAN
			-- Is the current node part of a NESTED_AS node?

end
