note
	description: "Summary description for {AFX_POSTCONDITION_AS_INVARIANT_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_POSTCONDITION_AS_INVARIANT_GENERATOR

inherit
	SHARED_WORKBENCH

	AUT_CONTRACT_EXTRACTOR

	AST_ITERATOR
		redefine
			process_result_as,
			process_nested_as,
			process_object_test_as,
			process_current_as,
			process_void_as,
			process_access_feat_as,
			process_integer_as,
			process_static_access_as,
			process_real_as,
			process_bool_as,
			process_char_as,
			process_string_as,
			process_verbatim_string_as,
			process_unary_as,
			process_binary_as,
			process_paran_as,
			process_precursor_as
		end

	SHARED_SERVER

	AUT_OBJECT_STATE_REQUEST_UTILITY

feature -- Access

	last_invariants: DS_HASH_SET [AFX_EXPRESSION]
			-- Invariant clauses generate by the last `generate'.

feature -- Generate

	generate (a_class: CLASS_C)
			-- Generate invariant clauses from postconditions of features in
			-- `a_class' and store result in `last_invariants'.
			-- A feature postcondition clause can be used as an class invariant if
			-- that clause satisfies all the following rules: (The rules are designed for ease of implementation for the moment).
			-- 1. The feature is an argumentless function
			-- 2. There is no object test in the clause
			-- 3. There is no "old" expression in the clause
			-- 4. There is no nested feature call in the clause.
			-- 5. The feature is not from class ANY.
			-- 6. The return type of the feature is boolean.
		local
			l_feat_table: FEATURE_TABLE
			l_feature: FEATURE_I
			l_any_class_id: INTEGER
			l_suitable_features: LINKED_LIST [FEATURE_I]
		do
			create last_invariants.make (10)
			last_invariants.set_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})
			context_class := a_class

			l_any_class_id := system.any_class.compiled_representation.class_id
			l_feat_table := a_class.feature_table
			create l_suitable_features.make

				-- Select suitable features.
			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				l_feature := l_feat_table.item_for_iteration
				if
					l_feature.argument_count = 0 and then
					l_feature.type.actual_type.is_boolean and then
					l_feature.written_class.class_id /= l_any_class_id
				then
					l_suitable_features.extend (l_feature)
				end
				l_feat_table.forth
			end

				-- Generate invariant clauses from postconditions
				-- of features in `l_suitable_features'.
			l_suitable_features.do_all (agent generate_for_feature)
		end

feature{NONE} -- Implementation

	text: STRING
			-- Text for the invariant class that is
			-- be generated.

	context_class: CLASS_C
			-- Context class

	context_feature: FEATURE_I
			-- Context feature

	current_written_class: CLASS_C
			-- Written class of the currently
			-- processed postcondtition clause

	is_suitable_as_invariant: BOOLEAN
			-- Is currently processed postcondition clause suitable
			-- as an class invariant?

	is_result_mentioned: BOOLEAN
			-- Is "Result" mentioned in the currently processed
			-- postcondition clause?

	generate_for_feature (a_feature: FEATURE_I)
			-- Generate invariant clauses from postconditions
			-- of `a_feature', store result in `last_invariants'.
		local
			l_posts: LINKED_LIST [detachable AUT_EXPRESSION]
			l_post_gen: AFX_SIMPLE_FUNCTION_POSTCONDITION_GENERATOR
			l_post_str: detachable STRING
			l_post_expr: AUT_EXPRESSION
		do
			l_posts := postcondition_of_feature (a_feature, context_class)

--			if l_posts.is_empty and then not a_feature.has_postcondition then
				-- Generate simple postcondition if the feature body is
				-- a single assignment to Result.
			context_feature := a_feature
			current_written_class := context_class
			create l_post_gen
			l_post_gen.generate (context_class, a_feature)
			l_post_str := l_post_gen.last_postcondition
			if l_post_str /= Void and then not l_post_str.is_empty then
				generate_invariant_from_string (l_post_str)
			end
--			else

			from
				l_posts.start
			until
				l_posts.after
			loop
				if l_posts.item_for_iteration /= Void then
					current_written_class := l_posts.item_for_iteration.written_class
					generate_invariant_from_string (l_posts.item_for_iteration.text)
				end
				l_posts.forth
			end
--		end
		end

--	generate_invariant_from_postcondition (a_expression: AUT_EXPRESSION)
--			-- Generate class invariant clause from `a_expression' from `context_feature' if
--			-- `a_expression' satisfies the conditions defined in `generate'.
--		local
--			l_expr: AFX_AST_EXPRESSION
--		do
--			current_written_class := a_expression.written_class
--			is_suitable_as_invariant := True
--			is_result_mentioned := False
--			create text.make (64)

--			a_expression.ast.process (Current)
--			if is_suitable_as_invariant and then is_result_mentioned then
--				create l_expr.make_with_text (context_class, context_feature, text, current_written_class)
--				last_invariants.force_last (l_expr)
--			end
--		end

	generate_invariant_from_string (a_text: STRING)
			-- Generate class invariant clause from `a_text'.
		local
			l_expr: AFX_AST_EXPRESSION
		do
			is_suitable_as_invariant := True
			is_result_mentioned := False
			create text.make (64)
			create l_expr.make_with_text (context_class, context_feature, a_text, current_written_class)

			l_expr.ast.process (Current)
			if is_suitable_as_invariant and then is_result_mentioned then
				create l_expr.make_with_text (context_class, context_feature, text, current_written_class)
				last_invariants.force_last (l_expr)
			end
		end

feature{NONE} -- Process

	process_result_as (l_as: RESULT_AS)
		do
			if is_suitable_as_invariant then
				is_result_mentioned := True
				text.append (context_feature.written_class.feature_of_body_index (context_feature.body_index).feature_name)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_current_as (l_as: CURRENT_AS)
		do
			if is_suitable_as_invariant then
				text.append (once "Current")
			end
		end

	process_void_as (l_as: VOID_AS)
		do
			if is_suitable_as_invariant then
				text.append (once "Void")
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_final_feature: detachable FEATURE_I
		do
			if is_suitable_as_invariant then
				l_final_feature := final_feature (l_as.access_name, current_written_class, context_class)
				check l_final_feature /= Void end
				text.append (l_final_feature.feature_name)
				if l_as.internal_parameters /= Void then
					text.append ("(")
					safe_process (l_as.internal_parameters)
					text.append (")")
				end
			end
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			if is_suitable_as_invariant then
				text.append (l_as.integer_32_value.out)
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_real_as (l_as: REAL_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if is_suitable_as_invariant then
				text.append (l_as.value.out)
			end
		end

	process_char_as (l_as: CHAR_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_string_as (l_as: STRING_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

	process_unary_as (l_as: UNARY_AS)
		do
			if is_suitable_as_invariant then
				text.append (l_as.operator_name)
				text.append_character (' ')
				l_as.expr.process (Current)
			end
		end

	process_binary_as (l_as: BINARY_AS)
		do
			if is_suitable_as_invariant then
				l_as.left.process (Current)
				text.append_character (' ')
				text.append (l_as.op_name.name)
				text.append_character (' ')
				l_as.right.process (Current)
			end
		end

	process_paran_as (l_as: PARAN_AS)
		do
			if is_suitable_as_invariant then
				text.append_character ('(')
				l_as.expr.process (Current)
				text.append_character (')')
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			fixme ("Support this later. 11.30.2009 Jasonw")
			is_suitable_as_invariant := False
		end

end
