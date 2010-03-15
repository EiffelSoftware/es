note
	description: "Wraps a statement with an if. Example for the use of trackable modifications"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_WRAP_GENERATOR
inherit
	ETR_SHARED_FACTORIES
	ETR_SHARED_TOOLS
	ETR_SHARED_ERROR_HANDLER

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications resulting from the last application

feature -- Operation

	wrap_statement (a_container: ETR_TRANSFORMABLE; a_statement_location: AST_PATH; a_guard: ETR_TRANSFORMABLE)
			-- Guard statement at `a_statement_location' in `a_container' with `a_guard'
		require
			valid_container: a_container /= void and then a_container.is_valid
			valid_loc: a_statement_location /= void and then a_statement_location.is_valid
			valid_guard: a_guard /= void and then a_guard.is_valid
		local
			l_replacement_instruction: ETR_TRANSFORMABLE
			l_original_statement: ETR_TRANSFORMABLE
			l_repl_mod: ETR_TRACKABLE_MODIFICATION
			l_bp_map: HASH_TABLE[INTEGER,INTEGER]
			l_old_bp_slot: INTEGER
			l_old_bp_count: INTEGER
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			path_tools.find_node (a_statement_location, a_container.target_node)

			if not path_tools.found then
				error_handler.add_error (Current, "wrap_statement", "Statement location was not found in container.")
			else
				create l_original_statement.make (path_tools.last_ast, a_container.context, true)
				l_replacement_instruction := transformable_factory.new_conditional (a_guard, l_original_statement, void, a_container.context)

				create l_bp_map.make (5)
				l_old_bp_slot := l_original_statement.target_node.breakpoint_slot
				l_old_bp_count := l_original_statement.breakpoint_count

				l_bp_map.extend (l_old_bp_slot, a_guard.target_node.breakpoint_slot) -- old->guard.bp_slot
				tracking_tools.map_region_shifted (l_bp_map, l_old_bp_slot+1, l_old_bp_slot, l_old_bp_count) -- old+1->old, etc

				create l_repl_mod.make_replace (a_statement_location, l_replacement_instruction.out)

				l_repl_mod.initialize_tracking_info (l_bp_map, l_old_bp_slot, l_old_bp_count, l_old_bp_count+1)
				modifications.extend (l_repl_mod)
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
