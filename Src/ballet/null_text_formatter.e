indexing
	description: "A null text formatter"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_TEXT_FORMATTER

inherit
	TEXT_FORMATTER

feature -- Process

	process_address_text (a_address, a_name: STRING_8; a_class: CLASS_C) is
			-- Do nothing.
		do
		end

	process_after_class (a_class: CLASS_C) is
			-- Do nothing.
		do
		end

	process_basic_text (text: STRING_8) is
			-- Do nothing.
		do
		end

	process_before_class (a_class: CLASS_C) is
			-- Do nothing.
		do
		end

	process_breakpoint (a_feature: E_FEATURE; a_index: INTEGER_32) is
			-- Do nothing.
		do
		end

	process_breakpoint_index (a_feature: E_FEATURE; a_index: INTEGER_32; a_cond: BOOLEAN) is
			-- Do nothing.
		do
		end

	process_cl_syntax (text: STRING_8; a_syntax_message: ERROR; a_class: CLASS_C) is
			-- Do nothing.
		do
		end

	process_class_name_text (text: STRING_8; a_class: CLASS_I; a_quote: BOOLEAN) is
			-- Do nothing.
		do
		end

	process_cluster_name_text (text: STRING_8; a_cluster: CONF_GROUP; a_quote: BOOLEAN) is
			-- Do nothing.
		do
		end

	process_comment_text (text, url: STRING_8) is
			-- Do nothing.
		do
		end

	process_error_text (text: STRING_8; a_error: ERROR) is
			-- Do nothing.
		do
		end

	process_feature_name_text (text: STRING_8; a_class: CLASS_C) is
			-- Do nothing.
		do
		end

	process_feature_text (text: STRING_8; a_feature: E_FEATURE; a_quote: BOOLEAN) is
			-- Do nothing.
		do
		end

	process_filter_item (text: STRING_8; is_before: BOOLEAN) is
			-- Do nothing.
		do
		end

	process_indentation (a_indent_depth: INTEGER_32) is
			-- Do nothing.
		do
		end

	process_keyword_text (text: STRING_8; a_feature: E_FEATURE) is
			-- Do nothing.
		do
		end

	process_new_line is
			-- Do nothing.
		do
		end

	process_operator_text (text: STRING_8; a_feature: E_FEATURE) is
			-- Do nothing.
		do
		end

	process_padded is
			-- Do nothing.
		do
		end

	process_quoted_text (text: STRING_8) is
			-- Do nothing.
		do
		end

	process_symbol_text (text: STRING_8) is
			-- Do nothing.
		do
		end

	process_target_name_text (text: STRING_8; a_target: CONF_TARGET) is
			-- Do nothing.
		do
		end

end
