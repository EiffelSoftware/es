note
	description: "Objects that represent finders to collect potentially interesting expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_FINDER

feature -- Access

	last_found_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions that are found by last `search'

feature --  Basic operations

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- Search for potentially interesting expressions, make newly found
			-- expressions avaiable in `last_found_expressions'.
			-- `a_expression_repository' is a set of existing expression, only new
			-- expressions are kept in `last_found_expressions'.
		deferred
		ensure
			new_in_last_found_expresssions: a_expression_repository.is_disjoint (last_found_expressions)
		end

feature{NONE} -- Implementation

	new_expression_set: like last_found_expressions
			-- New expression set
		do
			create Result.make (50)
			Result.set_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})
		end

	expression_equality_tester: EPA_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

end
