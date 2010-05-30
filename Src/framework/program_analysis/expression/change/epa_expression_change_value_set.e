note
	description: "Objects represent the set of values that a change can bare"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_CHANGE_VALUE_SET

inherit
	EPA_HASH_SET [EPA_EXPRESSION]

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			copy
		end

	DEBUG_OUTPUT
		undefine
			is_equal,
			copy
		end

create
	make

feature -- Status report

	is_valid: BOOLEAN
			-- Is Current value set valid?
		do
			Result := True
		end

	is_integer_range: BOOLEAN
			-- Does Current represent an integer range?
		do
		end

	is_unknown: BOOLEAN
			-- Does Current represent the notion of a "unknown" change?
		do
			Result := is_empty
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (128)
			do_all_with_index (
				agent (a_expr: EPA_EXPRESSION; a_index: INTEGER; a_count: INTEGER; a_str: STRING)
					do
						a_str.append (a_expr.text)
						if a_index < a_count then
							a_str.append (once ", ")
						end
					end (?, ?, count, Result))
		end

feature -- Visit

	process (a_visitor: EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_expression_change_value_set (Current)
		end

end
