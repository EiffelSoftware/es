note
	description: "Class to build expressions which are evaluated during dynamic program analysis."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_EXPRESSION_BUILDER

inherit
	EPA_SHARED_EQUALITY_TESTERS
		rename
			pointer_type as shared_pointer_type
		end

	EPA_UTILITY
		rename
			pointer_type as shared_pointer_type
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_)
			-- Initialize `class_' with `a_class', `feature_' with `a_feature'
		do
			set_class (a_class)
			set_feature (a_feature)
		end

feature -- Basic operations

	build_from_variables
			-- Build expressions to evaluate from `a_variables'
		require
			interesting_variables_not_void: interesting_variables /= Void
		local
			l_feature_selector: EPA_FEATURE_SELECTOR
			l_expr: EPA_AST_EXPRESSION
			l_locals, l_set, l_tmp_set: DS_HASH_SET [STRING]
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)

			create vars_with_exprs.make_default

			-- Consider only attributes and queries without arguments which are not
			-- inherited from ANY.
			create l_feature_selector.default_create
			l_feature_selector.add_query_selector
			l_feature_selector.add_argumented_feature_selector (0, 0)
			l_feature_selector.add_selector (l_feature_selector.not_from_any_feature_selector)

			-- Case unqualified calls detected			
			if interesting_variables.has (ti_current) then
				create l_expr.make_with_text (class_, feature_, ti_current, class_)
				if not is_file_type (l_expr.type) and not is_pointer_type (l_expr.type) and not is_basic_type (l_expr.type) and not is_string_type (l_expr.type) then
					create l_set.make_default
					l_set.set_equality_tester (string_equality_tester)
					l_locals := local_names_of_feature (feature_)
					from
						l_locals.start
					until
						l_locals.after
					loop
						create l_expr.make_with_text (class_, feature_, l_locals.item_for_iteration, class_)
						expressions_to_evaluate.force_last (l_expr)
						l_set.force_last (l_expr.text)

						l_locals.forth
					end
					if vars_with_exprs.has (ti_current) then
						l_tmp_set := vars_with_exprs.item (ti_current)
						l_set.do_all (agent l_tmp_set.force_last)
					else
						vars_with_exprs.force_last (l_set, ti_current)
					end
				end
			end

			-- Case `Result' detected
			if interesting_variables.has (ti_result) then
				create l_expr.make_with_text (class_, feature_, ti_result, class_)
				if not is_file_type (l_expr.type) then
					create l_expr.make_with_text (class_, feature_, ti_result, class_)
					expressions_to_evaluate.force_last (l_expr)
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

			-- Case variables from calls
			from
				interesting_variables.start
			until
				interesting_variables.after
			loop
				create l_expr.make_with_text (class_, feature_, interesting_variables.item_for_iteration, class_)
				if not is_file_type (l_expr.type) and not is_pointer_type (l_expr.type) and not is_basic_type (l_expr.type) and not is_string_type (l_expr.type) then
					create l_set.make_default
					l_set.set_equality_tester (string_equality_tester)
					l_set.force_last (l_expr.text)
					expressions_to_evaluate.force_last (l_expr)

					l_feature_selector.select_from_class (l_expr.type.associated_class)

					across l_feature_selector.last_features as l_queries loop
						create l_expr.make_with_text (class_, feature_, interesting_variables.item_for_iteration + "." + l_queries.item.feature_name, class_)
						expressions_to_evaluate.force_last (l_expr)
						l_set.force_last (l_expr.text)
					end

					if vars_with_exprs.has (interesting_variables.item_for_iteration) then
						l_tmp_set := vars_with_exprs.item (interesting_variables.item_for_iteration)
						l_set.do_all (agent l_tmp_set.force_last)
					else
						vars_with_exprs.force_last (l_set, interesting_variables.item_for_iteration)
					end
				end
				interesting_variables.forth
			end

			if attached {DS_HASH_SET [STRING]} interesting_variables_from_assignments then
				-- Case variables from assignments
				from
					interesting_variables_from_assignments.start
				until
					interesting_variables_from_assignments.after
				loop
					create l_expr.make_with_text (class_, feature_, interesting_variables_from_assignments.item_for_iteration, class_)
					if not is_file_type (l_expr.type) and not is_pointer_type (l_expr.type) then
						create l_set.make_default
						l_set.set_equality_tester (string_equality_tester)
						l_set.force_last (l_expr.text)

						expressions_to_evaluate.force_last (l_expr)

						if vars_with_exprs.has (interesting_variables_from_assignments.item_for_iteration) then
							l_tmp_set := vars_with_exprs.item (interesting_variables_from_assignments.item_for_iteration)
							l_set.do_all (agent l_tmp_set.force_last)
						else
							vars_with_exprs.force_last (l_set, interesting_variables_from_assignments.item_for_iteration)
						end
					end

					interesting_variables_from_assignments.forth
				end
			end
		end

	build_from_expressions
			-- Build expressions to evaluate from `a_expressions'
		require
			interesting_expressions_not_void: interesting_expressions /= Void
		local
			l_expr: EPA_AST_EXPRESSION
			l_expr_string: STRING
			l_var: STRING
		do
			create expressions_to_evaluate.make_default
			expressions_to_evaluate.set_equality_tester (expression_equality_tester)
			from
				interesting_expressions.start
			until
				interesting_expressions.after
			loop
				l_expr_string := interesting_expressions.item_for_iteration
				if l_expr_string.has ('.') then
					l_var := l_expr_string.split ('.').i_th (1)
				else
					l_var := l_expr_string
				end
				create l_expr.make_with_text (class_, feature_, l_var, class_)
				if not is_file_type (l_expr.type) then
					create l_expr.make_with_text (class_, feature_, interesting_expressions.item_for_iteration, class_)
					expressions_to_evaluate.force_last (l_expr)
				end

				interesting_expressions.forth
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

	set_interesting_variables (a_interesting_variables: like interesting_variables)
			-- Set `interesting_variables' to `a_interesting_variables'
		require
			a_interesting_variables_not_void: a_interesting_variables /= Void
		do
			interesting_variables := a_interesting_variables
		ensure
			interesting_variables_set: interesting_variables = a_interesting_variables
		end

	set_interesting_variables_from_assignments (a_interesting_variables_from_assignments: like interesting_variables_from_assignments)
			-- Set `interesting_variables_from_assignments' to `a_interesting_variables_from_assignments'
		require
			a_interesting_variables_from_assignments_not_void: a_interesting_variables_from_assignments /= Void
		do
			interesting_variables_from_assignments := a_interesting_variables_from_assignments
		ensure
			interesting_variables_from_assignments_set: interesting_variables_from_assignments = a_interesting_variables_from_assignments
		end

	set_interesting_expressions (a_interesting_expressions: like interesting_expressions)
			-- Set `interesting_expressions' to `a_interesting_expressions'
		require
			a_interesting_expressions_not_void: a_interesting_expressions /= Void
		do
			interesting_expressions := a_interesting_expressions
		ensure
			interesting_expressions_set: interesting_expressions = a_interesting_expressions
		end

feature -- Access

	class_: CLASS_C
			-- Class containing the feature which should be analyzed

	feature_: FEATURE_I
			-- Feature which should be analyzed

	expressions_to_evaluate: DS_HASH_SET [EPA_EXPRESSION]
			-- Built expressions to evaluate

	vars_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Mapping of variables to expressions
			-- Keys are variables and values are expressions derived
			-- from a variable.

	interesting_variables: DS_HASH_SET [STRING]
			-- Interesting variables used to build expressions for evaluation.

	interesting_variables_from_assignments: DS_HASH_SET [STRING]
			-- Interesting variables from assignments used to build expressions for evaluation.

	interesting_expressions: DS_HASH_SET [STRING]
			-- Interesting expressions used to build expressions for evaluation.

feature {NONE} -- Implementation

	is_basic_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to one of the types contained
			-- in `basic_types'?
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
			-- Is `a_type' conforming to one of the types contained
			-- in `string_types'?
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

	is_pointer_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to the type specified
			-- by `pointer_type'?
		require
			a_type_not_void: a_type /= Void
		local
			l_classes: LIST [CLASS_I]
			l_found: BOOLEAN
			l_class: CLASS_I
			l_type: TYPE_A
		do
			l_classes := universe.classes_with_name (pointer_type)
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

	is_file_type (a_type: TYPE_A): BOOLEAN
			-- Is `a_type' conforming to the type specified
			-- by `file_type'?
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

	basic_types: ARRAY [STRING]
			-- Basic types
		once
			create Result.make_from_array (<<
				"BOOLEAN",
				"NATURAL_8",
				"NATURAL_16",
				"NATURAL_32",
				"NATURAL_64",
				"INTEGER_8",
				"INTEGER_16",
				"INTEGER_32",
				"INTEGER_64",
				"REAL_32",
				"REAL_64",
				"CHARACTER_8",
				"CHARACTER_32"
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

	pointer_type: STRING = "POINTER"
			-- Pointer type

	file_type: STRING = "FILE"
			-- File type

	eiffelbase_cluster_name: STRING = "elks"
			-- Name of the Eiffelbase cluster

end
