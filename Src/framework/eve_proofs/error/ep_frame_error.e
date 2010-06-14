indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FRAME_ERROR

inherit
	EP_ERROR
		rename
			make as make_with_message
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize frame error.
		do
			make_with_message (names.error_frame_violation)
			set_description (names.description_frame_violation)
		end

end
