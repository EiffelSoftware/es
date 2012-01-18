note
	description: "Prints an ast while depending purely on structure information (no matchlist needed)."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_STRUCTURE_PRINTER_WITH_HOOKS

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process,
			process_list_with_separator
		end

feature {NONE} -- Implementation (Processing)

	process (a_as: detachable AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as'
		do
			if attached a_as as l_as then
--				debug
					io.put_string ("[process] ")
					io.put_string (l_as.generating_type.name)
					io.put_string (",")
					if attached a_parent as l_parent then io.put_string (l_parent.generating_type.name) end
					io.put_string (",")
					io.put_integer (a_branch)
					io.put_new_line
--				end

				if attached process_hook as l_agent then
					l_agent.call([a_as, a_parent, a_branch, true])
				end

				Precursor (a_as, a_parent, a_branch)

				if attached process_hook as l_agent then
					l_agent.call([a_as, a_parent, a_branch, false])
				end
			end
		end

	process_list_with_separator (a_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as' and use `separator' for string output
		local
			l_cursor: INTEGER
		do
			if attached a_as as l_as then
--				debug
					io.put_string ("[process_list_with_separator] ")
					io.put_string (l_as.generating_type.name)
--					if attached l_as.generating_type as l_type then
--						if l_type.generic_parameter_count > 0 and then attached l_type.generic_parameter_type (1) as l_generic_type then
--							io.put_string ("_OF_")
--							io.put_string (l_generic_type.name)
--							io.put_string ("")
--						end
--					end
					io.put_string (",")
					if attached a_parent as l_parent then io.put_string (l_parent.generating_type.name) end
					io.put_string (",")
					io.put_integer (a_branch)
					io.put_new_line
--				end

				if attached process_list_with_separator_hook as l_agent then
					l_agent.call([a_as, separator, a_parent, a_branch, true])
				end

				Precursor (a_as, separator, a_parent, a_branch)

--				from
--					l_cursor := l_as.index
--					l_as.start
--				until
--					l_as.after
--				loop
--					debug
--						io.put_string ("-->")
--						io.put_string (l_as.item.generator)
--						io.put_string (",")
--						io.put_string (l_as.generator)
--						io.put_string (",")
--						io.put_integer (l_as.index)
--						io.put_new_line
--					end
--					process_child (l_as.item, l_as, l_as.index)
--					if attached separator and l_as.index /= l_as.count then
--						output.append_string ((separator))
--					end
--					l_as.forth
--				end
--				l_as.go_i_th (l_cursor)

				if attached process_list_with_separator_hook as l_agent then
					l_agent.call([a_as, separator, a_parent, a_branch, false])
				end
			end
		end

feature {NONE} -- Implementation (Processing - Add-On)

	process_hook: detachable ROUTINE [ANY, TUPLE [a_as: detachable AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER; a_open: BOOLEAN]]
		assign set_process_hook
			-- Agent executed at the beginning and end of `process'.

	process_list_with_separator_hook: detachable ROUTINE [ANY, TUPLE [a_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER; a_open: BOOLEAN]]
		assign set_process_list_with_separator_hook
			-- Agent executed at the beginning and end of `process_list_with_separator'.

feature -- Configuration

	set_process_hook (a_agent: like process_hook)
			-- Sets `process_hook'.
		require
			a_agent_not_void: attached a_agent
		do
			process_hook := a_agent
		end

	set_process_list_with_separator_hook (a_agent: like process_list_with_separator_hook)
			-- Sets `process_list_with_separator_hook'.
		require
			a_agent_not_void: attached a_agent
		do
			process_list_with_separator_hook := a_agent
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
