note
	description: "Summary description for {DPA_MYSQL_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_CONSTANTS

feature -- Access

	analysis_order_pairs_table_name: STRING = "analysis_order_pairs"
			--

	aop_counter_attribute_name: STRING = "counter"
			--

	aop_counter_attribute_column_number: INTEGER = 1
			--

	aop_pre_state_bp_attribute_name: STRING = "pre_state_bp"
			--

	aop_pre_state_bp_attribute_column_number: INTEGER = 2
			--

	aop_post_state_bp_attribute_name: STRING = "post_state_bp"
			--

	aop_post_state_bp_attribute_column_number: INTEGER = 3
			--

	expression_value_transitions_table_name: STRING = "expression_value_transitions"
			--

	evt_counter_attribute_name: STRING = "counter"
			--

	evt_counter_attribute_column_number: INTEGER = 1
			--

	evt_round_attribute_name: STRING = "round"
			--

	evt_round_attribute_column_number: INTEGER = 2
			--

	evt_class_attribute_name: STRING = "class"
			--

	evt_class_attribute_column_number: INTEGER = 3
			--

	evt_feature_attribute_name: STRING = "feature"
			--

	evt_feature_attribute_column_number: INTEGER = 4
			--

	evt_expression_attribute_name: STRING = "expression"
			--

	evt_expression_attribute_column_number: INTEGER = 5
			--

	evt_location_expression_occurrence_attribute_name: STRING = "location_expression_occurrence"
			--

	evt_location_expression_occurrence_attribute_column_number: INTEGER = 6
			--

	evt_pre_state_bp_attribute_name: STRING = "pre_state_bp"
			--

	evt_pre_state_bp_attribute_column_number: INTEGER = 7
			--

	evt_pre_state_type_attribute_name: STRING = "pre_state_type"
			--

	evt_pre_state_type_attribute_column_number: INTEGER = 8
			--

	evt_pre_state_type_information_attribute_name: STRING = "pre_state_type_information"
			--

	evt_pre_state_type_information_attribute_column_number: INTEGER = 9
			--

	evt_pre_state_value_attribute_name: STRING = "pre_state_value"
			--

	evt_pre_state_value_attribute_column_number: INTEGER = 10
			--

	evt_post_state_bp_attribute_name: STRING = "post_state_bp"
			--

	evt_post_state_bp_attribute_column_number: INTEGER = 11
			--

	evt_post_state_type_attribute_name: STRING = "post_state_type"
			--

	evt_post_state_type_attribute_column_number: INTEGER = 12
			--

	evt_post_state_type_information_attribute_name: STRING = "post_state_type_information"
			--

	evt_post_state_type_information_attribute_column_number: INTEGER = 13
			--

	evt_post_state_value_attribute_name: STRING = "post_state_value"
			--

	evt_post_state_value_attribute_column_number: INTEGER = 14
			--

end
