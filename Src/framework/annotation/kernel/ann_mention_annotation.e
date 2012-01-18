note
	description: "Annotation signaling that a certain expression or identifier is mentioned."
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_MENTION_ANNOTATION

inherit
	ANN_ANNOTATION
		redefine
			out
		end

create
	make_as_conditional, make_as_mandatory, make_with_arguments

feature {NONE} -- Initialization

	make_as_conditional (a_expression: STRING)
			-- Initialize as conditional `a_expression'.
		do
			make_with_arguments (a_expression, True)
		end

	make_as_mandatory (a_expression: STRING)
			-- Initialize as mandatory `a_expression'.
		do
			make_with_arguments (a_expression, False)
		end

	make_with_arguments (a_expression: STRING; a_conditional: BOOLEAN)
			-- Initialize with arguments.
		do
			expression := a_expression
			is_conditional := a_conditional
		end

feature -- Access

	expression: STRING
			-- Is either a valid identifier e.g. 'var1' or
			-- a valid identifier with feature call e.g. 'var1.feat1'
			-- omitting brackets and arguments.

	ast_of_expression: EXPR_AS
			-- AST representtion of `expression'
		do
			Result := epa_utility.ast_from_expression_text (expression)
		end

	is_conditional: BOOLEAN
			-- States if the `expression' occures conditionally or mandatory.

	hash_code: INTEGER
			-- Hash code value
		do
			Result := out.hash_code
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := out
		end

feature -- Output

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make_empty
			Result.append (once "mentions")
			if is_conditional then
				Result.append (once "_conditionally")
			end
			Result.append (once "(")
			Result.append (expression)
			Result.append (once ")")
		end

feature -- Process

	process (a_visitor: ANN_VISITOR)
			-- Process current with `a_visitor'.
		do
			a_visitor.process_mention_annotation (Current)
		end

feature {NONE} -- Implementaton

	epa_utility: EPA_UTILITY
		once
			create Result
		end
		
end
