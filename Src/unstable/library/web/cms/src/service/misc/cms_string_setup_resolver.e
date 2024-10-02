note
	description: "[
			String resolver using the CMS_SETUP values
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STRING_SETUP_RESOLVER

inherit
	CMS_STRING_RESOLVER [STRING_32]

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
		do
			setup := a_setup
		end

feature -- Access

	setup: CMS_SETUP

	value (n: READABLE_STRING_GENERAL): detachable STRING_32
		local
			res: READABLE_STRING_32
		do
			-- First check in setup.environment
			res := setup.text_item (query_name (n))
			if res = Void then
				res := setup.text_item (n)
			end
		end

feature {NONE} -- Internal

	query_name (n: READABLE_STRING_GENERAL): STRING_32
		local
			qn: like query_name
		do
			Result := query_name_prefix
			Result.keep_head (query_name_prefix_count)
			Result.append_string_general (n)
		end

	query_name_prefix_count: INTEGER_32
			-- Set only after a first call to `query_name_prefix`

	query_name_prefix: STRING_32
		once
			Result := "environment."
			query_name_prefix_count := Result.count
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
