note
	description: "Summary description for {AUT_RESULT_ANALYSIS_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_RESULT_ANALYSIS_UTILITY

inherit
	ERL_G_TYPE_ROUTINES

feature -- Access

	feature_under_test (a_witness: AUT_ABS_WITNESS): AUT_FEATURE_OF_TYPE is
			-- Feature under test in `a_witness' in `a_system'
		local
			l_test_case: AUT_TEST_CASE_RESULT
		do
			l_test_case := a_witness.classifications.last
			create Result.make (l_test_case.feature_, l_test_case.class_.actual_type)
		end

	features_with_non_trivial_precondition (a_classes: LIST [CLASS_C]; a_system: SYSTEM_I): DS_HASH_SET [AUT_FEATURE_OF_TYPE] is
			-- Features from `a_classes' which have non-trivial preconditions (preocnditions stronger than True)
		local
			l_feat_table: FEATURE_TABLE
			l_feature_i: FEATURE_I
			l_any_class: CLASS_C
			l_cursor: CURSOR
		do
			create Result.make (100)
			Result.set_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)

			l_any_class := a_system.any_class.compiled_class
			from
				a_classes.start
			until
				a_classes.after
			loop
				l_feat_table := a_classes.item.feature_table
				l_cursor := l_feat_table.cursor
				from
					l_feat_table.start
				until
					l_feat_table.after
				loop
					l_feature_i := l_feat_table.item_for_iteration
					if
						(not l_feature_i.is_prefix and then not l_feature_i.is_infix) and then
						(l_feature_i.export_status.is_exported_to (l_any_class) or else
						 is_exported_creator (l_feature_i, a_classes.item.actual_type)) and then
						 l_feature_i.has_precondition and then
						 (l_feature_i.written_class /= l_any_class)
					then
						Result.force_last (create {AUT_FEATURE_OF_TYPE}.make (l_feature_i, a_classes.item.actual_type))
					end
					l_feat_table.forth
				end
				l_feat_table.go_to (l_cursor)
				a_classes.forth
			end
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
