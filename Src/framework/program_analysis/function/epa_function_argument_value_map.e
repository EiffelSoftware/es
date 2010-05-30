note
	description: "Class that represents a mapping for argument(s) to value of a function."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_ARGUMENT_VALUE_MAP

inherit
	HASHABLE

	EPA_SHARED_EQUALITY_TESTERS

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_arguments: like arguments; a_value: like value; a_function: like function)
			-- Initialize Current.
		require
			arity_correct: a_arguments.count = a_function.arity
			a_arguments_valid: a_arguments.equality_tester = function_equality_tester
		do
			arguments := a_arguments
			value := a_value
			function := a_function
		end

feature -- Access

	function: EPA_FUNCTION
			-- Function where current mapping exists

	arguments: DS_ARRAYED_LIST [EPA_FUNCTION]
			-- List of arguments
			-- Order of elements is important

	value: EPA_FUNCTION
			-- Value of the function when applied with `a_arguments'

	cloned: like Current
			-- Cloned current
		do
			create Result.make (arguments.twin, value, function)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [EPA_FUNCTION]
			l_count: INTEGER
		do
			create Result.make (64)
			from
				l_count := arguments.count
				l_cursor := arguments.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.item.body)
				if l_cursor.index < l_count then
					Result.append (once " x ")
				end
				l_cursor.forth
			end
			Result.append (once " -> ")
			Result.append (value.body)
		end

feature -- Hashing

	hash_code: INTEGER
			-- Hash code value
		local
			l_str: STRING
		do
			if hash_code_internal = 0 then
				create l_str.make (32)
				arguments.do_all (
					agent (a_func: EPA_FUNCTION; a_str: STRING)
						do
							a_str.append (a_func.body)
							a_str.append_character (',')
						end (?, l_str))
				l_str.append (value.body)
				hash_code_internal := l_str.hash_code
			end
			Result := hash_code_internal
		end

feature{NONE} -- Implementation

	hash_code_internal: INTEGEr
			-- Cache for `hash_code'

end
