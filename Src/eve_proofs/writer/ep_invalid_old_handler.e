indexing
	description:
		"[
			Handler which issues an error for old expressions.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_INVALID_OLD_HANDLER

inherit

	EP_OLD_HANDLER

feature -- Processing

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		local
			l_error: EP_GENERAL_ERROR
		do
			create l_error.make (names.error_old_expression_not_allowed)
			l_error.set_description (names.description_old_expression_not_allowed)
			l_error.set_from_context
			errors.extend (l_error)
		end

end
