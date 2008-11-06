indexing
	description: "Write out the functional definition for functions"
	author: "Bernd Schoeller, Raphael Mack"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_FUNCTION_WRITER

inherit
	BPL_BN_ITERATOR
		redefine
			make,
			process_bin_ne_b,
			process_bin_eq_b,
			process_integer_constant,
			process_attribute_b,
			process_result_b,
			process_argument_b,
			process_bin_and_b,
			process_bin_and_then_b,
			process_bin_div_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
			process_bin_minus_b,
			process_bin_mod_b,
			process_bin_or_b,
			process_bin_or_else_b,
			process_bin_plus_b,
			process_bin_power_b,
			process_bin_slash_b,
			process_bin_star_b,
			process_bin_xor_b,
			process_bit_const_b,
			process_byte_code,
			process_bool_const_b,
			process_char_const_b,
			process_constant_b,
			process_current_b,
			process_creation_expr_b,
			process_feature_b,
			process_int64_val_b,
			process_int_val_b,
			process_local_b,
			process_nat64_val_b,
			process_nat_val_b,
			process_nested_b,
			process_paran_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_void_b,
			process_feature_without_code,
			process_routine_creation_b
		end

create
	make

feature -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Initialize.
		do
			Precursor {BPL_BN_ITERATOR} (a_class)
			argument_prefix := once "arg."
			reset
		end

feature -- Main

	write_function (a_function: FEATURE_I) is
			-- Write the definition of the function pointed to by `a_function'.
		require
			as_not_void: a_function /= Void
		local
			feat_name: STRING
			func_name: STRING
			arg_name: STRING
			arg_type: TYPE_A
			return_type: STRING
			byte_code: BYTE_CODE
			i: INTEGER
			feat: FEATURE_I
			parents: FIXED_LIST[CLASS_C]
			last_current_class: EIFFEL_CLASS_C
			precursor_call: STRING
		do
			last_current_class := current_class
			set_current_feature (a_function)
			if byte_server.has (current_feature.code_id) then
				byte_code := byte_server.disk_item (current_feature.code_id)
			end

			set_this_ref ("C")
			set_heap_ref ("H")

			feat_name := bpl_mangled_feature_name (a_function.feature_name)
			func_name := "fun." + current_class.name + "." + feat_name
			return_type := bpl_type_for_type_a (a_function.type)
			bpl_out ("// Function: " + a_function.feature_name + " of class " + current_class.name + "%N")
			bpl_out ("function ")
			bpl_out (func_name)
			bpl_out ("([ref, <x>name]x, ")
			bpl_out (bpl_type_for_class (current_class))
			result_call := func_name + "(H, C"

			from
				i := 1
			until
				i > a_function.argument_count
			loop
				arg_name := a_function.arguments.item_name (i)
				arg_type := a_function.arguments.i_th (i)
				bpl_out (", ")
				bpl_out (argument_prefix)
				bpl_out (arg_name)
				bpl_out (":")
				bpl_out (bpl_type_for_type_a (arg_type))
				result_call.append (", ")
				result_call.append (argument_prefix)
				result_call.append (arg_name)

				i := i + 1
			end

			bpl_out (") returns (" + return_type + ");%N")
			result_call.append (")")
			intro := "forall H:[ref, <x>name]x, C:ref"

			from
				i := 1
			until
				i > a_function.argument_count
			loop
				arg_name := a_function.arguments.item_name (i)
				arg_type := a_function.arguments.i_th (i)
				intro.append (", ")
				intro.append (argument_prefix)
				intro.append (arg_name)
				intro.append (":")
				intro.append (bpl_type_for_type_a (arg_type))
				i := i + 1
			end

			process_feature_i (current_feature) -- generate assertions

			-- tie result to inherited result
			parents := current_feature.written_class.parents_classes
			if parents /= Void then
				from
					parents.start
				until
					parents.after
				loop
					feat := system.class_of_id (parents.item.class_id).feature_of_rout_id (current_feature.rout_id_set.first)
					if feat /= Void then
						bpl_out ("// feat = " + feat.feature_name + "%N")
						bpl_out ("  axiom (")
						bpl_out (intro)
						bpl_out (" :: ")
						bpl_out (result_call)
						bpl_out (" == ")

						bpl_out ("fun." + parents.item.name + "." + feat.feature_name + "(H, C")
						from
							i := 1
						until
							i > a_function.argument_count
						loop
							arg_name := a_function.arguments.item_name (i)
							arg_type := a_function.arguments.i_th (i)
							bpl_out (", ")
							bpl_out (argument_prefix)
							bpl_out (arg_name)
							i := i + 1
						end

						bpl_out ("));%N")
					else
						bpl_out ("// no feature for " + current_feature.feature_name + " in class " + parents.item.name +"%N")
					end
					parents.forth
				end
			else
				bpl_out ("// no parents for this feature%N")
			end

			if a_function.written_class /= last_current_class then
				feat_name := bpl_mangled_feature_name (a_function.feature_name)
				func_name := "fun." + last_current_class.name + "." + feat_name
				return_type := bpl_type_for_type_a (a_function.type)
				bpl_out ("%Nfunction ")
				bpl_out (func_name)
				bpl_out ("([ref, <x>name]x, ")
				bpl_out (bpl_type_for_class (last_current_class))

				precursor_call := result_call
				result_call := func_name + "(H, C"

				from
					i := 1
				until
					i > a_function.argument_count
				loop
					arg_name := a_function.arguments.item_name (i)
					arg_type := a_function.arguments.i_th (i)
					bpl_out (", ")
					bpl_out (argument_prefix)
					bpl_out (arg_name)
					bpl_out (":")
					bpl_out (bpl_type_for_type_a (arg_type))
					result_call.append (", ")
					result_call.append (argument_prefix)
					result_call.append (arg_name)

					i := i + 1
				end

				bpl_out (") returns (" + return_type + ");%N")
				result_call.append (")")

				bpl_out ("  axiom (")
				bpl_out (intro)
				bpl_out (" :: ")
				bpl_out (result_call)
				bpl_out (" == ")
				bpl_out (precursor_call)
				bpl_out (");%N")

			end
			bpl_out ("%N")

			current_class := last_current_class
		end

	process_feature_without_code (a_feature: FEATURE_I) is
			-- Process a feature that does not have code.
		do
			if a_feature.is_constant then
				bpl_out ("  axiom (")
				bpl_out (intro)
				bpl_out (":: ")
				bpl_out (result_call)
				bpl_out (" == ")
				bpl_out (current_constant.value.dump)
				bpl_out (");%N")
			end
		end

	process_byte_code (a_node: BYTE_CODE) is
			-- We have to have an extra processor here, as BYTE_CODEs do
			-- not want to be BYTE_NODEs (though they are).
		local
			ass_list: BYTE_LIST[BYTE_NODE]
			precondition: STRING
		do
			precondition := intro.twin
			precondition.append (":: (C != null)")
			ass_list := a_node.precondition
			if ass_list /= Void then
				from
					ass_list.start
				until
					ass_list.off
				loop
					precondition.append (" && (")
					expr := ""
					ass_list.item.process (Current)
					precondition.append (expr)
					precondition.append (")")
					ass_list.forth
				end
			end
			precondition.append (" ==> ")

			ass_list := a_node.postcondition
			if ass_list /= Void then
				from
					ass_list.start
				until
					ass_list.off
				loop
					bpl_out ("  axiom (")
					bpl_out (precondition)
					expr := ""
					ass_list.item.process (Current)
					bpl_out (expr)
					bpl_out (");%N")
					ass_list.forth
				end
			end
		end

feature -- Processing Environment

	result_call: STRING
		-- String to insert for `Result'

	set_result_call (a_string: STRING) is
			-- Set the text to insert on a Result to `a_string'.
		require
			not_void: a_string /= Void
		do
			result_call := a_string
		ensure
			value_set: result_call = a_string
		end

	heap_ref: STRING

	set_heap_ref (a_string: STRING) is
			-- Set the text to insert on a Heap reference.
		require
			not_void: a_string /= Void
		do
			heap_ref := a_string
		ensure
			value_set: heap_ref = a_string
		end

	this_ref: STRING
	current_this_ref: STRING

	set_this_ref (a_string: STRING) is
			-- Set the text to insert on a reference to the current object.
		require
			not_void: a_string /= Void
		do
			this_ref := a_string
			current_this_ref := this_ref
		ensure
			value_set: this_ref = a_string
		end

	argument_prefix: STRING

	set_argument_prefix (a_string: STRING) is
			-- Set the text to appended to argument names
		require
			not_void: a_string /= Void
		do
			argument_prefix := a_string
		ensure
			value_set: argument_prefix = a_string
		end


feature -- Result and side-effects

	expr: STRING
		-- Expression output

	side_effect: STRING
		-- Set of instructions that minic the side-effect

	local_vars: STRING
		-- Set of local variables needed for the evaluation of the expression

	record_local_var (a_name: STRING; a_bpl_type: STRING) is
			-- Record the need of a temp variable `a_name' of `a_bpl_type'
		do
			local_vars.append ("  var ")
			local_vars.append (a_name)
			local_vars.append (":")
			local_vars.append (a_bpl_type)
			local_vars.append (";%N")
		end

	reset is
			-- Reset the result and side-effects to process a new function
		do
			expr := ""
			local_vars := ""
			side_effect := ""
			used_arguments := create {ARRAYED_LIST[STRING]}.make (0)
		ensure
			expr_reset: expr.is_equal ("")
			local_vars_reset: local_vars.is_equal ("")
			side_effect_reset: side_effect.is_equal ("")
			used_arguemnts_reset: used_arguments /= Void and then used_arguments.count = 0
		end

	intro: STRING
			-- first part of the assertions ("forall ...")

	used_arguments: LIST[STRING]
			-- names of used arguments, including prefix

feature -- Processing

	process_argument_b (a_node: ARGUMENT_B) is
			-- Process `a_node'.
		local
			name: STRING
		do
			name := current_feature.arguments.item_name (a_node.position)
			expr.append (argument_prefix)
			expr.append (name)
			used_arguments.extend (argument_prefix + name)
		end

	process_attribute_b (a_node: ATTRIBUTE_B) is
			-- Process `a_node'.
		local
			var: STRING
			new_side_effect: STRING
			new_code: STRING
		do
			-- Compute Side-Effect
			new_label ("attr")
			var := last_label
			new_side_effect := "    call "
			new_side_effect.append (var)
			new_side_effect.append (" := proc.")
			new_side_effect.append (System.class_of_id(a_node.written_in).name)
			new_side_effect.append (".")
			new_side_effect.append (a_node.attribute_name)
			new_side_effect.append ("(")
			new_side_effect.append (current_this_ref)
			new_side_effect.append (")")
			new_side_effect.append ("; ")
			new_side_effect.append (location_info (a_node))
			side_effect.append (new_side_effect)
			record_local_var (var, bpl_type_for_type_a (a_node.type))

			-- Compute function call
			new_code := "fun."
			new_code.append (System.class_of_id(a_node.written_in).name)
			new_code.append (".")
			new_code.append (a_node.attribute_name)
			new_code.append ("(")
			new_code.append (heap_ref)
			new_code.append (", ")
			new_code.append (current_this_ref)
			new_code.append (")")
			expr.append (new_code)
		end

	process_bin_and_b (a_node: BIN_AND_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" && ")
			safe_process (a_node.right)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" && ")
			safe_process (a_node.right)
		end

	process_bin_div_b (a_node: BIN_DIV_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" / ")
			safe_process (a_node.right)
		end

	process_bin_eq_b (a_node: BIN_EQ_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append (" == ")
			safe_process (a_node.right)
		end

	process_bin_ge_b (a_node: BIN_GE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" >= ")
			safe_process (a_node.right)
		end

	process_bin_gt_b (a_node: BIN_GT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" > ")
			safe_process (a_node.right)
		end

	process_bin_implies_b (a_node: B_IMPLIES_B) is
			-- Process `a_node'.
		do
			expr.append("(")
			safe_process (a_node.left)
			expr.append(") ==> (")
			safe_process (a_node.right)
			expr.append(")")
		end

	process_bin_le_b (a_node: BIN_LE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" <= ")
			safe_process (a_node.right)
		end

	process_bin_lt_b (a_node: BIN_LT_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" < ")
			safe_process (a_node.right)
		end

	process_bin_minus_b (a_node: BIN_MINUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" - ")
			safe_process (a_node.right)
		end

	process_bin_mod_b (a_node: BIN_MOD_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" %% ")
			safe_process (a_node.right)
		end

	process_bin_ne_b (a_node: BIN_NE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append (" != ")
			safe_process (a_node.right)
		end

	process_bin_or_b (a_node: BIN_OR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" || ")
			safe_process (a_node.right)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" || ")
			safe_process (a_node.right)
		end

	process_bin_plus_b (a_node: BIN_PLUS_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" + ")
			safe_process (a_node.right)
		end

	process_bin_power_b (a_node: BIN_POWER_B) is
			-- Process `a_node'.
		do
			expr.append("power(")
			safe_process (a_node.left)
			expr.append(",")
			safe_process (a_node.right)
			expr.append(")")
		end

	process_bin_slash_b (a_node: BIN_SLASH_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" / ")
			safe_process (a_node.right)
		end

	process_bin_star_b (a_node: BIN_STAR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" * ")
			safe_process (a_node.right)
		end

	process_bin_xor_b (a_node: BIN_XOR_B) is
			-- Process `a_node'.
		do
			safe_process (a_node.left)
			expr.append(" != ")
			safe_process (a_node.right)
		end

	process_bit_const_b (a_node: BIT_CONST_B) is
			-- Process `a_node'.
		local
			error: BPL_ERROR
		do
			create error.make ("Bit constants are not supported")
			add_error (error)
		end

	process_bool_const_b (a_node: BOOL_CONST_B) is
			-- Process `a_node'.
		do
			if a_node.value then
				expr.append("true")
			else
				expr.append("false")
			end
		end

	process_char_const_b (a_node: CHAR_CONST_B) is
			-- Process `a_node'.
		do
			expr.append(a_node.value.code.out)
			-- TODO: how a CHARACTERS handled?
		end

	process_constant_b (a_node: CONSTANT_B) is
			-- Process `a_node'.
		do
			expr.append(a_node.value.string_value)
		end

	process_current_b (a_node: CURRENT_B) is
			-- Process `a_node'.
		do
			expr.append(this_ref)
		end

	process_feature_b (a_node: FEATURE_B) is
			-- Process `a_node'.
		local
			cls_name: STRING
		do
			cls_name := System.class_of_id(a_node.written_in).name

			if Agent_classes.has (cls_name) then
				process_feature_b_for_agents (a_node)
			else
				process_feature_b_normal (a_node)
			end

		end

	process_feature_b_for_agents (a_node: FEATURE_B) is
			-- Process `a_node'.
		local
			l_feature_name: STRING
			l_boogie_function: STRING
			l_open_argument_count: INTEGER
			l_tuple_argument: TUPLE_CONST_B
			l_tuple_content: BYTE_LIST [BYTE_NODE]
			l_args: STRING
			tmp_expr: STRING
			tmp_this_ref: STRING
			i: INTEGER
		do
			l_feature_name := a_node.feature_name

			check a_node.parameters.count = 1 end
			l_tuple_argument ?= a_node.parameters [1].expression
			check l_tuple_argument /= Void end
			l_tuple_content := l_tuple_argument.expressions
			l_open_argument_count := l_tuple_content.count
			l_boogie_function := "agent." + l_feature_name + "_" + l_open_argument_count.out

				-- Construct arguments
			l_args := ""
			if l_feature_name.is_equal ("precondition") then
				l_args := "Heap"
			elseif l_feature_name.is_equal ("postcondition") then
				l_args := "Heap, old(Heap)"
			elseif l_feature_name.is_equal ("call") then
				check false end
			else
				check false end
			end

			tmp_expr := expr
			tmp_this_ref := current_this_ref

			current_this_ref := this_ref
			expr := ""
			safe_process (a_node.parent.target)
			l_args.append (", ")
			l_args.append(expr)

			from
				i := 1
			until
				i > l_tuple_content.count
			loop
				current_this_ref := this_ref
				expr := ""
				safe_process (l_tuple_content.i_th (i))
				l_args.append (", ")
				l_args.append(expr)
				i := i + 1
			end
			current_this_ref := tmp_this_ref
			expr := tmp_expr

			expr.append (l_boogie_function)
			expr.append ("(")
			expr.append (l_args)
			expr.append (")")
		end

	process_feature_b_normal (a_node: FEATURE_B) is
			-- Process `a_node'.
		local
			var: STRING
			i: INTEGER
			args: STRING
			side_effect_args: STRING
			tmp_expr: STRING
			tmp_this_ref: STRING
			new_code: STRING
			new_side_effect: STRING
			cls_name: STRING
			special_call: BOOLEAN
		do
			cls_name := System.class_of_id(a_node.written_in).name
			special_call := Mapping_table.item (cls_name) /= Void


			args := ""
			if not special_call then
				args.append (heap_ref)
				args.append (", ")
			end

			args.append (current_this_ref)
			side_effect_args := ""
			side_effect_args.append (current_this_ref)

			tmp_expr := expr
			tmp_this_ref := current_this_ref
			if a_node.parameters /= Void then
				from
					i := 1
				until
					i > a_node.parameters.count
				loop
					current_this_ref := this_ref
					expr := ""
					safe_process (a_node.parameters.i_th (i))
					args.append (", ")
					args.append(expr)
					side_effect_args.append (", ")
					side_effect_args.append(expr)
					i := i + 1
				end
			end
			current_this_ref := tmp_this_ref
			expr := tmp_expr

			if special_call then
				-- Call on special classes
				new_code := ""
				new_code.append(Mapping_table.item (cls_name))
				new_code.append(".")
				new_code.append(a_node.feature_name)
			else
				-- Not special calls have potential side-effects
				new_label ("zwerg")
				var := last_label
				record_local_var (var, bpl_type_for_type_a (a_node.type))
				new_side_effect := "    call "
				new_side_effect.append (var)
				new_side_effect.append (" := proc.")
				new_side_effect.append (cls_name)
				new_side_effect.append (".")
				new_side_effect.append (a_node.feature_name)
				new_side_effect.append ("(")
				new_side_effect.append (side_effect_args)
				new_side_effect.append (")")
				new_side_effect.append ("; ")
				new_side_effect.append (location_info (a_node))
				side_effect.append (new_side_effect)

				-- Call on regular classes
				new_code := "fun."
				new_code.append (cls_name)
				new_code.append (".")
				new_code.append (a_node.feature_name)
			end
			new_code.append ("(")
			new_code.append (args)
			new_code.append (")")
			expr.append (new_code)
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B) is
			-- Process `a_node'.
		do
				-- Store new locals in here
			local_vars.append ("")
				-- Store side effects in here
			side_effect.append ("")
				-- Store expression which is assigned in here
			expr.append ("TODO")
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B) is
			-- Process `a_node'.
		local
			l_agent_variable: STRING
			l_agent_feature_name: STRING
			l_agent_class: CLASS_C
			l_agent_feature: FEATURE_I
			l_target_name: STRING
			l_open_argument_count: INTEGER
			l_byte_code: BYTE_CODE
			l_precondition: STRING
			l_postcondition: STRING
		do
			l_agent_variable := "l_agent"
			l_agent_class := system.class_of_id (a_node.origin_class_id)
			l_agent_feature := l_agent_class.feature_of_feature_id (a_node.feature_id)
			l_agent_feature_name := "feature." + l_agent_class.name_in_upper + "." + l_agent_feature.feature_name

			check a_node.is_target_closed end

			if {l_arg: !ARGUMENT_B} a_node.arguments.expressions[1] then
				l_target_name := "arg." + current_feature.arguments.item_name (l_arg.position)
			else
				check false end
			end

			l_open_argument_count := a_node.arguments.expressions.count

				-- New local for created agent
			record_local_var (l_agent_variable, "ref") -- TODO: "ref" as constant
				-- Store side effects in here
			side_effect.append ("// Create agent%N")
			side_effect.append ("havoc " + l_agent_variable + ";%N")
			side_effect.append ("assume Heap[" + l_agent_variable + ", $allocated] == false && " + l_agent_variable + " != null;%N")
			side_effect.append ("assert ValidCreateTarget(Heap, " + l_agent_variable + ");%N")

			if a_node.is_target_closed then
				side_effect.append ("assert " + l_target_name + " != null;%N")
			end


			side_effect.append ("call agent.create (" + l_agent_variable + ");%N")
    		side_effect.append ("assert ValidCreation(Heap, " + l_agent_variable + ");%N")
			side_effect.append ("assume IsHeap(Heap);%N")

			if byte_server.has (l_agent_feature.code_id) then
				l_byte_code := byte_server.item (l_agent_feature.code_id)
					-- TODO: create precondition / postcondition

				if l_agent_feature_name.is_equal ("feature.FORMATTER.align_left") then
					l_precondition := "a1 != null && !fun.PARAGRAPH.is_left_aligned (heap, a1)"
					l_postcondition := "fun.PARAGRAPH.is_left_aligned(heap, a1)"
				elseif l_agent_feature_name.is_equal ("feature.FORMATTER.align_right") then
					l_precondition := "a1 != null && fun.PARAGRAPH.is_left_aligned (heap, a1)"
					l_postcondition := "!fun.PARAGRAPH.is_left_aligned(heap, a1)"
				else
					check false end
				end

			else
				check false end
			end


			side_effect.append ("// Agent properties%N")
			side_effect.append ("assume (forall heap: [ref, <x>name]x, a1: ref :: %N")
            side_effect.append ("            { agent.precondition_" + l_open_argument_count.out + "(heap, " + l_agent_variable + ", a1) } // Trigger%N")
            side_effect.append ("        IsHeap(heap) ==> (agent.precondition_" + l_open_argument_count.out + "(heap, " + l_agent_variable + ", a1) <==> " + l_precondition + " ));%N")
			side_effect.append ("assume (forall heap: [ref, <x>name]x, old_heap: [ref, <x>name]x, a1: ref :: %N")
			side_effect.append ("            { agent.postcondition_" + l_open_argument_count.out + "(heap, old_heap, " + l_agent_variable + ", a1) } // Trigger%N")
            side_effect.append ("        IsHeap(heap) ==> (agent.postcondition_" + l_open_argument_count.out + "(heap, old_heap, " + l_agent_variable + ", a1) <==> " + l_postcondition + " ));%N")

				-- Store expression which is assigned in here
			expr.append (l_agent_variable)
		end

	process_int64_val_b (a_node: INT64_VAL_B) is
			-- Process `a_node'.
		do
			expr.append(a_node.value.out)
		end

	process_int_val_b (a_node: INT_VAL_B) is
			-- Process `a_node'.
		do
			expr.append(a_node.value.out)
		end

	process_integer_constant (a_node: INTEGER_CONSTANT) is
			-- Process `a_node'.
		do
			expr.append (a_node.integer_64_value.out)
		end

	process_local_b (a_node: LOCAL_B) is
			-- Process `a_node'.
		do
			expr.append ("l" + a_node.position.out)
		end

	process_nat64_val_b (a_node: NAT64_VAL_B) is
			-- Process `a_node'.
		do
			expr.append (a_node.value.out)
		end

	process_nat_val_b (a_node: NAT_VAL_B) is
			-- Process `a_node'.
		do
			expr.append (a_node.value.out)
		end

	process_nested_b (a_node: NESTED_B) is
			-- Process `a_node'.
		local
			tmp_expr: STRING
			tmp_this_ref: STRING
		do
			-- First, store the expr somewhere
			tmp_expr := expr
			-- Evatuate the target expression
			expr := ""
			safe_process (a_node.target)
			-- Safe the current_this_ref
			tmp_this_ref := current_this_ref
			-- Make the target expression the this expression
			current_this_ref := expr
			-- Restore the expr
			expr := tmp_expr
			-- Call the actual query
			safe_process (a_node.message)
			-- Restore the this expression to its original value
			current_this_ref := tmp_this_ref
		end

	process_paran_b (a_node: PARAN_B) is
			-- Process `a_node'.
		do
			expr.append("(")
			safe_process (a_node.expr)
			expr.append(")")
		end

	process_result_b (b_node: RESULT_B) is
			-- Process `b_node'.
		do
			expr.append (result_call)
		end

	process_un_minus_b (a_node: UN_MINUS_B) is
			-- Process `a_node'.
		do
			expr.append("( -")
			safe_process (a_node.expr)
			expr.append (")")
		end

	process_un_not_b (a_node: UN_NOT_B) is
			-- Process `a_node'.
		do
			expr.append("( !")
			safe_process (a_node.expr)
			expr.append (")")
		end

	process_un_old_b (a_node: UN_OLD_B) is
			-- Process `a_node'.
		do
			expr.append("old(")
			safe_process (a_node.expr)
			expr.append (")")
		end

	process_void_b (a_node: VOID_B) is
			-- Process `a_node'.
		do
			expr.append ("null")
		end

end
