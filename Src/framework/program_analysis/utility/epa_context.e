note
	description: "Context for type checking"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTEXT

inherit
	SHARED_EIFFEL_PARSER

	SHARED_WORKBENCH

	SHARED_NAMES_HEAP

	EPA_UTILITY

	ETR_SHARED_TOOLS
		rename
			type_checker as expr_type_checker
		end

create
	make,
	make_with_variable_names,
	make_with_class,
	make_with_class_and_variable_names,
	make_with_class_and_feature

feature{NONE} -- Initialization

	make (a_variables: like variables)
			-- Initialize with `a_variables'.
			-- The root class of current system is used as context class.
		require
			has_root_class: attached workbench.system.root_type as l_root_type and then l_root_type.associated_class /= Void
		do
			make_with_class (workbench.system.root_type.associated_class, a_variables)
		end

	make_with_variable_names (a_variables: HASH_TABLE [STRING, STRING])
			-- Initialize `variables' with `a_variables' and `class_' with
			-- the root class of current system.
			-- Key in `a_variables' is variable name, value is type name.
		require
			has_root_class: attached workbench.system.root_type as l_root_type and then l_root_type.associated_class /= Void
			a_variables_valid: is_variables_valid (a_variables, l_root_type.associated_class)
		do
			make_with_class_and_variable_names (workbench.system.root_type.associated_class, a_variables)
		end

	make_with_class (a_class: CLASS_C; a_variables: like variables)
			-- Initialize Current with `a_class' and `a_variable'.
		do
			class_ := a_class
			create variables.make (a_variables.count)
			variables := a_variables
			feature_ := environment_feature (variables)
			create feature_context.make_with_locals (feature_, a_variables)
			is_dummy_feature_used := True
		end

	make_with_class_and_variable_names (a_class: like class_; a_variables: HASH_TABLE [STRING, STRING])
			-- Initialize Current with `a_class' and `a_variables'.
			-- Key in `a_variables' is variable name, value is type name.
		require
			a_variables_valid: is_variables_valid (a_variables, a_class)
		local
			l_variables: like variables
			l_cursor: CURSOR
			l_type: TYPE_A
			l_class: CLASS_C
		do
			create variables.make (a_variables.count)
			variables.compare_objects
			l_cursor := a_variables.cursor
			from
				a_variables.start
			until
				a_variables.after
			loop
				l_type := type_a_from_string (a_variables.item_for_iteration, a_class)
				check l_type /= Void end
				variables.put (l_type, a_variables.key_for_iteration)
				a_variables.forth
			end
			a_variables.go_to (l_cursor)
			make_with_class (a_class, variables)
		end

	make_with_class_and_feature (a_class: like class_; a_feature: like feature_; a_add_operands: BOOLEAN; a_add_locals: BOOLEAN; a_add_target: BOOLEAN)
			-- Initialize Current with `a_class' and `a_feature'.
			-- `a_add_operands' indicates if operands of `a_feature' should be added as variables into the resulting context.
			-- `a_add_locals' indicates if locals in `a_feature' should be added as variables into the resulting context.
			-- `a_add_target' indicates if target of `a_feature' should be added as a variable into the resulting context.
		local
			l_context: ETR_CLASS_CONTEXT
			i: INTEGER
			l_upper: INTEGER
			l_tvar: ETR_TYPED_VAR
			l_opd_cursor: like operand_name_types_with_feature.new_cursor
		do
			class_ := a_class
			feature_ := a_feature
			create l_context.make (class_)
			create feature_context.make (feature_, l_context)

				-- Setup `variables'.
			create variables.make (10)
			variables.compare_objects

			if a_add_operands then
				from
					l_opd_cursor := operand_name_types_with_feature (a_feature, a_class).new_cursor
					l_opd_cursor.start
				until
					l_opd_cursor.after
				loop
					if l_opd_cursor.key ~ ti_current implies a_add_target then
						variables.put (l_opd_cursor.item, l_opd_cursor.key)
					end
					l_opd_cursor.forth
				end
			end

			if a_add_locals and then feature_context.has_locals then
				if attached {ARRAY [ETR_TYPED_VAR]} feature_context.locals as l_locals then
					from
						i := l_locals.lower
						l_upper := l_locals.upper
					until
						i > l_upper
					loop
						l_tvar := l_locals.item (i)
						variables.put (l_tvar.original_type, l_tvar.name)
						i := i + 1
					end
				end
			end
		end

feature -- Access

	class_: CLASS_C
			-- Class of current context

	feature_: FEATURE_I
			-- Feature of current context
			-- This is can be a fake FEATURE_I object
			-- built just for type checking

	feature_context: ETR_FEATURE_CONTEXT
			-- Feature context for current transition context

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Variables in current context which includes
			-- all variables that are needed for type checking
			-- a transition.
			-- Key is the case sensitive name of variable,
			-- value is the type of that variable.

	variable_type_name_table: HASH_TABLE [STRING, STRING]
			-- Table from variable name to variable type name
			-- Key is name of a variable, value is the name of the type of that variable
		local
			l_cursor: CURSOR
			l_variables: like variables
		do
			l_variables := variables
			create Result.make (l_variables.count)
			Result.compare_objects

			l_cursor := l_variables.cursor
			from
				l_variables.start
			until
				l_variables.after
			loop
				Result.put (cleaned_type_name (l_variables.item_for_iteration.name), l_variables.key_for_iteration)
				l_variables.forth
			end
			l_variables.go_to (l_cursor)
		end

	transition_feature_name: STRING = "dummy__feature"
			-- Name of the fake feature used to type check feature transitions

	variable_type (a_name: STRING): TYPE_A
			-- Type of variable named `a_name' in Current
		require
			a_name_exists: has_variable_named (a_name)
		do
			Result := variables.item (a_name)
		end

	variable_class (a_name: STRING): detachable CLASS_C
			-- Class of variable named `a_name' in Current
		require
			a_name_exists: has_variable_named (a_name)
		do
			Result := variables.item (a_name).associated_class
		end

feature -- Status report

	is_variables_valid (a_variables: HASH_TABLE [STRING, STRING]; a_context_class: CLASS_C): BOOLEAN
			-- Are variables in `a_variables' valid in `a_context_class'?
		local
			l_cursor: CURSOR
		do
			l_cursor := a_variables.cursor
			Result := True
			from
				a_variables.start
			until
				a_variables.after or not Result
			loop
				Result := is_variable_valid (a_variables.key_for_iteration, a_variables.item_for_iteration, a_context_class)
				a_variables.forth
			end
		end

	is_variable_valid (a_variable_name: STRING; a_type_name: STRING; a_context_class: CLASS_C): BOOLEAN
			-- Is `a_variable_name' with `a_type_name' valid in `a_context_class'?
		do
			Result := attached type_a_from_string (a_type_name, a_context_class)
		end

	has_variable_named (a_name: STRING): BOOLEAN
			-- Does `variables' have a varaible named `a_name'?
		do
			Result := variables.has (a_name)
		end

	is_dummy_feature_used: BOOLEAN
			-- Is dummy feature used?

feature -- Type checking

	expression_type (a_expression: EXPR_AS): detachable TYPE_A
			-- Check type of `a_expression',
			-- return the type if checked correctly, return Void,
			-- if `a_expression' is type-invalid.
		local
			l_type_checker: like expr_type_checker
			l_context: ETR_FEATURE_CONTEXT
		do
			l_type_checker := expr_type_checker
				-- We do a hack here: in order to type check old expressions with local variables, we
				-- first translate an old expression into one without the "old" keyword, then do the type-checking
				-- on that translated old-free expression. The type should be the same as before.
			l_type_checker.check_ast_type (ast_without_old_expression (a_expression), feature_context)
			Result := l_type_checker.last_type
		end

	expression_text_type (a_expression: STRING): detachable TYPE_A
			-- Check type of `a_expression',
			-- return the type if checked correctly, return Void,
			-- if `a_expression' is type-invalid.
		do
			if attached {EXPR_AS} ast_without_old_expression (ast_from_expression_text (a_expression)) as l_expr then
				Result := expression_type (l_expr)
			end
		end

feature{NONE} -- Implementation

	environment_feature (a_variables: HASH_TABLE [TYPE_A, STRING]): FEATURE_I
			-- Environment feature in which type checking is done for transition of `a_feature' viewed from `a_context_class'
			-- `a_variables' are the set of variables in the transition, key is variable name,
			-- value is type name of that variable.
		local
			l_class: CLASS_C
			l_vars: HASH_TABLE [TYPE_A, INTEGER]
			l_feat_as: FEATURE_AS
			l_name_id: INTEGER
			l_body: STRING
			l_cursor: CURSOR
		do
				-- Synthesize the fake feature body for type checking purpose.
			create l_body.make (64)
			l_body.append (once "feature ")
			l_body.append (transition_feature_name)
			if not a_variables.is_empty then
				l_body.append (once " (")
				across a_variables as l_var_list loop
					l_body.append (l_var_list.key)
					l_body.append_character (':')
					l_body.append (l_var_list.item.name)
					l_body.append_character (';')
				end
				l_body.append (once ") ")
			end
			l_body.append (once " do end")

				-- Parse this fake feature.
			entity_feature_parser.set_syntax_version (entity_feature_parser.provisional_syntax)
			entity_feature_parser.parse_from_utf8_string (l_body, Void)
			l_feat_as := entity_feature_parser.feature_node

				-- Generate FEATURE_I for this fake feature.
			l_class := workbench.system.root_type.associated_class
			names_heap.put (transition_feature_name)
			l_name_id := names_heap.id_of (transition_feature_name)

			Result := feature_i_generator.new_feature (l_feat_as, 0, l_class)
			Result.set_written_in (l_class.class_id)
			Result.set_feature_name_id (l_name_id, l_name_id)
		end

end
