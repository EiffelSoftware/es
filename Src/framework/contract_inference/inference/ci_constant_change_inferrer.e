note
	description: "Class to infer properties describing that some expression is changed to a constant"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_CONSTANT_CHANGE_INFERRER

inherit
	CI_INFERRER
		redefine
			is_expression_value_map_needed
		end

	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Status report

	is_expression_value_map_needed: BOOLEAN = True
			-- Is expression to its value set mapping needed?

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- Initialize.
			data := a_data
			setup_data_structures
			operand_string_table := operand_string_table_for_feature (feature_under_test)

			logger.put_line_with_time_and_level ("Start inferring constant-change properties.", {ELOG_CONSTANTS}.debug_level)

			collect_single_change_expressions
			generate_equality_candidates
			log_candidate_properties (candidate_properties, "Found the following constant-change properties:")
			validate_candiate_properties (candidate_properties, operand_map_table, "Start validating constant-change properties.")
			log_candidate_properties (candidate_properties, "Found the following valid constant-change properties:")
			create function_to_postcondition_mapping.make (20)
			function_to_postcondition_mapping.set_key_equality_tester (function_equality_tester)


				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_inferred_contracts_in_last_postconditions (candidate_properties, operand_map_table, agent function_to_postcondition_mapping.force_last)
			setup_last_contracts
		end

feature -- Access

	function_to_postcondition_mapping: DS_HASH_TABLE [EPA_EXPRESSION, EPA_FUNCTION]
			-- Mapping from functions to postconditions

feature{NONE} -- Implementation

	candidate_properties: EPA_HASH_SET [EPA_FUNCTION]
			-- Candidate properties

	operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
			-- Operand map of properties in `candidate_properties'
			-- Key of the outer table is a candidate property in `candidate_properties'.
			-- Key of the inner table is 1-based argument index of the function,
			-- value of the inner table is the 0-based operand index in `feature_under_test'.

	operand_string_table: HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand index to curly brace surrounded indexes for `feature_under_test'	
			-- 0 -> {0}, 1 -> {1} and so on.

	single_change_expressions: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			-- Potentially changable expressions that have only a single value.
			-- Key is the expression name (in anonymous format), value is the single value that expression is changed to.

feature{NONE} -- Implementation

	collect_single_change_expressions
			-- Collect potentially changable expressions that have only a single value,
			-- store result in `single_change_expressions'.
		local
			l_expr: STRING
			l_post_values: like data.interface_post_expression_values
		do
			create single_change_expressions.make (20)
			single_change_expressions.compare_objects

			l_post_values := data.interface_post_expression_values
			across data.interface_expression_changes as l_changes loop
				if l_changes.item then
					l_expr := l_changes.key
					l_post_values.search (l_expr)
					if l_post_values.found and then l_post_values.found_item.count = 1 and then not l_post_values.found_item.first.is_nonsensical then
						single_change_expressions.put (l_post_values.found_item.first, l_expr)
					end
				end
			end
		end

	generate_equality_candidates
			-- Generate equality candidates and store result in `equality_candidates'.
		local
			l_left_cur: DS_HASH_SET_CURSOR [STRING]
			l_left_expr: STRING
			l_values: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_set: DS_HASH_SET [STRING]
			l_expr_cur: DS_HASH_SET_CURSOR [STRING]
			l_candidate: STRING
			l_property: like candidate_property
			l_clauses: DS_HASH_SET [STRING]
			l_cand_cur: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_equality_candidates: DS_HASH_SET [STRING]
			l_temp: STRING
			l_expr: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_property_body: STRING
		do
			create candidate_properties.make (20)
			candidate_properties.set_equality_tester (function_equality_tester)

			create operand_map_table.make (100)
			operand_map_table.set_key_equality_tester (function_equality_tester)

			create l_equality_candidates.make (20)
			l_equality_candidates.set_equality_tester (string_equality_tester)

				-- Iterate through all single-change expressions and generate
				-- candidate properties in form of exp = value.
			across single_change_expressions as l_exprs loop
				l_expr := l_exprs.key
				l_value := l_exprs.item
				create l_clauses.make (1)
				l_clauses.set_equality_tester (string_equality_tester)
				create l_property_body.make (128)
				if l_expr.has_substring (" ") then
					l_property_body.append_character ('(')
					l_property_body.append (l_expr)
					l_property_body.append_character (')')
				else
					l_property_body.append (l_expr)
				end
				l_property_body.append (" = ")
				l_property_body.append (l_value.text)
				l_clauses.force_last (l_property_body)
				l_property := candidate_property (l_clauses, operand_string_table)
				candidate_properties.force_last (l_property.function)
				operand_map_table.force_last (l_property.operand_map, l_property.function)
			end
		end


end
