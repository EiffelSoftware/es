note
	description: "[
		Translator for ghost features.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_GHOST_TRANSLATOR

inherit

	E2B_FEATURE_TRANSLATOR

feature -- Basic operations

	translate_ghost_attribute (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate ghost attribute `a_feature' of `a_context_type' as a ghost attribute.
		require
			is_attribute: a_feature.is_attribute
			is_ghost: helper.is_ghost (a_feature)
		do
			check False end
		end

	translate_ghost_function (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate feature `a_feature' of `a_context_type' as a ghost function.
		require
			is_routine: a_feature.is_routine
			is_function: a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		do
			check False end
		end

	translate_ghost_routine_signature (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate signature of ghost routine `a_feature' of `a_context_type'.
		require
			is_routine: a_feature.is_routine
			not_function: not a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		do
			check False end
		end

	translate_ghost_routine_implementation (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate signature of ghost routine `a_feature' of `a_context_type'.
		require
			is_routine: a_feature.is_routine
			not_function: not a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		do
			check False end
		end

end
