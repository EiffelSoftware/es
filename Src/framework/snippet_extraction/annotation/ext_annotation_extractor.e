note
	description: "Class to extract annotations from snippets"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_ANNOTATION_EXTRACTOR [G -> ANN_ANNOTATION]

feature -- Access

	last_annotations: DS_HASH_SET [G]
			-- Annotations extracted by last `extract'

feature -- Basic operations

	extract_from_ast (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
			-- The default implementation is empty because
			-- `extract_from_snippet' is the preferred way
			-- to extract snippets and `extract_from_ast'
			-- is not mandatory to be supported from
			-- descendants of `{EXT_ANNOTATION_EXTRACTOR}'.
		do
		end

	extract_from_snippet (a_snippet: EXT_SNIPPET)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		deferred
		end

end
