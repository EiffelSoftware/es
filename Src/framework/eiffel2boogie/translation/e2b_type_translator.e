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
		do
			l_boogie_type_name := name_translator.boogie_name_for_type (a_type)

			-- TODO: refactor
			if not a_type.is_tuple then
					-- Type definition
				create l_constant.make (l_boogie_type_name, types.type)
				l_constant.set_unique
				boogie_universe.add_declaration (l_constant)

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
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
		do
			generate_invariant_function (a_type, create {LINKED_LIST [STRING]}.make, create {LINKED_LIST [STRING]}.make)
			generate_invariant_axiom (a_type)
		end

	translate_filtered_invariant_function (a_type: TYPE_A; a_included, a_excluded: LIST [STRING])
			-- Translate `a_type' to Boogie.
		require
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
			included_not_void: a_included /= Void
			excluded_not_void: a_excluded /= Void
		do
			a_included.compare_objects
			a_excluded.compare_objects
			generate_invariant_function (a_type, a_included, a_excluded)
		end

	generate_argument_property (a_arg: IV_EXPRESSION; a_type: TYPE_A)
			-- Generate argument property about `a_arg' of `a_type'.
		do
			last_property := argument_property (a_arg, a_type)
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

	generate_invariant_function (a_type: TYPE_A; a_included, a_excluded: LIST [STRING])
			-- Generate invariant function for `a_type'.
		local
			l_decl: IV_FUNCTION
			l_classes: FIXED_LIST [CLASS_C]
			l_clauses: LINKED_LIST [IV_EXPRESSION]
			l_expr: IV_EXPRESSION
			l_ghost_collector: E2B_GHOST_SET_COLLECTOR
		do
			if a_included.is_empty and a_excluded.is_empty then
				create l_decl.make (name_translator.boogie_function_for_invariant (a_type), types.bool)
			else
				create l_decl.make (name_translator.boogie_function_for_filtered_invariant (a_type, a_included, a_excluded), types.bool)
			end

			l_decl.add_argument ("heap", types.heap_type)
			l_decl.add_argument ("current", types.ref)
			boogie_universe.add_declaration (l_decl)

			create l_ghost_collector

			l_clauses := process_invariants (a_type.base_class, a_type, l_ghost_collector, a_included, a_excluded)
			from
				l_classes := a_type.base_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if l_classes.item.class_id /= system.any_id then
					l_clauses.append (process_invariants (l_classes.item, a_type, l_ghost_collector, a_included, a_excluded))
				end
				l_classes.forth
			end

				-- Add ownership defaults unless included clauses are explicitly specified
			if options.is_ownership_enabled and a_included.is_empty then
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
					l_clauses.extend (factory.function_call ("admissibility2", << "heap", "current" >>, types.bool))
				end
			end

			if l_clauses.count = 0 then
				l_decl.set_body (factory.true_)
			else
				from
					l_clauses.start
					l_expr := l_clauses.first
					l_clauses.forth
				until
					l_clauses.after
				loop
					l_expr := factory.and_ (l_expr, l_clauses.item)
					l_clauses.forth
				end
				l_decl.set_body (l_expr)
			end
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

	process_invariants (a_class: CLASS_C; a_context_type: TYPE_A; a_collector: E2B_GHOST_SET_COLLECTOR; a_included, a_excluded: LIST [STRING]): LINKED_LIST [IV_EXPRESSION]
			-- Process invariants of `a_class'.
		require
			a_class_not_void: a_class /= Void
			a_included_not_void: a_included /= Void
			a_iexcluded_not_void: a_excluded /= Void
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

					if
						(a_included.is_empty and a_excluded.is_empty) or else
						(not a_included.is_empty and then l_assert.tag /= Void and then a_included.has (l_assert.tag)) or else
						(not a_excluded.is_empty and then (l_assert.tag = Void or else not a_excluded.has (l_assert.tag)))
					then
						create l_translator.make
						l_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
						l_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap_type))
						l_translator.set_context (Void, a_context_type)
						l_translator.set_context_line_number (l_assert.line_number)
						l_translator.set_context_tag (l_assert.tag)
						l_assert.process (l_translator)
						across l_translator.side_effect as i loop
							Result.extend (i.item.expr)
						end
						Result.extend (l_translator.last_expression)
							-- If ownership is enabled and we are processing the full invariant,
							-- check if the invariant clause defines one of the built-in ghost sets
							-- and generate correspoding functions
						if options.is_ownership_enabled and (a_included.is_empty and a_excluded.is_empty) then
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
			-- Generate invariant function for `a_type'.
		local
			l_fname: STRING
			l_forall: IV_FORALL
			l_heap: IV_ENTITY
			l_current: IV_ENTITY
		do
			l_fname := name_translator.boogie_function_for_invariant (a_type)

			create l_heap.make ("heap", types.heap_type)
			create l_current.make ("current", types.ref)

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
			create l_heap.make ("heap", types.heap_type)

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

	argument_property (a_expr: IV_EXPRESSION; a_type: TYPE_A): detachable IV_EXPRESSION
			-- Property associated with argument `a_name' of type `a_type'.
		local
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type
			check not l_type.is_like end
			if l_type.is_reference then
				Result := reference_property (a_expr, l_type)
			elseif l_type.is_boolean then
				Result := Void
			elseif l_type.is_integer or l_type.is_natural or l_type.is_character then
				Result := numeric_property (a_expr, l_type)
			elseif l_type.is_formal then
					-- TODO: take constraint type
			else
				check False end
			end
		end

	reference_property (a_expr: IV_EXPRESSION; a_type: TYPE_A): detachable IV_EXPRESSION
			-- Property associated with argument `a_name' of type `a_type'.
		require
			reference_type: a_type.is_reference
		local
			l_heap, l_type: IV_ENTITY
			l_expr: IV_FUNCTION_CALL
			l_fcall: IV_FUNCTION_CALL
			l_content_type: TYPE_A
		do
			if not types.is_mml_type (a_type) then
				create l_type.make (name_translator.boogie_name_for_type (a_type), types.type)
				if attached {IV_ENTITY} a_expr as a_entity and then a_entity.name ~ "Current" then
					-- For Current the exact dynamic type is considered known
					create l_expr.make ("attached_exact", types.bool)
				elseif a_type.is_attached then
					create l_expr.make ("attached", types.bool)
				else
					create l_expr.make ("detachable", types.bool)
				end
			elseif a_type.base_class.name ~ "MML_SET" then
				l_content_type := a_type.generics.first
				if l_content_type.is_reference then
					create l_type.make (name_translator.boogie_name_for_type (l_content_type), types.type)
					if l_content_type.is_attached then
						create l_expr.make ("set_attached", types.bool)
					else
						create l_expr.make ("set_detachable", types.bool)
					end
				end
			elseif a_type.base_class.name ~ "MML_SEQUENCE" then
				l_content_type := a_type.generics.first
				if l_content_type.is_reference then
					create l_type.make (name_translator.boogie_name_for_type (l_content_type), types.type)
					if l_content_type.is_attached then
						create l_expr.make ("sequence_attached", types.bool)
					else
						create l_expr.make ("sequence_detachable", types.bool)
					end
				end
			else
				check False end
			end
			if l_expr /= Void then
				create l_heap.make ("Heap", types.heap_type)
				l_expr.add_argument (l_heap)
				l_expr.add_argument (a_expr)
				l_expr.add_argument (l_type)
				Result := l_expr
					-- TODO: refactor
				if a_type.base_class.name_in_upper ~ "ARRAY" then
					create l_fcall.make ("ARRAY.inv", types.bool)
					l_fcall.add_argument (l_heap)
					l_fcall.add_argument (a_expr)
					Result := factory.and_ (Result, l_fcall)
				end
			end
		end

	numeric_property (a_expr: IV_EXPRESSION; a_type: TYPE_A): detachable IV_EXPRESSION
			-- Property associated with argument `a_name' of type `a_type'.
		require
			numeric_property: a_type.is_numeric or a_type.is_character
		local
			l_expr: IV_FUNCTION_CALL
			l_f_name: STRING
		do
			if attached {INTEGER_A} a_type as l_int_type then
				l_f_name := "is_integer_" + l_int_type.size.out
			elseif attached {NATURAL_A} a_type as l_nat_type then
				l_f_name := "is_natural_" + l_nat_type.size.out
			elseif attached {CHARACTER_A} a_type as l_char_type then
				if l_char_type.is_character_32 then
					l_f_name := "is_natural_32"
				else
					l_f_name := "is_natural_8"
				end
			else
				check False end
			end
			create l_expr.make (l_f_name, types.bool)
			l_expr.add_argument (a_expr)
			Result := l_expr
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
			create l_pre.make (factory.function_call ("attached_exact", << "Heap", "Current", factory.type_value (a_class.actual_type) >>, types.bool))
			l_proc.add_contract (l_pre)
			create l_pre.make (factory.function_call ("user_inv", << "Heap", "Current" >>, types.bool))
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
			create l_assert.make (factory.function_call ("admissibility2", << "Heap", "Current" >>, types.bool))
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
			create l_assert.make (factory.function_call ("admissibility4", << "Heap", "Current" >>, types.bool))
			l_assert.node_info.set_type ("A4")
			l_block_a4.add_statement (l_assert)
			l_block_a4.add_statement (create {IV_RETURN})


				-- A5: o.inv cannot be violated by enlarging observers field of a subject

			l_impl.body.add_statement (l_block_a5)
			create l_assert.make (factory.function_call ("admissibility5", << "Heap", "Current" >>, types.bool))
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
