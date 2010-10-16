note
	description: "Calculator to measure the change from an expression to another expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_CHANGE_CALCULATOR

inherit
	EPA_SHARED_EQUALITY_TESTERS
		export{NONE}
			all
		end

	EPA_EXPRESSION_VALUE_VISITOR
		export{NONE}
			all
		end

	SHARED_TEXT_ITEMS
		export{NONE}
			all
		end

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			set_positive_relaxation_delta (10)
			set_negative_relaxation_delta (10)
		end

feature -- Basic operation

	change_set (a_source_state: EPA_STATE; a_target_state: EPA_STATE): DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			-- Change set from `a_source_state' to `a_target_state'
			-- Key of the resulting table is an expression in the state model,
			-- value is the list of changes of that expression.
		local
			l_exprs: EPA_HASH_SET [EPA_EXPRESSION]
		do
				-- Collect all expressions appear in either `a_source_state' or `a_target_state'.
			create l_exprs.make (a_source_state.count + a_target_state.count)
			l_exprs.set_equality_tester (expression_equality_tester)
			l_exprs.append (a_source_state.expressions)
			l_exprs.append (a_target_state.expressions)

				-- Calculate Result.
			create Result.make (l_exprs.count)
			Result.set_key_equality_tester (expression_equality_tester)
			l_exprs.do_if (
				agent put_expression_change (?, a_source_state, a_target_state, Result),
				agent should_change_be_calculated (?, a_source_state, a_target_state))
		end

feature -- Access

	positive_relaxation_delta: INTEGER
			-- The value for relaxed integer change calculation for positive case
			-- This delta only has effect if `is_integer_change_relaxation_enabled' is True.
			-- Default is 10.

	negative_relaxation_delta: INTEGER
			-- The avlue for relaxed integer change calculation for negative case
			-- This delta only has effect if `is_integer_change_relaxation_enabled' is True.
			-- Default is 10.

feature -- Status report	

	is_integer_change_relaxation_enabled: BOOLEAN
			-- Is integer change relaxation enabled?
			-- Default: False

	is_no_change_included: BOOLEAN
			-- Is no change included?
			-- If True, even when an expression is not changed in post-state,
			-- an instance of {EPA_EXPRESSION_NOCHANGE_SET} will be included.
			-- Default: False

feature -- Setting

	set_is_integer_change_relaxation_enabled (b: BOOLEAN)
			-- Set `is_integer_change_relaxation_enabled' with `b'.
		do
			is_integer_change_relaxation_enabled := b
		ensure
			is_integer_change_relaxation_enabled_set: is_integer_change_relaxation_enabled = b
		end

	set_positive_relaxation_delta (i: INTEGER)
			-- Set `positive_relaxation_delta' with `i'.
		do
			positive_relaxation_delta := i
		ensure
			positive_relaxation_delta_set: positive_relaxation_delta = i
		end

	set_negative_relaxation_delta (i: INTEGER)
			-- Set `negative_relaxation_delta' with `i'.
		do
			negative_relaxation_delta := i
		ensure
			negative_relaxation_delta_set: negative_relaxation_delta = i
		end

	set_is_no_change_included (b: BOOLEAN)
			-- Set `is_no_change_included' with `b'.
		do
			is_no_change_included := b
		ensure
			is_no_change_included_set: is_no_change_included = b
		end

feature{NONE} -- Implementation

	should_change_be_calculated (a_expression: EPA_EXPRESSION; a_source_state: EPA_STATE; a_target_state: EPA_STATE): BOOLEAN
			-- Should change of `a_expression' from `a_source_state' to `a_target_state' be calculated?
			-- Result is decided by the following table:
			--
			-- +---------------+-------------------------------------+
			-- | source/target | Not exists | Nonsensical |  Exists  |
			-- |---------------+--------------------------------------
			-- |   Not exists  |   False    |    False    |   True   |
			-- |---------------+------------+-------------+----------+
			-- |  Nonsensical  |   False    |    False    |   True   |
			-- |---------------+------------+-------------+----------+
			-- |    Exists     |   False    |    False    |   True   |
	        -- +---------------+------------+-------------+----------+
	   	local
			l_tgt_equation: detachable EPA_EQUATION
       	do
			l_tgt_equation := a_target_state.item_with_expression (a_expression)
			if l_tgt_equation /= Void then
				Result := not l_tgt_equation.value.is_nonsensical
			end
   		end

	put_expression_change (a_expression: EPA_EXPRESSION; a_source_state: EPA_STATE; a_target_state: EPA_STATE; a_changes: like change_set)
			-- Put changes of `a_expression' from `a_source_state' to `a_target_state' into `a_changes'.
		require
			a_expression_changed: should_change_be_calculated (a_expression, a_source_state, a_target_state)
		do
			expression := a_expression
			source_state := a_source_state
			target_state := a_target_state
			expression_change_set := a_changes

			if attached {EPA_EQUATION} a_target_state.item_with_expression (a_expression) as l_expr then
				l_expr.value.process (Current)
			end
		end

feature{NONE} -- Process/Data

	source_state: EPA_STATE
			-- Source state

	target_state: EPA_STATE
			-- Target state

	expression: EPA_EXPRESSION
			-- Expression whose change is being calcualted

	expression_change_set: like change_set
			-- Change set calculated so far

	new_single_value_change_set (a_value: EPA_EXPRESSION): EPA_EXPRESSION_CHANGE_VALUE_SET
			-- Expression change set containing only `a_value'
		do
			create {EPA_EXPRESSION_ENUMERATION_CHANGE_SET} Result.make (1)
			Result.set_equality_tester (expression_equality_tester)
			Result.force_last (a_value)
		end

	new_expression_change (a_expr: EPA_EXPRESSION; a_change_values: EPA_EXPRESSION_CHANGE_VALUE_SET; a_relative: BOOLEAN; a_relevance: DOUBLE): EPA_EXPRESSION_CHANGE
			-- Expression change
		do
			create Result.make (a_expr, a_change_values, a_relative)
			Result.set_relevance (a_relevance)
		end

feature{NONE} -- Process/Data

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		local
			l_equation: detachable EPA_EQUATION
			l_delta_expr: EPA_AST_EXPRESSION
			l_absolute_result_expr: EPA_AST_EXPRESSION
			l_changes: EPA_EXPRESSION_CHANGE_VALUE_SET
			l_change: EPA_EXPRESSION_CHANGE
			l_change_list: LINKED_LIST [EPA_EXPRESSION_CHANGE]
			l_delta: INTEGER
			l_no_change: EPA_EXPRESSION_NO_CHANGE_SET
		do
			l_equation := source_state.item_with_expression (expression)

			if l_equation /= Void and then attached {EPA_INTEGER_VALUE} l_equation.value as l_source_value then
				l_delta := a_value.item - l_source_value.item
				if l_delta /= 0 then
					create l_change_list.make

					create l_delta_expr.make_with_text (expression.class_, expression.feature_, l_delta.out, expression.written_class)
					l_change_list.extend (new_expression_change (expression, new_single_value_change_set (l_delta_expr), True, 1.0))
					create l_absolute_result_expr.make_with_text (expression.class_, expression.feature_, a_value.out, expression.written_class)
					l_change_list.extend (new_expression_change (expression, new_single_value_change_set (l_absolute_result_expr), False, 1.0))

						-- Integer delta relaxation
					if is_integer_change_relaxation_enabled then
						if l_delta > 0 then
							l_changes := create {EPA_INTEGER_RANGE}.make (expression.class_, 1, 1 + positive_relaxation_delta)
						else
							l_changes := create {EPA_INTEGER_RANGE}.make (expression.class_, -negative_relaxation_delta, 0)
						end
						l_change_list.extend (new_expression_change (expression, l_changes, True, 0.1))
					end

					expression_change_set.force_last (l_change_list, expression)
				elseif is_no_change_included then
					check l_equation /= Void end
					create l_no_change.make (l_equation.value)
					create l_change_list.make
					l_change_list.extend (new_expression_change (expression, l_no_change, True, 0.1))

					create l_absolute_result_expr.make_with_text (expression.class_, expression.feature_, a_value.out, expression.written_class)
					l_change_list.extend (new_expression_change (expression, new_single_value_change_set (l_absolute_result_expr), False, 0.1))

					expression_change_set.force_last (l_change_list, expression)
				end
			end
		end

	process_real_value (a_value: EPA_REAL_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 15.5.2010 Jasonw")
		end

	process_pointer_value (a_value: EPA_POINTER_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 15.5.2010 Jasonw")
		end

	process_boolean_value (a_value: EPA_BOOLEAN_VALUE)
			-- Process `a_value'.
		local
			l_equation: detachable EPA_EQUATION
			l_expr: EPA_AST_EXPRESSION
			l_changes: EPA_EXPRESSION_CHANGE_VALUE_SET
			l_change_list: LINKED_LIST [EPA_EXPRESSION_CHANGE]
			l_is_changed: BOOLEAN
			l_no_change: EPA_EXPRESSION_NO_CHANGE_SET
		do
			l_equation := source_state.item_with_expression (expression)
			if  l_equation = Void or else not l_equation.value.is_boolean then
				l_is_changed := True
			else
				if attached {EPA_BOOLEAN_VALUE} l_equation.value as l_src_value and then l_src_value.item /= a_value.item then
						-- We only catch the case that the value of `expression'
						-- has changed in Current transition.
					l_is_changed := True
				end
			end

			if l_is_changed then
				create l_expr.make_with_text (expression.class_, expression.feature_, a_value.item.out, expression.written_class)
				create l_change_list.make
				l_changes := new_single_value_change_set (l_expr)
				l_change_list.extend (new_expression_change (expression, l_changes, False, 1.0))
				expression_change_set.force_last (l_change_list, expression)
			elseif is_no_change_included then
				check l_equation /= Void end
				create l_no_change.make (l_equation.value)

				create l_change_list.make
				l_change_list.extend (new_expression_change (expression, l_no_change, False, 0.1))
				expression_change_set.force_last (l_change_list, expression)
			end
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		do
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- Process `a_value'.
		do
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 8.3.2010 Jasonw")
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 29.4.2010 Jasonw")
		end


	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'
		do
			to_implement ("To implement. 8.5.2010 Jasonw")
		end

	process_set_value (a_value: EPA_EXPRESSION_SET_VALUE)
			-- Process `a_value'.
		do
		end

	process_numeric_range_value (a_value: EPA_NUMERIC_RANGE_VALUE)
			-- Process `a_value'.
		do
		end

	process_integer_exclusion_value	(a_value: EPA_INTEGER_EXCLUSION_VALUE)
			-- Process `a_value'.
		do
		end

end
