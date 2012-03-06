note
	description: "Summary description for {TBON_TEXT_ITEMS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_TEXT_ITEMS

feature -- Access: BON keywords
	bti_class_chart_keyword: STRING = "class_chart"
			-- Informal textual BON keyword for declaring class charts.

	bti_command_keyword: STRING = "command"
			-- Informal textual BON keyword for the command clause.

	bti_constraint_keyword: STRING = "constraint"
			-- Informal textual BON keyword for the constraint clause.

	bti_end_keyword: STRING = "end"
			-- BON keyword for ending a chart or diagram.

	bti_explanation_keyword: STRING = "explanation"
			-- Informal textual BON keyword for the explanation clause.

	bti_indexing_keyword: STRING = "indexing"
			-- Informal textual BON keyword for the indexing clause.

	bti_inherit_keyword: STRING = "inherit"
			-- BON keyword for the inherit clause.

	bti_part_keyword: STRING = "part"
			-- Informal textual BON keyword for the part clause.

	bti_query_keyword: STRING = "query"
			-- Informal textual BON keyword for the query clause.

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
