note
	description: "Summary description for {AUT_FEATURE_PRECONDITION_BREAKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_PRECONDITION_BREAKER

inherit

	AUT_TASK

	AUT_SHARED_CONSTANTS
		export {NONE} all end

	ERL_G_TYPE_ROUTINES

	REFACTORING_HELPER

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	SHARED_TYPES

	EPA_UTILITY
		undefine
			system
		end

create
	make

feature{NONE} -- Implementation

	make (a_system: like system; a_interpreter: like interpreter; a_error_handler: like error_handler;
				a_invariant: like current_invariant; a_combinations: LINKED_LIST [SEMQ_RESULT])
			-- Initialization.
		require
			invariant_attached: a_invariant /= Void
			combination_not_empty: a_combinations /= Void and then not a_combinations.is_empty
		do
			system := a_system
			interpreter := a_interpreter
			error_handler := a_error_handler
			current_invariant := a_invariant
			create object_combinations.make
			a_combinations.do_all (agent object_combinations.force_last)
		end

feature -- Access

	system: SYSTEM_I
			-- System

	interpreter: AUT_INTERPRETER_PROXY
			-- Proxy to the interpreter.

	error_handler: AUT_ERROR_HANDLER
			-- Error handler.

	current_invariant: AUT_STATE_INVARIANT
			-- State invariant to break.

	object_combinations: DS_LINKED_LIST [SEMQ_RESULT]
			-- Objects combinations that might break the state invariant.

	class_: CLASS_C
			-- Class of `current_invariant'.
		do
			Result := current_invariant.context_class
		end

	feature_: FEATURE_I
			-- Feature of `current_invariant'.
		do
			Result := current_invariant.feature_
		end

feature -- Status

	has_next_step: BOOLEAN
			-- Is there a next step to execute?
		do
			Result := not should_quit and then not object_combinations.is_empty
		end

feature -- Execute

	start
		do
			should_quit := false
		end

	step
		local
			l_queryables: LINKED_LIST [SEM_QUERYABLE]
			l_result: DS_ARRAYED_LIST [TUPLE [var_index: INTEGER; var_type: TYPE_A]]
			l_variable_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			l_nbr_variables: INTEGER
		do
			current_combination := object_combinations.first
			object_combinations.remove_first

			if not should_quit and then attached current_combination as lv_combination and then not lv_combination.queryables.is_empty then
				has_error := False
				collect_provided_operands

				if interpreter.is_executing and then interpreter.is_ready and then not has_error then
					batch_assign_provided_operands_to_variables
				end

				if interpreter.is_executing and then interpreter.is_ready and then not has_error
						and then is_missing_operand
				then
					prepare_missing_operand_objects
				end

				if interpreter.is_executing and then interpreter.is_ready and then not has_error then
					invoke_feature_with_operands
				end
			end
		end

	cancel
		do
			should_quit := True
		end

feature{NONE} -- Access

	should_quit: BOOLEAN
			-- Should the task quit executing?

	has_error: BOOLEAN
			-- Has error happened in breaking the precondition?

	current_combination: SEMQ_RESULT
			-- Current object combination used to break `current_invariant'.

	provided_object_serializations: DS_HASH_TABLE [STRING, STRING]
			-- Serialization data containing all provided operand objects.
			-- Key: test case UUID;
			-- Val: Objects associated with the test case.

	operand_for_invokation: DS_HASH_TABLE[TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A], INTEGER]
			-- Information about the operands that are provided.
			-- Key: operand position in a call to `feature_'.
			-- Val: information about the operand at that position.

feature{NONE} -- Implementation

	is_missing_operand: BOOLEAN
			-- Is `operand_for_invokation' not enough for invokation?
		local
			l_operand_count: INTEGER
			l_operand_index: INTEGER
		do
			l_operand_count := feature_.argument_count + 1
			from
				Result := False
				l_operand_index := 0
			until
				Result or else l_operand_index >= l_operand_count
			loop
				if not operand_for_invokation.has (l_operand_index) or else operand_for_invokation.item (l_operand_index).var = Void then
					Result := True
				end
				l_operand_index := l_operand_index + 1
			end
		end

	collect_provided_operands
			-- Collect operands that have been provided.
			-- Make the result available in `provided_object_serializations' and `operand_for_invokation'.
		require
			combination_attached: current_combination /= Void
		local
			l_queryables: LINKED_LIST [SEM_QUERYABLE]
			l_operand_position_name_mapping: DS_HASH_TABLE [STRING, INTEGER]
			l_operand_name_var_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			l_uuid_object_types_mapping: DS_HASH_TABLE [HASH_TABLE [TYPE_A, STRING], STRING]
			l_serialization_string: STRING
			l_interpreter_var: ITP_VARIABLE
			l_operand_position, l_operand_count, l_var_index: INTEGER
			l_operand_name, l_var_name, l_uuid: STRING
			l_var_with_uuid: SEM_VARIABLE_WITH_UUID
			l_var_type: TYPE_A
		do
				-- Put all serializations into a hash table, with the test case UUID as the key.
			l_operand_position_name_mapping := operands_with_feature (current_invariant.feature_)
			l_operand_name_var_mapping := current_combination.variable_mapping
			from
				l_queryables := current_combination.queryables
				create l_uuid_object_types_mapping.make_equal (l_queryables.count)
				create provided_object_serializations.make_equal (l_queryables.count)
				l_queryables.start
			until
				l_queryables.after
			loop
				check attached {SEM_OBJECTS} l_queryables.item_for_iteration as lv_objects then
					l_uuid_object_types_mapping.force (lv_objects.variable_dynamic_type_table, lv_objects.uuid)
					l_serialization_string := string_from_array (lv_objects.serialization_as_array)
					provided_object_serializations.force (l_serialization_string, lv_objects.uuid)
				end
				l_queryables.forth
			end

				-- Collect all provided operands into `operand_for_invokation'.
			l_operand_count := l_operand_position_name_mapping.count
			create operand_for_invokation.make (l_operand_count)
			from l_operand_position := 0
			until l_operand_position >= l_operand_count
			loop
				l_operand_name := l_operand_position_name_mapping.item (l_operand_position)
				if l_operand_name_var_mapping.has (l_operand_name) then
						-- Only put information about available operands into the mapping.
					l_var_with_uuid := l_operand_name_var_mapping.item (l_operand_name)
					l_uuid := l_var_with_uuid.uuid
					l_var_name := l_var_with_uuid.variable
					l_interpreter_var := interpreter.variable_table.new_variable
					l_var_type := l_uuid_object_types_mapping.item (l_uuid).item (l_var_name)
					operand_for_invokation.put ([l_var_with_uuid, l_interpreter_var, l_var_type], l_operand_position)
				end

				l_operand_position := l_operand_position + 1
			end
		end

	batch_assign_provided_operands_to_variables
			-- Assign provided operand objects to interpreter variables.
		require
			provided_object_serializations_not_empty: provided_object_serializations /= Void
						and then not provided_object_serializations.is_empty
			operand_for_invokation_not_empty: operand_for_invokation /= Void
						and then not operand_for_invokation.is_empty
		local
			l_provided_object_serializations: DS_HASH_TABLE [STRING, STRING]
			l_batch_assignment_list: DS_ARRAYED_LIST [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A]]
		do
			l_provided_object_serializations := provided_object_serializations
			create l_batch_assignment_list.make (operand_for_invokation.count)
			from operand_for_invokation.start
			until operand_for_invokation.after
			loop
				check interpreter_var_assigned: operand_for_invokation.item_for_iteration.var /= Void end
				l_batch_assignment_list.force_last (operand_for_invokation.item_for_iteration)
				operand_for_invokation.forth
			end

			interpreter.batch_assign_variables (l_batch_assignment_list, l_provided_object_serializations)
		end

	prepare_missing_operand_objects
			-- Prepare missing operand objects for the invocation.
			-- Add such information into `operand_for_invokation'.
		require
			operand_for_invokation_not_empty: operand_for_invokation /= Void and then not operand_for_invokation.is_empty
			target_variable_type_available: operand_for_invokation.has (0) and then operand_for_invokation.item (0).type /= Void
			is_missing_operand: is_missing_operand
		local
			l_target_type: TYPE_A
			l_operand_types: DS_HASH_TABLE [TYPE_A, INTEGER]
			l_operand_index, l_operand_count: INTEGER
			l_operand_type: TYPE_A
			l_variable: ITP_VARIABLE
			l_input_creator: AUT_RANDOM_INPUT_CREATOR
			l_operands_to_create: DS_ARRAYED_LIST [INTEGER]
			l_receivers: DS_LIST [ITP_VARIABLE]
		do
			l_target_type := operand_for_invokation.item (0).type
			l_operand_count := feature_.argument_count + 1
			l_operand_types := resolved_operand_types_with_feature (feature_, class_, l_target_type)

				-- Prepare input creator.
			from
				create l_input_creator.make (system, interpreter, Void)
				create l_operands_to_create.make (l_operand_count)
				l_operand_index := 1
			until
				l_operand_index >= l_operand_count
			loop
				if not operand_for_invokation.has (l_operand_index) then
					l_operand_type := l_operand_types.item (l_operand_index)
					l_input_creator.add_type (l_operand_type)
					l_operands_to_create.force_last (l_operand_index)
				end
				l_operand_index := l_operand_index + 1
			end
			check missing_operands: l_input_creator.types.count > 0 end

				-- Create all missing operands.
			from l_input_creator.start
			until not interpreter.is_ready or else not l_input_creator.has_next_step or else l_input_creator.has_error
			loop
				l_input_creator.step
			end

				-- Get created objects for operands.
			if l_input_creator.receivers.count /= l_operands_to_create.count then
				has_error := True
			else
				l_receivers := l_input_creator.receivers
				from
					l_receivers.start
					l_operands_to_create.start
				until
					l_receivers.after
				loop
					l_operand_index := l_operands_to_create.item_for_iteration
					l_operand_type := l_operand_types.item (l_operand_index)
					operand_for_invokation.force ([Void, l_receivers.item_for_iteration, l_operand_type], l_operand_index)

					l_receivers.forth
					l_operands_to_create.forth
				end
			end
		ensure
			is_missing_operand_implies_has_error: is_missing_operand implies has_error
		end

	invoke_feature_with_operands
			-- Invoke `feature_' using the operands from `operand_for_invokation'.
		require
			interpreter_ready: interpreter.is_executing and then interpreter.is_ready
			not_has_error: not has_error
			operands_complete: not is_missing_operand
		local
			l_argument_variables: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_argument_index, l_argument_count: INTEGER
			l_target_type: TYPE_A
			l_target_var, l_result_var: ITP_VARIABLE
		do
				-- Argument variable list.
			l_argument_count := feature_.argument_count
			from
				l_argument_index := 1
				create l_argument_variables.make (l_argument_count)
			until
				l_argument_index > l_argument_count
			loop
				l_argument_variables.force_last (operand_for_invokation.item(l_argument_index).var)
				l_argument_index := l_argument_index + 1
			end

				-- Invoke feature using given objects as operands.
			l_target_type := operand_for_invokation.item (0).type
			l_target_var := operand_for_invokation.item (0).var
			if feature_.type.is_void then
				interpreter.invoke_feature (l_target_type, feature_, l_target_var, l_argument_variables, Void)
			else
				l_result_var := interpreter.variable_table.new_variable
				interpreter.invoke_and_assign_feature (l_result_var, l_target_type, feature_, l_target_var, l_argument_variables, Void)
			end
		end

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
