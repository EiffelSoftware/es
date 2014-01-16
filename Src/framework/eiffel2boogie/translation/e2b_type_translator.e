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

	last_property: detachable IV_EXPRESSION
			-- Last generated property.

feature -- Basic operations

	translate_type (a_type: TYPE_A)
			-- Translate `a_type' to Boogie.
		require
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
		local
			l_boogie_type_name: STRING
			l_constant: IV_CONSTANT
			l_path: PATH
			l_dep: FILE_NAME
		do
			l_boogie_type_name := name_translator.boogie_name_for_type (a_type)

				-- Add dependencies
			across
				helper.class_note_values (a_type.base_class, "theory") as deps
			loop
				create l_path.make_from_string (deps.item)
				if l_path.is_absolute then
					create l_dep.make_from_string (deps.item)
				else
					create l_dep.make_from_string (l_path.absolute_path_in (a_type.base_class.lace_class.file_name.parent).canonical_path.out)
				end
				boogie_universe.add_dependency (l_dep)
			end

			-- TODO: refactor
			if not a_type.is_tuple and not helper.is_class_logical (a_type.base_class) then
					-- Type definition
				create l_constant.make (l_boogie_type_name, types.type)
				l_constant.set_unique
				boogie_universe.add_declaration (l_constant)

				if a_type.is_frozen then
					boogie_universe.add_declaration (create {IV_AXIOM}.make (
						factory.function_call ("is_frozen", << factory.entity (l_boogie_type_name, types.type) >>, types.bool)))
				end

					-- Inheritance relations
				if not a_type.has_generics then
					generate_inheritance_relations (a_type)
				end

					-- TODO: refactor
				if a_type.base_class.name_in_upper /~ "ARRAY" then
					translate_invariant_function (a_type)
				end
			end
		end

	translate_invariant_function (a_type: TYPE_A)
			-- Translate `a_type' to Boogie.
		require
			a_type_exists: a_type /= Void
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
		do
			generate_invariant_function (a_type, Void, Void, a_type.base_class)
			generate_invariant_axiom (a_type)
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
			generate_invariant_function (a_type, a_included, a_excluded, a_ancestor)
		end

feature {NONE} -- Implementation

	generate_inheritance_relations (a_type: TYPE_A)
			-- Generate inheritance relations for type `a_type'.
		require
			not_generic: not a_type.has_generics
		local
			l_parents: FIXED_LIST [CL_TYPE_A]
			l_type_name: STRING
			l_axiom: IV_AXIOM
			l_operation: IV_BINARY_OPERATION
			l_type_value: IV_VALUE
			l_parent_value: IV_VALUE
		do
			l_type_name := name_translator.boogie_name_for_type (a_type)
			l_parents := a_type.associated_class.parents
			from
				l_parents.start
			until
				l_parents.after
			loop
				translation_pool.add_type (l_parents.item)

				create l_type_value.make (l_type_name, types.type)
				create l_parent_value.make (name_translator.boogie_name_for_type (l_parents.item), types.type)
				create l_operation.make (l_type_value, "<:", l_parent_value, types.bool)
				create l_axiom.make (l_operation)
				boogie_universe.add_declaration (l_axiom)

				l_parents.forth
			end
		end

	generate_invariant_function (a_type: TYPE_A; a_included, a_excluded: LIST [STRING]; a_ancestor: CLASS_C)
			-- Generate invariant function for `a_type';
			-- if `a_included /= Void', include only those clauses;
			-- if `a_excluded /= Void', exclude those clauses;
			-- restrict clauses to those inherited from `a_ancestor'.
		require
			a_type_exists: a_type /= Void
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
			a_ancestor_exists: a_ancestor /= Void
			not_both: a_included = Void or a_excluded = Void
		local
			l_decl: IV_FUNCTION
			l_clauses: LINKED_LIST [IV_EXPRESSION]
			l_expr: IV_EXPRESSION
			l_ghost_collector: E2B_GHOST_SET_COLLECTOR
		do
			if a_included = Void and a_excluded = Void and a_ancestor.class_id = a_type.base_class.class_id then
				create l_decl.make (name_translator.boogie_function_for_invariant (a_type), types.bool)
			else
				create l_decl.make (name_translator.boogie_function_for_filtered_invariant (a_type, a_included, a_excluded, a_ancestor), types.bool)
			end

			l_decl.add_argument ("heap", types.heap)
			l_decl.add_argument ("current", types.ref)
			boogie_universe.add_declaration (l_decl)

			create l_ghost_collector
			l_clauses := process_flat_invariants (a_ancestor, a_type, l_ghost_collector, a_included, a_excluded)
				-- Add ownership defaults unless included clauses are explicitly specified
			if options.is_ownership_enabled and a_included = Void then
				if not helper.is_class_explicit (a_type.base_class, "observers") and not l_ghost_collector.has_observers then
					l_clauses.extend (empty_set_property ("observers"))
				end
				if not helper.is_class_explicit (a_type.base_class, "subjects") and not l_ghost_collector.has_subjects then
					l_clauses.extend (empty_set_property ("subjects"))
				end
				if not helper.is_class_explicit (a_type.base_class, "owns") and not l_ghost_collector.has_owns then
					l_clauses.extend (empty_set_property ("owns"))
				end
				if not helper.is_class_explicit (a_type.base_class, "invariant") then
					l_clauses.extend (factory.function_call ("admissibility2", << factory.heap_entity ("heap"), factory.ref_entity ("current") >>, types.bool))
				end
			end

			l_expr := factory.true_
			from
				l_clauses.start
			until
				l_clauses.after
			loop
				l_expr := factory.and_clean (l_expr, l_clauses.item)
				l_clauses.forth
			end
			l_decl.set_body (l_expr)
		end

	empty_set_property (a_name: STRING): IV_EXPRESSION
		do
			Result := factory.function_call (
				"Set#Equal",
				<<
					factory.heap_access ("heap", create {IV_ENTITY}.make ("current", types.ref), a_name, types.set (types.ref)),
					factory.function_call ("Set#Empty", << >>, types.set (types.ref))
				>>,
				types.bool)
		end

	process_flat_invariants (a_class: CLASS_C; a_context_type: TYPE_A; a_collector: E2B_GHOST_SET_COLLECTOR; a_included, a_excluded: LIST [STRING]): LINKED_LIST [IV_EXPRESSION]
			-- Process invariants of `a_class' and its ancestors.
		local
			l_classes: FIXED_LIST [CLASS_C]
		do
			Result := process_invariants (a_class, a_context_type, a_collector, a_included, a_excluded)
			from
				l_classes := a_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if l_classes.item.class_id /= system.any_id then
					Result.append (process_flat_invariants (l_classes.item, a_context_type, a_collector, a_included, a_excluded))
				end
				l_classes.forth
			end
		end

	process_invariants (a_class: CLASS_C; a_context_type: TYPE_A; a_collector: E2B_GHOST_SET_COLLECTOR; a_included, a_excluded: LIST [STRING]): LINKED_LIST [IV_EXPRESSION]
			-- Process invariants of `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			l_list: BYTE_LIST [BYTE_NODE]
			l_assert: ASSERT_B
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			create Result.make
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
						l_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
						l_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
						l_translator.set_context (Void, a_context_type)
						l_translator.set_origin_class (a_class)
						l_translator.set_context_line_number (l_assert.line_number)
						l_translator.set_context_tag (l_assert.tag)
						l_assert.process (l_translator)
						across l_translator.side_effect as i loop
							Result.extend (i.item.expression)
						end
						Result.extend (l_translator.last_expression)
							-- If ownership is enabled and we are processing the full invariant,
							-- check if the invariant clause defines one of the built-in ghost sets
							-- and generate correspoding functions
						if options.is_ownership_enabled and a_included = Void and a_excluded = Void then
							generate_ghost_set_definition (l_translator.last_expression, a_context_type, "owns")
							generate_ghost_set_definition (l_translator.last_expression, a_context_type, "subjects")
							generate_ghost_set_definition (l_translator.last_expression, a_context_type, "observers")
						end
					end
					l_assert.process (a_collector)

					l_list.forth
				end
			end
		end

	generate_invariant_axiom (a_type: TYPE_A)
			-- Generate axioms that connect "user_inv" with the invariant of `a_type'.
		local
			l_fname: STRING
			l_forall: IV_FORALL
			l_heap: IV_ENTITY
			l_current: IV_ENTITY
		do
			l_fname := name_translator.boogie_function_for_invariant (a_type)

			create l_heap.make ("heap", types.heap)
			create l_current.make ("current", types.ref)

				-- type_of(current) == a_type  ==>  user_inv(heap, current) == l_fname(heap, current)
			create l_forall.make (
				factory.implies_ (
					factory.equal (
						factory.type_of (l_current),
						factory.type_value (a_type)),
					factory.equal (
						factory.function_call ("user_inv", << l_heap, l_current >>, types.bool),
						factory.function_call (l_fname, << l_heap, l_current >>, types.bool))))
			l_forall.add_bound_variable (l_heap.name, l_heap.type)
			l_forall.add_bound_variable (l_current.name, l_current.type)

			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))

				-- Inheritance axiom:
				-- type_of(current) <: a_type  ==>  user_inv(heap, current) ==> l_fname(heap, current)
			create l_forall.make (
				factory.implies_ (
					factory.sub_type (
						factory.type_of (l_current),
						factory.type_value (a_type)),
					factory.implies_ (
						factory.function_call ("user_inv", << l_heap, l_current >>, types.bool),
						factory.function_call (l_fname, << l_heap, l_current >>, types.bool))))
			l_forall.add_bound_variable (l_heap.name, l_heap.type)
			l_forall.add_bound_variable (l_current.name, l_current.type)

			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	generate_ghost_set_definition (a_expr: IV_EXPRESSION; a_type: TYPE_A; a_name: STRING)
			-- If `a_expr' has the form `a_name = def', create a Boogie function that defined `a_name' for `a_type' as `def'.
			-- (Only accespting definitions of this form to avoid cycles).
		local
			l_current, l_heap: IV_ENTITY
			l_def: IV_EXPRESSION
			l_function: IV_FUNCTION
		do
			create l_current.make ("current", types.ref)
			create l_heap.make ("heap", types.heap)

			l_def := definition_of (a_expr, l_heap, l_current, a_name)
			if attached l_def and not helper.is_class_explicit (a_type.base_class, a_name) then
				create l_function.make (name_translator.boogie_function_for_ghost_definition (a_type, a_name), types.set (types.ref))
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
				if fcall.arguments [1].same_expression (factory.heap_access (a_heap.name, a_current, a_name, types.set (types.ref))) then
					Result := fcall.arguments [2]
				end
			end
		end

feature -- TODO: move somewhere else

	generate_invariant_admissability_check (a_class: CLASS_C)
			-- Generate invariant admissability check for class `a_class'.
		local
			l_reads_collector: E2B_READS_COLLECTOR
			l_proc: IV_PROCEDURE
			l_impl: IV_IMPLEMENTATION
			l_pre: IV_PRECONDITION
			l_name: STRING
			l_goto: IV_GOTO
			l_block_a1, l_block_a2, l_block_a3, l_block_a4, l_block_a5: IV_BLOCK
			l_assert: IV_ASSERT
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
			create l_pre.make (factory.function_call ("user_inv", << factory.global_heap, factory.std_current >>, types.bool))
			l_proc.add_contract (l_pre)

			create l_block_a1.make_name ("a1")
			create l_block_a2.make_name ("a2")
			create l_block_a3.make_name ("a3")
			create l_block_a4.make_name ("a4")
			create l_block_a5.make_name ("a5")

			create l_goto.make (l_block_a1)
			l_goto.add_target (l_block_a2)
			l_goto.add_target (l_block_a3)
			l_goto.add_target (l_block_a4)
			l_goto.add_target (l_block_a5)
			l_impl.body.add_statement (l_goto)

				-- A1: reads(o.inv) is subset of domain(o) + o.subjects

			l_impl.body.add_statement (l_block_a1)
			create l_assert.make (factory.true_)
			l_assert.node_info.set_type ("A1")
			l_block_a1.add_statement (l_assert)
			l_block_a1.add_statement (create {IV_RETURN})

				-- A2: o.inv implies forall x: x in o.subjects implies o in x.observers

			l_impl.body.add_statement (l_block_a2)
			create l_assert.make (factory.function_call ("admissibility2", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A2")
			l_block_a2.add_statement (l_assert)
			l_block_a2.add_statement (create {IV_RETURN})

				-- A3: o.inv does not mention closed/owner/is_open/is_closed/is_wrapped

			l_impl.body.add_statement (l_block_a3)
			create l_assert.make (factory.true_)
			l_assert.node_info.set_type ("A3")
			l_block_a3.add_statement (l_assert)
			l_block_a3.add_statement (create {IV_RETURN})

				-- A4: o.inv cannot be violated by updating subjects field of a subject

			l_impl.body.add_statement (l_block_a4)
			create l_assert.make (factory.function_call ("admissibility4", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A4")
			l_block_a4.add_statement (l_assert)
			l_block_a4.add_statement (create {IV_RETURN})


				-- A5: o.inv cannot be violated by enlarging observers field of a subject

			l_impl.body.add_statement (l_block_a5)
			create l_assert.make (factory.function_call ("admissibility5", << factory.global_heap, factory.std_current >>, types.bool))
			l_assert.node_info.set_type ("A5")
			l_block_a5.add_statement (l_assert)
			l_block_a5.add_statement (create {IV_RETURN})

		end

	handle_class_validity_result (a_class: CLASS_C; a_boogie_result: E2B_BOOGIE_PROCEDURE_RESULT; a_result: E2B_RESULT)
			-- Handle Boogie result `a_boogie_result'.
		local
			l_success: E2B_SUCCESSFUL_VERIFICATION
			l_failure: E2B_FAILED_VERIFICATION
			l_error: E2B_DEFAULT_VERIFICATION_ERROR
		do
			if a_boogie_result.is_successful then
				create l_success
				l_success.set_class (a_class)
				l_success.set_time (a_boogie_result.time)
				l_success.set_verification_context ("invariant admissibility")
				a_result.add_result (l_success)

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
					elseif i.item.attributes["type"] ~ "A2" then
						l_error.set_message ("Some subjects might not have Current in their observers set")
					elseif i.item.attributes["type"] ~ "A3" then
						l_error.set_message ("A3")
					elseif i.item.attributes["type"] ~ "A4" then
						l_error.set_message ("The invariant might be invalidated by changing subjects of one of the subjects")
					elseif i.item.attributes["type"] ~ "A5" then
						l_error.set_message ("The invariant might be invalidated by adding observers to one of the subjects")
					else
						check internal_error: False end
					end
					l_failure.errors.extend (l_error)
				end

				a_result.add_result (l_failure)
			end
		end

end
