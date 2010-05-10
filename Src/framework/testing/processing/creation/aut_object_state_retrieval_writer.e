note
	description: "Class to generate code for object state retrieval during testing"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_RETRIEVAL_WRITER

inherit
	AUT_SOURCE_WRITER_UTILITY

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

create
	make

feature{NONE} -- Initialization

	make (a_type_list: like type_list; a_stream: like stream; a_is_needed: BOOLEAN; a_root_class: like root_class; a_root_feature: like root_feature)
			-- Initialize Current.
		require
			a_type_list_attached: a_type_list /= Void
			a_steam_attached: a_stream /= Void
			a_root_class_attached: a_root_class /= Void
			a_root_feature_attached: a_root_feature /= Void
		do
			type_list := a_type_list.twin
			stream := a_stream
			is_object_state_retrieval_needed := a_is_needed
			root_class := a_root_class
			root_feature := a_root_feature
		end

feature -- Access

	type_list: DS_LINEAR [STRING]
			-- List of types

	stream: TEST_INDENTING_SOURCE_WRITER
			-- Stream to output generated code

	root_class: CLASS_C
			-- Root class of current system

	root_feature: FEATURE_I
			-- Root feature of current system

feature -- Status report

	is_object_state_retrieval_needed: BOOLEAN
			-- Is object state retrieval needed?	

feature -- Basic operations

	write
			-- Write generated code into `stream'.
			-- Generate routines to support object state retrieval.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		local
			l_class_info: LINKED_LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]
		do
			if is_object_state_retrieval_needed then
				l_class_info := topologically_sorted_classes_info (type_list)

					-- Generate routines to record states.
				put_record_queries_routine (l_class_info)
				put_record_queries_with_static_type_routine (l_class_info)

				from
					l_class_info.start
				until
					l_class_info.after
				loop
					put_record_query_routine (l_class_info.item.a_class_name, l_class_info.item.a_type, l_class_info.item.a_type_name)
					l_class_info.forth
				end
				put_record_query_default
				put_record_query_for_void
			else
				put_empty_record_queries_routine
				put_empty_record_queries_with_static_type_routine
			end
		end

feature{NONE} -- Implementation

	put_record_queries_routine (a_classes: LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]) is
			-- Generate `record_queries' routine for record argumentless queries
			-- of type BOOLEAN and INTEGER.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		local
			l_class: CLASS_C
			l_classi: LIST [CLASS_I]
			l_class_name: STRING
			l_local_name: STRING
			i: INTEGER
		do
			stream.indent
			stream.put_line ("record_queries (o: detachable ANY)")
			stream.indent
			STREAM.put_line ("do")
			stream.indent
			from
				type_a_checker.init_for_checking (root_feature, root_class, Void, Void)
				a_classes.start
				i := 1
			until
				a_classes.after
			loop
				l_class_name := a_classes.item.a_class_name
				l_local_name := "l_" + l_class_name.as_lower
				if i = 1 then
					stream.put_string ("if ")
				else
					stream.put_string ("elseif ")
				end
				stream.put_string ("attached {")
				stream.put_string (a_classes.item.a_type_name)
				stream.put_string ("} o as ")
				stream.put_string (l_local_name)
				stream.put_line (" then")

				stream.indent
				stream.put_string ("record_query_")
				stream.put_string (l_class_name)
				stream.put_string (" (")
				stream.put_string (l_local_name)
				stream.put_line (")")
				stream.dedent
				i := i + 1
				a_classes.forth
			end

			if a_classes.is_empty then
				stream.put_string ("if ")
			else
				stream.put_string ("elseif ")
			end
			stream.put_line ("attached {ANY} o as l_obj_of_any then")
			stream.indent
			stream.put_line ("record_query_default_for_any (l_obj_of_any)")
			stream.dedent

			stream.put_line ("else")
			stream.indent
			stream.put_line ("record_query_for_void")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_queries_with_static_type_routine (a_classes: LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]) is
			-- Generate `record_queries_with_static_type' routine for record argumentless queries
			-- of type BOOLEAN and INTEGER.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		local
			l_class: CLASS_C
			l_classi: LIST [CLASS_I]
			l_class_name: STRING
			l_local_name: STRING
			i: INTEGER
		do
			stream.indent
			stream.put_line ("record_queries_with_static_type (o: detachable ANY; a_static_type: STRING)")
			stream.indent
			stream.put_line ("do")
			stream.indent
			from
				type_a_checker.init_for_checking (root_feature, root_class, Void, Void)
				a_classes.start
				i := 1
			until
				a_classes.after
			loop
				l_class_name := a_classes.item.a_class_name
				l_local_name := "l_" + l_class_name.as_lower
				if i = 1 then
					stream.put_string ("if a_static_type.is_equal (%"" + a_classes.item.a_type_name + "%") and then ")
				else
					stream.put_string ("elseif a_static_type.is_equal (%"" + a_classes.item.a_type_name + "%") and then ")
				end
				stream.put_string ("attached {")
				stream.put_string (a_classes.item.a_type_name)
				stream.put_string ("} o as ")
				stream.put_string (l_local_name)
				stream.put_line (" then")

				stream.indent
				stream.put_string ("record_query_")
				stream.put_string (l_class_name)
				stream.put_string (" (")
				stream.put_string (l_local_name)
				stream.put_line (")")
				stream.dedent
				i := i + 1
				a_classes.forth
			end

			if a_classes.is_empty then
				stream.put_string ("if ")
			else
				stream.put_string ("elseif ")
			end
			stream.put_line ("attached {ANY} o as l_obj_of_any then")
			stream.indent
			stream.put_line ("record_query_default_for_any (l_obj_of_any)")
			stream.dedent

			stream.put_line ("else")
			stream.indent
			stream.put_line ("record_query_for_void")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_empty_record_queries_routine is
			-- Generate an empty `record_queires' feature.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		do
			stream.indent
			stream.put_line ("record_queries (o: ANY)")
			stream.indent
			stream.put_line ("do")
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_empty_record_queries_with_static_type_routine
			-- Generate an empty `record_queires_with_static_type' feature.
			-- Note: If the recording from byte-code works, this feature should be removed.
		do
			stream.indent
			stream.put_line ("record_queries_with_static_type (o: ANY; a_static_type: STRING)")
			stream.indent
			stream.put_line ("do")
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end
	put_record_query_routine (a_class_name: STRING; a_type: TYPE_A; a_full_type_name: STRING) is
			-- Put routine to record queries for `a_type'.
		require
			a_class_name_attached: a_class_name /= Void
			a_type_attached: a_full_type_name /= Void
		local
			l_features: LIST [FEATURE_I]
		do

			stream.indent
			stream.put_string ("record_query_")
			stream.put_string (a_class_name)
			stream.put_string (" (o: ")
			stream.put_string (a_full_type_name)
			stream.put_line (")")
			stream.indent
			stream.put_line ("do")
			stream.indent

			if
				a_type.is_integer or else
				a_type.is_natural or else
				a_type.is_real_32 or else
				a_type.is_real_64 or else
				a_type.is_character or else
				a_type.is_boolean or else
				a_type.is_character_32 or else
				a_type.is_pointer
			then
				stream.put_line ("record_object_state_basic (o)")
			else
				l_features := argumentless_primitive_queries (a_type)
				from
					l_features.start
				until
					l_features.after
				loop
					stream.put_string ("record_query (agent o.")
					stream.put_string (l_features.item.feature_name.as_lower)
					stream.put_line (")")
					l_features.forth
				end
			end

			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_query_default is
			-- Put "record_query_default_for_any" into stream.
		do
			stream.indent
			stream.put_line ("record_query_default_for_any (a_obj: ANY)")
			stream.indent
			stream.put_line ("do end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_query_for_void is
			-- Put "record_query_default_for_any" into stream.
		do
			stream.indent
			stream.put_line ("record_query_for_void")
			stream.indent
			stream.put_line ("do")
			stream.indent
			 stream.put_line ("record_query (agent: STRING do Result := %"Void%" end)")
			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
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
