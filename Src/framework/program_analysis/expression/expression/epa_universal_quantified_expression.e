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
	make

feature{NONE} -- Initialization

	make (a_variable: STRING; a_variable_type: TYPE_A; a_predicate: like predicate; a_class: like class_; a_feature: like feature_; a_written_class: like written_class)
			-- Initialize Current.
		do
			create variables.make (1)
			variables.compare_objects
			variables.put (a_variable_type, a_variable.twin)
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			predicate := a_predicate
			text := text_internal
			create {BOOLEAN_A} type
		end

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

	ast: EXPR_AS
			-- AST node for `text'
		do
		end

	type: TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.

feature -- Status report

	is_universal_quantified: BOOLEAN = True
			-- Is Current expression universally quantified?


	is_ast_available: BOOLEAN = False
			-- Is `ast' available?

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.

feature{NONE} -- Implementation

	quantifier_name: STRING = "forall"
			-- <Precursor>

end
