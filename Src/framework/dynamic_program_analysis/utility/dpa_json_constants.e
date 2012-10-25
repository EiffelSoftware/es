note
	description: "JSON constants used by the JSON file writer and reader."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_CONSTANTS

feature -- Access

	Json_class: JSON_STRING
			-- JSON_STRING representing "class".
		once
			create Result.make_json ("class")
		end

	Json_feature: JSON_STRING
			-- JSON_STRING representing "feature".
		once
			create Result.make_json ("feature")
		end

	Json_transitions: JSON_STRING
			-- JSON_STRING representing "transitions".
		once
			create Result.make_json ("transitions")
		end

	Json_pre_state_breakpoint: JSON_STRING
			-- JSON_STRING representing "pre_bp".
		once
			create Result.make_json ("pre_bp")
		end

	Json_pre_state_type: JSON_STRING
			-- JSON_STRING representing "pre_type".
		once
			create Result.make_json ("pre_type")
		end

	Json_pre_state_value: JSON_STRING
			-- JSON_STRING representing "pre_value".
		once
			create Result.make_json ("pre_value")
		end

	Json_pre_state_class_id: JSON_STRING
			-- JSON_STRING representing "pre_ref_class_id".
		once
			create Result.make_json ("pre_ref_class_id")
		end

	Json_pre_state_address: JSON_STRING
			-- JSON_STRING representing "pre_string_address".
		once
			create Result.make_json ("pre_string_address")
		end

	Json_post_state_breakpoint: JSON_STRING
			-- JSON_STRING representing "post_bp".
		once
			create Result.make_json ("post_bp")
		end

	Json_post_state_type: JSON_STRING
			-- JSON_STRING representing "post_type".
		once
			create Result.make_json ("post_type")
		end

	Json_post_state_value: JSON_STRING
			-- JSON_STRING representing "post_value".
		once
			create Result.make_json ("post_value")
		end

	Json_post_state_class_id: JSON_STRING
			-- JSON_STRING representing "post_ref_class_id".
		once
			create Result.make_json ("post_ref_class_id")
		end

	Json_post_state_address: JSON_STRING
			-- JSON_STRING representing "post_string_address".
		once
			create Result.make_json ("post_string_address")
		end

end
