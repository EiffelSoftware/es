note
	description: "Common features for both TREE_BUILDER and TREE_FILTER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_EBBRO_TREE_FACILITY

feature -- operations

	check_parent(a_addr:STRING;a_row:EV_GRID_ROW):BOOLEAN
			-- checks whether its is a cyclic reference or not
		local
			l_par:EV_GRID_ROW
			l_tuple:TUPLE[ANY,ARRAY[INTEGER]]
			l_disp:ANY
		do
			l_par := a_row.parent_row
			if l_par /= void then
				l_tuple ?= l_par.data
				l_disp ?= l_tuple.reference_item (1)
				if object_addr_from_tagged_out(l_disp.tagged_out).is_equal (a_addr) then
					result := true
					found_parent := l_par
				else
					result := check_parent(a_addr,l_par)
				end
			else
				result := false
			end
		end


	object_addr_from_tagged_out(str:STRING):STRING 
			-- parses out of default "out" the object address of an display object
		local
			left,right:INTEGER
		do
			if str.count > 6 then
				left := str.index_of ('[',1)
				right := str.index_of (']',left)
				if str.item (left+1).is_equal ('0') then
					result := str.substring (left+1, right-1)
				else
					result := object_addr_from_tagged_out (str.substring (left+1, str.count-1))
				end
			else
				create result.make_empty
			end
		end

feature -- access

	found_parent:EV_GRID_ROW
			-- parent which was found in a recursive match

	global_root_object_count:INTEGER_REF
			--
		once
			create result
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
