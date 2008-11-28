indexing
	description:
		"[
			Shared access to context.
		]"
	date: "$Date$"
	revision: "$Revision$"

class SHARED_EP_CONTEXT

feature -- Access

	ev_context: !EP_CONTEXT
			-- Shared access to context
		once
			create Result
		end

end
