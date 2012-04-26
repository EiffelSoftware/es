note
	description: "Class to build expressions which are evaluated during dynamic program analysis."
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

feature -- Initialization

	make (a_class: like class_; a_feature: like feature_)
			-- Initialize `class_' with `a_class' and `feature_' with `a_feature'
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
			a_variables.do_all (agent interesting_variables.force_last)

			build_from_interesting_variables
		end

	build_from_expressions (a_expressions: LINKED_LIST [STRING])
			-- Build expressions to evaluate from `a_expressions'
		require
			a_expressions_not_void: a_expressions /= Void
		local
			l_expr: EPA_AST_EXPRESSION
			l_expr_string: STRING
			l_var: STRING
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)
			across a_expressions as l_exprs loop
				l_expr_string := l_exprs.item
				if l_expr_string.has ('.') then
					l_var := l_expr_string.split ('.').i_th (1)
				else
					l_var := l_expr_string
				end
				create l_expr.make_with_text (class_, feature_, l_var, class_)
				if not is_file_type (l_expr.type) then
					create l_expr.make_with_text (class_, feature_, l_exprs.item, class_)
					expressions_to_evaluate.force_last (l_expr)
				end
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

	store_vars_exprs_mapping (b: BOOLEAN)
			--
		do
			is_storage_of_vars_exprs_mapping_activated := b
		ensure
			is_storage_of_vars_exprs_mapping_activated_set: is_storage_of_vars_exprs_mapping_activated = b
		end

feature -- Access

	class_: CLASS_C assign set_class
			-- Class containing the feature which should be analyzed

	feature_: FEATURE_I assign set_feature
			-- Feature which should be analyzed

	is_storage_of_vars_exprs_mapping_activated: BOOLEAN
			--

	expressions_to_evaluate: DS_HASH_SET [EPA_EXPRESSION]
			-- Built expressions to evaluate

	vars_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			--

feature {NONE} -- Implementation

	interesting_variables: DS_HASH_SET [STRING]
			-- Contains all found interesting variables
			-- with respect to data flow.

feature {NONE} -- Implementation

	is_basic_type (a_type: TYPE_A): BOOLEAN
			--
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			Result := False
			across basic_types as l_types loop
				l_classes := universe.classes_with_name (l_types.item)
				l_type := Void
				from
					l_classes.start
					l_found := False
				until
					l_classes.after or l_found
				loop
					l_class := l_classes.item
					if attached {EIFFEL_CLASS_I} l_class as l_eiffel_class then
						if l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name) then
							l_type := l_eiffel_class.compiled_representation.actual_type
							l_found := True
						end
					end
					l_classes.forth
				end
				if l_type /= Void then
					Result := Result or is_type_conformant_in_application_context (a_type, l_type)
				end
			end
		end

	is_string_type (a_type: TYPE_A): BOOLEAN
			--
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			Result := False
			across string_types as l_types loop
				l_classes := universe.classes_with_name (l_types.item)
				l_type := Void
				from
					l_classes.start
					l_found := False
				until
					l_classes.after or l_found
				loop
					l_class := l_classes.item
					if attached {EIFFEL_CLASS_I} l_class as l_eiffel_class then
						if l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name) then
							l_type := l_eiffel_class.compiled_representation.actual_type
							l_found := True
						end
					end
					l_classes.forth
				end
				if l_type /= Void then
					Result := Result or is_type_conformant_in_application_context (a_type, l_type)
				end
			end
		end

	is_file_type (a_type: TYPE_A): BOOLEAN
			--
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			l_classes := universe.classes_with_name (file_type)
			from
				l_classes.start
				l_found := False
			until
				l_classes.after or l_found
			loop
				l_class := l_classes.item
				if attached {EIFFEL_CLASS_I} l_class as l_eiffel_class then
					if l_eiffel_class.cluster.cluster_name.is_equal (Eiffelbase_cluster_name) then
						l_type := l_eiffel_class.compiled_representation.actual_type
						l_found := True
					end
				end
				l_classes.forth
			end
			Result := is_type_conformant_in_application_context (a_type, l_type)
		end

feature {NONE} -- Implementation

	build_from_interesting_variables
			-- Build expressions to evaluate from `interesting_variables'
		local
			l_feature_selector: EPA_FEATURE_SELECTOR
			l_expr: EPA_AST_EXPRESSION
			l_set, l_tmp_set: DS_HASH_SET [STRING]
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)

			if is_storage_of_vars_exprs_mapping_activated then
				create vars_with_exprs.make_default
			end

			-- Consider only attributes and queries without arguments which are not
			-- inherited from ANY.
			create l_feature_selector.default_create
			l_feature_selector.add_query_selector
			l_feature_selector.add_argumented_feature_selector (0, 0)
			l_feature_selector.add_selector (l_feature_selector.not_from_any_feature_selector)

			if interesting_variables.has (ti_current) then
				create l_expr.make_with_text (class_, feature_, ti_current, class_)
				if not is_file_type (l_expr.type) and not is_basic_type (l_expr.type) and not is_string_type (l_expr.type) then
					if is_storage_of_vars_exprs_mapping_activated then
						create l_set.make_default
						l_set.set_equality_tester (string_equality_tester)
					end
					across local_names_of_feature (feature_).to_array as l_locals loop
						create l_expr.make_with_text (class_, feature_, l_locals.item, class_)
						expressions_to_evaluate.force_last (l_expr)
						if is_storage_of_vars_exprs_mapping_activated then
							l_set.force_last (l_expr.text)
						end
					end
					if is_storage_of_vars_exprs_mapping_activated then
						if vars_with_exprs.has (ti_current) then
							l_tmp_set := vars_with_exprs.item (ti_current)
							l_set.do_all (agent l_tmp_set.force_last)
						else
							vars_with_exprs.force_last (l_set, ti_current)
						end
					end
				end
			end

			if interesting_variables.has (ti_result) then
				create l_expr.make_with_text (class_, feature_, ti_result, class_)
				if not is_file_type (l_expr.type) then
					create l_expr.make_with_text (class_, feature_, ti_result, class_)
					expressions_to_evaluate.force_last (l_expr)
					if is_storage_of_vars_exprs_mapping_activated then
						if vars_with_exprs.has (ti_result) then
							vars_with_exprs.item (ti_result).force_last (l_expr.text)
						else
							create l_set.make_default
							l_set.set_equality_tester (string_equality_tester)
							l_set.force_last (l_expr.text)
							vars_with_exprs.force_last (l_set, ti_result)
						end
					end
				end
			end

			-- Set up the expressions to evaluate.
			across interesting_variables.to_array as l_var loop
				create l_expr.make_with_text (class_, feature_, l_var.item, class_)
				if not is_file_type (l_expr.type) and not is_basic_type (l_expr.type) and not is_string_type (l_expr.type) then
					if is_storage_of_vars_exprs_mapping_activated then
						create l_set.make_default
						l_set.set_equality_tester (string_equality_tester)
					end
					l_feature_selector.select_from_class (l_expr.type.associated_class)

					across l_feature_selector.last_features as l_queries loop
						create l_expr.make_with_text (class_, feature_, l_var.item + "." + l_queries.item.feature_name, class_)
						expressions_to_evaluate.force_last (l_expr)
						if is_storage_of_vars_exprs_mapping_activated then
							l_set.force_last (l_expr.text)
						end
					end
					if is_storage_of_vars_exprs_mapping_activated then
						if vars_with_exprs.has (l_var.item) then
							l_tmp_set := vars_with_exprs.item (l_var.item)
							l_set.do_all (agent l_tmp_set.force_last)
						else
							vars_with_exprs.force_last (l_set, l_var.item)
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	basic_types: ARRAY [STRING]
			-- Basic types
		once
			create Result.make_from_array (<<
				"BOOLEAN",
				"INTEGER_8",
				"INTEGER_16",
				"INTEGER_32",
				"INTEGER_64",
				"CHARACTER_8",
				"CHARACTER_32",
				"STRING_8",
				"STRING_32",
				"REAL_32",
				"REAL_64",
				"POINTER"
			>>)
		end

	string_types: ARRAY [STRING]
			-- String types
		once
			create Result.make_from_array (<<
				"STRING_8",
				"STRING_32"
			>>)
		end

	file_type: STRING = "FILE"
			-- Name of the file class

	eiffelbase_cluster_name: STRING = "elks"
			-- Name of the Eiffelbase cluster

end
