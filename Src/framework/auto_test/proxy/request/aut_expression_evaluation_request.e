note
	description: "Request to evaluate expressions before/after test case execution"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_EXPRESSION_EVALUATION_REQUEST

inherit
	AUT_OBJECT_STATE_REQUEST

create
	make

feature{NONE} -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_expressions: LINKED_LIST [EPA_EXPRESSION]; a_operand_map: like operand_map)
			-- Initialize Current.
		do
			context_class := a_class
			feature_ := a_feature
			expressions := a_expressions
			operand_map := a_operand_map
		end

feature -- Access

	expressions: LINKED_LIST [EPA_EXPRESSION]
			-- Expressions to evaluate
			-- Note: This request only generate program to evaluate
			-- variables and single-rooted expressions of those variables
			-- inside the given expressions, to get the values of the original
			-- expressions, use an external expression evaluator.
			-- The expressions are in normal format, such as "Current.has (v)".
			-- They do not mention objects in the object pool, the mapping from operands
			-- such as "Current" to the real object in the object pool is given by `operand_map'.

	context_class: CLASS_C
			-- Context class in which `feature_' is viewed

	feature_: FEATURE_I
			-- Feature that `expressions' are evaluated in

	operand_map: HASH_TABLE [INTEGER, INTEGER]
			-- Map from opreand index to object index in the object pool.
			-- Key is 0-based operand index.
			-- Value is object id (used in the object pool) for that operand.

	byte_codes: TUPLE [pre_state_byte_code: STRING; post_state_byte_code: detachable STRING]
			-- Strings representing the byte-code needed to retrieve object states
			-- `pre_state_byte_code' is to be executed before the test case execution.
			-- `post_state_byte_code' is to be executed after the test case execution.
		local
			l_gen: AUT_OBJECT_STATE_RETRIEVAL_FEATURE_GENERATOR
			l_text: STRING
		do
			create l_gen
			l_gen.generate_for_expressions (expressions, context_class, feature_, False, False, context_class.constraint_actual_type)
			l_text := text_with_actual_objects (l_gen.feature_text, operand_map)
			Result := [feature_byte_code_with_text (interpreter_root_class, feature_for_byte_code_injection, once "feature " + l_text, True).byte_code, Void]
		end

note
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
