note
	description: "Summary description for {AUT_PREDICATE_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_FACTORY

inherit
	AUT_PREDICATE_UTILITY

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize current factory.
		do
			initialize
		end

feature -- Access

	predicates: DS_HASH_SET [AUT_PREDICATE]
			-- predicates that are created so far

feature -- Basic operations

	initialize is
			-- Initialize current factory.
		do
			create predicates.make (100)
			predicates.set_equality_tester (predicate_equality_tester)
			next_predicate_id := 1
		end

	normal_predicate (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: CLASS_C): AUT_NORMAL_PREDICATE is
			-- If there is no normal predicate which has the same setting with `a_types', `a_text', `a_context_class',
			-- create one and put it into `predicates' and then return that predicate.
			-- Otherwise return the existing predicate.
		do
			if attached {AUT_NORMAL_PREDICATE}
				actual_predicate (create {AUT_NORMAL_PREDICATE}.make (a_types, a_text, a_context_class)) as l_pred
			then
				Result := l_pred
			else
				check should_not_happen: False end
			end
		end

	linear_solvable_predicate (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: CLASS_C; a_constrained_arguments: DS_HASH_SET [INTEGER]; a_constraining_queries: DS_HASH_SET [STRING]): AUT_LINEAR_SOLVABLE_PREDICATE is
			-- If there is no normal predicate which has the same setting with `a_types', `a_text', `a_context_class',
			-- create one and put it into `predicates' and then return that predicate.
			-- Otherwise return the existing predicate.
		do
			if attached {AUT_LINEAR_SOLVABLE_PREDICATE}
				actual_predicate (create {AUT_LINEAR_SOLVABLE_PREDICATE}.make (a_types, a_text, a_context_class, a_constrained_arguments, a_constraining_queries)) as l_pred
			then
				Result := l_pred
			else
				check should_not_happen: False end
			end
		end

feature{NONE} -- Implementation

	next_predicate_id: INTEGER
			-- Id that is to be used for the next created predicate

	actual_predicate (a_predicate: AUT_PREDICATE): AUT_PREDICATE is
			-- if `predicates' already contains `a_predicate', return that predicate
			-- which is in `predicates', otherwise return `a_predicate' (as a side effect, .
			-- insert `a_predicate' into `predicates'.
		do
			if predicates.has (a_predicate) then
				Result := predicates.item (a_predicate)
			else
				a_predicate.set_id (next_predicate_id)
				predicates.force_last (a_predicate)
				next_predicate_id := next_predicate_id + 1
				Result := a_predicate
			end
		end

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
