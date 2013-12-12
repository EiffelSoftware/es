note
	description: "[
		Byte node visitor to collect which ghost sets are mentioned in a byte node structure.
		Only collects ghost sets accessed on the Current object.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_READS_COLLECTOR

inherit

	BYTE_NODE_ITERATOR
		redefine
			process_feature_b,
			process_nested_b
		end

	SHARED_NAMES_HEAP

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize reads set collector.
		do
			create reads_set_parts.make
			reads_set := Void
		end

feature -- Access

	reads_set_parts: LINKED_LIST [IV_EXPRESSION]
			-- List of individual reads set elements.

	reads_set: IV_EXPRESSION
			-- Reads set expression.

feature -- Processing

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		do


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
