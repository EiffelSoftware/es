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

			logger.put_line_with_time_and_level ("Start inferring simple equality properties.", {ELOG_CONSTANTS}.debug_level)

			generate_equality_candidates
			log_candidate_properties (candidate_pre_properties,  "Found the following candidate properties for pre:")
			log_candidate_properties (candidate_post_properties, "Found the following candidate properties for post:")

			validate
			log_candidate_properties (candidate_pre_properties,  "Found the following valid properties for pre:")
			log_candidate_properties (candidate_post_properties, "Found the following valid properties for post:")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)

			create function_to_postcondition_mapping.make (candidate_post_properties.count)
			function_to_postcondition_mapping.set_key_equality_tester (function_equality_tester)
			setup_inferred_contracts_in_last_postconditions (candidate_post_properties, post_properties_operand_map_table, agent function_to_postcondition_mapping.force_last)
			setup_last_contracts
		end

feature -- Access

	function_to_postcondition_mapping: DS_HASH_TABLE [EPA_EXPRESSION, EPA_FUNCTION]
			-- Mapping from functions to postconditions

feature{NONE} -- Implementation

	pre_expression_value_table: DS_HASH_TABLE [DS_HASH_SET [STRING], CI_HASH_SET [EPA_EXPRESSION_VALUE]]
			-- Mapping from value set to expressions in prestate that have that value set
			-- Key is a value set, value is the list of expressions (in anonymous format) in prestate which have that value set.
			--
			-- The key value sets include only the value sets of expressions changed by the transition.
			-- This table is used for constructing `candidate_post_properties'.

	post_expression_value_table: DS_HASH_TABLE [DS_HASH_SET [STRING], CI_HASH_SET [EPA_EXPRESSION_VALUE]]
			-- Mapping from value set to expostssions in poststate that have that value set
			-- Key is a value set, value is the list of expressions (in anonymous format) in poststate which have that value set.
			--
			-- The key value sets include only the value sets of expressions changed by the transition.
			-- This table is used for constructing `candidate_post_properties'.

	left_expressions_for_post: DS_HASH_SET [STRING]
			-- Set of expressions (in anonymous format) used in post expressions as left hand side of the equality.

	equivalent_expressions_for_pre: ARRAYED_LIST [EPA_HASH_SET [STRING]]
			-- List of sets of equivalent expressions in the pre state.

	candidate_properties (a_pre: BOOLEAN): EPA_HASH_SET [EPA_FUNCTION]
			-- Candidate properties.
			-- Pre properties if `a_pre'; Post properties otherwise.
		do
			if a_pre then
				Result := candidate_pre_properties
			else
				Result := candidate_post_properties
			end
		end

	operand_map_table (a_pre: BOOLEAN): DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
			-- Operand map table.
			-- For pre properties if `a_pre'; for post properties otherwise.
		do
			if a_pre then
				Result := pre_properties_operand_map_table
			else
				Result := post_properties_operand_map_table
			end
		end

	operand_string_table: HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand index to curly brace surrounded indexes for `feature_under_test'	
			-- 0 -> {0}, 1 -> {1} and so on.					

	candidate_post_properties: EPA_HASH_SET [EPA_FUNCTION]
			-- Candidate post properties.

	candidate_pre_properties: EPA_HASH_SET [EPA_FUNCTION]
			-- Candidate pre properties.

	post_properties_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
			-- Operand map of properties in `candidate_post_properties'
			-- Key of the outer table is a candidate property in `candidate_post_properties'.
			-- Key of the inner table is 1-based argument index of the function,
			-- value of the inner table is the 0-based operand index in `feature_under_test'.

	pre_properties_operand_map_table: DS_HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], EPA_FUNCTION]
			-- Operand map of properties in `candidate_pre_properties'.
			-- Key of the outer table is a candidate property in `candidate_pre_properties'.
			-- Key of the inner table is 1-based argument index of the function,
			-- value of the inner table is the 0-based operand index in `feature_under_test'.

feature{NONE} -- Implementation

	generate_equality_candidates
			-- Generate equality candidates and store result in `equality_candidates'.
		do
			initialize_implementation_data_structures

			collect_potentially_equal_expressions_for_pre
			generate_equality_candidates_for_pre

			collect_potentially_equal_expressions_for_post
			generate_equality_candidates_for_post
		end

	validate
			-- Validate equality candidates.
		do
			validate_candidate_properties (True,  candidate_pre_properties,  pre_properties_operand_map_table,  "Start validating simple equality properties for pre.")
			validate_candidate_properties (False, candidate_post_properties, post_properties_operand_map_table, "Start validating simple equality properties for post.")
		end

	initialize_implementation_data_structures
			-- Initialize required data structures.
		do
				-- For collecting potentially equal expressions.
			create pre_expression_value_table.make (100)
			pre_expression_value_table.set_key_equality_tester (ci_expression_value_hash_set_equality_tester)

			create post_expression_value_table.make (100)
			post_expression_value_table.set_key_equality_tester (ci_expression_value_hash_set_equality_tester)

			create left_expressions_for_post.make (100)
			left_expressions_for_post.set_equality_tester (string_equality_tester)

			create equivalent_expressions_for_pre.make (10)

				-- For candidate expressions.
			create candidate_post_properties.make (20)
			candidate_post_properties.set_equality_tester (function_equality_tester)

			create candidate_pre_properties.make (20)
			candidate_pre_properties.set_equality_tester (function_equality_tester)

			create post_properties_operand_map_table.make (100)
			post_properties_operand_map_table.set_key_equality_tester (function_equality_tester)

			create pre_properties_operand_map_table.make (100)
			pre_properties_operand_map_table.set_key_equality_tester (function_equality_tester)
		end

	collect_potentially_equal_expressions_for_pre
			-- Collect expressions that are potentially equal in the pre state,
			-- store result in `equivalent_expressions_for_pre'.
		local
			l_pre_values: like data.interface_pre_expression_values
			l_pre_expressions: like data.interface_pre_expressions
			l_expr_str: STRING
			l_expr_value_set: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_str_set: EPA_HASH_SET[STRING]
			l_partition: HASH_TABLE [EPA_HASH_SET[STRING], CI_HASH_SET [EPA_EXPRESSION_VALUE]]
		do
			l_pre_values := data.interface_pre_expression_values
			l_pre_expressions := data.interface_pre_expressions
			create l_partition.make_equal (30)

				-- Group pre expressions according to their value set.
			across l_pre_expressions as li_expression loop
				l_expr_str := li_expression.key
				if attached l_pre_values and then l_pre_values.has (l_expr_str) then
					l_expr_value_set := l_pre_values.item (l_expr_str)

					if attached l_expr_value_set then
						if l_partition.has (l_expr_value_set) then
							l_expr_str_set := l_partition.item (l_expr_value_set)
						else
							create l_expr_str_set.make_equal (5)
							l_partition.put (l_expr_str_set, l_expr_value_set)
						end
						l_expr_str_set.force (l_expr_str)
					end
				end
			end

				-- Add equivalent expression sets to `equivalent_expressions_for_pre'.
			across l_partition as li_partition loop
				if
					li_partition.key.count > 0 and then li_partition.item.count > 1
								-- Ignore equality between boolean expressions in pre state.
							and then not attached {EPA_BOOLEAN_VALUE} li_partition.key.first
				then
					equivalent_expressions_for_pre.extend (li_partition.item)
				end
			end
		end

	collect_potentially_equal_expressions_for_post
			-- Collect expressions that are potentially equal in the post state,
			-- store result in `left_expressions_for_post', `pre_expression_value_table' and `post_expression_value_table'.
			--
			-- For each expression e whose evaluation changed in some transition, collect expressions that
			--		have the same value set as e, pre- or post- the feature call.
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
				-- Iterate through all interface expressions and only select potentially changable ones.
				-- `left_expressions_for_post' contains all such expressions.
			l_post_values := data.interface_post_expression_values
			across data.interface_expression_changes as l_changes loop
				if l_changes.item then
					l_expr := l_changes.key
					if not l_expr.has_substring ("~") and then not l_expr.has_substring ("=") then
						l_post_values.search (l_expr)
						if l_post_values.found and then l_post_values.found_item.count > 1 and then not l_post_values.found_item.there_exists (agent (a_v: EPA_EXPRESSION_VALUE): BOOLEAN do Result := a_v = Void or else a_v.is_nonsensical end) then
							l_values := l_post_values.found_item
							left_expressions_for_post.force_last (l_expr)
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
				-- as the expressions in `left_expressions_for_post'.
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
			logger.push_level ({ELOG_CONSTANTS}.debug_level)
			logger.put_line_with_time ("Found the following left-hand-side expressions:")
			from
				l_expr_cur := left_expressions_for_post.new_cursor
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

	generate_equality_candidates_for_pre
			-- Generate equality candidates and store results in `candidate_pre_properties'.
			-- Update `pre_properties_operand_map_table'.
		local
			l_equivalent_sets: like equivalent_expressions_for_pre
			l_candidate_properties: like candidate_pre_properties
			l_equality_candidates: DS_HASH_SET [STRING_8]
			l_equality_candidates_cursor: DS_HASH_SET_CURSOR [STRING_8]
			l_set, l_pair: EPA_HASH_SET [STRING]
			l_pairs: LINKED_LIST [EPA_HASH_SET [STRING]]
			l_temp, l_candidate: STRING
			l_clauses: DS_HASH_SET [STRING_8]
			l_property: like candidate_property
		do
			create l_equality_candidates.make_equal (20)

			l_equivalent_sets := equivalent_expressions_for_pre
			across l_equivalent_sets as li_set loop
				l_set := li_set.item
				l_pairs := l_set.combinations (2)
				across l_pairs as li_pair loop
					l_pair := li_pair.item

					create l_temp.make (128)
					l_temp.append (l_pair.first)
					l_temp.append (" = (")
					l_temp.append (l_pair.last)
					l_temp.append (")")

					if not l_equality_candidates.has (l_temp) then
						create l_candidate.make (l_temp.count + 1)
						l_candidate.append (l_pair.last)
						l_candidate.append (" = (")
						l_candidate.append (l_pair.first)
						l_candidate.append (")")
						l_equality_candidates.force_last (l_candidate)
					end
				end
			end

			l_candidate_properties := candidate_pre_properties
			from
				l_equality_candidates_cursor := l_equality_candidates.new_cursor
				l_equality_candidates_cursor.start
			until
				l_equality_candidates_cursor.after
			loop
				create l_clauses.make (1)
				l_clauses.set_equality_tester (string_equality_tester)
				l_clauses.force (l_equality_candidates_cursor.item)
				l_property := candidate_property (l_clauses, "or", operand_string_table)
				l_candidate_properties.force_last (l_property.function)
				pre_properties_operand_map_table.force_last (l_property.operand_map, l_property.function)

				l_equality_candidates_cursor.forth
			end
		end

	generate_equality_candidates_for_post
			-- Generate equality candidates and store results in `candidate_post_properties'.
			-- Update `post_properties_operand_map_table'.
		local
			l_property: like candidate_property
			l_operand_map_table: like operand_map_table
			l_left_cur: DS_HASH_SET_CURSOR [STRING]
			l_left_expr: STRING
			l_equiv_set: like pre_expression_value_table
			l_set_cur: like post_expression_value_table.new_cursor
			l_values: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_set: DS_HASH_SET [STRING]
			l_expr_cur: DS_HASH_SET_CURSOR [STRING]
			l_candidate: STRING
			l_clauses: DS_HASH_SET [STRING]
			l_cand_cur: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_equality_candidates: DS_HASH_SET [STRING]
			l_changes: like data.interface_expression_changes
			l_temp: STRING
		do
			create l_equality_candidates.make (20)
			l_equality_candidates.set_equality_tester (string_equality_tester)

				-- Build equality candidate p = q where p is a left-hand-side expression and
				-- q is another expression in poststate.
			from
				l_left_cur := left_expressions_for_post.new_cursor
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
				l_left_cur := left_expressions_for_post.new_cursor
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
				l_property := candidate_property (l_clauses, "or", operand_string_table)
				candidate_post_properties.force_last (l_property.function)
				post_properties_operand_map_table.force_last (l_property.operand_map, l_property.function)
				l_expr_cur.forth
			end
		end


end
