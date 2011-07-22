note
	description: "[
		Class representing a sequence generator annotation
		A sequence generator annotation describes an interface through
		which a sequence of values can be accessed.
		For example:
			from
				list.start
			unitl
				list.after
			loop
				... l.item ...
				l.forth
			end
		In the above snippet, the expression "l.item" is a sequence generator because
		during the loop execution, we can access a sequence of values from "l.item".
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_SEQUENCE_ANNOTATION

inherit
	ANN_ANNOTATION

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_expression: STRING)
			-- Initialize Current.
		do
			expression := a_expression.twin
			create generator_breakpoints.make (2)
		end

feature -- Access

	expression: STRING
			-- Expression of the sequence generator			

	ast: AST_EIFFEL
			-- AST representation of current annotation
		do
			Result := ast_from_expression_text (expression)
		end

	generator_breakpoints: DS_HASH_SET [INTEGER]
			-- The set of breakpoints where current appears

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := expression.hash_code
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := expression
		end

feature -- Process

	process (a_visitor: ANN_VISITOR)
			-- Process current with `a_visitor'.
		do
			a_visitor.process_sequence_annotation (Current)
		end

end
