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

	E2B_SHARED_BOOGIE_UNIVERSE

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

				translate_invariant_function (a_type)
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
				create l_decl.make (name_translator.boogie_name_for_invariant_function (a_type), types.bool)
			else
				create l_decl.make (name_translator.boogie_name_for_filtered_invariant_function (a_type, a_included, a_excluded), types.bool)
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

			if options.is_ownership_enabled then
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
					l_clauses.extend (forall_invariant_property)
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

	forall_invariant_property: IV_EXPRESSION
		local
			l_forall: IV_FORALL
			l_i, l_current: IV_ENTITY
		do
			create l_i.make (helper.unique_identifier ("i"), types.ref)
			create l_current.make ("current", types.ref)
			create l_forall.make (
				factory.implies_ (
					factory.map_access (factory.heap_access ("heap", l_current, "subjects", types.set (types.ref)), l_i),
					factory.map_access (factory.heap_access ("heap", l_i, "observers", types.set (types.ref)), l_current)))
			l_forall.add_bound_variable (l_i.name, l_i.type)
			Result := l_forall
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
						l_assert.process (l_translator)
						across l_translator.side_effect as i loop
							Result.extend (i.item.expr)
						end
						Result.extend (l_translator.last_expression)

						l_assert.process (a_collector)
					end

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
			l_fname := name_translator.boogie_name_for_invariant_function (a_type)

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
		do
			if not types.is_mml_type (a_type) then
				create l_heap.make ("Heap", types.heap_type)
				create l_type.make (name_translator.boogie_name_for_type (a_type), types.type)
				if attached {IV_ENTITY} a_expr as a_entity and then a_entity.name ~ "Current" then
					-- For Current the exact dynamic type is considered known
					create l_expr.make ("attached_exact", types.bool)
				elseif a_type.is_attached then
					create l_expr.make ("attached", types.bool)
				else
					create l_expr.make ("detachable", types.bool)
				end
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

end
