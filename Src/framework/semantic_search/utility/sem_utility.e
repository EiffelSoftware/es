note
	description: "Utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UTILITY

inherit
	EPA_TYPE_UTILITY

feature -- Access

	variable_to_type_replacements (a_variables: EPA_HASH_SET [EPA_EXPRESSION]): HASH_TABLE [STRING, STRING]
			-- Table to lookup the type of variables in `a_variables'
			-- Key is variable name, value is the type of that variable.
		do
			create Result.make (a_variables.count)
			Result.compare_objects
			a_variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					local
						l_type: STRING
					do
						l_type := cleaned_type_name (a_expr.resolved_type.name)
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, Result))
		end

feature -- Access

	expression_rewriter: SEM_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `variables' in anonymous format.
		once
			create Result.make
		end

end
