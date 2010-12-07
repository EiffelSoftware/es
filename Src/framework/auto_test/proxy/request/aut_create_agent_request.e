note
	description:

		"Instruction that requests the creation of an agent"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"


class AUT_CREATE_AGENT_REQUEST

inherit
	AUT_CALL_BASED_REQUEST
		rename
			make as make_request,
			feature_to_call as agent_feature
		redefine
			agent_feature
		end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER

	EPA_COMPILATION_UTILITY

create
	make

feature {NONE} -- Initialization

	make (a_system: like system
		  a_receiver: ITP_VARIABLE; a_receiver_type: TYPE_A;
		  a_feature: AUT_FEATURE_OF_TYPE;
		  a_operands: like operand_table)
			-- Create new request to create an agent
		require
			system_exists: a_system /= Void
			receiver_exists: a_receiver /= Void
			receiver_type_exists: a_receiver_type /= Void
			feature_exists: a_feature /= Void
			operands_exist: a_operands /= Void
		local
			i:INTEGER
			l_arg_list: DS_LINKED_LIST[ITP_VARIABLE]
		do
			system := a_system
			receiver := a_receiver
			receiver_type := a_receiver_type
			agent_feature_of_type := a_feature
			target_type := agent_feature_of_type.type
			operand_table := a_operands

			if operand_table.item (0) /= Void then
				target := operand_table.item (0)
			else
				is_target_open := True
			end

			create l_arg_list.make_from_linear (operand_table)
			argument_list := l_arg_list

		ensure
			system_set: system = a_system
			receiver_set: receiver = a_receiver
			receiver_type_set: receiver_type = a_receiver_type
			agent_feature_of_type_set: agent_feature_of_type = a_feature
			target_type_set: target_type = a_feature.type
			operand_table_set: operand_table = a_operands
			target_open_set: is_target_open = operand_table.item (0) = Void
			target_set: (not is_target_open) implies target /= Void
			argument_list_created: argument_list /= Void
		end

feature {AUT_CREATE_AGENT_REQUEST} -- Implementation

	is_target_open: BOOLEAN
			-- Is the target of the agent going to be left open?

	operand_indexes_internal: SPECIAL[INTEGER]
			-- special holding the values for `operand_indexes'

	operand_types_internal: SPECIAL[TYPE_A]
			-- special holding the values for `operand_types'

	fill_operand_indexes
			-- Fill `operand_indexes_internal'
		local
			i: INTEGER
		do
			create operand_indexes_internal.make_empty (operand_table.count)

			from
				operand_table.start
				i := 0
			until
				operand_table.after
			loop
				operand_indexes_internal.force (operand_table.item_for_iteration.index, i)
				operand_table.forth
				i := i+1
			end
		ensure
			set: operand_indexes_internal /= Void
		end

	fill_operand_types
			-- Fill `operand_types_internal'
		local
			i:INTEGER
			l_feat_arg_types: LIST[TYPE_A]
		do
			create operand_types_internal.make_empty (operand_table.count)
			l_feat_arg_types := feature_argument_types (agent_feature, agent_feature_of_type.type)

			i := 0
			operand_table.start
			if not is_target_open then
				operand_types_internal.force (agent_feature_of_type.type, 0)
				i := 1
				operand_table.forth
			end

			from
			until
				operand_table.after
			loop
				operand_types_internal.force (l_feat_arg_types.i_th (operand_table.key_for_iteration), i)
				operand_table.forth
				i := i+1
			end
		ensure
			set: operand_types_internal /= Void
		end


feature -- Status report

	is_setup_ready: BOOLEAN = True
			-- Is setup of current request ready?

feature -- Access

	agent_feature_of_type: AUT_FEATURE_OF_TYPE
			-- wrapper for `agent_feature' with type

	agent_feature: FEATURE_I
			-- feature to be wrapped around by agent
		do
			Result := agent_feature_of_type.feature_
		ensure then
			result_set: Result = agent_feature_of_type.feature_
		end

	receiver: ITP_VARIABLE
			-- Variable that stores future agent

	receiver_type: TYPE_A
			-- (static) type of `receiver'

	operand_table: DS_BILINEAR_TABLE[ITP_VARIABLE,INTEGER]
			-- Table of operands for closed arguments of the agent
			-- 0-indexed by their position in the agent expression: 0 is the target, 1 is the first argument etc

	operand_indexes: SPECIAL [INTEGER]
			-- Indexes of operands (indexes are used in object pool) for the agent creation
			-- Indexing done conforming to `operand_table'
		do
			if operand_indexes_internal = Void then
				fill_operand_indexes
			end

			Result := operand_indexes_internal
		ensure then
			result_set: Result = operand_indexes_internal
		end

	operand_types: SPECIAL [TYPE_A]
			-- Static types of operands
			-- Indexing done conforming to `operand_table'
		do
			if operand_types_internal = Void then
				fill_operand_types
			end

			Result := operand_types_internal
		ensure then
			result_set: Result = operand_types_internal
		end


	byte_code: STRING_8
			-- generate byte code that will execute the creation of this agent
		local
			l_code: STRING
		do
			create l_code.make (100)
			l_code.append (once "execute_byte_code%N")
			l_code.append (once "%Tlocal%N")
			l_code.append (locals_declaration_code (two_tabs))
			l_code.append (once "%Tdo%N")
			l_code.append (operand_loading_code(two_tabs))
			l_code.append (once "%T%Tif not l_inv then%N")
			l_code.append (agent_assignment_code (three_tabs))
			l_code.append (store_agent_code (three_tabs))
			l_code.append (store_agent_creation_info_code (three_tabs))
			l_code.append (once "%T%Tend%N")
			l_code.append (once "%Tend%N")

			--io.put_string (l_code)
			Result := feature_byte_code_with_text (interpreter_root_class, feature_for_byte_code_injection, once "feature " + l_code, True).byte_code
		ensure
			compilation_succeeded: Result.count > 1
		end

feature -- Code generation

	locals_declaration_code (a_indent: STRING) : STRING
			-- Text representing the declarations of the locals that will be used as operands (w/o target)
		local
			l_op_ids: like operand_indexes
			l_op_types: like operand_type_names
			i: INTEGER
		do
			l_op_ids := operand_indexes
			l_op_types := operand_type_names

			create Result.make (50)

			-- boolean to check whether all invariants hold
			Result.append (a_indent)
			Result.append (once "l_inv: BOOLEAN%N")

			-- Locals to store information about agent creation
			Result.append (a_indent)
			Result.append (once "l_operands_special: SPECIAL[INTEGER]%N")
			Result.append (a_indent)
			Result.append (once "l_agent_creation_info: ITP_AGENT_CREATION_INFO%N")

			-- Receiver (agent)
			Result.append (a_indent)
			Result.append (variable_name (receiver.index))
			Result.append (": ")
			Result.append (receiver_type.name)
			Result.append_character ('%N')

			from i := 0
			until i >= l_op_ids.count
			loop
				Result.append (a_indent)
				Result.append (variable_name (l_op_ids.item (i)))
				Result.append (once ": ")
				Result.append (l_op_types.item (i))
				Result.append_character ('%N')
				i := i+1
			end
		end

	operand_loading_code (a_indent: STRING) : STRING
			-- Text representing the process of loading and invariant checking for operands
		local
			l_op_ids: like operand_indexes
			i: INTEGER
		do
			l_op_ids := operand_indexes

			create Result.make (50)
			Result.append (a_indent)
			Result.append ("l_inv := False%N%N")

			from i := 0
			until i >= l_op_ids.count
			loop
				Result.append (a_indent)
				Result.append (variable_name(l_op_ids.item (i)))
				Result.append (" ?= variable_at_index(")
				Result.append_integer (l_op_ids.item (i))
				Result.append (")%N")
				Result.append (a_indent)
				Result.append ("check_invariant(")
				Result.append_integer(l_op_ids.item (i))
				Result.append_character (',')
				Result.append_character (' ')
				Result.append (variable_name(l_op_ids.item (i)))
				Result.append (")%N")
				Result.append (a_indent)
				Result.append ("l_inv := l_inv or is_last_invariant_violated%N%N")
				i := i+1
			end
		end

	agent_assignment_code (a_indent: STRING) : STRING
			-- Text representing the code line where the agent (with operand names) is assigned to the receiver
		local
			l_op_arg: SPECIAL[STRING]
			i: INTEGER
		do
			create l_op_arg.make_filled ("?", agent_feature.argument_count+1)

			from operand_table.start
			until operand_table.after
			loop
				l_op_arg.put (operand_table.item_for_iteration.name (once "v_"), operand_table.key_for_iteration)
				operand_table.forth
			end

			create Result.make (50)
			Result.append (a_indent)
			Result.append (variable_name(receiver.index))
			Result.append (" := agent ")

			if is_target_open then
				Result.append_character ('{')
				Result.append(target_type.name)
				Result.append_character ('}')
			else
				Result.append (variable_name(target.index))
			end

			Result.append_character ('.')
			Result.append (agent_feature.feature_name)

			if agent_feature.argument_count > 0 then
				Result.append ("(")
				Result.append (l_op_arg.item (1))

				from
					i := 2
				until
					i >= l_op_arg.count
				loop
					Result.append_character (',')
					Result.append (l_op_arg.item (i))
					i := i+1
				end

				Result.append_character (')')
				Result.append_character ('%N')
			end
		end

	store_agent_code (a_indent: STRING): STRING
			-- Text representing the command to store the freshly created agent `receiver'
		do
			create Result.make (50)
			Result.append(a_indent)
			Result.append (once "store_variable_at_index(")
			Result.append (variable_name(receiver.index))
			Result.append_character (',')
			Result.append (receiver.index.out)
			Result.append (")%N")
		end

	store_agent_creation_info_code (a_indent: STRING): STRING
			-- Text representing the code to put info about the creation of `receiver' into the interpreter
			-- See `ITP_AGENT_CREATION_INFO'
		local
			i: INTEGER
		do
			create Result.make (50)
			Result.append (a_indent)
			Result.append (once "create l_operands_special.make_empty (")
			Result.append_integer (operand_table.count*2)
			Result.append_character (')')
			Result.append_character ('%N')

			from
				operand_table.start
				i := 0
			until
				operand_table.after
			loop
				Result.append (a_indent)
				Result.append (once "l_operands_special.force (")
				Result.append_integer (operand_table.key_for_iteration)
				Result.append (once ", ")
				Result.append_integer (i)
				Result.append_character (')')
				Result.append_character ('%N')

				Result.append (a_indent)
				Result.append (once "l_operands_special.force (")
				Result.append_integer (operand_table.item_for_iteration.index)
				Result.append (once ", ")
				Result.append_integer (i+1)
				Result.append_character (')')
				Result.append_character ('%N')
				i := i + 2
				operand_table.forth
			end

			Result.append (a_indent)
			Result.append (once "create l_agent_creation_info.make (")
			Result.append_integer (receiver.index)
			Result.append (once ", ")
			Result.append_character ('"')
			Result.append (agent_feature.feature_name)
			Result.append_character ('"')
			Result.append (once ", ")
			Result.append (once "l_operands_special)%N")

			Result.append (a_indent)
			Result.append (once "agent_creation_info.put (l_agent_creation_info, ")
			Result.append_integer (receiver.index)
			Result.append_character (')')
			Result.append_character ('%N')
		end

	one_tab: STRING = "%T"
	two_tabs: STRING = "%T%T"
	three_tabs: STRING = "%T%T%T"

	variable_name (a_index: INTEGER): STRING
			-- Name of variable with `a_index'.
			-- fixme: copied from `AUT_OBJECT_STATE_RETRIEVAL_FEATURE_GENERATOR'
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_index.out)
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_create_agent_request (Current)
		end

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
