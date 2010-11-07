note
	description: "Class to collect online test data"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ONLINE_STATISTICS

inherit
	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create passing_statistics.make (100)
			passing_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			create failing_statistics.make (100)
			failing_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			create faults.make (64)
			faults.set_equality_tester (create {AUT_EXCEPTION_EQUALITY_TESTER})
		end

feature -- Access

	passing_statistics: DS_HASH_TABLE [INTEGER, AUT_FEATURE_OF_TYPE]
			-- Statistic for passing test cases
			-- Key is the feature under test, value is the number
			-- of passing test cases of that feature

	failing_statistics: DS_HASH_TABLE [INTEGER, AUT_FEATURE_OF_TYPE]
			-- Statistic for failing test cases
			-- Key is the feature under test, value is the number
			-- of failing test cases of that feature

	faults: DS_HASH_SET [AUT_EXCEPTION]
			-- Set of found faults

feature -- Basic operations

	add_test_case (a_request: AUT_REQUEST)
			-- Add test case `a_request' into Current.
		local
			l_feature: AUT_FEATURE_OF_TYPE
			l_exception: AUT_EXCEPTION
			l_type: TYPE_A
			l_feat: FEATURE_I
			l_class: CLASS_C
		do
			if attached {AUT_CALL_BASED_REQUEST} a_request as l_request then
				create l_feature.make (l_request.feature_to_call, l_request.target_type)
				if l_request.response.is_normal then
					if l_request.response.is_exception then
						if attached {AUT_NORMAL_RESPONSE} l_request.response as l_normal_response and then l_normal_response.exception /= Void and then not l_normal_response.is_precondition_violation then
							l_exception := l_normal_response.exception
							if not l_exception.is_invariant_violation_on_feature_entry then
								l_class := workbench.universe.classes_with_name (l_exception.class_name).first.compiled_representation
								l_feat := l_class.feature_named_32 (l_exception.recipient_name)
								if l_feature /= Void then
									faults.force_last (l_exception)
									create l_feature.make (l_feat, l_class.constraint_actual_type)
									failing_statistics.search (l_feature)
									if failing_statistics.found then
										failing_statistics.replace (failing_statistics.found_item + 1, l_feature)
									else
										failing_statistics.force_last (1, l_feature)
									end
								end
							end
						end
					else
						passing_statistics.search (l_feature)
						if passing_statistics.found then
							passing_statistics.replace (passing_statistics.found_item + 1, l_feature)
						else
							passing_statistics.force_last (1, l_feature)
						end
					end
				end
			end
		end

;note
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
