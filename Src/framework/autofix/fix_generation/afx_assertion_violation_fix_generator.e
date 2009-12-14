note
	description: "Summary description for {AFX_ASSERTION_VIOLATION_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ASSERTION_VIOLATION_FIX_GENERATOR

inherit
	AFX_FIX_GENERATOR

feature -- Basic operations

	generate
			-- Generate fixes for `exception_spot' and
			-- store result in `fixes'.
		do
			generate_relevant_asts
		end

feature{NONE} -- Implementation

	relevant_asts: LINKED_LIST [LINKED_LIST [AFX_AST_STRUCTURE_NODE]]
			-- List of ASTs which will be involved in a fix.
			-- Item in the outer list is a list of ASTs, they represent the ASTs whilch will be involved in a fix.
			-- The outer list is needed because there may be more than one fixing locations.

feature{NONE} -- Implementation

	generate_relevant_asts
			-- Generate `relevant_asts'.
		local
			l_spot: like exception_spot
			l_node: detachable AFX_AST_STRUCTURE_NODE
			l_nlist: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			create relevant_asts.make
			l_spot := exception_spot
			if l_spot.is_precondition_violation  or l_spot.is_check_violation then
					-- Generate possible fixing locations:
				from
					l_node := l_spot.recipient_ast_structure.surrounding_instruction (l_spot.failing_assertion_break_point_slot)
				until
					l_node = Void
				loop
						-- The fixing location which only contains the instruction in trouble.
					create l_nlist.make
					l_nlist.extend (l_node)
					relevant_asts.extend (l_nlist)

						-- The fixing locations containing all the instructions which appear
						-- in the same basic block as the instruction in trouble.
					if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_node.sibling as l_list and then l_list.count > 1 then
						create l_nlist.make
						l_nlist.append (l_list)
						relevant_asts.extend (l_nlist)
					end
					l_node := l_node.parent
				end
			elseif l_spot.is_postcondition_violation or l_spot.is_class_invariant_violation then
					-- The only fix location is right before the end of the feature body.
				relevant_asts.extend (create {LINKED_LIST [AFX_AST_STRUCTURE_NODE]}.make)
			else
				check not_supported: False end
			end
		end

end
