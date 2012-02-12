note
	description: "Common abstraction for adding NSView functionality to Eiffel Vision."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_NS_VIEW

inherit
	EV_ANY_I
		redefine
			interface
		end

feature -- Positions

	x_position: INTEGER
			-- Horizontal offset relative to parent `x_position'.
			-- Unit of measurement: screen pixels.
		do
			Result := attached_view.frame.origin.x.rounded
		end

	y_position: INTEGER
			-- Vertical offset relative to parent `y_position'.
			-- Unit of measurement: screen pixels.
		local
			l_superview: detachable NS_VIEW
		do
			l_superview := attached_view.superview
			if attached l_superview and then l_superview.is_flipped then
				Result := attached_view.frame.origin.y.rounded
			else
				Result := (parent_inner_height - attached_view.frame.size.height - attached_view.frame.origin.y).rounded
			end
		end

	screen_x: INTEGER
			-- Horizontal position of the client area on screen,
		local
			l_point: NS_POINT
		do
			if attached {NS_WINDOW} attached_view.window as l_window then
				create l_point.make
				l_point.set_x (0)
				l_point.set_y (0)
				Result := l_window.convert_base_to_screen_ (attached_view.convert_point__to_view_ (l_point, Void)).x.rounded
			end
		end

	screen_y: INTEGER
			-- Horizontal position of the client area on screen,
		local
			screen_height: INTEGER
			position_in_window, position_on_screen, l_point: detachable NS_POINT
		do
			-- Translate the coordinate to a top-left coordinate system
			if attached attached_view.window as l_window and then attached l_window.screen as l_screen then
				screen_height := l_screen.frame.size.height.rounded
				create l_point.make
				if attached_view.is_flipped then
					l_point.set_x (0)
					l_point.set_y (0)
					position_in_window := attached_view.convert_point__to_view_ (l_point, Void)
				else
					l_point.set_x (0)
					l_point.set_y (attached_view.frame.size.height)
					position_in_window := attached_view.convert_point__to_view_ (l_point, Void)
				end
				position_on_screen := l_window.convert_base_to_screen_ (position_in_window)
				Result :=  screen_height - position_on_screen.y.rounded
			end
		end

	width: INTEGER
			-- Horizontal size measured in pixels.
		do
			Result := attached_view.frame.size.width.rounded
		end

	height: INTEGER
			-- Vertical size measured in pixels.
		do
			Result := attached_view.frame.size.height.rounded
		end

	minimum_width: INTEGER
		do
			Result := attached_view.fitting_size.width.rounded
		end

	minimum_height: INTEGER
		do
			Result := attached_view.fitting_size.height.rounded
		end

feature -- Measurement

	parent_inner_height: REAL_64
			-- FIXME: find a way to calculate the proper inner/client size of an nsview
		do
			if attached {EV_CONTAINER} parent as l_parent then
				if attached {EV_BOX_IMP} l_parent.implementation as l_box then
					Result := l_box.bounds.size.height
				elseif attached {EV_WINDOW_IMP} l_parent.implementation as l_window then
					if attached {NS_VIEW} l_window.content_view as l_content_view then
						Result := l_content_view.bounds.size.height
					end
				else
					--io.put_string ("f: " + cocoa_view.superview.frame.size.height.out + " b; " + cocoa_view.superview.bounds.size.height.out + " c: " + l_parent.client_height.out + "%N")
					Result := l_parent.client_height
				end
			else
				if attached {NS_VIEW} attached_view.superview as l_superview then
					Result := l_superview.bounds.size.height
				end
				--io.error.put_string ("Failed to calculate parent's inner height%N")
			end
		end

	parent: detachable EV_ANY
		deferred
		end

	cocoa_move (a_x_position, a_y_position: INTEGER)
		local
			l_point: NS_POINT
		do
			create l_point.make
			l_point.set_x (a_x_position)
			l_point.set_y (a_y_position)
			if attached attached_view.superview as l_superview and then not l_superview.is_flipped then
				-- Recalculate y-coordinate with respect to parent view
				if parent /= void then
					l_point.set_y (parent_inner_height - attached_view.frame.size.height - a_y_position)
				else
					io.put_string ("Warning: converting coordinates failed%N")
				end
			end
			attached_view.set_frame_origin_ (l_point)
		end

feature -- Element change

	set_tooltip (a_tooltip: READABLE_STRING_GENERAL)
			-- Set `tooltip' to `a_text'.
		do
			internal_tooltip_string := a_tooltip.as_string_32.twin
			attached_view.set_tool_tip_ (create {NS_STRING}.make_with_eiffel_string (a_tooltip.as_string_8))
		end

	tooltip: STRING_32
			-- Tooltip that has been set.
		do
			if attached internal_tooltip_string as l_tooltip then
				Result := l_tooltip.twin
			else
				create Result.make_empty
			end
		end

	set_pointer_style (a_cursor: EV_POINTER_STYLE)
			-- Assign `a_cursor' to `pointer_style'.
		local
			pointer_style_imp: detachable EV_POINTER_STYLE_IMP
		do
			pointer_style_imp ?= a_cursor.implementation
			check pointer_style_imp /= void end
			attached_view.discard_cursor_rects
			attached_view.add_cursor_rect__cursor_ (attached_view.visible_rect, pointer_style_imp.cursor)
		end

feature -- Focus

	has_focus: BOOLEAN
			-- Does widget have the keyboard focus?
		do

			Result := attached attached_view.window as win and then win.is_key_window
		end

	set_focus
			-- Grab keyboard focus.
		local
			success: BOOLEAN
		do
			if attached attached_view.window as win then
				success := win.make_first_responder_ (attached_view)
			end
		end

feature -- Implementation

	internal_tooltip_string: detachable STRING_32

	cocoa_view: detachable NS_VIEW
		note
			options: stable
		attribute
		end

	attached_view: NS_VIEW
		require
			cocoa_view /= void
		do
			check attached cocoa_view as l_result then
				Result := l_result
			end
		end

feature {EV_ANY_I} -- Layout padding constraints

	set_left_padding (a_padding: INTEGER)
		do
			if left_constraint /= Void and then left_constraint.relation = 0 then
				left_constraint.constant := a_padding
			else
				attached_view.remove_constraint_ (left_constraint)
				left_constraint := constraint_for_view_and_string (Current, "H:|-(" + a_padding.out + ")-[view]")
				attached_view.superview.add_constraint_ (left_constraint)
			end
		end

	set_right_padding (a_padding: INTEGER)
		do
			if right_constraint /= Void and then right_constraint.relation = 0 then
				right_constraint.constant := a_padding
			else
				attached_view.remove_constraint_ (right_constraint)
				right_constraint := constraint_for_view_and_string (Current, "H:[view]-(" + a_padding.out + ")-|")
				attached_view.superview.add_constraint_ (right_constraint)
			end
		end

	set_top_padding (a_padding: INTEGER)
		do
			if top_constraint /= Void and then top_constraint.relation = 0 then
				top_constraint.constant := a_padding
			else
				attached_view.remove_constraint_ (top_constraint)
				top_constraint := constraint_for_view_and_string (Current, "V:|-(" + a_padding.out + ")-[view]")
				attached_view.superview.add_constraint_ (top_constraint)
			end
		end

	set_bottom_padding (a_padding: INTEGER)
		do
			if bottom_constraint /= Void and then bottom_constraint.relation = 0 then
				bottom_constraint.constant := a_padding
			else
				attached_view.remove_constraint_ (bottom_constraint)
				bottom_constraint := constraint_for_view_and_string (Current, "V:[view]-(" + a_padding.out + ")-|")
				attached_view.superview.add_constraint_ (bottom_constraint)
			end
		end

	set_padding_constraints (a_padding: INTEGER)
		do
				-- Set vertical constraints:   V:|-padding-[v]-padding-|
				-- Set horizontal constraints: H:|-padding-[v]-padding-|
			set_top_padding (a_padding)
			set_bottom_padding (a_padding)
			set_left_padding (a_padding)
			set_right_padding (a_padding)
		end

	set_minimum_left_padding_constraint (v: EV_NS_VIEW; a_padding: INTEGER)
		do
			v.attached_view.superview.add_constraint_ (constraint_for_view_and_string (v, "H:|-(>=" + a_padding.out + ")-[view]"))
		end

	set_minimum_right_padding_constraint (v: EV_NS_VIEW; a_padding: INTEGER)
		do
			v.attached_view.superview.add_constraint_ (constraint_for_view_and_string (v, "H:[view]-(>=" + a_padding.out + ")-|"))
		end

	set_minimum_top_padding_constraint (v: EV_NS_VIEW; a_padding: INTEGER)
		do
			v.attached_view.superview.add_constraint_ (constraint_for_view_and_string (v, "V:|-(>=" + a_padding.out + ")-[view]"))
		end

	set_minimum_bottom_padding_constraint (v: EV_NS_VIEW; a_padding: INTEGER)
		do
			v.attached_view.superview.add_constraint_ (constraint_for_view_and_string (v, "V:[view]-(>=" + a_padding.out + ")-|"))
		end

	set_horizontal_padding_constraints (first_view, second_view: NS_VIEW; a_padding: INTEGER)
		require
			first_view_not_void: first_view /= Void
			second_view_not_void: second_view /= Void
			padding_non_negative: a_padding >= 0
		local
			l_dictionary: NS_MUTABLE_DICTIONARY
			l_string: NS_STRING
		do
			create l_dictionary.make
			l_dictionary.set_object__for_key_ (first_view, create {NS_STRING}.make_with_eiffel_string ("view_1"))
			l_dictionary.set_object__for_key_ (second_view, create {NS_STRING}.make_with_eiffel_string ("view_2"))
			create l_string.make_with_eiffel_string ("H:[view_1]-" + a_padding.out + "-[view_2]")
			attached_view.add_constraints_ (constraint_utils.constraints_with_visual_format__options__metrics__views_ (l_string, 0, Void, l_dictionary))
		end

	set_vertical_padding_constraints (first_view, second_view: NS_VIEW; a_padding: INTEGER)
		require
			first_view_not_void: first_view /= Void
			second_view_not_void: second_view /= Void
			padding_non_negative: a_padding >= 0
		local
			l_dictionary: NS_MUTABLE_DICTIONARY
			l_string: NS_STRING
		do
			create l_dictionary.make
			l_dictionary.set_object__for_key_ (first_view, create {NS_STRING}.make_with_eiffel_string ("view_1"))
			l_dictionary.set_object__for_key_ (second_view, create {NS_STRING}.make_with_eiffel_string ("view_2"))
			create l_string.make_with_eiffel_string ("V:[view_1]-" + a_padding.out + "-[view_2]")
			attached_view.add_constraints_ (constraint_utils.constraints_with_visual_format__options__metrics__views_ (l_string, 0, Void, l_dictionary))
		end

feature {EV_ANY_I} -- Layout size constraints

	set_minimum_width_constraint (a_width: INTEGER)
		require
			positive_width: a_width >= 0
		do
			if width_constraint /= Void and then width_constraint.relation = 1 then
				width_constraint.constant := a_width
			else
				attached_view.remove_constraint_ (width_constraint)
				width_constraint := constraint_for_view_and_string (Current, "H:[view(>=" + a_width.out + ")]")
				attached_view.add_constraint_ (width_constraint)
			end
		end

	set_minimum_height_constraint (a_height: INTEGER)
		require
			positive_height: a_height >= 0
		do
			if height_constraint /= Void and then height_constraint.relation = 1 then
				height_constraint.constant := a_height
			else
				attached_view.remove_constraint_ (height_constraint)
				height_constraint := constraint_for_view_and_string (Current, "V:[view(>=" + a_height.out + ")]")
				attached_view.add_constraint_ (height_constraint)
			end
		end

	set_fixed_width_constraint (a_width: INTEGER)
		require
			positive_width: a_width >= 0
		do
			if width_constraint /= Void and then width_constraint.relation = 0 then
				width_constraint.constant := a_width
			else
				attached_view.remove_constraint_ (width_constraint)
				width_constraint := constraint_for_view_and_string (Current, "H:[view(" + a_width.out + ")]")
				attached_view.add_constraint_ (width_constraint)
			end
		end

	set_fixed_height_constraint (a_height: INTEGER)
		require
			positive_height: a_height >= 0
		do
			if height_constraint /= Void and then height_constraint.relation = 0 then
				height_constraint.constant := a_height
			else
				attached_view.remove_constraint_ (height_constraint)
				height_constraint := constraint_for_view_and_string (Current, "V:[view(" + a_height.out + ")]")
				attached_view.add_constraint_ (height_constraint)
			end
		end

feature {EV_ANY_I} -- Update constraints

	update_horizontal_padding_constraints (a_padding: INTEGER)
		do
			update_padding_constraints (a_padding, 5)
		end

	update_vertical_padding_constraints (a_padding: INTEGER)
		do
			update_padding_constraints (a_padding, 3)
		end

	update_padding_constraints (a_padding, a_attribute: INTEGER_64)
		local
			i: NATURAL_64
		do
			from i := 0
			until i >= attached_view.constraints.count
			loop
				check attached {NS_LAYOUT_CONSTRAINT} attached_view.constraints.object_at_index_ (i) as l_constraint then
					if l_constraint.first_attribute = a_attribute and l_constraint.second_attribute = a_attribute + 1 then
						l_constraint.constant := a_padding
					end
				end
				i := i + 1
			end
		end

feature {EV_ANY_I} -- Implementation

	set_position_constraints (a_view: EV_NS_VIEW; a_x, a_y: INTEGER)
		require
			view_not_void: a_view /= Void
		do
			if left_constraint /= Void then
				left_constraint.constant := a_x
			else
				left_constraint := constraint_for_view_and_string (a_view, "H:|-(" + a_x.out + ")-[view]")
				a_view.attached_view.superview.add_constraint_ (left_constraint)
			end
			if top_constraint /= Void then
				top_constraint.constant := a_y
			else
				top_constraint := constraint_for_view_and_string (a_view, "V:|-(" + a_y.out + ")-[view]")
				a_view.attached_view.superview.add_constraint_ (top_constraint)
			end
		end

feature {EV_ANY_I} -- Widget constraints

	left_constraint, right_constraint, top_constraint, bottom_constraint: NS_LAYOUT_CONSTRAINT

	width_constraint, height_constraint: NS_LAYOUT_CONSTRAINT

feature {NONE} -- Implementation

	constraint_utils: NS_LAYOUT_CONSTRAINT_UTILS
		once
			create Result
		end

	constraint_for_view_and_string (a_view: EV_NS_VIEW; a_string: STRING_8): attached NS_LAYOUT_CONSTRAINT
		require
			view_not_void: a_view /= Void
			string_not_empty: a_string /= Void and then not a_string.is_empty
		local
			l_string: NS_STRING
			l_dictionary: NS_MUTABLE_DICTIONARY
			l_array: NS_ARRAY
		do
			create l_string.make_with_eiffel_string (a_string)
			create l_dictionary.make
			l_dictionary.set_object__for_key_ (a_view.attached_view, create {NS_STRING}.make_with_eiffel_string ("view"))
			l_array := constraint_utils.constraints_with_visual_format__options__metrics__views_ (l_string, 0, Void, l_dictionary)
			check attached {NS_LAYOUT_CONSTRAINT} l_array.object_at_index_ (0) as l_result then
				Result := l_result
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_ANY note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'.

end
