note
	description: "Summary description for {AUT_TEST_CASE_SERIALIZATION_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_SERIALIZATION_WRITER

inherit
	AUT_SHARED_PREDICATE_CONTEXT

	AUT_SHARED_TYPE_FORMATTER

	AUT_OBJECT_STATE_REQUEST_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration; a_stream: like stream; a_class_info: like class_info) is
			-- Initialize `stream' with `a_stream'.
		require
			a_config_attached: a_config /= Void
			a_stream_attached: a_stream /= Void
			a_class_info_attached: a_class_info /= Void
		do
			configuration := a_config
			stream := a_stream
			class_info := a_class_info
		ensure
			configuration_set: configuration = a_config
			stream_set: stream = a_stream
			class_info_set: class_info = a_class_info
		end

feature -- Access

	stream: TEST_INDENTING_SOURCE_WRITER
			-- Stream used to store generated source code

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration of current AutoTest session

	class_info: LINKED_LIST [TUPLE [class_name: STRING; type: TYPE_A; type_name: STRING]]
			-- Information of classes	

feature -- Generation

	generate is
			-- Generate routines needed by test case serialization.
		do
			generate_supported_query_names_routine
			generate_initialize_supported_query_name_table_routine
		end

	generate_initialize_supported_query_name_table_routine is
			-- Generate the routine `initialize_supported_query_name_table'.
		local
			l_cursor: CURSOR
			l_queries: LIST [FEATURE_I]
		do
			stream.indent
			stream.put_line ("initialize_supported_query_name_table is")
			stream.indent
			stream.put_line ("local")
			stream.indent
			stream.put_line ("l: LINKED_LIST [STRING]")
			stream.dedent
			stream.put_line ("do")
			stream.indent
			stream.put_string ("create supported_query_name_table.make (")
			stream.put_string ((class_info.count + 1).out)
			stream.put_line (")")
			stream.put_line ("supported_query_name_table.put (create {LINKED_LIST [STRING]}.make, 0)")

			if configuration.is_test_case_serialization_enabled then
				l_cursor := class_info.cursor
				from
					class_info.start
				until
					class_info.after
				loop
					stream.put_line ("create l.make")
					l_queries := supported_queries_of_type (class_info.item.type)
					from
						l_queries.start
					until
						l_queries.after
					loop
						stream.put_string ("l.extend (%"")
						stream.put_string (l_queries.item_for_iteration.feature_name)
						stream.put_line ("%")")
						l_queries.forth
					end
					stream.put_string ("supported_query_name_table.put (l, ")
					stream.put_string (class_info.index.out)
					stream.put_line (")")
					stream.put_line ("")
					class_info.forth
				end
				class_info.go_to (l_cursor)
			end
			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.put_line ("")
		end

	generate_supported_query_names_routine is
			-- Generate the routine `supported_query_names'.
		local
			l_cursor: CURSOR
		do
			stream.indent
			stream.put_line ("supported_query_names (o: ANY): LINKED_LIST [STRING] is")
			stream.indent
			stream.put_line ("do")
			if configuration.is_test_case_serialization_enabled then
				stream.indent
				if not class_info.is_empty then
					l_cursor := class_info.cursor
					from
						class_info.start
					until
						class_info.after
					loop
						if class_info.index = 1 then
							stream.put_string ("if ")
						else
							stream.put_string ("elseif ")
						end
						stream.put_string ("attached {")
						stream.put_string (class_info.item.type_name)
						stream.put_string ("} o as l_")
						stream.put_string (class_info.index.out)
						stream.put_line (" then")
						stream.indent
						stream.put_string ("Result := supported_query_name_table.item (")
						stream.put_string (class_info.index.out)
						stream.put_line (")")
						stream.dedent
						class_info.forth
					end
					stream.put_line ("else")
					stream.indent
					stream.put_line ("Result := supported_query_name_table.item (0)")
					stream.dedent
					stream.put_line ("end")
					class_info.go_to (l_cursor)
				else
					stream.put_line ("Result := supported_query_name_table.item (0)")
				end
				stream.dedent
			end
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

;note
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
