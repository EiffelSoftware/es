note
	description: "Summary description for {AFX_SMTLIB_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_CONSTANTS

feature -- Access

	smtlib_function_header: STRING is ":extrafuns "
			-- Header for a SMTLIB function

	smtlib_axiom_header: STRING is ":assumption "
			-- Header for a SMTLIB axiom

	smtlib_prefix_opener: STRING is "{{"
			-- Opener for a class prefix inside a SMTLIB expression
			-- Used to handle qualified call

	smtlib_prefix_closer: STRING is "}}"
			-- Closer for a class prefix inside a SMTLIB expression
			-- Used to handle qualified call

end
