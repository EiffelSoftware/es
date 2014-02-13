note
	description: "{PR_IO} represents a wrapper around the NSPR io handles such as sockets, file descriptors, directories etc."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PR_IO


feature -- Access
	handle: POINTER

	c: PR_IO_C

feature -- Status report
	use_exceptions: BOOLEAN assign set_use_exceptions

	error: detachable PR_ERROR

feature -- Status setting
	set_use_exceptions (a_val: BOOLEAN)
		do
			use_exceptions := a_val
		ensure
			use_exceptions = a_val
		end

feature {PR_IO_C} -- Helper

	set_error
			-- Set error attribute and raise exception if `use_exceptions' is True
		do
			create error
			if use_exceptions then
				(create {PR_EXCEPTION}.make).raise
			end
		end
end
