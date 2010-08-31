note
	description: "Summary description for {AFX_RANDOM_BASED_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RANDOM_BASED_FIX_GENERATOR

inherit
	AFX_FIX_GENERATOR

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_spot: like exception_spot; a_config: like config; a_test_case_execution_status: like test_case_execution_status)
			-- Initialize.
		do
			exception_spot := a_spot
			config := a_config
			test_case_execution_status := a_test_case_execution_status
		end

feature -- Access

--	relevant_objects:

feature -- Basic operations

	generate
			-- <Precursor>
		do
			--Initialize.
			create fix_skeletons.make

--			collect_directly_relevant_objects

			-- Generate fix locations.
			generate_relevant_asts

			-- Collect relevant objects at each fix location.
--			collect_relevant_objects

			-- Generate actual fixes.
--			create fixes.make
--			from
--				fix_skeletons.start
--			until
--				fix_skeletons.after
--			loop
--				fix_skeletons.item_for_iteration.generate
--				fixes.append (fix_skeletons.item_for_iteration.fixes)
--				fix_skeletons.forth
--			end
		end

feature{NONE} -- Implementation operations

--	collect_relevant_objects
			-- Collect relevant objects into

	generate_relevant_asts
			-- Generate `fixing_locations'.
		local
			l_spot: like exception_spot
			l_node: detachable AFX_AST_STRUCTURE_NODE
			l_nlist: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			l_scope_level: INTEGER
		do
			fixme ("Copied from {AFX_ASSERTION_VIOLATION_FIX_GENERATOR}.")

			create fixing_locations.make
			l_spot := exception_spot
			if l_spot.is_precondition_violation  or l_spot.is_check_violation then
					-- Generate possible fixing locations:
				from
					l_scope_level := 1
					l_node := l_spot.recipient_ast_structure.surrounding_instruction (l_spot.failing_assertion_break_point_slot)
				until
					l_node = Void or else l_node.is_feature_node or l_scope_level > config.max_fixing_location_scope_level
				loop
						-- The fixing location which only contains the instruction in trouble.
					create l_nlist.make
					l_nlist.extend (l_node)
					fixing_locations.extend ([l_scope_level, l_nlist])

						-- The fixing locations containing all the instructions which appear
						-- in the same basic block as the instruction in trouble.						
					if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_spot.recipient_ast_structure.instructions_in_block_as (l_node) as l_list and then l_list.count > 1 then
						create l_nlist.make
						l_nlist.append (l_list)
						fixing_locations.extend ([l_scope_level, l_nlist])
					end
					l_node := l_node.parent
					l_scope_level := l_scope_level + 1
				end
			elseif l_spot.is_postcondition_violation or l_spot.is_class_invariant_violation then
					-- The only fix location is right before the end of the feature body.
				fixing_locations.extend ([1, create {LINKED_LIST [AFX_AST_STRUCTURE_NODE]}.make])
			else
				check not_supported: False end
			end
		end

feature{NONE} -- Implementation attributes

	config: AFX_CONFIG
			-- Config for current AutoFix session.

	test_case_execution_status: HASH_TABLE [AFX_TEST_CASE_EXECUTION_STATUS, STRING]
			-- Table of test case execution status
			-- Key is the UUID of a test case, value is the execution status
			-- assoicated with that test case

	fixing_locations: LINKED_LIST [TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- List of ASTs which will be involved in a fix.
			-- Item in the inner list `instructions' is a list of ASTs, they represent the ASTs whilch will be involved in a fix.
			-- `scope_level' is the scope level difference from `instructions' to the failing point. If `instructions' are in
			-- the same basic block as the failing point, `scope_level' will be 1. `scope_level' will be increased by 1, every time
			-- `instructions' goes away for the failing point. `scope_leve' is used for fix ranking.
			-- The outer list is needed because there may be more than one fixing locations.

end
