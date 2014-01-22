note
	description: "Summary description for {E2B_CUSTOM_OWNERSHIP_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_OWNERSHIP_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

	SHARED_WORKBENCH

	SHARED_SERVER

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := (a_feature.written_in = system.any_id and
				(translation_mapping.builtin_any_functions.has (a_feature.feature_name) or
				translation_mapping.builtin_any_procedures.has (a_feature.feature_name) or
				translation_mapping.ghost_access.has (a_feature.feature_name) or
				translation_mapping.ghost_setter.has (a_feature.feature_name)))
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_assign: IV_ASSIGNMENT
			l_call: IV_PROCEDURE_CALL
			l_type: IV_TYPE
		do
			l_name := a_feature.feature_name
			if translation_mapping.builtin_any_functions.has (l_name) then
				a_translator.process_builtin_function_call (a_feature, a_parameters, l_name)
			elseif translation_mapping.builtin_any_procedures.has (l_name) then
				set_static_ghost_sets (a_translator, l_name)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
			elseif translation_mapping.ghost_access.has (l_name) then
				l_type := translation_mapping.ghost_access_type (l_name)
				a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap.name, a_translator.current_target, l_name, l_type))
			elseif translation_mapping.ghost_setter.has (l_name) then
				l_name := l_name.substring (5, l_name.count)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "xyz")
				l_call ?= a_translator.side_effect.last
				a_translator.side_effect.finish
				a_translator.side_effect.remove	-- last side effect is actual call, here to non-existing "xyz"
				a_translator.set_last_expression (Void)
				if l_name ~ "subjects" then
					l_call := factory.procedure_call ("update_subjects", << a_translator.current_target, l_call.arguments.i_th (2)>>)
				elseif l_name ~ "observers" then
					l_call := factory.procedure_call ("update_observers", << a_translator.current_target, l_call.arguments.i_th (2)>>)
				else
					l_call := factory.procedure_call ("update_heap", <<
						a_translator.current_target,
						factory.entity (l_name, types.field ((create {E2B_SPECIAL_MAPPING}.make).ghost_access_type (l_name))),
						l_call.arguments.i_th (2)>>)
				end
				l_call.node_info.set_line (a_translator.context_line_number)
				a_translator.side_effect.extend (l_call)
			else
				check false end
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
			l_tag_filters: LIST [STRING]
			l_field: IV_ENTITY
			l_feature: FEATURE_I
			l_partial_inv_class: CLASS_C
		do
			l_name := a_feature.feature_name
			if translation_mapping.builtin_any_functions.has (l_name) then
				if l_name ~ "inv_without" then
					l_tag_filters := extract_tags (a_parameters)
						-- Determine the class whose invariant is taken as reference:
						-- if target is Current, then it is the origin class of the contract clause,
						-- otherwise, it is the type of the target
					if a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) then
						l_partial_inv_class := a_translator.origin_class
					else
						l_partial_inv_class := a_translator.current_target_type.base_class
					end
					check_valid_class_inv_tags (l_partial_inv_class, a_translator.context_feature, a_translator.context_line_number, l_tag_filters)
					translation_pool.add_filtered_invariant_function (a_translator.current_target_type, Void, l_tag_filters, l_partial_inv_class)
					a_translator.set_last_expression (
						factory.function_call (
							name_translator.boogie_function_for_filtered_invariant (a_translator.current_target_type, Void, l_tag_filters, l_partial_inv_class),
							<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
				elseif l_name ~ "inv_only" then
					l_tag_filters := extract_tags (a_parameters)
					if a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) then
						l_partial_inv_class := a_translator.origin_class
					else
						l_partial_inv_class := a_translator.current_target_type.base_class
					end
					check_valid_class_inv_tags (l_partial_inv_class, a_translator.context_feature, a_translator.context_line_number, l_tag_filters)
					translation_pool.add_filtered_invariant_function (a_translator.current_target_type, l_tag_filters, Void, l_partial_inv_class)
					a_translator.set_last_expression (
						factory.function_call (
							name_translator.boogie_function_for_filtered_invariant (a_translator.current_target_type, l_tag_filters, Void, l_partial_inv_class),
							<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
				elseif l_name ~ "inv" then
					a_translator.process_builtin_routine_call (a_feature, a_parameters, "user_inv")
				elseif l_name ~ "is_field_writable" then
					if attached {STRING_B} a_parameters.first.expression as l_string then
						l_field := field_from_string (l_string.value, a_translator.current_target_type, a_translator.context_feature, a_translator.context_line_number)
						if attached l_field then
							a_translator.set_last_expression (factory.frame_access (
								a_translator.context_writable,
								a_translator.current_target,
								l_field))
						end
					else
						helper.add_semantic_error (a_translator.context_feature, messages.first_argument_string, a_translator.context_line_number)
					end
				elseif l_name ~ "is_fully_writable" then
					a_translator.set_last_expression (factory.function_call (
						"has_whole_object",
						<< a_translator.context_writable, a_translator.current_target>>,
						types.bool))
				elseif l_name ~ "is_field_readable" then
					if attached a_translator.context_readable then
						if attached {STRING_B} a_parameters.first.expression as l_string then
							l_field := field_from_string (l_string.value, a_translator.current_target_type, a_translator.context_feature, a_translator.context_line_number)
							if attached l_field then
								a_translator.set_last_expression (factory.frame_access (
									a_translator.context_readable,
									a_translator.current_target,
									l_field))
							end
						else
							helper.add_semantic_error (a_translator.context_feature, messages.first_argument_string, a_translator.context_line_number)
						end
					else
						helper.add_semantic_warning (a_translator.context_feature, messages.invalid_context_for_read_predicate, a_translator.context_line_number)
						a_translator.set_last_expression (factory.true_)
					end
				elseif l_name ~ "is_fully_readable" then
					if attached a_translator.context_readable then
						a_translator.set_last_expression (factory.function_call (
							"has_whole_object",
							<< a_translator.context_readable, a_translator.current_target>>,
							types.bool))
					else
						helper.add_semantic_warning (a_translator.context_feature, messages.invalid_context_for_read_predicate, a_translator.context_line_number)
						a_translator.set_last_expression (factory.true_)
					end
				elseif l_name ~ "domain_has" then
					a_translator.process_builtin_routine_call (a_feature, a_parameters, "in_domain")
				else
					a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
				end
			elseif translation_mapping.ghost_access.has (l_name) then
				if l_name ~ "closed" then
					l_type := types.bool
				elseif l_name ~ "owner" then
					l_type := types.ref
				else
					l_type := types.set (types.ref)
				end
				a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap.name, a_translator.current_target, l_name, l_type))
			else
					-- cannot happen
				check False end
			end
		end

	extract_tags (a_parameters: BYTE_LIST [PARAMETER_B]): LIST [STRING]
		do
			check a_parameters.count = 1 end
			create {LINKED_LIST [STRING]} Result.make
			Result.compare_objects
			if attached {STRING_B} a_parameters.first.expression as l_string then
				Result.extend (l_string.value)
			elseif attached {TUPLE_CONST_B} a_parameters.first.expression as l_tuple then
				across l_tuple.expressions as i loop
					if attached {STRING_B} i.item as l_string then
						Result.extend (l_string.value)
					else
						check False end
					end
				end
			else
				check False end
			end
		end

	check_valid_class_inv_tags (a_class: CLASS_C; a_context_feature: FEATURE_I; a_line_number: INTEGER; a_tags: LIST [STRING])
			-- Check if `a_tags' only lists valid class invariant of `a_class'.
			-- Otherwise report error in feature `a_context_featur'.
		local
			l_asserts: BYTE_LIST [BYTE_NODE]
			l_assert: ASSERT_B
			l_tags_copy: LINKED_LIST [STRING]
			l_string: STRING
		do
			create l_tags_copy.make
			l_tags_copy.append (a_tags)
			l_tags_copy.compare_objects
			check_flat_inv_tags (a_class, l_tags_copy)
			if not l_tags_copy.is_empty then
				l_string := ""
				across l_tags_copy as i loop
					l_string.append (i.item)
					l_string.append (", ")
				end
				l_string.remove_tail (2)
				helper.add_semantic_error (a_context_feature, messages.invalid_tag (l_string, a_class.name_in_upper), a_line_number)
			end
		end

	check_flat_inv_tags (a_class: CLASS_C; a_tags: LIST [STRING])
			-- Remove from `a_tags' all class invariant tags present in `a_class' and its ancestors.
		local
			l_asserts: BYTE_LIST [BYTE_NODE]
			l_assert: ASSERT_B
			l_classes: FIXED_LIST [CLASS_C]
		do
			if inv_byte_server.has (a_class.class_id) then
				from
					l_asserts := inv_byte_server.item (a_class.class_id).byte_list
					l_asserts.start
				until
					l_asserts.after
				loop
					l_assert ?= l_asserts.item_for_iteration
					check l_assert /= Void end
					if l_assert.tag /= Void then
						a_tags.prune_all (l_assert.tag)
					end
					l_asserts.forth
				end
			end
			from
				l_classes := a_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if l_classes.item.class_id /= system.any_id then
					check_flat_inv_tags (l_classes.item, a_tags)
				end
				l_classes.forth
			end
		end

	set_static_ghost_sets (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature_name: STRING)
			-- If processing a call to `Current.wrap',
			-- generate guarded assignments to statically known built-in ghost fields and store them in the side effect of `a_translator'.
		do
			if a_feature_name ~ "wrap" and a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) then
				set_static_ghost_set (a_translator, "owns", "update_heap", True)
				set_static_ghost_set (a_translator, "subjects", "update_subjects", False)
				set_static_ghost_set (a_translator, "observers", "update_observers", False)
			end
		end

	set_static_ghost_set (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_field_name, a_update_name: STRING; a_pass_field: BOOLEAN)
			-- If the definition of `a_field_name' in `current_target_type' is statically known,
			-- generate a guarded update using Boogie procedure `a_update_name' and store it in the side effect of `a_translator';
			-- if `a_pass_field' the procedure receives the field as argument.
		local
			l_function: IV_FUNCTION
			l_field: IV_ENTITY
			l_pcall: IV_PROCEDURE_CALL
			l_if: IV_CONDITIONAL
		do
				-- Get definition of `a_field_name' for `current_target_type';
				-- if it exists, generate a guarded assignment.
			l_function := boogie_universe.function_named (name_translator.boogie_function_for_ghost_definition (a_translator.current_target_type, a_field_name))
			if attached l_function then
				create l_field.make (a_field_name, types.field (types.set (types.ref)))
				create l_pcall.make (a_update_name)
				l_pcall.add_argument (a_translator.entity_mapping.current_expression)
				if a_pass_field then
					l_pcall.add_argument (l_field)
				end
				l_pcall.add_argument (factory.function_call (l_function.name,
					<< a_translator.entity_mapping.heap, a_translator.entity_mapping.current_expression >>,
					types.set (types.ref)))
				l_pcall.node_info.set_attribute ("default", a_field_name)
				l_pcall.node_info.set_line (a_translator.context_line_number)
				create l_if.make_if_then (factory.frame_access (a_translator.context_writable, a_translator.current_target, l_field),
					factory.singleton_block (l_pcall))
				a_translator.side_effect.extend (l_if)
			end
		end

	field_from_string (a_name: STRING; a_type: TYPE_A; a_context_feature: FEATURE_I; a_context_line_number: INTEGER): IV_ENTITY
			-- Boogie field corresponding to an attribute (or built-in ghost access) with name `a_name' in type `a_type'.
		local
			l_feature: FEATURE_I
		do
			l_feature := a_type.base_class.feature_named_32 (a_name)
			if l_feature = Void then
				helper.add_semantic_error (a_context_feature, messages.field_not_attribute (a_name, a_type.base_class.name_in_upper), a_context_line_number)
			else
				if translation_mapping.ghost_access.has (a_name) then
					-- Handle built-in ANY attributes separately, since they are not really attributes
					Result := factory.entity (a_name, types.field (translation_mapping.ghost_access_type (a_name)))
				elseif l_feature.is_attribute then
					Result := factory.entity (name_translator.boogie_procedure_for_feature (l_feature, a_type),
						types.field (types.for_type_a (l_feature.type)))
					translation_pool.add_referenced_feature (l_feature, a_type)
				else
					helper.add_semantic_error (a_context_feature, messages.field_not_attribute (a_name, a_type.base_class.name_in_upper), a_context_line_number)
				end
			end

		end
end
