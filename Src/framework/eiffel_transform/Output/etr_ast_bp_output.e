note
	description: "Print's an ast with breakpoint-slots"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_BP_OUTPUT
inherit
	ETR_AST_STRING_OUTPUT
		redefine
			append_string,
			enter_child,
			exit_child,
			make,
			reset
		end
create
	make,
	make_with_indentation_string

feature {NONE} -- Creation

	make
			-- <precursor>
		do
			create child_stack.make
			is_new_child := true
			Precursor
		end

feature {NONE} -- Implementation

	child_stack: LINKED_STACK[ANY]
			-- Children we're in at the moment

	is_new_child: BOOLEAN
			-- Is the child at the top of a stack a newly added one

feature -- Operations

	reset
			-- <precursor>
		do
			child_stack.wipe_out
			is_new_child := true
			Precursor
		end

	append_string (a_string: STRING)
			-- <precursor>
		do
			if last_was_newline then
				-- Hack to print the breakpoint-slot at the end of a routine
				if attached {ROUTINE_AS}child_stack.item as ast then
					if not is_new_child and ast.breakpoint_slot/=0 then
						context.add_string (ast.breakpoint_slot.out)
					end
				elseif is_new_child and attached {AST_EIFFEL}child_stack.item as ast and then ast.breakpoint_slot/=0 then
					context.add_string (ast.breakpoint_slot.out)
				end
				context.add_string (current_indentation.twin)
			end

			context.add_string (a_string)

			if a_string.ends_with ("%N") then
				last_was_newline := true
			else
				last_was_newline := false
			end
		end

	enter_child (a_child: ANY)
			-- <precursor>
		do
			child_stack.put (a_child)
			is_new_child := true
		end

	exit_child
			-- <precursor>
		do
			child_stack.remove
			is_new_child := false
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
