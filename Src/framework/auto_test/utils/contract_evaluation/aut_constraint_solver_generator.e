note
	description: "Summary description for {AUT_CONSTRAINT_SOLVER_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CONSTRAINT_SOLVER_GENERATOR

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

	AUT_OBJECT_STATE_REQUEST_UTILITY

feature -- Access

	constraining_queries: DS_HASH_SET [STRING]
			-- List of constraining query names.

	constrained_arguments: DS_HASH_SET [STRING]
			-- Set of name of constrained arguments
			-- The names are arguments of the feature (not predicate argument names).

	assertions: LINKED_LIST [AUT_EXPRESSION]
			-- Assertions of all the linearly solvable preconditions

	last_smtlib: STRING
			-- SMT-LIB file from the last `generate_smtlib'
			-- Only has effect if `has_linear_constraints' is True.

feature -- Status report

	has_linear_constraints: BOOLEAN
			-- Does the last feature processed by `generate_smtlib' has linear constraints?

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
			create constraining_queries.make (5)
			create constrained_arguments.make (5)
			create assertions.make
			constraining_queries.set_equality_tester (string_equality_tester)
			constrained_arguments.set_equality_tester (string_equality_tester)
			has_linear_constraints := False

				-- Collect constrained arguments and constraing queries.
			from
				a_patterns.start
			until
				a_patterns.after
			loop
				if attached {AUT_LINEAR_SOLVABLE_PREDICATE} a_patterns.item_for_iteration.predicate as l_linear_pred then
					has_linear_constraints := True
					l_cursor := a_patterns.item_for_iteration.access_pattern.new_cursor
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						constrained_arguments.force_last (normalized_argument_name (l_cursor.key))
						l_cursor.forth
					end
					l_linear_pred.constraining_queries.do_all (agent constraining_queries.force_last)
					assertions.extend (l_linear_pred.expression)
				end
				a_patterns.forth
			end

			if has_linear_constraints then
				create last_smtlib.make (1024)
				generate_header
				generate_extra_functions
				generate_assumptions
				generate_formula
			end
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
--			last_smtlib.append (" (")
			l_as.left.process (Current)
--			last_smtlib.append (") (")
			last_smtlib.append (" ")
			l_as.right.process (Current)
--			last_smtlib.append_character (')')
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
		do
--			last_smtlib.append ("#Formula%N%N")
			last_smtlib.append (":formula (%N")
			last_smtlib.append ("and%N")
			from
				assertions.start
			until
				assertions.after
			loop
				last_smtlib.append ("%T")
				current_written_class := assertions.item_for_iteration.written_class
				current_context_class := assertions.item_for_iteration.context_class
				current_match_list := match_list_server.item (current_written_class.class_id)
				assertions.item_for_iteration.ast.process (Current)
				last_smtlib.append ("%N")
				assertions.forth
			end
			last_smtlib.append ("%N))")
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
			constrained_arguments.do_all (agent l_names.extend)

--			last_smtlib.append ("#Extra functions%N")
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

	final_argument_index (a_name: STRING; a_feature: FEATURE_I; a_written_class: CLASS_C): INTEGER is
			-- 1-based argument index of an argument `a_name' in feature `a_feature'.
			-- Resolve `a_name' in case that the argument name changes in inherited features.
			-- If there is no argument called `a_name' in `a_feature', return 0.
		local
			l_round: INTEGER
			l_arg_count: INTEGER
			l_feature: detachable FEATURE_I
			i: INTEGER
		do
			from
				l_round := 1
				l_feature := a_feature
				l_arg_count := l_feature.argument_count
			until
				l_round <= 2 or else Result > 0
			loop
				from
					i := 1
				until
					Result > 0 or else i > l_arg_count
				loop
					if l_feature.arguments.item_name (i).is_case_insensitive_equal (a_name) then
						Result := i
					else
						i := i + 1
					end
				end

				if l_round = 1 then
					l_feature := a_written_class.feature_of_rout_id_set (a_feature.rout_id_set)
					if l_feature = Void then
						l_round := l_round + 1
					end
				end
				l_round := l_round + 1
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
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
