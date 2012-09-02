note
	description: "Summary description for {DPA_JSON_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_UTILITY

feature -- Access

	json_string_from_string (a_string: STRING): JSON_STRING
			-- JSON_STRING representing `a_string'
		require
			a_string_not_void: a_string /= Void
		do
			Result := create {JSON_STRING}.make_json (a_string)
		ensure
			Result_not_void: Result /= Void
		end

	string_from_json (a_json_value: JSON_VALUE): STRING
			-- String contained in `a_json_value' if `a_json_value' is a JSON_STRING.
		require
			a_json_value_not_void: a_json_value /= Void
		do
			if attached {JSON_STRING} a_json_value as l_json_string then
				Result := l_json_string.item
			end
		end

end
