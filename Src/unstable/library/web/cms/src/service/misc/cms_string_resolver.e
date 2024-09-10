note
	description: "Summary description for {CMS_STRING_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_STRING_RESOLVER [G -> READABLE_STRING_GENERAL]

feature -- Access

	value (n: READABLE_STRING_GENERAL): detachable G
		deferred
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
