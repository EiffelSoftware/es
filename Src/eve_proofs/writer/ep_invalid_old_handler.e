indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_INVALID_OLD_HANDLER

inherit

	EP_OLD_HANDLER

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do
		end

feature -- Processing

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		local
			l_error: EP_UNSUPPORTED_ERROR
		do
				-- TODO: internationalization
			create l_error.make ("Old expression in this context not allowed")
			l_error.set_from_context
			errors.extend (l_error)
		end

end
