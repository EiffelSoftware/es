note
	description: "Implementation for objects that have layout attributes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LAYOUTABLE

feature -- Access

	left_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := single_term (left_position, 1)
		end

	right_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := double_term (left_position, 1, width, 1)
		end

	top_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms  := single_term (top_position, 1)
		end

	bottom_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := double_term (top_position, 1, height, 1)
		end

	width_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := single_term (width, 1)
		end

	height_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := single_term (height, 1)
		end

	horizontal_center_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := double_term (width, 0.5, left_position, 1)
		end

	vertical_center_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := double_term (height, 0.5, top_position, 1)
		end

	baseline_attribute: EV_LAYOUT_ATTRIBUTE
		do
			create Result.make
			Result.terms := double_term (height, 1, top_position, -0.1)
		end

feature {EV_AUTOLAYOUT_I} -- Access

	left_position: VARIABLE assign set_left_position
			-- The variable representing the left border of the widget.

	width: VARIABLE assign set_width
			-- The variable representing the right border of the widget.

	top_position: VARIABLE assign set_top_position
			-- The variable representing the top border of the widget.

	height: VARIABLE assign set_height
			-- The variable representing the bottom border of the widget.

	positions: LINKED_LIST [VARIABLE]
		do
			create Result.make
			Result.extend (left_position)
			Result.extend (width)
			Result.extend (top_position)
			Result.extend (height)
		end

	name_for_variable (a_variable: VARIABLE): STRING
			-- String representation of the position attribute backed by the variable `a_variable'.
		require
			variable_not_void: a_variable /= Void
		do
			if a_variable = left_position then
				Result := ".left_attribute"
			elseif a_variable =  width then
				Result := ".width_attribute"
			elseif a_variable =  top_position then
				Result := ".top_position"
			elseif a_variable =  height then
				Result := ".height_attribute"
			else
				Result := ".unknown_attribute"
			end
		end

feature {EV_AUTOLAYOUT_I} -- Element Change

	set_program (a_lp: LINEAR_PROGRAM)
		require
			program_not_void: a_lp /= Void
		local
			l_variable: VARIABLE
		do
			create l_variable.make_with_program (a_lp)
			set_left_position (l_variable)

			create l_variable.make_with_program (a_lp)
			set_width (l_variable)

			create l_variable.make_with_program (a_lp)
			set_top_position (l_variable)

			create l_variable.make_with_program (a_lp)
			set_height (l_variable)
		end

	set_minimum_size (a_minimum_width, a_minimum_height: INTEGER)
		require
			nonnegative_width: a_minimum_width >= 0
			nonnegative_height: a_minimum_height >= 0
			width_set: width /= Void
			height_set: height /= Void
		do
			width.set_minimum (a_minimum_width)
			height.set_minimum (a_minimum_height)
		ensure
			minimum_width_set: width.minimum = a_minimum_width
			minimum_height_set: height.minimum = a_minimum_height
		end

	set_maximum_size (a_maximum_width, a_maximum_height: INTEGER)
		require
			nonnegative_width : a_maximum_width >= 0
			nonnegative_height: a_maximum_height >= 0
		do
			width.set_maximum (a_maximum_width)
			height.set_maximum (a_maximum_height)
		ensure
			maximum_width_set: width.maximum = a_maximum_width
			maximum_height_set: height.maximum = a_maximum_height
		end

feature {NONE} -- Element Change

	set_left_position (a_position: like left_position)
		do
			left_position := a_position
		end

	set_width (a_position: like width)
		do
			width := a_position
		end

	set_top_position (a_position: like top_position)
		do
			top_position := a_position
		end

	set_height (a_position: like height)
		do
			height := a_position
		end

feature {NONE} -- Utility Methods


	single_term (a_variable: VARIABLE; a_coefficient: DOUBLE): LINKED_LIST [TERM]
		local
			l_term: TERM
		do
			create Result.make
			create l_term.make (a_variable, a_coefficient)
			Result.extend (l_term)
		end

	double_term (first_variable: VARIABLE; first_coefficient: DOUBLE; second_variable: VARIABLE; second_coefficient: DOUBLE): LINKED_LIST [TERM]
		local
			l_term: TERM
		do
			create Result.make

			create l_term.make (first_variable, first_coefficient)
			Result.extend (l_term)

			create l_term.make (second_variable, second_coefficient)
			Result.extend (l_term)
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
