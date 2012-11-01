note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_ACROSS_HANDLER

inherit

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

feature -- Access

	expression_translator: E2B_EXPRESSION_TRANSLATOR
			-- Expression translator for this handler.

feature -- Element change

	set_translator (a_translator: E2B_EXPRESSION_TRANSLATOR)
			-- Initialize this handler.
		do
			expression_translator := a_translator
		end

feature -- Basic operations

	handle_across_expression (a_expr: LOOP_EXPR_B)
			-- Handle across loop expression.
		deferred
		end

	handle_call_item (a_feature: FEATURE_I)
			-- Handle call to `item'.
		deferred
		end

	handle_call_cursor_index (a_feature: FEATURE_I)
			-- Handle call to `item'.
		deferred
		end

	handle_call_after (a_feature: FEATURE_I)
			-- Handle call to `item'.
		deferred
		end

	handle_call_forth (a_feature: FEATURE_I)
			-- Handle call to `item'.
		deferred
		end

end
