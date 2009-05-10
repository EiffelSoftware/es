note
	description: "Summary description for {AUT_NORMAL_PREDICATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NORMAL_PREDICATE

inherit
	AUT_PREDICATE

create
	make

feature{NONE} -- Initializaiton

	make (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: like context_class; a_assertion: like assertion) is
			-- Initialize current.
		do
			create types.make
			a_types.do_all (agent types.force_last)
			text_internal := a_text.twin
			context_class := a_context_class
			assertion := a_assertion
		end

feature -- Access

	text: STRING is
			-- Text of Current predicate
			-- The arguments in of the predicates are replaced by "{1}", "{2}"
			-- in the text. For example: "{1}.valid_cursor ({2})"
		do
			Result := text_internal
		end

	assertion: AUT_ASSERTION
			-- Assertion associated with current predicates

feature -- Status report

	is_linear_solvable: BOOLEAN is
			-- Is current predicate linearly solvable?
		do
			Result := False
		ensure then
			good_result: Result = False
		end

feature{NONE} -- Implementation

	text_internal: like text;
			-- Implementation of `text'

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
