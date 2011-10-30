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
			--
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			class_ := a_class
			feature_ := a_feature
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
		end

feature -- Basic operations

	build_from_ast (a_ast: AST_EIFFEL)
			-- Find all interesting variables and make them available
			-- in `interesting_variables'
		local
			l_variable_finder: EPA_INTERESTING_VARIABLE_FINDER
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)

			create l_variable_finder.make_with (a_ast)
			l_variable_finder.find
			interesting_variables := l_variable_finder.interesting_variables

			build
		end

	build_from_variables (a_variables: LINKED_LIST [STRING])
			--
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)
			across a_variables as l_variables loop
				interesting_variables.force_last (l_variables.item)
			end

			build
		end

feature -- Access

	class_: CLASS_C
			--

	feature_: FEATURE_I
			--

	expressions_to_evaluate: DS_HASH_SET [EPA_EXPRESSION]
			--

feature {NONE} -- Implementation

	interesting_variables: DS_HASH_SET [STRING]
			-- Contains all found interesting variables
			-- with respect to data flow.

feature {NONE} -- Implementation

	build
			--
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
