note
	description: "Summary description for {EV_NS_WINDOW}."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_NS_WINDOW

inherit

	NS_WINDOW
		rename
			set_background_color_ as cocoa_set_background_color,
			background_color as cocoa_background_color,
			item as window_item,
			title as cocoa_title,
			set_title_ as cocoa_set_title
		undefine
			copy,
			is_equal
		select
			window_item
		end

	NS_WINDOW_DELEGATE_PROTOCOL
		rename
			item as window_delegate_item
		undefine
			copy,
			is_equal
		end

feature -- Window Title

	set_title (a_title: READABLE_STRING_GENERAL)
			-- <Precursor>
		do
			cocoa_set_title (create {NS_STRING}.make_with_eiffel_string (a_title.as_string_8))
			internal_title := a_title.as_string_32
		end

	title: STRING_32
			-- <Precursor>-
		do
			if attached internal_title as l_title then
				Result := l_title.twin
			else
				create Result.make_empty
			end
		end

	internal_title: detachable STRING_32


feature -- Measurement

	x_position, screen_x: INTEGER
			-- X coordinate of `Current'
		do
			Result := frame.origin.x.rounded
		end

	y_position, screen_y: INTEGER
			-- Y coordinate of `Current'
		do
			Result := (zero_screen.frame.size.height - frame.origin.y - frame.size.height).rounded
		end

	set_x_position (a_x: INTEGER)
			-- Set horizontal offset to parent to `a_x'.
		do
			set_position (a_x, y_position)
		end

	set_y_position (a_y: INTEGER)
			-- Set vertical offset to parent to `a_y'.
		do
			set_position (x_position, a_y)
		end

	set_position (a_x, a_y: INTEGER)
			-- Set horizontal offset to parent to `a_x'.
			-- Set vertical offset to parent to `a_y'.
		local
			l_point: NS_POINT
		do
			create l_point.make
			l_point.set_x (a_x)
			l_point.set_y (a_y)
			set_frame_top_left_point_ (l_point)
		end

	width: INTEGER
			-- Horizontal size measured in pixels.
		do
			Result := frame.size.width.rounded
		end

	height: INTEGER
			-- Vertical size measured in pixels.
		do
			Result := frame.size.height.rounded
		end

	set_width (a_width: INTEGER)
			-- Set the horizontal size to `a_width'.
		do
			set_size (a_width, height)
		end

	set_height (a_height: INTEGER)
			-- Set the vertical size to `a_height'.
		do
			set_size (width, a_height)
		end

	set_size (a_width, a_height: INTEGER)
			-- Set the horizontal size to `a_width'.
			-- Set the vertical size to `a_height'.
		do
			set_frame__display_ (create {NS_RECT}.make_with_coordinates (x_position, y_position, a_width, a_height), True)
		end

	forbid_resize
			-- Forbid the resize of `Current'.
		local
			l_button: detachable NS_BUTTON
		do
			set_shows_resize_indicator_ (False)
			-- NSWindowZoomButton
			l_button := standard_window_button_ (2)
			if attached l_button then
				l_button.set_enabled_ (False)
			end
		end

	allow_resize
			-- Allow the resize of `Current'.
		local
			l_button: detachable NS_BUTTON
		do
			set_shows_resize_indicator_ (True)
			-- NSWindowZoomButton = 2
			l_button := standard_window_button_ (2)
			if attached l_button then
				l_button.set_enabled_ (True)
			end
		end

feature {NONE} -- Implementation

	zero_screen: NS_SCREEN
		local
			l_screen_utils: NS_SCREEN_UTILS
		once
			create l_screen_utils
			if attached {NS_SCREEN}l_screen_utils.screens.object_at_index_ (0) as l_screen then
				Result := l_screen
			end
		end

end
