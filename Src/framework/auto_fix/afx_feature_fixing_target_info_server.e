note
	description: "Summary description for {AFX_FEATURE_FIXING_TARGET_INFO_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_FIXING_TARGET_INFO_SERVER

create
    make

feature

    make
    		-- initialize a new object
    	do
    	    create feature_fixing_target_info_storage.make_default
    	end

feature -- Operation

	fixing_target_info (a_feature: E_FEATURE): detachable AFX_FEATURE_FIXING_TARGET_INFO
			-- retrieve the fixing target info about `a_feature'
		local
		    l_storage: like feature_fixing_target_info_storage
		    l_info: AFX_FEATURE_FIXING_TARGET_INFO
		    i: INTEGER
		do
			l_storage := feature_fixing_target_info_storage
			check l_storage /= Void end

			from i := 1
			until i > l_storage.count or Result /= Void
			loop
			    l_info := l_storage.at (i)
			    if l_info.context_feature.same_as (a_feature) then
					Result := l_info
			    end
			    i := i + 1
			end

			if Result = Void then
				Result := resolve_fixing_target_info (a_feature)
				cache_fixing_target_info (Result)
			end
		end


feature{NONE} -- Implementation

	resolve_fixing_target_info (a_feature: E_FEATURE): detachable AFX_FEATURE_FIXING_TARGET_INFO
			-- resolve the fixing target info for `a_feature'
		local
		    l_collector: AFX_FIXING_TARGET_COLLECTOR_FUNDAMENTAL
		do
		    create l_collector
		    l_collector.collect_fixing_targets (a_feature, Void)

		    create Result.make (a_feature,
                    	l_collector.object_test_variable_collection,
                    	l_collector.local_variable_collection,
                    	l_collector.argument_collection,
                    	l_collector.attribute_collection)
		end

	cache_fixing_target_info (an_info: AFX_FEATURE_FIXING_TARGET_INFO)
			-- put the info into storage
		do
		    feature_fixing_target_info_storage.force_last (an_info)
		end


feature{NONE} -- Access

	feature_fixing_target_info_storage: DS_ARRAYED_LIST [AFX_FEATURE_FIXING_TARGET_INFO]
			-- internal storage for cached info

	last_found_index: INTEGER
			-- index of last found info

;note
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
