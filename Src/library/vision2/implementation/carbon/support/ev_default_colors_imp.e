indexing
	description: "List of default colors used by the system. Gtk implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_STOCK_COLORS_IMP

create
	default_create

feature
	color_dialog: EV_COLOR is
			-- Access
			-- Color usely used for the background of dialogs
			-- Was declared in EV_STOCK_COLORS_IMP as synonym of color_dialog.
			-- Was declared in EV_STOCK_COLORS_IMP as synonym of color_3d_face.
		do
		end

	color_3d_face: EV_COLOR is
			-- Color usely used for the background of dialogs
			-- Was declared in EV_STOCK_COLORS_IMP as synonym of color_dialog.
			-- Was declared in EV_STOCK_COLORS_IMP as synonym of color_dialog.
		do
		end

	color_dialog_fg: EV_COLOR is
		do
		end

	color_3d_highlight: EV_COLOR is
		do
		end

	color_3d_shadow: EV_COLOR is
		do
		end

	color_read_only: EV_COLOR is
			-- Status report
		do
		end

	color_read_write: EV_COLOR is
		do
		end

	default_background_color: EV_COLOR is
			-- from ANY
		do
		end

	default_foreground_color: EV_COLOR is
		do
		end

indexing
	copyright: "Copyright (c) 1984-2006, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		356 Storke Road, Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end -- class EV_STOCK_COLORS_IMP

