note
	description: "Summary description for {AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR

inherit
	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

	SHARED_WORKBENCH

	AFX_SHARED_SESSION

feature -- Access

	expressions_from_feature: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION] assign set_expressions_from_feature
			-- Expressions collected directly from a feature.
			-- The collector would build expressions to be monitored based on these expressions.

	expressions_to_monitor: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Set of expressions to monitor, according to `expressions_from_feature'.
			-- Expressions with different breakpoint indexes are considered different.
		require
			expressions_attached: expressions_from_feature /= Void
		do
			if expressions_to_monitor_cache = Void then
				create expressions_to_monitor_cache.make (expressions_from_feature.count * 3 + 1)
				expressions_to_monitor_cache.set_equality_tester (breakpoint_specific_equality_tester)
			end
			Result := expressions_to_monitor_cache
		end

feature -- Basic operation

	collect_from (a_expressions: like expressions_from_feature)
			-- Collect expressions to monitor from `a_expression'.
		require
			expression_attached: a_expressions /= Void
		local
			l_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_exp_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			set_expressions_from_feature (a_expressions)

--			if not expressions_from_feature.is_empty then
--				expressions_to_monitor_cache := Void
--			else
				from expressions_from_feature.start
				until expressions_from_feature.after
				loop
					l_exp := expressions_from_feature.item_for_iteration

					l_exp_set := collect_from_expression (l_exp)
					expressions_to_monitor.append (l_exp_set)

					expressions_from_feature.forth
				end
--			end
		end

	reset_collector
			-- Reset the internal state of the collector.
		do
			expressions_to_monitor_cache := Void
		end

feature -- Status set

	set_expressions_from_feature (a_exprs: like expressions_from_feature)
			-- Set `expressions_from_feature'.
		require
			exprs_attached: a_exprs /= Void
		do
			expressions_from_feature := a_exprs

			reset_collector
		end

feature{NONE} -- Implementation

	collect_from_expression (a_expression: AFX_PROGRAM_STATE_EXPRESSION): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Collect expressions to monitor based on `a_expression'.
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
			l_new_expression: AFX_PROGRAM_STATE_EXPRESSION
		do
			create Result.make_equal (1)

			l_result_type := a_expression.type
			if l_result_type /= Void and then (l_result_type.is_integer or else l_result_type.is_boolean) then
				-- Monitor the value of the expression directly.
				Result.force (a_expression)
			elseif l_result_type /= Void and then not l_result_type.is_formal and then not l_result_type.is_void and then not l_result_type.is_basic then
				-- Monitor argument-less query calls on this object.
				l_result_class := l_result_type.associated_class
				l_context_class := a_expression.class_
				l_written_class := a_expression.written_class
				l_context_feature := a_expression.feature_

				l_feature_table := l_result_class.feature_table
				Result.resize (l_feature_table.count + 1)

				-- Feature calls on "Current" object don't need to be qualified.
				l_exp_text := a_expression.text
				if l_exp_text.is_case_insensitive_equal ("current") then
					l_exp_text := ""
				else
					l_exp_text := "(" + a_expression.text + ")."
				end

				from l_feature_table.start
				until l_feature_table.after
				loop
					l_next_feature := l_feature_table.item_for_iteration
					l_feature_type := l_next_feature.type
					l_feature_name := l_next_feature.feature_name_32
					if is_interface_argumentless_query (l_next_feature) then
						if (l_feature_type.is_integer or else l_feature_type.is_boolean) and then not (l_next_feature.is_obsolete or else l_next_feature.is_once) then
							create l_new_expression.make_with_text (l_context_class, l_context_feature, l_exp_text + l_feature_name, l_written_class, 0)
							if l_new_expression.type /= Void then
								l_new_expression.set_originate_expression (a_expression)
								Result.force (l_new_expression)
							end
						end
					end
					l_feature_table.forth
				end
			end
		end

	is_interface_argumentless_query (a_feature: FEATURE_I): BOOLEAN
			-- Set these expressions as originated from `Current'.
		do
			if a_feature.written_class.class_id /= system.any_class.compiled_representation.class_id
					and then a_feature.argument_count = 0
					and then a_feature.is_exported_for (system.any_class.compiled_representation)
					and then (a_feature.type /= Void and then not a_feature.type.is_void)
			then
				Result := True
			end
		end

feature -- Cache

	expressions_to_monitor_cache: like expressions_to_monitor
			-- Cache for `expressions_to_monitor'.

end
