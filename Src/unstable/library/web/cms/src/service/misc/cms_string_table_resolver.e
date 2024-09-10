note
	description: "[
			String resolver using table
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STRING_TABLE_RESOLVER [G -> READABLE_STRING_GENERAL]

inherit
	CMS_STRING_RESOLVER [G]

create
	make

feature -- Initialization

	make (nb: INTEGER)
		do
			create values.make (nb)
		end

feature -- Access

	values: STRING_TABLE [G]

	value (n: READABLE_STRING_GENERAL): detachable G
		do
			Result := values [n]
		end

feature -- Element change

	force, put (new: G; key: READABLE_STRING_GENERAL)
		do
			values.force (new, key)
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
