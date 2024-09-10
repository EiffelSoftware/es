note
	description: "[
			String resolver using the environment variables
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STRING_ENVIRONMENT_RESOLVER

inherit
	CMS_STRING_RESOLVER [STRING_32]

	SHARED_EXECUTION_ENVIRONMENT

feature -- Access

	value (n: READABLE_STRING_GENERAL): detachable STRING_32
		do
			Result := execution_environment.item (n)
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
