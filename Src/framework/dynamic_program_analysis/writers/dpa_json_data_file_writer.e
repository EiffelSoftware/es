note
	description: "A writer that writes the data from a dynamic program analysis to disk using one or multiple JSON files."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_JSON_DATA_FILE_WRITER

inherit
	DPA_DATA_FILE_WRITER

	DPA_JSON_CONSTANTS

	DPA_JSON_UTILITY

feature {NONE} -- Implementation

	json_analysis_order_pairs: JSON_ARRAY
			-- JSON representation of analysis order pairs.

	json_expression_value_transitions: JSON_OBJECT
			-- JSON representation of expression value transitions.

feature {NONE} -- Implementation

	update_json_analysis_order_pairs
			--
		local
			l_object: JSON_OBJECT
			l_pre_bp_slot, l_post_bp_slot: INTEGER
			l_bp_slots: TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]
		do
			from
				analysis_order_pairs.start
			until
				analysis_order_pairs.after
			loop
				l_bp_slots := analysis_order_pairs.item
				l_pre_bp_slot := l_bp_slots.pre_state_bp_slot
				l_post_bp_slot := l_bp_slots.post_state_bp_slot
				create l_object.make

				l_object.put (json_string_from_string (l_pre_bp_slot.out), pre_bp_json_string)

				l_object.put (json_string_from_string (l_post_bp_slot.out), post_bp_json_string)

				json_analysis_order_pairs.add (l_object)
				analysis_order_pairs.forth
			end
			create analysis_order_pairs.make
		end

	update_json_expression_value_transitions
			--
		local
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_loc_expr: STRING
			l_json_loc_expr: JSON_STRING
			l_value: JSON_OBJECT
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
			l_values: JSON_ARRAY
		do
			create l_type_finder

			from
				expression_value_transitions.start
			until
				expression_value_transitions.after
			loop
				l_transition := expression_value_transitions.item_for_iteration

				create l_value.make

				l_loc_expr := l_transition.pre_state_bp.out + ";" + l_transition.expression.text

				l_json_loc_expr := json_string_from_string (l_loc_expr)

				-- Pre-state value
				l_type_finder.set_value (l_transition.pre_state_value)
				l_type_finder.find
				l_value.put (json_string_from_string (l_transition.pre_state_bp.out), pre_bp_json_string)
				l_value.put (json_string_from_string (l_type_finder.type), pre_type_json_string)
				l_value.put (json_string_from_string (l_transition.pre_state_value.text), pre_value_json_string)
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.pre_state_value.type as l_type then
						l_value.put (json_string_from_string (l_type.class_id.out), pre_ref_class_id_json_string)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					l_value.put (json_string_from_string (l_transition.pre_state_value.item.out), pre_string_address_json_string)
				end

				-- Post-state value
				l_type_finder.set_value (l_transition.post_state_value)
				l_type_finder.find
				l_value.put (json_string_from_string (l_transition.post_state_bp.out), post_bp_json_string)
				l_value.put (json_string_from_string (l_type_finder.type), post_type_json_string)
				l_value.put (json_string_from_string (l_transition.post_state_value.text), post_value_json_string)
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.post_state_value.type as l_type then
						l_value.put (json_string_from_string (l_type.class_id.out), post_ref_class_id_json_string)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					l_value.put (json_string_from_string (l_transition.post_state_value.item.out), post_string_address_json_string)
				end

				if json_expression_value_transitions.has_key (l_json_loc_expr) then
					if attached {JSON_ARRAY} json_expression_value_transitions.item (l_json_loc_expr) as l_existing_values then
						l_existing_values.add (l_value)
					end
				else
					create l_values.make_array
					l_values.add (l_value)
					json_expression_value_transitions.put (l_values, l_json_loc_expr)
				end
				expression_value_transitions.forth
			end
			create expression_value_transitions.make
		end

end
