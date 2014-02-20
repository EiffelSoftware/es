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

	translate (a_feature: FEATURE_I; a_context_type: CL_TYPE_A)
			-- Translate feature `a_feature' of type `a_context_type'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_attribute_name, l_old_name: STRING
			l_class_type: CL_TYPE_A
			l_type_prop, l_expr: IV_EXPRESSION
			l_forall: IV_FORALL
			l_heap, l_o: IV_ENTITY
			l_heap_access: IV_MAP_ACCESS
			l_boogie_type: IV_TYPE
			l_prev: like previous_versions
			l_typed_sets: like helper.class_note_values
		do
			set_context (a_feature, a_context_type)
			l_class_type := helper.class_type_in_context (current_feature.type, current_type.base_class, Void, current_type)
			l_attribute_name := name_translator.boogie_procedure_for_feature (current_feature, current_type)
			l_boogie_type := types.for_class_type (l_class_type)

			l_prev := previous_versions
			if l_prev = Void then
					-- No previous versions:
					-- Add unique field declaration
				boogie_universe.add_declaration (
					create {IV_CONSTANT}.make_unique (
						l_attribute_name,
						types.field (l_boogie_type)))

					-- Mark field as a ghost or non-ghost
				l_expr := factory.function_call ("IsGhostField", << factory.entity (l_attribute_name, types.field (l_boogie_type)) >>, types.bool)
				if helper.is_ghost (current_feature) then
					boogie_universe.add_declaration (create {IV_AXIOM}.make (l_expr))
				else
					boogie_universe.add_declaration (create {IV_AXIOM}.make (factory.not_ (l_expr)))
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

				-- Add type properties
			l_heap := factory.heap_entity ("heap")
			l_o := factory.ref_entity ("o")
			l_heap_access := factory.heap_access (l_heap, l_o, l_attribute_name, l_boogie_type)
			l_type_prop := types.type_property (l_class_type, l_heap, l_heap_access)
			if not l_type_prop.is_true then
				l_type_prop := factory.implies_ (factory.and_ (
						factory.is_heap (l_heap),
						factory.function_call ("attached", << l_heap, l_o, factory.type_value (current_type)>>, types.bool)),
					l_type_prop)
				create l_forall.make (l_type_prop)
				l_forall.add_bound_variable (l_heap)
				l_forall.add_bound_variable (l_o)
				l_forall.add_trigger (l_heap_access)
				boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
			end

				-- Check if it replaces old models correctly
			check_model_replacement

				-- Add guard
			generate_guard (l_class_type, l_attribute_name, l_boogie_type)

				-- Add translation references
			translation_pool.add_type (l_class_type)

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

	generate_guard (a_type: CL_TYPE_A; a_boogie_name: STRING; a_boogie_type: IV_TYPE)
			-- Generate update guard for attribute `current_feature' of type `a_type' inside `current_type',
			-- where the Boogie translation of the attribute has name `a_boogie_name' and type `a_boogie_type'.
		local
			l_guard_feature: FEATURE_I
			l_h, l_cur, l_f, l_v, l_o: IV_ENTITY
			l_fcall: IV_FUNCTION_CALL
			l_guard, l_fname: STRING
			l_def: IV_EXPRESSION
			l_forall: IV_FORALL
		do
			create l_h.make ("heap", types.heap)
			create l_cur.make ("current", types.ref)
			create l_f.make (a_boogie_name, types.field (a_boogie_type))
			create l_v.make ("v", a_boogie_type)
			create l_o.make ("o", types.ref)
			l_fcall := factory.function_call ("guard", << l_h, l_cur, l_f, l_v, l_o >>, types.bool)

			l_guard := helper.guard_for_attribute (current_feature)
			if l_guard.as_lower ~ "true" then
					-- The guard is trivially true
				create l_forall.make (l_fcall)
			elseif l_guard.as_lower ~ "false" then
					-- The guard is trivially false
				create l_forall.make (factory.not_ (l_fcall))
			else
				l_guard_feature := current_type.base_class.feature_named_32 (l_guard)
				if not l_guard.is_empty and is_valid_guard_feature (l_guard, l_guard_feature, a_type) then
					translation_pool.add_referenced_feature (l_guard_feature, current_type)
						-- Generate guard axiom from `l_guard_feature'
					l_fname := name_translator.boogie_function_for_feature (l_guard_feature, current_type)
					l_def := factory.function_call (name_translator.boogie_free_function_precondition (l_fname), << l_h, l_cur, l_v, l_o >>, types.bool)
					l_def := factory.and_ (l_def,
						factory.function_call (name_translator.boogie_function_precondition (l_fname), << l_h, l_cur, l_v, l_o >>, types.bool))
					l_def := factory.and_ (l_def,
						factory.function_call (l_fname, << l_h, l_cur, l_v, l_o >>, types.bool))
					create l_forall.make (factory.equiv (l_fcall, l_def))
				else
						-- No guard defined: apply default
					create l_forall.make (factory.equiv (l_fcall,
						factory.function_call ("user_inv", << factory.map_update (l_h, << l_cur, l_f >>, l_v), l_o >>, types.bool)))
				end
			end

			l_forall.add_bound_variable (l_h)
			l_forall.add_bound_variable (l_cur)
			l_forall.add_bound_variable (l_v)
			l_forall.add_bound_variable (l_o)
			l_forall.add_trigger (l_fcall)
			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

feature {NONE} -- Implementation

	previous_versions: LINKED_LIST [TUPLE [feat: FEATURE_I; typ: CL_TYPE_A]]
			-- Versions of `current_feature' from ancestors of `current_type' if inherited or redefined; Void if it is the original definition.
		local
			l_written_type: CL_TYPE_A
			l_written_feature: FEATURE_I
			i: INTEGER
		do
			if current_feature.written_in /= current_type.base_class.class_id then
					-- Inherited attribute: return the class where it is written in				
				l_written_type := helper.class_type_from_class (current_feature.written_class, current_type)
				l_written_feature := l_written_type.base_class.feature_of_body_index (current_feature.body_index)
				create Result.make
				Result.extend ([l_written_feature, l_written_type])
			elseif current_feature.assert_id_set /= Void then
					-- Redefined attribute: return original versions
				from
					create Result.make
					i := 1
				until
					i > current_feature.assert_id_set.count
				loop
					l_written_type := helper.class_type_from_class (current_feature.assert_id_set [i].written_class, current_type)
					l_written_feature := l_written_type.base_class.feature_of_body_index (current_feature.assert_id_set [i].body_index)
					Result.extend ([l_written_feature, l_written_type])
					i := i + 1
				end
			end
		end

	is_valid_guard_feature (a_guard_name: STRING_32; a_guard_feature: FEATURE_I; a_attr_type: CL_TYPE_A): BOOLEAN
			-- Does `a_guard_feature' have a valid signature for an update guard for an attribute of type `a_attr_type'?
		do
			if a_guard_feature = Void then
				helper.add_semantic_error (current_feature, messages.unknown_feature (a_guard_name, current_type.base_class.name_in_upper), -1)
			elseif not helper.is_functional (a_guard_feature) then
				helper.add_semantic_error (a_guard_feature, messages.guard_feature_not_functional, -1)
			elseif not (a_guard_feature.has_return_value and then a_guard_feature.type.is_boolean) then
				helper.add_semantic_error (a_guard_feature, messages.guard_feature_not_predicate, -1)
			elseif a_guard_feature.argument_count /= 2 then
				helper.add_semantic_error (a_guard_feature, messages.guard_feature_arg_count, -1)
			elseif not a_guard_feature.arguments [1].same_as (a_attr_type) then
				helper.add_semantic_error (a_guard_feature, messages.guard_feature_arg1, -1)
			elseif not a_guard_feature.arguments [2].same_as (system.any_type) then
				helper.add_semantic_error (a_guard_feature, messages.guard_feature_arg2, -1)
			else
				Result := True
			end
		end

	check_model_replacement
			-- For an immediate attribute with a "replaces" clause,
			-- check that is didn't use to be a model query in any parent.
		local
			l_old_version: FEATURE_I
			found: BOOLEAN
		do
			if current_feature.written_in = current_type.base_class.class_id and
					not helper.string_feature_note_value (current_feature, "replaces").is_empty then
				across current_type.base_class.parents_classes as c until found loop
					l_old_version := c.item.feature_of_rout_id_set (current_feature.rout_id_set)
					if attached l_old_version and then helper.flat_model_queries (c.item).has (l_old_version) then
						helper.add_semantic_error (current_feature, messages.invalid_model_replacement (current_feature.feature_name_32, c.item.name_in_upper), -1)
						found := True
					end
				end
			end
		end

end
