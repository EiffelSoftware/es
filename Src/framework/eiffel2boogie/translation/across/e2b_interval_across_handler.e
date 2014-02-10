note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INTERVAL_ACROSS_HANDLER

inherit
	E2B_ACROSS_HANDLER
		redefine
			domain
		end

create
	make

feature -- Access

	domain: BIN_FREE_B
			-- <Precursor>	

	lower_bound: IV_EXPRESSION
			-- Lower bound of the interval.

	upper_bound: IV_EXPRESSION
			-- Upper bound of the interval.

feature -- Basic operations

	handle_call_item (a_feature: FEATURE_I)
			-- <Precursor>
		do
			expression_translator.set_last_expression (expression_translator.locals_map.item (bound_variable.position))
		end

	handle_call_cursor_index (a_feature: FEATURE_I)
			-- <Precursor>
		local
			l_binop1, l_binop2: IV_BINARY_OPERATION
		do
			create l_binop1.make (expression_translator.locals_map.item (bound_variable.position), "+", create {IV_VALUE}.make ("1", types.int), types.int)
			create l_binop2.make (l_binop1, "-", lower_bound, types.int)
			expression_translator.set_last_expression (l_binop2)
		end

	handle_call_after (a_feature: FEATURE_I)
			-- <Precursor>
		local
			l_binop: IV_BINARY_OPERATION
		do
			create l_binop.make (expression_translator.locals_map.item (bound_variable.position), ">", upper_bound, types.bool)
			expression_translator.set_last_expression (l_binop)
		end

	handle_call_forth (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

feature {NONE} -- Implementation

	translate_domain
			-- <Precursor>
		do
			domain.left.process (expression_translator)
			lower_bound := expression_translator.last_expression
			domain.right.process (expression_translator)
			upper_bound := expression_translator.last_expression
		end

	bound_var_type: IV_TYPE
			-- <Precursor>
		once
			Result := types.int
		end

	guard (a_bound_var: IV_ENTITY): IV_EXPRESSION
			-- <Precursor>
		do
			Result := factory.and_ (factory.less_equal (lower_bound, a_bound_var),
				factory.less_equal (a_bound_var, upper_bound))
		end

	add_triggers (a_quantifier: IV_QUANTIFIER)
			-- Add triggers to `a_quantifier' generated from the current across expression.
		do
			a_quantifier.add_restrictive_trigger
		end

end
