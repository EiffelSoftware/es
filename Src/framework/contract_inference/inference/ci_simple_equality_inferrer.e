note
	description: "Class to infer simple equality properties in form of p = q."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SIMPLE_EQUALITY_INFERRER

inherit
	CI_INFERRER
		redefine
			is_expression_value_map_needed
		end

	CI_SHARED_EQUALITY_TESTERS

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

			logger.put_line_with_time_at_fine_level ("Start inferring simple equality properties.")
			collect_potentially_equal_expressions
			generate_equality_candidates
			log_candidate_properties (candidate_properties, "Found the following candidate properties:")
			validate_candiate_properties (candidate_properties, operand_map_table, "Start validating simple equality properties.")
			log_candidate_properties (candidate_properties, "Found the following valid properties:")
			create function_to_postcondition_mapping.make (candidate_properties.count)
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

	pre_expression_value_table: DS_HASH_TABLE [DS_HASH_SET [STRING], CI_HASH_SET [EPA_EXPRESSION_VALUE]]
			-- Mapping from value set to expressions in prestate that have that value set
			-- Key is a value set, value is the list of expressions (in anonymous format) in prestate which have that value set.

	post_expression_value_table: DS_HASH_TABLE [DS_HASH_SET [STRING], CI_HASH_SET [EPA_EXPRESSION_VALUE]]
			-- Mapping from value set to expostssions in poststate that have that value set
			-- Key is a value set, value is the list of expressions (in anonymous format) in poststate which have that value set.

	left_expressions: DS_HASH_SET [STRING]
			-- Set of expressions (in anonymous format) used as left hand side of the equality

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

feature{NONE} -- Implementation

	generate_equality_candidates
			-- Generate equality candidates and store result in `equality_candidates'.
		local
			l_left_cur: DS_HASH_SET_CURSOR [STRING]
			l_left_expr: STRING
			l_equiv_set: like pre_expression_value_table
			l_set_cur: like post_expression_value_table.new_cursor
			l_values: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_set: DS_HASH_SET [STRING]
			l_expr_cur: DS_HASH_SET_CURSOR [STRING]
			l_candidate: STRING
			l_property: like candidate_property
			l_clauses: DS_HASH_SET [STRING]
			l_cand_cur: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_equality_candidates: DS_HASH_SET [STRING]
			l_changes: like data.interface_expression_changes
			l_temp: STRING
		do
			create candidate_properties.make (20)
			candidate_properties.set_equality_tester (function_equality_tester)

			create operand_map_table.make (100)
			operand_map_table.set_key_equality_tester (function_equality_tester)

			create l_equality_candidates.make (20)
			l_equality_candidates.set_equality_tester (string_equality_tester)

				-- Build equality candidate p = q where p is a left-hand-side expression and
				-- q is another expression in poststate.
			from
				l_left_cur := left_expressions.new_cursor
				l_left_cur.start
			until
				l_left_cur.after
			loop
				l_left_expr := l_left_cur.item
				from
					l_set_cur := post_expression_value_table.new_cursor
					l_set_cur.start
				until
					l_set_cur.after
				loop
					l_expr_set := l_set_cur.item
					l_values := l_set_cur.key
					if l_expr_set.has (l_left_expr) and then l_expr_set.count > 1 then
						from
							l_expr_cur := l_expr_set.new_cursor
							l_expr_cur.start
						until
							l_expr_cur.after
						loop
							if l_expr_cur.item /~ l_left_expr then
								create l_temp.make (128)
								l_temp.append (l_expr_cur.item)
								l_temp.append (" = (")
								l_temp.append (l_left_expr)
								l_temp.append_character (')')

								if not l_equality_candidates.has (l_temp) then
									create l_candidate.make (128)
									l_candidate.append (l_left_expr)
									l_candidate.append (" = (")
									l_candidate.append (l_expr_cur.item)
									l_candidate.append_character (')')
									l_equality_candidates.force_last (l_candidate)
								end
							end
							l_expr_cur.forth
						end
					end
					l_set_cur.forth
				end
				l_left_cur.forth
			end

				-- Build equality candidate p = old q where p is a left-hand-side expression and
				-- q is another expression in prestate.
			l_changes := data.interface_expression_changes
			from
				l_left_cur := left_expressions.new_cursor
				l_left_cur.start
			until
				l_left_cur.after
			loop
				l_left_expr := l_left_cur.item
				from
					l_set_cur := post_expression_value_table.new_cursor
					l_set_cur.start
				until
					l_set_cur.after
				loop
					l_expr_set := l_set_cur.item
					l_values := l_set_cur.key
					if l_expr_set.has (l_left_expr) then
						pre_expression_value_table.search (l_values)
						if pre_expression_value_table.found then
							l_expr_set := pre_expression_value_table.found_item
							from
								l_expr_cur := l_expr_set.new_cursor
								l_expr_cur.start
							until
								l_expr_cur.after
							loop
								if l_expr_cur.item /~ l_left_expr then
									l_changes.search (l_expr_cur.item)
									if l_changes.found and then l_changes.found_item then
										create l_candidate.make (128)
										l_candidate.append (l_left_expr)
										l_candidate.append (" = old (")
										l_candidate.append (l_expr_cur.item)
										l_candidate.append_character (')')
										l_equality_candidates.force_last (l_candidate)
									end
								end
								l_expr_cur.forth
							end
						end
					end
					l_set_cur.forth
				end
				l_left_cur.forth
			end

			from
				l_expr_cur := l_equality_candidates.new_cursor
				l_expr_cur.start
			until
				l_expr_cur.after
			loop
				create l_clauses.make (1)
				l_clauses.set_equality_tester (string_equality_tester)
				l_clauses.force_last (l_expr_cur.item)
				l_property := candidate_property (l_clauses, operand_string_table)
				candidate_properties.force_last (l_property.function)
				operand_map_table.force_last (l_property.operand_map, l_property.function)
				l_expr_cur.forth
			end
		end

	collect_potentially_equal_expressions
			-- Collect expressions that are potentially equal,
			-- store result in `left_expressions', `pre_expression_value_table' and `post_expression_value_table'.
		local
			l_expr: STRING
			l_post_values: like data.interface_post_expression_values
			l_values: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_empty_exprs, l_expr_set: DS_HASH_SET [STRING]
			l_equiv_set: like pre_expression_value_table
			l_expr_cur: DS_HASH_SET_CURSOR [STRING]
			l_equiv_cur: like pre_expression_value_table.new_cursor
			l_value_cur: DS_HASH_SET_CURSOR [EPA_EXPRESSION_VALUE]
		do
				-- Initialize data structures.
			create left_expressions.make (100)
			left_expressions.set_equality_tester (string_equality_tester)

			create pre_expression_value_table.make (100)
			pre_expression_value_table.set_key_equality_tester (ci_expression_value_hash_set_equality_tester)

			create post_expression_value_table.make (100)
			post_expression_value_table.set_key_equality_tester (ci_expression_value_hash_set_equality_tester)

				-- Iterate through all interface expressions and only
				-- select potentially changable ones.
			l_post_values := data.interface_post_expression_values
			across data.interface_expression_changes as l_changes loop
				if l_changes.item then
					l_expr := l_changes.key
					if not l_expr.has_substring ("~") and then not l_expr.has_substring ("=") then
						l_post_values.search (l_expr)
						if l_post_values.found and then l_post_values.found_item.count > 1 and then not l_post_values.found_item.there_exists (agent (a_v: EPA_EXPRESSION_VALUE): BOOLEAN do Result := a_v = Void or else a_v.is_nonsensical end) then
							l_values := l_post_values.found_item
							left_expressions.force_last (l_expr)
							post_expression_value_table.search (l_values)
							if post_expression_value_table.found then
								l_expr_set := post_expression_value_table.found_item
							else
								create l_expr_set.make (20)
								l_expr_set.set_equality_tester (string_equality_tester)
								post_expression_value_table.force_last (l_expr_set, l_values)
								create l_empty_exprs.make (20)
								l_empty_exprs.set_equality_tester (string_equality_tester)
								pre_expression_value_table.force_last (l_empty_exprs, l_values)
							end
							l_expr_set.force_last (l_expr)
						end
					end
				end
			end

				-- Collect expressions in both pre- and poststates which have the same set of values
				-- as the expressions in `left_expressions'.
			across data.interface_expression_values as l_states loop
				if l_states.key then
					l_equiv_set := pre_expression_value_table
				else
					l_equiv_set := post_expression_value_table
				end
				across l_states.item as l_value_map loop
					l_expr := l_value_map.key
					if not l_expr.has_substring ("~") and then not l_expr.has_substring ("=") then
						l_values := l_value_map.item
						l_equiv_set.search (l_values)
						if l_equiv_set.found then
							l_equiv_set.found_item.force_last (l_expr)
						end
					end
				end
			end

				-- Logging.
			logger.push_fine_level
			logger.put_line_with_time ("Found the following left-hand-side expressions:")
			from
				l_expr_cur := left_expressions.new_cursor
				l_expr_cur.start
			until
				l_expr_cur.after
			loop
				logger.put_line ("%T" + l_expr_cur.item)
				l_expr_cur.forth
			end

			across <<True, False>> as l_states loop
				if l_states.item then
					logger.put_line ("Prestate expressions with same value set:")
					l_equiv_cur := pre_expression_value_table.new_cursor
				else
					logger.put_line ("Poststate expressions with same value set:")
					l_equiv_cur := post_expression_value_table.new_cursor
				end

				from
					l_equiv_cur.start
				until
					l_equiv_cur.after
				loop
					l_expr_set := l_equiv_cur.item
					l_values := l_equiv_cur.key
					if not l_expr_set.is_empty then
						from
							l_expr_cur := l_expr_set.new_cursor
							l_expr_cur.start
						until
							l_expr_cur.after
						loop
							if l_expr_cur.is_last then
								logger.put_string (l_expr_cur.item)
							else
								logger.put_string (l_expr_cur.item + ", ")
							end
							l_expr_cur.forth
						end
						logger.put_string (" : {")
						from
							l_value_cur := l_values.new_cursor
							l_value_cur.start
						until
							l_value_cur.after
						loop
							if l_value_cur.is_last then
								logger.put_string (l_value_cur.item.text)
							else
								logger.put_string (l_value_cur.item.text + ", ")
							end
							l_value_cur.forth
						end
						logger.put_line ("}")
					end
					l_equiv_cur.forth
				end
			end
			logger.pop_level
		end

end
