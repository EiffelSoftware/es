note
	description: "Class to find transitions to satisfy given postconditions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TRANSITION_FINDER

inherit
	EPA_UTILITY

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
		do
			create last_transitions.make
			-- To implement.
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
			l_preconditions.extend ("l.has (v)")
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
			l_preconditions.extend ("not l.has (v)")
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

			l_preconditions.extend ("l.count > old l.count")
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
