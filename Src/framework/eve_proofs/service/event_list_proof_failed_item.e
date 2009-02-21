indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class EVENT_LIST_PROOF_FAILED_ITEM

inherit

	EVENT_LIST_PROOF_ITEM_I

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_error: EP_ERROR)
			-- TODO
		do
			initialize (a_class, a_feature)
			data := a_error
			error := a_error
			description := a_error.description
		end

feature -- Access

	data: ANY
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

	error: EP_ERROR
			-- Data as error

end
