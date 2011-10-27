note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSIONS_TO_EVALUATE_BUILDER

inherit
	AST_ITERATOR
		redefine
			process_access_id_as,
			process_create_creation_as,
			process_nested_as,
			process_assign_as,
			process_assigner_call_as,
			process_access_feat_as,
			process_if_as,
			process_loop_as,
			process_result_as
		end

	KL_SHARED_STRING_EQUALITY_TESTER

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

	build_from_ast (a_ast: like ast)
			-- Find all interesting variables and make them available
			-- in `interesting_variables'
		do
			create interesting_variables.make_default
			interesting_variables.set_equality_tester (string_equality_tester)

			ast.process (Current)

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

feature -- Process operations

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if is_nested then
				if not l_as.access_name_8.is_equal ("io") then
					interesting_variables.force_last (l_as.access_name_8)
				end
			elseif is_creation_procedure then
				interesting_variables.force_last (l_as.access_name_8)
			else
				interesting_variables.force_last ("Current")
			end
			process_access_feat_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			is_creation_procedure := True
			process_creation_as (l_as)
			is_creation_procedure := False
		end

	process_nested_as (l_as: NESTED_AS)
		do
			is_nested := True
			l_as.target.process (Current)
			is_nested := False
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			l_as.target.process (Current)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			l_as.target.process (Current)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			-- Nothing to be done
		end

	process_if_as (l_as: IF_AS)
		do
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.compound)
		end

	process_result_as (l_as: RESULT_AS)
		do
			interesting_variables.force_last ("Result")
		end

feature -- Access

	class_: CLASS_C
			--

	feature_: FEATURE_I
			--

	expressions_to_evaluate: DS_HASH_SET [EPA_EXPRESSION]
			--

feature {NONE} -- Implementation

	ast: AST_EIFFEL
			-- AST which is used to collect interesting variables

	interesting_variables: DS_HASH_SET [STRING]
			-- Contains all found interesting variables
			-- with respect to data flow.

	is_nested: BOOLEAN
			-- Is the current node part of a NESTED_AS node?

	is_creation_procedure: BOOLEAN
			-- Is the current node part of a creation procedure?

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
