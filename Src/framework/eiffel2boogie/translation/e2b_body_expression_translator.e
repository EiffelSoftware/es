note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BODY_EXPRESSION_TRANSLATOR

inherit

	E2B_EXPRESSION_TRANSLATOR
		redefine
			reset,
			process_array_const_b,
			process_creation_expr_b,
			process_tuple_access_b,
			process_tuple_const_b
		end

create
	make

feature -- Access

	context_implementation: IV_IMPLEMENTATION
			-- Context of expression.

	side_effect: LINKED_LIST [IV_STATEMENT]
			-- List of side effect statements.

feature -- Basic operations

	set_context_implementation (a_implementation: IV_IMPLEMENTATION)
			-- Set context of expression.
		do
			context_implementation := a_implementation
		end

	reset
			-- Reset expression translator.
		do
			Precursor
			context_implementation := Void
			create side_effect.make
			create procedure_calls.make
		end

feature -- Visitors

	process_array_const_b (a_node: ARRAY_CONST_B)
			-- <Precursor>
		local
			i, n: INTEGER
			l_expr: EXPR_B
			l_target: IV_EXPRESSION
			l_pcall: IV_PROCEDURE_CALL
			l_assign: IV_ASSIGNMENT
		do
			translation_pool.add_type (a_node.type)

			if a_node.expressions /= Void then
				n := a_node.expressions.count
			else
				n := 0
			end

			create_local (a_node.type)
			l_target := last_local

				-- Create array
			create l_pcall.make ("allocate")
			l_pcall.add_argument (factory.type_value (a_node.type))
			l_pcall.set_target (l_target)
			side_effect.extend (l_pcall)

			create l_pcall.make ("ARRAY.make")
			l_pcall.add_argument (l_target)
			l_pcall.add_argument (factory.int_value (1))
			l_pcall.add_argument (factory.int_value (n))
			side_effect.extend (l_pcall)

				-- Put all elements into array
			from
				i := 1
			until
				i > n
			loop
				l_expr ?= a_node.expressions.i_th (i)
				check l_expr /= Void end
				create l_assign.make (
					factory.array_access (entity_mapping.heap, l_target, factory.int_value (i)),
					process_argument_expression (l_expr))
				side_effect.extend (l_assign)

				i := i + 1
			end
			last_expression := l_target
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- <Precursor>
		local
			l_type: CL_TYPE_A
			l_feature: FEATURE_I
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A

			l_local: IV_ENTITY
			l_havoc: IV_HAVOC
			l_assume: IV_ASSUME
			l_assignment: IV_ASSIGNMENT
			l_allocated: IV_ENTITY
			l_binop: IV_BINARY_OPERATION
			l_heap_access: IV_HEAP_ACCESS
			l_call: IV_FUNCTION_CALL
			l_proc_call: IV_PROCEDURE_CALL
			l_type_value: IV_VALUE
			l_handler: E2B_CUSTOM_CALL_HANDLER
		do
			l_type ?= a_node.type.deep_actual_type
			check l_type /= Void end
			l_feature := a_node.type.associated_class.feature_of_rout_id (a_node.call.routine_id)
			check feature_valid: l_feature /= Void end
			translation_pool.add_type (l_type)

				-- Call to `allocate'
			create_local (l_type)
			l_local := last_local

				-- Is this a normal reference type?
			if l_local.type.is_reference then
				create l_proc_call.make ("allocate")
				l_proc_call.node_info.set_line (a_node.call.line_number)
				l_proc_call.add_argument (factory.type_value (l_type))
				l_proc_call.set_target (l_local)
				side_effect.extend (l_proc_call)

					-- Call to creation procedure
				l_target := current_target
				l_target_type := current_target_type

				current_target := l_local
				current_target_type := l_type

				l_handler := translation_mapping.handler_for_call (current_target_type, l_feature)
				if l_handler /= Void then
					l_handler.handle_routine_call_in_body (Current, l_feature, a_node.parameters)
				else
					process_routine_call (l_feature, a_node.parameters, True)
				end

				current_target := l_target
				current_target_type := l_target_type

				last_expression := l_local
			else
					-- Or something special?
				check l_local.type.is_set or l_local.type.is_seq end

				l_handler := translation_mapping.handler_for_call (current_target_type, l_feature)
				check l_handler /= Void end
				l_handler.handle_routine_call_in_body (Current, l_feature, a_node.parameters)
			end

		end

	process_tuple_access_b (a_node: TUPLE_ACCESS_B)
			-- <Precursor>
		local
			l_proc_call: IV_PROCEDURE_CALL
		do
			if a_node.source = Void then
				Precursor (a_node)
			else
					-- TODO: add check that position is in the range of the tuple
				a_node.source.expression.process (Current)
				create l_proc_call.make ("TUPLE.put")
				l_proc_call.add_argument (current_target)
				l_proc_call.add_argument (last_expression)
				l_proc_call.add_argument (factory.int_value (a_node.position))
				side_effect.extend (l_proc_call)
				last_expression := Void
			end
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B)
			-- <Precursor>
		local
			l_local: IV_ENTITY
			l_proc_call: IV_PROCEDURE_CALL
			l_expr: EXPR_B
		do
			create_local (a_node.type)
			l_local := last_local

			create l_proc_call.make ("allocate")
			l_proc_call.add_argument (create {IV_ENTITY}.make ("TUPLE", types.type))
			l_proc_call.set_target (l_local)
			side_effect.extend (l_proc_call)

			create l_proc_call.make ("TUPLE.make" + a_node.expressions.count.out)
			l_proc_call.add_argument (l_local)
			across a_node.expressions as i loop
				l_expr ?= i.item
				check l_expr /= Void end
				l_proc_call.add_argument (process_argument_expression (l_expr))
			end
			side_effect.extend (l_proc_call)

			last_expression := l_local
		end

feature -- Translation

	process_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_for_creator: BOOLEAN)
			-- Process feature call.
		local
			l_inlining_depth: INTEGER
		do
			if options.inlining_depth > 0 then
				l_inlining_depth := options.inlining_depth
				options.set_inlining_depth (options.inlining_depth - 1)
				process_inlined_routine_call (a_feature, a_parameters)
				options.set_inlining_depth (l_inlining_depth)
			elseif
				helper.is_inlining_routine (a_feature) and then
				(inlined_routines.has (a_feature.body_index) implies inlined_routines.item (a_feature.body_index) < options.max_recursive_inlining_depth)
			then
				process_inlined_routine_call (a_feature, a_parameters)
			else
				process_normal_routine_call (a_feature, a_parameters, a_for_creator)
			end
		end

	process_normal_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_for_creator: BOOLEAN)
			-- Process feature call.
		local
			l_pcall: IV_PROCEDURE_CALL
			l_fcall, l_pre_call: IV_FUNCTION_CALL
		do
			translation_pool.add_referenced_feature (a_feature, current_target_type)
			if a_feature.has_return_value and helper.is_functional (a_feature) then
				check not a_for_creator end
				create l_fcall.make (name_translator.boogie_function_for_feature (a_feature, current_target_type), types.for_type_a (a_feature.type))
				l_fcall.add_argument (entity_mapping.heap)
				l_fcall.add_argument (current_target)
				process_parameters (a_parameters)
				l_fcall.arguments.append (last_parameters)

				-- Add precondition check
				if a_feature.has_precondition then
					create l_pre_call.make (name_translator.precondition_predicate_name (a_feature, current_target_type), types.bool)
					l_pre_call.add_argument (entity_mapping.heap)
					l_pre_call.add_argument (current_target)
					l_pre_call.arguments.append (last_parameters)
					add_safety_check (l_pre_call, "check", "precondition_of_function_" + a_feature.feature_name, context_line_number)
				end

				-- This checks that functionals are well-defined, from the corresponding fake procedure
				add_recursion_termination_check (a_feature, last_parameters)

				last_expression := l_fcall
			else
				if a_for_creator then
					create l_pcall.make (name_translator.boogie_procedure_for_creator (a_feature, current_target_type))
				else
					create l_pcall.make (name_translator.boogie_procedure_for_feature (a_feature, current_target_type))
					if helper.is_feature_status (a_feature, "creator") then
						-- A feature specified to be creator-only, but called as a regular procedure
						helper.add_semantic_error (context_feature, messages.creator_call_as_procedure (a_feature.feature_name), context_line_number)
					end
				end

				l_pcall.node_info.set_line (context_line_number)
				l_pcall.node_info.set_attribute ("cid", a_feature.written_class.class_id.out)
				l_pcall.node_info.set_attribute ("rid", a_feature.rout_id_set.first.out)

				l_pcall.add_argument (current_target)
				process_parameters (a_parameters)
				l_pcall.arguments.append (last_parameters)

				-- This checks termination of non-functional routines, when they are called from their own implementation
				add_recursion_termination_check (a_feature, last_parameters)
				-- This adds an extra framing check if we are inside a context with a local frame
				add_loop_frame_check (a_feature, last_parameters)

					-- Process call
				if a_feature.has_return_value then
					create_local (a_feature.type.instantiated_in (current_target_type))
					l_pcall.set_target (last_local)
					last_expression := last_local
				else
						-- No expression generated, this has to be a call statement
					last_expression := Void
				end
				side_effect.extend (l_pcall)
			end
		end

	process_builtin_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_builtin_name: STRING)
			-- Process feature call.
		local
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_call: IV_PROCEDURE_CALL
		do
			create l_call.make (a_builtin_name)
			l_call.add_argument (current_target)

			process_parameters (a_parameters)
			l_call.arguments.append (last_parameters)

				-- Process call
			if a_feature.has_return_value then
				create_local (a_feature.type.instantiated_in (current_target_type))
				l_call.set_target (last_local)
				last_expression := last_local
			else
					-- No expression generated, this has to be a call statement
				last_expression := Void
			end
			l_call.node_info.set_line (context_line_number)
			l_call.node_info.set_attribute ("cid", a_feature.written_in.out)
			l_call.node_info.set_attribute ("rid", a_feature.rout_id_set.first.out)
			side_effect.extend (l_call)
		end

	process_builtin_function_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B]; a_builtin_name: STRING)
			-- Process feature call.
		require
			a_feature.has_return_value
		local
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_call: IV_FUNCTION_CALL
			l_pcall: IV_PROCEDURE_CALL
		do
			create l_call.make (a_builtin_name, types.for_type_a (a_feature.type))
			l_call.add_argument (entity_mapping.heap)
			l_call.add_argument (current_target)

			process_parameters (a_parameters)
			l_call.arguments.append (last_parameters)

			current_target := l_target
			current_target_type := l_target_type

			last_expression := l_call
		end

	process_special_routine_call (a_handler: E2B_CUSTOM_CALL_HANDLER; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			a_handler.handle_routine_call_in_body (Current, a_feature, a_parameters)
		end

	inlined_routines: HASH_TABLE [INTEGER, INTEGER]
			-- Routines currently being inlined.
		once
			create Result.make (5)
		end

	process_inlined_routine_call (a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call.
		local
			l_target: IV_EXPRESSION
			l_target_type: TYPE_A
			l_call: IV_PROCEDURE_CALL
			l_translator: E2B_INSTRUCTION_TRANSLATOR
			l_block: IV_BLOCK
			l_entity_mapping: E2B_ENTITY_MAPPING
			l_features: LIST [FEATURE_I]
		do
				-- TODO: look for all possible descendant-implementations for feature
				-- and add a nondeterministic goto that selects between all of those
				-- implementations

--			if l_features.count > 1 then
--					-- More than one possible feature to inline
--			elseif l_features.count = 1 then
--					-- Exactly one feature to inline
--			else
--					-- No possible feature to inline (deferred or external)
--				process_normal_routine_call (a_feature, a_parameters)
--			end

			if inlined_routines.has (a_feature.body_index) then
				inlined_routines.force (inlined_routines.item (a_feature.body_index) + 1, a_feature.body_index)
			else
				inlined_routines.force (1, a_feature.body_index)
			end


			process_parameters (a_parameters)

				-- Set up entity mapping
			create l_entity_mapping.make_copy (entity_mapping)
			l_entity_mapping.clear_arguments
			l_entity_mapping.clear_locals
				-- Map `Current'
			l_entity_mapping.set_current (current_target)
				-- Map arguments
			across last_parameters as l_args loop
				l_entity_mapping.set_argument (l_args.cursor_index, l_args.item)
			end
				-- Map `Result'
			if a_feature.has_return_value then
				create_local (a_feature.type)
				l_entity_mapping.set_result (last_local)
			end

			create l_block.make
			create l_translator.make
			l_translator.set_context (context_implementation, a_feature, current_target_type)
			l_translator.set_current_block (l_block)
			l_translator.set_entity_mapping (l_entity_mapping)

			l_translator.process_feature_of_type (a_feature, current_target_type)
			helper.set_up_byte_context (context_feature, context_type)

			side_effect.extend (l_block)

			if a_feature.has_return_value then
				last_expression := l_entity_mapping.result_expression
			else
				last_expression := Void
			end

			inlined_routines.force (inlined_routines.item (a_feature.body_index) - 1, a_feature.body_index)
		end

	add_safety_check (a_expression: IV_EXPRESSION; a_name: STRING; a_tag: STRING; a_line: INTEGER)
			-- <Precursor>
		local
			l_assert: IV_ASSERT
		do
			create l_assert.make (implies_safety_expression (a_expression))
			l_assert.node_info.set_type (a_name)
			l_assert.node_info.set_tag (a_tag)
			l_assert.node_info.set_line (a_line)
			l_assert.set_attribute_string (":subsumption 0")
			side_effect.extend (l_assert)
		end

	add_termination_check (l_old_variants, l_new_variants: LIST [IV_EXPRESSION])
			-- Given expressions for old and new values of variants, add a safety check that the new variants are strinctly less and the order is well-founded.
		require
			l_old_variants_exists: l_old_variants /= Void
			l_new_variants_exists: l_new_variants /= Void
			same_count: l_old_variants.count = l_new_variants.count
		local
			l_eq_less: like eq_and_less
			l_check_list: ARRAYED_LIST [like eq_and_less]
			l_check, l_bounds_check_guard: IV_EXPRESSION
			i: INTEGER
		do
			from
				i := 1
				create l_check_list.make (3)
				l_bounds_check_guard := factory.false_
			until
				i > l_old_variants.count
			loop
				l_eq_less := eq_and_less (l_new_variants [i], l_old_variants [i])
				l_check_list.extend (l_eq_less)
				if l_new_variants [i].type.is_integer then
					-- Add bounds check, since integers are not already bounded from below;
					-- more precisely, for variant k check:
        					-- new[1] < old[1] || ... || new[k-1] < old[k-1] || new[k] == old[k] || 0 <= old[k]
					add_safety_check (factory.or_clean (l_bounds_check_guard,
													factory.or_ (l_eq_less.eq, factory.less_equal (factory.int_value (0), l_old_variants [i]))),
						"termination", "bounded" + i.out, context_line_number)
				end
				l_bounds_check_guard := factory.or_clean (l_bounds_check_guard, l_eq_less.less)

				i := i + 1
			end

			if not l_check_list.is_empty then
				-- Go backward through the list and generate "less1 || (eq1 && (less2 || ... eq<n-1> && less<n>))"
				l_check := l_check_list.last.less
				from
					i := l_check_list.count - 1
				until
					i < 1
				loop
					l_check := factory.and_ (l_check_list [i].eq, l_check)
					l_check := factory.or_ (l_check_list [i].less, l_check)
					i := i - 1
				end
				add_safety_check (l_check, "termination", "variant_decreases", context_line_number)
			else
				-- Explicitly marked as possibly non-terminating: do not generate any checks
			end
		end


	add_recursion_termination_check (a_feature: FEATURE_I; a_parameters: like last_parameters)
			-- Add termination check for a call to routine `a_feature' with actual arguments `a_parameters' int he current context.
		local
			l_caller_variant, l_callee_variant: IV_FUNCTION_CALL
			l_caller_variants, l_callee_variants: ARRAYED_LIST [IV_EXPRESSION]
			l_decreases_fun: IV_FUNCTION
			i, j: INTEGER
		do
			-- If we are inside a routine and calling the same routine (recursive call)
			if context_feature /= Void and then context_feature.written_in = a_feature.written_in and
												context_feature.feature_id = a_feature.feature_id then
				from
					i := 1
					create l_caller_variants.make (3)
					create l_callee_variants.make (3)
					l_decreases_fun := boogie_universe.function_named (name_translator.boogie_function_for_variant (i, a_feature, current_target_type))
					check checked_when_creating: types.is_variant_type (l_decreases_fun.type) end
				until
					l_decreases_fun = Void
				loop
					create l_callee_variant.make (l_decreases_fun.name, l_decreases_fun.type)
					l_callee_variant.add_argument (entity_mapping.heap)
					l_callee_variant.add_argument (current_target)
					l_callee_variant.arguments.append (a_parameters)
					l_callee_variants.extend (l_callee_variant)

					create l_caller_variant.make (l_decreases_fun.name, l_decreases_fun.type)
					l_caller_variant.add_argument (entity_mapping.heap)
					l_caller_variant.add_argument (entity_mapping.current_expression)
					from
						j := 1
					until
						j > context_feature.argument_count
					loop
						l_caller_variant.add_argument (entity_mapping.argument (context_feature, context_type, j))
						j := j + 1
					end
					l_caller_variants.extend (l_caller_variant)

					i := i + 1
					l_decreases_fun := boogie_universe.function_named (name_translator.boogie_function_for_variant (i, a_feature, current_target_type))
					check checked_when_creating: types.is_variant_type (l_decreases_fun.type) end
				end
				add_termination_check (l_caller_variants, l_callee_variants)
			end
		end

	add_loop_frame_check (a_feature: FEATURE_I; a_parameters: like last_parameters)
			-- If there is a local frame, check that `a_feature's frame is a subframe of it.
		local
			l_fcall: IV_FUNCTION_CALL
		do
			if local_writable /= Void then
				create l_fcall.make (name_translator.boogie_function_for_frame (a_feature, current_target_type), types.frame)
				l_fcall.add_argument (entity_mapping.heap)
				l_fcall.add_argument (current_target)
				l_fcall.arguments.append (a_parameters)
				add_safety_check (factory.function_call ("Frame#Subset", <<l_fcall, local_writable>>, types.bool),
					"check", "frame_writable", context_line_number)
			end
		end


feature {NONE} -- Implementation

	procedure_calls: LINKED_STACK [IV_PROCEDURE_CALL]
			-- Stack of procedure calls.

	create_local (a_type: TYPE_A)
			-- Create new local.
		do
			create last_local.make (helper.unique_identifier ("temp"), types.for_type_a (a_type))
			context_implementation.add_local (last_local.name, last_local.type)
		end

	eq_and_less (e1, e2: IV_EXPRESSION): TUPLE [eq: IV_EXPRESSION; less: IV_EXPRESSION]
			-- Expressions "e1 = e2" and "e1 < e2" accorsing to the type of subexpressions.			
		require
			same_types: e1.type.is_same_type (e2.type)
			proper_type: types.is_variant_type (e1.type)
		local
			l_type: IV_TYPE
			l_eq, l_less: IV_EXPRESSION
		do
			l_type := e1.type
			if l_type.is_boolean then
				l_eq := factory.equiv (e1, e2)
				l_less := factory.and_ (factory.not_ (e1), e2) -- false < true
			elseif l_type.is_integer then
				l_eq := factory.equal (e1, e2)
				l_less := factory.less (e1, e2)
			elseif l_type.is_set then
				l_eq := factory.function_call ("Set#Equal", <<e1, e2>>, types.bool)
				l_less := factory.function_call ("Set#ProperSubset", <<e1, e2>>, types.bool)
			elseif l_type.is_seq then
				l_eq := factory.equal (factory.function_call ("Seq#Length", <<e1>>, types.int),
										factory.function_call ("Seq#Length", <<e2>>, types.int))
				l_less := factory.less (factory.function_call ("Seq#Length", <<e1>>, types.int),
										factory.function_call ("Seq#Length", <<e2>>, types.int))
			elseif l_type.is_reference then
				l_eq := factory.equiv (factory.equal (e1, factory.void_), factory.equal (e2, factory.void_))
				l_less := factory.and_ (factory.equal (e1, factory.void_), factory.not_equal (e2, factory.void_)) -- Void < r
			else
				check wrong_type_in_a_decreases_clause: False end
			end
			Result := [l_eq, l_less]
		end

end
