note
	description: "Prints an ast structure to a normal text representation."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_STRING_OUTPUT

inherit
	ETR_AST_STRUCTURE_OUTPUT_I
		redefine
			set_block_depth
		end
		
create
	make,
	make_with_indentation_string

feature {NONE} -- Creation

	make
			-- Create with `default_indentation_string'
		do
			make_with_indentation_string(default_indentation_string)
		end

	make_with_indentation_string (an_indentation_string: like indentation_string)
			-- Create with `an_indentation_string'
		require
			string_attached: an_indentation_string /= void
		do
			create context.make
			create current_indentation.make_empty
			indentation_string := an_indentation_string
			last_was_newline := true
		end

feature {NONE} -- Implementation
	context: ROUNDTRIP_STRING_LIST_CONTEXT
			-- String-context used to append strings

	last_was_newline: BOOLEAN
			-- Was the last symbol a newline?

	current_indentation: STRING
			-- Current level of indentation

feature -- Constants

	default_indentation_string: STRING
			-- The default indentation string
		once
			Result := "%T"
		end

feature -- Attributes

	indentation_string: STRING

feature -- Output
	string_representation:STRING
			-- string representation of `Current'
		do
			Result := context.string_representation
		end

feature -- Operations

	set_block_depth (a_block_depth: like block_depth)
			-- Set `block_depth' to `a_block_depth'.
		local
			l_index: INTEGER
		do
			from
				l_index := 1
				create current_indentation.make_empty
			until
				l_index > a_block_depth
			loop
				current_indentation.append (indentation_string)
				l_index := l_index + 1
			end

			block_depth := a_block_depth
		end

	set_indentation_string (an_indentation_string: like indentation_string)
			-- Set `indentation_string'
		require
			not_void: an_indentation_string /= void
		do
			indentation_string := an_indentation_string
		end

	reset
			-- <precursor>
		do
			context.clear
			current_indentation := ""
			last_was_newline := true
			block_depth := 0
		end

	enter_block
			-- <precursor>
		do
			current_indentation := current_indentation + indentation_string
			block_depth := block_depth + 1
		end

	exit_block
			-- <precursor>
		do
			if current_indentation.count >= indentation_string.count then
				current_indentation.remove_tail (indentation_string.count)
			end
			block_depth := block_depth - 1
		end

	enter_child(a_child: ANY)
			-- <precursor>
		do
			-- unused
		end

	exit_child
			-- <precursor>
		do
			-- unused
		end

	append_string (a_string: STRING)
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
