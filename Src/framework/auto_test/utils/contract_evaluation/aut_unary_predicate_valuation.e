note
	description: "Summary description for {AUT_UNARY_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_UNARY_PREDICATE_VALUATION

inherit
	AUT_PREDICATE_VALUATION

create
	make

feature{NONE} -- Initializaiton

	make
			-- Initialize current.
		do
			create valuation_mapping.make_default
		end

feature -- Access

	valuation (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Valuation of the unary predicate on `a_variable'
		require
			a_variable_attached: a_variable /= Void
			a_variable_exist: has_variable (a_variable)
		do
			Result := valuation_mapping.item (a_variable)
		ensure
			good_result: Result = valuation_mapping.item (a_variable)
		end

	has_variable (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Returns whether `a_variable' has a valuation
		require
			a_variable_attached: a_variable /= Void
		do
			Result := valuation_mapping.has (a_variable)
		ensure
			good_result: Result = valuation_mapping.has (a_variable)
		end


feature -- Setting

	set_valuation (a_variable: ITP_VARIABLE; a_valuation: BOOLEAN) is
			-- Set the valuation of the unary predicate on `a_variable'
		require
			a_variable_attached: a_variable /= Void
		do
			valuation_mapping.put (a_valuation, a_variable)
		ensure
			valuation_set: valuation_mapping.has (a_variable) and then valuation_mapping.item (a_variable) = a_valuation
		end

feature{NONE} -- Implementation

	valuation_mapping: DS_HASH_TABLE [BOOLEAN, attached ITP_VARIABLE]
			-- Mapping between variable

invariant
	valuation_mapping_set: valuation_mapping /= Void

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
