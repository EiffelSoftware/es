note
	description: "Summary description for {E2B_SUCCESSFUL_VERIFICATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SUCCESSFUL_VERIFICATION_RESULT

inherit

	EBB_VERIFICATION_RESULT

create
	make

feature -- Access

	message: STRING = "Verified successfully"
			-- <Precursor>

end
