note
	description: "Custom AST iterator which does the actual comment parsing."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_AST_ITERATOR

inherit

	AST_ROUNDTRIP_ITERATOR
		redefine
			process_break_as
		end

feature -- Processing

	process_break_as (a_break_as: BREAK_AS)
		do
			io.put_string (a_break_as.text_32 (match_list))
		end

end
