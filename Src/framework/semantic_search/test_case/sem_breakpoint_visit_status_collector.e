note
	description: "Class that collects hit breakpoints for a given feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_BREAKPOINT_VISIT_STATUS_COLLECTOR

inherit
	SEM_FIELD_NAMES

	IR_TERM_OCCURRENCE

feature -- Access

	visited_breakpoints_in_passing_tests: DS_HASH_SET [INTEGER]
			-- Set of break points that are visited only in passing tests

	visited_breakpoints_in_failing_tests: DS_HASH_SET [INTEGER]
			-- Set of break points that are visited only in failing tests

	breakpoints: DS_HASH_SET [INTEGER]
			-- Set of break points in the last collected feature

	dumped_integer_sets (a_set: DS_HASH_SET [INTEGER]): STRING
			-- String representation for `a_set'.
		local
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
		do
			create Result.make (128)
			from
				l_cursor := a_set.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append_integer (l_cursor.item)

				if not l_cursor.is_last then
					Result.append_character (',')
					Result.append_character (' ')
				end
				l_cursor.forth
			end
		end

feature -- Basic operations

	collect (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Collect break point visit status from `a_feature' in `a_class',
			-- make result available in `visited_breakpoints_in_passing_tests',
			-- `visited_breakpoints_in_failing_tests' and `breakpoints'.
		local
			l_bp_count: INTEGER
		do
			last_class := a_class
			last_feature := a_feature

				-- Setup `breakpoints'.
			l_bp_count := a_feature.e_feature.number_of_breakpoint_slots
			create breakpoints.make (l_bp_count)
			across 1 |..| l_bp_count as l_bps loop
				breakpoints.force_last (l_bps.item)
			end

			create visited_breakpoints_in_failing_tests.make (100)
			create visited_breakpoints_in_passing_tests.make (100)

				-- Consult the search system for all transitions of `last_feature'.
			search_for_transitions

				-- Process `last_results'.
			last_results.do_all (agent process_document)
		end

feature{NONE} -- Implementation

	last_class: CLASS_C
			-- Last class

	last_feature: FEATURE_I
			-- Last feature

	last_results: LINKED_LIST [IR_DOCUMENT]
			-- Last results from `search_for_transitions'

	search_for_transitions
			-- Search for breakpoints in `last_feature' from `last_class' that are not visited in
			-- all the test cases for that feature in the search system.
			-- Make result available in `last_results'
		local
			l_query: IR_BOOLEAN_QUERY
			l_doc_type_term: IR_TERM
			l_class_term: IR_TERM
			l_feature_term: IR_TERM
			l_query_executor: IR_SOLR_QUERY_EXECUTOR
		do
				-- Setup query.
			create l_doc_type_term.make_as_string (document_type_field, "transition", default_boost_value, term_occurrence_must)
			create l_class_term.make_as_string (class_field, last_class.name, default_boost_value, term_occurrence_must)
			create l_feature_term.make_as_string (feature_field, last_feature.feature_name, default_boost_value, term_occurrence_must)
			create l_query.make
			l_query.terms.force_last (l_doc_type_term)
			l_query.terms.force_last (l_class_term)
			l_query.terms.force_last (l_feature_term)
			l_query.returned_fields.force_last (uuid_field)
			l_query.returned_fields.force_last (test_case_status_field)
			l_query.returned_fields.force_last (content_field)
			l_query.returned_fields.force_last (hit_break_points_field)
			l_query.meta.force ("5000", "rows")

				-- Execute query.
			create l_query_executor.make
			l_query_executor.execute (l_query)
			last_results := l_query_executor.last_result.documents
		end

	process_document (a_document: IR_DOCUMENT)
			-- Process `a_document' to collect break point visit information.
		local
			l_fields: HASH_TABLE [LINKED_LIST [IR_FIELD], STRING]
			l_breaks: like visited_breakpoints_in_failing_tests
			l_bps: LIST [STRING]
		do
			l_fields := a_document.table_by_name
			l_fields.search (hit_break_points_field)
			if l_fields.found then
				l_bps := l_fields.found_item.first.value.text.split (',')
				l_fields.search (test_case_status_field)
				if l_fields.found_item.first.value.text ~ test_case_status_passing then
					l_breaks := visited_breakpoints_in_passing_tests
				else
					l_breaks := visited_breakpoints_in_failing_tests
				end
				across l_bps as l_breakpoints loop
					if l_breakpoints.item.is_integer then
						l_breaks.force_last (l_breakpoints.item.to_integer)
					end
				end
			else
				io.put_string ("Breakpoint not found in " + l_fields.item (uuid_field).first.value.text + "%N")
			end
		end

end
