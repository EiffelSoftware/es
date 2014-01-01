note
	description: "Allows undoable modification of a class text. It is basically the same as {ERF_CLASS_TEXT_MODIFICATION} but it has been adapted to code analysis fixes."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CA_CLASS_TEXT_MODIFICATION

inherit
	ERF_CLASS_TEXT_MODIFICATION

create
	make

feature

	execute_fix (a_visitor: CA_FIX; process_leading: BOOLEAN)
			-- Execute `a_visitor' on this class, if we `process_leading' we process all nodes and process the `BREAK_AS' directly,
			-- otherwise we process the `BREAK_AS' at the end.
		require
			text_managed: text_managed
		do
			compute_ast
			if not is_parse_error then
				a_visitor.setup (ast, match_list, process_leading, true)
				a_visitor.process_ast_node (ast)
				if not process_leading then
					a_visitor.process_all_break_as
				end
			end

			rebuild_text
			logger.refactoring_class (class_i)
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
