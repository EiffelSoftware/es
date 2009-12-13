note
	description: "Summary description for {AFX_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX

feature -- Access

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception related information

	text: STRING
			-- Text of the feature body containing current fix

feature -- Setting

	set_text (a_text: STRING)
			-- Set `text' with `a_text'.
		do
			text := a_text.twin
		end

	set_exception_spot (a_spot: like exception_spot)
			-- Set `exception_spot' with `a_spot'.
		do
			exception_spot := a_spot
		end

end
