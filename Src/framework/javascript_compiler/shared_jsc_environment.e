note
	description : "The class to inherit from to get access to the JavaScript Compilation results."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	SHARED_JSC_ENVIRONMENT

feature -- Shared

	errors: attached LIST [JSC_ERROR]
			-- Shared error list
		once
			create {LINKED_LIST [JSC_ERROR]} Result.make
		end

	warnings: attached LIST [JSC_ERROR]
			-- Shared warnings list
		once
			create {LINKED_LIST [JSC_ERROR]} Result.make
		end

end
