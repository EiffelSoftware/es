note
	description: "Equality testers for the snippet extraction library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SHARED_EQUALITY_TESTERS

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	mention_annotation_equality_tester: ANN_ANNOTATION_EQUALITY_TESTER [EXT_MENTION_ANNOTATION]
			-- Equality tester for mention annotations
		once
			create Result
		end

end
