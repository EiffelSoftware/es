note
	description: "Class to collect feature calls from an AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR
		redefine
			-- CALL_AS
			---- ACCESS_AS
			process_current_as,
			process_precursor_as,
			process_result_as,
			process_access_feat_as,
			------ ACCESS_FEAT_AS
			-------- (ACCESS_INV_AS)
			---------- (ACCESS_ASSERT_AS)
			---------- (ACCESS_ID_AS)
			-------- (STATIC_ACCESS_AS)
			---- CREATION_EXPR_AS
			process_bang_creation_expr_as,
			process_create_creation_expr_as,
			---- NESTED_AS
			process_nested_as,
			---- NESTED_EXPR_AS
			process_nested_expr_as,

			-- INSTRUCTION_AS
			---- CREATION_AS
			process_creation_as
		end

	EPA_UTILITY

	EPA_FEATURE_CALL_COLLECTOR_UTILITY


feature -- Access

	last_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]
			-- Feature calls collected by last call to `collect'
			-- Keys are break point slots, values are feature calls
			-- associated with those break points.
			-- Note: since this class works in AST level, there is
			-- no guarantee that the CALL_AS nodes represents type-wise valid
			-- Eiffel expressions or statements. No type checking is done.

	last_calls_without_breakpoints: LINKED_LIST [CALL_AS]
			-- Calls from `last_calls, with calls from different calls
			-- at various breakpoints accumulated together, and with
			-- duplicates removed
		do
			Result := calls_without_breakpoints (last_calls)
		end

feature -- Basic operations

	collect_from_ast (a_ast: AST_EIFFEL; a_variables: LINEAR_SUBSET [STRING])
			-- Collect feature calls from `a_ast' which mentions `a_variables',
			-- and make results available in `last_calls'.
			-- `a_variables' is a set of variables that `a_ast' is allow to access.
			-- The set may also include reserved entity names such as Current and Result.
			-- The variable names are case insensitive.
		local
			l_ast: AST_EIFFEL
		do
			l_ast := ast_with_breakpoints (a_ast)

			create last_calls.make (16)
			allowed_variables := a_variables
			l_ast.process (Current)
		end

feature -- Access

	allowed_variables: LINEAR_SUBSET [STRING]

feature{NONE} -- Implementation

	breakpoint_initializer: ETR_BP_SLOT_INITIALIZER
			-- Break point initializer
		once
			create Result
		end

	ast_with_breakpoints (a_ast: AST_EIFFEL): AST_EIFFEL
			-- A copy of `a_ast' with breakpoint information initialized.
			-- Do not change `a_ast'.
		local
			l_text: STRING
		do
			l_text := text_from_ast (a_ast)
			if attached {EXPR_AS} a_ast as l_expr then
				Result := ast_from_expression_text (l_text)
			else
				Result := ast_from_compound_text (l_text)
			end
			breakpoint_initializer.init_from (Result)
		end

	add_call (a_as: CALL_AS; a_key: INTEGER)
			-- Add a call to the last_calls hash table
		local
			l_list: LINKED_LIST [CALL_AS]
		do
			if last_calls.has (a_key) then
					-- Call already exists with this breakpoint slot --> at to the existing list of calls
				last_calls.item (a_key).extend (a_as)
			else
					-- No all with this breakpoint slot yet --> create and add a new list containing this call
				create l_list.make
				l_list.extend (a_as)
				last_calls.put (l_list, a_key)
			end
		end

feature -- Visitor Routines

	process_current_as (a_as: CURRENT_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_precursor_as (a_as: PRECURSOR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_result_as (a_as: RESULT_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_access_feat_as (a_as: ACCESS_FEAT_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_bang_creation_expr_as (a_as: BANG_CREATION_EXPR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_create_creation_expr_as (a_as: CREATE_CREATION_EXPR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_nested_as (a_as: NESTED_AS)
		do
			if allowed_variables.has (a_as.target.access_name) then
					-- Add a_as to last_calls if the target of the nested call is a variable that is allowed to access
				add_call (a_as, a_as.breakpoint_slot)
			end
		end

	process_nested_expr_as (a_as: NESTED_EXPR_AS)
		do
				-- TODO: only add if target is an allowed variable
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_creation_as (a_as: CREATION_AS)
		local
			l_nested_as: NESTED_AS
			l_creation_expr: CREATE_CREATION_EXPR_AS
			l_type: TYPE_AS
		do
			if a_as.call /= Void then

				if allowed_variables.has (a_as.target.access_name) then
						-- A creation instruction of the form "create target.creation_procedure" is added as a nested_as
					create l_nested_as.initialize (a_as.target, a_as.call, Void)
					add_call (l_nested_as, a_as.breakpoint_slot)
				end

			else
					-- TODO: What to do with a creation instruction of the form "create target" ?

			end
		end

end
