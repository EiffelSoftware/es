note
	description : "The class to inherit from to get access to the JavaScript Compilation Context."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	SHARED_JSC_CONTEXT

feature -- Access

	jsc_context: attached JSC_CONTEXT
			-- Current translation context
		once
			create Result.make
		end

end
