note
	description: "Annotation visitor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ANN_ANNOTATION_VISITOR

feature -- Process

	process_state_annotation (a_annotation: ANN_STATE_ANNOTATION)
			-- Process `a_annotation'.
		deferred
		end
		
end
