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

	encoded_daikon_name (a_name: STRING): STRING
			-- Escaped variable name from `a_name'.
			-- Replacing ' ' with "\_", and "\" with "\\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			create Result.make_from_string (a_name)
			Result.replace_substring_all ("\", "\\")
			Result.replace_substring_all (" ", "\_")
		end

	decoded_daikon_name (a_name: STRING): STRING
			-- Unescape variable names from `a_name'.
			-- Replacing "\_" with " ", and "\\" with "\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			create Result.make_from_string (a_name)
			Result.replace_substring_all ("\_", " ")
			Result.replace_substring_all ("\\", "\")
		end

end
