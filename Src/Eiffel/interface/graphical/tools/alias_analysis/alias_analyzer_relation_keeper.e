note
	description: "Keeper for alias relations."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_RELATION_KEEPER

inherit
	AST_STACKED_SCOPE_KEEPER [ALIAS_ANALYZER_RELATION [INTEGER_32]]
		rename
			make as make_stacked,
			scope as relation
		export {ALIAS_ANALYZER}
			enter_realm,
			is_sibling_dominating,
			leave_optional_realm,
			leave_realm,
			relation,
			save_sibling,
			update_realm,
			update_sibling
		end

create
	make

feature {NONE} -- Creation

	make (any_aliases: ARRAY [INTEGER_32])
			-- Initialize storage to keep alias relation
			-- with special entries `any_aliases' that can be aliased to anything.
		do
			make_stacked (0)
			across
				any_aliases as c
			loop
				relation.add_any (c.item)
			end
		end

feature {NONE} -- Modification: nesting

	merge_siblings
			-- Merge sibling scope information from scope
			-- into `inner_scopes.item'.
		local
			s: like relation
		do
			s := inner_scopes.item
			if s /= relation then
				s.add_relation (relation)
			end
		end

feature {NONE} -- Initialization

	new_scope (n: like count): like relation
			-- New alias relation.
		do
				-- Pass an empty list of predefined entries here.
				-- They are added by the creation procedure.
			create Result.make (<<>>)
		end

feature {NONE} -- Status report

	is_dominating: BOOLEAN
			-- <Precursor>
		do
			Result := relation.is_subset (inner_scopes.item)
		end

feature {NONE} -- Unused

	is_attached (index: like count): BOOLEAN
			-- <Precursor>
		do
		ensure then
			False
		end

	max_count: INTEGER_32
			-- <Precursor>
		do
			Result := Result.max_value
		end

	start_scope (index: like count)
			-- Mark that a variable with the given `index' is not void.
		do
		ensure then
			False
		end

	stop_scope (index: like count)
			-- Mark that a local with the given `position' can be void.
		do
		ensure then
			False
		end

	set_all
			-- Mark that all variables are not void.
		do
		ensure then
			False
		end

note
	copyright: "Copyright (c) 2012-2013, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
