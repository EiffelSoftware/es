note
	description: "Summary description for {EV_LAYOUT_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LAYOUT_EXPRESSION

create
	make, make_with_other


feature {NONE} -- Initialization

	make
			-- Initalize `Current'.
		do
			create terms.make
		end

	make_with_other (other: like Current)
			-- Initialize `Current' from another layout expression.
		do
			create terms.make
			terms.append (other.terms)
			set_sign (other.sign)
			set_right_hand_side (other.right_hand_side)
		end

feature -- Access

	terms: LINKED_LIST [TERM]

	sign: INTEGER assign set_sign

	right_hand_side: REAL_64 assign set_right_hand_side

feature -- Element Change

	set_sign (a_sign: like sign)
		do
			sign:= a_sign
		end

	set_right_hand_side (a_right_hand_side: like right_hand_side)
		do
			right_hand_side := a_right_hand_side
		end

	plus alias "+" (other: like Current): like Current
		do
			create Result.make_with_other (Current)
			Result.terms.append (other.terms)
			Result.right_hand_side := Result.right_hand_side + other.right_hand_side
		end

	minus alias "-" (other: like Current): like Current
		local
			l_term: TERM
		do
			create Result.make_with_other (Current)
			across other.terms as term loop
				create l_term.make (term.item.variable, - term.item.coefficient)
				Result.terms.extend (l_term)
			end
			Result.right_hand_side := Result.right_hand_side - other.right_hand_side
		end

	greater_equal alias ">=" (other: like Current): like Current
		do
			create Result.make_with_other (Current)
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_greater_than_or_equal
			Result := Result - other
		end

	less_equal alias "<=" (other: like Current): like Current
		do
			create Result.make_with_other (Current)
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_less_than_or_equal
			Result := Result - other
		end

	equal_to (other: like Current): like Current
		do
			create Result.make_with_other (Current)
			Result.sign := {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal
			Result := Result - other
		end


note
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
