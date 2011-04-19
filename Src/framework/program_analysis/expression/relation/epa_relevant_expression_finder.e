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
			process_binary_as
		end

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_CONTRACT_EXTRACTOR

create
	make

feature -- Creation Procedure

	make (a_context: like context)
			-- Creates a new relevant expression finder.
			-- Initializes `context' with `a_context'.
			-- `a_context' indicates in which scope the relevant expressions are calculated.
		do
			create relevant_expression_sets.make (0)
			context := a_context
			create written_context_cache.make (5)
		ensure
			context_set: context = a_context
			relevant_expression_sets_not_void: relevant_expression_sets /= Void
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

	find
			-- Find relevant expressions from `context', make
			-- result available in `relevant_expression_sets'.
		local
			l_feature: FEATURE_I
			l_selector: EPA_FEATURE_SELECTOR
			l_ast: AST_EIFFEL
			l_text: STRING
		do
			if attached {ETR_CLASS_CONTEXT} context as l_class_ctxt then
				set_context_class (l_class_ctxt.context_class)
				set_written_class (l_class_ctxt.written_class)
				create l_selector.default_create
				l_selector.select_from_class (l_class_ctxt.written_class)

				-- Process all features of `a_context'
				across l_selector.last_features as l_features loop
					l_feature := l_features.item

					set_context_feature (l_feature)
					set_written_class (l_feature.written_class)

					-- Process feature
					l_ast := l_feature.e_feature.ast
					l_text := text_from_ast (l_ast)
					if
						not l_text.has_substring (once "attached")
					then
						l_ast.process (Current)
					end

					-- Process preconditions
					across precondition_of_feature (l_feature, l_class_ctxt.context_class) as l_preconditions loop
						l_ast := l_preconditions.item.ast
						l_text := text_from_ast (l_ast)
						if
							not l_text.has_substring (once "attached")
						then
							l_ast.process (Current)
						end
					end

					-- Process postconditions
					across postcondition_of_feature (l_feature, l_class_ctxt.context_class) as l_postconditions loop
						l_ast := l_postconditions.item.ast
						l_text := text_from_ast (l_ast)
						if
							not l_text.has_substring (once "attached")
						then
							l_ast.process (Current)
						end
					end
				end

					-- Process invariants
				across invariant_of_class (l_class_ctxt.context_class) as l_invariants loop
					l_ast := l_invariants.item.ast
					l_text := text_from_ast (l_ast)
					if
						not l_text.has_substring (once "attached")
					then
						l_ast.process (Current)
					end
				end
			elseif attached {ETR_FEATURE_CONTEXT} context as l_feat_ctxt then
				l_feature := l_feat_ctxt.written_feature
				set_context_feature (l_feat_ctxt.written_feature)
				set_written_class (l_feat_ctxt.written_feature.written_class)
				set_context_class (l_feat_ctxt.context_class)

				-- Process feature
				l_ast := l_feature.e_feature.ast
				l_text := text_from_ast (l_ast)
				if
					not l_text.has_substring (once "attached")
				then
					l_ast.process (Current)
				end

				-- Process preconditions
				across precondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_preconditions loop
					l_ast := l_preconditions.item.ast
					l_text := text_from_ast (l_ast)
					if
						not l_text.has_substring (once "attached")
					then
						l_ast.process (Current)
					end
				end

				-- Process postconditions
				across postcondition_of_feature (l_feature, l_feat_ctxt.context_class) as l_postconditions loop
					l_ast := l_postconditions.item.ast
					l_text := text_from_ast (l_ast)
					if
						not l_text.has_substring (once "attached")
					then
						l_ast.process (Current)
					end
				end
			end
		end

feature {NONE} -- Visit operations

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
			if attached {PARAN_AS} l_exp as l_paran then
				l_exp := l_paran.expr
			end
			create l_left_epa.make_with_feature (context_class, context_feature, l_exp, context_class)

			l_exp ?= ast_in_other_context (l_as.right, written_context, context)
			if attached {PARAN_AS} l_exp as l_paran then
				l_exp := l_paran.expr
			end
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
			-- {expr_1,expr_2,...};{expr_n,...};...
		local
			i,j: INTEGER
		do
			create Result.make (256)
			i := 0
			across relevant_expression_sets as l_sets
			loop
				if i > 0 then
					Result.append_character (';')
				end
				Result.append_character ('{')
				from
					l_sets.item.start
					j := 0
				until
					l_sets.item.after
				loop
					if j > 0 then
						Result.append_character (',')
					end
					Result.append (l_sets.item.item_for_iteration.text)
					l_sets.item.forth
					j := j + 1
				end
				Result.append_character ('}')
				i := i + 1
			end
		ensure
			Result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	context_class: CLASS_C
			-- Context class for the visited AST.

	written_class: CLASS_C
			-- Written class for the visited AST.

	context_feature: FEATURE_I
			-- Context feature for the visited AST.

	context: ETR_CONTEXT
			-- Context from which the expressions are viewed.

	written_context: ETR_CONTEXT
			-- Context from which the expression are written.

	written_context_cache: HASH_TABLE [ETR_CONTEXT, INTEGER]
			-- Cache for created `written_context'.
			-- Keys are written class IDs, and values are contexts for those classes.

end
