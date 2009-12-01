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
    make_default

feature -- statur report

	class_outline (a_class: CLASS_C): AFX_QUERY_STATE_OUTLINE
			-- query the state outline for `a_class'
		require
		    registered: is_registered (a_class.class_id)
		do
--		    search (a_class.class_id)
--		    check found_outline /= Void end
		    Result := item (a_class.class_id)
		    check Result /= Void end
		end

--	last_outline: AFX_STATE_OUTLINE
--			-- last outline

--	projection_types: DS_HASH_SET [TYPE_A]
--			-- the set of types, onto which we will project our model

feature -- operations

--	register_extractor (an_extractor: AFX_STATE_OUTLINE_EXTRACTOR)
--			-- register an extractor at this manager
--		require
--		    not_registered: not is_registered (an_extractor)
--		local
--		    l_table: DS_HASH_TABLE [AFX_STATE_OUTLINE, INTEGER]
--		do
--		    create l_table.make_default
--		    put (l_table, an_extractor)
--		ensure
--		    registered: is_registered (an_extractor)
--		end

--	class_outline (an_extractor: AFX_STATE_OUTLINE_EXTRACTOR; a_class: CLASS_C): like last_outline
--			-- query for the outline of `a_class', extracted by using `an_extractor'
--		require
--		    extractor_registered: is_registered (an_extractor)
--		local
--		    l_found: BOOLEAN
--		    l_outline: like last_outline
--		    l_id: INTEGER
--		do
--		    l_id := a_class.class_id
--		    search (an_extractor)
--		    check found_outline /= Void end
--		    if not found_outline.has (l_id) then
--		        l_outline := an_extractor.extract_class_outline (a_class)
--		        found_outline.put (l_outline, l_id)
--		        last_outline := l_outline
--		    else
--		        found_outline.search (l_id)
--		        last_outline := found_outline.found_item
--		    end
--		ensure
--			outline_ready: last_outline /= Void
--		end

	register (a_state: AFX_QUERY_MODEL_STATE)
			-- register/update the outline for each component `AFX_STATE'
		local
		    l_state: AFX_STATE
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
        		        item (l_id).accommodate (l_state)
        		    else
        		        register_new (l_state)
        		    end
		        end

		        a_state.forth
		    end
		end

feature{NONE} --implementation

	register_new (a_state: AFX_STATE)
			-- register an outline for `a_state'
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
