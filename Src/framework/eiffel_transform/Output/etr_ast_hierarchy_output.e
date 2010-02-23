note
	description: "Prints an ast structure to a tree."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_HIERARCHY_OUTPUT
inherit
	ETR_AST_STRING_OUTPUT
		redefine
			enter_block,
			exit_block,
			enter_child,
			exit_child,
			append_string
		end
create
	make,
	make_with_indentation_string

feature -- Operations

	enter_block
			-- Enters a new indentation-block
		do
			block_depth := block_depth + 1
		end

	exit_block
			-- Exits an indentation-block
		do
			block_depth := block_depth - 1
		end

	enter_child(a_name: STRING)
			-- Enters a new child with name `a_name'
		do
			context.add_string (current_indentation.twin+a_name+"%N")
			current_indentation := current_indentation + indentation_string
		end

	exit_child
			-- Exits a child
		do
			if current_indentation.count >= indentation_string.count then
				current_indentation.remove_tail (indentation_string.count)
			end
		end

	append_string(a_string: STRING)
			-- Appends `a_string' to the output
		do
			-- unused
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
