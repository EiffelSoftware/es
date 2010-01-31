note
	description: "Summary description for {AFX_MELT_FEATURE_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MELT_FEATURE_REQUEST

inherit
	AFX_INTERPRETER_REQUEST

create
	make

feature{NONE} -- Initialization

	make (a_body_id: INTEGER; a_pattern_id: INTEGER; a_byte_code: STRING; a_fix_signature: STRING)
			-- Initialize Current.
		require
			a_byte_code_attached: a_byte_code /= Void
		do
			body_id := a_body_id
			pattern_id := a_pattern_id
			byte_code := a_byte_code.twin
			fix_signature := a_fix_signature.twin
		end

feature -- Access

	body_id: INTEGER
			-- Body ID of the feature to be melted

	pattern_id: INTEGER
			-- Pattern ID of the feature to be melted

	byte_code: STRING
			-- String containing the byte code of the feature to be melted

	fix_signature: STRING
			-- Fix signature

end
