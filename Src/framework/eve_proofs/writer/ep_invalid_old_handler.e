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
			l_exception: EP_SKIP_EXCEPTION
		do
				-- TODO: better message
			create l_exception.make ("Old expression not allowed")
			l_exception.raise
		end

end
