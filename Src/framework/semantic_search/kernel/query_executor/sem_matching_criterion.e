note
	description: "Class that represents a matching criterion in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_MATCHING_CRITERION

inherit
	HASHABLE

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_criterion: like criterion; a_operands: like operands; a_value: like value)
			-- Initialize.
		do
			criterion := a_criterion
			operands := a_operands
			value := a_value
			hash_code := criterion.hash_code
		end

feature -- Access

	criterion: STRING
			-- Text of Current criterion content

	operands: LINKED_LIST [INTEGER]
			-- IDs of operands mentioned in Current criterion.
			-- The order of the operands are the same as their appearing
			-- order in `criterion'

	operand_count: INTEGER
			-- Number of mentioned operands in `criterion'
		do
			Result := operands.count
		ensure
			good_result: Result = operands.count
		end

	value: IR_VALUE
			-- Value of current criterion		

	text: STRING
			-- String representation of Current
		do
			create Result.make (128)
			Result.append (criterion)
			Result.append (once " == ")
			Result.append (value.text)
			Result.append (once ", operands: ")
			across operands as l_operands loop
				Result.append_character (',')
				Result.append (l_operands.item.out)
			end
		end

	term: detachable SEM_TERM
			-- Term associated with current criterion

feature -- Access

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Setting

	set_term (a_term: like term)
			-- Set `term' with `a_term'.
		do
			term := a_term
		ensure
			term_set: term = a_term
		end

end
