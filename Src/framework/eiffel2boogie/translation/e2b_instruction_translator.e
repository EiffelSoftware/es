note
	description: "Translates Eiffel instructions to Boogie."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INSTRUCTION_TRANSLATOR

inherit

	E2B_VISITOR
		rename
			safe_process as safe_process_b
		redefine
			process_assign_b,
			process_check_b,
			process_debug_b,
			process_guard_b,
			process_if_b,
			process_inspect_b,
			process_instr_call_b,
			process_loop_b,
			process_nested_b,
			process_retry_b,
			process_reverse_b
		end

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize instruction translator.
		do
			reset
		end

feature -- Access

	current_implementation: IV_IMPLEMENTATION
			-- Boogie procedure implementation currently being processed.

	current_feature: FEATURE_I
			-- Feature that is currently being processed.

	current_type: TYPE_A
			-- Type containing feature that is currently being processed.

	current_block: IV_BLOCK
			-- Current block that receives statements.

	entity_mapping: E2B_ENTITY_MAPPING
			-- Name mapping used.

feature -- Element change

	set_context (a_implementation: IV_IMPLEMENTATION; a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context.
		do
			current_implementation := a_implementation
			current_feature := a_feature
			current_type := a_type
			current_block := current_implementation.body
			if a_feature.has_return_value then
				entity_mapping.set_default_result (a_feature.type)
			end

		end

	set_entity_mapping (a_entity_mapping: E2B_ENTITY_MAPPING)
			-- Set `entity_mapping' to `a_entity_mapping'.
		do
			entity_mapping := a_entity_mapping
		ensure
			entity_mapping_set: entity_mapping = a_entity_mapping
		end

	set_current_block (a_block: IV_BLOCK)
			-- Set `current_block' to `a_block'.
		do
			current_block := a_block
		ensure
			current_block_set: current_block = a_block
		end

feature -- Basic operations

	reset
			-- Reset instruction translator.
		do
			current_feature := Void
			current_type := Void
			current_implementation := Void
			current_block := Void
			create entity_mapping.make
			create locals_map.make (5)
		end

	process_feature_of_type (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Process body of feature `a_feature' of type `a_type'.
		local
			l_type: TYPE_A
			l_name: STRING
		do
			helper.set_up_byte_context (a_feature, a_type)
			if attached Context.byte_code as l_byte_code then
				if l_byte_code.compound /= Void and then not l_byte_code.compound.is_empty then
					if l_byte_code.locals /= Void then
						across l_byte_code.locals as i loop
							l_name := helper.unique_identifier ("local")
							l_type := i.item.deep_actual_type.instantiated_in (current_type)
							entity_mapping.set_local (i.cursor_index, create {IV_ENTITY}.make (l_name, types.for_type_a (l_type)))
							current_implementation.add_local (l_name, types.for_type_a (l_type))
						end
					end
					process_compound (l_byte_code.compound)
				end
			end
		end

	process_compound (a_compound: BYTE_LIST [BYTE_NODE])
			-- Process `a_compound'.
		do
			safe_process_b (a_compound)
		end

feature -- Processing

	process_assign_b (a_node: ASSIGN_B)
			-- <Precursor>
		local
			l_local: LOCAL_B
			l_result: RESULT_B
			l_attribute: ATTRIBUTE_B
			l_feature: FEATURE_I
			l_target_name: STRING

			l_target, l_source: IV_EXPRESSION
			l_assignment: IV_ASSIGNMENT
		do
			set_current_origin_information (a_node)

				-- Create target node
			if a_node.target.is_local then
				l_local ?= a_node.target
				check l_local /= Void end
				l_target := entity_mapping.local_ (l_local.position)
			elseif a_node.target.is_result then
				l_result ?= a_node.target
				check l_result /= Void end
				check current_feature.has_return_value end
				l_target := entity_mapping.result_expression
			elseif a_node.target.is_attribute then
				l_attribute ?= a_node.target
				check is_attribute: l_attribute /= Void end

				l_feature := helper.feature_for_call_access (l_attribute, current_type)
				check
					valid_feature: l_feature /= Void
					correct_feature: l_feature.feature_name_id = l_attribute.attribute_name_id
				end
				translation_pool.add_referenced_feature (l_feature, current_type)
				create {IV_HEAP_ACCESS} l_target.make (
					entity_mapping.heap.name,
					entity_mapping.current_entity,
					create {IV_ENTITY}.make (name_translator.boogie_name_for_feature (l_feature, current_type),
					types.generic_type)
				)
			else
				check should_never_happen: False end
			end

				-- Create source node
			process_expression (a_node.source)
			l_source := last_expression

				-- Create assignment node
			create l_assignment.make (l_target, l_source)
			add_statement (l_assignment)
			add_trace_statement (a_node)
		end

	process_check_b (a_node: CHECK_B)
			-- <Precursor>
		local
			l_assert: ASSERT_B
			l_statement: IV_ASSERT
			l_assume: IV_ASSUME
			l_info: IV_ASSERTION_INFORMATION
		do
			if a_node.check_list /= Void then
				from
					a_node.check_list.start
				until
					a_node.check_list.after
				loop
					l_assert ?= a_node.check_list.item
					check l_assert /= Void end
					set_current_origin_information (l_assert)

					process_expression (l_assert.expr)
					if attached l_assert.tag and then l_assert.tag.is_case_insensitive_equal ("assume") then
						create l_assume.make (last_expression)
						add_statement (l_assume)
					else
						create l_statement.make (last_expression)
						create l_info.make ("check")
						l_info.set_tag (l_assert.tag)
						l_info.set_line (l_assert.line_number)
						l_statement.set_information (l_info)
						add_statement (l_statement)
					end

					a_node.check_list.forth
				end
			end
		end

	process_debug_b (a_node: DEBUG_B)
			-- Process `a_node'.
		do
			if a_node.compound /= Void then
					-- This debug clause is activated
				process_compound (a_node.compound)
			else
					-- This debug clause is not activated
				-- TODO: what to do?
			end
		end

	process_guard_b (a_node: GUARD_B)
			-- Process `a_node'.
		do
			process_check_b (a_node)
			if a_node.compound /= Void then
				process_compound (a_node.compound)
			end
		end

	process_if_b (a_node: IF_B)
			-- <Precursor>
		local
			l_if: IV_CONDITIONAL
			l_nested_if: IV_CONDITIONAL
			l_elseif: ELSIF_B
			l_temp_block: IV_BLOCK
		do
			set_current_origin_information (a_node)

			l_temp_block := current_block

				-- if condition
			process_expression (a_node.condition)
			create l_if.make (last_expression)
			add_statement (l_if)

				-- then block
			current_block := l_if.then_block
			process_compound (a_node.compound)

				-- elseif blocks
			current_block := l_if.else_block
			if a_node.elsif_list /= Void then
				from
					a_node.elsif_list.start
				until
					a_node.elsif_list.after
				loop
					l_elseif ?= a_node.elsif_list.item
					check l_elseif /= Void end
					set_current_origin_information (l_elseif)

						-- elseif condition
					process_expression (l_elseif.expr)
					create l_nested_if.make (last_expression)
					add_statement (l_nested_if)

						-- elseif block
					current_block := l_nested_if.then_block
					process_compound (l_elseif.compound)

						-- else block
					current_block := l_nested_if.else_block

					a_node.elsif_list.forth
				end
			end

				-- else block
			if a_node.else_part /= Void then
				process_compound (a_node.else_part)
			end

				-- restore context
			current_block := l_temp_block
		end

	process_inspect_b (a_node: INSPECT_B)
			-- <Precursor>
		local
			l_case: CASE_B
			l_temp_block, l_head_block, l_else_block, l_end_block: IV_BLOCK
			l_case_blocks: ARRAY [IV_BLOCK]
			l_case_conditions: ARRAY [IV_EXPRESSION]
			l_index: INTEGER
			l_entity: IV_ENTITY
			l_condition, l_lower, l_upper: IV_EXPRESSION
			l_binary: IV_BINARY_OPERATION
			l_assign: IV_ASSIGNMENT
			l_assume: IV_ASSUME
			l_goto: IV_GOTO
		do
			set_current_origin_information (a_node)

			l_temp_block := current_block
			create l_head_block.make
			create l_else_block.make_name (helper.unique_identifier ("inspect_else"))
			create l_end_block.make_name (helper.unique_identifier ("inspect_end"))

			create l_case_blocks.make_empty
			create l_case_conditions.make_empty

			create l_entity.make (helper.unique_identifier ("switch"), types.int)
			current_implementation.add_local (l_entity.name, types.int)

			set_current_block (l_head_block)
			process_expression (a_node.switch)
			create l_assign.make (l_entity, last_expression)
			add_statement (l_assign)

			if a_node.case_list /= Void then
				from
					a_node.case_list.start
				until
					a_node.case_list.after
				loop
					l_index := a_node.case_list.index
					l_case ?= a_node.case_list.item
					check l_case /= Void end

					if l_case.interval /= Void and then not l_case.interval.is_empty then
						from
							l_condition := Void
							l_case.interval.start
						until
							l_case.interval.after
						loop
							process_contract_expression (l_case.interval.item.lower)
							l_lower := last_expression
								-- TODO: check side effect
							process_contract_expression (l_case.interval.item.upper)
							l_upper := last_expression
								-- TODO: check side effect

							l_binary := factory.and_ (
								factory.less_equal (l_lower, l_entity),
								factory.less_equal (l_entity, l_upper))

							if l_condition = Void then
								l_condition := l_binary
							else
								l_condition := factory.or_ (l_condition, l_binary)
							end

							l_case.interval.forth
						end
					else
						create {IV_VALUE} l_condition.make ("false", types.bool)
					end

					set_current_origin_information (l_case)

					l_case_blocks.force (create {IV_BLOCK}.make_name (helper.unique_identifier ("inspect_case")), l_index)
					set_current_block (l_case_blocks.item (l_index))
					create l_assume.make (l_condition)
					add_statement (l_assume)
					process_compound (l_case.compound)
					create l_goto.make (l_end_block)
					add_statement (l_goto)

					l_case_conditions.force (l_condition, l_index)

					a_node.case_list.forth
				end
			end

				-- Else part
			set_current_block (l_else_block)
			across l_case_conditions as i loop
				create l_assume.make (factory.not_ (i.item))
				add_statement (l_assume)
			end
			if a_node.else_part /= Void then
				process_compound (a_node.else_part)
			end
			create l_goto.make (l_end_block)
			add_statement (l_goto)

				-- Switch in head
			set_current_block (l_head_block)
			create l_goto.make (l_else_block)
			across l_case_blocks as i loop
				l_goto.add_target (i.item)
			end
			add_statement (l_goto)

				-- Add blocks
			set_current_block (l_temp_block)
			add_statement (l_head_block)
			across l_case_blocks as i loop
				add_statement (i.item)
			end
			add_statement (l_else_block)
			add_statement (l_end_block)
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- <Precursor>
		do
			set_current_origin_information (a_node)
				-- Instruction call is in the side effect of the expression,
				-- so the generated expression itself is ignored.
			process_expression (a_node.call)
			add_trace_statement (a_node)
		end

	process_loop_b (a_node: LOOP_B)
			-- <Precursor>
		do
			if options.is_automatic_loop_unrolling_enabled and a_node.invariant_part = Void then
				process_loop_unrolled (a_node)
			else
				process_loop_normal (a_node)
			end
		end

	process_loop_normal (a_node: LOOP_B)
			-- Process loop in normal way.
		local
			l_condition: IV_EXPRESSION
			l_variant_local: STRING
			l_invariant: ASSERT_B
			l_goto: IV_GOTO
			l_temp_block, l_head_block, l_body_block, l_end_block: IV_BLOCK
			l_assert: IV_ASSERT
			l_assume: IV_ASSUME
			l_not: IV_UNARY_OPERATION
			l_op: IV_BINARY_OPERATION
			l_variant: IV_ENTITY
			l_assignment: IV_ASSIGNMENT
		do
			set_current_origin_information (a_node)

			l_temp_block := current_block
			create l_head_block.make_name (helper.unique_identifier("loop_head"))
			create l_body_block.make_name (helper.unique_identifier("loop_body"))
			create l_end_block.make_name (helper.unique_identifier("loop_end"))

				-- From part
			if a_node.from_part /= Void then
				a_node.from_part.process (Current)
			end
			create l_goto.make (l_head_block)
			add_statement (l_goto)
			add_statement (l_head_block)
			current_block := l_head_block

				-- Invariants
			if a_node.invariant_part /= Void then
				from
					a_node.invariant_part.start
				until
					a_node.invariant_part.after
				loop
					l_invariant ?= a_node.invariant_part.item
					set_current_origin_information (l_invariant)
					process_contract_expression (l_invariant.expr)
					across last_safety_checks as i loop
						create l_assert.make (i.item.expr)
						l_assert.set_information (i.item.info)
						add_statement (l_assert)
					end
					create l_assert.make (last_expression)
					add_statement (l_assert)
					a_node.invariant_part.forth
				end
			end

				-- Variant
			if a_node.variant_part /= Void then
				set_current_origin_information (a_node.variant_part)
				create l_variant.make (helper.unique_identifier ("variant"), types.int)
				current_implementation.add_local (l_variant.name, types.int)
				process_expression (a_node.variant_part.expr)
				create l_assignment.make (l_variant, last_expression)
				add_statement (l_assignment)
				create l_assert.make (factory.less_equal (factory.int_value (0), l_variant))
				add_statement (l_assert)
			end

				-- Condition
			set_current_origin_information (a_node.stop)
			process_expression (a_node.stop)
			l_condition := last_expression
			create l_goto.make (l_body_block)
			l_goto.add_target (l_end_block)
			add_statement (l_goto)
			current_block := l_temp_block

				-- Body
			add_statement (l_body_block)
			current_block := l_body_block

			create l_assume.make (factory.not_ (l_condition))
			add_statement (l_assume)
			process_compound (a_node.compound)
			if a_node.variant_part /= Void then
				set_current_origin_information (a_node.variant_part)
				process_expression (a_node.variant_part.expr)
				create l_assert.make (factory.less (last_expression, l_variant))
				add_statement (l_assert)
			end
			create l_goto.make (l_head_block)
			add_statement (l_goto)
			current_block := l_temp_block

			add_statement (l_end_block)
			current_block := l_end_block

			create l_assume.make (l_condition)
			add_statement (l_assume)

			current_block := l_temp_block
		end

	process_loop_unrolled (a_node: LOOP_B)
			-- Process loop with unrolling.
		local
			l_condition: IV_EXPRESSION
			l_variant_local: STRING
			l_invariant: ASSERT_B
			l_goto: IV_GOTO
			l_temp_block, l_head_block, l_body_block, l_end_block, l_force_end_block: IV_BLOCK
			l_assert: IV_ASSERT
			l_assume: IV_ASSUME
			l_not: IV_UNARY_OPERATION
			l_op: IV_BINARY_OPERATION
			l_variant: IV_ENTITY
			l_assignment: IV_ASSIGNMENT
			l_unroll_counter: INTEGER
		do
			l_temp_block := current_block

				-- Init condition
			set_current_origin_information (a_node.stop)
			process_expression (a_node.stop)
			l_condition := last_expression

				-- Init variant
			if a_node.variant_part /= Void then
				create l_variant.make (helper.unique_identifier ("variant"), types.int)
				current_implementation.add_local (l_variant.name, types.int)
			end

				-- Init end block
			l_temp_block := current_block
			create l_end_block.make_name (helper.unique_identifier("loop_end"))

				-- From part
			set_current_origin_information (a_node)
			if a_node.from_part /= Void then
				a_node.from_part.process (Current)
			end

				-- Unrolled body
			from
				l_unroll_counter := 1
			until
				l_unroll_counter > options.loop_unrolling_depth
			loop
				create l_head_block.make_name (helper.unique_identifier("loop_head"+l_unroll_counter.out))
				create l_body_block.make_name (helper.unique_identifier("loop_body"+l_unroll_counter.out))

					-- goto head
				create l_goto.make (l_head_block)
				add_statement (l_goto)

					-- head
				current_block := l_temp_block
				add_statement (l_head_block)
				current_block := l_head_block

					-- Invariants
				if a_node.invariant_part /= Void then
					from
						a_node.invariant_part.start
					until
						a_node.invariant_part.after
					loop
						l_invariant ?= a_node.invariant_part.item
						set_current_origin_information (l_invariant)
						process_contract_expression (l_invariant.expr)
						create l_assert.make (last_expression)
						add_statement (l_assert)
						a_node.invariant_part.forth
					end
				end

					-- Variant
				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					process_expression (a_node.variant_part.expr)
					create l_assignment.make (l_variant, last_expression)
					add_statement (l_assignment)
					create l_op.make (l_variant, ">=", create {IV_VALUE}.make ("0", types.int), types.bool)
					create l_assert.make (l_op)
					add_statement (l_assert)
				end

					-- goto end or body
				create l_goto.make (l_body_block)
				l_goto.add_target (l_end_block)
				add_statement (l_goto)

					-- body
				current_block := l_temp_block
				add_statement (l_body_block)
				current_block := l_body_block

				create l_not.make ("!", l_condition, types.bool)
				create l_assume.make (l_not)
				add_statement (l_assume)
				process_compound (a_node.compound)

				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					process_expression (a_node.variant_part.expr)
					create l_op.make (last_expression, "<", l_variant, types.bool)
					create l_assert.make (l_op)
					add_statement (l_assert)
				end

				l_unroll_counter := l_unroll_counter + 1
			end

			if options.is_sound_loop_unrolling_enabled then
				create l_goto.make (l_head_block)
				add_statement (l_goto)
			else
				create l_force_end_block.make_name (helper.unique_identifier("force_end"))
				create l_goto.make (l_force_end_block)
				add_statement (l_goto)

					-- force end
				current_block := l_temp_block
				add_statement (l_force_end_block)
				current_block := l_force_end_block

					-- Invariants
				if a_node.invariant_part /= Void then
					from
						a_node.invariant_part.start
					until
						a_node.invariant_part.after
					loop
						l_invariant ?= a_node.invariant_part.item
						set_current_origin_information (l_invariant)
						process_contract_expression (l_invariant.expr)
						create l_assert.make (last_expression)
						add_statement (l_assert)
						a_node.invariant_part.forth
					end
				end

					-- Variant
				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					current_implementation.add_local (l_variant.name, types.int)
					process_expression (a_node.variant_part.expr)
					create l_assignment.make (l_variant, last_expression)
					add_statement (l_assignment)
					create l_op.make (l_variant, ">=", create {IV_VALUE}.make ("0", types.int), types.bool)
					create l_assert.make (l_op)
					add_statement (l_assert)
				end
			end

				-- end
			current_block := l_temp_block
			add_statement (l_end_block)
			current_block := l_end_block

			create l_assume.make (l_condition)
			add_statement (l_assume)

			current_block := l_temp_block
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		do
			set_current_origin_information (a_node)
				-- Instruction call is in the side effect of the expression,
				-- so the generated expression itself is ignored.
			process_expression (a_node)
			add_trace_statement (a_node)
		end

	process_retry_b (a_node: RETRY_B)
			-- <Precursor>
		local
			l_havoc: IV_HAVOC
		do
			create l_havoc.make (entity_mapping.heap.name)
			l_havoc.set_origin_information (origin_information (a_node))
			current_block.add_statement (l_havoc)
		end

	process_reverse_b (a_node: REVERSE_B)
			-- <Precursor>
		local
			l_havoc: IV_HAVOC
		do
			create l_havoc.make (entity_mapping.heap.name)
			l_havoc.set_origin_information (origin_information (a_node))
			current_block.add_statement (l_havoc)
		end

feature {NONE} -- Implementation

	current_origin_information: detachable IV_STATEMENT_ORIGIN

	set_current_origin_information (a_node: BYTE_NODE)
			-- Set origin information to be used by first side effect or statement generated.
		do
			current_origin_information := origin_information (a_node)
		end

	origin_information (a_node: BYTE_NODE): IV_STATEMENT_ORIGIN
			-- Origin information of node `a_node'.
		local
			l_error: BOOLEAN
		do
			if l_error then
				create Result
				Result.set_file (current_feature.written_class.file_name)
				Result.set_line (-1)
			else
				create Result
				Result.set_file (current_feature.written_class.file_name)
				Result.set_line (a_node.line_number)
			end
		rescue
				-- a_node.line_number might result in a postcondition violation
			l_error := True
			retry
		end

	add_statement (a_statement: IV_STATEMENT)
			-- Add statement and possibly add origin information.
		do
			if attached current_origin_information as coi then
				a_statement.set_origin_information (coi)
				current_origin_information := Void
			end
			current_block.add_statement (a_statement)
		end

	add_trace_statement (a_node: BYTE_NODE)
			-- Add statement and possibly add origin information.
		do
			current_block.add_statement (factory.trace (name_translator.boogie_name_for_feature (current_feature, current_type) + ":" + a_node.line_number.out))
		end

	process_expression (a_expr: BYTE_NODE)
			-- Process expression `a_expr'.
		local
			l_translator: E2B_BODY_EXPRESSION_TRANSLATOR
		do
			create l_translator.make
			l_translator.set_context (current_feature, current_type)
			l_translator.set_context_implementation (current_implementation)
			l_translator.copy_entity_mapping (entity_mapping)
			l_translator.locals_map.merge (locals_map)
			a_expr.process (l_translator)
			if not l_translator.side_effect.is_empty and attached current_origin_information as coi then
				l_translator.side_effect.first.set_origin_information (coi)
				current_origin_information := Void
			end
			l_translator.side_effect.do_all (agent current_block.add_statement (?))
			last_expression := l_translator.last_expression
			if last_expression = Void then
				last_expression := factory.false_
			end
			locals_map.merge (l_translator.locals_map)
		end

	process_contract_expression (a_expr: BYTE_NODE)
			-- Process expression `a_expr'.
		local
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			create l_translator.make
			l_translator.set_context (current_feature, current_type)
			l_translator.copy_entity_mapping (entity_mapping)
			l_translator.locals_map.merge (locals_map)
			a_expr.process (l_translator)
			last_expression := l_translator.last_expression
			last_safety_checks := l_translator.side_effect
			if last_expression = Void then
				last_expression := factory.false_
			end
			locals_map.merge (l_translator.locals_map)
		end

	last_expression: IV_EXPRESSION
			-- Last generated expression.

	last_safety_checks: LINKED_LIST [TUPLE [expr: IV_EXPRESSION; info: IV_ASSERTION_INFORMATION]]
			-- List of last generated safety checks.

	locals_map: HASH_TABLE [IV_EXPRESSION, INTEGER]
			-- Mapping for object test locals.

end
