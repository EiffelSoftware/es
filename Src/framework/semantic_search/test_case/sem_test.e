note
	description: "Class to test semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TEST

inherit
	IR_TERM_OCCURRENCE

	SEM_FIELD_NAMES

	EPA_UTILITY

feature -- Basic operations

	test_search_for_feature (a_class_name: STRING; a_feature_name: STRING; a_rows: INTEGER)
			-- Test search for `a_feature_name' in `a_class_name',
			-- the result returns at most `a_rows' elements.
		local
			l_executor: SEM_SOLR_QUERY_EXECUTOR
			l_generator: SEM_QUERYABLE_SEARCHABLE_PROPERTY_GENERATOR
			l_query_config: SEM_QUERY_CONFIG
			l_bquery: SEM_BOOLEAN_QUERY
			l_queryable: SEM_QUERYABLE
			l_matcher: SEM_QUERYABLE_MATCHER
			l_matches: LINKED_LIST [SEM_QUERYABLE_MATCHING_RESULT]
		do
				-- Generate a query config.
			create l_generator
			l_queryable := l_generator.queryable_from_feature_names (a_feature_name, a_class_name)
			l_query_config := l_generator.query_config_from_queryable (l_queryable)
			l_query_config.returned_fields.append (l_generator.last_returned_fields)
			across l_generator.last_fields as l_fields loop
				l_query_config.extra_fields.force (l_fields.item, l_fields.key)
			end


				-- Generate a query executor.
			create l_bquery.make (l_query_config)
			create l_executor

				-- Execute query and output results.
			io.put_string ("----------------------------------------------------%N")
			io.put_string (l_query_config.text)
			l_executor.execute_with_options (l_bquery, l_generator.last_options)
			io.put_string ("----------------------------------------------------%N")

			create l_matcher.make
			l_matcher.match (l_query_config, l_executor.last_result)
			l_matches := l_matcher.last_matches
			from
				l_matches.start
			until
				l_matches.after
			loop
				if l_matches.item_for_iteration.is_full_solution then
					io.put_string ("------------------------%N")
					io.put_string (l_matches.item_for_iteration.text)
				end
				l_matches.forth
			end

			io.put_string (l_matcher.last_match_start_time.out + "%N")
			io.put_string (l_matcher.last_match_end_time.out + "%N")
		end

	test_for_find_unvisited_breakpoints (a_class: STRING; a_feature: STRING)
			-- Search for breakpoints in `a_feature' from `a_class' that are not visited in
			-- all the test cases for that feature in the search system.
		local
			l_bp_collector: SEM_BREAKPOINT_VISIT_STATUS_COLLECTOR
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			create l_bp_collector
			l_class := first_class_starts_with_name (a_class)
			l_feature := l_class.feature_named (a_feature)

			l_bp_collector.collect (l_class, l_feature)
			io.put_string ("---------------------------------------------------%N")
			io.put_string (l_class.name + "." + l_feature.feature_name + "%N")
			io.put_string ("All break points: " + l_bp_collector.dumped_integer_sets (l_bp_collector.breakpoints) + "%N")
			io.put_string ("In passing tests: " + l_bp_collector.dumped_integer_sets (l_bp_collector.visited_breakpoints_in_passing_tests) + "%N")
			io.put_string ("In failing tests: " + l_bp_collector.dumped_integer_sets (l_bp_collector.visited_breakpoints_in_failing_tests) + "%N")
			io.put_string ("Unvisited points: " +
				l_bp_collector.dumped_integer_sets (
					l_bp_collector.breakpoints.subtraction (l_bp_collector.visited_breakpoints_in_passing_tests).subtraction (l_bp_collector.visited_breakpoints_in_failing_tests)) + "%N")

		end

end
