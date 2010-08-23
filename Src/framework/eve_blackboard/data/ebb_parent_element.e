note
	description: "Data element which has children."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_PARENT_ELEMENT [PARENT -> EBB_PARENT_ELEMENT [PARENT, CHILD], CHILD -> EBB_CHILD_ELEMENT [PARENT, CHILD]]

inherit

	EBB_DATA_ELEMENT

feature {NONE} -- Initialization

	make_parent
			-- Initialize parent.
		do
			create {LINKED_LIST [CHILD]} children.make
		end

feature -- Access

	children: attached LIST [CHILD]
			-- Children of this element.

feature -- Basic operations

	recalculate_correctness_confidence
			-- <Precursor>
		local
			l_accumulator: REAL
			l_count: INTEGER
		do
			if children.is_empty then
				correctness_confidence := 1
			else
				across children as l_cursor loop
					if l_cursor.item.has_correctness_confidence then
						l_accumulator := l_accumulator + l_cursor.item.correctness_confidence
						l_count := l_count + 1
					end
				end
				if l_count > 0 then
					correctness_confidence := (l_accumulator / l_count) --* (l_accumulator / children.count)
				else
					correctness_confidence := 1.0
				end
			end
		end

end
