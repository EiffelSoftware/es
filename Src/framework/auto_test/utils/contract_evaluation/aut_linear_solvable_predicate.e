note
	description: "Summary description for {AUT_LINEAR_SOLVABLE_PREDICATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_LINEAR_SOLVABLE_PREDICATE

inherit
	AUT_PREDICATE

feature -- Status report

	is_linear_solvable: BOOLEAN is
			-- Is current predicate linearly solvable?
		do
			Result := True
		ensure then
			good_result: Result
		end

feature -- Access

	constrained_arguments: DS_HASH_TABLE [STRING, INTEGER]
			-- Table of constrained arguments of the predicate
			-- [argument name, 1-based argument index for the predicate]

	constraining_queries: DS_HASH_SET [STRING];
			-- List of queries that constrains the arguments
			-- in `constrained_arguments'.

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
