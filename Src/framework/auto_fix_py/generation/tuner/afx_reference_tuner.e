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

    last_tunes: DS_LINEAR [AFX_FIX_OPERATION_TUNNING]
    		-- <Precursor>
    	do
    	    Result := last_tunes_internal
    	end

feature -- Operations

    generate_tunes (a_target: AFX_FIXING_TARGET_I)
    		-- <Precursor>
    	local
		    l_feature: E_FEATURE
		    l_rep: STRING
		    l_type: TYPE_A
    	    l_tunes: like last_tunes_internal
    	    l_feature_table: FEATURE_TABLE
    	    l_creators: HASH_TABLE [EXPORT_I, STRING]
    	    l_next_feature: FEATURE_I
    	    l_next_e_feature: E_FEATURE
    	    l_next_feature_name: STRING
    	    l_context_type: TYPE_A
    	    l_tune: AFX_FIX_OPERATION_TUNNING
    	    l_tune_code: STRING
    	do
		    l_feature := a_target.context_feature
		    l_rep := a_target.representation
		    l_type := a_target.type

    	    l_tunes := last_tunes_internal
    	    if not l_tunes.is_empty then
	    	    l_tunes.wipe_out
    	    end

    	    l_context_type := l_feature.written_class.actual_type
    	    check l_type.associated_class.has_feature_table end
    	    l_feature_table := l_type.associated_class.feature_table
    	    l_creators := l_type.associated_class.creators

    	    from
    	        l_feature_table.start
    	    until
    	        l_feature_table.after
    	    loop
    	        l_next_feature := l_feature_table.item_for_iteration
    	        l_next_feature_name := l_next_feature.feature_name
    	        l_next_e_feature := l_next_feature.e_feature

    	        if
    	        			-- TODO: do we need to rule out creators?
--    	        		(l_creators /= Void implies not l_creators.has (l_next_feature_name)) and then
    	        		l_next_feature.export_status.is_exported_to (l_feature.written_class) and then
    	        		l_next_feature.argument_count = 0 and then
    	        		l_next_feature.type = void_type and then
    	        			-- to avoid recursive call
    	        		not (l_feature.same_as (l_next_e_feature)) then
    	        	l_tune_code := "if " + l_rep + " /= Void then " + l_rep + "." + l_next_feature_name + " end"
    	            create l_tune.make (l_tune_code)
    	            l_tunes.force_last (l_tune)
    	        end

    	        l_feature_table.forth
    	    end
    	end

feature -- Implementation

	last_tunes_internal: DS_ARRAYED_LIST [AFX_FIX_OPERATION_TUNNING]
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
