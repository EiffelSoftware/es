note
	description: "Function domain by listing all the elements exhaustively"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXHAUSTIVE_DOMAIN

inherit
	EPA_FUNCTION_DOMAIN
		redefine
			is_exhaustive
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	is_exhaustive: BOOLEAN = True
			-- Does current represent an exhaustive domain?

feature -- Access

	values: DS_HASH_SET [EPA_EXPRESSION_VALUE]
			-- Set of values in current domain
		do
			if values_internal = Void then
				create values_internal.make (5)
				values_internal.set_equality_tester (expression_equality_tester)
			end
			Result := values_internal
		end

feature{NONE} -- Implementation

	values_internal: like values
			-- Cache for `values'

end
