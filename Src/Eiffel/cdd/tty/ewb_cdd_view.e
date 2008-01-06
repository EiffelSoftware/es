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
			filter: CDD_FILTERED_VIEW
			tree: CDD_TREE_VIEW
		do
			if cdd_manager.is_project_initialized then
				localized_print ("%NAll test classes%N%N")
				io.put_string ("Please enter filter: ")
				io.read_line
				create filter.make (cdd_manager.test_suite)
				if io.last_string.count > 0 then
					filter.filters.force_last (io.last_string.twin)
				end
				io.put_string ("Please enter tree key: ")
				io.read_line
				create tree.make (filter)
				tree.set_key (io.last_string.twin)
				print_nodes (tree.nodes, 1)
			else
				io.put_string ("Please compile project first.")
			end
		end

feature {NONE} -- Implementation

	print_nodes (a_list: DS_LINEAR [CDD_TREE_NODE]; a_level: INTEGER) is
			-- Print content and children of `a_node' at level `a_level'.
		require
			a_list_void: a_list /= Void
			a_level_not_negative: a_level > 0
		local
			i: INTEGER
			cs: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			from
				cs := a_list.new_cursor
				cs.start
			until
				cs.off
			loop
				from
					i := 1
				until
					i > a_level
				loop
					localized_print ("-->")
					i := i + 1
				end
				localized_print (cs.item.tag + "%N")
				if cs.item.test_routine /= Void then
					print_test_routine (cs.item.test_routine)
				else
					print_nodes (cs.item.children, a_level + 1)
				end
				cs.forth
			end
		end

	print_test_routine (a_test_routine: CDD_TEST_ROUTINE) is
			-- Print details for `a_test_routine'
		require
			a_test_routine_not_void: a_test_routine /= Void
		local
			l_resp: CDD_TEST_EXECUTION_RESPONSE
		do
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
