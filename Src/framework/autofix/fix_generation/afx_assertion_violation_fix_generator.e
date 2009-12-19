note
	description: "Summary description for {AFX_ASSERTION_VIOLATION_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ASSERTION_VIOLATION_FIX_GENERATOR

inherit
	AFX_FIX_GENERATOR

	AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR

create
	make

feature{NONE} -- Initialization

	make (a_spot: like exception_spot; a_config: like config)
			-- Initialize.
		do
			exception_spot := a_spot
			config := a_config
		end

feature -- Basic operations

	generate
			-- Generate fixes for `exception_spot' and
			-- store result in `fixes'.
		local
			l_done: BOOLEAN
		do
				-- Initialize.
			create fixes.make
			initialize_assertion_structure_analyzer

				-- Generate fixing locations.
			generate_relevant_asts

				-- Analyze structure type of the failing assertion.			
			assertion_structure_analyzer.do_all (agent {AFX_EXPRESSION_STRUCTURE_ANALYZER}.analyze (exception_spot.failing_assertion))

				-- Generate fixes according to structure type of the failing assertion.
			from
				assertion_structure_analyzer.start
			until
				assertion_structure_analyzer.after or l_done
			loop
				if assertion_structure_analyzer.item_for_iteration.is_matched then
					assertion_structure_analyzer.item_for_iteration.process (Current)
					l_done := True
				end
				assertion_structure_analyzer.forth
			end

		end

feature{NONE} -- Implementation

	fixing_locations: LINKED_LIST [TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- List of ASTs which will be involved in a fix.
			-- Item in the inner list `instructions' is a list of ASTs, they represent the ASTs whilch will be involved in a fix.
			-- `scope_level' is the scope level difference from `instructions' to the failing point. If `instructions' are in
			-- the same basic block as the failing point, `scope_level' will be 1. `scope_level' will be increased by 1, every time,
			-- `instructions' goes away for the failing point. `scope_leve' is used for fix ranking.
			-- The outer list is needed because there may be more than one fixing locations.

	assertion_structure_analyzer: LINKED_LIST [AFX_EXPRESSION_STRUCTURE_ANALYZER]
			-- List of assertion structure analyzers
			-- The fix syntax for assertions with different structures are different.

	initialize_assertion_structure_analyzer
			-- Analyze `assertion_structure_analyzer'.
		do
			create assertion_structure_analyzer.make
			assertion_structure_analyzer.extend (create {AFX_ABQ_STRUCTURE_ANALYZER})
			assertion_structure_analyzer.extend (create {AFX_ABQ_IMPLICATION_STRUCTURE_ANALYZER})
			assertion_structure_analyzer.extend (create {AFX_ANY_STRUCTURE_ANALYZER})
		end

	config: AFX_CONFIG
			-- Config for Current AutoFix session

feature{NONE} -- Implementation

	generate_relevant_asts
			-- Generate `fixing_locations'.
		local
			l_spot: like exception_spot
			l_node: detachable AFX_AST_STRUCTURE_NODE
			l_nlist: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			l_scope_level: INTEGER
		do
			create fixing_locations.make
			l_spot := exception_spot
			if l_spot.is_precondition_violation  or l_spot.is_check_violation then
					-- Generate possible fixing locations:
				from
					l_scope_level := 1
					l_node := l_spot.recipient_ast_structure.surrounding_instruction (l_spot.failing_assertion_break_point_slot)
				until
					l_node = Void or else l_node.is_feature_node
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

feature{NONE} -- Implementation

	process_abq_structure_analyzer (a_analyzer: AFX_ABQ_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ABQ_FIX_GENERATOR
		do
			create l_generator.make (exception_spot, a_analyzer, fixing_locations, config)
			l_generator.generate
			fixes.append (l_generator.fixes)
		end

	process_abq_implication_structure_analyzer (a_analyzer: AFX_ABQ_IMPLICATION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ABQ_IMPLICATION_FIX_GENERATOR
		do
			create l_generator.make (exception_spot, a_analyzer, fixing_locations, config)
			l_generator.generate
			fixes.append (l_generator.fixes)
		end

	process_linear_constrained_structure_analyzer (a_analyzer: AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_LINEAR_CONSTRAINT_FIX_GENERATOR
		do
			create l_generator.make (exception_spot, a_analyzer, fixing_locations, config)
			l_generator.generate
			fixes.append (l_generator.fixes)
		end

	process_any_structure_analyzer (a_analyzer: AFX_ANY_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ANY_STRUCTURE_FIX_GENERATOR
		do
			create l_generator.make (exception_spot, a_analyzer, fixing_locations, config)
			l_generator.generate
			fixes.append (l_generator.fixes)
		end

end
