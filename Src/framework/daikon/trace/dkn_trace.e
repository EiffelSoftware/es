note
	description: "Daikon trace"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_TRACE

inherit
	LINKED_LIST [DKN_TRACE_RECORD]
		redefine
			out
		end

	DEBUG_OUTPUT
		undefine
			out,
			is_equal,
			copy
		end

create
	make

feature -- Access

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make (1024 * 10)
			do_all (
				agent (a_record: like item; a_result: STRING)
					do
						a_result.append (a_record.out)
					end (?, Result))
		end

	debug_output: STRING
			-- Debug output
		do
			Result := out
		end

end
