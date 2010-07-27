note
	description: "Class to infer equation-based properties"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_EQUATION_BASED_INFERRER

inherit
	CI_INFERRER
		redefine
			is_expression_value_map_needed
		end


feature -- Status report

	is_expression_value_map_needed: BOOLEAN = True
			-- Is expression to its value set mapping needed?

feature -- Basic operation

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- Initialize.
			data := a_data
			setup_data_structures

			setup_inferrers
			infer_properties
--			operand_string_table := operand_string_table_for_feature (feature_under_test)

--			logger.put_line_with_time_at_fine_level ("Start inferring simple equality properties.")
--			collect_potentially_equal_expressions
--			generate_equality_candidates
--			log_candidate_properties (candidate_properties, "Found the following candidate properties:")
--			validate_candiate_properties (candidate_properties, operand_map_table, "Start validating simple equality properties.")
--			log_candidate_properties (candidate_properties, "Found the following valid properties:")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
--			setup_inferred_contracts_in_last_postconditions (candidate_properties, operand_map_table)
			setup_last_contracts
		end

feature{NONE} -- Implementation

	simple_equality_inferrer: CI_SIMPLE_EQUALITY_INFERRER
			-- Inferrer for simple equality properties

	constant_change_inferrer: CI_CONSTANT_CHANGE_INFERRER
			-- Inferrer for constant-change properties

	constant_change_properties: DS_HASH_SET [EPA_EXPRESSION]
			-- Inferred constant-change properties

	simple_equality_properties: DS_HASH_SET [EPA_EXPRESSION]
			-- Inferred simple-equality properties

feature{NONE} -- Implementation

	setup_inferrers
			-- Setup inferrers.
		do
			create simple_equality_inferrer
			simple_equality_inferrer.set_config (config)
			simple_equality_inferrer.set_logger (logger)

			create constant_change_inferrer
			constant_change_inferrer.set_config (config)
			constant_change_inferrer.set_logger (logger)
		end

	infer_properties
			-- Infer properties using `simple_equality_inferrer' and `constant_change_inferrer'.
			-- Store result in `simple_equality_properties' and `constant_change_properties'.
		local
			l_map, l_simple: DS_HASH_TABLE [EPA_EXPRESSION, EPA_FUNCTION]
			l_equation: DS_HASH_TABLE [EPA_EXPRESSION, EPA_FUNCTION]
			l_arg_indexes: DS_HASH_SET [STRING]
			l_cursor: DS_HASH_TABLE_CURSOR [EPA_EXPRESSION, EPA_FUNCTION]
			l_properties: LINKED_LIST [EPA_EXPRESSION]
		do
			create simple_equality_properties.make (10)
			simple_equality_properties.set_equality_tester (expression_equality_tester)

			create constant_change_properties.make (10)
			constant_change_properties.set_equality_tester (expression_equality_tester)

			simple_equality_inferrer.infer (data)
			l_simple := simple_equality_inferrer.function_to_postcondition_mapping.cloned_object

			constant_change_inferrer.infer (data)
			l_equation := constant_change_inferrer.function_to_postcondition_mapping.cloned_object

			create l_arg_indexes.make (10)
			l_arg_indexes.set_equality_tester (string_equality_tester)
			across operand_index_set (feature_under_test, False, False) as l_indexes loop
				l_arg_indexes.force_last (curly_brace_surrounded_integer (l_indexes.item))
			end

				-- Keep properties that do not mention arguments of `feature_under_test',
				-- store them in `l_properties'.
			create l_properties.make
			across <<l_simple, l_equation>> as l_mappings loop
				l_map := l_mappings.item
				from
					l_cursor := l_map.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					if l_arg_indexes.there_exists (
						agent (a_index: STRING; a_prop: EPA_FUNCTION): BOOLEAN
							do
								Result := a_prop.body.has_substring (a_index)
							end (?, l_cursor.key))
					then
						l_map.remove (l_cursor.key)
					else
						l_properties.extend (l_cursor.item)
						l_cursor.forth
					end
				end
			end


		end

end
