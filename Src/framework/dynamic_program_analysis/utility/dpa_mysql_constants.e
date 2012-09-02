note
	description: "Summary description for {DPA_MYSQL_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_CONSTANTS

feature -- Access

	analysis_order_pairs_table_name: STRING = "analysis_order_pairs"
			-- Name of the analysis order pairs table.

	aop_counter_attribute_name: STRING = "counter"
			-- Name of the counter attribute of the analysis order pairs table.

	aop_counter_attribute_column_number: INTEGER = 1
			-- Column of the counter attribute of the analysis order pairs table.

	aop_pre_state_bp_attribute_name: STRING = "pre_state_bp"
			-- Name of the pre-state breakpoint attribute of the analysis order pairs table.

	aop_pre_state_bp_attribute_column_number: INTEGER = 2
			-- Column of the pre-state breakpoint attribute of the analysis order pairs table.

	aop_post_state_bp_attribute_name: STRING = "post_state_bp"
			-- Name of the post-state breakpoint attribute of the analysis order pairs table.

	aop_post_state_bp_attribute_column_number: INTEGER = 3
			-- Column of the post-state breakpoint attribute of the analysis order pairs table.

	expression_value_transitions_table_name: STRING = "expression_value_transitions"
			-- Name of the expression value transition table.

	evt_counter_attribute_name: STRING = "counter"
			-- Name of the counter attribute of the expression value transition table.

	evt_counter_attribute_column_number: INTEGER = 1
			-- Column of the counter attribute of the expression value transition table.

	evt_class_attribute_name: STRING = "class"
			-- Name of the class attribute of the expression value transition table.

	evt_class_attribute_column_number: INTEGER = 2
			-- Column of the class attribute of the expression value transition table.

	evt_feature_attribute_name: STRING = "feature"
			-- Name of the feature attribute of the expression value transition table.

	evt_feature_attribute_column_number: INTEGER = 3
			-- Column of the feature attribute of the expression value transition table.

	evt_expression_attribute_name: STRING = "expression"
			-- Name of the expression attribute of the expression value transition table.

	evt_expression_attribute_column_number: INTEGER = 4
			-- Column of the expression attribute of the expression value transition table.

	evt_location_expression_occurrence_attribute_name: STRING = "location_expression_occurrence"
			-- Name of the location expression occurrence attribute of the expression value transition table.

	evt_location_expression_occurrence_attribute_column_number: INTEGER = 5
			-- Column of the location expression occurrence attribute of the expression value transition table.

	evt_pre_state_bp_attribute_name: STRING = "pre_state_bp"
			-- Name of the pre-state breakpoint attribute of the expression value transition table.

	evt_pre_state_bp_attribute_column_number: INTEGER = 6
			-- Column of the pre-state breakpoint attribute of the expression value transition table.

	evt_pre_state_type_attribute_name: STRING = "pre_state_type"
			-- Name of the pre-state type attribute of the expression value transition table.

	evt_pre_state_type_attribute_column_number: INTEGER = 7
			-- Column of the pre-state type attribute of the expression value transition table.

	evt_pre_state_type_information_attribute_name: STRING = "pre_state_type_information"
			-- Name of the pre-state type information attribute of the expression value transition table.

	evt_pre_state_type_information_attribute_column_number: INTEGER = 8
			-- Column of the pre-state type information attribute of the expression value transition table.

	evt_pre_state_value_attribute_name: STRING = "pre_state_value"
			-- Name of the pre-state value attribute of the expression value transition table.

	evt_pre_state_value_attribute_column_number: INTEGER = 9
			-- Column of the pre-state value attribute of the expression value transition table.

	evt_post_state_bp_attribute_name: STRING = "post_state_bp"
			-- Name of the post-state breakpoint attribute of the expression value transition table.

	evt_post_state_bp_attribute_column_number: INTEGER = 10
			-- Column of the post-state breakpoint attribute of the expression value transition table.

	evt_post_state_type_attribute_name: STRING = "post_state_type"
			-- Name of the post-state type attribute of the expression value transition table.

	evt_post_state_type_attribute_column_number: INTEGER = 11
			-- Column of the post-state type attribute of the expression value transition table.

	evt_post_state_type_information_attribute_name: STRING = "post_state_type_information"
			-- Name of the post-state type information attribute of the expression value transition table.

	evt_post_state_type_information_attribute_column_number: INTEGER = 12
			-- Column of the post-state type information attribute of the expression value transition table.

	evt_post_state_value_attribute_name: STRING = "post_state_value"
			-- Name of the post-state value attribute of the expression value transition table.

	evt_post_state_value_attribute_column_number: INTEGER = 13
			-- Column of the post-state value attribute of the expression value transition table.

end
