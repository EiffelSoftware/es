note
	description: "Summary description for {AFX_REAL_NUMBER_TUNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_REAL_NUMBER_TUNER

inherit
	AFX_OBJECT_TUNER

create
    make

feature -- Initialization

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
    	    l_insertion: AFX_FIX_OPERATION_INSERTION
    	do
    	    l_tunes := last_tunes_internal
    	    if not l_tunes.is_empty then
	    	    l_tunes.wipe_out
    	    end

			create l_insertion.make (an_obj_name + " := " + an_obj_name + " + 1 ")
			l_tunes.force_last (l_insertion)

			create l_insertion.make (an_obj_name + " := " + an_obj_name + " - 1 ")
			l_tunes.force_last (l_insertion)

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
