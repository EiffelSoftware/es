note
	description: "Class that represents a state invariant derived from generated test cases"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_INVARIANT

inherit
	EPA_UTILITY

	HASHABLE

	EPA_STRING_UTILITY

	DEBUG_OUTPUT

create
	make,
	make_as_one_of

feature{NONE} -- Initialization

	make (a_expression: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Initialize Current.
		local
		do
			expression := a_expression
			context_class := a_context_class
			feature_ := a_feature
			create id.make (64)
			id.append (a_context_class.name_in_upper)
			id.append_character ('.')
			id.append (a_feature.feature_name)
			id.append_character ('.')
			id.append (a_expression.text)
			hash_code := id.hash_code
			feature_id := class_name_dot_feature_name (a_context_class, feature_)
			create one_of_components.make
		end

	make_as_one_of (a_expression: EPA_EXPRESSION; a_values: LINKED_LIST [EPA_EXPRESSION]; a_context_class: CLASS_C; a_feature: FEATURE_I; a_pre_context: detachable EPA_EXPRESSION; a_post_context: detachable EPA_EXPRESSION)
			-- Initialize Current as an one of invariant.
		local
			l_expr: EPA_AST_EXPRESSION
			l_str: STRING
			i: INTEGER
		do
			original_expression := a_expression
			create l_str.make (128)
			set_is_one_of_invariant (True)
			i := 1
			across a_values as l_values loop
				l_str.append (once "not ")
				l_str.append_character ('(')
				l_str.append (a_expression.text)
				l_str.append (once " = ")
				l_str.append (l_values.item.text)
				l_str.append_character (')')
				if i < a_values.count then
					l_str.append (once " and ")
				end
				i := i + 1
			end
			if a_pre_context /= Void then
				l_str := l_str + " and (" + a_pre_context.text + ")"
			end
			create l_expr.make_with_text (a_context_class, a_feature, l_str, a_context_class)
			make (l_expr, a_context_class, a_feature)
			one_of_components.append (a_values)
		end

feature -- Access

	feature_: FEATURE_I
			-- The feature whose state invariant Current class stands for

	context_class: CLASS_C
			-- Context class from with `feature_' is viewed

	expression: EPA_EXPRESSION
			-- Expression representing the state invariant

	hash_code: INTEGER
			-- Hash code value

	id: STRING
			-- Identifier of current invariant

	feature_id: STRING
			-- Indentifer of `context_class'.`feature_'
			-- In form of "CLASS_NAME.feature_name'

	text: STRING
			-- String representation of `expression'
		do
			Result := expression.text
		end

	one_of_components: LINKED_LIST [EPA_EXPRESSION]
			-- List of components in a "one of" invariant
			-- Empty when Current invariant is not a "one of" invariant		

	original_expression: EPA_EXPRESSION
			-- Original expression in "one of" invariant

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := expression.text
		end

	pre_state_context_expression: EPA_EXPRESSION
			-- The expression (if attached) which must be evaluated to True in pre-state

	post_state_context_expression: EPA_EXPRESSION
			-- The expression (if attached) which must be evaluated to True in post-state

	invariant_id: STRING
			-- Id for current invariant
		do
			create Result.make (256)
			Result.append (context_class.name_in_upper)
			Result.append_character ('.')
			Result.append (feature_.feature_name.as_lower)
			Result.append_character ('.')
			if is_implication then
				Result.append ("old (" + pre_state_context_expression.text + ") implies " + post_state_context_expression.text)
			else
				Result.append (expression.text)
			end
		end

	structure: STRING
			-- Structure of the invariant to be violated
			-- REC: Reference equality comparision
			-- OEC: Object equality comparision
			-- VOD: Void comparison
			-- INT: Integer comparision
			-- ABQ: Argumentless boolean query
			-- BLQ: Boolean query with argument
			-- CPX: Complex structure

	structure_REC: STRING = "REC"
	structure_OEC: STRING = "OEC"
	structure_VOD: STRING = "VOD"
	structure_INT: STRING = "INT"
	structure_ABQ: STRING = "ABQ"
	structure_BQY: STRING = "BQY"
	structure_CPX: STRING = "CPX"

feature -- Status report

	is_one_of_invariant: BOOLEAN
			-- Is Current invariant a "one of" invariant?

	is_implication: BOOLEAN
			-- Is Current invariant an implication?

feature -- Setting

	set_is_one_of_invariant (b: BOOLEAN)
			-- Set `is_one_of_invariant' with `b'.
		do
			is_one_of_invariant := b
		ensure
			is_one_of_invariant_set: is_one_of_invariant = b
		end

	set_is_implication (b: BOOLEAN)
			-- Set `is_implication' with `b'.
		do
			is_implication := b
		ensure
			is_implication_set: is_implication = b
		end

	set_pre_state_context_expression (a_expression: like pre_state_context_expression)
			-- Set `pre_state_context_expression' with `a_expression'.
		do
			pre_state_context_expression := a_expression
		ensure
			pre_state_context_expression_set: pre_state_context_expression = a_expression
		end

	set_post_state_context_expression (a_expression: like post_state_context_expression)
			-- Set `post_state_context_expression' with `a_expression'.
		do
			post_state_context_expression := a_expression
		ensure
			post_state_context_expression_set: post_state_context_expression = a_expression
		end

	set_structure (a_structure: like structure)
			-- Set `structure' with `a_structure'.
		do
			structure := a_structure.twin
		ensure
			structure_set: structure ~ a_structure
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
