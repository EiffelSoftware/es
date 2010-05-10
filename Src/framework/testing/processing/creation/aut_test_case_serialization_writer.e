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

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	AUT_SOURCE_WRITER_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration; a_stream: like stream; a_type_list: DS_LINEAR [STRING]; a_root_class: like root_class) is
			-- Initialize `stream' with `a_stream'.
		require
			a_config_attached: a_config /= Void
			a_stream_attached: a_stream /= Void
			a_type_list_attached: a_type_list /= Void
		do
			configuration := a_config
			stream := a_stream
			root_class := a_root_class
			class_info := topologically_sorted_classes_info (a_type_list)
		ensure
			configuration_set: configuration = a_config
			stream_set: stream = a_stream
			root_class_set: root_class = a_root_class
		end

feature -- Access

	stream: TEST_INDENTING_SOURCE_WRITER
			-- Stream used to store generated source code

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration of current AutoTest session

	class_info: LINKED_LIST [TUPLE [class_name: STRING; type: TYPE_A; type_name: STRING]]
			-- Information of classes	

	root_class: CLASS_C
			-- Root class of current system

feature -- Generation

	generate is
			-- Generate routines needed by test case serialization.
		do
			generate_supported_query_names_routine
			generate_supported_query_names_with_static_type_routine
			generate_supported_query_type_routine
			generate_initialize_supported_query_name_table_routine
		end

	generate_initialize_supported_query_name_table_routine is
			-- Generate the routine `initialize_supported_query_name_table'.
		local
			l_cursor: CURSOR
			l_queries: LIST [FEATURE_I]
			l_signature: STRING
			l_feat: E_FEATURE
			l_type: TYPE_A
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
			stream.put_string ("create supported_query_type_table.make (")
			stream.put_string ((class_info.count + 1).out)
			stream.put_line (")")
			stream.put_line ("supported_query_name_table.put (create {LINKED_LIST [STRING]}.make, 0)")
			stream.put_line ("supported_query_type_table.put (%"%", 0)")

			if configuration.is_test_case_serialization_enabled then
				l_cursor := class_info.cursor
				from
					class_info.start
				until
					class_info.after
				loop
					stream.put_string ("%T-- For class ")
					stream.put_line (class_info.item_for_iteration.class_name)
					stream.put_line ("create l.make")
					l_queries := argumentless_primitive_queries (class_info.item.type)
					create l_signature.make (64)
					from
						l_queries.start
					until
						l_queries.after
					loop
						stream.put_string ("l.extend (%"")
						l_feat := l_queries.item_for_iteration.e_feature

						l_type := l_feat.type.instantiation_in (l_feat.associated_class.actual_type, l_feat.associated_class.class_id).actual_type
						if l_type.is_boolean then
							l_signature.extend ('b')
						elseif l_type.is_integer then
							l_signature.extend ('i')
						elseif l_type.is_real_32 or l_type.is_real_64 then
							l_signature.extend ('f')
						elseif l_type.is_character or l_type.is_character_32 then
							l_signature.extend ('c')
						elseif l_type.is_pointer then
							l_signature.extend ('p')
						elseif
							(l_type.conform_to (system.any_class.compiled_class, system.string_8_class.compiled_class.actual_type) or else
				 			 l_type.conform_to (system.any_class.compiled_class, system.string_32_class.compiled_class.actual_type)) then
							l_signature.extend ('s')
						else
							l_signature.extend ('r')
						end
						stream.put_string (l_queries.item_for_iteration.feature_name)
						stream.put_line ("%")")
						l_queries.forth
					end
					stream.put_string ("supported_query_name_table.put (l, ")
					stream.put_string (class_info.index.out)
					stream.put_line (")")
					stream.put_string ("supported_query_type_table.put (%"")
					stream.put_string (l_signature)
					stream.put_string ("%", ")
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

	generate_supported_query_names_with_static_type_routine is
			-- Generate the routine `supported_query_names_with_static_type'.
		local
			l_cursor: CURSOR
		do
			stream.indent
			stream.put_line ("supported_query_names_with_static_type (o: ANY; a_static_type: STRING): LINKED_LIST [STRING] is")
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
						stream.put_string ("a_static_type.is_equal (%"" + class_info.item.type_name + "%")")
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

	generate_supported_query_type_routine is
			-- Generate the routine `supported_query_names'.
		local
			l_cursor: CURSOR
		do
			stream.indent
			stream.put_line ("supported_query_types (o: ANY): STRING is")
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
						stream.put_string ("Result := supported_query_type_table.item (")
						stream.put_string (class_info.index.out)
						stream.put_line (")")
						stream.dedent
						class_info.forth
					end
					stream.put_line ("else")
					stream.indent
					stream.put_line ("Result := supported_query_type_table.item (0)")
					stream.dedent
					stream.put_line ("end")
					class_info.go_to (l_cursor)
				else
					stream.put_line ("Result := supported_query_type_table.item (0)")
				end
				stream.dedent
			end
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

;note
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
