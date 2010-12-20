note
	description: "Objects that create agents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RANDOM_AGENT_CREATOR

inherit
	AUT_TASK

	AUT_SHARED_RANDOM
		export {NONE} all end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	AUT_CREATE_AGENT_UTILITIES
		export {NONE} all end

	AUT_AGENT_FEATURE_CACHE
		rename make as make_cache end

	KL_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

	REFACTORING_HELPER

	AUT_SHARED_PREDICATE_CONTEXT
		undefine
			system
		end

	EPA_TYPE_UTILITY
		undefine
			system
		end

create
	make

feature {NONE} -- Initialization

make (a_system: like system; an_interpreter: like interpreter; a_type: like receiver_type; a_feature_table: like feature_table; a_feature_target: like feature_target)
			-- Create new agent creator.
		require
			a_system_not_void: a_system /= Void
			a_interpreter_not_void: an_interpreter /= Void
			a_type_not_void: a_type /= Void
			a_type_associated_with_class: a_type.has_associated_class
			a_type_is_agent_type: is_agent_type (a_type)
			a_feature_table_attached: a_feature_table /= Void
			a_feature_target_attached: a_feature_target /= Void
		do
			system := a_system
			interpreter := an_interpreter
			receiver_type := a_type
			feature_table := a_feature_table
			feature_target := a_feature_target
			steps_completed := True

			target_type := receiver_type.generics[1]
			argument_types := receiver_type.generics[2].generics

			if is_procedure (receiver_type) or is_routine (receiver_type) then
				return_type := void_type
			elseif is_function (receiver_type) then
				return_type := receiver_type.generics[3]
			elseif is_predicate (receiver_type) then
				return_type := boolean_type
			end
		ensure
			system_set: system = a_system
			interpreter_set: interpreter = an_interpreter
			type_set: receiver_type = a_type
			feature_table_set: feature_table = a_feature_table
			feature_target_set: feature_target = a_feature_target
			steps_completed: steps_completed
			return_type_set: return_type /= Void
		end


feature -- Status

	has_next_step: BOOLEAN
			-- Is there a next step to be executed?
		do
			Result := interpreter.is_running and interpreter.is_ready and not steps_completed
		ensure then
			definition: Result = interpreter.is_running and interpreter.is_ready and not steps_completed
		end


feature -- Access

	agent_feature: AUT_FEATURE_OF_TYPE
			-- Feature to be used for agent instantiation

	receiver: ITP_VARIABLE
			-- Variable that will hold this new agent instance

	operands: DS_HASH_TABLE [ITP_VARIABLE,INTEGER]
			-- (Closed) Operands of the agent

	input_creator: AUT_RANDOM_INPUT_CREATOR
			-- Input creator used to get operand values

	system: SYSTEM_I
			-- System under which the agent is going to be created

	interpreter: AUT_INTERPRETER_PROXY
			-- Proxy to the interpreter process

	feature_target: ITP_VARIABLE
			-- Target of the feature that will need this agent as an argument

feature -- Agent characterisation

	receiver_type: TYPE_A
			-- Type that the future agent must comply to
			-- Note that this type includes target, target, argument and return types

	target_type: TYPE_A
			-- Target type that the future agent must comply to

	argument_types: ARRAY [TYPE_A]
			-- Argument types that the future agent must comply to

	return_type: TYPE_A
			-- Return type that the future agent must comply to


feature -- Execution

	start
		do
			steps_completed := False
			agent_feature := Void
			input_creator := Void
			operands := Void
		ensure then
			steps_uncompleted: steps_completed = False
			agent_feature_reset: agent_feature = Void
			input_creator_reset: input_creator = Void
			operands_reset: operands = Void
		end

	step
		do
			if agent_feature = Void then
				choose_random_agent_feature
			elseif input_creator = Void then
				create_input_creator
			elseif input_creator.has_next_step then
				input_creator.step
			elseif input_creator.has_error then
				cancel
			elseif operands = Void then
				fill_operands
			else
				receiver := interpreter.variable_table.new_variable
				interpreter.create_agent (receiver,receiver_type,agent_feature,operands)
				steps_completed := True
			end
		end

	cancel
		do
			steps_completed := True;
		end

feature {NONE} -- Steps

	choose_random_agent_feature
			-- Select a feature to be wrapped arround by the agent to be created
		require
			not_yet_chosen: agent_feature = Void
		local
			l_features: like interpreter.features_under_test
			l_feature: AUT_FEATURE_OF_TYPE
			l_table: ARRAYED_LIST [AUT_FEATURE_OF_TYPE]
			l_cache: AUT_AGENT_FEATURE_CACHE
			i: INTEGER
		do
			l_cache := agent_feature_cache
			l_cache.find (receiver_type)

			if l_cache.found then
				l_table := l_cache.found_item
			else
				l_features := interpreter.features_under_test
				create l_table.make (0)
				l_features.do_if (agent l_table.put_front (?), agent is_conform (?))
				l_cache.put (l_table, receiver_type)
			end

			if l_table.count > 0 then
				random.forth
				i := (random.item \\ l_table.count) + 1

				agent_feature := l_table[i]
			else
				cancel
			end

		ensure
			found_or_exit: has_next_step implies agent_feature /= Void
		end

	create_input_creator
			-- Set up an input creator to get variables for closed operands
		require
			not_yet_created: input_creator = Void
			feature_chosen: agent_feature /= Void
			closed_operands_void: closed_operands_positions = Void
		local
			l_feature_arguments: LIST [TYPE_A]
			i: INTEGER
		do
			create input_creator.make (system, interpreter, feature_table)

			l_feature_arguments := feature_argument_types (agent_feature.feature_, agent_feature.type)
			create closed_operands_positions.make

			if argument_types.count > 0 and then check_conform (argument_types[1], agent_feature.type) then
				is_target_open := True
			else
				is_target_open := False
				input_creator.add_type (agent_feature.type)
				closed_operands_positions.put_front (0)
			end

			from
				i := 1
				l_feature_arguments.start
				closed_operands_positions.start
			until
				l_feature_arguments.after
			loop
				if i <= argument_types.count and then check_conform (argument_types[i], l_feature_arguments.item_for_iteration) then
					i := i+1
				else
					input_creator.add_type (l_feature_arguments.item_for_iteration)
					closed_operands_positions.put_right (l_feature_arguments.index)
					closed_operands_positions.forth
				end

				l_feature_arguments.forth
			end

			input_creator.start
		ensure
			created: input_creator /= Void
			operand_info_populated: closed_operands_positions /= Void
		end

	fill_operands
			-- Fill operands table to be passed on to interpreter
		require
			not_yet_filled: operands = Void
		do
			-- Void target?
			if is_target_open = False and then typed_object_pool.variable_type (input_creator.receivers.first) = none_type then
				cancel
			end

			-- Targets equal?
			if is_target_open = False and then feature_target.is_equal (input_creator.receivers.first) then
				cancel
			end

			create operands.make (closed_operands_positions.count)

			from
				input_creator.receivers.start
				closed_operands_positions.start
			until
				closed_operands_positions.after
			loop
				operands.put (input_creator.receivers.item_for_iteration, closed_operands_positions.item_for_iteration)
				closed_operands_positions.forth
				input_creator.receivers.forth
			end
		ensure
			operands_created: operands /= Void
			operands_filled: operands.count = closed_operands_positions.count
		end

feature {NONE} -- Implementation

	closed_operands_positions: LINKED_LIST [INTEGER]
			-- Lists the positions of operands that will be closed
			-- Indexed by 0 for target, 1 for first argument etc

	feature_table: HASH_TABLE [ARRAY [FEATURE_I],CLASS_C]
			-- Feature table

	steps_completed: BOOLEAN
			-- Can the current execution be continued?

	is_target_open: BOOLEAN
			-- Will the future agent have an open target?
			-- Note that this is only known after create_input_creator
			-- and should therefore not be called before

	is_conform (a_feature: AUT_FEATURE_OF_TYPE) : BOOLEAN
			-- True iff `a_feature' is conforming the requested type, i.e.
			-- Return and target type are conforming
			-- Argument count is greater or equal and positions that are not going to be closed match arguments of `argument_types'
		require
			a_feature_attached: a_feature /= Void
		local
			l_return_type_agent: TYPE_A
			l_target_type_agent: TYPE_A

			l_return_type_feature: TYPE_A
			l_target_type_feature: TYPE_A
		do
			l_return_type_agent := return_type
			l_target_type_agent := target_type

			l_return_type_feature := explicit_type_in_context (a_feature.feature_.type, a_feature.type)
			l_target_type_feature := a_feature.type

			Result := check_conform (l_return_type_feature,l_return_type_agent)
				      and then check_conform (l_target_type_feature, l_target_type_agent)
				      and then not has_anchored_arguments (a_feature.feature_)
				      and then argument_types_conform (a_feature)
		end

	check_conform (a_type_1:TYPE_A;a_type_2:TYPE_A): BOOLEAN
			-- Is a_type_1 conform to a_type_2?
		require
			a_type_1_attached: a_type_1 /= Void
			a_type_2_attached: a_type_2 /= Void
		do
			if a_type_1 = void_type then
				Result := a_type_2 = void_type
			else
				Result := a_type_2.associated_class = system.any_class.compiled_class or else a_type_1.conform_to (interpreter.interpreter_root_class, a_type_2)
			end
		end

	argument_types_conform (a_feature: AUT_FEATURE_OF_TYPE): BOOLEAN
			-- Can a feature with `a_argument_types_feature' argument types be used to
			-- be wrapped around by an agent with `a_argument_types_agent' argument types
			-- by closing (possibly none) operands?
		require
			a_feauture_attached: a_feature /= Void
		local
			i: INTEGER
			l_argument_types_agent: like argument_types
			l_argument_types_feature: LIST [TYPE_A]
			l_argument_type_agent: TYPE_A
			l_argument_type_feature: TYPE_A
		do

			l_argument_types_agent := argument_types
			l_argument_types_feature := feature_argument_types (a_feature.feature_, a_feature.type)

			i := 1
			-- Can we leave target open?
			if l_argument_types_agent.count > 0 and then check_conform(l_argument_types_agent[1], a_feature.type) and then check_conform(a_feature.type, l_argument_types_agent[1]) then
				i := 2
			end

			from
				l_argument_types_feature.start
			until
				i > l_argument_types_agent.count or l_argument_types_feature.after
			loop
				l_argument_type_agent := l_argument_types_agent[i]
				l_argument_type_feature := l_argument_types_feature.item_for_iteration

				-- First check is to prevent recursion
				if not is_agent_type (l_argument_type_feature) and then check_conform (l_argument_type_agent, l_argument_type_feature) and then check_conform (l_argument_type_feature, l_argument_type_agent) then
					i := i+1
				end

				l_argument_types_feature.forth
			end

			Result := i > l_argument_types_agent.count
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
