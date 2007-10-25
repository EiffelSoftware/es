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
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
			l_cluster_name, l_class_name, l_feature_name: STRING
		do
			if cdd_manager.is_cdd_enabled then
				cdd_manager.test_suite.sort_by_target (Void, Void, Void)
				create l_cursor.make (cdd_manager.test_suite.last_sort_result)
				from
					l_cursor.start
					create l_cluster_name.make_empty
					create l_class_name.make_empty
					create l_feature_name.make_empty
				until
					l_cursor.after
				loop
					if not l_feature_name.is_equal (l_cursor.item.feature_name) then
						l_feature_name := l_cursor.item.feature_name
						if not l_class_name.is_equal (l_cursor.item.class_name) then
							l_class_name := l_cursor.item.class_name
							if not l_cluster_name.is_equal (l_cursor.item.cluster_name) then
								l_cluster_name := l_cursor.item.cluster_name
								localized_print ("%N" + l_cluster_name + "%N")
							end
							localized_print ("%T" + l_class_name + "%N")
						end
						localized_print ("%T%T" + l_feature_name + "%N")
					end
					localized_print ("%T%T%T" + l_cursor.item.test_class.name_in_upper + "%N")
					l_cursor.forth
				end
				localized_print ("%NCurrently " + (l_cursor.index - 1).out + " test cases in system%N%N")
			else
				io.put_string ("CDD is currently not enabled. To view or create%Ntest cases enable CDD through `Status' menu.")
			end
		end

end
