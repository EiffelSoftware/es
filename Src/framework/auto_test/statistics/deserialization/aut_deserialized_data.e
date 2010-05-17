note
	description: "Summary description for {AUT_SERIALIZED_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DESERIALIZED_DATA

inherit

	AUT_TEST_CASE_SUMMARIZATION
		rename
			make as make_summarization
		redefine
			key_to_hash,
			reset_cache
		end

create
	make

feature -- Initialization

	make (a_class_name, a_time, a_code, a_operands, a_variables, a_trace, a_hash_code, a_pre_state, a_post_state: STRING;
				a_pre_serialization: ARRAYED_LIST[NATURAL_8])
			-- Initialization.
		do
			make_summarization (a_class_name, a_code, a_operands, a_trace,
					a_pre_state, a_post_state)
			time_str := a_time.twin
			variables_str := a_variables
			hash_code_str := a_hash_code.twin
			pre_serialization := a_pre_serialization
--			post_serialization := a_post_serialization
		end

feature -- Access string representation

	time_str: STRING
	variables_str: STRING
	hash_code_str: STRING
	pre_serialization: ARRAYED_LIST[NATURAL_8]
--	post_serialization: ARRAYED_LIST[NATURAL_8]

feature -- Access

	trans_hashcode: STRING
			-- Hashcode string from
		require
			hashcode_str_not_empty: hash_code_str /= Void and then not hash_code_str.is_empty
		local
			l_string: STRING
			l_start: INTEGER
		do
			if trans_hashcode_cache = Void then
				l_string := hash_code_str
				-- Bypassing class name.
				l_start := l_string.index_of ('.', 1)
				-- Bypassing feature name.
				l_start := l_string.index_of ('.', l_start + 1)

				trans_hashcode_cache := l_string.substring (l_start + 1, l_string.count)
			end
			Result := trans_hashcode_cache
		end

	variable_type_table: detachable HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- All reachable variables from the operands and their types.
		do
			if variable_type_table_cache = Void then
				variable_type_table_cache := variable_type_table_from_declaration (variables_str)
			end
			Result := variable_type_table_cache
		end

feature{NONE} -- Implementation

	trans_hashcode_cache: detachable STRING
			-- Cache for `trans_hashcode'.

	variable_type_table_cache: detachable like variable_type_table
			-- Cache for `variable_type_table'.	

	reset_cache
			-- <Precursor>
		do
			Precursor
			trans_hashcode_cache := Void
			variable_type_table_cache := Void
		end

feature{NONE} -- Variable renaming

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (5)
			l_list.append (Precursor, 1)
			l_list.force_last (trans_hashcode.hash_code)
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
