note
	description: "Modifies ast nodes"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_MODIFIER
inherit
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_PARSERS
create
	make

feature {NONE} -- Creation

	make
			-- create a new instance
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			create modified_transformable.make_invalid
			create output.make
		end

feature -- Access

	modified_transformable: detachable ETR_TRANSFORMABLE
			-- Transformable with modifications applied

	modifications: LIST[ETR_AST_MODIFICATION]
			-- The modifications stored

	output: ETR_AST_STRING_OUTPUT
			-- string output of printer

feature -- Operations

	add_list (a_list: like modifications)
			-- Add `a_list' to `modifications'
		require
			list_attached: a_list /= void
		do
			modifications.append (a_list)
		end

	add (a_modification: ETR_AST_MODIFICATION)
			-- Add `a_modification' to `modifications'
		require
			non_void: a_modification /= void
		do
			modifications.extend (a_modification)
		end

	reset
			-- Empty `modifications' and reset `output'
		do
			modifications.wipe_out
			output.reset
		end

	apply_to (a_transformable: ETR_TRANSFORMABLE)
			-- Apply to `a_transformable'
		require
			non_void: a_transformable /= void and a_transformable.is_valid /= void
		local
			l_printer: ETR_MODIFYING_PRINTER
		do
			-- pick parser depending on root node
			create l_printer.make (output, modifications)
			l_printer.print_ast_to_output (a_transformable.target_node)

			parsing_helper.parse_printed_ast(a_transformable.target_node, output.string_representation)

			if attached parsing_helper.parsed_ast then
				create modified_transformable.make_from_ast (parsing_helper.parsed_ast, a_transformable.context, false)
			else
				create modified_transformable.make_invalid
				error_handler.add_error (Current, "apply_to", "Modification resulted in unparsable text.")
			end

			-- Reset the modifications list and output
			reset
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
