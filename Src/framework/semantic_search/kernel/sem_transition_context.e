note
	description: "Context for semantic transitions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_CONTEXT

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
	make_with_class_and_variable_names

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
		end

	make_with_class_and_variable_names (a_class: CLASS_C; a_variables: HASH_TABLE [STRING, STRING])
			-- Initialize Current with `a_class' and `a_variables'.
			-- Key in `a_variables' is variable name, value is type name.
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
				variables.put (l_type, a_variables.key_for_iteration)
				a_variables.forth
			end
			a_variables.go_to (l_cursor)
			make_with_class (a_class, variables)
		end

feature -- Access

	class_: CLASS_C
			-- Class of current context

	feature_: FEATURE_I
			-- Feature of current context
			-- This is usually a fake FEATURE_I object
			-- built just for type checking

	feature_context: ETR_FEATURE_CONTEXT
			-- Feature context for current transition context

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Variables in current context which includes
			-- all variables that are needed for type checking
			-- a transition.
			-- Key is the case sensitive name of variable,
			-- value is the type of that variable.

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

	environment_feature (a_variable: HASH_TABLE [TYPE_A, STRING]): FEATURE_I
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
			l_body.append (once " do end")

				-- Parse this fake feature.
			entity_feature_parser.parse_from_string (l_body, Void)
			l_feat_as := entity_feature_parser.feature_node

				-- Generate FEATURE_I for this fake feature.
			l_class := workbench.system.root_type.associated_class
			names_heap.put (transition_feature_name)
			l_name_id := names_heap.id_of (transition_feature_name)

			Result := feature_i_generator.new_feature (l_feat_as, 0, l_class)
			Result.set_written_in (l_class.class_id)
			Result.set_feature_name_id (l_name_id, l_name_id)
		end

	transition_feature_name: STRING = "transition__feature"
			-- Name of the fake feature used to type check feature transitions

end
