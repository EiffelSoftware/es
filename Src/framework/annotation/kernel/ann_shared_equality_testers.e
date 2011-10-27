note
	description: "Shared equality testers for annotation related classes"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_SHARED_EQUALITY_TESTERS

feature -- Access

	annotation_equality_tester: ANN_ANNOTATION_EQUALITY_TESTER [ANN_ANNOTATION]
			-- Equality tester for annotations
		once
			create Result
		end

	mention_annotation_equality_tester: ANN_ANNOTATION_EQUALITY_TESTER [ANN_MENTION_ANNOTATION]
			-- Equality tester for mention annotations
		once
			create Result
		end

end
