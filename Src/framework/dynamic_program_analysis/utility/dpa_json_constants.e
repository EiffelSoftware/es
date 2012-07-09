note
	description: "Summary description for {EPA_JSON_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_CONSTANTS

feature -- Access

	analysis_order_json_string: JSON_STRING
			-- JSON_STRING representing "analysis_order"
		once
			create Result.make_json ("analysis_order")
		end

	data_json_string: JSON_STRING
			-- JSON_STRING representing "data"
		once
			create Result.make_json ("data")
		end

	call_stack_count_json_string: JSON_STRING
			-- JSON_STRING representing "call_stack_count"
		once
			create Result.make_json ("call_stack_count")
		end

	pre_bp_json_string: JSON_STRING
			-- JSON_STRING representing "pre_bp"
		once
			create Result.make_json ("pre_bp")
		end

	pre_type_json_string: JSON_STRING
			-- JSON_STRING representing "pre_type"
		once
			create Result.make_json ("pre_type")
		end

	pre_value_json_string: JSON_STRING
			-- JSON_STRING representing "pre_value"
		once
			create Result.make_json ("pre_value")
		end

	pre_ref_class_id_json_string: JSON_STRING
			-- JSON_STRING representing "pre_ref_class_id"
		once
			create Result.make_json ("pre_ref_class_id")
		end

	pre_string_address_json_string: JSON_STRING
			-- JSON_STRING representing "pre_string_address"
		once
			create Result.make_json ("pre_string_address")
		end

	post_bp_json_string: JSON_STRING
			-- JSON_STRING representing "post_bp"
		once
			create Result.make_json ("post_bp")
		end

	post_type_json_string: JSON_STRING
			-- JSON_STRING representing "post_type"
		once
			create Result.make_json ("post_type")
		end

	post_value_json_string: JSON_STRING
			-- JSON_STRING representing "post_value"
		once
			create Result.make_json ("post_value")
		end

	post_ref_class_id_json_string: JSON_STRING
			-- JSON_STRING representing "post_ref_class_id"
		once
			create Result.make_json ("post_ref_class_id")
		end

	post_string_address_json_string: JSON_STRING
			-- JSON_STRING representing "post_string_address"
		once
			create Result.make_json ("post_string_address")
		end

end
