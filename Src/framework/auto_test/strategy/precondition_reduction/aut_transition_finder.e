note
	description: "Class to find transitions to satisfy given postconditions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TRANSITION_FINDER

inherit
	EPA_UTILITY

	EPA_TEMPORARY_DIRECTORY_UTILITY

create
	make,
	make_empty

feature{NONE} -- Initialization

	make (a_variables: like variables; a_preconditions: like preconditions; a_postconditions: like postconditions; a_connection: like connection)
			-- Initialize Current.
		do
			make_empty (a_connection)

			across a_variables as l_vars loop variables.force (l_vars.item, l_vars.key) end
			preconditions.append (a_preconditions)
			postconditions.append (a_postconditions)
		end

	make_empty (a_connection: like connection)
			-- Initialize Current with empty `variables', `preconditions' and `postconditions'.
		do
			create variables.make (2)
			variables.compare_objects

			create preconditions.make
			create postconditions.make
			connection := a_connection
		end

feature -- Access

	preconditions: LINKED_LIST [STRING]
			-- List of precondition assertions

	postconditions: LINKED_LIST [STRING]
			-- List of postcondition assertions

	variables: HASH_TABLE [TYPE_A, STRING]
			-- List of variables used in `preconditions' and postconditions'
			-- Keys are variable names, and values are types of associated
			-- variables.

	connection: MYSQL_CLIENT
			-- Semantic database connection

	class_name: detachable STRING
			-- Name of the class whose features are searched to satisfy `postcondition'
			-- When not Void, use this class name to speed up the query execution.

	log_manager: detachable ELOG_LOG_MANAGER
			-- Log manager

feature -- Setting

	set_log_manager (a_manager: like log_manager)
			-- Set `log_manager' with `a_manager'.
		do
			log_manager := a_manager
		ensure
			log_manager_set: log_manager = a_manager
		end

feature -- Access

	last_transitions: LINKED_LIST [TUPLE [feature_name: STRING; operand_map: HASH_TABLE [INTEGER, STRING]]]
			-- Transitions found by last `find'
			-- Result is a list of features which possibly can satisfy `postconditions' when executed
			-- in a state that `preconditions' hold. `feature_name' is the name a feature.
			-- `operand_map' is a hash-table, keys are variable names which appear in `variables' and
			-- values are the 0-based operand indexes where those variables are used.
			-- For example, if the precondition is "True" and the postcondition is "l.has (v)" with
			-- l of type LINKED_LIST [ANY], and v of type ANY, feature named "extend" should appear in the
			-- result, with the following `operand_map': "l" -> 0, "v" -> 1, meaning that l is used as the
			-- 0-th operand (i.e., the target) in the feature, and "v" is used as the 1-th operand (i.e.,
			-- the first argument) in the feature.
			-- There should not exists duplications in the elements of this result.

feature -- Basic operations

	find
			-- Find transitions through `connection' and
			-- make results available in `last_transitions'.
		local
			l_executor: SEMQ_QUERYABLE_QUERY_EXECUTOR
			l_query: SEMQ_QUERYABLE_QUERY
			l_terms: LINKED_LIST [SEMQ_TERM]
			l_equation_term: SEMQ_EQUATION_TERM
			l_meta_term: SEMQ_META_TERM
			l_variable_term: SEMQ_VARIABLE_TERM
			l_transition_tuple: TUPLE [feature_name: STRING; operand_map: HASH_TABLE [INTEGER, STRING]]
			l_operand_map: HASH_TABLE [INTEGER, STRING]
			l_i: INTEGER
			l_stamp: PLAIN_TEXT_FILE
			l_retried: BOOLEAN
			l_stamp_file_name: STRING
		do
			l_stamp_file_name := file_in_temporary_directory ("pr_transition.stamp")
			if not l_retried then
				create l_stamp.make_create_read_write (l_stamp_file_name)
				l_stamp.close
				create last_transitions.make
				if not connection.is_connected then
					connection.reinitialize
				end
				create l_executor.make (connection)
				l_executor.set_log_manager (log_manager)
				create l_terms.make

				-- Feature
				create l_meta_term.make_without_type (ast_from_expression_text ("qry.feature_name"), Void)
				l_terms.extend (l_meta_term)

				-- Variables
				from
					variables.start
				until
					variables.after
				loop
					create l_variable_term.make (ast_from_expression_text (variables.key_for_iteration))
					l_variable_term.set_type (variables.item_for_iteration)
					l_terms.extend (l_variable_term)
					variables.forth
				end

				-- Preconditions
				from
					preconditions.start
				until
					preconditions.after
				loop
					create l_equation_term.make (ast_from_expression_text (preconditions.item), ast_from_expression_text ("True"))
					l_equation_term.set_is_precondition (True)
					l_terms.extend (l_equation_term)
					preconditions.forth
				end

				-- Postconditions
				from
					postconditions.start
				until
					postconditions.after
				loop
					create l_equation_term.make (ast_from_expression_text (postconditions.item), ast_from_expression_text ("True"))
					l_equation_term.set_is_postcondition (True)
					l_terms.extend (l_equation_term)
					postconditions.forth
				end

				-- Class
				if class_name /= Void then
					create l_meta_term.make_without_type (ast_from_expression_text ("qry.class_name"), ast_from_expression_text("%"" + class_name + "%""))
					l_terms.extend (l_meta_term)
				end

				-- Execute
				create l_query.make_with_terms (l_terms)
				l_query.set_group_by_feature_and_positions (True)
				if not connection.is_connected then
					connection.reinitialize
				end
				l_executor.execute (l_query)

				-- Fetch results
				from
					l_executor.last_results.start
				until
					l_executor.last_results.after
				loop
					create l_transition_tuple.make
					create l_operand_map.make (variables.count)
					l_transition_tuple.operand_map := l_operand_map
					-- Feature name is in the first column
					l_transition_tuple.feature_name := l_executor.last_results.item.at (1)
					--io.put_string ("Feature: " + l_transition_tuple.feature_name + "%N")
					-- Position of i-th variable is in the '1 + i*6'-th column
					from
						l_i := 1
						variables.start
					until
						variables.after
					loop
						l_transition_tuple.operand_map.put (l_executor.last_results.item.at (1 + l_i*6).to_integer, variables.key_for_iteration)
						--io.put_string ("%TVariable: " + variables.key_for_iteration + " -> " + l_executor.last_results.item.at (1 + l_i*6) + "%N")
						l_i := l_i + 1
						variables.forth
					end
					last_transitions.extend (l_transition_tuple)
					l_executor.last_results.forth
				end
				create l_stamp.make (l_stamp_file_name)
				if l_stamp.exists then
					l_stamp.delete
				end
			end
		rescue
			create last_transitions.make
			l_retried := True
			create l_stamp.make (l_stamp_file_name)
			if l_stamp.exists then
				l_stamp.delete
			end
			if not connection.is_connected then
				connection.reinitialize
			end
			retry
		end

feature -- Setting

	set_class_name (a_name: like class_name)
			-- Set `class_name' with `a_name'.
		do
			if a_name = Void then
				class_name := Void
			else
				class_name := a_name.twin
			end
		end

feature -- Some test cases

	test_1
			-- Variables: l: LINKED_LIST [ANY]; v: ANY
			-- Preconditions: not l.has (v)
			-- Postconditions: l.has (v)
			-- Note: `extend' should be in the result.
		local
			l_preconditions: LINKED_LIST [STRING]
			l_postconditions: LINKED_LIST [STRING]
			l_operand_map: HASH_TABLE [TYPE_A, STRING]
		do
			create l_operand_map.make (2)
			l_operand_map.compare_objects

			l_operand_map.force (type_a_from_string_in_application_context ("LINKED_LIST [ANY]"), "l")
			l_operand_map.force (type_a_from_string_in_application_context ("ANY"), "v")

			create l_preconditions.make
			create l_postconditions.make

			l_preconditions.extend ("not l.has (v)")
			l_postconditions.extend ("l.has (v)")

			make (l_operand_map, l_preconditions, l_postconditions, connection)
			set_class_name ("LINKED_LIST")
		end

	test_2
			-- Variables: l: LINKED_LIST [ANY]; v: ANY
			-- Preconditions: l.has (v)
			-- Postconditions: not l.has (v)
			-- Note: `wipe_out' should be in the result, and pay attention that `wipe_out' only need one operand, l.
		local
			l_preconditions: LINKED_LIST [STRING]
			l_postconditions: LINKED_LIST [STRING]
			l_operand_map: HASH_TABLE [TYPE_A, STRING]
		do
			create l_operand_map.make (2)
			l_operand_map.compare_objects

			l_operand_map.force (type_a_from_string_in_application_context ("LINKED_LIST [ANY]"), "l")
			l_operand_map.force (type_a_from_string_in_application_context ("ANY"), "v")

			create l_preconditions.make
			create l_postconditions.make

			l_preconditions.extend ("l.has (v)")
			l_postconditions.extend ("not l.has (v)")

			make (l_operand_map, l_preconditions, l_postconditions, connection)
			set_class_name ("LINKED_LIST")
		end

	test_3
			-- Variables: l: LINKED_LIST [ANY]
			-- Preconditions: True
			-- Postconditions: l.count > old l.count
			-- Note: `append' and `extend' should be in the result, and pay attention, that both features
			-- needs 2 operands, but we only have one, so in the result, only one variable has its binding.
		local
			l_preconditions: LINKED_LIST [STRING]
			l_postconditions: LINKED_LIST [STRING]
			l_operand_map: HASH_TABLE [TYPE_A, STRING]
		do
			create l_operand_map.make (1)
			l_operand_map.compare_objects

			l_operand_map.force (type_a_from_string_in_application_context ("LINKED_LIST [ANY]"), "l")

			create l_preconditions.make
			create l_postconditions.make

			l_postconditions.extend ("l.count > old l.count")

			make (l_operand_map, l_preconditions, l_postconditions, connection)
			set_class_name ("LINKED_LIST")
		end

	test_4
			-- Variables: l: LINKED_LIST [ANY]
			-- Preconditions: True
			-- Postconditions: l.count > old l.count
			-- Note: `append' and `extend' should be in the result, and pay attention, that both features
			-- needs 2 operands, but we only have one, so in the result, only one variable has its binding.
		local
			l_preconditions: LINKED_LIST [STRING]
			l_postconditions: LINKED_LIST [STRING]
			l_operand_map: HASH_TABLE [TYPE_A, STRING]
		do


			create l_operand_map.make (1)
			l_operand_map.compare_objects
			l_operand_map.force (type_a_from_string_in_application_context ("TWO_WAY_TREE [ANY]"), "Current")
			l_operand_map.force (type_a_from_string_in_application_context ("ANY"), "v")

			create l_preconditions.make
			create l_postconditions.make
			l_preconditions.extend ("not Current.is_inserted (v)")
			l_postconditions.extend ("Current.is_inserted (v)")

			make (l_operand_map, l_preconditions, l_postconditions, connection)
			set_class_name ("TWO_WAY_TREE")
		end

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
