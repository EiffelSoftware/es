note
	description: "Class to test semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TEST

feature -- Basic operations

	test_search_for_feature (a_class_name: STRING; a_feature_name: STRING; a_rows: INTEGER)
			-- Test search for `a_feature_name' in `a_class_name',
			-- the result returns at most `a_rows' elements.
		local
			l_executor: SEM_SOLR_QUERY_EXECUTOR
			l_generator: SEM_QUERYABLE_SEARCHABLE_PROPERTY_GENERATOR
			l_query_config: SEM_QUERY_CONFIG
			l_bquery: SEM_BOOLEAN_QUERY
			l_options: HASH_TABLE [STRING, STRING]
			l_queryable: SEM_QUERYABLE
			l_matcher: SEM_QUERYABLE_MATCHER
			l_matches: LINKED_LIST [SEM_QUERYABLE_MATCHING_RESULT]
		do
				-- Generate a query config.
			create l_generator
			l_queryable := l_generator.queryable_from_feature_names (a_feature_name, a_class_name)
			l_query_config := l_generator.query_config_from_queryable (l_queryable)

				-- Generate a query executor.
			create l_bquery.make (l_query_config)
			create l_options.make (10)
			l_options.compare_objects
			l_options.force ("0", "start")
			l_options.force (a_rows.out, "rows")
			create l_executor

				-- Execute query and output results.
			io.put_string ("----------------------------------------------------%N")
			io.put_string (l_query_config.text)
			l_executor.execute_with_options (l_bquery, l_options)
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

end
