note
	description: "Summary description for {EPA_EXPRESSION_SAFE_CREATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EPA_AST_EXPRESSION_SAFE_CREATOR

feature

	safe_create_with_text (a_class: CLASS_C; a_feature: FEATURE_I; a_text: STRING; a_written_class: CLASS_C): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make_with_text (a_class, a_feature, a_text, a_written_class)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create_with_expression (a_expr: EPA_AST_EXPRESSION): EPA_AST_EXPRESSION
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				if a_expr /= Void and then not a_expr.has_syntax_error and then not a_expr.has_type_error then
					create Result.make_with_expression (a_expr)
					if not is_valid_expression (Result) then
						Result := Void
					end
				else
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create_with_text_and_type (a_class: CLASS_C; a_feature: FEATURE_I; a_text: STRING; a_written_class: CLASS_C; a_type: TYPE_A): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make_with_text_and_type (a_class, a_feature, a_text, a_written_class, a_type)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create_with_standard_text_and_type (a_class: CLASS_C; a_feature: FEATURE_I; a_text: STRING; a_written_class: CLASS_C; a_type: TYPE_A): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make_with_standard_text_and_type (a_class, a_feature, a_text, a_written_class, a_type)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create_with_feature (a_class: CLASS_C; a_feature: FEATURE_I; a_expr: EXPR_AS; a_written_class: CLASS_C): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make_with_feature (a_class, a_feature, a_expr, a_written_class)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create (a_ast: EXPR_AS; a_written_class: CLASS_C; a_context_class: CLASS_C): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make (a_ast, a_written_class, a_context_class)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end

	safe_create_with_type (a_class: CLASS_C; a_feature: FEATURE_I; a_expr: EXPR_AS; a_written_class: CLASS_C; a_type: TYPE_A): EPA_AST_EXPRESSION
			--
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create Result.make_with_type (a_class, a_feature, a_expr, a_written_class, a_type)
				if not is_valid_expression (Result) then
					Result := Void
				end
			else
				Result := Void
			end
		rescue
			l_retried := True
			retry
		end


	is_valid_expression (a_expr: EPA_AST_EXPRESSION): BOOLEAN
			--
		do
			Result := not a_expr.has_syntax_error and not a_expr.has_type_error and a_expr.type /= Void
		end

end
