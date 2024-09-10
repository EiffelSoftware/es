note
	description: "Summary description for {APPLICATION_ENVIRONMENT_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_ENVIRONMENT_RESOLVER

inherit
	APPLICATION_RESOLVER

	SHARED_EXECUTION_ENVIRONMENT

feature -- Access

	expanded_variable (vn: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
			-- <Precursor/>
		do
			Result := execution_environment.item (vn)
		end

note
	copyright: "2011-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
