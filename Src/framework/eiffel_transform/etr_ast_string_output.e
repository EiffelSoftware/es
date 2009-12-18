note
	description: "Prints an ast structure to a normal text representation"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_STRING_OUTPUT
inherit
	ETR_AST_STRUCTURE_OUTPUT
create
	make,
	make_with_indentation_string

feature {NONE} -- Implementation
	context: ROUNDTRIP_STRING_LIST_CONTEXT

	last_was_newline: BOOLEAN

	current_indentation: STRING

	make is
			-- Create with `default_indentation_string'
		do
			make_with_indentation_string(default_indentation_string)
		end

	make_with_indentation_string(an_indentation_string: like indentation_string)
			-- Create with `an_indentation_string'
		require
			string_attached: an_indentation_string /= void
		do
			create context.make
			create current_indentation.make_empty
			indentation_string := an_indentation_string
		end

feature -- Constants

	default_indentation_string: like indentation_string is "%T"

feature -- Attributes

	indentation_string: STRING

feature -- Output
	string_representation:STRING
			-- string representation of `Current'
		do
			Result := context.string_representation
		end

feature -- Operations

	set_indentation_string(an_indentation_string: like indentation_string)
			-- Set `indentation_string'
		require
			not_void: an_indentation_string /= void
		do
			indentation_string := an_indentation_string
		end

	reset
			-- Resets the internals state
		do
			context.clear
			current_indentation := ""
		end

	enter_block
			-- Enters a new indentation-block
		do
			current_indentation := current_indentation + indentation_string
		end

	exit_block
			-- Exits an indentation-block
		do
			if current_indentation.count >= indentation_string.count then
				current_indentation.remove_tail (indentation_string.count)
			end
		end

	enter_child(a_name: STRING)
			-- Enters a new child with name `a_name'
		do
			-- unused
		end

	exit_child
			-- Exits a child
		do
			-- unused
		end

	append_string(a_string: STRING)
			-- Appends `a_string' to the output
		do
			if last_was_newline then
				context.add_string (current_indentation.twin)
			end

			context.add_string (a_string)

			if a_string.ends_with ("%N") then
				last_was_newline := true
			else
				last_was_newline := false
			end
		end

note
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
