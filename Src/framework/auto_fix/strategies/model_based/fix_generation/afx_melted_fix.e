note
	description: "Summary description for {AFX_MELTED_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MELTED_FIX

create
	make

feature{NONE} -- Initialization

	make (a_id: INTEGER; a_body_id: INTEGER; a_pattern_id: INTEGER; a_byte_code: STRING; a_bpslots: INTEGER)
			-- Initialize Current.
		do
			id := a_id
			feature_body_id := a_body_id
			feature_pattern_id := a_pattern_id
			feature_byte_code := a_byte_code.twin
			number_of_break_point_slot := a_bpslots
		end

feature -- Access

	id: INTEGER
			-- Fix ID

	feature_body_id: INTEGER
			-- Body ID of the feature to be melted

	feature_pattern_id: INTEGER
			-- Pattern ID of the feature to be melted

	feature_byte_code: STRING
			-- Byte code of the feature to be melted

	number_of_break_point_slot: INTEGER
			-- Number of break point slots in `feature_byte_code'


end
