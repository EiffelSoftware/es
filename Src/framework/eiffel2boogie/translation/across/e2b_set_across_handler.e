note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SET_ACROSS_HANDLER

inherit
	E2B_ACROSS_HANDLER

create
	make

feature -- Access

	set: IV_EXPRESSION
		-- Boogie set to quantify over.

feature -- Basic operations

	handle_call_item (a_feature: FEATURE_I)
			-- <Precursor>
		do
			expression_translator.set_last_expression (expression_translator.locals_map.item (bound_variable.position))
		end

	handle_call_cursor_index (a_feature: FEATURE_I)
			-- <Precursor>
		do
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
			expression_translator.process_as_set (domain, bound_var_type)
			set := expression_translator.last_expression
		end

	bound_var_type: IV_TYPE
			-- <Precursor>
		do
			Result := types.for_type_a (bound_variable.type.generics.first)
		end

	guard (a_bound_var: IV_ENTITY): IV_EXPRESSION
			-- <Precursor>
		do
			Result := factory.map_access (set, << a_bound_var >>)
		end

end

