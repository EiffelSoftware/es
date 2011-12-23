note
	description: "Class to read the collected runtime data from disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA_READER

inherit
	EPA_UTILITY

feature -- Basic operations

	read_from_path (a_path: STRING)
			-- Read the file specified by `a_path' and make result available
			-- in `last_data'.
		local
			l_reader: JSON_FILE_READER
			l_parser: JSON_PARSER
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_order: LINKED_LIST [TUPLE [INTEGER, INTEGER]]
			l_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
		do
			create l_reader
			create l_parser.make_parser (l_reader.read_json_from (a_path))
			check attached {JSON_OBJECT} l_parser.parse as l_json_object then
				-- Extract class
				l_class := first_class_starts_with_name (string_from_json (l_json_object.item ("class")))

				-- Extract feature
				l_feature := feature_from_class (l_class.name, string_from_json (l_json_object.item ("feature")))

				-- Extract execution order
				l_order := analysis_order_from_json (l_json_object.item ("execution_order"))

				-- Extract collected data
				l_data := data_from_json (l_json_object.item ("data"))
			end
			create last_data.make (l_class, l_feature, l_order, l_data)
		ensure
			last_data_not_void: last_data /= Void
		end

feature -- Access

	last_data: EPA_COLLECTED_RUNTIME_DATA
			-- Last read data.

feature {NONE} -- Implementation

	string_from_json (a_json_value: JSON_VALUE): STRING
			-- String contained in `a_json_value' if `a_json_value' is a JSON_STRING.
		require
			a_json_value_not_void: a_json_value /= Void
		do
			if attached {JSON_STRING} a_json_value as l_json_string then
				Result := l_json_string.item
			end
		ensure
			Result_not_void: Result /= Void
		end

	analysis_order_from_json (a_json_value: JSON_VALUE): LINKED_LIST [TUPLE [INTEGER, INTEGER]]
			-- List of pre-state / post-state pairs in the order they were analyzed
			-- if `a_json_value' is a JSON_ARRAY.
		require
			a_json_value_not_void: a_json_value /= Void
		local
			l_pre_post_bp: LIST [STRING]
			i: INTEGER
		do
			if attached {JSON_ARRAY} a_json_value as l_json_array then
				create Result.make
				from
					i := 1
				until
					i > l_json_array.count
				loop
					l_pre_post_bp := string_from_json (l_json_array.i_th (i)).split (';')
					Result.extend ([l_pre_post_bp.i_th (1).to_integer, l_pre_post_bp.i_th (2).to_integer])
					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	data_from_json (a_json_value: JSON_VALUE): DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			-- Runtime data collected through dynamic means if `a_json_value' is a JSON_OBJECT.
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.
		require
			a_json_value_not_void: a_json_value /= Void
		local
			i, j: INTEGER
			l_keys: ARRAY [JSON_STRING]
			l_values: LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]]
			l_value, l_type, l_class_id, l_bp_slot: STRING
			l_pre_pos_value, l_post_pos_value: EPA_POSITIONED_VALUE
		do
			if attached {JSON_OBJECT} a_json_value as l_json_map then
				-- Iterate over keys of the JSON object.
				create Result.make_default
				l_keys := l_json_map.current_keys
				from
					i := 1
				until
					i > l_keys.count
				loop
					if attached {JSON_ARRAY} l_json_map.item (l_keys.item (i)) as l_json_array then
						-- Iterate over the JSON array containing pre-state and post-state values.
						create l_values.make
						from
							j := 1
						until
							j > l_json_array.count
						loop
							if attached {JSON_OBJECT} l_json_array.i_th (j) as l_json_data then
								-- Extract pre-state and post-state values

								-- Extract pre-state value
								l_bp_slot := string_from_json (l_json_data.item (pre_bp_json_string))
								l_value := string_from_json (l_json_data.item (pre_value_json_string))
								l_type := string_from_json (l_json_data.item (pre_type_json_string))
								if l_type.is_equal ("EPA_REFERENCE_VALUE") then
									l_class_id := string_from_json (l_json_data.item (pre_ref_class_id_json_string))
									create l_pre_pos_value.make (l_bp_slot.to_integer, ref_value_from_data (l_value, l_class_id))
								else
									create l_pre_pos_value.make (l_bp_slot.to_integer, value_from_data (l_value, l_type))
								end

								-- Extract post-state value
								l_bp_slot := string_from_json (l_json_data.item (post_bp_json_string))
								l_value := string_from_json (l_json_data.item (post_value_json_string))
								l_type := string_from_json (l_json_data.item (post_type_json_string))
								if l_type.is_equal ("EPA_REFERENCE_VALUE") then
									l_class_id := string_from_json (l_json_data.item (post_ref_class_id_json_string))
									create l_post_pos_value.make (l_bp_slot.to_integer, ref_value_from_data (l_value, l_class_id))
								else
									create l_post_pos_value.make (l_bp_slot.to_integer, value_from_data (l_value, l_type))
								end
								l_values.extend ([l_pre_pos_value, l_post_pos_value])
							end
							j := j + 1
						end
					end
					Result.force_last (l_values, string_from_json (l_keys.item (i)))
					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	value_from_data (a_value: STRING; a_type: STRING): EPA_EXPRESSION_VALUE
			-- Value based on `a_type' with value `a_value'
		require
			a_value_not_void: a_value /= Void
			a_type_not_void: a_type /= Void
		do
			if a_type.is_equal ("EPA_BOOLEAN_VALUE") then
				create {EPA_BOOLEAN_VALUE} Result.make (a_value.to_boolean)
			elseif a_type.is_equal ("EPA_INTEGER_VALUE") then
				create {EPA_INTEGER_VALUE} Result.make (a_value.to_integer)
			elseif a_type.is_equal ("EPA_REAL_VALUE") then
				create {EPA_REAL_VALUE} Result.make (a_value.to_real)
			elseif a_type.is_equal ("EPA_POINTER_VALUE") then
				create {EPA_POINTER_VALUE} Result.make (a_value)
			elseif a_type.is_equal ("EPA_NONSENSICAL_VALUE") then
				create {EPA_NONSENSICAL_VALUE} Result
			elseif a_type.is_equal ("EPA_VOID_VALUE") then
				create {EPA_VOID_VALUE} Result.make
			elseif a_type.is_equal ("EPA_ANY_VALUE") then
				create {EPA_ANY_VALUE} Result.make (a_value)
			else
				check not_suported: False end
			end
		end

	ref_value_from_data (a_value: STRING; a_class_id: STRING): EPA_REFERENCE_VALUE
			-- Reference value from `a_value' and `a_class_id'
		require
			a_value_not_void: a_value /= Void
			a_class_id_not_void: a_class_id /= Void
		do
			create Result.make (a_value, create {CL_TYPE_A}.make (a_class_id.to_integer))
		end

feature {NONE} -- Implementation

	pre_bp_json_string: JSON_STRING
			-- JSON_STRING representing "pre_bp"
		once
			create {JSON_STRING} Result.make_json ("pre_bp")
		end

	pre_type_json_string: JSON_STRING
			-- JSON_STRING representing "pre_type"
		once
			create {JSON_STRING} Result.make_json ("pre_type")
		end

	pre_value_json_string: JSON_STRING
			-- JSON_STRING representing "pre_value"
		once
			create {JSON_STRING} Result.make_json ("pre_value")
		end

	pre_ref_class_id_json_string: JSON_STRING
			-- JSON_STRING representing "pre_ref_class_id"
		once
			create {JSON_STRING} Result.make_json ("pre_ref_class_id")
		end

	post_bp_json_string: JSON_STRING
			-- JSON_STRING representing "post_bp"
		once
			create {JSON_STRING} Result.make_json ("post_bp")
		end

	post_type_json_string: JSON_STRING
			-- JSON_STRING representing "post_type"
		once
			create {JSON_STRING} Result.make_json ("post_type")
		end

	post_value_json_string: JSON_STRING
			-- JSON_STRING representing "post_value"
		once
			create {JSON_STRING} Result.make_json ("post_value")
		end

	post_ref_class_id_json_string: JSON_STRING
			-- JSON_STRING representing "post_ref_class_id"
		once
			create {JSON_STRING} Result.make_json ("post_ref_class_id")
		end

end
