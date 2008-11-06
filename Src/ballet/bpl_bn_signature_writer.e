indexing
	description: "Write the signature of procedures"
	author: "Bernd Schoeller, Raphael Mack"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_SIGNATURE_WRITER

inherit
	BPL_BN_ITERATOR
		redefine
			set_current_feature,
			process_byte_code,
			process_feature_without_code
		end
	SHARED_SERVER

	SHARED_BYTE_CONTEXT

	SHARED_BPL_ENVIRONMENT

create
	make

feature -- Generation

	write_signature (a_feature: FEATURE_I) is
			-- Write the signature for `a_feature'.
		require
			not_void: a_feature /= Void
			not_attribute: a_feature.body.body /= Void
		local
			i: INTEGER
			arg_name: STRING
			arg_type: TYPE_A
			ass_list: BYTE_LIST[BYTE_NODE]
			all_queries: LIST[FEATURE_I]
			frame: FRAME_B
			call: CALL_ACCESS_B
			nested: NESTED_B
			byte_code: BYTE_CODE
			mod_frame: FRAME_B
			mod_frame_call: CALL_ACCESS_B
			mod_byte_code: BYTE_CODE
			modifies_expression: STRING
			use_expression: STRING
			target: STRING
			argument_quantifier: STRING
			call_arguments: STRING
			last_current_class: EIFFEL_CLASS_C
		do
			last_current_class := current_class

			setup_function_writer
			function_writer.set_current_feature (a_feature)

			context.init (a_feature.written_class.types.first)
			bpl_out ("// Signature: " + a_feature.feature_name + " of class " + current_class.name + "%N")
			bpl_out ("procedure proc.")
			bpl_out (current_class.name)
			bpl_out (".")
			bpl_out (bpl_mangled_feature_name (a_feature.feature_name))
			bpl_out ("(Current: ref where Current != null && Heap[Current, $allocated]")
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				arg_name := a_feature.arguments.item_name (i)
				arg_type := a_feature.arguments.i_th (i)
				bpl_out (", arg.")
				bpl_out (arg_name)
				bpl_out (":")
				bpl_out (bpl_type_for_type_a (arg_type))
				if bpl_type_for_type_a (arg_type).is_equal ("ref") then
					if arg_type.is_attached then
						bpl_out (" where arg.")
						bpl_out (arg_name)
						bpl_out (" != null && Heap[arg.")
						bpl_out (arg_name)
						bpl_out (", $allocated]")
					else
						bpl_out (" where arg.")
						bpl_out (arg_name)
						bpl_out (" != null ==> Heap[arg.")
						bpl_out (arg_name)
						bpl_out (", $allocated]")
					end
				end
				i := i + 1
			end
			bpl_out (")")
			if a_feature.is_function or a_feature.is_attribute or a_feature.is_constant then
				bpl_out (" returns (Result:")
				bpl_out (bpl_type_for_type_a (a_feature.type))
				bpl_out (")")
			end
			bpl_out (";%N")
			bpl_out ("  requires Current != null;%N")

			if inv_byte_server.has(current_class.class_id) then
				ass_list := inv_byte_server.item (current_class.class_id).byte_list
				from
					ass_list.start
				until
					ass_list.off
				loop
					function_writer.reset
					ass_list.item.process (function_writer)

					bpl_out ("  free requires ")
					bpl_out (function_writer.expr)
					bpl_out (";%N")

					function_writer.reset
					ass_list.item.process (function_writer)
					bpl_out ("  ensures ")
					bpl_out (function_writer.expr)
					bpl_out (";")
					bpl_out (location_info (ass_list.item))
					ass_list.forth
				end
			end


			if a_feature.type.is_void then
				bpl_out ("  modifies Heap;%N")
			else
				bpl_out ("  free ensures (fun.")
				bpl_out (current_class.name)
				bpl_out (".")
				bpl_out (bpl_mangled_feature_name (a_feature.feature_name))
				bpl_out ("(Heap, Current")
				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					arg_name := a_feature.arguments.item_name (i)
					arg_type := a_feature.arguments.i_th (i)
					bpl_out (", arg.")
					bpl_out (arg_name)
					i := i + 1
				end
				bpl_out (") == Result);%N")
			end

			process_feature_i (a_feature) -- generate assertions
			function_writer.set_current_feature (a_feature)
			-- write ensure clauses for all queries in the program to state, that they
			-- are not changed if the frames do not overlap

			-- TODO: handle subtyping
			if Byte_server.has (a_feature.code_id)  then
				mod_byte_code := Byte_server.item (a_feature.code_id)
				if mod_byte_code.modify_frame /= Void then
					from
						mod_byte_code.modify_frame.start
						modifies_expression := Void
					until
						mod_byte_code.modify_frame.after
					loop
						mod_frame ?= mod_byte_code.modify_frame.item
						check
							mod_frame_not_void: mod_frame /= Void
						end
						mod_frame_call ?= mod_frame.expr
						check
							mod_frame_call_not_void: mod_frame_call /= Void
						end
						if modifies_expression = Void then
							modifies_expression := "fun." + a_feature.written_class.name + "." + mod_frame_call.feature_name + " (old (Heap), o)"
						else
							modifies_expression := "set.united(" + modifies_expression + ", " +
								"fun." + a_feature.written_class.name + "." + mod_frame_call.feature_name + " (old (Heap), o))"
						end
						mod_byte_code.modify_frame.forth
					end
					from
						all_queries := environment.usage_analyser.all_query_list
						all_queries.start
					until
						all_queries.after
					loop
						if Byte_server.has (all_queries.item.code_id) then
							argument_quantifier := ""
							byte_code := Byte_server.item (all_queries.item.code_id)
							if byte_code.use_frame /= Void then
								bpl_out ("  free ensures (")

								from
									byte_code.use_frame.start
									use_expression := Void
								until
									byte_code.use_frame.after
								loop
									frame ?= byte_code.use_frame.item
									check
										frame_not_void: frame /= Void
									end
									call ?= frame.expr
									nested ?= frame.expr
									call_arguments := ""
									if nested /= Void then
										call ?= nested.message
										function_writer.reset
										function_writer.set_current_feature (all_queries.item)
										function_writer.set_argument_prefix (all_queries.item.written_class.name + "." + call.feature_name + ".arg.")
										nested.target.process (function_writer)
										target := function_writer.expr
										from
											function_writer.used_arguments.start
										until
											function_writer.used_arguments.after
										loop
											argument_quantifier.append (", ")
											argument_quantifier.append (function_writer.used_arguments.item.out)
											argument_quantifier.append (":ref")
											call_arguments.append (", ")
											call_arguments.append (function_writer.used_arguments.item.out)
											function_writer.used_arguments.forth
										end
									else
										target := "Current"
									end
									check
										call_not_void: call /= Void
									end
									if use_expression = Void then
										use_expression := "fun." + all_queries.item.written_class.name + "." +
											call.feature_name + " (old (Heap), " + target + ")"
									else
										use_expression := "set.united (" + use_expression + ", " +
											"fun." + all_queries.item.written_class.name + "." + call.feature_name +
											" (old (Heap), " + target + "))"
									end
									byte_code.use_frame.forth
								end

								bpl_out ("forall o:ref")
								bpl_out (argument_quantifier)
								bpl_out (" :: ((set.is_disjoint_from (" +
									modifies_expression + ", " +
									use_expression + "))")

								bpl_out (" ==> (fun." + all_queries.item.written_class.name +
									"." + all_queries.item.feature_name + " (Heap, o" + call_arguments + ") == fun." +
									all_queries.item.written_class.name + "." +
									all_queries.item.feature_name + " (old (Heap), o" + call_arguments + "))));%N")
							end
						end
						all_queries.forth
					end
				end
			end
			bpl_out ("%N")
			current_class := last_current_class
		end

feature -- Settors

	set_current_feature (a_feature: FEATURE_I) is
			-- Set the current feature to `a_feature', keeping the feature in the
			-- function writer syncronous.
		do
			Precursor {BPL_BN_ITERATOR} (a_feature)
			function_writer.set_current_feature (a_feature)
		end


feature {BYTE_NODE} -- Visitors
	process_byte_code (a_node: BYTE_CODE) is
			-- We have to have an extra processor here, as BYTE_CODEs do
			-- not want to be BYTE_NODEs (though they are).
		local
			ass_list: BYTE_LIST[BYTE_NODE]
			inh_assert: INHERITED_ASSERTION
			byte_l: BYTE_LIST [BYTE_NODE]
			e_cls, tmp_cls: EIFFEL_CLASS_C
		do
			ass_list := a_node.precondition
			if ass_list /= Void then
				from
					ass_list.start
				until
					ass_list.off
				loop
					function_writer.reset
					ass_list.item.process (function_writer)
					bpl_out ("  requires (")
					bpl_out (function_writer.expr)
					bpl_out (");%N")
					ass_list.forth
				end
			end

			ass_list := a_node.postcondition
			if ass_list /= Void then
				from
					ass_list.start
				until
					ass_list.off
				loop
					function_writer.reset
					ass_list.item.process (function_writer)
					bpl_out ("  ensures (")
					bpl_out (function_writer.expr)
					bpl_out ("); ")
					bpl_out (location_info (ass_list.item))
					ass_list.forth
				end
			end

			-- inherited contracts

			Context.clear_feature_data
			Context.set_current_feature (current_feature)
			inh_assert := Context.inherited_assertion
			inh_assert.wipe_out

			if current_feature.assert_id_set /= Void  then
				a_node.formulate_inherited_assertions(current_feature.assert_id_set)
			end

			from
				inh_assert.precondition_list.start
				inh_assert.precondition_types.start
			until
				inh_assert.precondition_list.after
			loop
				check
					same_length_types: not inh_assert.precondition_types.after
				end
				e_cls ?= inh_assert.precondition_types.item.associated_class
				check
					need_eiffel: e_cls /= Void
				end

				from
					byte_l := inh_assert.precondition_list.item
					byte_l.start
				until
					byte_l.after
				loop
					function_writer.reset
					byte_l.item.process (function_writer)
					bpl_out ("  requires (")
					bpl_out (function_writer.expr)
					bpl_out ("); // (inherited) ")
					tmp_cls := current_class
					current_class := e_cls
					bpl_out (location_info (byte_l.item))
					e_cls := tmp_cls
					current_class := e_cls
					byte_l.forth
				end
				inh_assert.precondition_list.forth
			end

			from
				inh_assert.postcondition_list.start
				inh_assert.postcondition_types.start
			until
				inh_assert.postcondition_list.after
			loop
				check
					same_length_types: not inh_assert.postcondition_types.after
				end
				e_cls ?= inh_assert.postcondition_types.item.associated_class
				check
					need_eiffel: e_cls /= Void
				end

				from
					byte_l := inh_assert.postcondition_list.item
					byte_l.start
				until
					byte_l.after
				loop
					function_writer.reset
					byte_l.item.process (function_writer)
					bpl_out ("  ensures (")
					bpl_out (function_writer.expr)
					bpl_out ("); // (inherited) ")
					tmp_cls := current_class
					current_class := e_cls
					bpl_out (location_info (byte_l.item))
					e_cls := tmp_cls
					current_class := e_cls
					byte_l.forth
				end
				inh_assert.postcondition_list.forth
			end

		end

feature -- Extra processors
	process_feature_without_code (a_feature: FEATURE_I) is
			-- Process a feature that does not have code.
		do
			-- no need to do anything here
		end

feature{NONE} -- Implementation

	function_writer: BPL_BN_FUNCTION_WRITER

	setup_function_writer is
			-- Setup the function_writer.
		do
			create function_writer.make (current_class)
			function_writer.set_result_call ("Result")
			function_writer.set_heap_ref ("Heap")
			function_writer.set_this_ref ("Current")
			function_writer.set_leaf_list (match_list_server.item (current_class.class_id))
		end

end
