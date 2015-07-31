
note
	description: "State item based on an expression AST node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AST_EXPRESSION

inherit
	EPA_EXPRESSION
		redefine
			type,
			is_true_expression,
			is_false_expression
		end

	SHARED_EIFFEL_PARSER
		undefine
			is_equal
		end

	EPA_SHARED_EXPR_TYPE_CHECKER
		undefine
			is_equal
		end

	SHARED_SERVER
		undefine
			is_equal
		end

create
	make,
	make_with_text,
	make_with_expression,
	make_with_text_and_type,
	make_with_type,
	make_with_feature,
	make_with_standard_text_and_type

feature{NONE} -- Initialization

	make_with_expression (a_expr: EPA_AST_EXPRESSION)
		require
			expr_correct: a_expr /= Void and then not a_expr.has_syntax_error and then not a_expr.has_type_error
		do
			set_class (a_expr.class_)
			set_feature (a_expr.feature_)
			set_written_class (a_expr.written_class)
			set_type (a_expr.type)
			set_text (a_expr.text)
			ast := a_expr.ast
		end

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			parse_text (a_text)
			if not has_syntax_error then
				set_text (text_from_ast (ast))
				fixme ("This is a hack, because for the moment, the type checker crashes quite often on expressions with {G}. 21.2.2011 Jasonw")
				if not a_text.has ('{') then
					check_type
				end
			else
				check should_not_happen: False end
			end
		end

	make_with_text_and_type (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_type: like type)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			parse_text (a_text)
			set_type (a_type)
			if not has_syntax_error then
				set_text (a_text)
			else
				check should_not_happen: False end
			end
		end

	make_with_standard_text_and_type (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_type: like type)
			-- Initialize Current.
			-- `a_text' is standard, meaning that it is already pretty-printed.
			-- Standard text are used to compare expression equatity, so it is very important to make sure
			-- `a_text' is standard.
			-- This creation procedure is fast because it does not do type-checking and AST-to-text generation.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			parse_text (a_text)
			set_type (a_type)
			if not has_syntax_error then
				set_text (text_from_ast (ast))
			else
				check should_not_happen: False end
			end
		end

	make_with_feature (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			set_expression (a_expression)
			has_syntax_error := a_expression = Void
			if not has_syntax_error then
				check_type
				set_text (text_from_ast (a_expression))
			else
				check should_not_happen: False end
			end
		end

	make (a_expr: like ast; a_written_class: like written_class; a_context_class: like class_)
			-- Initialize Current.
		do
			make_with_feature (a_context_class, Void, a_expr, a_written_class)
		end

	make_with_type (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class; a_type: like type)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			set_expression (a_expression)
			has_syntax_error := False
			set_type (a_type)
			set_text (text_from_ast (a_expression))
		end

feature -- Access

	text: STRING_8
			-- A text form representing `ast'

	ast: detachable EXPR_AS
			-- Expression AST node of current item

	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			if hash_code_cache = 0 then
				hash_code_cache := text.hash_code
			end
			Result := hash_code_cache
		end

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

	has_type_error: BOOLEAN
			-- Does Current have type error?

	is_true_expression: BOOLEAN
			-- Does current expression represent "True"?
		do
			Result := attached {STRING} text as l_text and then l_text.is_case_insensitive_equal ("True")
		end

	is_false_expression: BOOLEAN
			-- Does current expression represent "False"?
		do
			Result := attached {STRING} text as l_text and then l_text.is_case_insensitive_equal ("False")
		end

feature -- Debug output

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Setting

	set_expression (a_expression: like ast)
			-- Set `ast' with `a_expression'.
		do
			ast := a_expression
		ensure
			expression_set: ast = a_expression
		end

	set_text (a_text: like text)
			-- Set `text' with `a_text'.
		do
			text := a_text.twin
		end

	set_type (a_type: like type)
			-- Set `type' with `a_type'.
		require
			type_attached: a_type /= Void
		do
			type := a_type.actual_type
		ensure
			type_set: type = a_type
		end

feature -- Visitor/Process

	process (a_visitor: EPA_EXPRESSION_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_ast_expression (Current)
		end

feature{NONE} -- Implementation

	set_has_syntax_error (b: BOOLEAN)
			-- Set `has_syntax_error' with `b'.
		do
			has_syntax_error := b
		ensure
			has_syntax_error_set: has_syntax_error = b
		end

	set_has_type_error (b: BOOLEAN)
			-- Set `has_type_error' with `b'.
		do
			has_type_error := b
		ensure
			has_type_error_set: has_type_error = b
		end

	check_type
			-- Check type of `ast', store type in `type'.
		require
			syntax_correct: not has_syntax_error
		local
			l_check_post: BOOLEAN
			l_checker: like expression_type_checker
			l_error_handler: like etr_error_handler
		do
			l_error_handler := etr_error_handler
			l_error_handler.reset_errors
			l_checker := expression_type_checker
			l_check_post := l_checker.is_checking_postcondition
			l_checker.set_is_checking_postcondition (has_old_expression)

				-- Shall we use `Void' or `written_class' for the last argument of the `check_expression_type' call??
			l_checker.check_expression_type (ast, feature_, class_, written_class)
			l_checker.set_is_checking_postcondition (l_check_post)
			type := l_checker.last_type

--			l_checker.check_ast_type (ast, context)
--			l_checker.set_is_checking_postcondition (l_check_post)
--			set_has_type_error (l_error_handler.has_errors)
--			if not has_type_error then
--				type := l_checker.last_type.actual_type
--			end
		ensure
			type_attached: not has_type_error implies type /= Void
		end

	parse_text (a_text: STRING)
			-- Parse `a_text' and set `ast' with the parsing result.
			-- Set `has_syntax_error' to True if `a_text' contains syntax error.
		require
			a_text_attached: a_text /= Void
		local
			l_parser: like parser
		do
				-- Parse `a_text' into `ast'.
			l_parser := parser
			l_parser.set_has_old_expression (False)
			l_parser.set_syntax_version (l_parser.provisional_syntax)
			l_parser.parse_from_utf8_string (once "check " + a_text, class_)
			set_has_syntax_error (l_parser.syntax_error)

			if has_syntax_error then
				ast := Void
			else
				has_old_expression := l_parser.has_old_expression
				ast := l_parser.expression_node
			end
		end

feature{NONE} -- Implementation

	hash_code_cache: INTEGER
			-- Cache for `hash_code'

	has_old_expression: BOOLEAN
			-- Does `text' contain old expression?

	parser: EPA_EIFFEL_PARSER
			-- Parser used for parsing expressions
		once
			create Result.make_with_factory (create {EPA_EXPRESSION_AST_FACTORY})
			Result.set_expression_parser
		end

end
