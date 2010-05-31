note
	description:

		"Instruction that requests the creation of an object"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_CREATE_OBJECT_REQUEST

inherit
	AUT_CALL_BASED_REQUEST
		rename
			make as make_request,
			feature_to_call as creation_procedure
		redefine
			creation_procedure,
			is_creation
		end

create
	make
--	make
--	make_default

feature {NONE} -- Initialization

	make (a_system: like system; a_receiver: like target; a_type: like target_type; a_procedure: like creation_procedure; an_argument_list: like argument_list)
			-- Create new request to create an object.
		require
			a_system_not_void: a_system /= Void
			a_receiver_not_void: a_receiver /= Void
			a_type_not_void: a_type /= Void
			a_procedure_not_void: a_procedure /= Void
			an_argument_list_not_void: an_argument_list /= Void
			a_type_not_expanded: not a_type.is_expanded
			a_type_has_class: a_type.has_associated_class
--			a_procedure_is_creation: a_type.base_class.is_creation_exported_to (a_procedure.name, a_system.any_class)
--			a_procedure_is_not_infix_or_prefix: not a_procedure.name.is_prefix and not a_procedure.name.is_infix
			no_argument_void: not an_argument_list.has (Void)
		do
			make_request (a_system)
			target := a_receiver
			target_type := a_type
			creation_procedure := a_procedure
			argument_list := an_argument_list
		ensure
			system_set: system = a_system
			receiver_set: target = a_receiver
			type_set: target_type = a_type
			procdure_set: creation_procedure = a_procedure
			argument_list_set:  argument_list = an_argument_list
		end

feature -- Status report

	is_setup_ready: BOOLEAN
			-- Is setup of current request ready?
		do
			Result := target_type.has_associated_class
		ensure then
			good_result: Result = target_type.has_associated_class
		end

	is_default_create_used: BOOLEAN
			-- Is the default creation procedure used to create the object?
		do
			Result := creation_procedure.feature_name.is_equal ("default_create")
		ensure
			definition: Result = creation_procedure.feature_name.is_equal ("default_create")
		end

feature -- Access

	creation_procedure: FEATURE_I
			-- Procedure used to create object;
			-- note that this must be a creation-procedure.
			-- If the default creation procedure should be used to create the object
			-- `creation_procecure' will be Void.

	operand_indexes: SPECIAL [INTEGER] is
			-- Indexes of operands (indexes are used in object pool) for the feature call
			-- in current
		do
			if argument_list /= Void then
				create Result.make_filled (0, argument_list.count + 1)
				Result.put (target.index, 0)
				argument_list.do_all_with_index (agent (a_var: ITP_VARIABLE; a_index: INTEGER; a_result: SPECIAL [INTEGER]) do a_result.put (a_var.index, a_index) end (?, ?, Result))
			else
				create Result.make_filled (0, 1)
				Result.put (target.index, 0)
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
			l_count := argument_list.count + 1

			create Result.make_filled (Void, l_count)
			Result.put (l_target_type, 0)

			if argument_count > 0 then
				l_args := creation_procedure.arguments
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
		end

	operand_type_table: HASH_TABLE [TYPE_A, INTEGER]
			-- A table for opernad indexes and their associated types
			-- Key is 0-based operand index, value is type of that operand.
		local
			l_opd_types: like operand_types
			i: INTEGER
			c: INTEGER
		do
			l_opd_types := operand_types
			c := l_opd_types.count
			create Result.make (c)
			from
				i := 0
			until
				i = c
			loop
				Result.put (l_opd_types.item (i), i)
				i := i + 1
			end
		end

feature -- Status report

	is_creation: BOOLEAN = True
			-- Is Current a creation procedure request?

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_create_object_request (Current)
		end

invariant

	receiver_not_void: target /= Void
	type_not_void: target_type /= Void
	type_not_expanded: not target_type.is_expanded
--	procedure_is_creation: not default_creation implies type.base_class.is_creation_exported_to (procedure.name, system.any_class)
--	procedure_is_not_infix_or_prefix: not default_creation implies (not procedure.name.is_prefix and not procedure.name.is_infix)
	no_argument_void: argument_list /= Void implies  not argument_list.has (Void)
--	is_default_creatable: default_creation implies is_default_creatable (type.base_class, system)

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
