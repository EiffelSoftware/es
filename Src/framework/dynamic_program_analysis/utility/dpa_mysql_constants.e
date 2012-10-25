note
	description: "MYSQL constants used by the MYSQL writer and reader."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MYSQL_CONSTANTS

feature -- Access

	Mysql_transitions_table_name: STRING = "transitions"
			-- Name of the transition table.

	Mysql_counter_name: STRING = "counter"
			-- Name of the counter attribute in the transition table.

	Mysql_counter_column: INTEGER = 1
			-- Column of the counter attribute in the transition table.

	Mysql_class_name: STRING = "class"
			-- Name of the class attribute in the transition table.

	Mysql_class_column: INTEGER = 2
			-- Column of the class attribute in the transition table.

	Mysql_feature_name: STRING = "feature"
			-- Name of the feature attribute in the transition table.

	Mysql_feature_column: INTEGER = 3
			-- Column of the feature attribute in the transition table.

	Mysql_expression_name: STRING = "expression"
			-- Name of the expression attribute in the transition table.

	Mysql_expression_column: INTEGER = 4
			-- Column of the expression attribute in the transition table.

	Mysql_localized_expression_occurrences_name: STRING = "localized_expression_occurrences"
			-- Name of the localized expression occurrences attribute in the transition table.

	Mysql_localized_expression_occurrences_column: INTEGER = 5
			-- Column of the localized expression occurrence attribute in the transition table.

	Mysql_pre_state_breakpoint_name: STRING = "pre_state_breakpoint"
			-- Name of the pre-state breakpoint attribute in the transition table.

	Mysql_pre_state_breakpoint_column: INTEGER = 6
			-- Column of the pre-state breakpoint attribute in the transition table.

	Mysql_pre_state_type_name: STRING = "pre_state_type"
			-- Name of the pre-state type attribute in the transition table.

	Mysql_pre_state_type_column: INTEGER = 7
			-- Column of the pre-state type attribute in the transition table.

	Mysql_pre_state_type_information_name: STRING = "pre_state_type_information"
			-- Name of the pre-state type information attribute in the transition table.

	Mysql_pre_state_type_information_column: INTEGER = 8
			-- Column of the pre-state type information attribute in the transition table.

	Mysql_pre_state_value_name: STRING = "pre_state_value"
			-- Name of the pre-state value attribute in the transition table.

	Mysql_pre_state_value_column: INTEGER = 9
			-- Column of the pre-state value attribute in the transition table.

	Mysql_post_state_breakpoint_name: STRING = "post_state_breakpoint"
			-- Name of the post-state breakpoint attribute in the transition table.

	Mysql_post_state_breakpoint_column: INTEGER = 10
			-- Column of the post-state breakpoint attribute in the transition table.

	Mysql_post_state_type_name: STRING = "post_state_type"
			-- Name of the post-state type attribute in the transition table.

	Mysql_post_state_type_column: INTEGER = 11
			-- Column of the post-state type attribute in the transition table.

	Mysql_post_state_type_information_name: STRING = "post_state_type_information"
			-- Name of the post-state type information attribute in the transition table.

	Mysql_post_state_type_information_column: INTEGER = 12
			-- Column of the post-state type information attribute in the transition table.

	Mysql_post_state_value_name: STRING = "post_state_value"
			-- Name of the post-state value attribute in the transition table.

	Mysql_post_state_value_column: INTEGER = 13
			-- Column of the post-state value attribute in the transition table.

end
