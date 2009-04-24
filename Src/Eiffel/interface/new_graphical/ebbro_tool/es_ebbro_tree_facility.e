indexing
	description: "Common features for both TREE_BUILDER and TREE_FILTER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_EBBRO_TREE_FACILITY

feature -- operations

	check_parent(a_addr:STRING;a_row:EV_GRID_ROW):BOOLEAN is
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


	object_addr_from_tagged_out(str:STRING):STRING is
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

end
