indexing
	description: "Objects that provide a tty command for viewing test cases in a system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_CDD_VIEW

inherit

	EWB_CDD_CMD

feature -- Access

	name: STRING is "View"

	help_message: STRING is "View current test cases"

	abbreviation: CHARACTER is 'v'

feature -- Execution

	execute is
			-- Print list of all test cases to stdout.
		local
			l_count: INTEGER
		do
			if cdd_manager.is_cdd_enabled then
				localized_print ("%NExtracted test classes")

				create last_cluster_name.make_empty
				create last_class_name.make_empty
				create last_feature_name.make_empty
				cdd_manager.test_suite.extracted_test_classes.do_all (agent (a_tc: CDD_EXTRACTED_TEST_CLASS)
					do
						print_extracted_test_class (a_tc)
					end)

				l_count := test_class_count
				localized_print ("%NManual test classes")
				cdd_manager.test_suite.manual_test_classes.do_all (agent (a_tc: CDD_MANUAL_TEST_CLASS)
					do
						print_manual_test_class (a_tc)
					end)
				localized_print ("%NTotal " + test_class_count.out + " test classes with " + test_routine_count.out + " test routines%N%N")
			else
				io.put_string ("CDD is currently not enabled. To view or create%Ntest cases enable CDD through `Status' menu.")
			end
		end

feature {NONE} -- Implementation

	test_class_count: INTEGER
			-- Number of test classes printed so far

	test_routine_count: INTEGER
			-- Number of test routines printed so far

	last_cluster_name: STRING
			-- Name of last cluster for which extracted test class details have been printed

	last_class_name: STRING
			-- Name of last class for which extracted test class details have been printed

	last_feature_name: STRING
			-- Name of last feature for which extracted test class details have been printed

	print_extracted_test_class (a_test_class: CDD_EXTRACTED_TEST_CLASS) is
			-- Print details for `a_test_class'.
		require
			a_test_class_not_void: a_test_class /= Void
			last_cluster_name_not_void: last_cluster_name /= Void
			last_class_name_not_void: last_class_name /= Void
			last_feature_name_not_void: last_feature_name /= Void
		do
			test_routine_count := test_routine_count + 1
			test_class_count := test_class_count + 1
			if not last_feature_name.is_equal (a_test_class.feature_name) then
				last_feature_name := a_test_class.feature_name
				if not last_class_name.is_equal (a_test_class.class_name) then
					last_class_name := a_test_class.class_name
					if a_test_class.cluster/= Void and then not last_cluster_name.is_equal (a_test_class.cluster.cluster_name) then
						last_cluster_name := a_test_class.cluster.cluster_name
						localized_print ("%N" + last_cluster_name + "%N")
					end
					localized_print ("%T" + last_class_name + "%N")
				end
				localized_print ("%T%T" + last_feature_name + "%N")
			end
			localized_print ("%T%T%T" + a_test_class.test_class.name_in_upper + "%N")
		end

	print_manual_test_class (a_test_class: CDD_MANUAL_TEST_CLASS) is
			-- Print details for `a_test_class'.
		require
			a_test_class_not_void: a_test_class /= Void
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_ROUTINE]
		do
			test_class_count := test_class_count + 1
			localized_print (a_test_class.test_class.name + "%N")
			create l_cursor.make (a_test_class.test_routines)
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				print_test_routine (l_cursor.item)
				l_cursor.forth
			end
		end

	print_test_routine (a_test_routine: CDD_TEST_ROUTINE) is
			-- Print details for `a_test_routine'
		require
			a_test_routine_not_void: a_test_routine /= Void
		local
			l_resp: CDD_ROUTINE_INVOCATION_RESPONSE
		do
			test_routine_count := test_routine_count + 1
			localized_print ("%T" + a_test_routine.routine_name)
			if not a_test_routine.outcomes.is_empty then
				l_resp := a_test_routine.outcomes.first.setup_response
				localized_print (": " + l_resp.response_text + "%N")
			else
				localized_print (": not tested yet%N")
			end
		end

end
