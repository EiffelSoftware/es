note
	description: "Class that represents a concept that can be queried"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERYABLE

inherit
	EPA_SHARED_EQUALITY_TESTERS

	REFACTORING_HELPER

	EPA_STRING_UTILITY

	EPA_UTILITY

	SEM_UTILITY

feature -- Access

	context: EPA_CONTEXT
			-- Context in which current transition is type checked
			-- Because transitions may contain code that does not appear
			-- in current project, so we need a special context in order to
			-- make the type checker work.

	variables: EPA_HASH_SET [EPA_EXPRESSION]
			-- Variables mentioned in Current transition
			-- Variables can be input, output or intermediate locals.
			-- Input and output variables can be seen from outside of current transition,
			-- while intermedidate locals is hidden from the outside.
			-- A variable can be both input and output. An intermediate local can neither
			-- be input nor be output.
			-- This variable set must be a subset of `context'.`variables'.

	variable_positions: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			-- Table of positions for `variables'.
			-- Key is a variable, value is the 0-based appearing index of that
			-- variable in Current transition.

	variable_position_set: DS_HASH_SET [INTEGER]
			-- Set of positions of `variables'
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, EPA_EXPRESSION]
		do
			create Result.make (variables.count)
			from
				l_cursor := variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.item)
				l_cursor.forth
			end
		end

	variable_name_positions: HASH_TABLE [INTEGER, STRING]
			-- Table from variable name to their positions
		local
			l_pos: like variable_positions
			l_cursor: like variable_positions.new_cursor
		do
			l_pos := variable_positions
			create Result.make (l_pos.count)
			Result.compare_objects

			from
				l_cursor := variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.put (l_cursor.item, l_cursor.key.text)
				l_cursor.forth
			end
		end

	reversed_variable_position: HASH_TABLE [EPA_EXPRESSION, INTEGER]
			-- Revsersed table for `variable_position'
			-- Key is variable expression, value is the index of that variable

	variable_types: HASH_TABLE [TYPE_A, INTEGER]
			-- Table of variable types
			-- key is variable position, value is the type of the variable in that position.
		do
			create Result.make (variables.count)
			across reversed_variable_position as l_vars loop
				Result.put (l_vars.item.type, l_vars.key)
			end
		end

	variable_type_table: DS_HASH_TABLE [INTEGER, TYPE_A]
			-- Table of types of `variables'
			-- Key is the type, value is the number of times that a certain
			-- type appears in `variables'.
			-- Create a new table each time.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_type: TYPE_A
			l_context_type: like context_type
		do
			create Result.make (variables.count)
			Result.set_key_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]}.make (
					agent (a, b: TYPE_A): BOOLEAN
						do
							Result := a.name ~ b.name
						end))

			l_context_type := context_type
			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_type := l_cursor.item.resolved_type (l_context_type)
				if Result.has (l_type) then
					Result.replace (Result.item (l_type) + 1, l_type)
				else
					Result.put (1, l_type)
				end
				l_cursor.forth
			end
		end

	variable_position (a_variable: EPA_EXPRESSION): INTEGER
			-- Position of `a_variable'
		require
			has_a_variable: has_variable (a_variable)
		do
			Result := variable_positions.item (a_variable)
		end

	variable_position_by_name (a_variable: STRING): INTEGER
			-- Position of `a_variable'
		require
			has_a_variable: variable_by_name (a_variable) /= Void
		do
			Result := variable_positions.item (variable_by_name (a_variable))
		end

	anonymous_expression_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by anonymoue names
			-- For example, "has (v)" will be: "{0}.has ({1})", given those variable positions.
		local
			l_replacements: HASH_TABLE [STRING, STRING]
			l_cursor: like variable_positions.new_cursor
			l_cache: like anonymous_expression_cache
		do
			l_cache := anonymous_expression_cache
			l_cache.search (a_expression)
			if l_cache.found then
				Result := l_cache.found_item
			else
				create l_replacements.make (variables.count)
				l_replacements.compare_objects
				from
					l_cursor := variable_positions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_replacements.put (anonymous_variable_name (l_cursor.item), l_cursor.key.text.as_lower)
					l_cursor.forth
				end
				Result := expression_rewriter.expression_text (a_expression, l_replacements)
				l_cache.force_last (Result, a_expression)
			end
		end

	anonymous_variables_table: DS_HASH_TABLE [STRING, EPA_EXPRESSION]
			-- Table from `variables' to their anonymous name format
			-- For example: v_128 -> "{0}" if v_128 is the 0-th variable.
		local
			l_cursor: like variable_positions.new_cursor
		do
			if anonymous_variables_table_cache = Void then
				create anonymous_variables_table_cache.make (variables.count)
				anonymous_variables_table_cache.set_key_equality_tester (expression_equality_tester)
				from
					l_cursor := variable_positions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					anonymous_variables_table_cache.force_last (anonymous_variable_name (l_cursor.item), l_cursor.key)
					l_cursor.forth
				end

			end
			Result := anonymous_variables_table_cache
		end

	anonymous_variables_string_table: HASH_TABLE [STRING, STRING]
			-- Table from `variables' to their anonymous name format
			-- For example: v_128 -> "{0}" if v_128 is the 0-th variable.
		local
			l_cursor: like variable_positions.new_cursor
		do
			if anonymous_variables_string_table_cache = Void then
				create anonymous_variables_string_table_cache.make (variables.count)
				anonymous_variables_string_table_cache.compare_objects

				from
					l_cursor := variable_positions.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					anonymous_variables_string_table_cache.force (anonymous_variable_name (l_cursor.item), l_cursor.key.text.as_lower)
					l_cursor.forth
				end
			end
			Result := anonymous_variables_string_table_cache
		end

	variable_name_type_table: HASH_TABLE[TYPE_A, STRING]
			-- Table from variable name to their types
			-- Key is variable name, value is the type of that variable.
			-- Note: The types may not be resolved.
		local
			l_cursor: like variables.new_cursor
		do
			if variable_name_type_table_cache = Void then
				create variable_name_type_table_cache.make (variables.count)
				variable_name_type_table_cache.compare_objects

				from
					l_cursor := variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					variable_name_type_table_cache.force (l_cursor.item.type, l_cursor.item.text)
					l_cursor.forth
				end
			end
			Result := variable_name_type_table_cache
		end

	typed_expression_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by the variables' static type
			-- For example, "has (v)" in LINKED_LIST [ANY] will be: {LINKED_LIST [ANY]}.has ({ANY})".
		do
			Result := typed_expression_text_with_variables (a_expression, variables)
		end

	equation_by_anonymous_expression_text (a_expr_text: STRING; a_state: EPA_STATE; a_pre_state: BOOLEAN): detachable EPA_EQUATION
			-- Assertion equation from `a_state' by anonymouse `a_expr_text' in
			-- the form of "{0}.has ({1})".
			-- Void if no such equation is found.
			-- `a_pre_state' indicates if `a_state' is from prestate.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_equation: EPA_EQUATION
			l_done: BOOLEAN
			l_cache: like equation_by_anonymous_expression_cache
			l_tbl: HASH_TABLE [EPA_EQUATION, STRING]
		do
			l_tbl := equation_by_anonymous_expression_cache.item (a_pre_state)
			l_tbl.search (a_expr_text)
			if l_tbl.found then
				Result := l_tbl.found_item
			else
				from
					l_cursor := a_state.new_cursor
					l_cursor.start
				until
					l_cursor.after or else l_done
				loop
					l_equation := l_cursor.item
					if a_expr_text ~ anonymous_expression_text (l_equation.expression) then
						Result := l_equation
						l_done := True
					else
						l_cursor.forth
					end
				end
				l_tbl.put (Result, a_expr_text)
			end
		end

	equation_by_anonymous_expression_cache: HASH_TABLE [HASH_TABLE [EPA_EQUATION, STRING], BOOLEAN]
			-- Cache for `equation_by_anonymous_expression_text'
		local
			l_tbl: HASH_TABLE [EPA_EQUATION, STRING]
		do
			if equation_by_anonymous_expression_cache_internal = Void then
				create equation_by_anonymous_expression_cache_internal.make (2)
				create l_tbl.make (100)
				l_tbl.compare_objects
				equation_by_anonymous_expression_cache_internal.put (l_tbl, True)
				create l_tbl.make (100)
				l_tbl.compare_objects
				equation_by_anonymous_expression_cache_internal.put (l_tbl, False)
			end
			Result := equation_by_anonymous_expression_cache_internal
		end

	equation_by_anonymous_expression_cache_internal: detachable like equation_by_anonymous_expression_cache
			-- Cache for `equation_by_anonymous_expression_cache'


	typed_expression_text_with_variables (a_expression: EPA_EXPRESSION; a_variables: EPA_HASH_SET [EPA_EXPRESSION]): STRING
			-- Text of `a_expression' with all accesses to variables replaced by the variables' static type
			-- For example, "has (v)" in LINKED_LIST [ANY] will be: {LINKED_LIST [ANY]}.has ({ANY})".
		do
			Result := expression_rewriter.expression_text (a_expression, variable_to_type_replacements (a_variables, context_type))
		end

	typed_expression_value_text_with_variables (a_expr_value: EPA_EXPRESSION_VALUE; a_variables: EPA_HASH_SET [EPA_EXPRESSION]): STRING
			-- Text of `a_expr_value' with all accesses to variables replaced by the variables' static type
			-- For example, "has (v)" in LINKED_LIST [ANY] will be: {LINKED_LIST [ANY]}.has ({ANY})".
		do
			Result := expression_rewriter.expression_value_text (a_expr_value, variable_to_type_replacements (a_variables, context_type))
		end

	context_type: detachable TYPE_A
			-- Context type in which types are resolved

	variable_by_name (a_name: STRING): EPA_EXPRESSION
			-- Variable in `variables' by `a_name'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]

		do
			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_cursor.item.text ~ a_name then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	variable_dynamic_type_table: HASH_TABLE [TYPE_A, STRING]
			-- Table from variable name in `variables' to their dynamic type
			-- Key of Result is variable name, value is the resolved dynamic type of that variable.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_context_type: detachable TYPE_A
		do
			l_context_type := context_type

			create Result.make (variables.count)
			Result.compare_objects
			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force (l_cursor.item.resolved_type (l_context_type), l_cursor.item.text)
				l_cursor.forth
			end
		end

	text_in_static_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		deferred
		end

	text_in_dynamic_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		deferred
		end

	text_in_anonymous_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		deferred
		end

	static_type_of_variable (a_variable: EPA_EXPRESSION): TYPE_A
			-- Static type of `a_variable'
		require
			a_variable_exists: variables.has (a_variable)
		deferred
		end

	as_objects: detachable SEM_OBJECTS
			-- Current as objects
		do
			if attached {SEM_OBJECTS} Current as l_objects then
				Result := l_objects
			end
		end

	as_feature_call_transition: detachable SEM_FEATURE_CALL_TRANSITION
			-- Current as feature call transition
		do
			if attached {SEM_FEATURE_CALL_TRANSITION} Current as l_call then
				Result := l_call
			end
		end

	uuid: detachable STRING
			-- UUID of current transition

	variable_with_uuid (a_variable: EPA_EXPRESSION): SEM_VARIABLE_WITH_UUID
			-- Variable with UUID for `a_variable'
		require
			uuid_exists: uuid /= Void
		do
			create Result.make (a_variable.text, uuid)
		end

	variable_with_uuid_from_name (a_var_name: STRING): SEM_VARIABLE_WITH_UUID
			-- Variable with UUID for the variable named `a_var_name'
		require
			a_var_name_exists: variable_by_name (a_var_name) /= Void
			uuid_exists: uuid /= Void
		do
			create Result.make (a_var_name, uuid)
		end

feature -- Status report

	has_variable (a_variable: EPA_EXPRESSION): BOOLEAN
			-- Does `a_variable' exist in `variables'?
		do
			Result := variables.has (a_variable)
		end

	has_variable_in_context (a_variable: EPA_EXPRESSION; a_context: EPA_CONTEXT): BOOLEAN
			-- Does `a_context' have variable `a_variable'?
		do
			Result := context.has_variable_named (a_variable.text)
		end

	is_variable_position_table_valid (a_table: HASH_TABLE [INTEGER, STRING]; a_context: like context): BOOLEAN
			-- Is `a_table' valid in terms of defining positions for variables in `a_context'.`variables'?
			-- Key of `a_table' is variable name, value is 0-based position of that variable'.
		local
			l_var_cursor: CURSOR
			l_pos_cursor: CURSOR
			l_vars: HASH_TABLE [TYPE_A, STRING]
			l_pos_set: DS_HASH_SET [INTEGER]
			l_pos: INTEGER
		do
			if a_table.count = l_vars.count then
				create l_pos_set.make (a_table.count)
				l_vars := a_context.variables
				l_var_cursor := l_vars.cursor
				from
				Result := True
					l_vars.start
				until
					l_vars.after or else not Result
				loop
					a_table.search (l_vars.key_for_iteration)
					if a_table.found then
						l_pos := a_table.found_item
						if l_pos >= 0 then
							Result := not l_pos_set.has (l_pos)
							if Result then
								l_pos_set.force_last (l_pos)
								l_vars.forth
							end
						else
							Result := False
						end
					else
						Result := False
					end
				end
				l_vars.go_to (l_var_cursor)
			end
		end

feature -- Type status report

	is_objects: BOOLEAN
			-- Is Current an object set queryable?
		do
		end

	is_snippet: BOOLEAN
			-- Is Current a snippet queryable?
		do
		end

	is_feature_call: BOOLEAN
			-- Is Current a feature call queryable?
		do
		end

	is_transition: BOOLEAN
			-- Is Current a transition querable (either a feature call or a snippet)?
		do
		end

feature -- Setting

	set_uuid (a_uuid: like uuid)
			-- Set `uuid' with `a_uuid'.
		do
			if a_uuid = Void then
				uuid := Void
			else
				uuid := a_uuid.twin
			end
		end

feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

feature{NONE} -- Implementation

	extend_variable (a_variable: EPA_EXPRESSION; a_index: INTEGER)
			-- Extend `a_vairable' at `a_index' in `variables'.
		require
			a_variable_not_exists: not variables.has (a_variable)
		do
			variables.force_last (a_variable)
			variable_positions.force_last (a_index, a_variable)
			reversed_variable_position.put (a_variable, a_index)
			clean_all_caches
		end

feature -- Variable name

	variable_name (a_variable: EPA_EXPRESSION; a_display_type: INTEGER): STRING
			-- Name for `a_variable'
			-- `a_display_type' decides the final output of the name.
			-- See `variable_position_name', `variable_normalized_position_name' and `variable_type_name' for details.
		require
			a_vairable_exists: has_variable (a_variable)
			a_display_type_valid: is_valid_variable_display_type (a_display_type)
		do
			create Result.make (32)
			if a_display_type = variable_position_name then
				Result := anonymous_variable_name (variable_positions.item (a_variable))
			elseif a_display_type = variable_type_name then
				Result := typed_expression_text (a_variable)
			elseif a_display_type = variable_normalized_position_name then
				Result.append (once "v_")
				Result.append_integer (variable_position (a_variable))
			elseif a_display_type = variable_original_name then
				Result.append (a_variable.text)
			end
		end

	is_valid_variable_display_type (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid variable display type?
		do
			Result :=
				a_type = variable_position_name or
				a_type = variable_normalized_position_name or
				a_type = variable_type_name or
				a_type = variable_original_name
		end

	variable_position_name: INTEGER = 1               -- {0}, {1}
	variable_normalized_position_name: INTEGER = 2    -- v_0, v_1
	variable_type_name: INTEGER = 3					  -- {LINKED_LIST [ANY]}, {ANY}
	variable_original_name: INTEGER = 4				  -- Original variable name


feature{NONE} -- Implementation

	equation_in_other_context (a_equation: EPA_EQUATION; a_source_context: ETR_CONTEXT; a_target_context: ETR_CONTEXT; a_type_checking_context: like context): detachable EPA_EQUATION
			-- Equation `a_equation' (originally in `a_source_context' viewed from `a_target_context'.
			-- Void if context transformation failed.
		local
			l_type: detachable TYPE_A
			l_expr: EPA_AST_EXPRESSION
			l_value: detachable EPA_EXPRESSION_VALUE
		do
			if attached {EXPR_AS} ast_in_other_context (a_equation.expression.ast, a_source_context, a_target_context) as l_new_expr then
				l_type := a_type_checking_context.expression_type (l_new_expr)
				if l_type /= Void then
					create l_expr.make_with_type (a_type_checking_context.class_, a_type_checking_context.feature_, l_new_expr, a_type_checking_context.class_, l_type)
					l_expr.set_boost (a_equation.expression.boost)
					if attached {EPA_AST_EXPRESSION_VALUE} a_equation.value as l_ast_value then
						fixme ("Use a visitor to process a_equation.value is safer. 29.4.2010 Jasonw")
						if attached {EXPR_AS} ast_in_other_context (l_ast_value.item, a_source_context, a_target_context) as l_new_value_ast then
							l_type := a_type_checking_context.expression_type (l_new_value_ast)
							if l_type /= Void then
								create {EPA_AST_EXPRESSION_VALUE} l_value.make (l_new_value_ast, l_type)
							end
						end
					else
						l_value := a_equation.value
					end
					if l_value /= Void then
						create Result.make (l_expr, l_value)
					end
				end
			end
		end

	adapt_state (a_source_state: EPA_STATE; a_target_state: EPA_STATE)
			-- Adapt `a_source_state' into `a_target_state'.
			-- Adaptation means possible renaming.
		local
			l_source_context: ETR_CONTEXT
			l_target_context: ETR_CONTEXT
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_context: like context
			l_equation: EPA_EQUATION
			l_class_ctxt: ETR_CLASS_CONTEXT
		do
				-- Calculate source and target context.
			create l_class_ctxt.make (a_source_state.class_)
			if attached {FEATURE_I} a_source_state.feature_ as l_feature then
				create {ETR_FEATURE_CONTEXT} l_source_context.make (l_feature, l_class_ctxt)
			else
				l_source_context := l_class_ctxt
			end
			l_target_context := context.feature_context

				-- Iterate through `a_source_state' and translate all the expressions in `a_source_state'
				-- to expressions in `l_target_context'.
			l_context := context
			from
				l_cursor := a_source_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if attached {EPA_EQUATION} equation_in_other_context (l_cursor.item, l_source_context, l_target_context, l_context) as l_new_equation then
					a_target_state.force_last (l_new_equation)
				end
				l_cursor.forth
			end
			clean_all_caches
		end

feature{NONE} -- Implementation

	is_variable_position_valid (a_position: INTEGER; a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' in `a_position' valid?
		do
			Result :=
				variables.has (a_variable) and then
				a_position >= 0
		end

	set_state (a_source_state: EPA_STATE; a_target_state: EPA_STATE)
			-- Adapt `a_source_state' into `a_target_state'.
		do
			a_target_state.wipe_out
			adapt_state (a_source_state, a_target_state)
		end

	set_state_unsafe (a_source_state: EPA_STATE; a_target_state: EPA_STATE)
			-- Directly set the content of `a_target_state' with `a_source_state'.
			-- No context rewriting is done.
		do
			a_target_state.wipe_out
			a_source_state.do_all (agent a_target_state.force_last)
		end

	variable_position_name_map: HASH_TABLE [STRING, INTEGER]
			-- Map from variable position to variable name
			-- Key is variable position, value is variable name
			-- Note: create a new table each time.
		local
			l_cursor: CURSOR
			l_reversed_variable_position: like reversed_variable_position
		do
			l_reversed_variable_position := reversed_variable_position
			create Result.make (l_reversed_variable_position.count)
			l_cursor := l_reversed_variable_position.cursor
			from
				l_reversed_variable_position.start
			until
				l_reversed_variable_position.after
			loop
				Result.put (l_reversed_variable_position.item_for_iteration.text, l_reversed_variable_position.key_for_iteration)
				l_reversed_variable_position.forth
			end
			l_reversed_variable_position.go_to (l_cursor)
		end

	expression_from_text (a_expr: STRING; a_context: like context): detachable EPA_EXPRESSION
			-- Expression from `a_expr', viewed from `a_context'.
			-- Void if the `a_expr' has syntax error or the resulting expression is not type checked.
		local
			l_expr_as: detachable EXPR_AS
			l_type: detachable TYPE_A
		do
			l_expr_as := a_context.ast_from_expression_text (a_expr)
			if l_expr_as /= Void then
				l_type := a_context.expression_type (l_expr_as)
				if l_type /= Void then
					create {EPA_AST_EXPRESSION} Result.make_with_type (a_context.class_, a_context.feature_, l_expr_as, a_context.class_, l_type)
				end
			end
		end

feature{NONE} -- Implementation

	anonymous_expression_cache: DS_HASH_TABLE [STRING, EPA_EXPRESSION]
			-- Cache for anonymous expressions
			-- Key is an expression value is the cached anonymous string of that expression
		do
			if anonymous_expression_internal = Void then
				create anonymous_expression_internal.make (200)
				anonymous_expression_internal.set_key_equality_tester (expression_equality_tester)
			end
			Result := anonymous_expression_internal
		end

	anonymous_expression_internal: detachable like anonymous_expression_cache
			-- Cache for `anonymous_expression_cache'

	clean_all_caches
			-- Clean all caches.
		do
			anonymous_expression_internal := Void
			anonymous_variables_table_cache := Void
			anonymous_variables_string_table_cache := Void
			variable_name_type_table_cache := Void
		end

	anonymous_variables_table_cache: detachable like anonymous_variables_table
			-- Cache for `anonymous_variables_table'

	anonymous_variables_string_table_cache: detachable like anonymous_variables_string_table
			-- Cache for `anonymous_variables_string_table'

	variable_name_type_table_cache: detachable like variable_name_type_table
			-- Cache for `variable_name_type_table'

invariant
	variable_positions_valid: variable_positions.for_all_with_key (agent is_variable_position_valid)
	variable_equality_tester_valid: variables.equality_tester = expression_equality_tester
	variable_positions_equality_tester_valid: variable_positions.key_equality_tester = expression_equality_tester
	variables_in_context: variables.for_all (agent has_variable_in_context)
end

