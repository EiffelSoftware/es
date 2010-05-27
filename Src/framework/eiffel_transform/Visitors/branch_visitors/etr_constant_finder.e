note
	description: "Constant extraction: Extracts all matching constants from an ast."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONSTANT_FINDER
inherit
	ETR_PATH_VISITOR
		redefine
			process_string_as,
			process_verbatim_string_as,
			process_integer_as,
			process_real_as,
			process_char_as,
			process_bit_const_as,
			process_bool_as,
			process_feature_as,
			process_routine_as
		end

feature -- Operation

	find_constants (a_constant: like constant; a_root: CLASS_AS; a_feature_name: like feature_name)
			-- Find all constants that match `a_constant'
		require
			non_void: a_constant /= void and a_root /= void
		do
			is_processing_single_feature := a_feature_name /= void
			feature_name := a_feature_name

			constant := a_constant
			create {LINKED_LIST[AST_PATH]}found_constants.make
			create current_path.make_as_root
			a_root.process (Current)
		end

feature -- Access

	found_constants: LIST[AST_PATH]
			-- Found constants

feature {NONE} -- Implementation

	feature_name: detachable STRING

	is_processing_single_feature: BOOLEAN

	constant: AST_EIFFEL
			-- The constant we're looking for

	is_in_routine: BOOLEAN

	process_constant (l_as: AST_EIFFEL)
			-- Check l_as
		do
			if is_in_routine and constant.same_type(l_as) and then constant.is_equivalent(l_as) then
				found_constants.extend (current_path)
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_routine_as (l_as: ROUTINE_AS)
		do
			is_in_routine := true
			Precursor(l_as)
			is_in_routine := false
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			if is_processing_single_feature then
				if l_as.feature_name.name.is_equal (feature_name) then
					Precursor(l_as)
				end
			else
				Precursor(l_as)
			end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			process_constant (l_as)
		end

	process_bit_const_as (l_as: BIT_CONST_AS)
		do
			process_constant (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			process_constant (l_as)
		end

	process_string_as (l_as: STRING_AS)
		do
			process_constant (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			process_constant (l_as)
		end

	process_real_as (l_as: REAL_AS)
		do
			process_constant (l_as)
		end

	process_char_as (l_as: CHAR_AS)
		do
			process_constant (l_as)
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
