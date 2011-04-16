note
	description: "[
		Task to invoke a feature with certain objects
		You can only specify some (if any) of the operands,
		the unspecified operands will be randomly generated.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_INVOKER_TASK

inherit
	AUT_TASK

	EPA_UTILITY
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_interpreter: like interpreter; a_error_handler: like error_handler; a_class: CLASS_C; a_feature: FEATURE_I; a_original_operand_map: like original_operand_map; a_should_invoke_feature: BOOLEAN)
			-- Initailize Current.
		do
			system := a_system
			interpreter := a_interpreter
			error_handler := a_error_handler
			class_ := a_class
			feature_ := a_feature
			create original_operand_map.make (5)
			create operand_map.make (5)
			across a_original_operand_map as l_maps loop
				original_operand_map.extend (l_maps.item, l_maps.key)
				operand_map.extend (l_maps.item, l_maps.key)
			end
			should_invoke_feature := a_should_invoke_feature
			operand_types := resolved_operand_types_with_feature (feature_, class_, class_.constraint_actual_type)
		end

feature -- Access

	class_: CLASS_C
			-- Class where `feature_' is from

	feature_: FEATURE_I
			-- Feature to be invoked

	original_operand_map: HASH_TABLE [ITP_VARIABLE, INTEGER]
			-- Operand maps given initially
			-- Keys are 0-based operand indexes (not including result)
			-- Values are objects in the object pool which will be used
			-- as those operands.

	operand_map: like original_operand_map
			-- Operands maps
			-- Keys are 0-based operand indexes (not including result)
			-- Values are objects in the object pool which will be used
			-- as those operands.	

	operand_types: like resolved_operand_types_with_feature
			-- Types of operands in `feature_'

feature -- Status report

	should_invoke_feature: BOOLEAN
			-- Should `feature_' be invoked?
			-- If True, the feature will be invoked after all operands are prepared.
			-- If False, only the operands are prepared, no feature invocation will happen.

	is_feature_invoked: BOOLEAN
			-- Is `feature_' invoked?

	has_next_step: BOOLEAN
			-- Does `Current' have a next step to execute?
		do
			Result := not should_quit
		end

feature -- Execution

	start
			-- Start execution of task.
		do
			set_should_quit (False)
		end

	step
			-- Perform a next step.
		do
			if is_operand_missing then
				prepare_missing_operands
			end
			if not should_quit and then should_invoke_feature and then not is_operand_missing then
				invoke_feature
				set_is_feature_invoked (interpreter.is_last_test_case_executed)
			end
			set_should_quit (True)
		end

	cancel
			-- Abort current execution.
		do
			set_should_quit (True)
		end

feature{NONE} -- Implementation

	should_quit: BOOLEAN
			-- Should current task terminate?

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter of Current testing session

	system: SYSTEM_I
			-- System

	error_handler: AUT_ERROR_HANDLER
			-- Error handler.

	set_should_quit (b: BOOLEAN)
			-- Set `should_quit' with `b'.
		do
			should_quit := b
		ensure
			should_quit_set: should_quit = b
		end

	set_is_feature_invoked (b: BOOLEAN)
			-- Set `is_feature_invoked' with `b'.
		do
			is_feature_invoked := b
		ensure
			is_feature_invoked_set: is_feature_invoked = b
		end

	is_operand_missing: BOOLEAN
			-- Is there any operand missing in `operand_map'?
		do
			Result := False
			across 0 |..| feature_.argument_count as l_indexes until Result loop
				Result := not operand_map.has (l_indexes.item)
			end
		end

	prepare_missing_operands
			-- Prepare missing operands, put them into
			-- `operand_map'.
		require
			is_missing_operand: is_operand_missing
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
			l_operand_count := feature_.argument_count + 1
			l_operand_types := operand_types
			l_target_type := l_operand_types.item (0)

				-- Prepare input creator.
			from
				create l_input_creator.make (system, interpreter, Void)
				create l_operands_to_create.make (l_operand_count)
				l_operand_index := 1
			until
				l_operand_index >= l_operand_count
			loop
				if not operand_map.has (l_operand_index) then
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
				set_should_quit (True)
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
					operand_map.force (l_receivers.item_for_iteration, l_operand_index)
					l_receivers.forth
					l_operands_to_create.forth
				end
			end
		ensure
			is_missing_operand_implies_has_error: is_operand_missing implies should_quit
		end

	invoke_feature
			-- Invoke `feature_' with operands specified
			-- in `operand_map' using `interpreter'.
		require
			interpreter_ready: interpreter.is_executing and then interpreter.is_ready
			operands_complete: not is_operand_missing
		local
			l_argument_variables: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_target_type: TYPE_A
			l_target_var, l_result_var: ITP_VARIABLE
		do
				-- Argument variable list.
			create l_argument_variables.make (feature_.argument_count)
			across 1 |..| feature_.argument_count as l_arg_indexes loop
				l_argument_variables.force_last (operand_map.item (l_arg_indexes.item))
			end

				-- Invoke feature using given objects as operands.
			l_target_type := operand_types.item (0)
			l_target_var := operand_map.item (0)
			if feature_.has_return_value then
				l_result_var := interpreter.variable_table.new_variable
				interpreter.invoke_and_assign_feature (l_result_var, l_target_type, feature_, l_target_var, l_argument_variables, Void)
			else
				interpreter.invoke_feature (l_target_type, feature_, l_target_var, l_argument_variables, Void)
			end
		end

	assign_void
			-- Assign void to the next free variable.
			-- Note: Copied from {AUT_RANDOM_STRATEGY}
			-- This causes code duplication, but avoid merge
			-- problem when synchronizing with trunk.
		local
			void_constant: ITP_CONSTANT
		do
			if interpreter.is_running and interpreter.is_ready then
				create void_constant.make (Void)
				interpreter.assign_expression (interpreter.variable_table.new_variable, void_constant)
			end
		end

note
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
