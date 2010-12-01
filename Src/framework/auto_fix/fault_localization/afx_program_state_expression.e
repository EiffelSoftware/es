note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXPRESSION

inherit

	SHARED_WORKBENCH
		undefine
			is_equal
		end

	EPA_AST_EXPRESSION
		rename
			make_with_text as old_make_with_text,
			make_with_feature as old_make_with_feature
		end

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	make_with_text, make_with_feature

feature -- Initialization

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_text (a_class, a_feature, a_text, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

	make_with_feature (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_feature (a_class, a_feature, a_expression, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

feature -- Access

	breakpoint_slot: INTEGER
			-- Index of the breakpoint slot, to which the state expression is associated.

	originate_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expressions from which the current expression originates.
			-- Initially an expression originats from itself.
		do
			if originate_expressions_cache = Void then
				create originate_expressions_cache.make_equal (2)
			end
			Result := originate_expressions_cache
		end

	sub_expression_collector: AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR
			-- Shared sub-expression collector.
		once
			create Result
		end

	sub_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Sub-expressions of the current expression.
		do
			if sub_expressions_cache = Void then
				create sub_expressions_cache.make (10)
				sub_expressions_cache.set_equality_tester (Breakpoint_unspecific_equality_tester)

				sub_expression_collector.collect_from_expression (context_class, feature_, ast, True)
				sub_expressions.append (sub_expression_collector.last_collection_in_written_class)

				sub_expressions_cache.do_all (
						agent (a_expr: AFX_PROGRAM_STATE_EXPRESSION; a_bp_index: INTEGER)
							do a_expr.set_breakpoint_slot (a_bp_index) end (?, breakpoint_slot))
			end
			Result := sub_expressions_cache
		end

	sub_expressions_cache: like sub_expressions
			-- Cache for `sub_expressions'.

	set_sub_expressions (a_set: like sub_expressions)
			-- Set `sub_expressions'.
		require
			set_attached: a_set /= Void
		do
			sub_expressions_cache := a_set
		end

	immediate_target_objects: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Immediate target objects of the current expression.
			-- Such immediate target objects could be used to change the value of the current expression.
		do
			if immediate_target_objects_cache = Void then
				target_object_detector.detect_target_objects_for_fixing (Current)
				immediate_target_objects_cache := target_object_detector.immediate_target_objects
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

	target_object_detector: AFX_TARGET_OBJECT_DETECTOR
			-- Shared target object detector.
		once
			create Result
		end

	ultimate_originate_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Set of ultimate originate expressions which have no originate expressions.
		local
			l_queue: DS_LINKED_QUEUE [AFX_PROGRAM_STATE_EXPRESSION]
			l_exp, l_org_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_originates: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			if ultimate_originate_expressions_cache = Void then
				create ultimate_originate_expressions_cache.make (10)
				ultimate_originate_expressions_cache.set_equality_tester (Breakpoint_unspecific_equality_tester)

				create l_queue.make
				from l_queue.put (Current)
				until l_queue.is_empty
				loop
					l_exp := l_queue.item
					l_queue.remove

					if l_exp.originate_expressions.is_empty then
							ultimate_originate_expressions_cache.force (l_exp)
					else
						l_exp.originate_expressions.do_all (agent l_queue.put)
					end
				end
			end

			Result := ultimate_originate_expressions_cache
		end

	ultimate_originate_expressions_cache: like ultimate_originate_expressions
			-- Cache for `ultimate_originate_expressions'.

	originate_expressions_cache: like originate_expressions
			-- Cache for `originate_expressions'.

	related_boolean_expressions: DS_LINKED_LIST [AFX_PROGRAM_STATE_EXPRESSION]
			-- Boolean expressions that are related with the `Current' expression.
			-- The list is ready after a call to `compute_related_boolean_expressions'.
			-- Refer to `compute_related_boolean_expressions' for an explanation about what's in the set.
		do
			if related_boolean_expressions_cache = Void then
				create related_boolean_expressions_cache.make
			end
			Result := related_boolean_expressions_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_bp_spot_specific: BOOLEAN
			-- Is this state expression specific to a breakpoint slot?
			-- Yes, if `breakpoint_slot' is greater than 0;
			-- No, otherwise.
		do
			Result := (breakpoint_slot > 0)
		ensure
			definition: result = (breakpoint_slot > 0)
		end

feature -- Status set

	set_breakpoint_slot (a_slot: INTEGER)
			-- Set the breakpoint slot of `ast'.
		require
			valid_slot: a_slot >= 0
		do
			breakpoint_slot := a_slot
		end

	adopt_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
			-- Adopt `a_exp' as an originate expression.
		require
			exp_attached: a_exp /= Void
		do
			originate_expressions.force (a_exp)
		end

	set_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
			-- Set `originate_expressions' to contain only `a_exp'.
		require
			exp_attached: a_exp /= VOid
			not_current: a_exp /= Current
		do
			originate_expressions.wipe_out
			originate_expressions.force (a_exp)

--			reset_indirectness
		end

	add_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
			-- Add an originate expression.
		require
			exp_attached: a_exp /= Void
			not_current: a_exp /= Current
		do
			originate_expressions.force (a_exp)

--			reset_indirectness
		end

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for `immediate_target_objects'.


--	reset_indirectness
--			-- Reset the indirectness value.
--		do
--			indirectness_cache := -1
--		end

--feature -- Basic operation

--	compute_related_boolean_expressions
--			-- Compute boolean expressions related to the current expression, and make the result available in `related_boolean_expressions'.
--			-- For an expression returning {BOOLEAN}, the only related boolean expression is itself;
--			-- For an expression returning {INTEGER}, the related boolean expressions include tests on its sign, i.e. >, =, or < 0;
--			-- For an expression returning concrete, i.e. non-formal, reference values, the result list contains
--			--		expressions based on `Current' and its queries that return {INTEGER} or {BOOLEAN} values;
--			-- For other cases, there is no related boolean expression.
--		local
--			l_type: TYPE_A
--			l_list, l_tmp_list: like related_boolean_expressions
--			l_exp: EPA_PROGRAM_STATE_EXPRESSION
--			l_class: CLASS_C
--			l_feature_table: FEATURE_TABLE
--			l_next_feature: FEATURE_I
--			l_feature_type: TYPE_A
--			l_feature_name: STRING
--		do
--			if related_boolean_expressions_cache = Void then
--				l_type := Current.type.actual_type
--				l_list := related_boolean_expressions

--				if l_type.is_boolean then
--					-- Boolean expressions are used as they are.
--					l_exp := Current.twin
--					l_exp.set_originate_expression (Current)
--					l_list.force_last (l_exp)
--				elseif l_type.is_integer then
--					-- Sign-testing expressions based on integral expressions.
--					l_tmp_list := queries_for_integer (text)
--					l_list.append_last (l_tmp_list)

--					-- Associate the expressions with the current `breakpoint_slot'.
--					-- These are direct expressions, so no need to set `originate_expression'.
--					l_list.do_all (
--							agent (a_exp: EPA_PROGRAM_STATE_EXPRESSION; a_index: INTEGER)
--								do
--									a_exp.set_breakpoint_slot (a_index)
--								end (?, breakpoint_slot))

--				elseif not l_type.is_formal
--						and then not l_type.is_void
--						and then not l_type.is_basic
--				then
--					-- Collect indirect expressions based on the current expression,
--					--		using argumentless interface queries returning {INTEGER}s or {BOOLEAN}s.
--					l_class := l_type.associated_class
--					l_feature_table := l_class.feature_table
--					from l_feature_table.start
--					until l_feature_table.after
--					loop
--						l_next_feature := l_feature_table.item_for_iteration
--						l_feature_type := l_next_feature.type
--						l_feature_name := l_next_feature.feature_name

--						if is_interface_argumentless_query (l_next_feature) then
--							if l_feature_type.is_integer then
--								l_tmp_list := queries_for_integer (expression_in_parentheses (text) + "." + l_feature_name)
--								l_list.append_last (l_tmp_list)
--							elseif l_feature_type.is_boolean then
--								create l_exp.make_with_text (class_, feature_, expression_in_parentheses (text) + "." + l_feature_name, written_class)
--								l_list.force_last (l_exp)
--							end
--						end

--						l_feature_table.forth
--					end

--					-- Set these expressions as originated from `Current'.
--					l_list.do_all (
--							agent (a_exp, a_originate: EPA_PROGRAM_STATE_EXPRESSION)
--								do
--									a_exp.set_originate_expression (a_originate)
--								end (?, Current))
--				else
--					-- Do nothing.
--				end
--			end
--		end

--feature{NONE} -- Status set

--	set_indirectness (a_val: INTEGER)
--			-- Set `indirectness'.
--		require
--			non_negative_value: a_val >= 0
--		do
--			indirectness := a_val
--		end

--feature{NONE} -- Implementation

--	queries_for_integer (a_exp: STRING;): DS_LINKED_LIST [EPA_PROGRAM_STATE_EXPRESSION]
--			-- Queries based on an integral expression `a_exp'.
--		local
--			l_exp: EPA_PROGRAM_STATE_EXPRESSION
--		do
--			create Result.make_equal
--			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " > 0", written_class)
--			Result.force_last (l_exp)
--			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " = 0", written_class)
--			Result.force_last (l_exp)
--			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " < 0", written_class)
--			Result.force_last (l_exp)
--		end

--	is_interface_argumentless_query (a_feature: attached FEATURE_I): BOOLEAN
--			-- Is 'a_feature' denoting an interface argumentless query?
--		do
--			if a_feature.written_class.class_id /= system.any_class.compiled_representation.class_id
--					and then a_feature.argument_count = 0
--					and then a_feature.is_exported_for (system.any_class.compiled_representation)
--			then
--				Result := True
--			end
--		end

--	expression_in_parentheses (a_exp: STRING): STRING
--			-- Expression with `a_exp' surrounded by parentheses.
--		do
--			Result := "(" + a_exp + ")"
--		end

--feature{NONE} -- Inheritance

--	key_to_hash: DS_LINEAR [INTEGER_32]
--			-- <Precursor>
--		local
--			l_list: DS_ARRAYED_LIST [INTEGER]
--		do
--			create l_list.make (2)
--			l_list.put_last (text.hash_code)
--			l_list.put_last (ast.breakpoint_slot)

--			Result := l_list
--		end

feature{NONE} -- Cache

--	indirectness_cache: INTEGER
--			-- Cache for `indirectness'.

	related_boolean_expressions_cache: like related_boolean_expressions
			-- Cache for `related_boolean_expressions'.

invariant
	originate_expression_attached: originate_expressions /= Void

end
