note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSIONS_TO_EVALUATE_BUILDER

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

create
	make

feature -- Creation procedure

	make (a_class: like class_; a_feature: like feature_)
			-- Set `class_' to `a_class' and `feature_' to `a_feature'
		do
			set_class (a_class)
			set_feature (a_feature)
		end

feature -- Basic operations

	build_from_ast (a_ast: AST_EIFFEL)
			-- Build expressions to evaluate from `a_ast'
		require
			a_ast_not_void: a_ast /= Void
		local
			l_variable_finder: EPA_INTERESTING_VARIABLE_FINDER
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)

			create l_variable_finder.make_with (a_ast)
			l_variable_finder.find
			interesting_variables := l_variable_finder.interesting_variables

			build_from_interesting_variables
		end

	build_from_variables (a_variables: LINKED_LIST [STRING])
			-- Build expressions to evaluate from `a_variables'
		require
			a_variables_not_void: a_variables /= Void
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)
			across a_variables as l_variables loop
				interesting_variables.force_last (l_variables.item)
			end

			build_from_interesting_variables
		end

	build_from_expressions (a_expressions: LINKED_LIST [STRING])
			-- Build expressions to evaluate from `a_expressions'
		require
			a_expressions_not_void: a_expressions /= Void
		local
			l_expr: EPA_AST_EXPRESSION
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)
			across a_expressions as l_exprs loop
				create l_expr.make_with_text (class_, feature_, l_exprs.item, class_)
				expressions_to_evaluate.force_last (l_expr)
			end
		end

feature -- Element change

	set_class (a_class: like class_)
			-- Set `class_' to `a_class'
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' to `a_feature'
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature -- Access

	class_: CLASS_C assign set_class
			-- Class containing the feature which should be analyzed

	feature_: FEATURE_I assign set_feature
			-- Feature which should be analyzed

	expressions_to_evaluate: DS_HASH_SET [EPA_EXPRESSION]
			-- Built expressions to evaluate

feature {NONE} -- Implementation

	interesting_variables: DS_HASH_SET [STRING]
			-- Contains all found interesting variables
			-- with respect to data flow.

feature {NONE} -- Implementation

	build_from_interesting_variables
			-- Build expressions to evaluate from `interesting_variables'
		local
			l_feature_selector: EPA_FEATURE_SELECTOR
			l_expr: EPA_AST_EXPRESSION
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)

			-- Consider only attributes and queries without arguments which are not
			-- inherited from ANY.
			create l_feature_selector.default_create
			l_feature_selector.add_query_selector
			l_feature_selector.add_argumented_feature_selector (0, 0)
			l_feature_selector.add_selector (l_feature_selector.not_from_any_feature_selector)

			if interesting_variables.has ("Current") then
				across local_names_of_feature (feature_).to_array as l_locals loop
					create l_expr.make_with_text (class_, feature_, "Current." + l_locals.item, class_)
					expressions_to_evaluate.force_last (l_expr)
				end
			end

			if interesting_variables.has ("Result") then
				create l_expr.make_with_text (class_, feature_, "Result", class_)
				expressions_to_evaluate.force_last (l_expr)
			end

			-- Set up the expressions to evaluate.
			across interesting_variables.to_array as l_var loop
				create l_expr.make_with_text (class_, feature_, l_var.item, class_)
				l_feature_selector.select_from_class (l_expr.type.associated_class)

				across l_feature_selector.last_features as l_queries loop
					create l_expr.make_with_text (class_, feature_, l_var.item + "." + l_queries.item.feature_name, class_)
					expressions_to_evaluate.force_last (l_expr)
				end
			end
		end

end
