note
	description: "Analyzer to extract functions from test case state expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCTION_ANALYZER

feature -- Access

	valuations: DS_HASH_TABLE [EPA_FUNCTION_MAP, EPA_FUNCTION]
			-- Valuations of functions
			-- Key is a function, value is the argument(s) to value mapping for that function.

feature -- Basic operations

	analyze (a_state: EPA_STATE; a_context: EPA_CONTEXT)
			-- Analyze functions in `a_state' and make result avaiable in `valuations'.
			-- `a_state' contains a set of expressions along with their values. Functions and
			-- mappings are extracted from `a_state'.
			-- `a_context' provides the set of variables that can be used as arguments of functions.
			-- That is, only variables in `a_context' are considered as arguments of to-be-extracted functions,
			-- all other literals are considered as part of the function body.
			-- The order of arguments for a particular function is decided by the order of the variable appearance in
			-- parse sense. For example in the expression "v1.has (v2)", the function {1}.has ({2}) will be extracted,
			-- and the first argument is v1 because it is first analyzed when parsing the expressions (target of feature call
			-- is parsed first), and v2 will be the second argument of that function.
		do

		end
end
