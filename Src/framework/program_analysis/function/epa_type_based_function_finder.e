note
	description: "[
		Class to find function for a feature based on types of variables in the given context. 
		Those functions are buiding blocks for contracts to be inferred
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TYPE_BASED_FUNCTION_FINDER

inherit
	EPA_FUNCTION_FINDER

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_ACCESS_AGENT_UTILITY

	SHARED_TYPES

create
	make_for_feature,
	make_for_variables

feature{NONE} -- Initialization

	make (a_output_directory: like output_directory)
			-- Initialize Current.
		do
			should_solve_integer_argument_bound := a_output_directory /= Void
			if a_output_directory /= Void then
				output_directory := a_output_directory.twin
			else
				output_directory := Void
			end
			should_search_for_query_with_arguments := True
		end

	make_for_feature (a_class: like context_class; a_feature: like feature_; a_operand_map: like operand_map; a_context: like context; a_output_directory: like output_directory; a_context_type: like context_type)
			-- Initialize Current for feature `a_feature'.
		do
			context_type := a_context_type
			set_class_and_feature (a_class, a_feature)
			set_context (a_context, a_operand_map)
			make (a_output_directory)
			is_for_feature := True
		end

	make_for_variables (a_variables: HASH_TABLE [TYPE_A, STRING]; a_output_directory: like output_directory)
			-- Initialize Current to find expressions among variables specified in `a_variables'.
			-- `a_variables' is a table, key is variable name, value is variable type.
		require
			a_variables_valid: a_variables.object_comparison
		local
			l_context: EPA_CONTEXT
			l_operand_map: like operand_map
		do
			create l_context.make (a_variables)
			create l_operand_map.make (0)
			set_class_and_feature (l_context.class_, l_context.feature_)
			set_context (l_context, l_operand_map)
			is_for_variables := True
			make (a_output_directory)
			context_type := l_context.class_.actual_type
		end

feature -- Access/Search scope

	feature_: FEATURE_I
			-- Feature

	context_class: CLASS_C
			-- Context class

	context: EPA_CONTEXT
			-- Context which provides all available variables.

	operand_map: HASH_TABLE [STRING, INTEGER]
			-- Map from 0-based operand index to name of variables in `context'
			-- This a map from operand index to variable name,
			-- key is operand index in `feature_', 0 means target, 1 means arguments, followed by result, if any,
			-- value is name of that operand as seen in `context'.
			-- `operand_map' is needed because for a given test case, which variables are used as which operands in the called
			-- feature is already fixed, the same ordering needs to be consistent with the generated functions.

	context_type: TYPE_A
			-- Context type where types are resolved

feature -- Status

	is_query: BOOLEAN
			-- Is `feature_' a query?
		do
			Result := feature_.has_return_value
		end

	is_creation: BOOLEAN
			-- Is `feature_' used as a creation procedure?

	is_for_pre_execution: BOOLEAN
			-- Are functions used a pre-execution evaluation?
			-- For pre-execution evaluation, functions such as "Result", and
			-- target object (if `feature_' is a creation procedure) are not included

	should_solve_integer_argument_bound: BOOLEAN
			-- Should bounds of integer arguments be solved?

	should_search_for_query_with_arguments: BOOLEAN
			-- Should search for queries with arguments?
			-- Default: True

	should_search_for_query_with_precondition: BOOLEAN
			-- Should search for queries with preconditions?
			-- Default: True	

	should_include_tilda_expressions: BOOLEAN
			-- Should tilda expressions be included?
			-- For example "v1 ~ v2" and "v1 /~ v2".
			-- Default: False

feature -- Setting

	set_should_include_tilda_expressions (b: BOOLEAN)
			-- Set `should_include_tilda_expressions' with `b'.
		do
			should_include_tilda_expressions := b
		ensure
			should_include_tilda_expressions_set: should_include_tilda_expressions = b
		end

	set_class_and_feature (a_class: like context_class; a_feature: like feature_)
			-- Set `context_class' and `feature_'.
		do
			context_class := a_class
			feature_ := a_feature
		ensure
			context_class_set: context_class = a_class
			feature_set: feature_ = a_feature
		end

	set_context (a_context: like context; a_operand_map: like operand_map)
			-- Set `context' and `operand_map'.
		do
			context := a_context
			operand_map := a_operand_map
		ensure
			context_set: context = a_context
			operand_map_set: operand_map = a_operand_map
		end

	set_is_creation (b: BOOLEAN)
			-- Set `is_creation' with `b'.
		do
			is_creation := b
		ensure
			is_creation_set: is_creation = b
		end

	set_is_for_pre_execution (b: BOOLEAN)
			-- Set `is_for_pre_execution' with `b'.
		do
			is_for_pre_execution := b
		ensure
			is_for_pre_execution_set: is_for_pre_execution = b
		end

	set_should_search_for_query_with_arguments (b: BOOLEAN)
			-- Set `should_search_for_query_with_arguments' with `b'.
		do
			should_search_for_query_with_arguments := b
		ensure
			should_search_for_query_with_arguments_set: should_search_for_query_with_arguments = b
		end

	set_should_search_for_query_with_precondition (b: BOOLEAN)
			-- Set `should_search_for_query_with_precondition' with `b'.
		do
			should_search_for_query_with_precondition := b
		ensure
			should_search_for_query_with_precondition_set: should_search_for_query_with_precondition = b
		end

feature -- Access

	quasi_constant_functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions found by last `search'
			-- Those functions must be constant functions or
			-- functions with a single argument and that argument
			-- must have both a lower and a upper bound.
			-- quasi_constant_functions.is_superset (variable_functions)
			-- `quasi_constant_functions' is superset of `variale_functions', `argumentless_functions' and `variable_functions'.

	variable_functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions for `variables'
			-- quasi_constant_functions.is_superset (variable_functions)
			-- `variable_functions', argumentless_functions and `composed_functions' are disjoint.

	argumentless_functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions representing a qualified argumentless query,
			-- the target is one of `variable_functions'

	composed_functions: DS_HASH_SET [EPA_FUNCTION]
			-- Composed functions, for example v1.has (v2),
			-- where v1 and v2 are too operands of `feature_'.

	tilda_functions: DS_HASH_SET [EPA_FUNCTION]
			-- Set of tilda functions, for example "v1 ~ v2" and "v1 /~ v2"

	functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions that are found by last `search'.
			-- The result is the union of `quasi_constant_functions', `variable_functions', `composed_functions', `argumentless_functions' and `tild_functions'.

feature -- Status report	

	is_for_feature: BOOLEAN
			-- Is Current made for generating expressions among operands of a feature?

	is_for_variables: BOOLEAN
			-- Is Current made for generating expressions among a given set of variables?

feature -- Basic operations

	search (a_repository: detachable like functions)
			-- Search for functions in `feature_' viewed in `context_class'.
			-- Make result available in `quasi_constant_functions', `variable_functions', `composed_functions' and `functions'.
			-- Call `set_class_and_feature' and `set_context' before calling this feature to setup the search scope.
		do
				-- Initialize data structures.
			initialize_data_structures

				-- Search for functions.
			build_operand_names
			build_type_tables
			build_operand_argumentless_query_table
			build_single_integer_argument_query_table
			build_variable_functions
			build_composed_functions
			build_tilda_functions

				-- Integrate results into `functions'.
			functions.merge (quasi_constant_functions)
			functions.merge (variable_functions)
			functions.merge (composed_functions)
			functions.merge (tilda_functions)
		end

feature{NONE} -- Implementation

	operand_names: DS_HASH_SET [STRING]
			-- Name of operands of `feature_'

	variable_names: DS_HASH_SET [STRING]
			-- Name of variables in `variables'

	static_type_table: DS_HASH_TABLE [TYPE_A, STRING]
			-- Table for static type of variables defined in `context'
			-- Key is the variable name, value is the static type of that variable.
			-- For operands in `feature_', the static types are from the feature definition.
			-- For other variables in `context', their static type is the declared type.

	operand_static_type_table: DS_HASH_TABLE [TYPE_A, STRING]
			-- Table of static types for operands of `feature_'
			-- Key is operand name, value is the static type of that operand.

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Table of variables in `context'
		do
			Result := context.variables
		end

	variable_type_table: DS_HASH_TABLE [TYPE_A, STRING]
			-- Type table for `variables'.
			-- For arguments and result of `feature_', static type is considered,
			-- for other variables, dynamic type is considered.

feature{NONE} -- Implementation

	build_variable_functions
			-- Build `variables' as functions and add those functions in `quasi_constant_functions'.
		local
			l_cursor: CURSOR
			l_variables: like variables
			l_expr: EPA_AST_EXPRESSION
			l_context_class: CLASS_C
			l_feature: FEATURE_I
			l_func: EPA_FUNCTION
			l_context: like context
			l_expr_ast: EXPR_AS
			l_context_type: like context_type
		do
			create variable_functions.make (variables.count)
			variable_functions.set_equality_tester (function_equality_tester)
			l_context := context
			l_context_class := l_context.class_
			l_feature := l_context.feature_
			l_variables := variables
			l_cursor := l_variables.cursor
			l_context_type := context_type
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_expr_ast := l_context.ast_from_expression_text (l_variables.key_for_iteration)
				create l_expr.make_with_type (l_context_class, l_feature, l_expr_ast, l_context_class, l_context.expression_type (l_expr_ast))
				create l_func.make_from_expression (l_expr)
				quasi_constant_functions.force_last (l_func)
				variable_functions.force_last (l_func)
				l_variables.forth
			end
		end

	build_tilda_functions
			-- Build `tilda_functions' from `variable_functions'.
		local
			l_cursor, l_cursor2: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_var_funcs: like variable_functions
			l_tilda_functions: like tilda_functions
			l_function: EPA_FUNCTION
			l_func_body: STRING
		do
			if should_include_tilda_expressions then
				l_tilda_functions := tilda_functions
				from
					l_cursor := variable_functions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					from
						l_cursor2 := variable_functions.new_cursor
						l_cursor2.start
					until
						l_cursor2.after
					loop
						l_tilda_functions.force_last (tilda_function (l_cursor.item, l_cursor2.item, once "~"))
						l_tilda_functions.force_last (tilda_function (l_cursor.item, l_cursor2.item, once "/~"))
						l_cursor2.forth
					end
					l_cursor.forth
				end
			end
		end

	build_composed_functions
			-- Build `composed_functions' from `quasi_constant_functions'.
		local
			l_operand_cur: DS_HASH_SET_CURSOR [STRING]
			l_operand_name: STRING
			l_operand_type: TYPE_A
			l_operand_class: CLASS_C
			l_context_class: CLASS_C
			l_features: LIST [FEATURE_I]
			l_feature: FEATURE_I
			l_funcs: LIST [EPA_FUNCTION]
			l_outer_func: EPA_FUNCTION
			l_context: like context
			l_composed_func: EPA_FUNCTION
			l_composed_functions: like composed_functions
			l_quasi_constant_functions: like quasi_constant_functions
		do
			if should_search_for_query_with_arguments then
					-- 1. Iterate through all operands
					-- 2. For each operand, get all queries with one argument.
					-- 3. For each such query, iterate through all functions in `variable_functions', select those
					--    whose type conforms to the type of that query,
					-- 4. Compose the query and the selected function in `quasi_constant_functions'.
				l_composed_functions := composed_functions
				l_quasi_constant_functions := quasi_constant_functions
				l_context := context
				l_context_class := l_context.class_
					-- 1. Iterate through all operands
				from
					if is_for_feature then
						l_operand_cur := operand_names.new_cursor
					else
						l_operand_cur := variable_names.new_cursor
					end
					l_operand_cur.start
				until
					l_operand_cur.after
				loop
					l_operand_name := l_operand_cur.item
					l_operand_type := variable_type_table.item (l_operand_name)
--					l_operand_type := resolved_type_in_context (l_operand_type, l_context_class)
					l_operand_class := l_operand_type.associated_class

						-- 2. For each operand, get all queries with one argument.
					l_features := queries_with_one_argument (l_operand_class)

					if not l_features.is_empty then
						from
							l_features.start
						until
							l_features.after
						loop
								-- 3. For each such query, iterate through all functions in `variable_functions', select those
								--    whose type conforms to the type of that query,
							l_feature := l_features.item_for_iteration
							fixme ("We don't handle is_equal for the moment because between any two given variables, you can test if they are eqaul, then we have too many cases. 9.5.2010 Jasonw")
							if is_single_argument_query_valid (l_feature, l_operand_type) then
								l_funcs := argumentable_functions (variable_functions, l_feature, l_operand_class, l_operand_type)

									-- 4. Compose the query and the selected function in `quasi_constant_functions'.
								if not l_funcs.is_empty then
									l_outer_func := new_single_argument_function (l_operand_class, l_feature, l_operand_name, context, l_operand_type)
									from
										l_funcs.start
									until
										l_funcs.after
									loop
										l_composed_func := l_outer_func.partially_evalauted (l_funcs.item_for_iteration, 1)
										l_composed_functions.force_last (l_composed_func)
										l_quasi_constant_functions.force_last (l_composed_func)

										l_funcs.forth
									end
								end
							end
							l_features.forth
						end
					end
					l_operand_cur.forth
				end
			end
		end

	build_operand_argumentless_query_table
			-- Search for argumentless queries for variables.
		local
			l_expr_gen: EPA_NESTED_EXPRESSION_GENERATOR
			l_operand_cursor: DS_HASH_SET_CURSOR [STRING]
			l_function: EPA_FUNCTION
			l_quasi_functions: like quasi_constant_functions
			l_argless_functions: like argumentless_functions
		do
				-- Setup expression generator to list all argument-less queries.
			l_expr_gen := argumentless_query_expression_generator
			if context.is_dummy_feature_used then
				l_expr_gen.generate_for_dummy_feature (context)
			else
				l_expr_gen.generate (context_class, feature_)
			end
			l_quasi_functions := quasi_constant_functions
			l_argless_functions := argumentless_functions
			from
				l_expr_gen.accesses.start
			until
				l_expr_gen.accesses.after
			loop
				create l_function.make_from_expression (expression_from_access (l_expr_gen.accesses.item_for_iteration))
				l_quasi_functions.force_last (l_function)
				l_argless_functions.force_last (l_function)
				l_expr_gen.accesses.forth
			end
		end

	build_single_integer_argument_query_table
			-- Build `quasi_constant_functions'.
		local
			l_expr_gen: EPA_NESTED_EXPRESSION_GENERATOR
			l_operand_cursor: DS_HASH_SET_CURSOR [STRING]
			l_function: EPA_FUNCTION
			l_cursor: DS_HASH_TABLE_CURSOR [TYPE_A, STRING]
			l_class: CLASS_C
			l_feat_tbl: FEATURE_TABLE
			l_tbl_cursor: CURSOR
			l_feat: FEATURE_I
			l_any_id: INTEGER
			l_argument_types: ARRAY [TYPE_A]
			l_argument_domains: ARRAY [EPA_FUNCTION_DOMAIN]
			l_result_type: TYPE_A
			l_body: STRING
			l_range: like integer_bounds
			l_quasi_functions: like quasi_constant_functions
			l_type: TYPE_A
		do
			if should_solve_integer_argument_bound and then is_for_feature and then should_search_for_query_with_arguments then
				l_quasi_functions := quasi_constant_functions
				l_any_id := system.any_class.compiled_representation.class_id
				from
					l_cursor := operand_static_type_table.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_type := l_cursor.item
					check l_type.associated_class /= Void end
					l_class := l_type.associated_class
					l_feat_tbl := l_class.feature_table
					l_tbl_cursor := l_feat_tbl.cursor
					from
						l_feat_tbl.start
					until
						l_feat_tbl.after
					loop
						l_feat := l_feat_tbl.item_for_iteration
						if
							l_feat.has_return_value and then
							l_feat.written_class.class_id /= l_any_id and then
							l_feat.argument_count = 1 and then
							l_feat.arguments.i_th (1).is_integer
						then
							l_range := integer_bounds (context_class, l_feat)
							if l_range /= Void then
								create l_argument_types.make (1, 1)
								create l_argument_domains.make (1, 1)
								l_argument_types.put (integer_type, 1)
								l_argument_domains.put (l_range, 1)
								l_result_type := l_feat.type.actual_type.instantiation_in (l_type, l_class.class_id)
								create l_body.make (32)
								l_body.append (l_cursor.key)
								l_body.append_character ('.')
								l_body.append (l_feat.feature_name)
								l_body.append (once " ({1})")
								create l_function.make (l_argument_types, l_argument_domains, l_result_type, l_body)
								l_quasi_functions.force_last (l_function)
							end
						end
						l_feat_tbl.forth
					end
					l_feat_tbl.go_to (l_tbl_cursor)
					l_cursor.forth
				end
			end
		end

	build_operand_names
			-- Build `operand_names'.
		local
			l_cursor: CURSOR
			l_map: like operand_map
			l_names: like operand_names
		do
			create operand_names.make (feature_.argument_count + 2)
			l_names := operand_names
			l_names.set_equality_tester (string_equality_tester)

			l_map := operand_map
			l_cursor := l_map.cursor
			from
				l_map.start
			until
				l_map.after
			loop
				l_names.force_last (l_map.item_for_iteration)
				l_map.forth
			end
			l_map.go_to (l_cursor)
		end

	build_type_tables
			-- Build type related tables from `feature_' in `context_class' and `context'.
		local
			l_opernd_types: like operand_types_with_feature
			l_type: TYPE_A
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_static_type_table: like static_type_table
			l_operand_static_type_table: like operand_static_type_table
			l_cursor: CURSOR
			l_operand_name: STRING
			l_variable_type_table: like variable_type_table
			l_var_name: STRING
			l_variable_names: like variable_names
			l_context_type: like context_type
			l_context_type_class: CLASS_C
		do
			l_context_type := context_type
			l_context_type_class := l_context_type.associated_class
			create static_type_table.make (variables.count)
			l_static_type_table := static_type_table
			l_static_type_table.set_key_equality_tester (string_equality_tester)

			create operand_static_type_table.make (variables.count)
			l_operand_static_type_table := operand_static_type_table
			l_operand_static_type_table.set_key_equality_tester (string_equality_tester)

			create variable_type_table.make (variables.count)
			l_variable_type_table := variable_type_table
			l_variable_type_table.set_key_equality_tester (string_equality_tester)

				-- Add static types of operands in `feature_' in `static_type_table'.
			if not context.is_dummy_feature_used then
				from
					l_opernd_types := resolved_operand_types_with_feature (feature_, context_class, l_context_type)
					l_opernd_types.start
				until
					l_opernd_types.after
				loop
					l_operand_name := operand_map.item (l_opernd_types.key_for_iteration)
					l_type := l_opernd_types.item_for_iteration
					l_static_type_table.force_last (l_type, l_operand_name)
					l_operand_static_type_table.force_last (l_type, l_operand_name)
					if l_opernd_types.key_for_iteration = 0 then
							-- Dynamic type for feature target.
						l_variable_type_table.force_last (variables.item (l_operand_name), l_operand_name)
					else
							-- Static type for arguments and result, if any.
						l_variable_type_table.force_last (l_type, l_operand_name)
					end
					l_opernd_types.forth
				end
			end

				-- Add types of variables other than operand of `feature_' into `static_type_table'.			
			l_variables := context.variables
			create variable_names.make (l_variables.count)
			l_variable_names := variable_names
			l_variable_names.set_equality_tester (string_equality_tester)
			l_cursor := l_variables.cursor
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_var_name := l_variables.key_for_iteration
				l_variable_names.force_last (l_var_name)
				l_type := l_variables.item_for_iteration
				if not l_static_type_table.has (l_var_name) then
					l_static_type_table.force_last (l_type, l_var_name)
					l_variable_type_table.force_last (l_type, l_var_name)
				end
				l_variables.forth
			end
			l_variables.go_to (l_cursor)
		end

feature{NONE} -- Implementations

	new_single_argument_function (a_context_class: CLASS_C; a_feature: FEATURE_I; a_operand_name: STRING; a_context: EPA_CONTEXT; a_context_type: TYPE_A): EPA_FUNCTION
			-- Function for `a_feature'.
			-- `a_feature' should only have one argument. `a_operand_name' serves as the target of the feature call in the resulting function.
			-- For example, if `a_operand_name' is "v" and `a_feature' is i_th, then the final function is: "v1.i_th({1})".
			-- The {1} part stands for the open argument of the resulting function.
		local
			l_arg_types: ARRAY [TYPE_A]
			l_arg_domains: ARRAY [EPA_FUNCTION_DOMAIN]
			l_result_type: TYPE_A
			l_body: STRING
		do
			create l_arg_types.make (1, 1)
			l_arg_types.put (a_feature.arguments.first.instantiation_in (a_context_type, a_context_type.associated_class.class_id), 1)
			create l_arg_domains.make (1, 1)
			l_arg_domains.put (create {EPA_UNSPECIFIED_DOMAIN}, 1)
			l_result_type := a_feature.type.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)
			create l_body.make (32)
			l_body.append (a_operand_name)
			l_body.append_character ('.')
			l_body.append (a_feature.feature_name.as_lower)
			l_body.append (once " ({1})")
			create Result.make (l_arg_types, l_arg_domains, l_result_type, l_body)
		end

	argumentable_functions (a_functions: DS_HASH_SET[EPA_FUNCTION]; a_feature: FEATURE_I; a_context_class: CLASS_C; a_context_type: TYPE_A): LIST [EPA_FUNCTION]
			-- Functions from `a_functions' whose type conforms to the argument type of `a_feature'
		local
			l_arg_type: TYPE_A
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_func_type: TYPE_A
			l_func: EPA_FUNCTION
			l_context_class: CLASS_C
		do
			create {LINKED_LIST [EPA_FUNCTION]} Result.make
			l_context_class := context.class_
			l_arg_type := a_feature.arguments.first.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)

			from
				l_cursor := a_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_func := l_cursor.item
				l_func_type := l_func.result_type
				if l_func_type.conform_to (l_context_class, l_arg_type) then
					Result.extend (l_func)
				end
				l_cursor.forth
			end
		end

	queries_with_one_argument (a_class: CLASS_C): LIST [FEATURE_I]
			-- One argument queries from `a_class'
		local
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
			l_feature: FEATURE_I
			l_any_id: INTEGER
		do
			l_any_id := system.any_class.compiled_representation.class_id
			create {LINKED_LIST [FEATURE_I]} Result.make
			l_feat_tbl := a_class.feature_table
			l_cursor := l_feat_tbl.cursor
			from
				l_feat_tbl.start
			until
				l_feat_tbl.after
			loop
				l_feature := l_feat_tbl.item_for_iteration
				if l_feature.written_class.class_id /= l_any_id and then l_feature.has_return_value and then l_feature.argument_count = 1 then
					Result.extend (l_feature)
				end
				l_feat_tbl.forth
			end
			l_feat_tbl.go_to (l_cursor)
		end

	expression_from_access (a_access: EPA_ACCESS): EPA_EXPRESSION
			-- Expression in `context' derived from `a_access'
		local
			l_text: STRING
			l_new_text: STRING
			l_arg_name: STRING
			l_parts: LIST [STRING]
			l_expr: EPA_AST_EXPRESSION
			l_expr_ast: EXPR_AS
			l_context: like context
		do
			l_text := a_access.text
			if is_for_feature then
				if l_text.is_case_insensitive_equal (ti_current) then
					l_new_text := operand_map.item (0)
				elseif l_text.is_case_insensitive_equal (ti_result) then
					l_new_text := operand_map.item (feature_.argument_count + 1)
				elseif l_text.has ('.') then
					l_parts := l_text.split ('.')
					l_arg_name := l_parts.first
					if l_arg_name ~ ti_result then
						l_new_text := operand_map.item (feature_.argument_count + 1).twin
					else
						l_new_text := operand_map.item (operands_of_feature (feature_).item (l_arg_name)).twin
					end
					l_new_text.append_character ('.')
					l_new_text.append (l_parts.last)
				else
					create l_new_text.make (32)
					l_new_text.append (operand_map.item (0))
					l_new_text.append_character ('.')
					l_new_text.append (l_text)
				end
			else
				l_new_text := l_text
			end
			l_context := context
			l_expr_ast := l_context.ast_from_expression_text (l_new_text)
			create l_expr.make_with_type (l_context.class_, l_context.feature_, l_expr_ast, l_context.class_, l_context.expression_type (l_expr_ast))
			Result := l_expr
		ensure
			result_good: Result.type /= Void
		end

	argumentless_query_expression_generator: EPA_NESTED_EXPRESSION_GENERATOR
			-- Expression generator to list all argument-less queries
		local
			l_criteria: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]]
			l_cri_array: ARRAY [FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]]
			i: INTEGER
			l_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]]
		do
			create Result.make
			Result.expression_veto_agents.wipe_out

			if is_for_feature then
				create l_criteria.make
				l_criteria.extend (argument_expression_veto_agent)
					-- Extend different expression selection criteria into `l_criteria' depending on
					-- the value of `is_for_pre_execution', `is_creation' and `is_query'.
				if is_for_pre_execution then
					if not is_creation then
						l_criteria.extend (current_expression_veto_agent)
					end
				else
					l_criteria.extend (current_expression_veto_agent)
					if is_query then
						l_criteria.extend (result_expression_veto_agent)
					end
				end
				create l_cri_array.make (1, l_criteria.count)
				from
					i := 1
					l_criteria.start
				until
					l_criteria.after
				loop
					l_cri_array.put (l_criteria.item_for_iteration, i)
					i := i + 1
					l_criteria.forth
				end

				Result.expression_veto_agents.put (
					anded_agents (<<
						ored_agents (l_cri_array),
						feature_not_from_any_veto_agent>>),
						 	 1)
			else
				Result.expression_veto_agents.put (local_expression_veto_agent, 1)
			end

			create l_agents.make
			l_agents.extend (feature_expression_veto_agent)
			l_agents.extend (feature_not_from_any_veto_agent)
			l_agents.extend (nested_not_on_basic_veto_agent)
			l_agents.extend (feature_with_few_arguments_veto_agent (0))
			if not should_search_for_query_with_precondition then
				l_agents.extend (feature_without_precondition)
			end
			Result.expression_veto_agents.put (anded_agents_with_list (l_agents), 2)

			Result.set_final_expression_veto_agent (Void)
		end

	single_integer_argument_query_expression_generator: EPA_NESTED_EXPRESSION_GENERATOR
			-- Expression generator to list all argument-less queries
		local
			l_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]]
		do
			create Result.make
			Result.expression_veto_agents.wipe_out
			Result.expression_veto_agents.put (
				anded_agents (<<
					ored_agents (
						<<result_expression_veto_agent,
					  	  current_expression_veto_agent,
					  	  argument_expression_veto_agent>>),
					feature_not_from_any_veto_agent>>),
					 	 1)

			create l_agents.make
			l_agents.extend (feature_expression_veto_agent)
			l_agents.extend (feature_not_from_any_veto_agent)
			l_agents.extend (nested_not_on_basic_veto_agent)
			l_agents.extend (feature_with_one_integer_argument_veto_agent)
			if not should_search_for_query_with_precondition then
				l_agents.extend (feature_without_precondition)
			end

			Result.expression_veto_agents.put (
				anded_agents_with_list (l_agents), 2)

			Result.set_final_expression_veto_agent (Void)
		end


	integer_domain_from_bounds (a_lower_bounds: LINKED_LIST [EPA_EXPRESSION]; a_upper_bounds: LINKED_LIST [EPA_EXPRESSION]): EPA_INTEGER_RANGE_DOMAIN
			-- Integer bounds from `a_lower_bounds' and `a_upper_bounds'
		do
			create Result.make (a_lower_bounds, a_upper_bounds)
		end

	integer_bounds (a_class: CLASS_C; a_feature: FEATURE_I): detachable EPA_INTEGER_RANGE_DOMAIN
			-- Integer bounds for input of `a_feature' viewed from `a_class'
			-- Void if no such bounds exist
		require
			a_feature_valid: a_feature.argument_count = 1 and then a_feature.has_return_value and then a_feature.arguments.i_th (1).is_integer
		local
			l_bound_checker: EPA_LINEAR_BOUNDED_ARGUMENT_FINDER
		do
			create l_bound_checker.make (output_directory, context_type)
			l_bound_checker.analyze_bounds (a_class, a_feature)
			if l_bound_checker.is_bound_found then
				Result := integer_domain_from_bounds (l_bound_checker.minimal_values, l_bound_checker.maximal_values)
			end
		end

	output_directory: detachable STRING
			-- Directory to store temp files
			-- Those files are Mathematica scripts, which are used to determine
			-- the minimal and maximal value of a integer argument constrained in preconditions.
			-- If Void, no Mathematica files are generated.

	initialize_data_structures
			-- Initialize data structures.
		do
			create quasi_constant_functions.make (100)
			quasi_constant_functions.set_equality_tester (function_equality_tester)

			create argumentless_functions.make (100)
			argumentless_functions.set_equality_tester (function_equality_tester)

			create composed_functions.make (100)
			composed_functions.set_equality_tester (function_equality_tester)

			create functions.make (200)
			functions.set_equality_tester (function_equality_tester)

			create tilda_functions.make (100)
			tilda_functions.set_equality_tester (function_equality_tester)
		end

	is_single_argument_query_valid (a_feature: FEATURE_I; a_context_type: TYPE_A): BOOLEAN
			-- Is `a_feature' valid as the feature in a composed query?
		local
			l_type: TYPE_A
			l_class: CLASS_C
			l_class_id: INTEGER
			l_system: like system
		do
			fixme ("We don't handle the following cases. 21.5.2010 Jasonw")

				-- We don't handle is_equal for the moment because between any two given variables, you can test if they are eqaul, then we have too many cases.
			Result := not a_feature.feature_name.is_case_insensitive_equal (once "is_equal")


				-- Don't handle queries with preconditions.
			if Result then
				Result := (should_search_for_query_with_precondition or else all_preconditions (a_feature).is_empty)
			end

				-- Don't handle agents as argument.
			if Result then
				l_class := a_context_type.associated_class
				Result := l_class /= Void
				if Result then
					l_type := a_feature.arguments.first.actual_type
					l_type := actual_type_from_formal_type (l_type, l_class)
					l_type := l_type.instantiation_in (a_context_type, l_class.class_id)
					l_class := l_type.associated_class
					if l_class /= Void then
						l_class_id := l_class.class_id
						l_system := system
						Result :=
							l_class_id /= l_system.procedure_class_id and then
							l_class_id /= l_system.function_class_id and then
							l_class_id /= l_system.predicate_class_id
					else
						Result := False
					end
				end
			end
		end

	tilda_function (a_func1, a_func2: EPA_FUNCTION; a_tilda_symbol: STRING): EPA_FUNCTION
			-- Tilda function connecting `a_func1' and `a_func2' with `a_tilda_symbol'
		require
			a_func1_is_constant: a_func1.is_constant
			a_func2_is_constant: a_func2.is_constant
			a_tilda_symbol_valid: a_tilda_symbol ~ ti_tilda or a_tilda_symbol ~ "/~"
		local
			l_body: STRING
		do
			create l_body.make (24)
			l_body.append (a_func1.body)
			l_body.append_character (' ')
			l_body.append (a_tilda_symbol)
			l_body.append_character (' ')
			l_body.append (a_func2.body)
			create Result.make_nullary (boolean_type, l_body)
		end

end
