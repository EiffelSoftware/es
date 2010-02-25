note
	description: "Prints an AST as xml."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_XML_OUTPUT
inherit
	ETR_AST_STRING_OUTPUT
		redefine
			enter_block,
			exit_block,
			enter_child,
			exit_child,
			make_with_indentation_string,
			append_string
		end
create
	make,
	make_with_indentation_string

feature {NONE} -- Creation

	make_with_indentation_string(an_indentation_string: like indentation_string)
			-- Create with `an_indentation_string'
		do
			create node_stack.make
			Precursor(an_indentation_string)
		end

feature -- Output

	node_stack: LINKED_STACK[STRING]

	append_string(a_string: STRING)
			-- <precursor>
		do
			context.add_string (current_indentation.twin + "<text>%N")
			current_indentation := current_indentation + indentation_string
			context.add_string (current_indentation.twin + "<![CDATA[%N")
			current_indentation := current_indentation + indentation_string
			context.add_string (current_indentation.twin + a_string)
			current_indentation.remove_tail (indentation_string.count)
			context.add_string ("%N" + current_indentation.twin + "]]>%N")
			current_indentation.remove_tail (indentation_string.count)
			context.add_string (current_indentation.twin + "</text>%N")
		end

	enter_block
			-- <precursor>
		do
			block_depth := block_depth + 1
		end

	exit_block
			-- <precursor>
		do
			block_depth := block_depth - 1
		end

	exit_child
			-- <precursor>
		do
			current_indentation.remove_tail (indentation_string.count)
			context.add_string (current_indentation.twin+"</"+node_stack.item+">%N")
			node_stack.remove
		end

	enter_child(a_child: ANY)
			-- <precursor>
		local
			l_formatted_name: STRING
		do
			l_formatted_name := a_child.generating_type
			-- remove any spaces
			l_formatted_name.replace_substring_all (" ", "")

			node_stack.put (l_formatted_name)

			context.add_string (current_indentation.twin+"<"+l_formatted_name)

			if attached {AST_EIFFEL}a_child as ast_child then
				if attached ast_child.path then
					context.add_string (" branch_id=%""+ast_child.path.branch_id.out+"%" breakpoint_slot=%""+ast_child.breakpoint_slot.out+"%"")
				else
					context.add_string (" breakpoint_slot=%""+ast_child.breakpoint_slot.out+"%"")
				end
			else
				context.add_string (current_indentation.twin+a_child.generating_type+"%N")
			end
			context.add_string (">%N")

			current_indentation := current_indentation + indentation_string
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
