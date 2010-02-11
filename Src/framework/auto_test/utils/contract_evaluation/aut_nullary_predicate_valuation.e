note
	description: "Summary description for {AUT_NULLARY_PREDICATE_VALUATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NULLARY_PREDICATE_VALUATION

inherit
	AUT_PREDICATE_VALUATION

create
	make

feature{NONE} -- Initialization

	make (a_predicate: like predicate) is
			-- Initialize `predicate' with `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_valid: a_predicate.is_nullary
		do
			predicate := a_predicate
		ensure
			predicate_set: predicate = a_predicate
		end

feature -- Access

	count: INTEGER is
			-- <Precursor>
		do
			if value then
				Result := {INTEGER}.max_value
			else
				Result := 0
			end
		end

	item (a_arguments: ARRAY [ITP_VARIABLE]): BOOLEAN is
			-- <Precursor>
		do
			Result := value
		ensure then
			good_result: Result = value
		end

feature -- Status report

	has_variable (a_variable: ITP_VARIABLE): BOOLEAN is
			-- Does `a_variable' exist in current valuation?
		do
			Result := False
		end

feature -- Basic operations

	put (a_arguments: ARRAY [ITP_VARIABLE]; a_value: BOOLEAN) is
			-- Set valuation for `a_arguments' with `a_value'.
			-- Index of `a_arguments' is 1-based. They are arguments for `predicate'.
		do
			value := a_value
		ensure then
			good_result: value = a_value
		end

	wipe_out is
			-- Wipe out current all valuations.
		do
			value := False
		ensure then
			good_result: value = False
		end

	remove_variable (a_variable: ITP_VARIABLE) is
			-- Remove all valuations related to `a_variable'.
		do
			-- Do nothing
		end

feature -- Process

	process (a_visitor: AUT_PREDICATE_VALUATION_VISITOR) is
			-- Prcoess current with `a_visitor'.
		do
			a_visitor.process_nullary_predicate_valuation (Current)
		end

feature{AUT_NULLARY_PREDICATE_VALUATION_CURSOR} -- Implementation

	value: BOOLEAN;
			-- Value of current nullary predicate valuation

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
