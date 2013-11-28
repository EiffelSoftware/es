note
	description: "[
		Byte node visitor to collect which ghost sets are mentioned in a byte node structure.
		Only collects ghost sets accessed on the Current object.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_GHOST_SET_COLLECTOR

inherit

	BYTE_NODE_ITERATOR
		redefine
			process_feature_b,
			process_nested_b
		end

	SHARED_NAMES_HEAP

feature -- Status report

	has_observers: BOOLEAN
			-- Is the `observers' set mentioned?

	has_subjects: BOOLEAN
			-- Is the `subjects' set mentioned?

	has_owns: BOOLEAN
			-- Is the `owns' set mentioned?

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

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		do
			if attached {CURRENT_B} a_node.target then
				a_node.message.process (Current)
			else
				a_node.target.process (Current)
					-- It is deliberte to not follow the "message" part.
					-- Only ghost sets on "Current" are to be considered.
			end
		end

end
