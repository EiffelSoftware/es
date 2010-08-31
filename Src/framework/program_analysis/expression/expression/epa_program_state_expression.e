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
		undefine
			hash_code
		redefine
			is_equal
		end

	EPA_HASH_CALCULATOR
		undefine
			is_equal
		end

create
	make_with_text, make_with_feature

feature -- Access

	breakpoint_slot: INTEGER
			-- Index of the breakpoint slot, to which the state expression is associated.
		require
			ast_attached: ast /= Void
		do
			Result := ast.breakpoint_slot
		end

	indirectness: INTEGER assign set_indirectness
			-- Number of levels current expression is away from the source code.
			-- The default value 0 indicates the expression appears directly in the source code.
			-- Expressions built on those direct ones would have indirectness increased by 1.
			-- And so on...

	originate_expression: EPA_PROGRAM_STATE_EXPRESSION assign set_originate_expression
			-- Expression from which the current expression originates.
			-- (indirectness = 0) implies (originate_expression = Void)

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
			Result := Precursor {EPA_AST_EXPRESSION} (other) and then
						indirectness = other.indirectness and then
						originate_expression = other.originate_expression and then
						(ast = other.ast) and then
						((ast /= Void and then other.ast /= Void) implies breakpoint_slot = other.breakpoint_slot)
		end

feature -- Status set

	set_breakpoint_slot (a_slot: INTEGER)
			-- Set the breakpoint slot of `ast'.
		require
			ast_attached: ast /= Void
			valid_slot: a_slot >= 0
		do
			ast.set_breakpoint_slot (a_slot)
		end

	set_originate_expression (a_exp: like Current)
			-- Set `originate_expression'.
		do
			originate_expression := a_exp
			if a_exp = Void then
				set_indirectness (0)
			else
				set_indirectness (a_exp.indirectness + 1)
				set_breakpoint_slot (a_exp.breakpoint_slot)
			end
		end

feature -- Basic operation

	compute_related_boolean_expressions
			-- Compute boolean expressions related to the current expression, and make the result available in `related_boolean_expressions'.
			-- For an expression returning {BOOLEAN}, the only related boolean expression is itself;
			-- For an expression returning {INTEGER}, the related boolean expressions include tests on its sign, i.e. >, =, or < 0;
			-- For an expression returning concrete, i.e. non-formal, reference values, the result list contains
			--		expressions based on `Current' and its queries that return {INTEGER} or {BOOLEAN} values;
			-- For other cases, there is no related boolean expression.
		local
			l_type: TYPE_A
			l_list, l_tmp_list: like related_boolean_expressions
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_class: CLASS_C
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING
		do
			if related_boolean_expressions_cache = Void then
				l_type := Current.type.actual_type
				l_list := related_boolean_expressions

				if l_type.is_boolean then
					-- Boolean expressions are used as they are.
					l_exp := Current.twin
					l_list.force_last (l_exp)
				elseif l_type.is_integer then
					-- Sign-testing expressions based on integral expressions.
					l_tmp_list := queries_for_integer (text)
					l_list.append_last (l_tmp_list)

					-- Associate the expressions with the current `breakpoint_slot'.
					-- These are direct expressions, so no need to set `originate_expression'.
					l_list.do_all (
							agent (a_exp: EPA_PROGRAM_STATE_EXPRESSION; a_index: INTEGER)
								do
									a_exp.set_breakpoint_slot (a_index)
								end (?, breakpoint_slot))

				elseif not l_type.is_formal
						and then not l_type.is_void
						and then not l_type.is_basic
				then
					-- Collect indirect expressions based on the current expression,
					--		using argumentless interface queries returning {INTEGER}s or {BOOLEAN}s.
					l_class := l_type.associated_class
					l_feature_table := l_class.feature_table
					from l_feature_table.start
					until l_feature_table.after
					loop
						l_next_feature := l_feature_table.item_for_iteration
						l_feature_type := l_next_feature.type
						l_feature_name := l_next_feature.feature_name

						if is_interface_argumentless_query (l_next_feature) then
							if l_feature_type.is_integer then
								l_tmp_list := queries_for_integer (expression_in_parentheses (text) + "." + l_feature_name)
								l_list.append_last (l_tmp_list)
							elseif l_feature_type.is_boolean then
								create l_exp.make_with_text (class_, feature_, expression_in_parentheses (text) + "." + l_feature_name, written_class)
								l_list.force_last (l_exp)
							end
						end

						l_feature_table.forth
					end

					-- Set these expressions as originated from `Current'.
					l_list.do_all (
							agent (a_exp, a_originate: EPA_PROGRAM_STATE_EXPRESSION)
								do
									a_exp.set_originate_expression (a_originate)
								end (?, Current))
				else
					-- Do nothing.
				end
			end
		end

feature{NONE} -- Status set

	set_indirectness (a_val: INTEGER)
			-- Set `indirectness'.
		require
			non_negative_value: a_val >= 0
		do
			indirectness := a_val
		end

feature{NONE} -- Implementation

	queries_for_integer (a_exp: STRING;): DS_LINKED_LIST [EPA_PROGRAM_STATE_EXPRESSION]
			-- Queries based on an integral expression `a_exp'.
		local
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
		do
			create Result.make_equal
			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " > 0", written_class)
			Result.force_last (l_exp)
			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " = 0", written_class)
			Result.force_last (l_exp)
			create l_exp.make_with_text (class_, feature_, expression_in_parentheses (a_exp) + " < 0", written_class)
			Result.force_last (l_exp)
		end

	is_interface_argumentless_query (a_feature: attached FEATURE_I): BOOLEAN
			-- Is 'a_feature' denoting an interface argumentless query?
		do
			if a_feature.written_class.class_id /= system.any_class.compiled_representation.class_id
					and then a_feature.argument_count = 0
					and then a_feature.is_exported_for (system.any_class.compiled_representation)
			then
				Result := True
			end
		end

	expression_in_parentheses (a_exp: STRING): STRING
			-- Expression with `a_exp' surrounded by parentheses.
		do
			Result := "(" + a_exp + ")"
		end

feature{NONE} -- Inheritance

	key_to_hash: DS_LINEAR [INTEGER_32]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (2)
			l_list.put_last (text.hash_code)
			l_list.put_last (ast.breakpoint_slot)

			Result := l_list
		end

feature{NONE} -- Cache

	related_boolean_expressions_cache: like related_boolean_expressions
			-- Cache for `related_boolean_expressions'.


end
