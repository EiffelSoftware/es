note
	description: "Summary description for {BASE64}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	BASE64_ENCODER

inherit
	ENCODER [READABLE_STRING_8, READABLE_STRING_8]
		redefine
			valid_encoded_string
		end

	BASE64

feature -- Access

	name: READABLE_STRING_8
		do
			create {IMMUTABLE_STRING_8} Result.make_from_string ("base64")
		end

feature -- Status report

	valid_encoded_string (v: READABLE_STRING_8): BOOLEAN
		do
			Result := Precursor (v) and then
					(v.is_empty or v.count >= 4)
		end

note
	copyright: "Copyright (c) 2011-2025, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
