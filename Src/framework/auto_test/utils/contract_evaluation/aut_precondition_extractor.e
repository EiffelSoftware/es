note
	description: "Summary description for {AUT_PRECONDITION_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_EXTRACTOR

inherit
	AUT_CONTRACT_EXTRACTOR

	SHARED_WORKBENCH

	SHARED_SERVER

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create preconditions.make (2)
			create {DS_LINKED_LIST [FUNCTION [ANY, TUPLE [AUT_EXPRESSION], BOOLEAN]]} veto_assertion_functions.make

			veto_assertion_functions.force_last (agent is_assertion_non_trivial)
		end

feature -- Access

	preconditions: DS_HASH_TABLE [DS_LIST [AUT_EXPRESSION], AUT_FEATURE_OF_TYPE]
			-- Preconditions extracted by last `extract_preconditions'
			-- Key is feature, value is a list of assertions of that feature.

	veto_assertion_functions: DS_LIST [FUNCTION [ANY, TUPLE [AUT_EXPRESSION], BOOLEAN]]
			-- Function to veto an assertion from being extracted.
			-- An assertion will be extracted if all veto functions return True.
			-- If no function is available, an assertion will always be extracted.

feature -- Basic operations

	wipe_out is
			-- Wipe out `last_preconditions'.
		do
			create preconditions.make (2)
		ensure
			last_preconditions_is_empty: preconditions.is_empty
		end

	extract_precondition (a_feature: AUT_FEATURE_OF_TYPE)
			-- Extract preconditions from `a_feature' and
			-- store result in `preconditions'.
		local
			l_asserts: LIST [AUT_EXPRESSION]
			l_veto: FUNCTION [ANY, TUPLE [AUT_EXPRESSION], BOOLEAN]
			l_assert_list: DS_LINKED_LIST [AUT_EXPRESSION]
		do
			l_veto := agent actual_veto_assertion_function
			l_asserts := precondition_of_feature (a_feature.feature_, a_feature.type.associated_class)
			create l_assert_list.make
			from
				l_asserts.start
			until
				l_asserts.after
			loop
				if l_veto.item ([l_asserts.item]) then
					l_assert_list.force_last (l_asserts.item)
				end
				l_asserts.forth
			end
			preconditions.force_last (l_assert_list, a_feature)
		end

	extract_preconditions (a_features: DS_LINKED_LIST [AUT_FEATURE_OF_TYPE])
			-- Extract preconditions from every feature in `a_features' and
			-- store result in `preconditions'.
		do
			a_features.do_all (agent extract_precondition)
		end

feature{NONE} -- Implementation

	actual_veto_assertion_function (a_assertion: AUT_EXPRESSION): BOOLEAN is
			-- Actual veto assertion function, take all functions in
			-- `veto_assertion_functions' into consideration.
		local
			l_vetos: like veto_assertion_functions
			l_cursor: DS_LIST_CURSOR [FUNCTION [ANY, TUPLE [AUT_EXPRESSION], BOOLEAN]]
		do
			l_vetos := veto_assertion_functions
			Result := True
			if not l_vetos.is_empty then
				from
					l_cursor := l_vetos.new_cursor
					l_cursor.start
				until
					l_cursor.after or else not Result
				loop
					Result := l_cursor.item.item ([a_assertion])
					l_cursor.forth
				end
			end
		end

	is_assertion_non_trivial (a_assertion: AUT_EXPRESSION): BOOLEAN is
			-- Is `a_assertion' a non-trivial one?
			-- "True" is considered as a trivial assertion.
		local
			l_text: STRING
		do
			l_text := a_assertion.text
			l_text.to_lower
			l_text.left_adjust
			l_text.right_adjust
			Result := not l_text.is_equal ("true")
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
