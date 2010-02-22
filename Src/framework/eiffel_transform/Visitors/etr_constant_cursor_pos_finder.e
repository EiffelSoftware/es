note
	description: "Summary description for {ETR_CONSTANT_CURSOR_POS_FINDER}."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONSTANT_CURSOR_POS_FINDER
inherit
	ETR_PATH_FINDER
		redefine
			process_routine_as,
			process_feature_as,
			find_from
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make_with_match_list

feature -- Access

	contained_feature_name: STRING

feature -- Operation

	init(a_x, a_y: INTEGER)
			-- Init with (`a_x'/`a_y')
		do
			target_x := a_x
			target_y := a_y
			is_in_routine := false
		end

	find_from(a_ast: AST_EIFFEL)
			-- <precursor>
		do
			contained_feature_name := void
			Precursor(a_ast)
		end

feature {NONE} -- Implementation

	is_in_routine: BOOLEAN

	is_constant (a_ast: AST_EIFFEL): BOOLEAN
		do
			if attached {INTEGER_AS}a_ast then
				Result := True
			elseif attached {REAL_AS}a_ast then
				Result := True
			elseif attached {CHAR_AS}a_ast then
				Result := True
			elseif attached {BOOL_AS}a_ast then
				Result := True
			elseif attached {STRING_AS}a_ast or attached {VERBATIM_STRING_AS}a_ast then
				Result := True
			elseif attached {BIT_CONST_AS}a_ast as b then
				Result := True
			end
		end

	target_x, target_y: INTEGER
			-- The position we're looking for

	is_target(a_ast: AST_EIFFEL): BOOLEAN
			-- is `a_ast' the target?
		do
			if is_in_routine and is_constant(a_ast) and attached {LOCATION_AS}a_ast as loc then
				if loc.line = target_y and target_x >= loc.column and target_x <= loc.final_column then
					Result := true
				end
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_feature_as (l_as: FEATURE_AS)
		do
			contained_feature_name := l_as.feature_name.name
			Precursor(l_as)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			is_in_routine := true
			Precursor(l_as)
			is_in_routine := false
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
