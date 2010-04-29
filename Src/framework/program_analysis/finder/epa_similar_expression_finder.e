note
	description: "[
				Find expressions that are similar to a given expression.
				How do we define similar expressions.
					- Expressions with the same return type
					- ? if the expression is a feature call, find expressoin with the same type as the arguments?
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SIMILAR_EXPRESSION_FINDER

inherit
	EPA_EXPRESSION_FINDER

	REFACTORING_HELPER

	AST_ITERATOR
	redefine
		process_access_feat_as, process_assign_as,process_bin_slash_as,
		process_bin_star_as, process_bin_mod_as, process_bin_power_as,
		process_bin_div_as, process_bin_minus_as, process_bin_plus_as,
		process_bin_and_as, process_bin_and_then_as,process_bin_or_as,
		process_bin_or_else_as,	process_bin_eq_as,	process_bin_ne_as
	end

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	EPA_UTILITY


create
	make

feature{NONE} -- Initialization

	make (a_expression: like expression; a_context_class: like context_class)
			-- Initialze Current.
		do
			expression := a_expression
			context_class := a_context_class
		end


feature -- Access

	expression: EPA_EXPRESSION
			-- Expression whose similar expressions are to be found

	context_class: CLASS_C
			-- Class in which expressions similar to `expression' are to be found

feature --  Basic operations
	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: detachable FEATURE_I
			l_expr: EPA_AST_EXPRESSION
		do
			-- actually if we analyze the features that we iterate on we can get all the features
			-- with the same return type, and if we don't care about feature call to other classes that's enough

--			l_feature := context_class.feature_named (l_as.access_name)
--			if l_feature /= Void and then l_feature.type.is_safe_equivalent (expression.type) then
--				create l_expr.make_with_feature (context_class, l_feature, Void, context_class)
				-- I get some exeption
				-- what feature should I use to store it in the hash?
--				io.put_string (text_from_ast(l_as))
--				io.put_new_line
				--last_found_expressions.force_last (l_expr)
--			end
--			text_from_ast (l_as)
--			l_feature.type.is_equivalent (expression.type)
--			print ("abc")
			precursor(l_as)
		end


	process_assign_as (l_as: ASSIGN_AS)
		local
			l_expr_source, l_expr_target: EPA_AST_EXPRESSION
		do
--			create l_expr_target.make_with_text (context_class, Void, text_from_ast(l_as.target), context_class)
--			-- HOW TO COMPARE THEM?
--			if l_expr_target = expression then
--				create l_expr_source.make_with_text (context_class, Void, text_from_ast(l_as.source), context_class)
--				io.put_string(text_from_ast (l_as.source))
--				io.put_new_line
--				last_found_expressions.put (l_expr)
--			end

			precursor(l_as)
		end

	process_bin_star_as (l_as: BIN_STAR_AS)
		do
			precursor(l_as)
		end

	process_bin_div_as (l_as: BIN_DIV_AS)
		do
			precursor(l_as)
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			precursor(l_as)
		end

	process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			precursor(l_as)
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS)
		local
			l_expr: EPA_AST_EXPRESSION
		do
			-- if we don't want every expression but just the ones that the expression is part of
			-- then a very simple heuristic would be to make a text search to see if expression is there,
			-- would that work for features with arguments
			-- what do we want to get from expression like (count - 1) + (index + 1)

			--EXCEPTION
--			create l_expr.make_with_text (context_class, Void, text_from_ast (l_as), context_class)
--			if expression.type.is_safe_equivalent (l_expr.type) then
--				io.put_string(text_from_ast (l_as))
--				io.put_new_line
--				last_found_expressions.put (l_expr)
--			end
			precursor(l_as)
		end

	process_bin_power_as (l_as: BIN_POWER_AS)
		do
			precursor(l_as)
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			precursor(l_as)
		end

feature -- BOOLEAN OPERATORS
	process_bin_and_as (l_as: BIN_AND_AS)
		do
			-- what do we want from the AND
			-- would it be a good idea to inlude the gt lt processing
			if text_from_ast (l_as).has_substring ( expression.text ) then
--				io.put_string (text_from_ast (l_as))
--				io.put_new_line
			end

			precursor(l_as)
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			precursor(l_as)
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			precursor(l_as)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			precursor(l_as)
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			precursor(l_as)
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			precursor(l_as)
		end

feature -- inherited

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
		local
			l_features: LIST [FEATURE_I]
			l_expr: EPA_AST_EXPRESSION
			l_feat: FEATURE_I
		do
				-- Create empty `last_found_expressions'.
			create last_found_expressions.make (100)
			last_found_expressions.set_equality_tester (expression_equality_tester)

				-- Go through the ASTs of all features in `context_class',
				-- searching for similar expressions.
			from
				l_features := features_in_class (context_class, Void)
				l_features.start
			until
				l_features.after
			loop
				l_feat := l_features.item_for_iteration
				if l_feat.type.is_safe_equivalent (expression.type) and then l_feat.argument_count = 0 then
					io.put_string (l_features.item_for_iteration.feature_name)
					io.put_new_line

					create l_expr.make_with_text (context_class, l_features.item_for_iteration, l_features.item_for_iteration.feature_name, context_class)
					-- strange hashing exception
--					last_found_expressions.put (l_expr)
				end
				l_features.item_for_iteration.e_feature.ast.process (Current)
				l_features.forth
			end
		end

end
