note
	description: "[
		Translation of Eiffel types to Boogie.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TYPE_TRANSLATOR

inherit

	E2B_SHARED_CONTEXT

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

feature -- Access

	type: TYPE_A
			-- Type under translation.

	last_clauses: LINKED_LIST [IV_EXPRESSION]
			-- Last generated invariant clauses.

	last_safety_checks: LINKED_LIST [IV_ASSERT]
			-- Last generated precondition of the invariant.

	builtin_collector: E2B_BUILTIN_CALLS_COLLECTOR
			-- Visitor that collects information about the usage of built-in ghost fields.

feature -- Basic operations

	translate_type (a_type: TYPE_A)
			-- Translate `a_type' to Boogie.
		require
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
		local
			l_class: CLASS_C
			l_boogie_type_name: STRING
			l_constant: IV_CONSTANT
			l_path: PATH
			l_dep: FILE_NAME
		do
			type := a_type
			l_class := a_type.base_class
			l_boogie_type_name := name_translator.boogie_name_for_type (a_type)

				-- Add dependencies
			across
				helper.class_note_values (l_class, "theory") as deps
			loop
				create l_path.make_from_string (deps.item)
				if l_path.is_absolute then
					create l_dep.make_from_string (deps.item)
				else
					create l_dep.make_from_string (l_path.absolute_path_in (l_class.lace_class.file_name.parent).canonical_path.out)
				end
				boogie_universe.add_dependency (l_dep)
			end

				-- Add actual generic parameters
			if a_type.has_generics then
				across
					a_type.generics as params
				loop
					if not params.item.is_formal then
						translation_pool.add_type_in_context (params.item, type)
					end
				end
			end

			-- TODO: refactor
			if not a_type.is_tuple and not helper.is_class_logical (l_class) then
					-- Type definition
				create l_constant.make (l_boogie_type_name, types.type)
				l_constant.set_unique
				boogie_universe.add_declaration (l_constant)

				if a_type.is_frozen then
					boogie_universe.add_declaration (create {IV_AXIOM}.make (
						factory.function_call ("is_frozen", << factory.entity (l_boogie_type_name, types.type) >>, types.bool)))
				end

					-- Inheritance relations
				generate_inheritance_relations

					-- TODO: refactor
				if l_class.name_in_upper /~ "ARRAY" then
					translate_invariant_function
				end
			end

				-- Check model clause
			across
				helper.model_queries (l_class) as m
			loop
				if a_type.base_class.feature_named_32 (m.item) = Void then
					helper.add_semantic_error (l_class, messages.field_not_attribute (m.item, l_class.name_in_upper), -1)
				end
			end
		end

	translate_filtered_invariant_function (a_type: TYPE_A; a_included, a_excluded: LIST [STRING]; a_ancestor: CLASS_C)
			-- Translate `a_type' to Boogie.
		require
			a_type_exists: a_type /= Void
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
			a_ancestor_exists: a_ancestor /= Void
			not_both: a_included = Void or a_excluded = Void
		do
			type := a_type
			generate_invariant_function (a_included, a_excluded, a_ancestor)
		end

feature {NONE} -- Implementation

	translate_invariant_function
			-- Translate invariant of `type'.
		require
			a_type_exists: type /= Void
			valid_type: type.is_class_valid
			no_like_type: not type.is_like
		do
			generate_invariant_function (Void, Void, type.base_class)
			generate_invariant_axiom ("user_inv", name_translator.boogie_function_for_invariant (type))
		end

	generate_inheritance_relations
			-- Generate inheritance relations for `type'.
		local
			l_parents: FIXED_LIST [CL_TYPE_A]
			l_parent: TYPE_A
			l_type_name: STRING
			l_axiom: IV_AXIOM
			l_operation: IV_BINARY_OPERATION
			l_type_value: IV_VALUE
			l_parent_value: IV_VALUE
		do
			l_type_name := name_translator.boogie_name_for_type (type)
			l_parents := type.associated_class.parents
			from
				l_parents.start
			until
				l_parents.after
			loop
				l_parent := l_parents.item.instantiated_in (type)
				translation_pool.add_type_in_context (l_parent, type)

				create l_type_value.make (l_type_name, types.type)
				create l_parent_value.make (name_translator.boogie_name_for_type (l_parent), types.type)
				create l_operation.make (l_type_value, "<:", l_parent_value, types.bool)
				create l_axiom.make (l_operation)
				boogie_universe.add_declaration (l_axiom)

					-- Link model queries
				link_model_queries (l_parent)

				l_parents.forth
			end
		end

	link_model_queries (a_parent_type: TYPE_A)
			-- Generate axioms that link model queries of `a_parent_type' to model queries of `type'.
		local
			l_model: FEATURE_I
			l_type_var: IV_VAR_TYPE
			l_f, l_old_m, l_new_m: IV_ENTITY
			l_def: IV_EXPRESSION
			l_fcall: IV_FUNCTION_CALL
			l_forall: IV_FORALL
		do
			across helper.model_queries (a_parent_type.base_class) as m loop
				l_model := a_parent_type.base_class.feature_named_32 (m.item)
				if attached l_model and not helper.model_queries (system.any_type.base_class).has (m.item) then
					create l_type_var.make_fresh
					create l_f.make ("$f", types.field (l_type_var))
					create l_old_m.make (
						name_translator.boogie_procedure_for_feature (l_model, a_parent_type),
						types.field (types.for_type_in_context (l_model.type, a_parent_type)))

					l_def := factory.false_
					across helper.model_represented (l_model, a_parent_type.base_class, type.associated_class) as m1 loop
						create l_new_m.make (
							name_translator.boogie_procedure_for_feature (m1.item, type),
							types.field (types.for_type_in_context (m1.item.type, type)))
						l_def := factory.or_clean (l_def, factory.equal (l_f, l_new_m))
					end
					l_fcall := factory.function_call ("ModelRepresents", <<
							l_f, factory.type_value (type),
							l_old_m, factory.type_value (a_parent_type) >>,
						types.bool)
					create l_forall.make (factory.equiv (l_fcall, l_def))
					l_forall.add_type_variable (l_type_var.name)
					l_forall.add_bound_variable (l_f.name, l_f.type)
					l_forall.add_trigger (l_fcall)
					boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
				end
			end
		end

	generate_invariant_function (a_included, a_excluded: LIST [STRING]; a_ancestor: CLASS_C)
			-- Generate invariant function for `type';
			-- if `a_included /= Void', include only those clauses;
			-- if `a_excluded /= Void', exclude those clauses;
			-- restrict clauses to those inherited from `a_ancestor'.
		require
			type_exists: type /= Void
			valid_type: type.is_class_valid
			no_like_type: not type.is_like
			a_ancestor_exists: a_ancestor /= Void
			not_both: a_included = Void or a_excluded = Void
		local
			l_heap, l_current: IV_ENTITY
			l_inv_function: IV_FUNCTION
			l_mapping: E2B_ENTITY_MAPPING
		do
			l_heap := factory.entity ("heap", types.heap)
			l_current := factory.entity ("current", types.ref)

			if a_included = Void and a_excluded = Void and a_ancestor.class_id = type.base_class.class_id then
				create l_inv_function.make (name_translator.boogie_function_for_invariant (type), types.bool)
			else
				create l_inv_function.make (name_translator.boogie_function_for_filtered_invariant (type, a_included, a_excluded, a_ancestor), types.bool)
			end
			l_inv_function.add_argument (l_heap.name, l_heap.type)
			l_inv_function.add_argument (l_current.name, l_current.type)
			boogie_universe.add_declaration (l_inv_function)

			create l_mapping.make
			l_mapping.set_heap (l_heap)
			l_mapping.set_current (l_current)
			create builtin_collector
			process_invariants (a_ancestor, a_included, a_excluded, l_mapping)
				-- Add ownership defaults unless included clauses are explicitly specified
			if options.is_ownership_enabled and a_included = Void then
				if not type.base_class.is_deferred then
						-- For an effective class: built-in ghost sets are empty by default
						-- (ToDo: the policy seems arbitrary, should it be for all non-frozen classes?)
					if not helper.is_class_explicit (type.base_class, "observers") and not builtin_collector.has_observers then
						last_clauses.extend (empty_set_property ("observers"))
					end
					if not helper.is_class_explicit (type.base_class, "subjects") and not builtin_collector.has_subjects then
						last_clauses.extend (empty_set_property ("subjects"))
					end
					if not helper.is_class_explicit (type.base_class, "owns") and not builtin_collector.has_owns then
						last_clauses.extend (empty_set_property ("owns"))
					end
				end
				if not helper.is_class_explicit (type.base_class, "invariant") then
					last_clauses.extend (factory.function_call ("admissibility2", << factory.heap_entity ("heap"), factory.ref_entity ("current") >>, types.bool))
				end
			end

			l_inv_function.set_body (factory.conjunction (last_clauses))
		end

	empty_set_property (a_name: STRING): IV_EXPRESSION
		do
			Result := factory.function_call (
				"Set#IsEmpty",
				<< factory.heap_access (factory.entity ("heap", types.heap), factory.entity ("current", types.ref), a_name, types.set (types.ref)) >>,
				types.bool)
		end

	process_invariants (a_class: CLASS_C; a_included, a_excluded: LIST [STRING]; a_mapping: E2B_ENTITY_MAPPING)
			-- Process invariants of `a_class' and its ancestors, and store results in `last_clauses'.
		do
			create last_clauses.make
			create last_safety_checks.make
			helper.set_up_byte_context (Void, type)
			process_flat_invariants (a_class, a_included, a_excluded, a_mapping)
		end

	process_flat_invariants (a_class: CLASS_C; a_included, a_excluded: LIST [STRING]; a_mapping: E2B_ENTITY_MAPPING)
			-- Recursively process invariants of `a_class' and its ancestors.
		local
			l_classes: FIXED_LIST [CLASS_C]
		do
			from
				l_classes := a_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if l_classes.item.class_id /= system.any_id then
					process_flat_invariants (l_classes.item,a_included, a_excluded, a_mapping)
				end
				l_classes.forth
			end
			process_immediate_invariants (a_class, a_included, a_excluded, a_mapping)
		end

	process_immediate_invariants (a_class: CLASS_C; a_included, a_excluded: LIST [STRING]; a_mapping: E2B_ENTITY_MAPPING)
			-- Process invariants written in `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			l_list: BYTE_LIST [BYTE_NODE]
			l_assert: ASSERT_B
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			if inv_byte_server.has (a_class.class_id) then
				from
					l_list := inv_byte_server.item (a_class.class_id).byte_list
					l_list.start
				until
					l_list.after
				loop
					l_assert ?= l_list.item
					check l_assert /= Void end

					if  (a_included = Void and a_excluded = Void) or else
						(a_included /= Void and then l_assert.tag /= Void and then a_included.has (l_assert.tag)) or else
						(a_excluded /= Void and then (l_assert.tag = Void or else not a_excluded.has (l_assert.tag)))
					then
						create l_translator.make
						l_translator.copy_entity_mapping (a_mapping)
						l_translator.set_context (Void, type)
						l_translator.set_origin_class (a_class)
						l_translator.set_context_line_number (l_assert.line_number)
						l_translator.set_context_tag (l_assert.tag)
						l_translator.set_context_readable (factory.function_call ("user_inv_readable", << factory.global_heap, factory.std_current >>, types.frame))
--						l_translator.set_restricted_context_readable (factory.function_call ("user_inv_function_readable", << factory.global_heap, factory.std_current >>, types.frame))
						l_assert.process (l_translator)
						last_safety_checks.append (l_translator.side_effect)
						last_safety_checks.extend (create {IV_ASSERT}.make_assume (l_translator.last_expression))
						last_clauses.extend (l_translator.last_expression)
							-- If ownership is enabled and we are processing the full invariant,
							-- check if the invariant clause defines one of the built-in ghost sets
							-- and generate correspoding functions
						if options.is_ownership_enabled and a_included = Void and a_excluded = Void then
							generate_ghost_set_definition (l_translator.last_expression, "owns")
							generate_ghost_set_definition (l_translator.last_expression, "subjects")
							generate_ghost_set_definition (l_translator.last_expression, "observers")
						end
					end
					l_assert.process (builtin_collector)

					l_list.forth
				end
			end
		end

	generate_invariant_axiom (a_generic_function, a_special_function: STRING)
			-- Generate axioms that connect `a_generic_function' with `a_special_function' for `a_type'.
		local
			l_forall: IV_FORALL
			l_heap, l_current: IV_ENTITY
			l_generic_call, l_special_call: IV_FUNCTION_CALL
		do
			create l_heap.make ("heap", types.heap)
			create l_current.make ("current", types.ref)
			l_generic_call := factory.function_call (a_generic_function, << l_heap, l_current >>, types.bool)
			l_special_call := factory.function_call (a_special_function, << l_heap, l_current >>, types.bool)

				-- type_of(current) == type  ==>  generic_function(heap, current) == special_function(heap, current)
			create l_forall.make (factory.implies_ (
					factory.equal (
						factory.type_of (l_current),
						factory.type_value (type)),
					factory.equal (l_generic_call, l_special_call)))
			l_forall.add_bound_variable (l_heap.name, l_heap.type)
			l_forall.add_trigger (l_generic_call)
			l_forall.add_bound_variable (l_current.name, l_current.type)

			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))

				-- Inheritance axiom:
				-- type_of(current) <: type  ==>  generic_function(heap, current) ==> special_function(heap, current)
			create l_forall.make (factory.implies_ (
					factory.sub_type (
						factory.type_of (l_current),
						factory.type_value (type)),
					factory.implies_ (l_generic_call, l_special_call)))
			l_forall.add_bound_variable (l_heap.name, l_heap.type)
			l_forall.add_trigger (l_generic_call)
			l_forall.add_bound_variable (l_current.name, l_current.type)

			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	generate_ghost_set_definition (a_expr: IV_EXPRESSION; a_name: STRING)
			-- If `a_expr' has the form `a_name = def', create a Boogie function that defined `a_name' for `type' as `def'.
			-- (Only accespting definitions of this form to avoid cycles).
		local
			l_current, l_heap: IV_ENTITY
			l_def: IV_EXPRESSION
			l_function: IV_FUNCTION
		do
			create l_current.make ("current", types.ref)
			create l_heap.make ("heap", types.heap)

			l_def := definition_of (a_expr, l_heap, l_current, a_name)
			if attached l_def and not helper.is_class_explicit (type.base_class, a_name) then
				create l_function.make (name_translator.boogie_function_for_ghost_definition (type, a_name), types.set (types.ref))
				l_function.add_argument (l_heap.name, l_heap.type)
				l_function.add_argument (l_current.name, l_current.type)
				l_function.set_body (l_def)
				boogie_universe.add_declaration (l_function)
			end
		end

	definition_of (a_expr: IV_EXPRESSION; a_heap, a_current: IV_ENTITY; a_name: STRING): detachable IV_EXPRESSION
			-- If `a_expr' has the form `a_name = def' return `def', otherwise `Void'.
		do
			if attached {IV_FUNCTION_CALL} a_expr as fcall and then fcall.name ~ "Set#Equal" then
				if fcall.arguments [1].same_expression (factory.heap_access (a_heap, a_current, a_name, types.set (types.ref))) then
					Result := fcall.arguments [2]
				end
			end
		end

feature -- Invariant admissibility

	generate_invariant_admissability_check (a_class: CLASS_C)
			-- Generate invariant admissability check for class `a_class'.
		local
			l_proc: IV_PROCEDURE
			l_impl: IV_IMPLEMENTATION
			l_pre: IV_PRECONDITION
			l_name: STRING
			l_goto: IV_GOTO
			l_block: IV_BLOCK
			l_assert, l_assume: IV_ASSERT
			l_forall: IV_FORALL
			l_i, l_current: IV_ENTITY
		do
			l_name := a_class.name_in_upper + ".invariant_admissibility_check"
			create l_proc.make (l_name)
			create l_impl.make (l_proc)
			boogie_universe.add_declaration (l_proc)
			boogie_universe.add_declaration (l_impl)
			result_handlers.extend (agent handle_class_validity_result (a_class, ?, ?), l_name)

				-- Set up procedure with arguments and precondition
			l_proc.add_argument ("Current", types.ref)
			create l_pre.make (factory.function_call ("attached_exact", << factory.global_heap, factory.std_current, factory.type_value (a_class.actual_type) >>, types.bool))
			l_proc.add_contract (l_pre)
			create l_assume.make_assume (factory.function_call ("user_inv", << factory.global_heap, factory.std_current >>, types.bool))

			create l_goto.make_empty
			l_impl.body.add_statement (l_goto)

				-- Invariant has no precondition

			create l_block.make_name ("pre")
			l_goto.add_target (l_block)
			l_impl.body.add_statement (l_block)
			type := a_class.actual_type
			create builtin_collector
			builtin_collector.set_any_target
			process_invariants (a_class, Void, Void, create {E2B_ENTITY_MAPPING}.make)
			across last_safety_checks as i loop
				l_block.add_statement (i.item)
			end

				-- A3: o.inv does not mention closed and owner (static check)
			if builtin_collector.is_inv_unfriendly then
				helper.add_semantic_error (a_class, messages.invalid_call_in_invariant, -1)
			end

				-- A1: reads(o.inv) is subset of domain(o) + o.subjects

			create l_block.make_name ("a1")
			l_goto.add_target (l_block)
			l_impl.body.add_statement (l_block)
			l_block.add_statement (l_assume)
			create l_assert.make (factory.true_)
			l_assert.node_info.set_type ("A1")
			l_block.add_statement (l_assert)
			l_block.add_statement (factory.return)

				-- A2: o.inv implies forall x: x in o.subjects implies o in x.observers

			create l_block.make_name ("a2")
			l_goto.add_target (l_block)
			l_impl.body.add_statement (l_block)
			l_block.add_statement (l_assume)
			create l_assert.make (factory.function_call ("admissibility2", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A2")
			l_block.add_statement (l_assert)
			l_block.add_statement (factory.return)

				-- A4: o.inv cannot be violated by updating subjects field of a subject

			create l_block.make_name ("a4")
			l_goto.add_target (l_block)
			l_impl.body.add_statement (l_block)
			l_block.add_statement (l_assume)
			create l_assert.make (factory.function_call ("admissibility4", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A4")
			l_block.add_statement (l_assert)
			l_block.add_statement (factory.return)


				-- A5: o.inv cannot be violated by enlarging observers field of a subject

			create l_block.make_name ("a5")
			l_goto.add_target (l_block)
			l_impl.body.add_statement (l_block)
			l_block.add_statement (l_assume)
			create l_assert.make (factory.function_call ("admissibility5", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A5")
			l_block.add_statement (l_assert)
			l_block.add_statement (factory.return)

		end

	handle_class_validity_result (a_class: CLASS_C; a_boogie_result: E2B_BOOGIE_PROCEDURE_RESULT; a_result_generator: E2B_RESULT_GENERATOR)
			-- Handle Boogie result `a_boogie_result'.
		local
			l_success: E2B_SUCCESSFUL_VERIFICATION
			l_failure: E2B_FAILED_VERIFICATION
			l_error: E2B_DEFAULT_VERIFICATION_ERROR
		do
			if a_result_generator.has_validity_error (Void, a_class) then
				-- Ignore results of classes with a validity error

			elseif a_boogie_result.is_successful then
				create l_success
				l_success.set_class (a_class)
				l_success.set_time (a_boogie_result.time)
				l_success.set_verification_context ("invariant admissibility")
				a_result_generator.last_result.add_result (l_success)

			elseif a_boogie_result.is_inconclusive then
					-- TODO

			elseif a_boogie_result.is_error then
				create l_failure.make
				l_failure.set_class (a_class)
				l_failure.set_verification_context ("invariant admissibility")
				across a_boogie_result.errors as i loop
					check i.item.is_assert_error end
					create l_error.make (l_failure)
					l_error.set_boogie_error (i.item)
					if i.item.attributes["type"] ~ "A1" then
						l_error.set_message ("A1")
						l_failure.errors.extend (l_error)
					elseif i.item.attributes["type"] ~ "A2" then
						l_error.set_message ("Some subjects might not have Current in their observers set")
						l_failure.errors.extend (l_error)
					elseif i.item.attributes["type"] ~ "A3" then
						l_error.set_message ("A3")
						l_failure.errors.extend (l_error)
					elseif i.item.attributes["type"] ~ "A4" then
						l_error.set_message ("The invariant might be invalidated by changing subjects of one of the subjects")
						l_failure.errors.extend (l_error)
					elseif i.item.attributes["type"] ~ "A5" then
						l_error.set_message ("The invariant might be invalidated by adding observers to one of the subjects")
						l_failure.errors.extend (l_error)
					else
						a_result_generator.process_individual_error (i.item, l_failure)
					end
				end

				a_result_generator.last_result.add_result (l_failure)
			end
		end

end
