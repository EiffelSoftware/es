note
	description: "Class which infers contracts from given data"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		deferred
		end

end
