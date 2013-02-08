note
	description: "Translator to generate Boogie code for attributes."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ATTRIBUTE_TRANSLATOR

inherit

	E2B_FEATURE_TRANSLATOR

feature -- Basic operations

	translate (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Translate feature `a_feature' of type `a_type'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_boogie_name: STRING
			l_constant: IV_CONSTANT
			l_axiom: IV_AXIOM
			l_call: IV_FUNCTION_CALL
			l_forall: IV_FORALL
			l_type: TYPE_A
			l_heap_access: IV_HEAP_ACCESS
			l_value1, l_value2: IV_VALUE
			l_op: IV_BINARY_OPERATION
		do

				-- Translation
			l_type := a_feature.type.instantiated_in (a_type)
			translation_pool.add_type (l_type)
			l_boogie_name := name_translator.boogie_name_for_feature (a_feature, a_type)
			create l_constant.make (l_boogie_name, types.field (types.for_type_a (l_type)))
			boogie_universe.add_declaration (l_constant)

				-- Map attribute slot to original attribute slot
			if a_feature.written_in /= l_type.base_class.class_id then
				create l_value1.make (l_boogie_name, types.field (types.for_type_a (l_type)))
				create l_value2.make (name_translator.boogie_name_for_feature (a_feature, a_feature.written_class.actual_type), types.field (types.for_type_a (l_type)))
				create l_op.make (l_value1, "==", l_value2, types.bool)
				create l_axiom.make (l_op)
				boogie_universe.add_declaration (l_axiom)
				translation_pool.add_referenced_feature (a_feature, a_feature.written_class.actual_type)
			end

			if a_feature.type.is_reference then
				if a_feature.type.is_attached then
					create l_call.make ("attached_attribute", types.bool)
				else
					create l_call.make ("detachable_attribute", types.bool)
				end

				l_call.add_argument (create {IV_ENTITY}.make ("heap", types.heap_type))
				l_call.add_argument (create {IV_ENTITY}.make ("o", types.ref))
				l_call.add_argument (create {IV_ENTITY}.make (l_boogie_name, l_constant.type))
				l_call.add_argument (factory.type_value (a_feature.type))

				create l_forall.make (l_call)
				l_forall.add_bound_variable ("heap", types.heap_type)
				l_forall.add_bound_variable ("o", types.ref)

				create l_axiom.make (l_forall)
				boogie_universe.add_declaration (l_axiom)
			elseif a_feature.type.is_integer or a_feature.type.is_natural then
				create l_heap_access.make ("heap", create {IV_ENTITY}.make ("o", types.ref), create {IV_ENTITY}.make (l_boogie_name, l_constant.type))
				create l_call.make ("is_" + a_feature.type.associated_class.name.as_lower, types.bool)
				l_call.add_argument (l_heap_access)
				create l_forall.make (l_call)
				l_forall.add_bound_variable ("heap", types.heap_type)
				l_forall.add_bound_variable ("o", types.ref)
				create l_axiom.make (l_forall)
				boogie_universe.add_declaration (l_axiom)
			end
		end

end
