indexing
	description: "Interface to all unicode string converters like UTF8_CONVERTER, UTF16LE_CONVERTER, UTF16BE_CONVERTER"
	author: "Unicode Team"
	date: "$Date$"
	revision: "$Revision$"

deferred class UNICODE_CONVERTER

feature -- Conversion
		wide_character_to_encoded (c: WIDE_CHARACTER) : ARRAY[NATURAL_8] is
				-- convert wide_character `c' to an encoded byte array
			deferred
			end

		encoded_to_wide_character (b: ARRAY[NATURAL_8]) : WIDE_CHARACTER is
				-- convert byte array `b' to a wide_character
			require
				array_not_void:	b /= Void
				right_encoded:	is_valid_encoded_array_as_character (b)
			deferred
			end

		string_32_to_encoded (s: STRING_32) : ARRAY[NATURAL_8] is
				-- convert string_32 `s' to an encoded byte array
			require
				string_not_void: s /= Void
			deferred
			end

		encoded_to_string_32 (b: ARRAY[NATURAL_8]) : STRING_32 is
				-- convert byte array `b' to a string_32
			require
				array_not_void:	b /= Void
				right_encoded:	is_valid_encoded_array_as_string (b)
			deferred
			end



		byte_array_to_string (b: ARRAY[NATURAL_8]) : STRING is
				-- convert byte array `b' to a string
			require
				array_not_void: b /= Void
			local
				i : INTEGER
			do
				create Result.make (b.count)

				from
					i := b.lower
				until
					i > b.upper
				loop
					Result.append_character (b.item (i).to_character_8)
					i := i + 1
				end
			ensure
				same_length: Result.count = b.count
			end

		string_to_byte_array (s: STRING) : ARRAY[NATURAL_8] is
				-- convert `s' to an array of bytes
			require
				string_not_void: s /= Void
			local
				i : INTEGER
			do
				create Result.make (1, s.count)
				from
					i := 1
				until
					i > s.count
				loop
					Result.put (s.item (i).code.as_natural_8, i)
					i := i + 1
				end
			ensure
				same_length: Result.count = s.count
			end



feature -- check states

	is_valid_encoded_array_as_character (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is byte array 'a' right encoded as a character?
		require
			array_not_void:  a /= void
		deferred
		end

	is_valid_encoded_array_as_string (a: ARRAY[NATURAL_8]): BOOLEAN is
			-- is byte array 'a' right encoded as a string?
		require
			array_not_void:  a /= void
		deferred
		end

	is_valid_char_to_encode (c: WIDE_CHARACTER): BOOLEAN is
			-- is 's' a valid string to encode
		deferred
		end

	is_valid_string_to_encode (s: STRING_32): BOOLEAN is
			-- is 's' a valid string to encode
		require
			string_not_void: s /= void
		deferred
		end

end
