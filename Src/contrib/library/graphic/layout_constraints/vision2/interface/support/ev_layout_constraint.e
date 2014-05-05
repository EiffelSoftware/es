note
	description: "Summary description for {EV_LAYOUT_CONSTRAINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LAYOUT_CONSTRAINT

inherit
	LINEAR_PROGRAM_CONSTANTS

create
	make, make_single, make_with_expression

feature {NONE} -- Initialization

	make (a_program: LINEAR_PROGRAM; multiplier: DOUBLE; first_attribute: EV_LAYOUT_ATTRIBUTE; a_constant: DOUBLE; a_sign: INTEGER; second_attribute: EV_LAYOUT_ATTRIBUTE)
		local
			l_terms: LINKED_LIST [TERM]
			l_term: TERM
		do
			create constraint.make_with_program (a_program)

				-- The constraint is: multiplier*first_attribute + constant = second_attribute
				-- where an attribute is a list of variables containing at least one element.

				-- Rearrange the equation as multiplier*first_attribute - second_attribute = -constant
			create l_terms.make
			across first_attribute.terms as term loop
				create l_term.make (term.item.variable, multiplier * term.item.coefficient)
				l_terms.extend (l_term)
			end
			across second_attribute.terms as term loop
				create l_term.make (term.item.variable, -term.item.coefficient)
				l_terms.extend (l_term)
			end

			constraint.left_hand_side := l_terms
			constraint.sign := a_sign
			constraint.right_hand_side := -a_constant
		end

	make_single (a_program: LINEAR_PROGRAM; a_attribute: EV_LAYOUT_ATTRIBUTE; a_sign: INTEGER; a_constant: DOUBLE)
		do
			create constraint.make_with_program (a_program)

			constraint.left_hand_side := a_attribute.terms
			constraint.sign := a_sign
			constraint.right_hand_side := a_constant
		end

	make_with_expression (a_program: LINEAR_PROGRAM; a_expression: EV_LAYOUT_EXPRESSION)
		do
			create constraint.make_with_program (a_program)

			constraint.left_hand_side := a_expression.terms
			constraint.sign := a_expression.sign
			constraint.right_hand_side := a_expression.right_hand_side
		end

feature -- Access

	constant: DOUBLE assign set_constant
		do
			Result := constraint.right_hand_side
		end

feature -- Element Change

	set_constant (a_constant: like constant)
		do
			constraint.right_hand_side := a_constant
		end

feature {EV_AUTOLAYOUT_I} -- Implementation

	constraint: CONSTRAINT

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
