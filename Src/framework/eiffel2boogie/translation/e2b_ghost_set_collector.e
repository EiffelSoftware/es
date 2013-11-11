note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_GHOST_SET_COLLECTOR

inherit

	BYTE_NODE_ITERATOR
		redefine
			process_feature_b
		end

	SHARED_NAMES_HEAP

feature -- Status report

	has_observers: BOOLEAN
	has_subjects: BOOLEAN
	has_owns: BOOLEAN

feature -- Processing

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		do
			Precursor (a_node)
			if names_heap.item_32 (a_node.feature_name_id) ~ "observers" then
				has_observers := True
			elseif names_heap.item_32 (a_node.feature_name_id) ~ "subjects" then
				has_subjects := True
			elseif names_heap.item_32 (a_node.feature_name_id) ~ "owns" then
				has_owns := True
			end
		end

end
