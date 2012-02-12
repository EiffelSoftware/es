note
	description: "Cocoa implementation for SD_SYSTEM_SETTER."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	SD_SYSTEM_SETTER_IMP

inherit
	SD_SYSTEM_SETTER

	EV_ANY_HANDLER

feature -- Command

	before_enable_capture
		do
		end

	after_disable_capture
		do
		end

	is_remote_desktop: BOOLEAN
		do
		end

	is_during_pnd: BOOLEAN
			-- If mouse is in Pick and Drop mode now?
		do
		end

	clear_background_for_theme (a_widget: EV_DRAWING_AREA; a_rect: EV_RECTANGLE)
		local
			l_widget_imp: EV_DRAWING_AREA_IMP
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
			l_color: NS_COLOR
			l_color_utils: NS_COLOR_UTILS
		do
			l_widget_imp ?= a_widget.implementation
			check
				l_widget_imp /= Void
			end
			l_widget_imp.prepare_drawing
			create l_color.make
			create l_color_utils
			l_color := l_color_utils.control_color
			l_color.set
--			create path.make_with_rect (create {NS_RECT}.make_with_coordinates (a_rect.x, a_rect.y, a_rect.width, a_rect.height))
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_rect_ (create {NS_RECT}.make_with_coordinates (a_rect.x, a_rect.y, a_rect.width, a_rect.height))
			path.fill
			l_widget_imp.finish_drawing
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
