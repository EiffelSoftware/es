note
	description: "[
			CMS String 8 resolver using JSON object interface
			Field name as variable name, and Field value as variable value.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_JSON_STRING_8_RESOLVER

inherit
	CMS_STRING_RESOLVER [READABLE_STRING_8]

create
	make

feature {NONE} -- Initialization

	make (j: JSON_OBJECT)
		do
			object := j
		end

	object: JSON_OBJECT

feature -- Access

	value (n: READABLE_STRING_GENERAL): detachable READABLE_STRING_8
		do
			if attached object [n] as v then
				if attached {JSON_STRING} v as js then
					Result := js.unescaped_string_8
				elseif attached {JSON_NUMBER} v as jnum then
					Result := jnum.item
				else
					Result := v.representation
				end
			end
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
