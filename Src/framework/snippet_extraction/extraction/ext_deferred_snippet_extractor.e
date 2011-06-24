note
	description: "Interface for snippet extraction entry point."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_DEFERRED_SNIPPET_EXTRACTOR

feature -- Access

	last_snippets: LINKED_SET [EXT_SNIPPET]
			-- Snippets that are extracted by last `extract_from_feature'
		deferred
		end

feature -- Basic operations

	extract_from_feature (a_type: TYPE_A; a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Extract snippet for relevant target of type `a_type' from
			-- `a_feature' viewed in `a_context_class'.
			-- Make results available in `last_snippets'.
		require
			a_type_not_void: attached a_type
			a_feature_not_void: attached a_feature
			a_context_class_not_void: attached a_context_class
		deferred
		ensure
			last_snippets_not_void: attached last_snippets
		end

end
