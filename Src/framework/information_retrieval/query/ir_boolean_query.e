note
	description: "Class that represents a boolean query, which consists a list of terms"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_BOOLEAN_QUERY

inherit
	IR_QUERY

	IR_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create terms.make (10)
			terms.set_equality_tester (ir_term_equality_tester)
		end

feature -- Access

	terms: EPA_HASH_SET [IR_TERM]
			-- Terms that specify searching criteria

feature -- Process

	process (a_visitor: IR_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_boolean_query (Current)
		end

end
