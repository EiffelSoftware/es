note
	description: "Text items used in textual BON specifications."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_TEXT_ITEMS

feature -- Access: BON keywords
	bti_and_keyword: STRING = "and"
			-- Textual BON keyword for logical AND.

	bti_class_chart_keyword: STRING = "class_chart"
			-- Informal textual BON keyword for declaring class charts.

	bti_command_keyword: STRING = "command"
			-- Informal textual BON keyword for the command clause.

	bti_constraint_keyword: STRING = "constraint"
			-- Informal textual BON keyword for the constraint clause.

	bti_creates_keyword: STRING = "creates"
			-- Textual BON keyword for specifying created classes in a creation clause.

	bti_creator_keyword: STRING = "creator"
			-- Textual BON keyword for specifying the creator of a creation clause.

	bti_delta_keyword: STRING = "delta"
			-- Textual BON keyword for a delta expression in an assertion.

	bti_end_keyword: STRING = "end"
			-- Textual BON keyword for ending a chart or diagram.

	bti_ensure_keyword: STRING = "ensure"
			-- Formal textual BON keyword for postconditions.

	bti_event_keyword: STRING = "event"
			-- Textual BON keyword for specifying an event.

	bti_explanation_keyword: STRING = "explanation"
			-- Informal textual BON keyword for the explanation clause.

	bti_indexing_keyword: STRING = "indexing"
			-- Informal textual BON keyword for the indexing clause.

	bti_inherit_keyword: STRING = "inherit"
			-- Textual BON keyword for the inherit clause.

	bti_invariant_keyword: STRING = "invariant"
			-- Formal textual BON keyword for a class invariant.

	bti_involves_keyword: STRING = "involves"
			-- Textual BON keyword for specifying involved classes.

	bti_member_of_keyword: STRING = "member_of"
			-- Textual BON keyword for expressing set membership.

	bti_not_keyword: STRING = "not"
			-- Textual BON keyword for negating an expression.

	bti_old_keyword: STRING = "old"
			-- Textual BON keyword for an old expresson in an assertion.

	bti_or_keyword: STRING = "or"
			-- Textual BON keyword for logical OR.

	bti_part_keyword: STRING = "part"
			-- Informal textual BON keyword for the part clause.

	bti_query_keyword: STRING = "query"
			-- Informal textual BON keyword for the query clause.

	bti_require_keyword: STRING = "require"
			-- Formal textual BON keyword for a precondition.

	bti_xor_keyword: STRING = "xor"
			-- Textual BON keyword for exclusive-OR.


feature -- Access: BON operators
	bti_colon_operator: STRING = ":"
			-- Colon operator for textual BON.

	bti_division_operator: STRING = "/"
			-- Division operator for textual BON.

	bti_equals_operator: STRING = "="
			-- Equals operator for textual BON.

	bti_greater_than_operator: STRING = ">"
			-- Greater-than operator for textual BON.

	bti_greater_than_equals_operator: STRING = ">="
			-- Greater-than-equals for textual BON.

	bti_implication_operator: STRING = "->"
			-- Implication operator for textual BON.

	bti_integer_division_operator: STRING = "//"
			--Integer division operator for textual BON.

	bti_less_than_operator: STRING = "<"
			-- Less-than operator for textual BON.

	bti_less_than_equals_operator: STRING = "<="
			-- Less-than-equales for textual BON.

	bti_logical_equivalence_operator: STRING = "<->"
			-- Logical equivalence operator for textual BON.

	bti_minus_operator: STRING = "-"
			-- Minus operator for textual BON.

	bti_modulo_operator: STRING = "\\"
			-- Modulo operator for textual BON.

	bti_multiplication_operator: STRING = "*"
			-- Multiplication operator for textual BON.

	bti_not_equals_operator: STRING = "/="
			-- Not equals operator for textual BON.

	bti_plus_operator: STRING = "+"
			-- Plus operator for textual BON.

	bti_power_operator: STRING = "^"
			-- Power operator for textual BON.
			-- Is also used for renaming.

feature -- Access: Special class names
	bti_none_class_name: STRING = "NONE"
			-- Class name for the BON class NONE (the class at the bottom of the inheritance hierarchy).

feature -- Access: Characters
	bti_underscore: STRING = "_"
			-- The character "_"

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
