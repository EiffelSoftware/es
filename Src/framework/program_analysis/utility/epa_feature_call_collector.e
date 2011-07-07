note
	description: "Class to collect feature calls from an AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR

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
--			l_ast.process (Current)
			-- TODO: implement here.
		end

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

end
