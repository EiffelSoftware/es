note
	description: "Finder to collect query postconditions which are used to defined the result of that query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_QUERY_POSTCONDITION_FINDER

inherit
	REFACTORING_HELPER

	SHARED_TEXT_ITEMS

	EPA_UTILITY

feature -- Access

	last_expressions: LINKED_LIST [EPA_EXPRESSION]
			-- Expressions that define the result of the feature
			-- which was applied to `find' for the last time.

feature -- Status report

	is_non_equation_allowed: BOOLEAN
			-- Should result defining postconditions other than "=" and "~" be allowed?
			-- Default: False

feature -- Setting

	set_is_non_equation_allowed (b: BOOLEAN)
			-- Set `is_non_equation_allowed' with `b'.
		do
			is_non_equation_allowed := b
		ensure
			is_non_equation_allowed_set: is_non_equation_allowed = b
		end

feature -- Basic operations

	find (a_context_class: CLASS_C; a_feature: FEATURE_I; a_postconditions: LINKED_LIST [EPA_EXPRESSION])
			-- Search for postconditions from `a_postconditions' that define the Result of `a_feature',
			-- make result avaiable in `last_expressions'.
		require
			a_feature_is_a_query: a_feature.has_return_value
		do
			create last_expressions.make

				-- Find out those postconditions that define the Result of `a_feature'.
				-- Those postconditions should have one of the following forms:
				-- 1. Result = expr
				-- 2. Result implies expr
			fixme ("This is a simple hack, more advanced analysis is needed to deliver a reliable answer. 2.5.2010 Jasonw")
			across a_postconditions as l_expressions loop
				fixme ("We only can handle postconditions without qualified calls for the moment. 2.5.2010 Jasonw")
				if not l_expressions.item.text.has ('.') then
					if attached result_defining_expression (l_expressions.item) as l_expr then
						last_expressions.extend (l_expr)
					end
				end
			end
		end

feature{NONE} -- Implementation

	result_defining_expression (a_assertion: EPA_EXPRESSION): detachable EPA_EXPRESSION
			-- If there is an expression in `a_assertion' which can be considered to define the meaning
			-- of the expression "Result", return that expression, otherwise, return Void.
		local
			l_ast: EXPR_AS
			l_op_text: STRING
		do
			l_ast := a_assertion.ast
			if attached {BIN_EQ_AS} l_ast as l_equal_as then
				l_op_text := text_from_ast (l_equal_as.op_name)
				if l_op_text ~ ti_equal or l_op_text ~ ti_tilda then
					if text_from_ast (l_equal_as.left).is_case_insensitive_equal (ti_result) then
						create {EPA_AST_EXPRESSION} Result.make_with_text (a_assertion.class_, a_assertion.feature_, text_from_ast (l_equal_as.right), a_assertion.written_class)
					end
				end
			elseif is_non_equation_allowed and then attached {BINARY_AS} l_ast as l_bin then
				if text_from_ast (l_bin.left).is_case_insensitive_equal (ti_result) then
					create {EPA_AST_EXPRESSION} Result.make_with_feature (a_assertion.class_, a_assertion.feature_, l_ast, a_assertion.written_class)
				end

--			elseif attached {BIN_IMPLIES_AS} l_ast as l_implies_as then
--				if text_from_ast (l_implies_as.left).is_case_insensitive_equal (ti_result) then
--					create {EPA_AST_EXPRESSION} Result.make_with_text (a_assertion.class_, a_assertion.feature_, text_from_ast (l_implies_as.right), a_assertion.written_class)
--				end
			end
		end

end
