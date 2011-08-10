note
	description: "Class to collect feature calls from an AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_COLLECTOR

inherit
	AST_ITERATOR
		redefine
			-- CALL_AS
			---- ACCESS_AS
			process_current_as,
			process_precursor_as,
			process_result_as,
			process_access_feat_as,
			------ ACCESS_FEAT_AS
			-------- (ACCESS_INV_AS)
			---------- (ACCESS_ASSERT_AS)
			---------- (ACCESS_ID_AS)
			-------- (STATIC_ACCESS_AS)
			---- CREATION_EXPR_AS
			process_bang_creation_expr_as,
			process_create_creation_expr_as,
			---- NESTED_AS
			process_nested_as,
			---- NESTED_EXPR_AS
			process_nested_expr_as,

			-- PARAMETER_LIST_AS
			process_parameter_list_as,

			-- INSTRUCTION_AS
			---- CREATION_AS
			process_creation_as

		end

	EPA_UTILITY

	EPA_FEATURE_CALL_COLLECTOR_UTILITY

create
	make

feature {NONE} -- Initialization

	make
			-- Creation procedure
		do
				-- Initialize the list of calls and the stacks used for nested calls
			create last_calls.make (16)
			create nesting_stacks.make
		end

feature -- Access

	last_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]
			-- Feature calls collected by last call to `collect'
			-- Keys are break point slots, values are feature calls
			-- associated with those break points.
			-- Note: since this class works in AST level, there is
			-- no guarantee that the CALL_AS nodes represents type-wise valid
			-- Eiffel expressions or statements. No type checking is done.

	last_calls_without_breakpoints: LINKED_LIST [CALL_AS]
			-- Calls from `last_calls, with calls from different calls
			-- at various breakpoints accumulated together, and with
			-- duplicates removed
		do
			Result := calls_without_breakpoints (last_calls)
		end

feature -- Basic operations

	collect_from_ast (a_ast: AST_EIFFEL; a_variables: LINEAR_SUBSET [STRING])
			-- Collect feature calls from `a_ast' which mentions `a_variables',
			-- and make results available in `last_calls'.
			-- `a_variables' is a set of variables that `a_ast' is allow to access.
			-- The set may also include reserved entity names such as Current and Result.
			-- The variable names are case insensitive.
		local
			l_ast: AST_EIFFEL
		do
			l_ast := ast_with_breakpoints (a_ast)

			allowed_variables := a_variables
			l_ast.process (Current)
		end

feature -- Access

	allowed_variables: LINEAR_SUBSET [STRING]

feature {NONE} -- Implementation

	breakpoint_initializer: ETR_BP_SLOT_INITIALIZER
			-- Break point initializer
		once
			create Result
		end

	ast_with_breakpoints (a_ast: AST_EIFFEL): AST_EIFFEL
			-- A copy of `a_ast' with breakpoint information initialized.
			-- Do not change `a_ast'.
		local
			l_text: STRING
		do
			l_text := text_from_ast (a_ast)
			if attached {EXPR_AS} a_ast as l_expr then
				Result := ast_from_expression_text (l_text)
			else
				Result := ast_from_compound_text (l_text)
			end
			breakpoint_initializer.init_from (Result)
		end

	add_call (a_as: CALL_AS; a_key: INTEGER)
			-- Add a call to the last_calls hash table
		local
			l_list: LINKED_LIST [CALL_AS]
		do
			if last_calls.has (a_key) then
					-- Call already exists with this breakpoint slot --> at to the existing list of calls
				last_calls.item (a_key).extend (a_as)
			else
					-- No all with this breakpoint slot yet --> create and add a new list containing this call
				create l_list.make
				l_list.extend (a_as)
				last_calls.put (l_list, a_key)
			end
		end

	current_breakpoint_slot: INTEGER
			-- The breakpoint slot of the currently processed call

	is_nesting: BOOLEAN
			-- Is processing inside an nested call?		

	is_nested_expression: BOOLEAN
			-- Is the nested call of type NESTED_EXPR_AS?

	nested_expr_target: EXPR_AS
			-- The target of a nested call of type NESTED_EXPR_AS

	nesting_stacks: LINKED_STACK[LINKED_STACK[ACCESS_AS]]
			-- Stacks for processing nested calls.

	current_stack: LINKED_STACK[ACCESS_AS]
			-- The current stack where nested calls are kept.
		local
			l_stack: LINKED_STACK[ACCESS_AS]
		do
			if nesting_stacks.is_empty then
				create l_stack.make
				nesting_stacks.put (l_stack)
			end
			Result := nesting_stacks.item
		end

	enter_nesting
			-- Enter a nested call.
		do
			is_nesting := True
			put_nesting_stack
		end

	exit_nesting
			-- Exit a nested call.
		do
			is_nesting := False

				-- Add nested calls to the list of calls
			add_current_nested_calls

			current_stack.remove
			if current_stack.count = 1 then
				current_stack.wipe_out
			end
			remove_nesting_stack
		end

	add_current_nested_calls
			--
		local
			l_list: ARRAYED_LIST [ACCESS_AS]
			l_target_call: ACCESS_AS
			l_nested_call: NESTED_AS
			l_nested_expr_call: NESTED_EXPR_AS
			l_message_list: LINKED_LIST [CALL_AS]
		do
			l_list := current_stack.linear_representation
			if not l_list.is_empty then

					-- If it's a NESTED_AS, get the target and prune it out of the stack. Also add the target call.
					-- Otherwise, the target is not on the stack but stored in the variable 'nested_expr_target'
				if not is_nested_expression then
					l_target_call := l_list.last
					l_target_call.set_breakpoint_slot (current_breakpoint_slot)
					add_call (l_target_call, current_breakpoint_slot)
					l_list.finish
					l_list.remove
				end

					-- Get all messages that have to be added as a call on the corresponding target
				create l_message_list.make
				from l_list.start
				until l_list.after
				loop
					from l_message_list.start
					until l_message_list.after
					loop
							-- Prepend the current item to the already existing calls in the list of messages
						create l_nested_call.initialize (l_list.item, l_message_list.item, Void)
						l_nested_call.set_breakpoint_slot (current_breakpoint_slot)
						l_message_list.replace (l_nested_call)
						l_message_list.forth
					end
						-- Add the current item to the list of messages
					l_message_list.extend (l_list.item)
					l_list.forth
				end

					-- Add all calls to the list of calls
				from l_message_list.start
				until l_message_list.after
				loop
					if is_nested_expression then
							-- NESTED_EXPR_AS: the target is stored in variable 'nested_expr_target'
						create l_nested_expr_call.initialize (nested_expr_target, l_message_list.item, Void, Void, Void)
						l_nested_expr_call.set_breakpoint_slot (current_breakpoint_slot)
						add_call (l_nested_expr_call, current_breakpoint_slot)
					else
							-- NESTED_AS: the target is stored in local variable l_target_call
						create l_nested_call.initialize (l_target_call, l_message_list.item, Void)
						l_nested_call.set_breakpoint_slot (current_breakpoint_slot)
						add_call (l_nested_call, current_breakpoint_slot)
					end
					l_message_list.forth
				end

			end
		end

	put_nesting_stack
			-- Put a new stack on nesting_stacks
		local
			l_stack: LINKED_STACK [ACCESS_AS]
		do
			create l_stack.make
			nesting_stacks.put (l_stack)
		end

	remove_nesting_stack
			-- Remove the top stack of nesting_stacks
		do
			nesting_stacks.remove
		end

feature -- Visitor Routines

	process_current_as (a_as: CURRENT_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_precursor_as (a_as: PRECURSOR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
				-- Process parameters
			precursor (a_as)
		end

	process_result_as (a_as: RESULT_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
		end

	process_access_feat_as (a_as: ACCESS_FEAT_AS)
		do
			if is_nesting then
					-- If it's part of a nested call, only put the it on the stack
				current_stack.put (a_as)
			else
					-- If it's not part of a nested call, add call to the list of calls
				add_call (a_as, a_as.breakpoint_slot)
			end
				-- Process parameters
			precursor (a_as)
		end

	process_bang_creation_expr_as (a_as: BANG_CREATION_EXPR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
			safe_process (a_as.call.internal_parameters)
		end

	process_create_creation_expr_as (a_as: CREATE_CREATION_EXPR_AS)
		do
			add_call (a_as, a_as.breakpoint_slot)
			safe_process (a_as.call.internal_parameters)
		end

	process_nested_as (a_as: NESTED_AS)
		do
--			TODO: wrap feature body with this if-clause
--			if allowed_variables.has (a_as.target.access_name) then
					-- Only add calls if the target of the nested call is a variable that is allowed to access
--			end


			if is_nesting then
				 	-- In this case, no calls have to be added to the list of calls
				 precursor (a_as)

			else
					-- Set flag that it's a NESTED_AS, enter nesting
				is_nested_expression := False
				enter_nesting

				precursor (a_as)

					-- Add nested calls if it's not part of a NESTED_EXPR_AS, exit nesting
				if not is_nested_expression then
					current_breakpoint_slot := a_as.breakpoint_slot
					exit_nesting
				end

			end
		end

	process_nested_expr_as (a_as: NESTED_EXPR_AS)
		local
			l_target_expr: EXPR_AS
		do
				-- Set flag that it's a NESTED_EXPR_AS, enter nesting
			is_nested_expression := True
			enter_nesting

				-- Process the message of the call
			a_as.message.process (Current)

				-- Set target and add nested calls
			nested_expr_target := a_as.target
			current_breakpoint_slot := a_as.breakpoint_slot
			exit_nesting

				-- If the target contains a call, process this one too
			l_target_expr := a_as.target
			if attached {EXPR_CALL_AS} l_target_expr as l_expr_call then
				l_expr_call.call.breakpoint_slot := a_as.breakpoint_slot
				l_expr_call.call.process (Current)
			end
		end

	process_creation_as (a_as: CREATION_AS)
		local
			l_nested_as: NESTED_AS
			l_id: ID_AS
			l_feat_call: ACCESS_FEAT_AS
		do
			if a_as.call /= Void then

				if allowed_variables.has (a_as.target.access_name) then
						-- A creation instruction of the form "create target.creation_procedure" is added as a nested_as
					create l_nested_as.initialize (a_as.target, a_as.call, Void)
				end

			else
					-- For a creation instruction of the form "create target", add a dummy message "default_create" to a nested_as.
				create l_id.initialize ("default_create")
				create l_feat_call.initialize (l_id, Void)
				create l_nested_as.initialize (a_as.target, l_feat_call, Void)
			end

				-- Set breakpoint slot and process the created nested call
			l_nested_as.set_breakpoint_slot (a_as.breakpoint_slot)
			l_nested_as.process (Current)
		end

	process_parameter_list_as (a_as: PARAMETER_LIST_AS)
		local
			is_nesting_backup: BOOLEAN
			is_nested_expr_backup: BOOLEAN
		do
				-- Save value of is_nesting and is_nested_expr flags and set is_nesting to False
			is_nested_expr_backup := is_nested_expression
			is_nesting_backup := is_nesting
			is_nesting := False

				-- Process parameters
			precursor (a_as)

				-- Reset is_nesting and is_nested_expr flags
			is_nesting := is_nesting_backup
			is_nested_expression := is_nested_expr_backup
		end

end
