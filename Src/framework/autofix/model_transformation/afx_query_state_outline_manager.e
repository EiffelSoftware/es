note
	description: "Summary description for {AFX_QUERY_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_STATE_OUTLINE_MANAGER

inherit
    DS_HASH_TABLE [AFX_QUERY_STATE_OUTLINE, INTEGER]
    	rename
    	    found_item as found_outline,
    	    has as is_registered
    	end

create
    make, make_default

feature -- Query

	class_outline (a_class: CLASS_C): AFX_QUERY_STATE_OUTLINE
			-- Query the query state outline for `a_class'.
		require
		    registered: is_registered (a_class.class_id)
		do
		    Result := value (a_class.class_id)
		    check Result /= Void end
		end

feature -- Register

	register (a_state: AFX_QUERY_MODEL_STATE)
			-- Register the query model state of `a_state'.
			-- Either a new outline would be created for its class, or existing outline would be updated.
		local
		    l_state: EPA_STATE
		    l_class: CLASS_C
		    l_id: INTEGER
		do
		    from a_state.start
		    until a_state.after
		    loop
		        l_state := a_state.item_for_iteration

		        if not l_state.is_chaos then
		            l_class := l_state.class_
		            l_id := l_class.class_id
        		    if is_registered (l_id) then
        		        value (l_id).accommodate (l_state)
        		    else
        		        register_new (l_state)
        		    end
		        end

		        a_state.forth
		    end
		end

feature{NONE} --Implementation

	register_new (a_state: EPA_STATE)
			-- Register `a_state' as from an unregistered class.
		require
		    not_registered: not is_registered (a_state.class_.class_id)
		local
		    l_outline: like found_outline
		do
		    create l_outline.make_for_state (a_state)
		    force (l_outline, a_state.class_.class_id)
		ensure
		    registered: is_registered (a_state.class_.class_id)
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
