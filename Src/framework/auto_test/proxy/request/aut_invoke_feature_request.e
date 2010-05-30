note
	description:

		"Instruction that requests the execution of a feature and optionally the assignment of its result (if applicable)"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_INVOKE_FEATURE_REQUEST

inherit

	AUT_CALL_BASED_REQUEST
		rename
			make as make_request
		end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

create

	make,
	make_assign

feature {NONE} -- Initialization

	make (a_system: like system; a_feature_name: like feature_name; a_target: like target; an_argument_list: like argument_list)
			-- Create new request to invoke a feature.
			-- If `a_feature' is a query its result will be ignored.
		require
			a_system_not_void: a_system /= Void
			a_feature_name_not_void: a_feature_name /= Void
			a_target_not_void: a_target /= Void
			an_argument_list_not_void: an_argument_list /= Void
			no_argument_void: not an_argument_list.has (Void)
		do
			make_request (a_system)
			feature_name := a_feature_name
			target := a_target
			argument_list := an_argument_list
		ensure
			system_set: system = a_system
			feature_name_set: feature_name = a_feature_name
			target_set: target = a_target
			argument_list_set:  argument_list = an_argument_list
		end

	make_assign (a_system: like system; a_receiver: like receiver; a_feature_name: like feature_name; a_target: like target; an_argument_list: like argument_list)
			-- Create new request to invoke a query and to store its result in a
			-- variable.
		require
			a_system_not_void: a_system /= Void
			a_receiver_not_void: a_receiver /= Void
			a_feature_name_not_void: a_feature_name /= Void
			a_target_not_void: a_target /= Void
			an_argument_list_not_void: an_argument_list /= Void
			no_argument_void: not an_argument_list.has (Void)
		do
			make (a_system, a_feature_name, a_target, an_argument_list)
			receiver := a_receiver
		ensure
			receiver_set: receiver = a_receiver
		end

feature -- Status report

	is_setup_ready: BOOLEAN
			-- Is setup of current request ready?
		do
			Result := target_type /= Void and then target_type.has_associated_class
		ensure then
			good_result: Result = (target_type /= Void) and then target_type.has_associated_class
		end

feature -- Access

	receiver: ITP_VARIABLE
			-- Variable where the result of `feature_to_call' is stored
			-- if `feature_to_call' is a query.

	feature_name: STRING
			-- Name of feature to invoke

	feature_to_call: FEATURE_I
			-- Feature to invoke
		do
			Result := class_of_target_type.feature_named (feature_name)
		ensure then
			definition: Result = class_of_target_type.feature_named (feature_name)
		end

	operand_indexes: SPECIAL [INTEGER] is
			-- Indexes of operands for the feature call
			-- in current
		local
			l_count: INTEGER
		do
			l_count := 1
			if is_feature_query then
				l_count := l_count + 1
			end
			if argument_list /= Void then
				l_count := l_count + argument_list.count
			end

			create Result.make_empty (l_count)
			Result.put (target.index, 0)

			if argument_list /= Void then
				argument_list.do_all_with_index (agent (a_var: ITP_VARIABLE; a_index: INTEGER; a_result: SPECIAL [INTEGER]) do a_result.put (a_var.index, a_index) end (?, ?, Result))
			end

			if is_feature_query then
				Result.put (receiver.index, l_count - 1)
			end
		end

	operand_types: SPECIAL [TYPE_A]
			-- Types of operands
			-- Index 0 is for the target object, index 1 is for the first argument, and so on.
			-- The result object (if any) is placed in (Result.count - 1)-th position.
		local
			l_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			l_target_type: TYPE_A
			i: INTEGER
			l_type: TYPE_A
		do
			l_target_type := target_type
			l_count := 1
			if is_feature_query then
				l_count := l_count + 1
			end
			if argument_list /= Void then
				l_count := l_count + argument_list.count
			end

			create Result.make_empty (l_count)
			Result.put (l_target_type, 0)

			if argument_count > 0 then
				l_args := feature_to_call.arguments
				l_cursor := l_args.cursor
				from
					i := 1
					l_args.start
				until
					l_args.after
				loop
					l_type := l_args.item_for_iteration.actual_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
					l_type := actual_type_from_formal_type (l_type, interpreter_root_class)
					Result.put (l_type, i)
					l_args.forth
					i := i + 1
				end
				l_args.go_to (l_cursor)
			end

			if is_feature_query then
				l_type := feature_to_call.type.actual_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
				l_type := actual_type_from_formal_type (l_type, interpreter_root_class)
				Result.put (l_type, l_count - 1)
			end
		end

feature -- Settings

	set_target_type (a_type: like target_type)
			-- Set `target_type' to `a_type'.
		require
			a_type_not_void: a_type /= Void
			a_type_associated_with_class: a_type.has_associated_class
			a_type.associated_class.feature_named (feature_name) /= Void
		do
			target_type := a_type
		ensure
			type_set: target_type = a_type
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_invoke_feature_request (Current)
		end

invariant

	feature_name_not_void: feature_name /= Void
	target_not_void: target /= Void
	argument_list_not_void: argument_list /= Void
	class_has_a_feature: target_type /= Void implies target_type.associated_class.feature_named (feature_name) /= Void
	no_argument_void: not argument_list.has (Void)

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
