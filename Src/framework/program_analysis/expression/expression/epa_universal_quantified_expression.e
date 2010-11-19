note
	description: "Summary description for {EPA_UNIVERSAL_QUANTIFIED_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_UNIVERSAL_QUANTIFIED_EXPRESSION

inherit
	EPA_QUANTIFIED_EXPRESSION
		redefine
			is_valid,
			is_ast_available,
			is_universal_quantified,
			quantifier_name,
			type
		end

create
	make,
	make_from_ast

feature -- Access

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := text.hash_code
		end

	type: TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.

	text_in_context (a_context_class: CLASS_C): STRING
			-- Text viewed from `a_context_class',
			-- with all kinds of renaming resolved
		do
			Result := text_with_predicate (predicate.text_in_context (a_context_class))
		end

feature -- Status report

	is_universal_quantified: BOOLEAN = True
			-- Is Current expression universally quantified?


	is_ast_available: BOOLEAN = True
			-- Is `ast' available?

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.

feature -- Visitor/Process

	process (a_visitor: EPA_EXPRESSION_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_universal_quantified_expression (Current)
		end

feature{NONE} -- Implementation

	quantifier_name: STRING
			-- <Precursor>
		do
			Result := ti_for_all_keyword
		end

feature{NONE} -- Implementation

	build_ast (a_variable_name: STRING; a_type: TYPE_A; a_expression: EXPR_AS)
			-- Build `ast' from `a_variable_name' and `a_expression'
		do
			build_ast_internal (a_variable_name, a_type, a_expression, True)
		end

end
