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
				localized_print ("%NAll test classes%N%N")

				cdd_manager.test_suite.test_classes.do_all (agent (a_tc: CDD_TEST_CLASS)
					do
						print_test_class (a_tc)
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

	print_test_class (a_test_class: CDD_TEST_CLASS) is
			-- Print details for `a_test_class'.
		require
			a_test_class_not_void: a_test_class /= Void
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
		do
			test_class_count := test_class_count + 1
			localized_print (a_test_class.test_class.name + "%N")
			l_cursor := a_test_class.test_routines.new_cursor
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
			l_resp: CDD_TEST_EXECUTION_RESPONSE
		do
			test_routine_count := test_routine_count + 1
			localized_print ("%T" + a_test_routine.name)
			if not a_test_routine.outcomes.is_empty then
				l_resp := a_test_routine.outcomes.last
				if l_resp.is_pass then
					localized_print (": PASS")
				elseif l_resp.is_fail then
					localized_print (": FAIL")
				else
					localized_print (": UNRESOLVED")
				end
				if l_resp.requires_maintenance then
					if l_resp.has_bad_communication then
						localized_print (" (bad communication)")
					elseif l_resp.has_bad_context then
						localized_print (" (bad context)")
					else
						localized_print (" (compile error)")
					end
				end
				localized_print ("%N")
			else
				localized_print (": (not tested yet)%N")
			end
		end

end
