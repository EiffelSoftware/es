note
	description: "Summary description for {AUT_TEST_CASE_CATEGORIZER_BY_FEATURE_UNDER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_CATEGORIZER_BY_FEATURE_UNDER_TEST

inherit
	AUT_TEST_CASE_CATEGORIZER
		redefine
			on_deserialization_started,
			on_deserialization_finished
		end

create
	make

feature -- Data event handler

	on_deserialization_started
			-- <Precursor>
		do
			-- Do nothing.
		end

	on_test_case_deserialized (a_data: AUT_DESERIALIZED_TEST_CASE)
			-- <Precursor>
		local
			l_categories: DS_ARRAYED_LIST [STRING]
		do
			if not a_data.test_case_text.is_empty then
				l_categories := categorize (a_data)
				write_test_case (a_data, l_categories)
			end
		end

	on_deserialization_finished
			-- <Precursor>
		do
			-- Do nothing.
		end

feature -- Basic operation

	categorize (a_data: AUT_DESERIALIZED_TEST_CASE): DS_ARRAYED_LIST [STRING]
			-- <Precursor>
		do
			create Result.make (2)
			Result.force_last (a_data.tc_class_under_test)
			Result.force_last (a_data.tc_feature_under_test)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
