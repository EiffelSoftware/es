note
	description: "[
					Cocoa implementation to draw native looking notebook tabs.
					]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SD_NOTEBOOK_TAB_DRAWER_IMP

inherit
	SD_NOTEBOOK_TAB_DRAWER_I
		redefine
			make,
			draw_pixmap_text_selected,
			draw_pixmap_text_unselected,
			expose_unselected,
			expose_selected,
			expose_hot,
			draw_focus_rect
		end

	EV_ANY_HANDLER

create
	make

feature {NONE} -- Initlialization

	make
			-- Creation method
		do
			Precursor {SD_NOTEBOOK_TAB_DRAWER_I}
		end

feature -- Command

	expose_unselected (a_width: INTEGER; a_tab_info: SD_NOTEBOOK_TAB_INFO)
			-- <Precursor>
		do
			Precursor {SD_NOTEBOOK_TAB_DRAWER_I} (a_width, a_tab_info)
			expose (a_width, a_tab_info)
		end

	expose_selected (a_width: INTEGER; a_tab_info: SD_NOTEBOOK_TAB_INFO)
			-- <Precursor>
		local
--			l_pixmap_imp: EV_PIXMAP_IMP
--			l_segmented_control: NS_SEGMENTED_CONTROL
--			icon: NS_IMAGE
		do
			Precursor {SD_NOTEBOOK_TAB_DRAWER_I} (a_width, a_tab_info)
			expose (a_width, a_tab_info)
		end

	expose_hot (a_width: INTEGER; a_tab_info: SD_NOTEBOOK_TAB_INFO)
			-- <Precursor>
		do
			Precursor {SD_NOTEBOOK_TAB_DRAWER_I} (a_width, a_tab_info)
			expose (a_width, a_tab_info)
		end

	expose (a_width: INTEGER;  a_tab_info: SD_NOTEBOOK_TAB_INFO)
		local
			l_pixmap_imp: EV_PIXMAP_IMP
			l_segmented_control: NS_SEGMENTED_CONTROL
			icon: NS_IMAGE
			trans: NS_AFFINE_TRANSFORM
			l_size: NS_SIZE
		do
			start_draw

			l_pixmap_imp ?= buffer_pixmap.implementation
			check not_void: l_pixmap_imp /= Void end

			l_pixmap_imp.prepare_drawing

			create trans.make
			trans.translate_x_by__y_by_ ({REAL_32}0.0, l_pixmap_imp.image.size.height.truncated_to_real)
			trans.scale_x_by__y_by_ ({REAL_32}1.0, {REAL_32}-1.0)
--			[NSAffineTransform concat] not present in Matteo's framework
--			trans.concat

			create l_segmented_control.make
			l_segmented_control.set_segment_count_ (1)
			-- segment_style_small_quare = 6
			l_segmented_control.set_segment_style_ (6)
			if is_selected then
				l_segmented_control.set_selected_segment_ (0)
			end
			l_segmented_control.set_label__for_segment_ (create {NS_STRING}.make_with_eiffel_string (text), 0)
			l_segmented_control.set_enabled__for_segment_ (True, 0)
			l_segmented_control.set_width__for_segment_ (a_width-4, 0)
			if attached {EV_PIXMAP_IMP} pixmap.implementation as l_icon_imp then
				-- Twin is not allowd on wrapped objects
--				icon := l_icon_imp.image.twin
				--icon.set_flipped (True)
				icon := l_icon_imp.image
				create l_size.make
				l_size.set_width (20)
				l_size.set_height (20)
				icon.set_size_ (l_size)
				l_segmented_control.set_image__for_segment_ (icon, 0)
			end

			l_segmented_control.set_frame_ (create {NS_RECT}.make_with_coordinates (0, 0, a_width, buffer_pixmap.height + 1))
			l_segmented_control.draw_rect_ (create {NS_RECT}.make_with_coordinates (0, 0, a_width, buffer_pixmap.height + 1))

			l_pixmap_imp.finish_drawing


--			pixmap.stretch (20, 20)
--			buffer_pixmap.draw_pixmap (0, 0, pixmap)
--			draw_pixmap_text_selected (buffer_pixmap, 20, a_width)
--			draw_close_button (buffer_pixmap, pixmap)

			end_draw

			if internal_tab.parent.has_focus then
				internal_tab.draw_focus_rect
			end
		end

	draw_focus_rect (a_rect: EV_RECTANGLE)
			-- <Precursor>
		do
--			wel_draw_focus_rect (l_dc, l_rect)
		end

	draw_close_button (a_drawable: EV_DRAWABLE; a_close_pixmap: EV_PIXMAP)
			-- Redefine
		do
			a_drawable.draw_rectangle (start_x_close, start_y_close, start_x_close + 10, start_y_close + 10)
		end

	draw_pixmap_text_selected (a_pixmap: EV_DRAWABLE; a_start_x, a_width: INTEGER)
			-- Redefine
		do
			buffer_pixmap.draw_text (a_start_x, 0, text)
		end

	draw_pixmap_text_unselected (a_pixmap: EV_DRAWABLE; a_start_x, a_width: INTEGER)
			-- Redefine
		do
			buffer_pixmap.draw_text (a_start_x, 0, text)
		end

feature {NONE}  -- Implementation	

	gap_height: INTEGER = 0
			-- Redefine

	start_y_position: INTEGER = 1
			-- Redefine

	start_y_position_text: INTEGER
			-- Redefine
		do
		end

note
	library:	"SmartDocking: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
