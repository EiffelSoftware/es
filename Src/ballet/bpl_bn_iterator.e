indexing
	description: "Visit every node of a byte node tree"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_ITERATOR

inherit
	BYTE_NODE_VISITOR
	SHARED_SERVER
	SHARED_BPL_ENVIRONMENT


create
	make

feature{NONE} -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Class to process.
		require
			not_void: a_class /= Void
		do
			current_class := a_class
		ensure
			class_set: current_class = a_class
		end

feature -- Main processors

	visit_all_features is
			-- Visit all features of the class.
		local
			feat_table: FEATURE_TABLE
			inv_byte_code: INVARIANT_B
		do
			from
				feat_table := current_class.feature_table
				feat_table.start
			until
				feat_table.after
			loop
				process_feature_i (feat_table.item_for_iteration)
				feat_table.forth
			end

			if inv_byte_server.has (current_class.class_id) then
				bpl_out ("// invariant for class " + current_class.name + "%N")
				inv_byte_code := inv_byte_server.item (current_class.class_id)
				safe_process (inv_byte_code)
			end
		end

feature -- Access

	current_class: EIFFEL_CLASS_C
		-- Current class processed

	current_feature: FEATURE_I
		-- Current feature processed

	current_attribute: ATTRIBUTE_I
		-- Current feature as attribute (if valid)

	current_constant: CONSTANT_I
		-- Current feature as constant (if valid)

	set_current_feature (a_feature: FEATURE_I) is
			-- Set the `current_feature' to `a_feature'.
		require
			not_void: a_feature /= Void
		do
			current_feature := a_feature
			current_attribute ?= a_feature
			current_constant ?= a_feature
			current_class ?= a_feature.written_class
			check
				only_eiffel_classes: current_class /= Void
			end
		ensure
			value_set: current_feature = a_feature
			attribute_set: a_feature.is_attribute implies current_attribute = a_feature
			constant_set: a_feature.is_constant implies current_constant = a_feature
			current_class_set: current_class = a_feature.written_class
		end

	leaf_list: LEAF_AS_LIST
		-- Leaf list from parent iterator

feature -- Setting

	set_leaf_list (a_list: LEAF_AS_LIST)
			-- Setup environment for roundtrip visit.
			-- TODO: Remove me, please, I am not needed when we only work with BYTE_CODE !!
		require
			a_list_not_void: a_list /= Void
		do
			leaf_list := a_list
		end

feature -- Extra Processors

	process_feature_i (a_feature: FEATURE_I) is
			-- Process FEATURE_I.
		require
			not_void: a_feature /= Void
		local
			byte_code: BYTE_CODE
		do
			set_current_feature (a_feature)
			if byte_server.has (current_feature.code_id) then
				byte_code := byte_server.item (current_feature.code_id)
				process_byte_code (byte_code)
			else
				process_feature_without_code (a_feature)
			end
		end

	process_byte_code (a_node: BYTE_CODE) is
			-- We have to have an extra processor here, as BYTE_CODEs do
			-- not want to be BYTE_NODEs (though they are).
		require
			not_void: a_node /= Void
		do
			safe_process (a_node.use_frame)
			safe_process (a_node.modify_frame)
			safe_process (a_node.precondition)
			safe_process (a_node.compound)
			safe_process (a_node.rescue_clause)
			safe_process (a_node.postcondition)
		end

	process_feature_without_code (a_feature: FEATURE_I) is
			-- Process a feature that does not have code.
		do

		end

feature {NONE} -- Supporting Features

	bpl_mangled_operator (op: STRING): STRING is
			-- Operator mangled that it can be used as function name in BPL
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if operator_names_mangled.item (op) /= Void then
				Result := operator_names_mangled.item (op)
			else
				-- Self-defined operator, we just make up a name
				Result := "op$"+operator_names_mangled.count.out
				operator_names_mangled.put (Result, op)
			end
		ensure
			not_void: Result /= Void
		end

	bpl_mangled_feature_name (op: STRING): STRING is
			-- Feature name mangled that it can be used as function name in BPL
		require
			not_void: op /= Void
			not_empty: not op.is_empty
		do
			if op.substring (1, 7).is_equal ("infix %"") then
				Result := bpl_mangled_operator (op.substring (8, op.count-1))
			elseif op.substring (1, 8).is_equal ("prefix %"") then
				Result := bpl_mangled_operator (op.substring (9, op.count-1))
			else
				Result := op
			end
		ensure
			not_void: Result /= Void
		end

	bpl_type_for_type_a (type: TYPE_A): STRING is
			-- Compute the suitable type in BPL for `type'.
		require
			type_not_void: type /= Void
		local
			actual: TYPE_A
			name: STRING
		do
			actual := type
			if actual.has_associated_class then
				name := actual.associated_class.name
			else
				if actual.is_boolean then
					name := "BOOLEAN"
				elseif actual.is_integer or actual.is_character then
					name := "INTEGER_32"
				else
					name := "ANY"
				end
			end
			if mapping_table.item(name) /= Void then
				Result := mapping_table.item (name)
			elseif actual.is_expanded then
				Result := "wrong_type"
				add_error(create {BPL_ERROR}.make("Cannot handle type '"+actual.dump+"' since it's expanded."))
			else
				Result := "ref"
			end
		ensure
			Result_not_void: Result /= Void
		end

--	bpl_type_for_type_i (type: TYPE_I): STRING is
--			-- Compute the suitable type in BPL for `type'.
--		require
--			type_not_void: type /= Void
--		do
--			if mapping_table.item(type.name) /= Void then
--				Result := mapping_table.item (type.name)
--			elseif type.is_expanded then
--				add_error(create {BPL_ERROR}.make("Cannot handle type '" + type.name
--											  + "' since it's expanded."))
--				Result := once "any"
--			else
--				Result := once "ref"
--			end
--		ensure
--			Result_not_void: Result /= Void
--		end

	bpl_type_for_class (a_class: CLASS_C):STRING is
			-- BPL type for class `a_class'.
		require
			not_void: a_class /= Void
		do
			if mapping_table.item(a_class.name) /= Void then
				Result := mapping_table.item (a_class.name)
			elseif a_class.is_expanded then
				add_error(create {BPL_AST_ERROR}.make_ast("Cannot handle type '" + a_class.name
											  + "' since it's expanded.", a_class.ast))
				Result := "any"
			else
				Result := once "ref"
			end
		end

	location_info (pos: BYTE_NODE): STRING is
			-- The information tag for `pos'.
		local
			ass: ASSERT_B
		do
			Result := "// eiffel:"
			Result.append (current_class.name)
			Result.append (";")
			Result.append (pos.line_number.out)
			Result.append (";")
			ass ?= pos
			if ass /= Void and then ass.tag /= Void then
				Result.append (ass.tag)
			end
			Result.append ("%N")
		end

feature {BYTE_NODE} -- Visitors

	process_access_expr_b (a_node: ACCESS_EXPR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_address_b (a_node: ADDRESS_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_argument_b (a_node: ARGUMENT_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_array_const_b (a_node: ARRAY_CONST_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expressions)
		end

	process_assert_b (a_node: ASSERT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_assign_b (a_node: ASSIGN_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.target)
			safe_process (a_node.source)
		end

	process_attribute_b (a_node: ATTRIBUTE_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_bin_and_b (a_node: BIN_AND_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_div_b (a_node: BIN_DIV_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_eq_b (a_node: BIN_EQ_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_free_b (a_node: BIN_FREE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_ge_b (a_node: BIN_GE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_gt_b (a_node: BIN_GT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_implies_b (a_node: B_IMPLIES_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_le_b (a_node: BIN_LE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_lt_b (a_node: BIN_LT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_minus_b (a_node: BIN_MINUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_mod_b (a_node: BIN_MOD_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_ne_b (a_node: BIN_NE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_or_b (a_node: BIN_OR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_power_b (a_node: BIN_POWER_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_slash_b (a_node: BIN_SLASH_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_star_b (a_node: BIN_STAR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bin_xor_b (a_node: BIN_XOR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			safe_process (a_node.right)
		end

	process_bit_const_b (a_node: BIT_CONST_B) is
			-- Process `a_node'.
		do
			-- No subnode
		end

	process_bool_const_b (a_node: BOOL_CONST_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_byte_list (a_node: BYTE_LIST [BYTE_NODE]) is
			-- Process `a_node'.
		local
			i: INTEGER
			c: INTEGER
		do
			from
				i := 1
				c := a_node.count
			until
				i > c
			loop
				safe_process (a_node.i_th (i))
				i := i + 1
			end
		end

	process_case_b (a_node: CASE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.compound)
			safe_process (a_node.interval)
		end

	process_char_const_b (a_node: CHAR_CONST_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_char_val_b (a_node: CHAR_VAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_check_b (a_node: CHECK_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.check_list)
		end

	process_constant_b (a_node: CONSTANT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.call)
		end

	process_current_b (a_node: CURRENT_B) is
			-- Process `a_node'.
		do
			-- No subnode
		end

	process_custom_attribute_b (a_node: CUSTOM_ATTRIBUTE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.creation_expr)
			-- TODO: Names arguments
		end

	process_debug_b (a_node: DEBUG_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.compound)
		end

	process_elsif_b (a_node: ELSIF_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_expr_address_b (a_node: EXPR_ADDRESS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_external_b (a_node: EXTERNAL_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.parameters)
		end

	process_feature_b (a_node: FEATURE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.parameters)
		end

	process_frame_b (a_node: FRAME_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_agent_call_b (a_node: AGENT_CALL_B) is
		do
			safe_process (a_node.parameters)
		end

	process_formal_conversion_b (a_node: FORMAL_CONVERSION_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_hector_b (a_node: HECTOR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.condition)
			safe_process (a_node.compound)
			safe_process (a_node.elsif_list)
			safe_process (a_node.else_part)
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.switch)
			safe_process (a_node.case_list)
			safe_process (a_node.else_part)
		end

	process_instr_call_b (a_node: INSTR_CALL_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.call)
		end

	process_instr_list_b (a_node: INSTR_LIST_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.compound)
		end

	process_int64_val_b (a_node: INT64_VAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_int_val_b (a_node: INT_VAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_integer_constant (a_node: INTEGER_CONSTANT) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_inv_assert_b (a_node: INV_ASSERT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_invariant_b (a_node: INVARIANT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.byte_list)
		end

	process_local_b (a_node: LOCAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.from_part)
			safe_process (a_node.stop)
			safe_process (a_node.invariant_part)
			safe_process (a_node.variant_part)
			safe_process (a_node.compound)
		end

	process_nat64_val_b (a_node: NAT64_VAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_nat_val_b (a_node: NAT_VAL_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_nested_b (a_node: NESTED_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.target)
			safe_process (a_node.message)
		end

	process_once_string_b (a_node: ONCE_STRING_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_operand_b (a_node: OPERAND_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_parameter_b (a_node: PARAMETER_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expression)
		end

	process_paran_b (a_node: PARAN_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_real_const_b (a_node: REAL_CONST_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_require_b (a_node: REQUIRE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_result_b (a_node: RESULT_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_retry_b (a_node: RETRY_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_reverse_b (a_node: REVERSE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.target)
			safe_process (a_node.source)
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B) is
			-- Process `a_node'.
		do
			-- TODO: Do not understand this
		end

	process_string_b (a_node: STRING_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_strip_b (a_node: STRIP_B) is
			-- Process `a_node'.
		do
			-- No Subnode
		end

	process_tuple_access_b (a_node: TUPLE_ACCESS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.source)
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expressions)
		end

	process_type_expr_b (a_node: TYPE_EXPR_B) is
			-- Process `a_node'.
		do
			-- No subnode
		end

	process_typed_interval_b (a_node: TYPED_INTERVAL_B [INTERVAL_VAL_B]) is
			-- Process `a_node'.
		do
			safe_process (a_node.lower)
			safe_process (a_node.upper)
		end

	process_un_free_b (a_node: UN_FREE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_un_minus_b (a_node: UN_MINUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_un_not_b (a_node: UN_NOT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_un_old_b (a_node: UN_OLD_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_un_plus_b (a_node: UN_PLUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.access)
			safe_process (a_node.expr)
		end

	process_variant_b (a_node: VARIANT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.expr)
		end

	process_void_b (a_node: VOID_B) is
			-- Process `a_node'.
		do
			-- No subnode
		end

	process_object_test_b (a_node: OBJECT_TEST_B) is
			-- Process `a_node'.
		do
			-- TODO
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B) is
			-- Process `a_node'.
		do
			-- TODO
		end

	process_bin_tilde_b (a_node: BIN_TILDE_B) is
			-- Process `a_node'.
		do
			-- TODO
		end

	process_bin_not_tilde_b (a_node: BIN_NOT_TILDE_B) is
			-- Process `a_node'.
		do
			-- TODO
		end

	process_std_byte_code (a_node: STD_BYTE_CODE) is
			-- Process `a_node'.
		do
			-- TODO
		end

feature{NONE} -- Tables

	Operator_names_mangled: HASH_TABLE[STRING, STRING] is
			-- Names for simple operators.
		do
			create Result.make(19)
			Result.compare_objects
			Result.put ("op$not","not")
			Result.put ("op$plus","+")
			Result.put ("op$minus","-")
			Result.put ("op$mult","*")
			Result.put ("op$div","/")
			Result.put ("op$less","<")
			Result.put ("op$more",">")
			Result.put ("op$leq","<=")
			Result.put ("op$meq",">=")
			Result.put ("op$divdiv","//")
			Result.put ("op$vidvid","\\")
			Result.put ("op$hat","^")
			Result.put ("op$and","and")
			Result.put ("op$or","or")
			Result.put ("op$xor","xor")
			Result.put ("op$andthen","and then")
			Result.put ("op$orelse","or else")
			Result.put ("op$implies","implies")
		end

	Mapping_table: TABLE[STRING, STRING] is
			-- Table of mappings between Eiffel and BPL types
			-- features for all classes which ware mentioned here will not be generated
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(19)
			Result.compare_objects
			Result.put("ref", "ANY")
			Result.put("int", "INTEGER")
			Result.put("int", "INTEGER_8")
			Result.put("int", "INTEGER_16")
			Result.put("int", "INTEGER_32")
			Result.put("int", "INTEGER_REF")
			Result.put("int", "INTEGER_8_REF")
			Result.put("int", "INTEGER_16_REF")
			Result.put("int", "INTEGER_32_REF")
			Result.put("int", "CHARACTER")
			Result.put("int", "CHARACTER_8")
			Result.put("int", "CHARACTER_32")
			Result.put("int", "CHARACTER_REF")
			Result.put("int", "CHARACTER_8_REF")
			Result.put("int", "CHARACTER_32_REF")
			Result.put("ref", "STRING")
			Result.put("ref", "STRING_8")
			Result.put("ref", "STRING_32")
			Result.put("ref", "ISE_RUNTIME")
			Result.put("ref", "EXCEPTIONS")
			Result.put("ref", "STD_FILES")
			Result.put("ref", "MISMATCH_CORRECTOR")
			Result.put("set", "FRAME")
			Result.put("set", "MML_SET")
			Result.put("set", "MML_DEFAULT_SET")

		end

	Infix_Operator_table: TABLE[STRING, STRING] is
			-- String-Versions of Operators
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(9)
			Result.compare_objects
			Result.put ("==", "=")
			Result.put ("!=", "/=")
			Result.put ("&&","and")
			Result.put ("||","or")
			Result.put ("&&","and then")
			Result.put ("||","or else")
			Result.put ("==>","implies")
		end

	Prefix_Operator_table: TABLE[STRING, STRING] is
			-- String-Versions of Operators
		once
			create {HASH_TABLE[STRING, STRING]}Result.make(9)
			Result.compare_objects
			Result.put ("!","not")
		end

end
