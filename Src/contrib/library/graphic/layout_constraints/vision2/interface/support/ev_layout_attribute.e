note
	description: "Summary description for {EV_LAYOUT_ATTRIBUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LAYOUT_ATTRIBUTE

create
	make

convert
	to_expression: {EV_LAYOUT_EXPRESSION}

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create terms.make
		end

feature {EV_LAYOUT_CONSTRAINT, EV_LAYOUTABLE, EV_LAYOUT_ATTRIBUTE} -- Access

	terms: LINKED_LIST [TERM] assign set_terms
			-- The left hand side of the linear equation.


feature {EV_AUTOLAYOUT_I, EV_LAYOUTABLE} -- Element Change

	set_terms (a_terms: like terms)
		do
			terms.wipe_out
			terms.append (a_terms)
		end

feature -- Element Change

	plus alias "+" (a_constant: REAL_64): EV_LAYOUT_EXPRESSION
		do
			create Result.make
			Result.terms.append (terms)
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal
			Result.right_hand_side := -a_constant
		end

	minus alias "-" (a_constant: REAL_64): EV_LAYOUT_EXPRESSION
		do
			create Result.make
			Result.terms.append (terms)
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal
			Result.right_hand_side := a_constant
		end

	multiply alias "*" (multiplier: REAL_64): EV_LAYOUT_EXPRESSION
		local
			l_term: TERM
		do
			create Result.make
			across terms as term loop
				create l_term.make (term.item.variable, term.item.coefficient * multiplier)
				Result.terms.extend (l_term)
			end
		end

	greater_equal alias ">=" (a_right_hand_side: REAL_64): EV_LAYOUT_EXPRESSION
		do
			Result := to_expression
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_greater_than_or_equal
			Result.right_hand_side := a_right_hand_side
		end

	less_equal alias "<=" (a_right_hand_side: REAL_64): EV_LAYOUT_EXPRESSION
		do
			Result := to_expression
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_less_than_or_equal
			Result.right_hand_side := a_right_hand_side
		end

	equal_to (a_other: EV_LAYOUT_EXPRESSION): EV_LAYOUT_EXPRESSION
		do
			Result := (to_expression - a_other)
			Result.sign := ({EV_LAYOUT_CONSTRAINT}.constraint_sign_equal)
		end

feature -- Conversion

	to_expression: EV_LAYOUT_EXPRESSION
		do
			create Result.make
			Result.terms.append (terms)
		end

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
