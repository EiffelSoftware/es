note
	description: "[
					Roundtrip visitor to process class names.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLASS_NAME_VISITOR

inherit
	SCOOP_CONTEXT_AST_PRINTER
		export
			{NONE} all
			{SCOOP_CLASS_NAME} setup, set_context
		redefine
			process_id_as
		end
		
	SCOOP_WORKBENCH
		export
			{NONE} all
		end

create
	make_with_context

feature {SCOOP_CLASS_NAME} -- Initialisation

	make_with_context (a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context

			-- create prefix string
			create scoop_prefix.make_from_string ("SCOOP_SEPARATE__")
			create scoop_string.make_from_string ("STRING")
		end

feature {SCOOP_CLASS_NAME} -- Access

	process_class_list_with_prefix (l_as: CLASS_LIST_AS; print_both: BOOLEAN) is
			-- Process `l_as'.
		do
			is_print_both := true
			is_set_prefix := true
			last_index := l_as.first_token (match_list).index
			process_eiffel_list (l_as)
			last_index := l_as.last_token (match_list).index - 1
		end

	process_id (l_as: ID_AS; a_set_prefix: BOOLEAN) is
			-- Process `l_as'.
		do
			is_print_both := false
			is_set_prefix := a_set_prefix
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
			last_index := l_as.last_token (match_list).index
		end

	process_id_str (l_class_name: STRING; a_set_prefix: BOOLEAN) is
			-- Process `l_as'.
		do
			if a_set_prefix and then (scoop_classes.has (l_class_name.as_upper)) then
				context.add_string (scoop_prefix)
			end
			context.add_string (l_class_name)
			if l_class_name.is_equal ("inherit") then
				is_set_prefix := true
			end
		end

feature {NONE} -- Roundtrip: process nodes

	process_id_as (l_as: ID_AS) is
		local
			is_scoop_string: BOOLEAN
		do
			if l_as.name.is_equal (scoop_string) then
				is_scoop_string := false -- hack to see if this fixes STRING_8 always being processed despite SCOOP_BASIC_TYPE
			end

			process_leading_leaves (l_as.index)
			last_index := l_as.index

			if is_set_prefix and then
			   (is_scoop_string or scoop_classes.has (l_as.name.as_upper))
			   then

				-- add 'SCOOP_SEPARATE__' prefix
				context.add_string (scoop_prefix)
				if is_print_both then
					put_string (l_as)
					if is_scoop_string then
						context.add_string ("_8")
					end
					context.add_string (", ")
				end
			elseif scoop_classes.has (l_as.name.as_upper) then
				do_nothing
			end

			put_string (l_as)
			if is_scoop_string then
				context.add_string ("_8")
			end
			if l_as.name.is_equal ("inherit") then
				is_set_prefix := true
			end
		end

feature {NONE} -- Implementation

	is_print_both: BOOLEAN
			-- indicates if original name and name with prefix should be printed.

	is_set_prefix: BOOLEAN
			-- indicates if prefix should be printed or not.

	scoop_prefix: STRING
			-- string that contains 'SCOOP_SEPARATE__'

	scoop_string: STRING
			-- string that contains 'STRING'

;note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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

end -- SCOOP_CLASS_NAME_VISITOR
