note
	description: "Summary description for {AUT_BATCH_ASSIGNMENT_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_BATCH_ASSIGNMENT_REQUEST

inherit

	AUT_REQUEST
		rename
			make as make_request
		end

--	EQA_TEST_CASE_SERIALIZATION_UTILITY

create

	make

feature {NONE} -- Initialization

	make (a_system: like system; a_receivers: DS_ARRAYED_LIST [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A]]; a_serialization: DS_HASH_TABLE[STRING, STRING])
			-- Create new request.
		require
			a_system_not_void: a_system /= Void
			receivers_not_empty: a_receivers /= Void and then not a_receivers.is_empty
			serialized_objects_not_empty: a_serialization /= Void and then not a_serialization.is_empty
		local
			l_count, l_index: INTEGER
			l_var_with_uuid: SEM_VARIABLE_WITH_UUID
			l_objects_seri: STRING
			l_cursor: DS_ARRAYED_LIST_CURSOR [TUPLE [var_with_uuid: SEM_VARIABLE_WITH_UUID; var: ITP_VARIABLE; type: TYPE_A]]
		do
			make_request (a_system)

				-- List of itp_variables and the references to the serialized objects.
			create receivers.make_empty (a_receivers.count)
			create receiver_types.make (a_receivers.count)
			receiver_types.compare_objects
			from
				l_cursor := a_receivers.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_var_with_uuid := l_cursor.item.var_with_uuid
				receivers.extend ([l_var_with_uuid.variable + "@" + l_var_with_uuid.uuid, l_cursor.item.var])
				receiver_types.force (l_cursor.item.type, l_cursor.item.var)
				l_cursor.forth
			end

				-- List of serialized objects.
			create serialized_objects.make_empty (a_serialization.count * 2)
			from
				a_serialization.start
			until
				a_serialization.after
			loop
				serialized_objects.extend (a_serialization.key_for_iteration)
				serialized_objects.extend (a_serialization.item_for_iteration)
				a_serialization.forth
			end

--				-- Testing the integrity of the data
--			from
--				l_index := 0
--			until
--				l_index >= serialized_objects.count
--			loop
--				l_objects_seri := serialized_objects.at (l_index + 1)
--				if attached {HASH_TABLE [ANY, INTEGER_32]} deserialized_variable_table (ascii_string_as_array (l_objects_seri)) as lv_mapping then
--					l_index := l_index
--				else
--					l_index := l_index
--				end
--				l_index := l_index + 2
--			end

		ensure
			system_set: system = a_system
			receivers_count: a_receivers.count = receivers.count
			serialized_objects_set: serialized_objects.count = a_serialization.count * 2
		end

feature -- Access

	receivers: SPECIAL [TUPLE [STRING, ITP_VARIABLE]]
			-- Receivers for the objects.
			-- Each receiver, specified by ITP_VARIABLE, will get the object referenced by STRING.
			-- For example, [3@uuid1, v_5] will cause the execution of v_5 := serialized_objects[uuid][3]

	receiver_types: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Type of receiver variables
			-- Keys are variables, values are types of those variables.

	serialized_objects: SPECIAL[STRING]
			-- Serialization data for all the objects to be used in the assignment.
			-- All the objects come in several object groups:
			-- [uuid_0, object_group_0, uuid_1, object_group_1, ..., uuid_n, object_group_n]

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_batch_assignment_request (Current)
		end

invariant
	receivers_not_empty: receivers /= Void and then receivers.count > 0
	serialized_objects_not_empty: serialized_objects /= Void and then serialized_objects.count > 0

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
