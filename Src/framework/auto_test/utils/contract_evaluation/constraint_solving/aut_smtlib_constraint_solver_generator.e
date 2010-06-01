note
	description: "SMT-LIB based linear constraint solver generator"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SMTLIB_CONSTRAINT_SOLVER_GENERATOR

inherit
	AUT_PREDICATE_UTILITY

	AST_ITERATOR
		redefine
			process_binary_as,
			process_unary_as,
			process_integer_as,
			process_access_feat_as
		end

	SHARED_SERVER

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	AUT_SHARED_RANDOM

	AUT_SHARED_PREDICATE_CONTEXT

feature -- Access

	constraining_queries: DS_HASH_SET [STRING]
			-- List of constraining query names.

	constrained_operands: DS_HASH_SET [STRING]
			-- Set of name of constrained operands
			-- The names are arguments of the feature (not predicate argument names).

	assertions: DS_LINKED_LIST [TUPLE [assertion: EPA_EXPRESSION; pattern: AUT_PREDICATE_ACCESS_PATTERN]]
			-- Assertions of all the linearly solvable preconditions

	last_smtlib: STRING
			-- SMT-LIB file from the last `generate_smtlib'
			-- Only has effect if `has_linear_constraints' is True.

	used_values: AUT_INTEGER_VALUE_SET
			-- Used values for feature whose linear constraints should be solved

feature -- Status report

	has_linear_constraints: BOOLEAN
			-- Does the last feature processed by `generate_smtlib' has linear constraints?

	use_predefined_values_rate: DOUBLE
			-- Probability in which predefined values for integers are used

	is_used_values_enforced: BOOLEAN
			-- Should the generated solution contain only used values?

feature -- Basic operations

	generate_smtlib (a_feature: AUT_FEATURE_OF_TYPE; a_patterns: like access_patterns) is
			-- Generate smtlib file to solve linear constrains in preconditions in `a_feature'.
			-- `a_patterns' are access patterns of preconditions for that feature.
			-- If there is any linear constraints for `a_feature', set `has_linear_constraints' to True and then
			-- generate the SMT-LIB file into `last_smtlib'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			current_feature := a_feature
			access_patterns := a_patterns

				-- Collect constrained arguments, constraing queries and assertion predicates.
			constrained_operands := constrained_operands_from_access_patterns (a_patterns)
			constraining_queries :=  constraining_queries_from_access_patterns (a_patterns)
			assertions := assertions_from_access_patterns (a_patterns)
			has_linear_constraints := not constrained_operands.is_empty

			if has_linear_constraints then
				create last_smtlib.make (1024)
				generate_header
				generate_extra_functions
				generate_assumptions
				generate_formula
			end
		end

feature -- Setting

	set_used_values (a_used_values: like used_values) is
			-- Set `used_values' with `a_used_values'.
		do
			used_values := a_used_values
		end

	set_is_used_value_enforced (b: BOOLEAN) is
			-- Set `is_used_value_enforced' with `b'.
		do
			is_used_values_enforced := b
		ensure
			is_used_values_enforced_set: is_used_values_enforced = b
		end

	set_use_predefined_values_rate (a_rate: DOUBLE) is
			-- Set `use_predefined_values_rate' with `a_rate'.
		do
			use_predefined_values_rate := a_rate
		end

feature{NONE} -- Implementation

	current_feature: AUT_FEATURE_OF_TYPE
			-- Current feature whose linearly solvable precondition
			-- is to be generated as a SMT-LIB file

	current_match_list: LEAF_AS_LIST
			-- Match list of current processed assertion

	current_written_class: CLASS_C
			-- Written class of currently processed assertion

	current_context_class: CLASS_C
			-- Context class of currently processed assertion

	access_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]
			-- Access patterns of `current_feature'

	current_name: STRING is "current"

	current_access_pattern: AUT_PREDICATE_ACCESS_PATTERN
			-- Access pattern for current processed predicate assertion

feature{NONE} -- Process

	process_binary_as (l_as: BINARY_AS)
		local
			l_operator: STRING
			l_is_ne: BOOLEAN
		do
			last_smtlib.append_character ('(')

				-- Get operator for current binary expression.
			l_operator := normalized_string (l_as.operator (current_match_list).text (current_match_list))
			if l_operator.is_equal ("and then") then
				l_operator := "and"
			elseif l_operator.is_equal ("or else") then
				l_operator := "or"
			end

			if l_operator.is_equal ("/=") then
				l_is_ne := True
				l_operator := "="
				last_smtlib.append ("not (")
			end

			last_smtlib.append (l_operator)
			last_smtlib.append (" ")
			l_as.left.process (Current)
			last_smtlib.append (" ")
			l_as.right.process (Current)
			last_smtlib.append_character (')')
			if l_is_ne then
				last_smtlib.append_character (')')
			end
		end

	process_unary_as (l_as: UNARY_AS)
		local
			l_operator: STRING
		do
			last_smtlib.append_character ('(')
			last_smtlib.append (normalized_string (l_as.operator (current_match_list).text (current_match_list)))
			last_smtlib.append (" ")
			l_as.expr.process (Current)
			last_smtlib.append (")")
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			last_smtlib.append (l_as.integer_32_value.out)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: detachable FEATURE_I
			l_arg_name: detachable STRING
			i: INTEGER
		do
			l_feature := final_feature (l_as.feature_name.name, current_written_class, current_context_class)
			if l_feature /= Void then
				last_smtlib.append (normalized_string (l_feature.feature_name))
			else
					-- Can be an argument.
				i := final_argument_index (l_as.access_name, current_feature.feature_, current_written_class)
				if i > 0 then
					last_smtlib.append (normalized_argument_name (i))
				else
					last_smtlib.append (l_as.access_name)
				end
			end
		end

feature{NONE} -- Generation

	generate_formula is
			-- Generate the formula part of the SMT-LIB.
		local
			l_data: TUPLE [assertion: EPA_EXPRESSION; pattern: AUT_PREDICATE_ACCESS_PATTERN]
		do
			last_smtlib.append (":formula (%N")
			last_smtlib.append ("and%N")
			from
				assertions.start
			until
				assertions.after
			loop
				last_smtlib.append ("%T")
				l_data := assertions.item_for_iteration
				current_access_pattern := l_data.pattern
				current_written_class := current_access_pattern.assertion.written_class
				current_context_class := current_access_pattern.assertion.context_class
				current_match_list := match_list_server.item (current_written_class.class_id)
				current_access_pattern.assertion.ast.process (Current)
				last_smtlib.append ("%N")
				assertions.forth
			end

				-- Generate constraints for constrained operands to use predefined values.
			if not is_used_values_enforced then
				constrained_operands.do_all (agent generate_predefined_value_constraint)
			end

				-- Generate constraints for `used_values'
			generate_constraints_for_used_values

			last_smtlib.append ("%N))")
		end

	generate_predefined_value_constraint (a_operand: STRING) is
			-- Generate constraints for `a_operand' to have predefined values and
			-- store result in `last_smtlib'.
		require
			a_operand_attached: a_operand /= Void
			not_a_operand_is_empty: not a_operand.is_empty
		local
			l_smtlib: like last_smtlib
			l_predefined_values: like predefined_integers
		do
			l_smtlib := last_smtlib
			if is_within_probability (use_predefined_values_rate) then
				l_smtlib.append ("%T(or%N")
				from
					l_predefined_values := predefined_integers
					l_predefined_values.start
				until
					l_predefined_values.after
				loop
					l_smtlib.append ("%T%T(= ")
					l_smtlib.append (a_operand)
					l_smtlib.append_character (' ')
					generate_integer_value (l_predefined_values.item_for_iteration)
					l_smtlib.append (")%N")
					l_predefined_values.forth
				end
				l_smtlib.append ("%T)%N")
			end
		end

	generate_constraints_for_used_values is
			-- Generate constraints for used values.
			-- If `is_used_values_enforced' is True, the generated solution only contains
			-- values that are already in `used_values', otherwise, the generated solution
			-- only contains values that are not in `used_values'.
		local
			l_used_values: like used_values
			l_smtlib: like last_smtlib
			l_operands: DS_ARRAYED_LIST [STRING]
			l_sorter: DS_QUICK_SORTER [STRING]
		do
			l_used_values := used_values
			if not l_used_values.is_empty then
				create l_operands.make (constrained_operands.count)
				constrained_operands.do_all (agent l_operands.force_last)
				create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (a, b: STRING): BOOLEAN do Result := a < b end))
				l_sorter.sort (l_operands)
				l_smtlib := last_smtlib

				if is_used_values_enforced then
					if is_within_probability (0.5) then
						l_smtlib.append ("%T(or%N")
						from
							l_used_values.start
						until
							l_used_values.after
						loop
							l_smtlib.append ("%T%T(")
							generate_used_values (l_used_values.item, l_operands)
							l_smtlib.append (")%N")
							l_used_values.forth
						end
						l_smtlib.append ("%T)%N")
					else
						from
							l_used_values.start
						until
							l_used_values.after
						loop
							l_smtlib.append ("%T(not (")
							generate_used_values (l_used_values.item, l_operands)
							l_smtlib.append ("))%N")
							l_used_values.forth
						end
					end
				end
			end
		end

	generate_used_values (a_values: ARRAY [INTEGER]; a_operands: DS_ARRAYED_LIST [STRING]) is
			-- Generate used values `a_values' in `last_smtlib'.
		require
			operand_number_valid: a_values.count = a_operands.count
		local
			l_used_values: like used_values
			l_smtlib: like last_smtlib
			i: INTEGER
			l_upper: INTEGER
			l_done: BOOLEAN
		do
			l_smtlib := last_smtlib
			if a_values.count = 1 then
				l_smtlib.append ("= " + a_values.item (a_values.lower).out + " " + a_operands.first)
			else
				l_smtlib.append ("and ")
				from
					i := a_values.lower
					l_upper := a_values.upper
					a_operands.start
				until
					i > l_upper
				loop
					l_done := True
					l_smtlib.append ("(")
					l_smtlib.append ("= ")
					generate_integer_value (a_values.item (i))
					l_smtlib.append_character (' ')
					l_smtlib.append (a_operands.item_for_iteration)
					if i = l_upper then
						l_smtlib.append (")")
					else
						l_smtlib.append (") ")
					end
					i := i + 1
					a_operands.forth
				end
			end
		end

	generate_integer_value (a_value: INTEGER) is
			-- Generate `a_value' into `last_smtlib'.
		local
			l_smtlib: like last_smtlib
		do
			l_smtlib := last_smtlib
			if a_value >= 0 then
				l_smtlib.append (a_value.out)
			else
				l_smtlib.append_character ('(')
				l_smtlib.append (a_value.out)
				l_smtlib.append_character (')')
			end
		end

	generate_header is
			-- Generate header SMT-LIB part.
		do
			last_smtlib.append ("(benchmark ")
			last_smtlib.append (current_feature.associated_class.name)
			last_smtlib.append ("_")
			last_smtlib.append (current_feature.feature_.feature_name)
			last_smtlib.append ("%N")
			last_smtlib.append (":status sat%N")
			last_smtlib.append (":logic QF_LIA%N%N")
		end

	generate_extra_functions is
			-- Generate the extra functions part of the SMT-LIB.
		local
			l_names: LINKED_LIST [STRING]
			l_is_windows: BOOLEAN
		do
			l_is_windows := {PLATFORM}.is_windows
			create l_names.make
			constraining_queries.do_all (agent l_names.extend)
			constrained_operands.do_all (agent l_names.extend)

			from
				l_names.start
			until
				l_names.after
			loop
				last_smtlib.append (":extrafuns (")
				last_smtlib.append ("(")
				last_smtlib.append (l_names.item_for_iteration)
				last_smtlib.append (" Int)")
				last_smtlib.append (")")
				last_smtlib.append ("%N")
				l_names.forth
			end
			last_smtlib.append ("%N")
		end

	generate_assumptions is
			-- Generate the assumption part of the SMT-LIB.
		local
			l_names: LINKED_LIST [STRING]
		do
			create l_names.make
			constraining_queries.do_all (agent l_names.extend)
			from
				l_names.start
			until
				l_names.after
			loop
				last_smtlib.append (":assumption (= ")
				last_smtlib.append (l_names.item_for_iteration)
				last_smtlib.append (" ")
				last_smtlib.append ("$" + l_names.item_for_iteration + "$")
				last_smtlib.append (")%N")
				l_names.forth
			end
			last_smtlib.append ("%N")
		end

	final_argument_name (a_name: STRING; a_feature: FEATURE_I; a_written_class: CLASS_C): detachable STRING is
			-- Final name of the argument `a_name' in `a_feature'
		local
			i: INTEGER
		do
			i := final_argument_index (a_name, a_feature, a_written_class)
			if i > 0 then
				Result := a_feature.arguments.item_name (i)
			end
		end

	normalized_string (a_string: STRING): STRING is
			-- Normalized version of `a_string'.
			-- Normalization means remoing all leading and trailing
			-- spaces, and turning all letters in non-capital ones.
		require
			a_string_attached: a_string /= Void
		do
			Result := a_string.as_lower
			Result.left_adjust
			Result.right_adjust
		ensure
			result_attached: Result /= Void
		end

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
