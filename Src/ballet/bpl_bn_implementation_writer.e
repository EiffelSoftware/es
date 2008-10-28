indexing
	description: "Generate the implementation clause for a given feature"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_IMPLEMENTATION_WRITER

inherit

	BPL_BN_ITERATOR
		redefine
			make,
			set_current_feature,
			process_byte_code,
			process_feature_without_code,
			process_assign_b,
			process_check_b,
			process_if_b,
			process_instr_call_b,
			process_loop_b
		end

create
	make

feature -- Initialization
	make (a_class: EIFFEL_CLASS_C) is
		do
			Precursor (a_class)
			create function_writer.make (current_class)

		end

feature -- Generation

	write_implementation (a_feature: FEATURE_I) is
			-- Write out the implementation of `a_feature'.
		require
			not_void: a_feature /= Void
		local
			i: INTEGER
			arg_type: TYPE_A
			arg_name: STRING
			last_current_class: EIFFEL_CLASS_C
		do
			last_current_class := current_class
			set_current_feature (a_feature)
			-- only generate implementations for currently verified class
			if last_current_class = current_class then
				function_writer.reset
				function_writer.set_leaf_list (leaf_list)
				function_writer.set_heap_ref ("Heap")
				function_writer.set_this_ref ("Current")
				function_writer.set_result_call ("Result")
				code := ""
				local_vars := ""
				bpl_out ("// Implementation: "+a_feature.feature_name+" of class "+current_class.name+"%N")
				bpl_out ("implementation proc.")
				bpl_out (current_class.name)
				bpl_out (".")
				bpl_out (bpl_mangled_feature_name (a_feature.feature_name))
				bpl_out ("(Current:ref")
				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					arg_name := a_feature.arguments.item_name (i)
					arg_type := a_feature.arguments.i_th (i)
					bpl_out (",arg.")
					bpl_out (arg_name)
					bpl_out (":")
					bpl_out (bpl_type_for_type_a (arg_type))
					i := i + 1
				end
				bpl_out (")")
				if a_feature.is_function then
					bpl_out (" returns (Result:")
					bpl_out (bpl_type_for_type_a (a_feature.type))
					bpl_out (")")
				end
				bpl_out (" {%N")
				bpl_out ("  // Code for "+a_feature.feature_name+" in "+current_class.name+"%N")
				process_feature_i (a_feature)
				bpl_out ("}%N")
			end
			current_class := last_current_class
		end

	process_feature_without_code (a_feature: FEATURE_I) is
			-- Process a constant (no code attached).
		do
			bpl_out ("  entry:%N")
			bpl_out ("    assume(false);%N")
			bpl_out ("    return;%N")
		end

	process_byte_code (a_node: BYTE_CODE) is
			-- Process the byte code.
		local
			i:INTEGER
		do
			-- Fill 'code' first
			safe_process (a_node.compound)

			from
				i := 1
			until
				i > a_node.local_count
			loop
				bpl_out ("  var l")
				bpl_out (i.out)
				bpl_out (":")
				bpl_out (bpl_type_for_type_a (a_node.locals.item (i).actual_type))
				bpl_out (";%N")
				i := i + 1
			end

			bpl_out (local_vars)
			bpl_out ("  entry:%N")
			bpl_out (code)
			bpl_out ("    return;%N")
		end

feature -- Settors

	set_current_feature (a_feature: FEATURE_I) is
			-- Set the current feature to `a_feature', keeping the feature in the
			-- function writer syncronous.
		do
			Precursor {BPL_BN_ITERATOR} (a_feature)
			function_writer.set_current_feature (a_feature)
		end

feature -- Processors

	process_assign_b (a_node: ASSIGN_B) is
			-- Process `a_node'.
		local
			local_b: LOCAL_B
			attribute_b: ATTRIBUTE_B
		do
			function_writer.reset
			a_node.source.process (function_writer)
			append_local_vars (function_writer.local_vars)
			code.append (function_writer.side_effect)

			code.append ("    ")
			if a_node.target.is_local then
				local_b ?= a_node.target
				check not_void: local_b /= Void end
				code.append ("l")
				code.append (local_b.position.out)
			elseif a_node.target.is_Result then
				code.append ("Result")
			elseif a_node.target.is_attribute then
				attribute_b ?= a_node.target
				check not_void: attribute_b /= Void end
				code.append ("Heap[Current,field.")
				code.append (system.class_of_id (attribute_b.written_in).name)
				code.append (".")
				code.append (attribute_b.attribute_name)
				code.append ("]")
			else
				check
					should_not_be_here: false
				end
			end
			code.append (" := ")
			code.append (function_writer.expr)
			code.append (";")
			code.append (location_info (a_node))
		end

	process_check_b (a_node: CHECK_B) is
			-- Process `a_node'.
		local
			i: INTEGER
			assert_b: ASSERT_B
		do
			from
				i := 1
			until
				i > a_node.check_list.count
			loop
				assert_b ?= a_node.check_list.i_th (i)
				check is_assert_b: assert_b /= Void end
				function_writer.reset
				assert_b.expr.process (function_writer)
				append_local_vars (function_writer.local_vars)
				code.append (function_writer.side_effect)
				code.append ("    assert (")
				code.append (function_writer.expr)
				code.append ("); ")
				code.append (location_info (assert_b))
				i := i + 1
			end
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		local
			true_label: STRING
			false_label: STRING
			endif_label: STRING
			cond_expr: STRING
			i: INTEGER
			elsif_b: ELSIF_B
		do
			new_label ("true")
			true_label := last_label
			new_label ("false")
			false_label := last_label
			new_label ("endif")
			endif_label := last_label

			function_writer.reset
			a_node.condition.process (function_writer)
			append_local_vars (function_writer.local_vars)
			code.append (function_writer.side_effect)
			cond_expr := function_writer.expr

			code.append ("    goto ")
			code.append (true_label)
			code.append (",")
			code.append (false_label)
			code.append (";%N")

			code.append ("  ")
			code.append (true_label)
			code.append (":%N")

			code.append ("    assume(")
			code.append (cond_expr)
			code.append (");%N")

			a_node.compound.process (Current)

			code.append ("    goto ")
			code.append (endif_label)
			code.append (";%N")

			from i := 1 until
				a_node.elsif_list = Void or else
				i > a_node.elsif_list.count
			loop

				elsif_b ?= a_node.elsif_list.i_th (i)

				check
					not_void: elsif_b /= Void
				end

				code.append ("  ")
				code.append (false_label)
				code.append (":%N")

				code.append ("    assume(!(")
				code.append (cond_expr)
				code.append ("));%N")

				function_writer.reset
				elsif_b.expr.process (function_writer)
				append_local_vars (function_writer.local_vars)
				code.append (function_writer.side_effect)
				cond_expr := function_writer.expr

				new_label ("true")
				true_label := last_label
				new_label ("false")
				false_label := last_label

				code.append ("    goto ")
				code.append (true_label)
				code.append (",")
				code.append (false_label)
				code.append (";%N")

				code.append ("  ")
				code.append (true_label)
				code.append (":%N")

				code.append ("    assume(")
				code.append (cond_expr)
				code.append (");%N")

				elsif_b.compound.process (Current)

				code.append ("    goto ")
				code.append (endif_label)
				code.append (";%N")

				i := i + 1
			end

			code.append ("  ")
			code.append (false_label)
			code.append (":%N")

			code.append ("    assume(!(")
			code.append (cond_expr)
			code.append ("));%N")

			if a_node.else_part /= Void then
				a_node.else_part.process (Current)
			end

			code.append ("    goto ")
			code.append (endif_label)
			code.append (";%N")

			code.append ("  ")
			code.append (endif_label)
			code.append (":%N")

		end

	process_instr_call_b (a_node: INSTR_CALL_B) is
			-- Process `a_node'.
		local
			new_code: STRING
			i,n: INTEGER
			call_access_b: CALL_ACCESS_B
			nested_b: NESTED_B
		do
			nested_b ?= a_node.call
			if nested_b /= Void then
				call_access_b ?= nested_b.message
			else
				call_access_b ?= a_node.call
			end
			if call_access_b /= Void then
				new_code := "    call proc."
				new_code.append (system.class_of_id (call_access_b.written_in).name)
				new_code.append (".")
				new_code.append (call_access_b.feature_name)
				new_code.append ("(")
				if nested_b /= Void then
					function_writer.reset
					nested_b.target.process (function_writer)
					append_local_vars (function_writer.local_vars)
					code.append (function_writer.side_effect)
					new_code.append (function_writer.expr)
				else
					new_code.append ("Current")
				end
				if call_access_b.parameters /= Void then
					from
						i := 1
						n := call_access_b.parameters.count
					until
						i > n
					loop
						function_writer.reset
						call_access_b.parameters.i_th (i).process (function_writer)
						append_local_vars (function_writer.local_vars)
						code.append (function_writer.side_effect)
						new_code.append (",")
						new_code.append (function_writer.expr)
						i := i + 1
					end
				end
				new_code.append (");")
				code.append (new_code)
				code.append (location_info (a_node))
			else
				check unknown_instruction: false end
			end
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		local
			loop_label,exit_label:STRING
			stop_expr: STRING
			inv_assert: STRING
			i: INTEGER
			stop_side_effect: STRING
		do
			new_label ("loop")
			loop_label := last_label
			new_label ("exit")
			exit_label := last_label

			if a_node.from_part /= Void then
				a_node.from_part.process (Current)
			end

			function_writer.reset
			a_node.stop.process (function_writer)
			append_local_vars (function_writer.local_vars)
			stop_expr := function_writer.expr
			stop_side_effect := function_writer.side_effect

			from
				i := 1
				inv_assert := ""
			until
				a_node.invariant_part = Void or else
				i > a_node.invariant_part.count
			loop
				function_writer.reset
				a_node.invariant_part.i_th (i).process (function_writer)
				append_local_vars (function_writer.local_vars)
				stop_side_effect.append (function_writer.side_effect)
				inv_assert.append("    assert(")
				inv_assert.append(function_writer.expr)
				inv_assert.append("); ")
				inv_assert.append(location_info (a_node.invariant_part.i_th (i)))
				i := i + 1
			end

			-- TODO: Generate assertions for variant

			code.append (stop_side_effect)
			code.append (inv_assert)
			code.append ("    goto ")
			code.append (loop_label)
			code.append (",")
			code.append (exit_label)
			code.append (";%N")

			code.append ("  ")
			code.append (loop_label)
			code.append (":%N")

			code.append ("    assume(!(")
			code.append (stop_expr)
			code.append ("));%N")

			a_node.compound.process (Current)

			code.append (stop_side_effect)
			code.append (inv_assert)
			code.append ("    goto ")
			code.append (loop_label)
			code.append (",")
			code.append (exit_label)
			code.append (";%N")

			code.append ("  ")
			code.append (exit_label)
			code.append (":%N")

			code.append ("    assume(")
			code.append (stop_expr)
			code.append (");%N")
		end

feature -- Access

	code: STRING
		-- Generated Code for the body

feature{NONE} -- Implementation

	local_vars: STRING

	function_writer: BPL_BN_FUNCTION_WRITER

	record_local_var (a_name: STRING; a_bpl_type: STRING) is
			-- Record the need of a temp variable `a_name' of `a_bpl_type'
		do
			local_vars.append ("  var ")
			local_vars.append (a_name)
			local_vars.append (":")
			local_vars.append (a_bpl_type)
			local_vars.append (";%N")
		end

	append_local_vars (a_string: STRING) is
			-- Append the local vars defined in `a_string' to `local_vars'.
		do
			local_vars.append (a_string)
		end

invariant
	function_writer_not_void: function_writer /= Void
end
