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

			Result := l_list
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
