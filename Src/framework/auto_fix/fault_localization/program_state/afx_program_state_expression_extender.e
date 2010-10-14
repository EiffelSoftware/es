note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION_EXTENDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_PROGRAM_STATE_EXPRESSION_EXTENDER

inherit
	SHARED_WORKBENCH

feature -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
		require
			config_attached: a_config /= Void
		do
			config := a_config
		end

	make_with_original_expressions (a_config: AFX_CONFIG; a_expressions: like original_expressions)
			-- Initialization.
		require
			config_attached: a_config /= Void
			expressions_attached: a_expressions /= Void
		do
			make (a_config)
			set_original_expressions (a_expressions)
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix configuration.

	original_expressions: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION] assign set_original_expressions
			-- Original set of expressions.
			-- Contents in this set would not be changed by the extender.

	extended_expressions: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Extended set of expressions.
		require
			original_expressions_attached: original_expressions /= Void
		do
			if extended_expressions_cache = Void then
				create extended_expressions_cache.make_equal (original_expressions.count * 5 + 1)
			end

			Result := extended_expressions_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	extend_original_expressions
			-- Compute the extended expressions on the basis of `original_expressions'.
			-- Make the result available in `extended_expressions'.
		require
			original_expression_attached: original_expressions /= Void
		deferred
		end

	clear_extender
			-- Clear last extending result.
		do
			extended_expressions_cache := Void
		end

feature -- Status set

	set_original_expressions (a_expressions: like original_expressions)
			-- Set `original_expressions'.
		require
			expressions_attached: a_expressions /= Void
		do
			original_expressions := a_expressions
			clear_extender
		ensure
			original_expressions_attached: original_expressions = a_expressions
							and then original_expressions /= Void
			extended_expressions_cleared: extended_expressions_cache = Void
		end

feature{NONE} -- Selecting expressions

	integral_expressions (a_expressions: like original_expressions): like original_expressions
			-- All expressions of type {INTEGER} from `a_expressions'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_type: TYPE_A
			l_expressions: like original_expressions
		do
			create l_expressions.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if l_type.is_integer then
					l_expressions.force (l_exp)
				end

				a_expressions.forth
			end

			Result := l_expressions
		end

	boolean_expressions (a_expressions: like original_expressions): like original_expressions
			-- All expressions of type {BOOLEAN} from `a_expressions', and their negations.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp, l_neg_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_type: TYPE_A
			l_expressions: like original_expressions
		do
			create l_expressions.make_equal (a_expressions.count * 2 + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if l_type.is_boolean then
					l_expressions.force (l_exp)

					-- Since `negated' return only an expression of type {EPA_AST_EXPRESSION}, we need
					--		to construct an appropriate object based on it.
					check attached {EPA_AST_EXPRESSION} l_exp.negated as lt_neg_exp then
						create l_neg_exp.make_with_text (lt_neg_exp.context_class, lt_neg_exp.feature_, lt_neg_exp.text, lt_neg_exp.written_class, l_exp.breakpoint_slot)
						l_expressions.force (l_neg_exp)
					end
				end

				a_expressions.forth
			end

			Result := l_expressions
		end

	object_expressions (a_expressions: like original_expressions):like original_expressions
			-- All expressions returning objects from `a_expressions'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_type: TYPE_A
			l_expressions: like original_expressions
		do
			create l_expressions.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if not l_type.is_formal and then not l_type.is_void and then not l_type.is_basic then
					l_expressions.force (l_exp)
				end
				a_expressions.forth
			end

			Result := l_expressions
		end

feature{NONE} -- Constructing expressions

	extended_expressions_on_integrals (a_integrals: like original_expressions): like original_expressions
			-- Boolean expressions based on integral expressions from `a_integrals'.
			-- Including both sign testing expressions and relational expressions.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			integrals_attached: a_integrals /= Void
		do
			Result := sign_testing_expressions_on_integrals (a_integrals)
			Result.append (relational_expressions_on_integrals (a_integrals))
		end

	sign_testing_expressions_on_integrals (a_integrals: like original_expressions): like original_expressions
			-- Sign testing expressions built on integral expressions from `a_integrals'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			integrals_attached: a_integrals /= Void
		local
			l_exp, l_new_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_expressions: like original_expressions
		do
			if a_integrals.is_empty then
				create Result.make_equal (1)
			else
				create Result.make_equal (a_integrals.count * 5 + 1)

				from a_integrals.start
				until a_integrals.after
				loop
					l_exp := a_integrals.item_for_iteration

					l_expressions := sign_testing_expressions_on_one_integral (l_exp)
					set_originate_expression (l_expressions, l_exp)
					Result.append (l_expressions)

					a_integrals.forth
				end
			end
		ensure
			result_attached: Result /= VOid
		end

	relational_expressions_on_integrals (a_integrals: like original_expressions): like original_expressions
			-- Relational expressions built on integral expressions from `a_integrals'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			integrals_attached: a_integrals /= Void
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_combinations: LINKED_LIST [like original_expressions]
			l_comb, l_expressions: like original_expressions
			l_op1, l_op2, l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_text1, l_text2: STRING
		do
			if a_integrals.count < 2 then
				-- Not enough integrals, return empty result.
				create Result.make_equal (1)
			else
				l_combinations := a_integrals.combinations (2)
				create Result.make_equal (l_combinations.count * 5 + 1)
				from
					l_combinations.start
				until
					l_combinations.after
				loop
					l_comb := l_combinations.item_for_iteration
					check l_comb.count = 2 end

					l_op1 := l_comb.first
					l_op2 := l_comb.last

					l_expressions := relational_expressions_on_two_integrals (l_op1, l_op2)
					set_originate_expression (l_expressions, l_op1)
					add_originate_expression (l_expressions, l_op2)
					Result.append (l_expressions)

					l_combinations.forth
				end
			end
		ensure
			result_attached: Result /= VOid
		end

	boolean_expressions_on_objects (a_objects: like original_expressions): like original_expressions
			-- Boolean expression based on object expressions.
			-- Construct expressions using these objects and their queries of type {INTEGER} or {BOOLEAN}.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			objects_attached: a_objects /= Void
			all_object_expressions: True
		local
			l_obj_exp, l_new_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_obj_type: TYPE_A
			l_obj_class, l_exp_class: CLASS_C
			l_exp_feature: FEATURE_I
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING_32
			l_exp_text: STRING
			l_integral_list, l_boolean_list: like original_expressions
		do
			if a_objects.is_empty then
				create Result.make_equal (1)
			else
				create Result.make_equal (a_objects.count * 7 + 1)
				-- Iterate through object expressions.
				from a_objects.start
				until a_objects.after
				loop
					l_obj_exp := a_objects.item_for_iteration

					l_obj_type := l_obj_exp.type.actual_type
					l_obj_class := l_obj_type.associated_class
					l_exp_class := l_obj_exp.class_
					l_exp_feature := l_obj_exp.feature_
					l_exp_text := "(" + l_obj_exp.text + ")"

					l_feature_table := l_obj_class.feature_table
					create l_integral_list.make_equal (l_feature_table.count + 1)
					create l_boolean_list.make_equal (l_feature_table.count + 1)
					-- Iterate through the feature table.
					from
						l_feature_table.start
					until
						l_feature_table.after
					loop
						l_next_feature := l_feature_table.item_for_iteration
						l_feature_type := l_next_feature.type
						l_feature_name := l_next_feature.feature_name_32
						if is_interface_argumentless_query (l_next_feature) then
							if l_feature_type.is_integer then
								create l_new_exp.make_with_text (l_exp_class, l_exp_feature, l_exp_text + "." + l_feature_name, l_exp_feature.written_class, 0)
								l_integral_list.force (l_new_exp)
							elseif l_feature_type.is_boolean then
								create l_new_exp.make_with_text (l_exp_class, l_exp_feature, l_exp_text + "." + l_feature_name, l_exp_feature.written_class, 0)
								l_boolean_list.force (l_new_exp)
							end
						end
						l_feature_table.forth
					end

					-- Add extended expressions into `Result'.
					set_originate_expression (l_boolean_list, l_obj_exp)
					Result.append (l_boolean_list)

					l_boolean_list := extended_expressions_on_integrals (l_integral_list)
					set_originate_expression (l_boolean_list, l_obj_exp)
					Result.append (l_boolean_list)

					a_objects.forth
				end
			end
		end

feature{NONE} -- Change expressions

	set_breakpoint_slot (a_expressions: like original_expressions; a_index: INTEGER)
			-- Set the `breakpoint_slot' of all expressions in `a_expressions' with `a_index'.
		require
			expressions_attached: a_expressions /= Void
			valid_index: a_index >= 0
		local
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
		do
			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_exp.set_breakpoint_slot (a_index)

				a_expressions.forth
			end
		end

	set_originate_expression (a_expressions: like original_expressions; a_originate: EPA_PROGRAM_STATE_EXPRESSION)
			-- Set `a_originate' as an originate expression to all expressions from `a_expressions'.
		require
			expressions_attached: a_expressions /= Void
			originate_attached: a_originate /= Void
		local
		do
			from a_expressions.start
			until a_expressions.after
			loop
				a_expressions.item_for_iteration.set_originate_expression (a_originate)

				a_expressions.forth
			end
		end

	add_originate_expression (a_expressions: like original_expressions; a_originate: EPA_PROGRAM_STATE_EXPRESSION)
			-- Add `a_originate' as an originate expression to all expressions from `a_expressions'.
		require
			expressions_attached: a_expressions /= Void
			originate_attached: a_originate /= Void
		local
		do
			from a_expressions.start
			until a_expressions.after
			loop
				a_expressions.item_for_iteration.add_originate_expression (a_originate)

				a_expressions.forth
			end
		end

feature{NONE} -- Implementation

	sign_testing_expressions_on_one_integral (a_exp: EPA_PROGRAM_STATE_EXPRESSION): like original_expressions
			-- Sign testing expressions built on one integral expression `a_exp'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			exp_attached: a_exp /= Void
		local
			l_class, l_written_class: CLASS_C
			l_feature: FEATURE_I
			l_new_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_text: STRING
		do
			l_class := a_exp.class_
			l_feature := a_exp.feature_
			l_written_class := l_feature.written_class
			l_text := "(" + a_exp.text + ")"

			create Result.make_equal (5)

			create l_new_exp.make_with_text (l_class, l_feature, l_text + " >= 0", l_written_class, 0)
			Result.force_last (l_new_exp)

			create l_new_exp.make_with_text (l_class, l_feature, l_text + " > 0", l_written_class, 0)
			Result.force_last (l_new_exp)

			create l_new_exp.make_with_text (l_class, l_feature, l_text + " = 0", l_written_class, 0)
			Result.force_last (l_new_exp)

			create l_new_exp.make_with_text (l_class, l_feature, l_text + " < 0", l_written_class, 0)
			Result.force_last (l_new_exp)

			create l_new_exp.make_with_text (l_class, l_feature, l_text + " <= 0", l_written_class, 0)
			Result.force_last (l_new_exp)

		end

	relational_expressions_on_two_integrals (a_integral1, a_integral2: EPA_PROGRAM_STATE_EXPRESSION): like original_expressions
			-- Relational expressions on two integrals `a_integral1' and `a_integral2'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			integrals_attached: a_integral1 /= Void and then a_integral2 /= Void
		local
			l_class, l_written_class: CLASS_C
			l_feature: FEATURE_I
			l_text1, l_text2: STRING
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
		do
			l_class := a_integral1.class_
			l_feature := a_integral1.feature_
			l_written_class := l_feature.written_class
			l_text1 := "(" + a_integral1.text + ")"
			l_text2 := "(" + a_integral2.text + ")"

			create Result.make_equal (5)
			create l_exp.make_with_text (l_class, l_feature, l_text1 + " >= " + l_text2, l_written_class, 0)
			Result.force (l_exp)

			create l_exp.make_with_text (l_class, l_feature, l_text1 + " > " + l_text2, l_written_class, 0)
			Result.force (l_exp)

			create l_exp.make_with_text (l_class, l_feature, l_text1 + " = " + l_text2, l_written_class, 0)
			Result.force (l_exp)

			create l_exp.make_with_text (l_class, l_feature, l_text1 + " < " + l_text2, l_written_class, 0)
			Result.force (l_exp)

			create l_exp.make_with_text (l_class, l_feature, l_text1 + " <= " + l_text2, l_written_class, 0)
			Result.force (l_exp)
		ensure
			result_attached: Result /= VOid
		end

	is_interface_argumentless_query (a_feature: FEATURE_I): BOOLEAN
			-- Set these expressions as originated from `Current'.
		do
			if a_feature.written_class.class_id /= system.any_class.compiled_representation.class_id
					and then a_feature.argument_count = 0
					and then a_feature.is_exported_for (system.any_class.compiled_representation)
			then
				Result := True
			end
		end

feature{NONE} -- Cache

	extended_expressions_cache: like extended_expressions
			-- Cache for `extended_expressions'.

end
