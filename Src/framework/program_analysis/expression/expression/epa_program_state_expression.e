note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_PROGRAM_STATE_EXPRESSION

inherit

	SHARED_WORKBENCH
		redefine
			is_equal
		end

	EPA_AST_EXPRESSION
		rename
			make_with_text as old_make_with_text,
			make_with_feature as old_make_with_feature
		redefine
			is_equal
		end

create
	make_with_text, make_with_feature

feature -- Initialization

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_text (a_class, a_feature, a_text, a_written_class)
			set_breakpoint_slot (a_bp_index)
--			add_originate_expression (Current)
		end

	make_with_feature (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_feature (a_class, a_feature, a_expression, a_written_class)
			set_breakpoint_slot (a_bp_index)
--			add_originate_expression (Current)
		end

feature -- Access

	breakpoint_slot: INTEGER
			-- Index of the breakpoint slot, to which the state expression is associated.
--		require
--			ast_attached: ast /= Void
--		do
--			Result := ast.breakpoint_slot
--		end

	indirectness: INTEGER
			-- Number of levels current expression is away from the source code.
			-- If an expression originates from itself, the indirectness would be 0;
			-- Otherwise, the indirectness would be that of its originate_expression plus 1.
		require
			originate_expressions_attached: originate_expressions /= VOid
		local
			l_originates: like originate_expressions
			l_org: like Current
		do
			if indirectness_cache = -1 then
				indirectness_cache := 0

				l_originates := originate_expressions
--				check originates_not_empty: not l_originates.is_empty end
				if l_originates.count > 0 then
					-- Return the largest indirectness of originate expression, plus 1.
					from l_originates.start
					until l_originates.after
					loop
						l_org := l_originates.item_for_iteration

						if l_org.indirectness + 1 > indirectness_cache then
							indirectness_cache := l_org.indirectness + 1
						end

						l_originates.forth
					end
				else
					-- Originates from itself, indirectness_cache =0
				end
			end

			Result := indirectness_cache
		end

	originate_expressions: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Expressions from which the current expression originates.
			-- Initially an expression originats from itself.
		do
			if originate_expressions_cache = VOid then
				create originate_expressions_cache.make_equal (2)
			end
			Result := originate_expressions_cache
		end

	originate_expressions_cache: like originate_expressions
			-- Cache for `originate_expressions'.

	related_boolean_expressions: DS_LINKED_LIST [EPA_PROGRAM_STATE_EXPRESSION]
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

	is_equal (other: EPA_PROGRAM_STATE_EXPRESSION): BOOLEAN
			-- <Precursor>
		do
			Result := text ~ other.text
						and then originate_expressions ~ other.originate_expressions
--						and then (originate_expression /= Current implies originate_expressions ~ other.originate_expressions)
--						and then (originate_expression = Current implies other.originate_expressions
						and then breakpoint_slot = other.breakpoint_slot
		end

feature -- Status set

	set_breakpoint_slot (a_slot: INTEGER)
			-- Set the breakpoint slot of `ast'.
		require
--			ast_attached: ast /= Void
			valid_slot: a_slot >= 0
		do
--			ast.set_breakpoint_slot (a_slot)
			breakpoint_slot := a_slot
		end

	set_originate_expression (a_exp: like Current)
			-- Set `originate_expressions' to contain only `a_exp'.
		require
			exp_attached: a_exp /= VOid
			not_current: a_exp /= Current
		do
			originate_expressions.wipe_out
			originate_expressions.force (a_exp)

			reset_indirectness
		end

	add_originate_expression (a_exp: like Current)
			-- Add an originate expression.
		require
			exp_attached: a_exp /= Void
			not_current: a_exp /= Current
		do
			originate_expressions.force (a_exp)

			reset_indirectness
		end

	reset_indirectness
			-- Reset the indirectness value.
		do
			indirectness_cache := -1
		end

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

	indirectness_cache: INTEGER
			-- Cache for `indirectness'.

	related_boolean_expressions_cache: like related_boolean_expressions
			-- Cache for `related_boolean_expressions'.

invariant
	originate_expression_attached: originate_expressions /= Void

end
