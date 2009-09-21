note
	description: "Summary description for {AUT_INVALID_WITNESS_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_INVALID_WITNESS_OBSERVER

inherit
	AUT_WITNESS_OBSERVER

create
	make

feature{NONE} -- Initialization

	make (a_system: like system) is
			-- Initialize `system' with `a_system'.
		do
			system := a_system
			create witnesses.make (100)
			create tested_features.make (100)
			tested_features.set_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			witnesses.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
		end

feature -- Access

	witnesses: DS_HASH_TABLE [LIST [AUT_WITNESS], AUT_FEATURE_OF_TYPE]
			-- Table of all invalid witnesses
			-- Key is feature under test, value is a list of invalid
			-- witnesses for that feature
			-- Only features that are not tested AT ALL are listed here.

	failed_assertions: DS_HASH_TABLE [HASH_TABLE [INTEGER, STRING], AUT_FEATURE_OF_TYPE] is
			-- Table of failed assertions for features
			-- Key is the feature under test. Value is a hashtable, key of that hashtable is
			-- tag name of the failing assertion, value of that hashtable is the number of times
			-- that the assertion failed.
		local
			l_witnesses: like witnesses
			l_witness: AUT_WITNESS
			l_list: LIST [AUT_WITNESS]
			l_tbl: HASH_TABLE [INTEGER, STRING]
			l_failed_tag: STRING
		do
			create Result.make (10)
			Result.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			l_witnesses := witnesses
			from
				l_witnesses.start
			until
				l_witnesses.after
			loop
				l_list := l_witnesses.item_for_iteration
				create l_tbl.make (2)
				l_tbl.compare_objects
				from
					l_list.start
				until
					l_list.after
				loop
					l_witness := l_list.item
					l_failed_tag := failed_tag_name (l_witness)
					if l_tbl.has (l_failed_tag) then
						l_tbl.force (l_tbl.item (l_failed_tag) + 1, l_failed_tag)
					else
						l_tbl.force (1, l_failed_tag)
					end
					l_list.forth
				end
				Result.force_last (l_tbl, l_witnesses.key_for_iteration)
				l_witnesses.forth
			end
		end

	failed_tag_name (a_witness: AUT_WITNESS): STRING is
			-- Name of the failed assertion in `a_witness'
		require
			a_witness_is_invalid: a_witness.is_invalid
		do
			if attached {AUT_NORMAL_RESPONSE} a_witness.item (a_witness.count).response as l_response then
				check l_response.exception /= Void end
				Result := l_response.exception.tag_name
				if Result = Void or else Result.is_empty then
					Result := "no_name"
				end
			else
				check False end
			end
		ensure
			result_not_is_empty: not Result.is_empty
		end

feature -- handler

	process_witness (a_witness: AUT_WITNESS) is
			-- Handle `a_witness'.
		local
			l_feature: AUT_FEATURE_OF_TYPE
			l_list: LIST [AUT_WITNESS]
		do
			l_feature := feature_under_test (a_witness)
			if a_witness.is_invalid or a_witness.is_bad_response then
				if not tested_features.has (l_feature) then
					if witnesses.has (l_feature) then
						l_list := witnesses.item (l_feature)
					else
						create {LINKED_LIST [AUT_WITNESS]} l_list.make
						witnesses.force (l_list, l_feature)
					end
					l_list.extend (a_witness)
				end
			else
				tested_features.force_last (l_feature)
				witnesses.remove (l_feature)
			end
		end

feature{NONE} -- Implementation

	system: SYSTEM_I
			-- System under which the tests were performed

	tested_features: DS_HASH_SET [AUT_FEATURE_OF_TYPE]
			-- List of features that have been tested

invariant

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
