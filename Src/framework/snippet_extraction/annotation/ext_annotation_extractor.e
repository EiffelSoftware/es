note
	description: "Class to extract annotations from snippets"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_ANNOTATION_EXTRACTOR [G -> ANN_ANNOTATION]

feature -- Access

	last_annotations: LINKED_LIST [G]
			-- Annotations extracted by last `extract'

feature -- Basic operations

	extract (a_snippet: EXT_SNIPPET)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		deferred
		end

end
