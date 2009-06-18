note
	description: "Factory to generate byte node structure"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_BYTE_NODE_FACTORY

inherit
	SHARED_TYPES

	SHARED_ARRAY_BYTE

	SHARED_BYTE_CONTEXT

	ERL_G_TYPE_ROUTINES

	AUT_SHARED_INTERPRETER_INFO

	COMPILER_EXPORTER

feature -- Byte node generation

	new_local_b (a_position: INTEGER): LOCAL_B
			-- New LOCAL_B instance for access to `a_position'-th local variable
		require
			a_position_positive: a_position > 0
		do
			create Result
			Result.set_position (a_position)
		ensure
			result_attached: Result /= Void
			location_correct: Result.position = a_position
		end

	new_nested_b (a_target: ACCESS_B; a_message: CALL_B): NESTED_B
			-- New NESTED_B instance for `a_target' and `a_message'
		require
			a_target_attached: a_target /= Void
			a_message_attached: a_message /= Void
		do
			create Result
			Result.set_target (a_target)
			Result.set_message (a_message)
			a_target.set_parent (Result)
			a_message.set_parent (Result)
		ensure
			result_attached: Result /= Void
		end

	new_reverse_b (a_target: ACCESS_B; a_source: EXPR_B): REVERSE_B
			-- REVERSE_B instance from `a_target' and `a_source'
		require
			a_target_attached: a_target /= Void
			a_source_attached: a_source /= Void
		do
			create Result
			Result.set_source (a_source)
			Result.set_target (a_target)
			Result.set_info (a_target.type.create_info)
		ensure
			result_attached: Result /= Void
			good_result: Result.source = a_source and then Result.target = a_target
		end

	new_assign_b (a_target: ACCESS_B; a_source: EXPR_B): ASSIGN_B
			-- ASSIGN_B instance from `a_target' and `a_source'
		require
			a_target_attached: a_target /= Void
			a_source_attached: a_source /= Void
		do
			create Result
			Result.set_source (a_source)
			Result.set_target (a_target)
		ensure
			result_attached: Result /= Void
			good_result: Result.source = a_source and then Result.target = a_target
		end

	new_feature_b (a_feature: FEATURE_I; a_return_type: TYPE_A; a_parameters: BYTE_LIST [PARAMETER_B]): CALL_ACCESS_B
			-- New FEATURE_B instance for `a_feature' with arguments `a_arguments'
			-- `a_return_type' is the return type of `a_feature'.
		require
			a_feature_attached: a_feature /= Void
			a_return_type_attached: a_return_type /= Void
		do
			Result ?= new_access_b (a_feature, a_return_type, a_parameters)
		ensure
			result_attached: Result /= Void
		end

	new_access_b (a_feature: FEATURE_I; a_return_type: TYPE_A; a_parameters: BYTE_LIST [PARAMETER_B]): ACCESS_B
			-- New FEATURE_B instance for `a_feature' with arguments `a_arguments'
			-- `a_return_type' is the return type of `a_feature'.
		require
			a_feature_attached: a_feature /= Void
			a_return_type_attached: a_return_type /= Void
		do
			Result ?= a_feature.access (a_return_type, True)
			if a_parameters /= Void then
				Result.set_parameters (a_parameters)
			end
		ensure
			result_attached: Result /= Void
		end

	new_integer_constant_from_constant (a_constant: ITP_CONSTANT; a_type: TYPE_A): INTEGER_CONSTANT
			-- New INTEGER_CONSTANT instance from `a_constant'
			-- `a_type' is the type of integer: INTEGER_8, INTEGER_16, INTEGER_32, INTEGER_64, NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64.
		require
			a_constant_attached: a_constant /= Void
			a_constant_valid: a_constant.value /= Void
		local
			l_str: STRING
			l_is_negative: BOOLEAN
		do
			l_str := a_constant.value.out
			l_is_negative := l_str.item (1) = '-'
			if l_is_negative then
				l_str.remove (1)
			end
			create Result.make_from_type (a_type, l_is_negative, l_str)
		ensure
			result_attached: Result /= Void
		end

	new_local_access_parameter_expressions (a_types: LIST [TYPE_A]; a_start_index: INTEGER): BYTE_LIST [PARAMETER_B]
			-- List of parameters made of local accesses.
		local
			l_local: LOCAL_B
			l_param: PARAMETER_B
			l_position: INTEGER
		do
			if a_types /= Void then
				create Result.make (a_types.count)
				from
					l_position := a_start_index
					a_types.start
				until
					a_types.after
				loop
					create l_param
					create l_local
					l_local.set_position (l_position)
					l_param.set_expression (l_local)
					l_param.set_attachment_type (a_types.item)
					Result.extend (l_param)
					l_position := l_position + 1
					a_types.forth
				end
			end
		end

	new_creation_byte_code (a_feat: FEATURE_I; a_target_type: TYPE_A; a_parameters: BYTE_LIST [PARAMETER_B]): CREATION_EXPR_B
			-- New instance of `create {a_target_type}.a_feat (a_expr1, a_expr2, ...)'
			-- `a_source_types' represents types of `a_exprs'.
		require
			a_feat_not_void: a_feat /= Void
			a_target_type_not_void: a_target_type /= Void
		local
			l_create_type: CREATE_TYPE
		do
			create Result
			create l_create_type.make (a_target_type.actual_type)

			Result.set_info (l_create_type)
			Result.set_type (a_target_type)

				-- Create call.
			Result.set_call (new_feature_b (a_feat, void_type, a_parameters))
			Result.set_creation_instruction (True)
		end

	new_instr_call_b (a_call: CALL_B): INSTR_CALL_B
			-- New instr_cal_b
		require
			a_call_attached: a_call /= Void
		do
			create Result.make (a_call, 1)
		end

	new_argumentless_agent (a_target_type: TYPE_A; a_feature: FEATURE_I; a_target_node: BYTE_NODE): ROUTINE_CREATION_B is
			-- New node for agent creation
			-- `a_target_type' is the type of the target object for the agent.
			-- `a_feature' is the feature wrapped by the agent.
		local
			l_result_type: GEN_TYPE_A
			l_feat_type: TYPE_A
			l_is_qualified_call: BOOLEAN
			l_type: TYPE_A
			l_generics: ARRAY [TYPE_A]
			l_current_class_void_safe: BOOLEAN
			l_arg_count: INTEGER
			l_open_count: INTEGER
			l_oidx: INTEGER
			l_cidx: INTEGER
			l_target_closed: BOOLEAN
			l_oargtypes, l_cargtypes: ARRAY [TYPE_A]
			l_closed_count: INTEGER
			l_tuple_type: TUPLE_TYPE_A
			l_expressions: BYTE_LIST [BYTE_NODE]
			l_expr: EXPR_B
			l_operand_node: OPERAND_B
			l_tuple_node: TUPLE_CONST_B
			l_array_of_opens: detachable ARRAY_CONST_B
			l_last_open_positions: detachable ARRAYED_LIST [INTEGER]
		do
			l_feat_type := a_feature.type.actual_type

			l_is_qualified_call := True
			l_type := l_feat_type.instantiation_in (a_target_type.as_implicitly_detachable, a_target_type.associated_class.class_id)
			l_type := l_type.deep_actual_type

			if l_type.actual_type.is_boolean then
				create l_generics.make (1, 2)
				create l_result_type.make (System.predicate_class_id, l_generics)
			else
				create l_generics.make (1, 3)
				l_generics.put (l_type, 3)
				create l_result_type.make (System.function_class_id, l_generics)
			end

			l_current_class_void_safe := False
			l_type := a_target_type

			if not l_type.is_attached then
					-- Type of the first actual generic parameter of the routine type
					-- should always be attached.
				if l_current_class_void_safe then
					l_type := l_type.as_attached_type
				elseif not l_type.is_implicitly_attached then
					l_type := l_type.as_implicitly_attached
				end
			end

			l_generics.put (l_type, 1)

			l_arg_count := 1

			l_open_count := 0
			l_oidx := 1
			l_target_closed := True

			create l_oargtypes.make (1, l_open_count)

			l_closed_count := l_arg_count - l_open_count
			create l_cargtypes.make (1, l_closed_count)

			l_cargtypes.put (a_target_type, 1)
			l_cidx := 2

			create l_tuple_type.make (System.tuple_id, l_oargtypes)
			l_current_class_void_safe := interpreter_root_class.lace_class.is_void_safe_call

			if not l_tuple_type.is_attached then
					-- Type of an argument tuple is always attached.
				if l_current_class_void_safe then
					l_tuple_type := l_tuple_type.as_attached_type
				elseif not l_tuple_type.is_implicitly_attached then
					l_tuple_type := l_tuple_type.as_implicitly_attached
				end
			end

				-- Insert it as second generic parameter of ROUTINE.
			l_generics.put (l_tuple_type, 2)

				-- Type of an agent is always attached.
			if l_current_class_void_safe then
				l_result_type := l_result_type.as_attached_type
			else
				l_result_type := l_result_type.as_implicitly_attached
			end

				-- Byte node creation
			create Result
			create l_expressions.make_filled (l_closed_count)
			l_expressions.start

			if a_target_node /= Void then
					-- A target was specified, we need to check if it is an open argument or not
					-- by simply checking that its byte node is not an instance of OPERAND_B.
				l_expr ?= a_target_node
				l_operand_node ?= l_expr
				if l_operand_node = Void then
					l_expressions.put (l_expr)
					l_expressions.forth
				end
			end

				-- Create TUPLE_CONST_B instance which holds all closed arguments.
			l_expressions.start
			create l_tuple_type.make (System.tuple_id, l_cargtypes)
			create l_tuple_node.make (l_expressions, l_tuple_type, l_tuple_type.create_info)

				-- We need to instantiate the closed TUPLE type of the agent otherwise it
				-- causes eweasel test#agent007 to fail.
			system.instantiator.dispatch (l_tuple_node.type, interpreter_root_class)

				-- Initialize ROUTINE_CREATION_B instance
				-- We need to use the conformence_type since it could be a like_current type which would
				-- be a problem with inherited assertions. See eweasel test execX10
			Result.init (a_target_type.conformance_type, a_target_type.associated_class.class_id,
				a_feature, l_result_type, l_tuple_node, l_array_of_opens, l_last_open_positions,
				a_feature.is_inline_agent, l_target_closed, a_target_type.associated_class.is_precompiled,
				a_target_type.associated_class.is_basic)
		ensure
			result_attached: Result /= Void
		end

	new_agent_as_parameter (a_target_type: TYPE_A; a_feature: FEATURE_I; a_target_node: BYTE_NODE): PARAMETER_B is
			-- New agent call as parameter
		local
			l_routine_creation: ROUTINE_CREATION_B
		do
			create Result
			l_routine_creation := new_argumentless_agent (a_target_type, a_feature, a_target_node)
			Result.set_expression (l_routine_creation)
			Result.set_attachment_type (l_routine_creation.type)
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
