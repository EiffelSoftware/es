note
	description: "Utility class for the JSON file writer and reader."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_UTILITY

feature -- Transformation

	json_string_from_string (a_string: STRING): JSON_STRING
			-- JSON_STRING representing `a_string'.
		require
			a_string_not_void: a_string /= Void
		do
			create Result.make_json (a_string)
		ensure
			Result_not_void: Result /= Void
		end

	string_from_json_value (a_json_value: JSON_VALUE): STRING
			-- String contained in `a_json_value' if `a_json_value' is a JSON_STRING.
		require
			a_json_value_not_void: a_json_value /= Void
		do
			check
				attached {JSON_STRING} a_json_value as l_json_string
			then
				Result := l_json_string.item
			end
		ensure
			Result_not_void: Result /= Void
		end

end
