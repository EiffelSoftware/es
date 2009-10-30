note
	description: "State item based on an expression AST node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXPR_STATE_ITEM

inherit
	AFX_STATE_ITEM
		redefine
			type
		end

	SHARED_EIFFEL_PARSER

	AFX_SHARED_EXPR_TYPE_CHECKER

	SHARED_SERVER

create
	make,
	make_with_text,
	make_with_expression

feature{NONE} -- Initialization

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_text (a_text)
			parse_text
			if not has_syntax_error then
				check_type
			end
		end

	make_with_expression (a_class: like class_; a_feature: like feature_; a_expression: like expression)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_expression (a_expression)
			set_text ("")
			check_type
		end

	make (a_class: like class_; a_feature: like feature_; a_expression: like expression; a_type: like type)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_expression (a_expression)
			set_type (a_type)
			has_syntax_error := a_expression = Void
		end

feature -- Access

	text: STRING_8
			-- A text form representing `expression'

	expression: detachable EXPR_AS
			-- Expression AST node of current item

	value: detachable ANY
			-- Value current item
		do
		end

	name: STRING
			-- Name of current item
		do
		end


	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.

feature -- Status report

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.
		do
			Result := not has_syntax_error
		end

	has_syntax_error: BOOLEAN
			-- Does `text' contain syntex error?

	is_boolean_type: BOOLEAN is
			-- Is `expression' of boolean type?
		do
			Result := is_valid and then type /= Void and then type.is_boolean
		end

	is_integer_type: BOOLEAN is
			-- Is `expression' of integer type?
		do
			Result := is_valid and then type /= Void and then type.is_integer
		end

feature -- Debug output

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (32)
			Result.append (name)
			Result.append (once " : ")
			Result.append (value.out)
		end

feature -- Setting

	set_expression (a_expression: like expression)
			-- Set `expression' with `a_expression'.
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end

	set_text (a_text: like text)
			-- Set `text' with `a_text'.
		do
			text := a_text.twin
		end

	set_type (a_type: like type)
			-- Set `type' with `a_type'.
		do
			type := a_type
		ensure
			type_set: type = a_type
		end

feature{NONE} -- Implementation

	set_has_syntax_error (b: BOOLEAN)
			-- Set `has_syntax_error' with `b'.
		do
			has_syntax_error := b
		ensure
			has_syntax_error_set: has_syntax_error = b
		end

	check_type is
			-- Check type of `expression', store type in `type'.
		require
			syntax_correct: not has_syntax_error
		do
			expression_type_checker.check_expression (expression, class_, feature_)
			type := expression_type_checker.last_type
		end

	parse_text is
			-- Parse `text' and set `expression' with the parsing result.
			-- Set `has_syntax_error' to True if `text' contains syntax error.
		local
			l_parser: like expression_parser
		do
				-- Parse `text' into `expression'.
			l_parser := expression_parser
			l_parser.set_syntax_version (l_parser.transitional_64_syntax)
			l_parser.parse_from_string (once "check " + text, class_)
			set_has_syntax_error (l_parser.syntax_error)

			if has_syntax_error then
				expression := Void
			else
				expression := l_parser.expression_node
			end
		end

end
