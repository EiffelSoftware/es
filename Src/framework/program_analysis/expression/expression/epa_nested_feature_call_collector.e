note
	description: "Class to collect nested feature calls in a given AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_NESTED_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR
		redefine
			process_nested_as,
			process_nested_expr_as
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Access

	nested_calls: LINKED_LIST [AST_EIFFEL]
			-- List of nested feature calls from
			-- last `collect'. May have duplications.

feature -- Basic operations

	collect (a_ast: AST_EIFFEL)
			-- Collect nested features calls in `a_ast',
			-- make result available in `nested_calls'.
		do
			create nested_calls.make
			a_ast.process (Current)
		end

feature{NONE} -- Implementation

	process_nested_as (a_as: NESTED_AS)
			-- Process `a_as'.
		do
				-- Ignore this case. This is a hack. 5.12.2010 Jasonw.			
			nested_calls.extend (a_as)
			Precursor (a_as)
		end

	process_nested_expr_as (a_as: NESTED_EXPR_AS)
			-- Process `a_as'.
		do
				-- Ignore this case. This is a hack. 5.12.2010 Jasonw.			
			Precursor (a_as)
		end

end
