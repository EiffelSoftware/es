note
	description: "Summary description for {DKN_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_UTILITY

inherit
	DKN_CONSTANTS
	
feature -- Access	

	encoded_daikon_name (a_string: STRING): STRING
			-- Encoded string from `a_string', used as program point name
			-- All spaces in `a_string' is encoded as `escaped_space'
			-- in the result string.
		do
			create Result.make_from_string (a_string)
			Result.replace_substring_all (space, escaped_space)
		end

	decoded_daikon_name (a_string: STRING): STRING
			-- Decoded string from a Daikon name `a_string'
			-- All `escape_space' in `a_string' is replaced by
			-- `space' in result string.
		do
			create Result.make_from_string (a_string)
			Result.replace_substring_all (escaped_space, space)
		end

end
