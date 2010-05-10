note
	description: "Class to collect expressions that can be used to abstract a set of objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_EXPRESSION_FINDER

inherit
	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do

		end

feature -- Access

	expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions found by last `search'

feature -- Basic operations

	search (a_context_class: CLASS_C; a_feature: FEATURE_I; a_prestate: BOOLEAN; a_is_creation: BOOLEAN; a_root_class: CLASS_C)
			-- Search for expressions, make results avaiable in `expressions'.
			-- The expressions are related to `a_feature' viewed in `a_context_class'.
			-- `a_prestate' indicates whether the found expressions are to be evaluated before
			-- the execution of the test case. This is important because expressions such as "Result"
			-- does not make sense to be evaluated before the test case execution.
			-- `a_is_creation' indicates if `a_feature' is used as a creation procedure.
			-- `a_root_class' should be the root class of the interpreter.
		local
			l_finder: EPA_TYPE_BASED_FUNCTION_FINDER
			l_context: EPA_CONTEXT
			l_operand_map: DS_HASH_TABLE [STRING, INTEGER]
			l_data: like variables_from_feature_signature
		do
			create l_finder.make (Void)
			l_finder.set_class_and_feature (a_context_class, a_feature)
			l_finder.set_is_creation (a_is_creation)
			l_finder.set_is_for_pre_execution (a_prestate)

			l_data := variables_from_feature_signature (a_context_class, a_feature, a_root_class)
			create l_context.make (l_data.variable_types)
			l_finder.set_context (l_context, l_data.operand_map)
		end

feature{NONE} -- Implementation

	variables_from_feature_signature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_root_class: CLASS_C): TUPLE [variable_types: HASH_TABLE [TYPE_A, STRING]; operand_map: DS_HASH_TABLE [STRING, INTEGER]]
			-- Variables extracted from the signature of `a_feature' viewed in `a_context_class'.
			-- `a_root_class' is the root class of the interpreter.
			-- The result is a table. Key is variable name, value is the type of that variable.
		local
			l_operands: like operand_types_with_feature
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_operand_map: DS_HASH_TABLE [STRING, INTEGER]
			l_index: INTEGER
			l_var_name: STRING
		do
			l_operands := resolved_operand_types_with_feature (a_feature, a_context_class, a_root_class)
			create l_variables.make (l_operands.count)
			l_variables.compare_objects
			create l_operand_map.make (l_operands.count)
			from
				l_operands.start
			until
				l_operands.after
			loop
				l_index := l_operands.key_for_iteration
				l_var_name := variable_name (l_index)
				l_variables.put (l_operands.item_for_iteration, l_var_name)
				l_operand_map.force_last (l_var_name, l_index)
				l_operands.forth
			end

		end

	variable_name (a_index: INTEGER): STRING
			-- Variable name for object with index `a_index'.
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_index.out)
		end

note
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
