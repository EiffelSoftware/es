note
	description: "Summary description for {CA_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FIX

create
	make_with_node_replacement

feature {NONE} -- Implementation
	make_with_node_replacement (a_old_node, a_new_node: AST_EIFFEL)
		do
			rule_violating_node := a_old_node
			corrected_node := a_new_node
		end

feature -- Commands
	apply
		do
			-- TODO: perhaps preliminary operations needed
			rule_violating_node := corrected_node
			-- TODO: re-generate the source file,
			-- perhaps re-parsing or re-compiling
		end

feature -- Properties

	rule_violating_node: AST_EIFFEL

	corrected_node: AST_EIFFEL

end
