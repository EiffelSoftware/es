note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ARRAY_ACROSS_HANDLER

inherit
	E2B_ACROSS_HANDLER

create
	make

feature -- Access

	array_expr: IV_EXPRESSION
			-- Translation of the underlying array.

feature -- Basic operations

	handle_call_item (a_feature: FEATURE_I)
			-- <Precursor>
		local
			l_call: IV_FUNCTION_CALL
		do
			check attached {IV_MAP_TYPE} array_expr.type as map_type then
				create l_call.make ("fun.ARRAY.item", map_type.range_type)
				l_call.add_argument (expression_translator.entity_mapping.heap)
				l_call.add_argument (array_expr)
				l_call.add_argument (expression_translator.locals_map.item (bound_variable.position))
				expression_translator.set_last_expression (l_call)
			end
		end

	handle_call_cursor_index (a_feature: FEATURE_I)
			-- <Precursor>
		do
			expression_translator.set_last_expression (expression_translator.locals_map.item (bound_variable.position))
		end

	handle_call_after (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

	handle_call_forth (a_feature: FEATURE_I)
			-- <Precursor>
		do
		end

feature {NONE} -- Implementation

	translate_domain
			-- <Precursor>
		do
			domain.process (expression_translator)
			array_expr := expression_translator.last_expression
		end

	bound_var_type: IV_TYPE
			-- <Precursor>
		once
			Result := types.int
		end

	guard (a_bound_var: IV_ENTITY): IV_EXPRESSION
			-- <Precursor>
		do
			Result := factory.function_call ("fun.ARRAY.is_index",
				<< expression_translator.entity_mapping.heap, array_expr, a_bound_var >>,
				types.bool)
		end

end
