note
	description: "Program location finder which finds potentially interesting program locations%
		%of an abstract syntax tree with respect to data flow."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_PROGRAM_LOCATION_FINDER

inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_access_id_as,
			process_create_creation_as,
			process_nested_as,
			process_assign_as,
			process_assigner_call_as,
			process_access_feat_as,
			process_if_as,
			process_loop_as
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

create
	default_create, make

feature {NONE} -- Initialization

	make (a_ast: like ast)
			-- Initialize current program location finder.
		require
			a_ast_not_void: a_ast /= Void
		do
			set_ast (a_ast)
		ensure
			ast_set: ast = a_ast
		end

feature -- Access

	last_program_locations: DS_HASH_SET [INTEGER]
			-- Last found program locations of `ast' which are interesting with respect to data flow.

	ast: AST_EIFFEL
			-- AST which is used to find potentially interesting program locations.

feature -- Basic operations

	find
			-- Find all potentially interesting program locations of `ast' and make them available
			-- in `last_program_locations'.
		require
			ast_not_void: ast /= Void
		local
			l_breakpoint_initializer: ETR_BP_SLOT_INITIALIZER
		do
			-- Initialize `program_locations' which will contain
			-- the found potentially interesting program locations.
			create last_program_locations.make_default

			-- Initialize breakpoints of `ast'.
			create l_breakpoint_initializer
			l_breakpoint_initializer.init_from (ast)

			-- Find potentially interesting program locations in `ast'.
			ast.process (Current)
		end

feature -- Setting

	set_ast (a_ast: like ast)
			-- Set `ast' to `a_ast'.
		require
			a_ast_not_void: a_ast /= Void
		do
			ast := a_ast
		ensure
			ast_set: ast = a_ast
		end

feature {AST_EIFFEL} -- Roundtrip

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Process `l_as'.
		do
			-- Store breakpoint of `l_as' if and only if the target of the qualified call is
			-- not "io".
			if
				not l_as.access_name_8.is_equal (Io_string)
			then
				last_program_locations.force_last (l_as.breakpoint_slot)
			end

			process_access_feat_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
			-- Store breakpoint of `l_as'.
			last_program_locations.force_last (l_as.breakpoint_slot)
		end

	process_nested_as (l_as: NESTED_AS)
			-- Process `l_as'.
		do
			l_as.target.process (Current)
		end

	process_assign_as (l_as: ASSIGN_AS)
			-- Process `l_as'.
		do
			l_as.target.process (Current)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
			-- Process `l_as'.
		do
			l_as.target.process (Current)
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

feature {NONE} -- Implementation

	Io_string: STRING = "io"
			-- String representation of "io"

end
