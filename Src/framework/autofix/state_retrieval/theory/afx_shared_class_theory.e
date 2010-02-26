note
	description: "Summary description for {AFX_SHARED_CLASS_THEORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_CLASS_THEORY

inherit
	AFX_UTILITY

	AFX_SOLVER_CONSTANTS

	AFX_SOLVER_FACTORY

feature -- Access

	class_theories: HASH_TABLE [AFX_THEORY, CLASS_C]
			-- Storage for class theories
			-- Key is the class, value is the theory for that class
		once
			create Result.make (20)
		end

feature -- Basic operations

	resolved_class_theory (a_class: CLASS_C): AFX_THEORY
			-- SMTLIB theory for `a_class' with all qualified call resolved.
		local
			l_statements: LINKED_LIST [STRING]
			l_processed: like class_with_prefix_set
		do
			l_processed := class_with_prefix_set

			create Result.make (a_class)
			resolved_class_theory_internal (create {AFX_CLASS_WITH_PREFIX}.make (a_class, ""), Result, l_processed)

				-- Generate dummy function for expression "Void"
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_void_function
			solver_expression_generator.last_statements.do_all (agent Result.extend_function_with_string)
		end

	expressions_with_theory (a_exprs: LINEAR [EPA_EXPRESSION]; a_class: CLASS_C; a_feature: detachable FEATURE_I): TUPLE [exprs: DS_HASH_TABLE [AFX_SOLVER_EXPR, EPA_EXPRESSION]; theory: AFX_THEORY]
			-- Expressions and their supporting theories for `a_exprs' in the context of `a_class' and `a_feature'.
			-- If `a_feature' is Void, it means that `a_exprs' are for `a_class', not for a particular feature.
			-- `exprs' are the SMTLIB expressions for `a_exprs', `theory' are the support theories.
		local
			l_smt_gen: like solver_expression_generator
			l_processed: like class_with_prefix_set
			l_theory: AFX_THEORY
			l_resolved: TUPLE [resolved_str: STRING; mentioned_classes: like class_with_prefix_set]
			l_base_prefix: AFX_CLASS_WITH_PREFIX
			l_generated_exprs: DS_HASH_TABLE [AFX_SOLVER_EXPR, EPA_EXPRESSION]
			l_raw_text: STRING
		do
			l_smt_gen := solver_expression_generator
			l_processed := class_with_prefix_set
			create l_base_prefix.make (a_class, "")
			create l_generated_exprs.make (20)
			l_generated_exprs.set_key_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})

			create l_theory.make_with_feature (a_class, a_feature)
			l_theory.append (resolved_class_theory (a_class))

				-- Process expressions.
			from
				a_exprs.start
			until
				a_exprs.after
			loop
				l_smt_gen.initialize_for_generation
				l_smt_gen.generate_expression (a_exprs.item_for_iteration.ast, a_class, a_exprs.item_for_iteration.written_class, a_feature)
				l_raw_text := l_smt_gen.last_statements.first
				l_resolved := resolved_smt_statement (l_raw_text, l_base_prefix)
				l_generated_exprs.force_last (new_solver_expression_from_string (l_resolved.resolved_str), a_exprs.item_for_iteration)
				l_resolved.mentioned_classes.do_all (agent resolved_class_theory_internal (?, l_theory, l_processed))
				a_exprs.forth
			end

				-- Generate argument functions.
			if a_feature /= Void then
				l_smt_gen.initialize_for_generation
				l_smt_gen.generate_argument_function (a_feature, a_class)
				l_smt_gen.generate_local_function (a_feature, a_class)
				l_smt_gen.last_statements.do_all (agent l_theory.extend)
			end

			Result := [l_generated_exprs, l_theory]
		end

feature -- Access

	class_with_prefix_set: DS_HASH_SET [AFX_CLASS_WITH_PREFIX]
			-- New set for class with prefix
		do
			create Result.make (5)
			Result.set_equality_tester (class_with_prefix_equality_tester)
		end

	generate_class_theory (a_class: CLASS_C)
			-- Generate class theory for `a_class' and store result in `class_theories'.
		require
			a_class_not_generated: not class_theories.has (a_class)
		local
			l_theory: AFX_THEORY
		do
			create l_theory.make (a_class)

				-- Generate functions.
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_functions (a_class)
			solver_expression_generator.last_statements.do_all (agent l_theory.extend_function_with_string)

				-- Generate function for "Current".
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_current_function (a_class)
			solver_expression_generator.last_statements.do_all (agent l_theory.extend_function_with_string)

				-- Generate class invariant axioms.
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_invariant_axioms (a_class)
			solver_expression_generator.last_statements.do_all (agent l_theory.extend_axiom_with_string)

				-- Generate postconditions as class invariant axioms.
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_postcondition_as_invariant_axioms (a_class)
			solver_expression_generator.last_statements.do_all (agent l_theory.extend_axiom_with_string)

			class_theories.put (l_theory, a_class)
		ensure
			a_class_generated: class_theories.has (a_class)
		end

	resolved_smt_statement (a_stmt: STRING; a_class_with_prefix: AFX_CLASS_WITH_PREFIX): TUPLE [resolved: STRING; mentioned_prefixes: like class_with_prefix_set]
			-- Resolve SMTLIB statement `a_stmt' by solving all qualified calls in the context
			-- of `a_class_with_prefix'. This means that all functions and axioms in the resolved
			-- statement will be prefixed with `a_class_with_prefix'.
			-- The resolved statement will be returned through `resolved'.
			-- `mentioned_prefixes' contains all the prefixes are present in `a_stmt'.
		local
			l_mentioned_prefixes: like class_with_prefix_set
			l_resolved: STRING
			l_start_index, l_end_index, l_separator_index: INTEGER
			l_done: BOOLEAN
			l_section: STRING
			l_prefix: STRING
			l_class: STRING
		do
			l_mentioned_prefixes := class_with_prefix_set
			create l_resolved.make (a_stmt.count)
			from
				l_end_index := -1
			until
				l_done
			loop
				l_start_index := a_stmt.substring_index (expr_prefix_opener, l_end_index + 2)
				if l_start_index > 0 then
						-- Separate the prefix section.
					l_resolved.append (a_stmt.substring (l_end_index + 2, l_start_index - 1))
					l_end_index := a_stmt.substring_index (expr_prefix_closer, l_start_index + 2)
					check l_end_index > 0 end
					l_section := a_stmt.substring (l_start_index + 2, l_end_index - 1)

						-- Analyze the prefix and class part in the section.
					l_separator_index := l_section.index_of (':', 1)
					l_prefix := l_section.substring (1, l_separator_index - 1)
					l_class := l_section.substring (l_separator_index + 1, l_section.count)

						-- Generate resolved string.
					l_resolved.append (a_class_with_prefix.prefix_)
					l_resolved.append (l_prefix)
					if l_class.is_empty  then
						l_class := a_class_with_prefix.class_.name
					end
					l_mentioned_prefixes.force_last (create {AFX_CLASS_WITH_PREFIX}.make_with_class_name (l_class, a_class_with_prefix.prefix_ + l_prefix))
				else
					l_done := True
				end
			end
			l_resolved.append (a_stmt.substring (l_end_index + 2, a_stmt.count))
			Result := [l_resolved, l_mentioned_prefixes]
		end

	resolved_class_theory_internal (a_class_with_prefix: AFX_CLASS_WITH_PREFIX; a_theory: AFX_THEORY; a_processed: like class_with_prefix_set)
			-- SMT theory for `a_class' with prefix `a_prefix'
		local
			l_theory: AFX_THEORY
			l_statements: LINKED_LIST [AFX_SOLVER_EXPR]
			l_resolved: TUPLE [a_statement: STRING; a_mentioned_class: like class_with_prefix_set]
			l_new: like class_with_prefix_set

			l_class: CLASS_C
		do
			if not a_processed.has (a_class_with_prefix) then
				a_processed.force_last (a_class_with_prefix)
				l_class := a_class_with_prefix.class_

					-- Generate theory for `l_class' if not yet generated.
				if not class_theories.has (l_class) then
					generate_class_theory (l_class)
				end

					-- Resolve statements in the theory of `l_class'.
					-- Remove all prefixes.
				l_theory := class_theories.item (l_class)
				create l_statements.make
				l_theory.statements.do_all (agent l_statements.extend)
				l_new := class_with_prefix_set
				from
					l_statements.start
				until
					l_statements.after
				loop
					l_resolved := resolved_smt_statement (l_statements.item_for_iteration.expression, a_class_with_prefix)
					a_theory.extend (l_resolved.a_statement)
					l_resolved.a_mentioned_class.subtraction (a_processed).do_all (agent l_new.force_last)
					l_statements.forth
				end

					-- Process newly discovered classes.
				l_new.do_all (agent resolved_class_theory_internal (?, a_theory, a_processed))
			end
		end

end
