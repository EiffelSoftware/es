note
	description: "Error model of a failed verification."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ERROR_MODEL

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize error model.
		do
			create partitions.make
			create function_interpretations.make
		end

feature -- Access

	partitions: LINKED_LIST [TUPLE [id: INTEGER; value: STRING]]
			-- List of partitions.

	function_interpretations: LINKED_LIST [TUPLE [function, value: STRING]]
			-- List of function interpretations.

end
