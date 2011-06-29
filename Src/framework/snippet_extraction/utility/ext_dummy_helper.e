note
	description: "Summary description for {EXT_DUMMY_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_DUMMY_HELPER

feature -- Basic operations

	snippets_from_feature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_target_variable_type: TYPE_A): LINKED_LIST [EXT_SNIPPET]
			-- Snippets extracted from `a_feature' in `a_context_class'
			-- with target variable of `a_target_variable_type'.
		local
			l_extractor: EXT_SNIPPET_EXTRACTOR
		do
			create l_extractor.make
			l_extractor.extract_from_feature (a_target_variable_type, a_feature, a_context_class, "source")
			create Result.make
			l_extractor.last_snippets.do_all (agent Result.extend)
		end

end
