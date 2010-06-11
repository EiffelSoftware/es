note
	description: "[
		Inferrer to infer composite frame properties, such as
		forall o. old l.has (o) and s.has (o) implies Result.has (o)
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_COMPOSITE_FRAME_PROPERTY_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
			transition_data := a_data
			setup_data_structures
		end

end
