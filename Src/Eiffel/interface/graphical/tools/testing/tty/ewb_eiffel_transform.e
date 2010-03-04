note
	description: "Entry point for tests of EiffelTransform"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_EIFFEL_TRANSFORM

inherit
	EWB_CMD
	ETR_SHARED_OPERATORS
	ETR_SHARED_TOOLS
	ETR_WORKBENCH_OPERATIONS
	ETR_SHARED_FACTORIES
	ETR_SHARED_ERROR_HANDLER

feature -- Properties

	name: STRING
		do
			Result := "EiffelTransform"
		end

	help_message: STRING_GENERAL
		do
			Result := "EiffelTransform"
		end

	abbreviation: CHARACTER
		do
			Result := 'e'
		end

feature -- Force compilation

	hier_out: ETR_AST_HIERARCHY_OUTPUT
	comp_helper: ETR_COMPILATION_HELPER

feature -- Entry point

	execute
			-- Action performed when invoked from the
			-- command line.
		do
			test_ren
			test_setter_gen
			test_context_transformation
			test_ass_attempt_replacing
			test_ec_gen
			test_typechecker
			test_me_all
			test_branch_removal
			test_xml_print
			test_dot_print
			test_bp_print
		end

feature -- Test features

	test_context_transformation
			-- test context transformations
		local
			a1_context, a2_context: ETR_FEATURE_CONTEXT
			a1_instr, a2_instr: ETR_TRANSFORMABLE
		do
			-- create contexts
			a1_context := context_factory.new_feature_context ("A1", "test")
			a2_context := context_factory.new_feature_context ("A2", "test")

			-- code snippet in `a1_context'
			a1_instr := transformable_factory.new_instr(	"if true then%N"+
									"io.putstring(c.c1_a_renamed)%N"+ -- feature type change
									"io.putstring(Current.c.c1_b)%N"+ -- fake qualified call
									"io.putstring(io.putstring(arg_c1_a1.c1_b))%N"+ -- argument type and name change
									"io.putstring(a_c.c1_a_renamed.out)%N"+ -- local type change
									"io.putstring(other.arg_c1_a1.c1_b)%N"+ -- same name, no renaming
									"io.putstring(a1.generating_type)%N"+ -- Current changed
									"io.putstring((c+arg_c1_a1.c1_b).out)%N"+ -- Nested expr
									"create str_a1.make_from_string(arg_c1_a1.c1_b)%N"+ -- creation
									"io.putstring(create {STRING}.make_from_string(a_c.c1_a_renamed))%N"+ -- creation expr
									"io.putstring(str_a1)%N"+ -- renamed local
									"end", a1_context )

			-- transform to `a2_context'
			a2_instr := a1_instr.as_in_other_context (a2_context)

			-- print transformed instruction
			io.put_string (a2_instr.out)
		end

	test_ass_attempt_replacing
			-- test assignment attempt replacing
		local
			l_trans: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_class_transformable("A2")

			rewrite.replace_assignment_attempts (l_trans)
			l_trans.apply_modifications (rewrite.modifications)

			-- print transformed instruction
			io.put_string (l_trans.out)
		end

	test_ren
			-- test renaming
		local
			a1_context: ETR_FEATURE_CONTEXT
			a1_feat: FEATURE_I
			a1_instr: ETR_TRANSFORMABLE
			trans: ETR_TRANSFORMABLE
		do

			a1_feat := feature_of_compiled_class ("A1", "test")

			-- create contexts
			a1_context := context_factory.new_feature_context ("A1", "test")
			create trans.make (a1_feat.e_feature.ast, a1_context, false)

			renamer.rename_argument_at_position (trans, "test", 2, "new_arg_name")
			renamer.rename_local (renamer.transformation_result, "test", "a_c", "a_renamed_local_c")

			-- code snippet in `a1_context'
			a1_instr := transformable_factory.new_instr(	"if true then%N"+
									"io.putstring(c.c1_a_renamed)%N"+ -- feature type change
									"io.putstring(Current.c.c1_b)%N"+ -- fake qualified call
									"io.putstring(io.putstring(arg_c1_a1.c1_b))%N"+ -- argument type and name change
									"io.putstring(a_c.c1_a_renamed.out)%N"+ -- local type change
									"io.putstring(other.arg_c1_a1.c1_b)%N"+ -- same name, no renaming
									"io.putstring(a1.generating_type)%N"+ -- Current changed
									"io.putstring(str_a1)%N"+ -- renamed local
									"end", a1_context )

			-- transform to new context with renaming
			trans := trans.as_in_other_context (renamer.transformation_result.context)

			io.put_string (trans.out)
		end

	test_setter_gen
			-- test setter creation
		local
			l_trans: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_feature_transformable ("A1", "c")

			setter_generator.generate_setter (l_trans, "set_c", "a_c", "c := a_c", "c = a_c")

			io.put_string (setter_generator.transformation_result.out)
		end

	test_ec_gen
			-- test effective class generation
		local
			l_trans: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_class_transformable ("DEF_B")

			effective_class_generator.generate_effective_class (l_trans)

			io.put_string (effective_class_generator.transformation_result.out)
		end

	test_me(method_name: STRING; a_start, a_end: STRING)
			-- test method extraction
		local
			l_trans: ETR_TRANSFORMABLE
			l_start, l_end: AST_PATH
		do
			l_trans := transformable_factory.new_feature_transformable ("M_EX", method_name)

			create l_start.make_from_string(l_trans.target_node,a_start)
			create l_end.make_from_string(l_trans.target_node,a_end)

			method_extractor.extract_method (l_trans,
								method_name,
								l_start,
								l_end,
								"extracted")
			io.put_string ("=== "+method_name+" EXTRACTED ===%N")
			io.put_string (method_extractor.extracted_method.out)
			io.put_string ("=== "+method_name+" OLD ===%N")
			io.put_string (method_extractor.old_method.out)
		end

	test_typechecker
		local
			l_trans, l_expr: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_feature_transformable ("M_EX", "test")

			renamer.rename_argument (l_trans, "test", "arg1", "arg1_new")

			l_expr := transformable_factory.new_expr ("arg1_new", renamer.transformation_result.context)

			type_checker.check_transformable (l_expr)
		end

	test_branch_removal
		local
			l_rng: RANGED_RANDOM
			l_trans: ETR_TRANSFORMABLE
			l_textout: PLAIN_TEXT_FILE
		do
			l_trans := transformable_factory.new_feature_transformable ("M_EX", "big")
			l_trans.enable_code_tracking

			create l_textout.make_open_write (eiffel_transform_directory+"big.before.ee")
			l_textout.put_string (ast_to_bp_string(l_trans))
			l_textout.close

			-- prepare rng
			create l_rng.make
--			l_rng.set_seed ((create {TIME}.make_now).compact_time)
			l_rng.set_seed (42)

			-- step 1: remove inspects
			from
				ast_stats.process_transformable (l_trans)
			until
				not ast_stats.has_inspects
			loop
				rewrite.replace_inspects (l_trans)
				l_trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (l_trans)
			end

			-- step 2: remove loops, random number of rewrites, one at a time
			from
				ast_stats.process_transformable (l_trans)
			until
				not ast_stats.has_loops
			loop
				rewrite.unroll_loop (l_trans, 3, false)
				l_trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (l_trans)
			end

			-- step 3: remove elseifs
			from
				ast_stats.process_transformable (l_trans)
			until
				not ast_stats.has_elseifs
			loop
				rewrite.replace_elseifs (l_trans)
				l_trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (l_trans)
			end

			-- step 4: remove ifs, take random branch, one at a time
			from
				ast_stats.process_transformable (l_trans)
			until
				not ast_stats.has_conditional_branches
			loop
				if l_rng.next_item_in_range (0, 1) = 0 then
					rewrite.remove_ifs (l_trans, true, true)
				else
					rewrite.remove_ifs (l_trans, false, true)
				end

				l_trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (l_trans)
			end

			create l_textout.make_open_write (eiffel_transform_directory+"big.after.ee")
			l_textout.put_string (ast_to_bp_string(l_trans))
			l_textout.close

--			l_bp_count := ast_tools.num_breakpoint_slots_in (l_trans)
--			l_final_map :=  ast_tools.combined_breakpoint_mapping (l_map_chain, l_bp_count)
			print_map(l_trans.breakpoint_map)
		end

	test_me_all
		do
			test_me("test", "1.2.4.4.1.2", "1.2.4.4.1.2")
			test_me("test2", "1.2.4.4.1.3", "1.2.4.4.1.3")
			test_me("test3", "1.2.4.4.1.3", "1.2.4.4.1.4")
			test_me("test4", "1.2.4.4.1.1.4.1", "1.2.4.4.1.1.4.4")
			test_me("test5", "1.2.4.4.1.2", "1.2.4.4.1.4")
			test_me("test6", "1.2.4.4.1.2", "1.2.4.4.1.2")
			test_me("test7", "1.2.4.4.1.1.2.2", "1.2.4.4.1.1.2.2")
		end

	test_xml_print
		local
			l_out: ETR_AST_XML_OUTPUT
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_textout: PLAIN_TEXT_FILE
			l_trans: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_class_transformable ("M_EX")
			l_trans.calculate_breakpoint_slots
			create l_out.make
			create l_printer.make_with_output (l_out)
			l_printer.print_ast_to_output (l_trans)

			create l_textout.make_open_write (eiffel_transform_directory+"testout.xml")
			l_textout.put_string (l_out.string_representation)
			l_textout.close
		end

	test_dot_print
		local
			l_out: ETR_AST_DOT_OUTPUT
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_textout: PLAIN_TEXT_FILE
			l_trans: ETR_TRANSFORMABLE
		do
			l_trans := transformable_factory.new_feature_transformable ("M_EX", "test")
			create l_out.make
			l_out.start
			create l_printer.make_with_output (l_out)
			l_printer.print_ast_to_output (l_trans)
			l_out.finish

			create l_textout.make_open_write (eiffel_transform_directory+"testout.dot")
			l_textout.put_string (l_out.string_representation)
			l_textout.close
		end

	test_bp_print
		local
			l_out: ETR_AST_BP_OUTPUT
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_textout: PLAIN_TEXT_FILE
			l_trans: ETR_TRANSFORMABLE
			l_classname: STRING
		do
			l_classname := "M_EX"
--			l_classname := "EFF"
			l_trans := transformable_factory.new_class_transformable (l_classname)
			l_trans.calculate_breakpoint_slots
			create l_out.make
			create l_printer.make_with_output (l_out)
			l_printer.print_ast_to_output (l_trans)

			create l_textout.make_open_write (eiffel_transform_directory+l_classname+"-bp.ee")
			l_textout.put_string (l_out.string_representation)
			l_textout.close
		end

feature -- Helper features

	eiffel_transform_directory: STRING
		once
			Result := (create {EXECUTION_ENVIRONMENT}).get("EIFFEL_SRC")+"\framework\eiffel_transform\"
		end

	ast_to_bp_string(a_ast: AST_EIFFEL): STRING
		local
			l_out: ETR_AST_BP_OUTPUT
			l_printer: ETR_AST_STRUCTURE_PRINTER
		do
			create l_out.make
			create l_printer.make_with_output (l_out)
			l_printer.print_ast_to_output (a_ast)
			Result := l_out.string_representation
		end

	print_map (a_map: HASH_TABLE[INTEGER,INTEGER])
		local
			l_textout: PLAIN_TEXT_FILE
		do
			create l_textout.make_open_write ((create {EXECUTION_ENVIRONMENT}).get("EIFFEL_SRC")+"\framework\eiffel_transform\map.txt")
			from
				a_map.start
			until
				a_map.after
			loop
				l_textout.put_string (a_map.key_for_iteration.out+" -> "+a_map.item_for_iteration.out+"%N")
				a_map.forth
			end
			l_textout.close
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
