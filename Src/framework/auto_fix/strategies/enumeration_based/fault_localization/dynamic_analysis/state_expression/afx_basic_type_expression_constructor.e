note
	description: "Summary description for {AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR

inherit

	AFX_UTILITY

	SHARED_WORKBENCH

	AFX_SHARED_SESSION

feature -- Access

	last_constructed_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Constructed expressions.
		do
			if last_constructed_expressions_cache = Void then
				create last_constructed_expressions_cache.make_equal (20)
			end
			Result := last_constructed_expressions_cache
		end

feature -- Basic operation

	construct_from (a_expressions: EPA_HASH_SET [EPA_EXPRESSION])
			-- Construct basic-typed expressions, based on `a_expressions', into `last_constructed_expressions'.
		require
			expressions_attached: a_expressions /= Void
		local
			l_exp: EPA_EXPRESSION
			l_exp_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			from
				create l_exp_set.make_equal (a_expressions.count + 1)
				a_expressions.start
			until
				a_expressions.after
			loop
				construct_from_expression (a_expressions.item_for_iteration)
				l_exp_set.merge (last_constructed_expressions)

				a_expressions.forth
			end

			last_constructed_expressions_cache := l_exp_set
		end

	construct_from_expression (a_expression: EPA_EXPRESSION)
			-- Construct basic-typed expressions, based on `a_expression', into `last_constructed_expressions'.
		require
			expression_attached: a_expression /= Void
		do
			construct_from_expression_internal (a_expression)
		end

feature{NONE} -- Add result expression

	add_expression (a_expr: EPA_EXPRESSION)
			-- Add `a_expr', if basic-typed, into `expressions_to_monitor'.
		require
			expr_attached: a_expr /= Void
		do
			if a_expr.type /= Void and then (a_expr.type.is_integer or else a_expr.type.is_boolean) then
				last_constructed_expressions.force (a_expr)
			end
		end

	add_expression_with_text (a_origin_expr: EPA_EXPRESSION; a_text: STRING)
			-- Add a expression derived from `a_origin_expr', if basic-typed, to `expressions_to_monitor'.
			-- The expression has the text `a_text'.
		require
			expr_attached: a_origin_expr /= Void
			text_not_empty: a_text /= Void and then not a_text.is_empty
		local
			l_expr: EPA_AST_EXPRESSION
		do
			create l_expr.make_with_text (a_origin_expr.class_, a_origin_expr.feature_, a_text, a_origin_expr.written_class)
			add_expression (l_expr)
		end

feature{NONE} -- Implementation

	construct_from_expression_internal (a_expression: EPA_EXPRESSION)
			-- Construct basic-typed expressions based on `a_expression'.
		require
			expression_attached: a_expression /= Void
		local
			l_result_type: TYPE_A
			l_result_class, l_context_class, l_written_class: CLASS_C
			l_context_feature:FEATURE_I
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING_32
			l_exp_text: STRING
			l_new_expression: EPA_AST_EXPRESSION
			l_interesting_features: DS_ARRAYED_LIST[FEATURE_I]
		do
			reset_constructor

			l_result_type := resolve_actual_type (a_expression.type, a_expression.context_class.actual_type, a_expression.context_class)
			if l_result_type /= Void and then (l_result_type.is_integer or else l_result_type.is_boolean) then
					-- Basic type, monitor the value of the expression directly.
				add_expression (a_expression)
			elseif l_result_type /= Void and then not l_result_type.is_formal
					and then not l_result_type.is_void and then not l_result_type.is_basic
			then
					-- Reference type
				l_result_class := l_result_type.associated_class
				l_context_class := a_expression.class_
				l_written_class := a_expression.written_class
				l_context_feature := a_expression.feature_

					-- Void-check.
				add_expression_with_text (a_expression, "("+a_expression.text+")  = Void")
				add_expression_with_text (a_expression, "("+a_expression.text+") /= Void")

					-- Monitor argument-less query calls on this object.
					-- Feature calls on "Current" object don't need to be qualified.
				if a_expression.text.is_case_insensitive_equal ("current") then
					l_exp_text := ""
				else
					l_exp_text := "(" + a_expression.text + ")."
				end
				l_interesting_features := interface_argumentless_queries (l_result_class)
				from l_interesting_features.start
				until l_interesting_features.after
				loop
					add_expression_with_text (a_expression, l_exp_text + l_interesting_features.item_for_iteration.feature_name_32)
					l_interesting_features.forth
				end
			end
		end

	reset_constructor
			-- <Precursor>
		do
			last_constructed_expressions_cache := Void
		end

	resolve_actual_type (a_type, a_context_type: TYPE_A; a_context_class: CLASS_C): TYPE_A
			-- Resolve actual type of `a_type', given `a_context_type' and `a_context_class'.
		local
		    l_actual_type: TYPE_A
		do
		    l_actual_type := a_type.instantiation_in(a_context_type, a_context_class.class_id).deep_actual_type

			if attached {FORMAL_A} l_actual_type as l_formal then
			    if not l_formal.is_multi_constrained (a_context_class) then
					l_actual_type := l_formal.constrained_type (a_context_class)
				else
				    check multi_constrained_formal_not_supported: False end
				end
			end

			Result := l_actual_type
		ensure
			result_attached: Result /= Void
		end

	interface_argumentless_queries (a_class: CLASS_C): DS_ARRAYED_LIST[FEATURE_I]
			-- List of interface argumentless queries of `a_class'.
		require
			class_attached: a_class /= Void
		local
			l_string_class, l_super_class: CLASS_C
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING
		do
				-- Super class whose features shall be excluded.
			l_string_class := first_class_starts_with_name ("STRING_GENERAL")
			if a_class.conform_to (l_string_class) then
				l_super_class := l_string_class
			else
				l_super_class := system.any_class.compiled_representation
			end

				-- Interface argumentless queries.			
			from
				l_feature_table := a_class.feature_table
				create Result.make (l_feature_table.count + 1)
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration
				l_feature_type := l_next_feature.type
				l_feature_name := l_next_feature.feature_name_32

				if
					l_next_feature.argument_count = 0	-- Argumentless
					and then l_next_feature.is_exported_for (system.any_class.compiled_representation)	-- Public
					and then (l_feature_type /= Void and then l_feature_type.is_boolean)  	-- BOOLEAN type query
					and then not l_next_feature.is_obsolete	-- Not obsolete
					and then not l_next_feature.is_once		-- Not once
					and then (String_queries.has (l_feature_name) or else not is_feature_from_class (l_next_feature, l_super_class))	-- Interesting
				then
					Result.put_last (l_next_feature)
				end

				l_feature_table.forth
			end
		end

	String_queries: DS_ARRAYED_LIST[STRING]
		once
			create Result.make (6)
			Result.force_last ("is_empty")
			Result.force_last ("full")
			Result.force_last ("prunable")
			Result.force_last ("extendible")
			Result.force_last ("count")
			Result.force_last ("capacity")
		end

	is_feature_from_class (a_feature: FEATURE_I; a_class: CLASS_C): BOOLEAN
			-- Is `a_feature' available in `a_class'?
		do
			Result := a_class.feature_of_rout_id_set (a_feature.rout_id_set) /= Void
		end

feature -- Cache

	last_constructed_expressions_cache: like last_constructed_expressions
			-- Cache for `last_constructed_expressions'.

end
