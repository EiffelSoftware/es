note
	description: "Contract inferrer based on data mining techniques"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_DATA_MINING_BASED_INFERRER

inherit
	CI_INFERRER

feature{NONE} -- Implementation

	arff_relation: WEKA_ARFF_RELATION
			-- ARFF relation

	value_sets: DS_HASH_TABLE [DS_HASH_SET [STRING_8], WEKA_ARFF_ATTRIBUTE]
			-- Table from attribute to values of that attributes in all instances
			-- Key is an attribute, value is the set of values that attribute have across all instances.

feature{NONE} -- Implementation

	expression_from_anonymous_form (a_text: STRING; a_feature: FEATURE_I; a_class: CLASS_C): STRING
			-- Expression from `a_text' with anonymous operands replaced with real operands of `a_feature' in `a_class'
		local
			l_opd_names: like operand_name_index_with_feature
		do
			l_opd_names := operand_name_index_with_feature (a_feature, a_class)
			create Result.make (a_text.count + 20)
			Result.append (a_text)
			across l_opd_names as l_names loop
				Result.replace_substring_all (curly_brace_surrounded_integer (l_names.key), l_names.item)
			end
		end

feature{NONE} -- Logging

	log_inferred_contracts (a_message: STRING; a_contracts: DS_HASH_SET [EPA_EXPRESSION])
			-- Log inferred implications.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			logger.push_info_level
			logger.put_line_with_time (a_message)
			from
				l_cursor := a_contracts.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%T" + l_cursor.item.text)
				l_cursor.forth
			end
			logger.pop_level
		end

end
