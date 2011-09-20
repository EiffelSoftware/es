note
	description: "Summary description for {AFX_ASSERTION_VIOLATION_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ASSERTION_VIOLATION_FIX_GENERATOR

inherit
	AFX_FIX_GENERATOR

	EPA_EXPRESSION_STRUCTURE_ANALYZER_VISITOR

feature -- Basic operations

	generate
			-- <Precursor>
		local
			l_done: BOOLEAN
		do
				-- Initialize.
			create fix_skeletons.make
			initialize_assertion_structure_analyzer

				-- Generate fixing locations.
			generate_relevant_asts

				-- Analyze structure type of the failing assertion.			
			assertion_structure_analyzers.do_all (agent {EPA_EXPRESSION_STRUCTURE_ANALYZER}.analyze (exception_signature.exception_condition_in_recipient))

				-- Generate fixes according to structure type of the failing assertion.
			from
				assertion_structure_analyzers.start
			until
				assertion_structure_analyzers.after or l_done
			loop
				if assertion_structure_analyzers.item_for_iteration.is_matched then
					assertion_structure_analyzers.item_for_iteration.process (Current)
					l_done := True
				end
				assertion_structure_analyzers.forth
			end

				-- Generate actual fixes.
			create fixes.make
			from
				fix_skeletons.start
			until
				fix_skeletons.after
			loop
				fix_skeletons.item_for_iteration.generate
				fixes.append_last (fix_skeletons.item_for_iteration.fixes)
				fix_skeletons.forth
			end
		end

feature{NONE} -- Implementation

	fixing_locations: LINKED_LIST [TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- List of ASTs which will be involved in a fix.
			-- Item in the inner list `instructions' is a list of ASTs, they represent the ASTs whilch will be involved in a fix.
			-- `scope_level' is the scope level difference from `instructions' to the failing point. If `instructions' are in
			-- the same basic block as the failing point, `scope_level' will be 1. `scope_level' will be increased by 1, every time
			-- `instructions' goes away for the failing point. `scope_leve' is used for fix ranking.
			-- The outer list is needed because there may be more than one fixing locations.

	assertion_structure_analyzers: LINKED_LIST [EPA_EXPRESSION_STRUCTURE_ANALYZER]
			-- List of assertion structure analyzers
			-- The fix syntax for assertions with different structures are different.

	initialize_assertion_structure_analyzer
			-- Analyze `assertion_structure_analyzers'.
		do
			create assertion_structure_analyzers.make
			assertion_structure_analyzers.extend (create {EPA_ABQ_STRUCTURE_ANALYZER})
			assertion_structure_analyzers.extend (create {EPA_ABQ_IMPLICATION_STRUCTURE_ANALYZER})
			assertion_structure_analyzers.extend (create {EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER})
			assertion_structure_analyzers.extend (create {EPA_ANY_STRUCTURE_ANALYZER})
		end

feature{NONE} -- Implementation

	generate_relevant_asts
			-- Generate `fixing_locations'.
		local
			l_signature: like exception_signature
			l_recipient: like exception_recipient_feature
			l_node: detachable AFX_AST_STRUCTURE_NODE
			l_nlist: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
			l_scope_level: INTEGER
		do
			create fixing_locations.make
			l_signature := exception_signature
			l_recipient := exception_recipient_feature
			if l_signature.is_precondition_violation  or l_signature.is_check_violation then
					-- Generate possible fixing locations:
				from
					l_scope_level := 1
					l_node := l_recipient.ast_structure.surrounding_instruction (l_signature.recipient_breakpoint)
				until
					l_node = Void or else l_node.is_feature_node or l_scope_level > config.max_fixing_location_scope_level
				loop
						-- The fixing location which only contains the instruction in trouble.
					create l_nlist.make
					l_nlist.extend (l_node)
					fixing_locations.extend ([l_scope_level, l_nlist])

						-- The fixing locations containing all the instructions which appear
						-- in the same basic block as the instruction in trouble.						
					if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_recipient.ast_structure.instructions_in_block_as (l_node) as l_list and then l_list.count > 1 then
						create l_nlist.make
						l_nlist.append (l_list)
						fixing_locations.extend ([l_scope_level, l_nlist])
					end
					l_node := l_node.parent
					l_scope_level := l_scope_level + 1
				end
			elseif l_signature.is_postcondition_violation or l_signature.is_class_invariant_violation then
					-- The only fix location is right before the end of the feature body.
				fixing_locations.extend ([1, create {LINKED_LIST [AFX_AST_STRUCTURE_NODE]}.make])
			else
				check not_supported: False end
			end
		end

feature{NONE} -- Implementation

	process_abq_structure_analyzer (a_analyzer: EPA_ABQ_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ABQ_FIX_GENERATOR
		do
			create l_generator.make (a_analyzer, fixing_locations)
			l_generator.generate
			fix_skeletons.append (l_generator.fixes)
		end

	process_abq_implication_structure_analyzer (a_analyzer: EPA_ABQ_IMPLICATION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ABQ_IMPLICATION_FIX_GENERATOR
		do
			create l_generator.make (a_analyzer, fixing_locations)
			l_generator.generate
			fix_skeletons.append (l_generator.fixes)
		end

	process_linear_constrained_structure_analyzer (a_analyzer: EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_LINEAR_CONSTRAINT_FIX_GENERATOR
		do
			create l_generator.make (a_analyzer, fixing_locations)
			l_generator.generate
			fix_skeletons.append (l_generator.fixes)
		end

	process_any_structure_analyzer (a_analyzer: EPA_ANY_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		local
			l_generator: AFX_ANY_STRUCTURE_FIX_GENERATOR
		do
			create l_generator.make (a_analyzer, fixing_locations)
			l_generator.generate
			fix_skeletons.append (l_generator.fixes)
		end

end
