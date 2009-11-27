note
	description: "[
			Find implications that appear in source code.
			Those implications can be used as candidate predicates for the state model.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_IMPLICATION_FINDER

inherit
	AST_ITERATOR
		redefine
			process_bin_implies_as,
			process_access_feat_as,
			process_result_as,
			process_nested_as
		end

	SHARED_WORKBENCH

	REFACTORING_HELPER

	AUT_OBJECT_STATE_REQUEST_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			initialize
		end

feature -- Access

	last_implications: LINKED_LIST [TUPLE [premise:AFX_EXPRESSION; consequent: AFX_EXPRESSION]]
			-- Implications that are found by the last `generate'.
			-- Every tuple represents an implication: `premise' -> `consequent'.
			-- The exact text `premise' -> `consequent' may not appear in code,
			-- it can be automatically generated as some guesses by current finder.

feature -- Basic operations

	generate (a_class: CLASS_C; a_feature: detachable FEATURE_I)
			-- Generate implications that are mentioned in the code of `a_class' and
			-- store result in `last_implications'.
		local
			l_contract_extractor: AUT_CONTRACT_EXTRACTOR
			l_inv: LIST [AUT_EXPRESSION]
			l_features: like features
			l_feat: FEATURE_I
			l_exprs: LINKED_LIST [TUPLE [expr: AUT_EXPRESSION; feat: detachable FEATURE_I]]
		do
			create l_exprs.make

			context_class := a_class
			context_feature := a_feature
			create l_contract_extractor

				-- Collect assertions from class invariants.
			append_expressions (l_contract_extractor.invariant_of_class (a_class), Void, l_exprs)

				-- Collect assertions from pre/post conditions in features.			
			from
				l_features := features (a_class)
				l_features.start
			until
				l_features.after
			loop
				l_feat := l_features.item_for_iteration
				append_expressions (l_contract_extractor.precondition_of_feature (l_feat, a_class), l_feat, l_exprs)
				append_expressions (l_contract_extractor.postcondition_of_feature (l_feat, a_class), l_feat, l_exprs)
				l_features.forth
			end

			fixme ("We may also check implications in feature body too. 27.11.2009 Jasonw")

				-- Generate implications from `l_exprs'.
			from
				l_exprs.start
			until
				l_exprs.after
			loop
				generate_implications (l_exprs.item_for_iteration.expr, l_exprs.item_for_iteration.feat)
				l_exprs.forth
			end
		end

feature{NONE} -- Implementation

	context_class: CLASS_C
			-- Context class

	context_feature: detachable FEATURE_I
			-- Context feature

	current_feature: detachable FEATURE_I
			-- Current feature

	written_class: CLASS_C
		-- Written class of the AST being processed

feature{NONE} -- Implementation

	premise_stack: ARRAYED_STACK [LINKED_LIST [AFX_EXPRESSION]]
			-- Stack for premises

	consequent_stack: ARRAYED_STACK [LINKED_LIST [AFX_EXPRESSION]]
			-- Stack for consequents

	term_writer: detachable PROCEDURE [ANY, TUPLE [a_expr: AFX_EXPRESSION]]
			-- Agent to call when a term is found

	final_expression: detachable AFX_AST_EXPRESSION
			-- Final name of the last found identifier

feature{NONE} -- Implementation

	initialize
			-- Initialize data structure for generation.
		do
			create last_implications.make
			create premise_stack.make (3)
			create consequent_stack.make (3)
		end

	generate_implications (a_expr: AUT_EXPRESSION; a_feature: detachable FEATURE_I)
			-- Generate implications from `a_expr'
		do
			premise_stack.wipe_out
			consequent_stack.wipe_out
			written_class := a_expr.written_class
			current_feature := a_feature
			a_expr.ast.process (Current)
		end

	features (a_class: CLASS_C): LINKED_LIST [FEATURE_I]
			-- Features from `a_class' which are not written in class ANY.
		local
			l_feat_table: FEATURE_TABLE
			l_feat: FEATURE_I
		do
			create Result.make
			l_feat_table := a_class.feature_table
			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				if not is_written_in_any (l_feat_table.item_for_iteration) then
					Result.extend (l_feat_table.item_for_iteration)
				end
				l_feat_table.forth
			end
		end

	is_written_in_any (a_feature: FEATURE_I): BOOLEAN
			-- Is `a_feature' written in ANY?
		do
			Result := a_feature.written_class.class_id = system.any_class.compiled_representation.class_id
		end

	append_expressions (a_assertions: LIST [AUT_EXPRESSION]; a_context_feature: detachable FEATURE_I; a_list: LINKED_LIST [TUPLE [expr: AUT_EXPRESSION; feat: detachable FEATURE_I]])
			-- Append `a_assertions' in `a_context_feature' into `a_list'.
		do
			from
				a_assertions.start
			until
				a_assertions.after
			loop
				a_list.extend ([a_assertions.item_for_iteration, a_context_feature])
				a_assertions.forth
			end
		end

	check_name (a_name: STRING)
			-- Check if access name `a_name' is a feature name,
			-- If so, turn it into an expression and store that
			-- expression in `final_expression'. Otherwise, set
			-- `final_expression' to Void.
		local
			l_feat: detachable FEATURE_I
			l_done: BOOLEAN
			l_expr: AFX_AST_EXPRESSION
		do
				-- Check if `a_name' is a feature name.
			check written_class /= Void end
			l_feat := final_feature (a_name, written_class, context_class)
			if
				l_feat /= Void and then
				l_feat.type.actual_type.is_boolean and then
				l_feat.argument_count = 0 and then
				not is_written_in_any (l_feat)
			then
				create l_expr.make_with_text (context_class, context_feature, l_feat.feature_name.as_lower, written_class)
				if term_writer /= Void then
					term_writer.call ([l_expr])
				end
			else
				final_expression := Void
			end
		end

	implications_from_components (a_premises: LINKED_LIST [AFX_EXPRESSION]; a_consequents: LINKED_LIST [AFX_EXPRESSION]): like last_implications
			-- List of implications that are constructed from `a_premises' and `a_consequents'.
			-- The result is an acoss product between `a_premises' and `a_consequents'.
			-- This means that some returned implications may not really appear in the source code, they are just guesses.
		do
			create Result.make
			from
				a_premises.start
			until
				a_premises.after
			loop
				from
					a_consequents.start
				until
					a_consequents.after
				loop
					Result.extend ([a_premises.item_for_iteration, a_consequents.item_for_iteration])
					a_consequents.forth
				end
				a_premises.forth
			end
		end

feature{NONE} -- Process

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		local
			l_premises: LINKED_LIST [AFX_EXPRESSION]
			l_consequents: LINKED_LIST [AFX_EXPRESSION]
			l_implication: AFX_IMPLICATION_EXPR
		do
			fixme ("No support for nested implications in source code for the moment. 27.11.2009 Jasonw")
			create l_premises.make
			create l_consequents.make

			premise_stack.put (l_premises)
			consequent_stack.put (l_consequents)

			term_writer := agent extend_expression (?, l_premises)
			l_as.left.process (Current)

			term_writer := agent extend_expression (?, l_consequents)
			l_as.right.process (Current)
			term_writer := Void

				-- Construct implications from collected premises and consequents.
			if not l_premises.is_empty and then not l_consequents.is_empty then
				last_implications.append (implications_from_components (l_premises, l_consequents))
			end

			premise_stack.remove
			consequent_stack.remove
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			check_name (l_as.access_name)
			fixme ("Does not support query with arguments for the moment. 26.11.2009 Jasonw")
		end

	process_result_as (l_as: RESULT_AS)
		do
			if current_feature /= Void then
				check_name (current_feature.feature_name.as_lower)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			fixme ("Does not support nested expressions for the moment. 26.11.2009 Jasonw")
		end

	extend_expression (a_expr: AFX_EXPRESSION; store: LINKED_LIST [AFX_EXPRESSION])
			-- Extend `a_expr' into `store'.
		do
			store.extend (a_expr)
		end

end
