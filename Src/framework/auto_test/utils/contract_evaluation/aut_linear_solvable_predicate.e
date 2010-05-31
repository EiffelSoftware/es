note
	description: "Linearly solvable predicate used in predicate pool"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_LINEAR_SOLVABLE_PREDICATE

inherit
	AUT_PREDICATE
		rename
			make as old_make
		redefine
			is_linear_solvable
		end

create
	make

feature{NONE} -- Initializaiton

	make (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: like context_class; a_constrained_arguments: like constrained_arguments; a_constraining_queries: like constraining_queries) is
			-- Initialize current.
		require
			a_types_attached: a_types /= Void
			a_text_attached: a_text /= Void
			a_context_class_attached: a_context_class /= Void
			a_constrained_arguments_attached: a_constrained_arguments /= Void
			a_constraining_queries_attached: a_constraining_queries /= Void
		do
			old_make (a_types, a_text, a_context_class)

				-- Setup `constrained_arguments'.
			create constrained_arguments.make (a_constrained_arguments.count)
			a_constrained_arguments.do_all (agent constrained_arguments.force_last)

				-- Setup `constraining_queries'.
			create constraining_queries.make (a_constraining_queries.count)
			constraining_queries.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (a, b: STRING): BOOLEAN do Result := a ~ b end))
			a_constraining_queries.do_all (agent constraining_queries.force_last)

			fixme ("Consider remove constrained_arguments and constraining_queries if possible.")
		end

feature -- Status report

	is_linear_solvable: BOOLEAN is True
			-- Is current predicate linearly solvable?

feature -- Access

	constrained_arguments: DS_HASH_SET [INTEGER]
			-- Table of 1-based index of constrained arguments of the predicate

	constraining_queries: DS_HASH_SET [STRING];
			-- List of queries that constrains the arguments
			-- in `constrained_arguments'.
			-- Query names are final names (feature renaming has been resolved)			

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
