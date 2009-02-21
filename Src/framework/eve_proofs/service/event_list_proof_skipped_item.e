indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class EVENT_LIST_PROOF_SKIPPED_ITEM

inherit

	EVENT_LIST_PROOF_ITEM_I

create
	make

feature {NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I)
			-- TODO
		do
			initialize (a_class, a_feature)
			data := Void
			description := "Skipped"
		end

feature -- Access

	data: ANY
			-- <Precursor>

	description: STRING_32
			-- <Precursor>

end
