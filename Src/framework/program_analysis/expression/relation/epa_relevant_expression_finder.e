note
	description: "Class to find expression which are relevant to each other"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_RELEVANT_EXPRESSION_FINDER

inherit
	AST_ITERATOR
		redefine
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as,
			process_body_as,
			process_binary_as
		end

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature -- Creation Procedure

	make (a_context: like context)
			-- Creates a new relevant expression finder.
			-- Initializes `context' with `a_context'.
			-- `a_context' indicates in which scope the relevant expressions are calculated.
		do
			context := a_context
			create written_context_cache.make (5)
		ensure
			context_set: context = a_context
			written_context_cache_not_void: written_context_cache /= Void
		end

feature -- Access

	relevant_expression_sets: ARRAYED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			-- Data structure containing sets of relevant expressions.

feature -- Element Change

	set_written_class (a_written_class: like written_class)
			-- Sets `written_class' to `a_written_class'.
			-- `a_written_class' specifies the written class for the visited AST.
		require
			a_written_class_not_void: a_written_class /= Void
		do
			written_class := a_written_class
			written_context_cache.search (a_written_class.class_id)
			if written_context_cache.found then
				written_context := written_context_cache.found_item
			else
				create {ETR_CLASS_CONTEXT} written_context.make (a_written_class)
				written_context_cache.force (written_context, a_written_class.class_id)
			end
		ensure
			written_class_set: written_class = a_written_class
		end

	set_context_class (a_context_class: like context_class)
			-- Sets `context_class' to `a_context_class'.
			-- `a_context_class' specifies the context class for the visited AST.
		require
			a_context_class_not_void: a_context_class /= Void
		do
			context_class := a_context_class
		ensure
			context_class_set: context_class = a_context_class
		end

	set_context_feature (a_context_feature: like context_feature)
			-- Sets `context_feature' to `a_context_feature'.
			-- `a_context_feature' specifies the context feature for the visited AST.
		require
			a_context_feature_not_void: a_context_feature /= Void
		do
			context_feature := a_context_feature
		ensure
			context_feature_set: context_feature = a_context_feature
		end

feature -- Basic operation

	find (a_ast: AST_EIFFEL)
			-- Find relavent rexpressions from `a_ast', make
			-- result available in `revelant_expression_sets'.
		do
			create relevant_expression_sets.make (0)
			a_ast.process (Current)
		end

feature {NONE} -- Visit operations

	process_body_as (l_as: BODY_AS)
		local
			l_feature_body_representation: STRING
		do
			l_feature_body_representation := text_from_ast (l_as)
			if
				not l_feature_body_representation.has_substring ("attached")
			then
				safe_process (l_as.arguments)
				safe_process (l_as.type)
				safe_process (l_as.assigner)
				safe_process (l_as.content)
			end
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			-- Nothing to be done
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			-- Nothing to be done
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			-- Nothing to be done
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			-- Nothing to be done
		end

	process_binary_as (l_as: BINARY_AS)
		local
			l_relevant_set: EPA_HASH_SET [EPA_EXPRESSION]
			l_left_epa: EPA_AST_EXPRESSION
			l_right_epa: EPA_AST_EXPRESSION
			l_exp: EXPR_AS
		do
			l_exp ?= ast_in_other_context (l_as.left, written_context, context)
			create l_left_epa.make_with_feature (context_class, context_feature, l_exp, context_class)

			l_exp ?= ast_in_other_context (l_as.right, written_context, context)
			create l_right_epa.make_with_feature (context_class, context_feature, l_exp, context_class)

			create l_relevant_set.make_default
			l_relevant_set.set_equality_tester (expression_equality_tester)
			l_relevant_set.force_last (l_left_epa)
			l_relevant_set.force_last (l_right_epa)

			relevant_expression_sets.extend (l_relevant_set)

			l_as.left.process (Current)
			l_as.right.process (Current)
		end

feature -- Dumping

	dumped_representation: STRING
			-- Returns a string containing the found sets of relevant expressions
			-- Structure of the string:
			-- expr_1_1,expr_1_2,...,expr_1_n;expr_2_1,expr_2_2,...,expr_2_n;...
		local
			i: INTEGER
		do
			create Result.make (256)
			across relevant_expression_sets as l_sets
			loop
				from
					l_sets.item.start
				until
					l_sets.item.after
				loop
					if i > 0 then
						Result.append_character (',')
						Result.append_character (' ')
					end
					Result.append (l_sets.item.item_for_iteration.text)
					l_sets.item.forth
					i := i + 1
				end
				Result.append (";")
			end
		ensure
			Result_not_void: Result /= Void
		end

	dump_file (a_file_path: STRING)
			-- Dumps the sets of relevant expressions into a text file into the folder specified by `a_file_path'
		require
			a_file_path_not_void: a_file_path /= Void
		local
			l_text_file: PLAIN_TEXT_FILE
			l_set_counter: INTEGER
			i: INTEGER
			l_file_path: STRING
		do
			l_file_path := a_file_path
			create l_text_file.make_create_read_write (l_file_path + "related_expressions.txt")
			l_text_file.flush

			from
				l_set_counter := 1
				i := 1
			until
				i > relevant_expression_sets.count
			loop
				if
					relevant_expression_sets.i_th (i) /= Void
				then
					l_text_file.put_string ("---Beginning of Set " + l_set_counter.out + "---")
					l_text_file.put_new_line
					l_text_file.flush
					from
						relevant_expression_sets.i_th (i).start
					until
						relevant_expression_sets.i_th (i).after
					loop
						l_text_file.put_string (relevant_expression_sets.i_th (i).item_for_iteration.text)
						l_text_file.put_string (": ")
						l_text_file.put_string (relevant_expression_sets.i_th (i).item_for_iteration.type.name)
						l_text_file.put_new_line
						l_text_file.flush
						relevant_expression_sets.i_th (i).forth
					end
					l_text_file.put_string ("---End of Set " + l_set_counter.out + "---")
					l_set_counter := l_set_counter + 1
					l_text_file.put_new_line
					l_text_file.put_new_line
					l_text_file.flush
				end
				i := i + 1
			end
			l_text_file.close
		end

	dump_console
			-- Dumps the sets of related expressions into the console
		local
			counter: INTEGER
			i: INTEGER
		do
			counter := 1

			from
				i := 1
			until
				i > relevant_expression_sets.count
			loop
				if
					relevant_expression_sets.i_th (i) /= Void
				then
					io.put_string ("---Beginning of Set " + counter.out + "---")
					io.put_new_line
					from
						relevant_expression_sets.i_th (i).start
					until
						relevant_expression_sets.i_th (i).after
					loop
						io.put_string (relevant_expression_sets.i_th (i).item_for_iteration.text)
						io.put_string (": ")
						io.put_string (relevant_expression_sets.i_th (i).item_for_iteration.type.name)
						io.put_new_line
						relevant_expression_sets.i_th (i).forth
					end
					io.put_string ("---End of Set " + counter.out + "---")
					counter := counter + 1
					io.put_new_line
					io.put_new_line
				end
				i := i + 1
			end
		end

feature {EPA_EXPRESSION_RELATION} -- Merging

	merge_not_disjoint_sets
			-- Merges the sets of relevant expressions if two different sets are not disjoint.
		local
			m,n: INTEGER
			l_count: INTEGER
			l_rev_sets: like relevant_expression_sets
		do
			l_rev_sets := relevant_expression_sets
			l_count := l_rev_sets.count
			from
				m := 1
			until
				m > l_count
			loop
				from
					n := m + 1
				until
					n > l_count
				loop
					if
						l_rev_sets.i_th (m) /= Void and then
						l_rev_sets.i_th (n) /= Void and then
						not expression_set_without_constant (l_rev_sets.i_th (m)).is_disjoint (expression_set_without_constant (l_rev_sets.i_th (n)))
					then
						l_rev_sets.i_th (m).merge (l_rev_sets.i_th (n))
						l_rev_sets.put_i_th (Void, n)
					end
					n := n + 1
				end
					-- Find the next set which may be merged with another set.
				from
					m := m + 1
				until
				   m > l_count or else l_rev_sets.i_th (m) /= Void
				loop
					m := m + 1
				end
			end
		end

	expression_set_without_constant (a_set: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- A set whose elements are non-constant elements from `a_set'.
		do
			create Result.make (a_set.count)
			Result.set_equality_tester (expression_equality_tester)
			a_set.do_if (agent Result.force_last, agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.is_constant end)
		end

feature -- Return sets

	is_relevant (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION): BOOLEAN
			-- Returns a boolean specifying if `a_expr' and `b_expr' are relevant
			-- `a_expr' specifies the first expression which should be used for comparison.
			-- `b_expr' specifies the first expression which should be used for comparison.
		require
			a_expr_not_void: a_expr /= Void
			b_expr_not_void: b_expr /= Void
		local
			i: INTEGER
			l_relevant: BOOLEAN
			l_empty_set: EPA_HASH_SET[EPA_EXPRESSION]
		do
			l_relevant := False
			from
				i := 1
			until
				i > relevant_expression_sets.count or l_relevant
			loop
				if
					relevant_expression_sets.i_th (i) /= Void and then relevant_expression_sets.i_th (i).has (a_expr) and then relevant_expression_sets.i_th (i).has (b_expr)
				then
					l_relevant := True
				end
				i := i + 1
			end
			Result := l_relevant
		end

	set_of_relevant_expressions (a_expr: EPA_EXPRESSION): EPA_HASH_SET [EPA_EXPRESSION]
			-- Returns a set containing `a_expr'. An empty set is returned when no set containing `a_expr' is found.
			-- `a_expr' specifies the expression which should be looked for.
		require
			a_expr_not_void: a_expr /= Void
		local
			i: INTEGER
			l_empty_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			create l_empty_set.make_default
			Result := l_empty_set
			from
				i := 1
			until
				i > relevant_expression_sets.count
			loop
				if
					relevant_expression_sets.i_th (i) /= Void and then relevant_expression_sets.i_th (i).has (a_expr)
				then
					Result := relevant_expression_sets.i_th (i)
				end
				i := i + 1
			end
		ensure
			Result_set: Result /= Void
		end

feature {NONE} -- Implementation

	context_class: CLASS_C
			-- Context class for the visited AST.

	written_class: CLASS_C
			-- Written class for the visited AST.

	context_feature: detachable FEATURE_I
			-- Context feature for the visited AST.

	context: ETR_CONTEXT
			-- Context from which the expressions are viewed.

	written_context: ETR_CONTEXT
			-- Context from which the expression are written.

	written_context_cache: HASH_TABLE [ETR_CONTEXT, INTEGER]
			-- Cache for created `written_context'.
			-- Keys are written class IDs, and values are contexts for those classes.

end
