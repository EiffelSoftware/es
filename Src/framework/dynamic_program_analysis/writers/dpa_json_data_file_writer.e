note
	description: "Summary description for {EPA_JSON_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_JSON_DATA_FILE_WRITER

inherit
	DPA_DATA_FILE_WRITER

	DPA_JSON_CONSTANTS

feature {NONE} -- Implementation

	analysis_order_from_list (a_list: like analysis_order): JSON_ARRAY
			-- JSON array of pre-state / post-state pairs in the order they were analyzed.
		local
			l_object: JSON_OBJECT
			l_value, l_pre_bp_slot, l_post_bp_slot: STRING
			l_bp_slots: TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]
		do
			create Result.make_array
			from
				a_list.start
			until
				a_list.after
			loop
				l_bp_slots := a_list.item
				l_pre_bp_slot := l_bp_slots.pre_state_bp_slot.out
				l_post_bp_slot := l_bp_slots.post_state_bp_slot.out
				create l_value.make (l_pre_bp_slot.count + l_post_bp_slot.count + 1)
				l_value.append (l_pre_bp_slot)
				l_value.append_character (';')
				l_value.append (l_post_bp_slot)
				Result.add (json_string_from_string (l_value))
				a_list.forth
			end
		end

	json_object_from_runtime_data (a_collected_runtime_data: like collected_runtime_data): JSON_OBJECT
			-- Transform `a_collected_runtime_data' into a JSON object.
		require
			a_collected_runtime_data_not_void: a_collected_runtime_data /= Void
		local
			l_tuple: TUPLE [call_stack_count: INTEGER; pre_value: EPA_POSITIONED_VALUE; post_value: EPA_POSITIONED_VALUE]
			l_json_values: JSON_OBJECT
			l_json_array: JSON_ARRAY
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
		do
			create l_type_finder

			create Result.make

			-- Iterate over keys.
			across a_collected_runtime_data.keys.to_array as l_keys loop
				create l_json_array.make_array
				-- Iterate over values.
				across a_collected_runtime_data.item (l_keys.item) as l_values loop
					l_tuple := l_values.item

					create l_json_values.make

					-- Pre-state value
					l_type_finder.set_value (l_tuple.pre_value.value)
					l_type_finder.find
					l_json_values.put (json_string_from_string (l_type_finder.type), pre_type_json_string)
					l_json_values.put (json_string_from_string (l_tuple.pre_value.value.text), pre_value_json_string)
					l_json_values.put (json_string_from_string (l_tuple.pre_value.bp_slot.out), pre_bp_json_string)
					if l_type_finder.type.is_equal (reference_value) then
						if attached {CL_TYPE_A} l_tuple.pre_value.value.type as l_type then
							l_json_values.put (json_string_from_string (l_type.class_id.out), pre_ref_class_id_json_string)
						end
					end
					if l_type_finder.type.is_equal (string_value) then
						l_json_values.put (json_string_from_string (l_tuple.pre_value.value.item.out), pre_string_address_json_string)
					end

					-- Post-state value
					l_type_finder.set_value (l_tuple.post_value.value)
					l_type_finder.find
					l_json_values.put (json_string_from_string (l_type_finder.type), post_type_json_string)
					l_json_values.put (json_string_from_string (l_tuple.post_value.value.text), post_value_json_string)
					l_json_values.put (json_string_from_string (l_tuple.post_value.bp_slot.out), post_bp_json_string)
					if l_type_finder.type.is_equal (reference_value) then
						if attached {CL_TYPE_A} l_tuple.post_value.value.type as l_type then
							l_json_values.put (json_string_from_string (l_type.class_id.out), post_ref_class_id_json_string)
						end
					end
					if l_type_finder.type.is_equal (string_value) then
						l_json_values.put (json_string_from_string (l_tuple.post_value.value.item.out), post_string_address_json_string)
					end
					l_json_values.put (json_string_from_string (l_tuple.call_stack_count.out), call_stack_count_json_string)

					l_json_array.add (l_json_values)
				end
				Result.put (l_json_array, json_string_from_string (l_keys.item))
			end
		end

feature {NONE} -- Implementation

	json_string_from_string (a_string: STRING): JSON_STRING
			-- JSON_STRING representing `a_string'
		require
			a_string_not_void: a_string /= Void
		do
			Result := create {JSON_STRING}.make_json (a_string)
		ensure
			Result_not_void: Result /= Void
		end

end
