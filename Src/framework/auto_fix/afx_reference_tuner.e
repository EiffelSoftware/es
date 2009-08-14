note
	description: "Summary description for {AFX_REFERENCE_TUNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_REFERENCE_TUNER

inherit
	AFX_OBJECT_TUNER

	SHARED_TYPES

create
    make

feature

    make
    		-- initialize
    	do
    	    create last_tunes_internal.make_default
    	end

feature -- Access

    last_tunes: DS_LINEAR [AFX_FIX_OPERATION_INSERTION]
    		-- <Precursor>
    	do
    	    Result := last_tunes_internal
    	end

feature -- Operations

    generate_tunes (an_obj_name: STRING; an_obj_type: TYPE_A; a_context_feature: E_FEATURE)
    		-- <Precursor>
    	local
    	    l_tunes: like last_tunes_internal
    	    l_feature_table: FEATURE_TABLE
    	    l_creators: HASH_TABLE [EXPORT_I, STRING]
    	    l_next_feature: FEATURE_I
    	    l_context_type: TYPE_A
    	    l_insertion: AFX_FIX_OPERATION_INSERTION
    	do
    	    l_tunes := last_tunes_internal
    	    if not l_tunes.is_empty then
	    	    l_tunes.wipe_out
    	    end

    	    l_context_type := a_context_feature.associated_class.actual_type
    	    l_feature_table := an_obj_type.associated_class.feature_table
    	    l_creators := an_obj_type.associated_class.creators

    	    from
    	        l_feature_table.start
    	    until
    	        l_feature_table.after
    	    loop
    	        l_next_feature := l_feature_table.item_for_iteration

    	        if (l_creators /= Void implies not l_creators.has (l_next_feature.feature_name))
    	        		and then l_next_feature.export_status.is_exported_to (a_context_feature.associated_class)
    	        		and then l_next_feature.argument_count = 0
    	        		and then l_next_feature.type = void_type
    	        		and then not (equal(l_context_type, an_obj_type) and equal (a_context_feature.name, l_next_feature.feature_name)) then
    	            create l_insertion.make (an_obj_name + "." + l_next_feature.feature_name)
    	            l_tunes.force_last (l_insertion)
    	        end

    	        l_feature_table.forth
    	    end
    	end

feature -- Implementation

	last_tunes_internal: DS_ARRAYED_LIST [AFX_FIX_OPERATION_INSERTION]
			-- internal storage for `last_tunes'


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
