note
	description: "Shared encoder for OAUTH purpose."
	date: "$Date$"
	revision: "$Revision$"

class
	OAUTH_SHARED_ENCODER

feature -- Encode

	oauth_encoded_string (s: READABLE_STRING_GENERAL): STRING_8
		do
			Result := oauth_encoder.encoded_string (s)
		end

feature -- Decode

	oauth_decoded_string (s: READABLE_STRING_GENERAL): STRING_32
		do
			Result := oauth_encoder.decoded_string (s)
		end

	oauth_decoded_string_8 (s: READABLE_STRING_GENERAL): STRING_8
		local
			s32: STRING_32
			utf: UTF_CONVERTER
		do
			s32 := oauth_encoder.decoded_string (s)
			if s32.is_valid_as_string_8 then
				Result := s32.to_string_8
			else
				Result := utf.utf_32_string_to_utf_8_string_8 (s32)
			end
		end

feature -- Access

	oauth_encoder: OAUTH_ENCODER
		once
			create Result
		end

note
	copyright: "2013-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
