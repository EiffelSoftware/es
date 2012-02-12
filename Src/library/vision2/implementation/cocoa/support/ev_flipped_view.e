note
	description: "Summary description for {EV_FLIPPED_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FLIPPED_VIEW

inherit
	NS_VIEW
		redefine
			make,
			is_flipped,
			draw_rect_
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'
		do
			add_objc_callback ("isFlipped", agent is_flipped)
			add_objc_callback ("drawRect:", agent draw_rect_)
			Precursor
		end

feature -- Access

	is_flipped: BOOLEAN = True
			-- Is `Current' using flipped (i.e. top-left) coordinates?

feature {EV_ANY_I} -- Implementation

		set_cocoa_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'
		local
			l_color_utils: NS_COLOR_UTILS
		do
			create l_color_utils
			cocoa_bg_color := l_color_utils.color_with_calibrated_red__green__blue__alpha_ (a_color.red.to_double, a_color.green.to_double, a_color.blue.to_double, 1.0)
		end

	cocoa_bg_color: NS_COLOR
		-- Cached Cocoa background color

	bezier_path_utils: NS_BEZIER_PATH_UTILS
		once
			create Result
		end

	draw_rect_ (a_dirty_rect: NS_RECT)
		do
			if cocoa_bg_color /= Void then
				cocoa_bg_color.set
				bezier_path_utils.fill_rect_ (a_dirty_rect)
			end
		end

end
