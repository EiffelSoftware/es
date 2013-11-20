note
	description: "[
		Translator for Eiffel attributes.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ATTRIBUTE_TRANSLATOR

inherit

	E2B_FEATURE_TRANSLATOR

feature -- Basic operations

	translate (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate feature `a_feature' of type `a_context_type'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_attribute_name: STRING
			l_fname: STRING
			l_call: IV_FUNCTION_CALL
			l_forall: IV_FORALL
			l_heap_access: IV_HEAP_ACCESS
			l_boogie_type: IV_TYPE
		do
			l_attribute_name := name_translator.boogie_name_for_feature (a_feature, a_context_type)
			l_boogie_type := types.for_type_in_context (a_feature.type, a_context_type)

				-- Add field declaration
			boogie_universe.add_declaration (
				create {IV_CONSTANT}.make_unique (
					l_attribute_name,
					types.field (l_boogie_type)))

				-- Mark field as a non-ghost field
			boogie_universe.add_declaration (
				create {IV_AXIOM}.make (
					factory.not_ (
						factory.function_call ("IsGhostField", << l_attribute_name >>, types.bool))))

				-- Add attribute-type specific properties
			if a_feature.type.is_reference and not l_boogie_type.is_set and not l_boogie_type.is_seq then
				if a_feature.type.is_attached then
					l_fname := "attached_attribute"
				else
					l_fname := "detachable_attribute"
				end
				l_call := factory.function_call (l_fname, << "heap", "o", l_attribute_name, factory.type_value (a_feature.type) >>, types.bool)
				create l_forall.make (l_call)
				l_forall.add_bound_variable ("heap", types.heap_type)
				l_forall.add_bound_variable ("o", types.ref)
				create l_heap_access.make ("heap", create {IV_ENTITY}.make ("o", types.ref), create {IV_ENTITY}.make (l_attribute_name, types.generic_type))
				l_forall.add_trigger (l_heap_access)
				boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
			end

				-- Add translation references
			translation_pool.add_type_in_context (a_feature.type, a_context_type)



				-- Map attribute slot to original attribute slot
--			if a_feature.written_in /= l_type.base_class.class_id then
--				create l_value1.make (l_boogie_name, types.field (types.for_type_a (l_type)))
--				create l_value2.make (name_translator.boogie_name_for_feature (a_feature, a_feature.written_class.actual_type), types.field (types.for_type_a (l_type)))
--				create l_op.make (l_value1, "==", l_value2, types.bool)
--				create l_axiom.make (l_op)
--				boogie_universe.add_declaration (l_axiom)
--				translation_pool.add_referenced_feature (a_feature, a_feature.written_class.actual_type)
--			end

--			elseif a_feature.type.is_integer or a_feature.type.is_natural then
--				create l_heap_access.make ("heap", create {IV_ENTITY}.make ("o", types.ref), create {IV_ENTITY}.make (l_boogie_name, l_constant.type))
--				create l_call.make ("is_" + a_feature.type.associated_class.name.as_lower, types.bool)
--				l_call.add_argument (l_heap_access)
--				create l_forall.make (l_call)
--				l_forall.add_bound_variable ("heap", types.heap_type)
--				l_forall.add_bound_variable ("o", types.ref)
--				create l_axiom.make (l_forall)
--				boogie_universe.add_declaration (l_axiom)
--			end
		end

end
