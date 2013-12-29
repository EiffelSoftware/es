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

	COMPILER_EXPORTER

feature -- Basic operations

	translate (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate feature `a_feature' of type `a_context_type'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_attribute_name, l_old_name: STRING
			l_fname: STRING
			l_call: IV_FUNCTION_CALL
			l_forall: IV_FORALL
			l_heap_access: IV_HEAP_ACCESS
			l_boogie_type: IV_TYPE
			l_content_type: TYPE_A
			l_prev: like previous_versions
		do
			l_attribute_name := name_translator.boogie_procedure_for_feature (a_feature, a_context_type)
			l_boogie_type := types.for_type_in_context (a_feature.type, a_context_type)

			l_prev := previous_versions (a_feature, a_context_type)
			if l_prev = Void then
					-- No previous versions:
					-- Add unique field declaration
				boogie_universe.add_declaration (
					create {IV_CONSTANT}.make_unique (
						l_attribute_name,
						types.field (l_boogie_type)))

					-- Mark field as a ghost or non-ghost
				if helper.is_ghost (a_feature) then
					boogie_universe.add_declaration (
						create {IV_AXIOM}.make (
							factory.function_call ("IsGhostField", << l_attribute_name >>, types.bool)))
				else
					boogie_universe.add_declaration (
						create {IV_AXIOM}.make (
							factory.not_ (
								factory.function_call ("IsGhostField", << l_attribute_name >>, types.bool))))
				end
			else
					-- Inherited or redefined:
					-- Add field declaration
				boogie_universe.add_declaration (
					create {IV_CONSTANT}.make (
						l_attribute_name,
						types.field (l_boogie_type)))

					-- Add equivalences
				across l_prev as prev loop
					l_old_name := name_translator.boogie_procedure_for_feature (prev.item.feat, prev.item.typ)
					translation_pool.add_referenced_feature (prev.item.feat, prev.item.typ)
					boogie_universe.add_declaration (create {IV_AXIOM}.make (factory.equal (
						create {IV_ENTITY}.make (l_attribute_name, l_boogie_type),
						create {IV_ENTITY}.make (l_old_name, l_boogie_type))))
				end
			end

				-- Add attribute-type specific properties
			if a_feature.type.is_reference and not l_boogie_type.is_set and not l_boogie_type.is_seq then
				l_content_type := a_feature.type
				if l_content_type.is_attached then
					l_fname := "attached_attribute"
				else
					l_fname := "detachable_attribute"
				end
			elseif l_boogie_type.is_set then
				l_content_type := a_feature.type.generics.first
				if l_content_type.is_attached then
					l_fname := "set_attached_attribute"
				else
					l_fname := "set_detachable_attribute"
				end
			elseif l_boogie_type.is_seq then
				l_content_type := a_feature.type.generics.first
				if l_content_type.is_attached then
					l_fname := "sequence_attached_attribute"
				else
					l_fname := "sequence_detachable_attribute"
				end
			end
			if l_fname /= Void then
				l_call := factory.function_call (l_fname, <<
						"heap", "o", factory.type_value (a_context_type),
						l_attribute_name, factory.type_value (l_content_type)
					>>, types.bool)
				create l_forall.make (l_call)
				l_forall.add_bound_variable ("heap", types.heap_type)
				l_forall.add_bound_variable ("o", types.ref)
				create l_heap_access.make ("heap", create {IV_ENTITY}.make ("o", types.ref), create {IV_ENTITY}.make (l_attribute_name, types.generic_type))
				l_forall.add_trigger (l_heap_access)
				boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
			end

				-- Add translation references
			translation_pool.add_type_in_context (a_feature.type, a_context_type)

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

feature {NONE} -- Implementation

	previous_versions (a_feature: FEATURE_I; a_context_type: TYPE_A): LINKED_LIST [TUPLE [feat: FEATURE_I; typ: TYPE_A]]
			-- Versions of `a_feature' from ancestors of `a_context_type' if inherited or redefined; Void if it is teh original definition.
		local
			l_written_type: TYPE_A
			l_written_feature: FEATURE_I
			i: INTEGER
		do
			check attached {CL_TYPE_A} a_context_type.deep_actual_type as cl_type then
				if a_feature.written_in /= a_context_type.base_class.class_id then
						-- Inherited attribute: return the class where it is written in
					l_written_type := cl_type.parent_type (a_feature.written_class.actual_type)
					create Result.make
					Result.extend ([a_feature, l_written_type])
				elseif a_feature.assert_id_set /= Void then
						-- Redefined attribute: return original versions
					from
						create Result.make
						i := 1
					until
						i > a_feature.assert_id_set.count
					loop
						l_written_type := cl_type.parent_type (a_feature.assert_id_set [i].written_class.actual_type)
						l_written_feature := a_feature.assert_id_set [i].written_class.feature_of_body_index (a_feature.assert_id_set [i].body_index)
						Result.extend ([l_written_feature, l_written_type])
						i := i + 1
					end
				end
			end
		end

end
