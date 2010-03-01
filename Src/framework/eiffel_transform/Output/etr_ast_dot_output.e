note
	description: "Prints an ast in dot-format."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_DOT_OUTPUT
inherit
	ETR_AST_STRUCTURE_OUTPUT_I
create
	make

feature -- Operation

	start
			-- Start processing
		do
			context.add_string ("digraph {%N%Tnode [margin=0.2,0.1]%N%Tedge [fontsize=20.0]%N")
		end

	finish
			-- Stop processing
		do
			context.add_string("}")
		end

feature {NONE} -- Creation

	make
			-- Create with `an_indentation_string'
		do
			create context.make
			create node_stack.make
		end

feature {NONE} -- Implementation

	context: ROUNDTRIP_STRING_LIST_CONTEXT
			-- String-context used to append strings

	node_stack: LINKED_STACK[INTEGER]
			-- Children that have been entered

	node_counter: INTEGER
			-- Counter for node id's

feature -- Output

	string_representation:STRING
			-- string representation of `Current'
		do
			Result := context.string_representation
		end

	reset
			-- <precursor>
		do
			context.clear
			node_counter := 0
		end

	append_string (a_string: STRING)
			-- <precursor>
		do
			-- unused
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
			node_stack.remove
		end

	enter_child (a_child: ANY)
			-- <precursor>
		do
			-- Create label for the new node
			context.add_string ("%T{node [label=%""+a_child.generating_type+"%"] "+node_counter.out+"}%N")
			-- Create edge from the current node
			if not node_stack.is_empty then
				if attached {AST_EIFFEL}a_child as ast_child and then attached ast_child.path then
					context.add_string ("%T"+node_stack.item.out+"->"+node_counter.out+" [label="+ast_child.path.branch_id.out+"]%N")
				else
					context.add_string ("%T"+node_stack.item.out+"->"+node_counter.out+"%N")
				end
			end

			-- Add to stack and increment counter
			node_stack.put (node_counter)
			node_counter := node_counter+1
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
