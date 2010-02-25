note
	description: "Entry point for tests of EiffelTransform"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_EIFFEL_TRANSFORM

inherit
	EWB_CMD
	SHARED_SERVER
	COMPILER_EXPORTER
	SHARED_DEGREES
	SHARED_EIFFEL_PARSER
	ETR_SHARED_OPERATORS
	REFACTORING_HELPER
	ETR_COMPILATION_HELPER
	ETR_SHARED_TRANSFORMABLE_FACTORY
	ETR_SHARED_TOOLS

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

	hier_out: ETR_AST_HIERARCHY_OUTPUT
			-- Used to force the class to compile

	dbg: ETR_BP_SLOT_INITIALIZER
			-- Used to force the class to compile

	test_context_transformation
			-- test context transformations
		local
			a1,a2: CLASS_I
			a1_ast,a2_ast: CLASS_AS
			a1_context, a2_context: ETR_FEATURE_CONTEXT
			a1_feat, a2_feat: FEATURE_I
			a1_instr, a2_instr: ETR_TRANSFORMABLE
		do
			-- create contexts
			a1 := universe.compiled_classes_with_name("A1").first
			a1_ast := a1.compiled_class.ast
			a2 := universe.compiled_classes_with_name("A2").first
			a2_ast := a2.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named ("test")
			a2_feat := a2.compiled_class.feature_named ("test")

			-- create contexts
			create a1_context.make (a1_feat, void)
			create a2_context.make (a2_feat, void)

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
			a2_instr := a1_instr.transform_to_context (a2_context)

			-- print transformed instruction
			io.put_string (ast_tools.ast_to_string(a2_instr.target_node))
		end

	test_ass_attempt_replacing
			-- test assignment attempt replacing
		local
			a2: CLASS_I
			a2_ast: CLASS_AS
			a2_context: ETR_FEATURE_CONTEXT
			a2_feat: FEATURE_I
			a2_trans: ETR_TRANSFORMABLE
			mod: ETR_AST_MODIFIER
		do
			-- create contexts
			a2 := universe.compiled_classes_with_name("A2").first
			a2_ast := a2.compiled_class.ast
			a2_feat := a2.compiled_class.feature_named ("test")

			-- create contexts
			create a2_context.make (a2_feat, void)

			a2_trans := create {ETR_TRANSFORMABLE}.make_from_ast(a2_ast, create {ETR_CLASS_CONTEXT}.make(a2.compiled_class),true)
			rewrite.replace_assignment_attempts (a2_trans)

			-- apply the modifications
			create mod.make
			mod.add_list(rewrite.modifications)
			mod.apply_to (a2_trans)

			-- print transformed instruction
			io.put_string (ast_tools.ast_to_string(mod.modified_ast.target_node))
		end

	test_ren
			-- test renaming
		local
			a1: CLASS_I
			a1_ast: CLASS_AS
			a1_context: ETR_FEATURE_CONTEXT
			a1_feat: FEATURE_I
			a1_instr: ETR_TRANSFORMABLE
			trans: ETR_TRANSFORMABLE
		do
			-- create contexts
			a1 := universe.compiled_classes_with_name("A1").first
			a1_ast := a1.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named ("test")

			-- create contexts
			create a1_context.make (a1_feat, void)
			create trans.make_from_ast (a1_feat.e_feature.ast, a1_context, false)


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
			trans := trans.transform_to_context (renamer.transformation_result.context)

			io.put_string (trans.out)
		end

	test_setter_gen
			-- test setter creation
		local
			a1: CLASS_I
			a1_ast: CLASS_AS
			a1_context: ETR_FEATURE_CONTEXT
			a1_feat: FEATURE_I
			trans: ETR_TRANSFORMABLE
			setter_gen: ETR_SETTER_GENERATOR
		do
			create setter_gen

			-- create contexts
			a1 := universe.compiled_classes_with_name("A1").first
			a1_ast := a1.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named ("c")

			-- create contexts
			create a1_context.make (a1_feat, void)
			create trans.make_from_ast (a1_feat.e_feature.ast, a1_context, false)

			setter_gen.generate_setter (trans, "set_c", "a_c", "c := a_c", "c = a_c")

			io.put_string (ast_tools.ast_to_string(setter_gen.transformation_result.target_node))
		end

	test_ec_gen
			-- test effective class generation
		local
			a1: CLASS_I
			a1_ast: CLASS_AS
			a1_context: ETR_CLASS_CONTEXT
			trans: ETR_TRANSFORMABLE
			ec_gen: ETR_EFFECTIVE_CLASS_GENERATOR
		do
			create ec_gen

			-- create contexts
			a1 := universe.compiled_classes_with_name("DEF_B").first
			a1_ast := a1.compiled_class.ast

			-- create contexts
			create a1_context.make (a1.compiled_class)
			create trans.make_from_ast (a1_ast, a1_context, false)

			ec_gen.generate_effective_class (trans)

			io.put_string (ast_tools.ast_to_string(ec_gen.transformation_result.target_node))
		end

	test_me(method_name: STRING; a_start, a_end: STRING)
			-- test method extraction
		local
			a1: CLASS_I
			a1_ast: CLASS_AS
			a1_feat: FEATURE_I
			trans: ETR_TRANSFORMABLE
			l_start, l_end: AST_PATH
		do
			a1 := universe.compiled_classes_with_name("M_EX").first
			a1_ast := a1.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named (method_name)

			create trans.make_in_class (a1_feat.e_feature.ast, a1.compiled_class)

			create l_start.make_from_string(a1_feat.e_feature.ast,a_start)
			create l_end.make_from_string(a1_feat.e_feature.ast,a_end)
			l_start.set_root (trans.target_node)
			l_end.set_root (trans.target_node)

			method_extractor.extract_method (trans,
								method_name,
								l_start,
								l_end,
								"extracted")
			io.put_string ("=== "+method_name+" EXTRACTED ===%N")
			io.put_string (ast_tools.ast_to_string(method_extractor.extracted_method.target_node))
			io.put_string ("=== "+method_name+" OLD ===%N")
			io.put_string (ast_tools.ast_to_string(method_extractor.old_method.target_node))
		end

	test_typechecker
		local
			a1: CLASS_I
			a1_ast: CLASS_AS
			a1_context: ETR_FEATURE_CONTEXT
			a1_feat: FEATURE_I
			trans, expr: ETR_TRANSFORMABLE
			tc: ETR_TYPE_CHECKER
		do
			a1 := universe.compiled_classes_with_name("M_EX").first
			a1_ast := a1.compiled_class.ast
			a1_feat := a1.compiled_class.feature_named ("test")

			create a1_context.make (a1_feat, void)
			create trans.make_from_ast (a1_feat.e_feature.ast, a1_context, false)

			renamer.rename_argument (trans, "test", "arg1", "arg1_new")

			expr := transformable_factory.new_expr ("arg1_new", renamer.transformation_result.context)

			create tc
			tc.check_transformable (expr)
		end

	test_branch_removal
		local
			cls: CLASS_I
			cls_ast: CLASS_AS
			l_rng: RANGED_RANDOM
			trans: ETR_TRANSFORMABLE
		do
			-- prepare transformable
			cls := universe.compiled_classes_with_name("M_EX").first
			cls_ast := cls.compiled_class.ast

			create trans.make_in_class (cls_ast, cls.compiled_class)

			-- prepare rng
			create l_rng.make
			l_rng.set_seed ((create {TIME}.make_now).compact_time)

			-- step 1: remove inspects
			from
				ast_stats.process_transformable (trans)
			until
				not ast_stats.has_inspects
			loop
				rewrite.replace_inspects (trans)
				trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (trans)
			end

			-- step 2: remove loops, random number of rewrites, one at a time
			from
				ast_stats.process_transformable (trans)
			until
				not ast_stats.has_loops
			loop
				rewrite.unroll_loop (trans, l_rng.next_item_in_range (1, 5), true)
				trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (trans)
			end

			-- step 3: remove elseifs
			from
				ast_stats.process_transformable (trans)
			until
				not ast_stats.has_elseifs
			loop
				rewrite.replace_elseifs (trans)
				trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (trans)
			end

			-- step 4: remove ifs, take random branch, one at a time
			from
				ast_stats.process_transformable (trans)
			until
				not ast_stats.has_conditional_branches
			loop
				if l_rng.next_item_in_range (0, 1) = 0 then
					rewrite.remove_ifs (trans, true, true)
				else
					rewrite.remove_ifs (trans, false, true)
				end

				trans.apply_modifications (rewrite.modifications)

				ast_stats.process_transformable (trans)
			end

			io.put_string (trans.out)
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

	test_slot_init
		local
			bp_vis: ETR_BP_SLOT_INITIALIZER
			path_vis: ETR_AST_PATH_INITIALIZER
			a1: CLASS_I
			a1_ast: CLASS_AS
			l_out: ETR_AST_HIERARCHY_OUTPUT
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_textout: PLAIN_TEXT_FILE
		do
			a1 := universe.compiled_classes_with_name("M_EX").first
			a1_ast := a1.compiled_class.ast
			create bp_vis
			create path_vis
			bp_vis.init_from (a1_ast)
			path_vis.process_from_root (a1_ast)

			create l_out.make
			create l_printer.make_with_output (l_out)
			l_printer.print_ast_to_output (a1_ast)

			create l_textout.make_open_write ("E:\ETH\MasterThesis\evedev\Src\framework\eiffel_transform\hierout.txt")
			l_textout.put_string (l_out.string_representation)
			l_textout.close
		end

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
			test_slot_init
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
