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
		local
			l_attribute_name: STRING
		do
			l_attribute_name := name_translator.boogie_name_for_feature (a_feature, a_context_type)

				-- Add field declaration
			boogie_universe.add_declaration (
				create {IV_CONSTANT}.make_unique (
					l_attribute_name,
					types.field (types.for_type_in_context (a_feature.type, a_context_type))))

				-- Mark field as a ghost field
			boogie_universe.add_declaration (
				create {IV_AXIOM}.make (
					factory.function_call ("IsGhostField", << l_attribute_name >>, types.bool)))

				-- Add translation references
			translation_pool.add_type_in_context (a_feature.type, a_context_type)
		end

	translate_ghost_function (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate feature `a_feature' of `a_context_type' as a ghost function.
		require
			is_routine: a_feature.is_routine
			is_function: a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		do
			helper.set_up_byte_context (a_feature, a_context_type)

			if
				not attached Context.byte_code or else
				not attached Context.byte_code.compound or else
				not attached Context.byte_code.compound.count = 1 or else
				not attached {ASSIGN_B} Context.byte_code.compound.first as l_assign_b or else
				not attached {RESULT_B} l_assign_b.target
			then
					-- TODO: error message
			else
--				translate_expression (l_assign_b.source)
				check False end
			end
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
