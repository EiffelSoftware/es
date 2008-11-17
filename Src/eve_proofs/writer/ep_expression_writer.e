indexing
	description:
		"[
			Boogie code writer to generate expressions
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_EXPRESSION_WRITER

inherit

	EP_VISITOR
		redefine
			process_attribute_b,
			process_argument_b,
			process_bin_and_b,
			process_bin_and_then_b,
			process_bin_div_b,
			process_bin_eq_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
			process_bin_minus_b,
			process_bin_ne_b,
			process_bin_mod_b,
			process_bin_or_b,
			process_bin_or_else_b,
			process_bin_plus_b,
			process_bin_power_b,
			process_bin_slash_b,
			process_bin_star_b,
			process_bin_xor_b,
			process_bit_const_b,
			process_bool_const_b,
			process_char_const_b,
			process_constant_b,
			process_current_b,
			process_creation_expr_b,
			process_feature_b,
			process_int_val_b,
			process_int64_val_b,
			process_integer_constant,
			process_local_b,
			process_nat64_val_b,
			process_nat_val_b,
			process_nested_b,
			process_paran_b,
			process_result_b,
			process_routine_creation_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_void_b
		end

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_mapper: !EP_NAME_MAPPER)
			-- Initialize expression writer with `a_mapper'.
		do
			name_mapper := a_mapper
			create expression.make
			create side_effect.make
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} locals.make
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

feature -- Access

	name_mapper: !EP_NAME_MAPPER
			-- Name mapper used to create Boogie code names

	old_handler: !EP_OLD_HANDLER
			-- Handler for old expressions

	expression: !EP_OUTPUT_BUFFER
			-- Output produced from expression

	side_effect: !EP_OUTPUT_BUFFER
			-- Side effect instructions

	locals: LIST [TUPLE [name: STRING; type: STRING]]
			-- List of locals needed for side effects

feature -- Element change

	set_name_mapper (a_mapper: like name_mapper)
			-- Set `name_mapper' to `a_name_mapper'.
		do
			name_mapper := a_mapper
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

	reset
			-- Reset expression writer for a new expression.
		do
			expression.reset
			side_effect.reset
			side_effect.set_indentation ("    ")
			locals.wipe_out
		end

feature {BYTE_NODE} -- Visitors

	process_argument_b (a_node: ARGUMENT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.argument_name (a_node))
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- Process `a_node'.
		local
			l_feature: !FEATURE_I
			l_field_name, l_function_name: STRING
		do
			l_feature ?= system.class_of_id (a_node.written_in).feature_of_feature_id (a_node.attribute_id)

--			l_field_name := name_generator.attribute_name (l_feature)
--			expression.put (name_mapper.heap_name + "[" + name_mapper.current_name + ", " + l_field_name + "]")

				-- TODO: compute side effect
			l_function_name := name_generator.functional_feature_name (l_feature)
			expression.put (l_function_name + "(" + name_mapper.heap_name + ", " + name_mapper.current_name + ")")
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" && ")
			safe_process (a_node.right)
		end

	process_bin_div_b (a_node: BIN_DIV_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" / ")
			safe_process (a_node.right)
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" == ")
			safe_process (a_node.right)
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" >= ")
			safe_process (a_node.right)
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" > ")
			safe_process (a_node.right)
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- Process `a_node'.
		do
			expression.put ("(")
			safe_process (a_node.left)
			expression.put (") ==> (")
			safe_process (a_node.right)
			expression.put (")")
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" <= ")
			safe_process (a_node.right)
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" < ")
			safe_process (a_node.right)
		end

	process_bin_minus_b (a_node: BIN_MINUS_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" - ")
			safe_process (a_node.right)
		end

	process_bin_mod_b (a_node: BIN_MOD_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" %% ")
			safe_process (a_node.right)
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" != ")
			safe_process (a_node.right)
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" || ")
			safe_process (a_node.right)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" + ")
			safe_process (a_node.right)
		end

	process_bin_power_b (a_node: BIN_POWER_B)
			-- Process `a_node'.
		do
			expression.put ("power(")
			safe_process (a_node.left)
			expression.put (", ")
			safe_process (a_node.right)
			expression.put (")")
		end

	process_bin_slash_b (a_node: BIN_SLASH_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" / ")
			safe_process (a_node.right)
		end

	process_bin_star_b (a_node: BIN_STAR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" * ")
			safe_process (a_node.right)
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expression.put (" != ")
			safe_process (a_node.right)
		end

	process_bit_const_b (a_node: BIT_CONST_B)
			-- Process `a_node'.
		do
			-- TODO: add error
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- Process `a_node'.
		do
			if a_node.value then
				expression.put ("true")
			else
				expression.put ("false")
			end
		end

	process_char_const_b (a_node: CHAR_CONST_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.code.out)
		end

	process_constant_b (a_node: CONSTANT_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.string_value)
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_creation_routine_name: STRING
			l_local_name: STRING
			l_type: CL_TYPE_A
		do
			l_type ?= a_node.type
			l_feature := system.class_of_id (l_type.class_id).feature_of_feature_id (a_node.call.feature_id)
			check l_feature /= Void end
			l_attached_feature ?= l_feature

			feature_list.record_creation_routine_needed (l_attached_feature)
			l_creation_routine_name := name_generator.creation_routine_name (l_attached_feature)

				-- TODO: create new local, register local, add arguments
			l_local_name := "c";

			side_effect.put_comment_line ("Object creation")
			side_effect.put_line ("havoc " + l_local_name + ";")
			side_effect.put_line ("assume !" + name_mapper.heap_name + "[" + l_local_name + ", $allocated] && " + l_local_name + " != null;")
			side_effect.put_line (l_local_name + " := call " + l_creation_routine_name + "(" + l_local_name + ");")

			expression.put (l_local_name)
		end

	process_current_b (a_node: CURRENT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.current_name)
		end

	process_feature_b (a_node: FEATURE_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_creation_routine_name: STRING
		do
			l_feature := system.class_of_id (a_node.written_in).feature_of_feature_id (a_node.feature_id)
			check l_feature /= Void end
			l_attached_feature ?= l_feature

			feature_list.record_feature_needed (l_feature)
			-- TODO
		end

	process_int64_val_b (a_node: INT64_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_int_val_b (a_node: INT_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_integer_constant (a_node: INTEGER_CONSTANT)
			-- Process `a_node'.
		do
			expression.put (a_node.integer_64_value.out)
		end

	process_local_b (a_node: LOCAL_B)
			-- Process `a_node'.
		do
			expression.put (name_generator.local_name (a_node.position))
		end

	process_nat64_val_b (a_node: NAT64_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_nat_val_b (a_node: NAT_VAL_B)
			-- Process `a_node'.
		do
			expression.put (a_node.value.out)
		end

	process_nested_b (a_node: NESTED_B)
			-- Process `a_node'.
		local
			l_temp_expression: STRING
			l_current_name: STRING
		do
				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate target with fresh expression
			expression.reset
			safe_process (a_node.target)
				-- Use target as new `Current' reference
			l_current_name := name_mapper.current_name
			name_mapper.set_current_name (expression.string)
				-- Evaluate message with original expression
			expression.reset
			expression.put (l_temp_expression)
			safe_process (a_node.message)
				-- Restore `Current' reference
			name_mapper.set_current_name (l_current_name)

			-- TODO
--			-- First, store the expr somewhere
--			tmp_expr := expr
--			-- Evatuate the target expression
--			expr := ""
--			safe_process (a_node.target)
--			-- Safe the current_this_ref
--			tmp_this_ref := current_this_ref
--			-- Make the target expression the this expression
--			current_this_ref := expr
--			-- Restore the expr
--			expr := tmp_expr
--			-- Call the actual query
--			safe_process (a_node.message)
--			-- Restore the this expression to its original value
--			current_this_ref := tmp_this_ref
		end

	process_paran_b (a_node: PARAN_B)
			-- Process `a_node'.
		do
			expression.put ("(")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_result_b (a_node: RESULT_B)
			-- Process `a_node'.
		do
			expression.put (name_mapper.result_name)
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B)
			-- Process `a_node'.
		do
			-- TODO
		end

	process_un_minus_b (a_node: UN_MINUS_B)
			-- Process `a_node'.
		do
			expression.put ("( -")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- Process `a_node'.
		do
			expression.put ("( !")
			safe_process (a_node.expr)
			expression.put (")")
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- Process `a_node'.
		do
			-- TODO: use old handler
		end

	process_void_b (a_node: VOID_B)
			-- Process `a_node'.
		do
			expression.put ("null")
		end

end
