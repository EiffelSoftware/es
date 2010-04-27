note
	description: "Summary description for {AUT_SERIALIZED_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DESERIALIZED_DATA

inherit

	EPA_HASH_CALCULATOR

	ITP_VARIABLE_CONSTANTS

	ERL_G_TYPE_ROUTINES

	EPA_UTILITY

create
	make

feature -- Initialization

	make (a_class_name, a_time, a_code, a_operands, a_variables, a_trace, a_hash_code, a_pre_state, a_post_state: STRING;
				a_pre_serialization, a_post_serialization: ARRAYED_LIST[NATURAL_8])
			-- Initialization.
		do
			class_name_str := a_class_name.twin
			time_str := a_time.twin
			code_str := a_code.twin
			operands_str := a_operands.twin
			variables_str := a_variables.twin
			trace_str := a_trace.twin
			hash_code_str := a_hash_code.twin
			pre_state_str := a_pre_state.twin
			post_state_str := a_post_state.twin
			pre_serialization := a_pre_serialization
			post_serialization := a_post_serialization
		end

feature -- Access string representation

	class_name_str: STRING
	time_str: STRING
	code_str: STRING
	operands_str: STRING
	variables_str: STRING
	trace_str: STRING
	hash_code_str: STRING
	pre_state_str: STRING
	post_state_str: STRING
	pre_serialization: ARRAYED_LIST[NATURAL_8]
	post_serialization: ARRAYED_LIST[NATURAL_8]

feature -- Access

	class_: detachable CLASS_C
			-- Target class of test case.

	test_case: detachable AUT_CALL_BASED_REQUEST
			-- {AUT_CALL_BASED_REQUEST} as the test case.

	operand_types: detachable HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Variables used in the test case and their types.

	variable_types: detachable HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- All reachable variables from the operands and their types.

	trans_hashcode: detachable STRING
			-- Hashcode string from

	target: ITP_VARIABLE
			-- Target of the test case.
		require
			test_case_attached: test_case /= Void
		do
			Result := test_case.target
		end

	feature_: FEATURE_I
			-- Feature tested in the test case.
		require
			test_case_attached: test_case /= Void
		do
			Result := test_case.feature_to_call
		end

feature -- Status report

	is_execution_successful: BOOLEAN
			-- Is the execution successful?
		do
			Result := trace_str.is_empty
		end

	is_good: BOOLEAN
			-- Is the data in good status?
		do
			Result := (not is_resolved implies
								class_name_str /= Void and then not class_name_str.is_empty and then
								time_str /= Void and then not time_str.is_empty and then
								code_str /= Void and then not code_str.is_empty and then
								operands_str /= Void and then not operands_str.is_empty and then
								variables_str /= Void and then --not variables_str.is_empty and then
								trace_str /= Void and then
								hash_code_str /= Void and then not hash_code_str.is_empty and then
								pre_state_str /= Void and then
								post_state_str /= Void and then
								pre_serialization /= Void and then
								post_serialization /= Void)
						and
					  (is_resolved implies
					  			class_ /= Void and then
					  			test_case /= Void and then
					  			operand_types /= Void and then
					  			variable_types /= Void and then
					  			trans_hashcode /= Void and then
								pre_serialization /= Void and then
								post_serialization /= Void)
		end

	is_resolved: BOOLEAN assign set_resolved
			-- Has the data been resolved?

feature -- Status set

	set_resolved (a_flag: BOOLEAN)
			-- Set the resolved flag.
		do
			is_resolved := a_flag
		end

feature -- Resolution

	resolve (a_system: SYSTEM_I; a_session: AUT_SESSION)
			-- Resolve test case information in 'a_system'.
		local
		do
			set_resolution_successful (True)
			class_ := first_class_starts_with_name (class_name_str)

			if is_resolution_successful then
				operand_types := resolve_vars (a_system, a_session, operands_str)
				variable_types := resolve_vars (a_system, a_session, variables_str)
			end

			if is_resolution_successful then
				resolve_test_case (a_system, a_session)
			end

			if is_resolution_successful then
				resolve_trans_hashcode (a_system, a_session)
			end

			set_resolved (is_resolution_successful)
		end

feature{NONE} -- Implementation

	resolve_trans_hashcode (a_system: SYSTEM_I; a_session: AUT_SESSION)
			-- Resolve transition hashcode from serialization data.
		require
			is_resolution_successful: is_resolution_successful
			hashcode_str_not_empty: hash_code_str /= Void and then not hash_code_str.is_empty
		local
			l_string: STRING
			l_start: INTEGER
		do
			l_string := hash_code_str
			-- Bypassing class name.
			l_start := l_string.index_of ('.', 1)
			-- Bypassing feature name.
			l_start := l_string.index_of ('.', l_start + 1)

			trans_hashcode := l_string.substring (l_start + 1, l_string.count)
		end


feature{NONE} -- Implementation

	is_resolution_successful: BOOLEAN assign set_resolution_successful
			-- Is the resolution successful?

	set_resolution_successful (a_status: BOOLEAN)
			-- Set the success status.
		do
			is_resolution_successful := a_status
		end

	resolve_vars (a_system: SYSTEM_I; a_session: AUT_SESSION; a_var_str: STRING): like operand_types
			-- Resolve the variables and their types from multiple lines of variable declarations.
		require
			is_resolution_successful: is_resolution_successful
			var_str_attached: a_var_str /= Void
--			table_attached: a_table /= Void
		local
			l_str: STRING
			l_list: LIST [STRING]
			l_line: STRING
			l_var_name: STRING
			l_type_str: STRING
			l_start_index, l_end_index: INTEGER
			l_var: ITP_VARIABLE
			l_index: INTEGER
			l_type: TYPE_A
			l_table: like operand_types
		do
			l_str := a_var_str

			-- Split types into lines of declarations
			l_str.prune_all ('%R')
			l_str.prune_all_leading ('%N')
			l_str.prune_all_trailing ('%N')
			l_list := l_str.split ('%N')

			-- Analyze variables and their types.
			from
				-- Make sure the table has size at least 1.
				create l_table.make (l_list.count + 1)
				l_table.compare_objects
				l_list.start
			until
				l_list.after
			loop
				l_line := l_list.item_for_iteration
				if not l_line.is_empty then
					l_end_index := l_line.index_of (':', 1)

					-- Variable.
					l_var_name := l_line.substring (1, l_end_index - 1)
					l_var_name.prune_all (' ')
					l_index := variable_index (l_var_name, variable_name_prefix)

					-- Type.
					l_type_str := l_line.substring (l_end_index + 1, l_line.count)
					l_type_str.prune_all (' ')
					l_type := base_type (l_type_str)

					create l_var.make (l_index)
					l_table.put (l_type, l_var)
				end

				l_list.forth
			end

			Result := l_table
		end

	resolve_test_case (a_system: SYSTEM_I; a_session: AUT_SESSION)
			-- Resolve test case.
		require
			is_resolution_successful: is_resolution_successful
		local
			l_parser: AUT_REQUEST_PARSER
			l_input: STRING
			l_request: AUT_REQUEST
		do
			l_input := ":execute "
			l_input.append (code_str)

			create l_parser.make (a_system, a_session.error_handler)
			l_parser.set_input (l_input)
			l_parser.parse

			if not l_parser.has_error and then attached {AUT_CALL_BASED_REQUEST} l_parser.last_request as lt_call then
				-- Explictly set the target type, which will be needed when finding out the 'feature_to_call'.
				if attached {AUT_INVOKE_FEATURE_REQUEST}lt_call as lt_invoke then
					lt_invoke.set_target_type (operand_types[lt_invoke.target])
				end
				test_case := lt_call
			else
				set_resolution_successful (False)
			end
		end

	variables_table_from_types (a_types: HASH_TABLE [TYPE_A, ITP_VARIABLE]): HASH_TABLE [STRING_8, STRING_8]
			-- Transform the variable-type information into string format.
		local
		do
			from
				create Result.make (a_types.count + 1)
				a_types.start
			until a_types.after
			loop
				Result.put (a_types.item_for_iteration.name, a_types.key_for_iteration.name (variable_name_prefix))
				a_types.forth
			end
		end


feature{NONE} -- Variable renaming

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		require else
			information_available: is_resolved and then is_good
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (3)
			l_list.force_last (class_.hash_code)
			l_list.force_last (feature_.feature_name_id)
			l_list.force_last (hash_code_str.hash_code)
--			l_list.force_last (pre_state.hash_code)

			Result := l_list
		end

--	resolve_formal_operand_states (a_system: SYSTEM_I; a_session: AUT_SESSION)
--			-- Analyze operand states as equations in terms of the formal arguments.
--		require
--			is_resolution_successful: is_resolution_successful
--			test_case_attached: test_case /= Void
--		local
--		do

--		end


--	resolve_formal_operand_states (a_system: SYSTEM_I; a_session: AUT_SESSION)
--			-- Analyze operand states as equations in terms of the formal arguments.
--		require
--			is_resolution_successful: is_resolution_successful
--			test_case_attached: test_case /= Void
--		local
--			l_feature: FEATURE_I
--			l_args: FEAT_ARG
--			l_actual_operands: SPECIAL [INTEGER]
--			l_formal_args: FEAT_ARG
--			l_formal_operands: LINKED_LIST[STRING]
--			i: INTEGER
--			l_formal_actual_table: HASH_TABLE [STRING, STRING]
--		do
--			l_feature := test_case.feature_to_call
----			l_args := test_case.feature_to_call.arguments
--			l_actual_operands := test_case.operand_indexes

--			-- Name list of formal operands.
--			l_formal_args := l_feature.arguments
--			create l_formal_operands.make
--			if l_formal_args /= Void then
--				from
--					i := 1
--				until
--					i > l_formal_args.count
--				loop
--					l_formal_operands.force (l_formal_args.item_name (i))
--					i := i + 1
--				end
--			end

--			l_formal_operands.put_front ("Current")
--			if l_feature.type /= void_type  then
--				l_formal_operands.force ("Result")
--			end
--			check l_actual_operands.count = l_formal_operands.count end

--			-- Map from formal operand name to actual operand index.
--			create l_formal_actual_table.make (l_formal_operands.count)
--			l_formal_actual_table.compare_objects
--			from
--				i := l_actual_operands.lower
--				l_formal_operands.start
--			until
--				i > l_actual_operands.upper
--			loop
--				l_formal_actual_table.put (variable_name_prefix + l_actual_operands.item (i).out, l_formal_operands.item_for_iteration)

--				i := i + 1
--				l_formal_operands.forth
--			end

--			pre_state := formal_operands_state (a_system, a_session, pre_state_str, l_formal_actual_table)
--			post_state := formal_operands_state (a_system, a_session, post_state_str, l_formal_actual_table)
--		end

--	formal_operands_state (a_system: SYSTEM_I; a_session: AUT_SESSION; a_report: STRING_8; a_renaming_table: HASH_TABLE [STRING, STRING]): EPA_STATE_TRANSITION_MODEL_STATE
--			-- State based on formal operands.
--		require
--			is_resolution_successful: is_resolution_successful
--		local
--			l_str: STRING
--			l_list: LIST [STRING]
--			l_line: STRING
--			l_var_name: detachable STRING
--			l_state_line: STRING
--			l_var_state: detachable LINKED_LIST[STRING]
--			l_var_state_table: HASH_TABLE[LINKED_LIST[STRING], STRING]
--			l_formal_operand_name: STRING
--			l_var_index: INTEGER

--			l_exp_str: STRING
--			l_val_str: STRING
--			l_start_index, l_end_index: INTEGER
----			l_new_var_index: INTEGER
----			l_new_var_name: STRING
--			l_expr: EPA_AST_EXPRESSION
--			l_value: EPA_EXPRESSION_VALUE
--			l_equations: HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_AST_EXPRESSION]
--		do
--			l_str := a_report.twin

--			-- Split report into lines
--			l_str.prune_all ('%R')
--			l_str.prune_all_leading ('%N')
--			l_str.prune_all_trailing ('%N')
--			l_list := l_str.split ('%N')

--			-- Collect all the state summary information for the actual arguments/target
--			from
--				create l_var_state_table.make (l_list.count)
--				l_var_state_table.compare_objects
--				l_list.start
--			until
--				l_list.after
--			loop
--				l_line := l_list.item_for_iteration

--				if l_line.starts_with ("--|") then
--					-- Object state.
--					l_state_line := l_line.substring (4, l_line.count)
--					l_var_state.force (l_state_line)
--				elseif l_line.starts_with ("--v") then
--					-- Put the previous var state into table.
--					if l_var_name /= Void and then l_var_state /= Void and then not l_var_state.has (l_var_name) then
--						l_var_state_table.put (l_var_state, l_var_name)
--						l_var_name := Void
--						l_var_state := Void
--					end

--					-- Start new var and var_state.
--					l_start_index := 3
--					l_end_index := l_line.index_of (':', l_start_index) - 1
--					l_var_name := l_line.substring (l_start_index, l_end_index)
--					create l_var_state.make
--				end

--				l_list.forth
--			end
--			-- Put the ending state into table.
--			if l_var_name /= Void and then l_var_state /= Void and then not l_var_state.has (l_var_name) then
--				l_var_state_table.put (l_var_state, l_var_name)
--				l_var_name := Void
--				l_var_state := Void
--			end

--			-- For each formal argument or the target of non-creation feature call,
--			-- 	find the actual argument or the target object as well as the related state summary,
--			--  then generate the state summary w.r.t the formal arguments.
--			from
--				a_renaming_table.start
--				create l_equations.make (l_list.count + 1)
--				l_equations.compare_objects
--			until
--				a_renaming_table.after
--			loop
--				l_formal_operand_name := a_renaming_table.key_for_iteration
--				l_var_name := a_renaming_table.item_for_iteration

--				if l_var_state_table.has (l_var_name) then
--					l_var_state := l_var_state_table.item (l_var_name)
--					from l_var_state.start
--					until l_var_state.after
--					loop
--						l_state_line := l_var_state.item_for_iteration

--						if not l_state_line.is_empty then
--							if l_state_line ~ "[[Void]]" then
--								-- Void argument.
--								create l_expr.make_with_text (class_, feature_, l_formal_operand_name, class_)
--								create {EPA_VOID_VALUE} l_value.make
--							else
--								-- Generate predicates about current formal operand.
--								-- Prepend the name of formal argument, with a '.', to the expression, which ends with an '='.
--								l_start_index := 1
--								l_end_index := l_state_line.last_index_of ('=', l_state_line.count) - 1
--								l_exp_str := l_formal_operand_name.twin
--								l_exp_str.append (once ".")
--								l_exp_str.append (l_state_line.substring (l_start_index, l_end_index))
--								create l_expr.make_with_text (class_, feature_, l_exp_str, class_)

--								l_start_index := l_end_index + 2
--								l_val_str := l_state_line.substring (l_start_index, l_state_line.count)
--								l_val_str.prune_all (' ')
--								if l_val_str.is_integer then
--									create {EPA_INTEGER_VALUE} l_value.make (l_val_str.to_integer)
--								elseif l_val_str.is_boolean then
--									create {EPA_BOOLEAN_VALUE} l_value.make (l_val_str.to_boolean)
--								else
--									check
--										not_supported: False
--									end
--								end
--							end

--							if not l_equations.has (l_expr) then
--								l_equations.put (l_value, l_expr)
--							end
--						end

--						l_var_state.forth
--					end
--				end
--				a_renaming_table.forth
--			end

--			create Result.make_from_expression_value (l_equations, class_, feature_, operand_types)
--		end

--	variable_index_map: HASH_TABLE [INTEGER, INTEGER]
--			-- Index map between variables before and after the renaming.
--			-- Key: variable index before renaming
--			-- Val: variable index after renaming

--	register_variable_renaming (a_old_index, a_new_index: INTEGER; a_type: TYPE_A)
--			-- Register a variable renaming rule.
--			-- The variable with 'a_old_index' will have 'a_new_index' after renaming,
--			-- while its type stays the same.
--		local
--			l_new_var: ITP_VARIABLE
--		do
--			variable_index_map.put (a_new_index, a_old_index)

--			create l_new_var.make (a_new_index)
--			operand_types.put (a_type, l_new_var)
--		end

--	apply_renaming (a_str: STRING)
--			-- Apply the renaming rules to 'a_str'.
--			-- To deal with the situations like renameing [v2, v9] to [v1, v2],
--			-- we first rename the variables to [v(9+1), v(9+2)], (with offset = 9)
--			-- then rename them again to [v1, v2]
--		local
--			l_order: TWO_WAY_SORTED_SET [INTEGER]
--			l_old_index, l_new_index, l_tmp_index: INTEGER
--			l_offset: INTEGER
--			l_old_name, l_new_name: STRING
--		do
--			-- Collect and order the old variable indexes
--			from
--				create l_order.make
--				variable_index_map.start
--			until
--				variable_index_map.after
--			loop
--				l_order.extend (variable_index_map.key_for_iteration)
--				variable_index_map.forth
--			end
--			l_offset := l_order.max

--			-- First round of renaming
--			from l_order.finish
--			until l_order.before
--			loop
--				l_old_index := l_order.item_for_iteration
--				l_tmp_index := l_offset + variable_index_map[l_old_index]

--				rename_variable (a_str, l_old_index, l_tmp_index)

--				l_order.back
--			end

--			-- Second round of renaming
--			from l_order.finish
--			until l_order.before
--			loop
--				l_old_index := l_order.item_for_iteration
--				l_new_index := variable_index_map[l_old_index]
--				l_tmp_index := l_offset + l_new_index

--				rename_variable (a_str, l_tmp_index, l_new_index)

--				l_order.back
--			end
--		end

--	rename_variable (a_str: STRING; a_old_index, a_new_index: INTEGER)
--			-- Rename all the variables in 'a_str' with 'a_old_index' to 'a_new_index'.
--		local
--			l_old_name, l_new_name: STRING
--			l_start, l_length, l_total: INTEGER
--		do
--			l_old_name := variable_name_prefix.twin
--			l_old_name.append_integer (a_old_index)
--			l_new_name := variable_name_prefix.twin
--			l_new_name.append_integer (a_new_index)

--			from
--				l_start := a_str.substring_index (l_old_name, 1)
--				l_length := l_old_name.count
--				l_total := a_str.count
--			until
--				l_start = 0
--			loop
--				if (l_start + l_length > l_total) or else not a_str[l_start + l_length].is_digit then
--					-- Matching variable name found, rename it.
--					a_str.replace_substring (l_new_name, l_start, l_start + l_length - 1)

--					-- Search for the next apperance.
--					l_start := a_str.substring_index (l_old_name, l_start)
--				else
--					-- Part of a longer name, skip.
--				end
--			end
--		end

--	resolve_object_states (a_system: SYSTEM_I; a_session: AUT_SESSION; a_report: STRING):EPA_STATE_TRANSITION_MODEL_STATE
--			-- Resolve object states reported, save the result into `state'.
--		require
--			is_resolution_successful: is_resolution_successful
--		local
--			l_context: SEM_TRANSITION_CONTEXT
--			l_exp_type: TYPE_A
--			l_str: STRING
--			l_list: LIST [STRING]
--			l_line: STRING
--			l_var_name: STRING
--			l_exp_str: STRING
--			l_val_str: STRING
--			l_start_index, l_end_index: INTEGER
--			l_new_var_index: INTEGER
--			l_new_var_name: STRING
--			l_expr: EPA_AST_EXPRESSION
--			l_value: EPA_EXPRESSION_VALUE
--			l_equations: HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_AST_EXPRESSION]
--		do
--			create l_context.make_with_variable_names (variables_table_from_types(operand_types))

--			l_str := a_report.twin

--			-- Split types into lines of declarations
--			l_str.prune_all ('%R')
--			l_str.prune_all_leading ('%N')
--			l_str.prune_all_trailing ('%N')
--			l_list := l_str.split ('%N')

--			from
--				create l_equations.make (l_list.count + 1)
--				l_equations.compare_objects
--				l_list.start
--			until
--				l_list.after
--			loop
--				l_line := l_list.item_for_iteration

--				if l_line.starts_with ("--|") then
--					-- Object state.
--					l_start_index := 4
--					l_end_index := l_line.last_index_of ('=', l_line.count) - 1

--					-- Prepend "var." to the expression
--					l_exp_str := l_var_name.twin
--					l_exp_str.append (once ".")
--					l_exp_str.append (l_line.substring (l_start_index, l_end_index))
--					l_exp_type := l_context.expression_text_type (l_exp_str)
--					create l_expr.make_with_text_and_type (l_context.class_, l_context.feature_, l_exp_str, l_context.class_, l_exp_type)
----					create l_expr.make_with_text (class_, Void, l_exp_str, class_)

--					-- Value of the expression.
--					l_start_index := l_end_index + 2
--					l_val_str := l_line.substring (l_start_index, l_line.count)
--					l_val_str.prune_all (' ')
--					if l_val_str.is_integer then
--						create {EPA_INTEGER_VALUE} l_value.make (l_val_str.to_integer)
--					elseif l_val_str.is_boolean then
--						create {EPA_BOOLEAN_VALUE} l_value.make (l_val_str.to_boolean)
--					else
--						check not_supported: False end
--					end

--					-- Store the <expr, value> pair
--					if not l_equations.has (l_expr) then
--						l_equations.put (l_value, l_expr)
--					end

--				elseif l_line.starts_with ("--") then
--					-- Object name and type.
--					l_start_index := l_line.index_of ('v', 1)
--					l_end_index := l_line.index_of (':', l_start_index) - 1
--					l_var_name := l_line.substring (l_start_index, l_end_index)
--					l_var_name.prune_all (' ')
--				end

--				l_list.forth
--			end

--			create Result.make_from_expression_value (l_equations, class_, feature_, operand_types)
--		end


--	resolve_and_rename_variables (a_system: SYSTEM_I; a_session: AUT_SESSION)
--			-- Resolve the variables, their types, and rename/reorder the variables.
--			-- The variables are renamed according to their order of apperance.
--		require
--			is_resolution_successful: is_resolution_successful
--		local
--			l_str: STRING
--			l_list: LIST [STRING]
--			l_line: STRING
--			l_var_name: STRING
--			l_type_str: STRING
--			l_start_index, l_end_index: INTEGER
--			l_var_old, l_var_new: ITP_VARIABLE
--			l_old_index, l_new_index: INTEGER
--			l_type: TYPE_A
--		do
--			l_str := operands_str

--			-- Split types into lines of declarations
--			l_str.prune_all ('%R')
--			l_str.prune_all_leading ('%N')
--			l_str.prune_all_trailing ('%N')
--			l_list := l_str.split ('%N')

--			-- Analyze variables and their types.
--			from
--				create operand_types.make (l_list.count + 1)
--				operand_types.compare_objects
--				create variable_index_map.make (l_list.count + 1)
--				variable_index_map.compare_objects
--				l_new_index := 1
--				l_list.start
--			until l_list.after
--			loop
--				l_line := l_list.item_for_iteration
--				l_end_index := l_line.index_of (':', 1)

--				-- Variable.
--				l_var_name := l_line.substring (1, l_end_index - 1)
--				l_var_name.prune_all (' ')
--				l_old_index := variable_index (l_var_name, variable_name_prefix)

--				-- Type.
--				l_type_str := l_line.substring (l_end_index + 1, l_line.count)
--				l_type_str.prune_all (' ')
--				l_type := base_type (l_type_str)

--				-- The order of variables
--				register_variable_renaming (l_old_index, l_new_index, l_type)

--				l_new_index := l_new_index + 1
--				l_list.forth
--			end

--			-- Apply variable renaming to relevant strings.
--			apply_renaming (operands_str)
--			apply_renaming (code_str)
--			apply_renaming (pre_state_str)
--			apply_renaming (post_state_str)
--		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
