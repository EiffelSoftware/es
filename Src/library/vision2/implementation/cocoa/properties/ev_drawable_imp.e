note
	description: "EiffelVision drawable. Cocoa implementation."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	keywords: "figures, primitives, drawing, line, point, ellipse"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_DRAWABLE_IMP

inherit
	EV_DRAWABLE_I
		redefine
			interface
		end

	EV_DRAWABLE_CONSTANTS

	DISPOSABLE

feature {NONE} -- Initialization

	old_make (an_interface: like interface)
			-- Create an empty drawing area.
		do
			assign_interface (an_interface)
		end

	make
			-- Set default values. Call during initialization.
		local
			l_size: NS_SIZE
		do
			create l_size.make
			l_size.set_width (1)
			l_size.set_height (1)
			create image.make_with_size_ (l_size)

			if internal_background_color = void then
				create internal_background_color.make_with_rgb (1, 1, 1)
			end
			if internal_foreground_color = void then
	        	create internal_foreground_color.make_with_rgb (0, 0, 0)
			end
			create app_kit_additions
			set_line_width (1)
			set_is_initialized (True)
		end

feature {EV_DRAWABLE_IMP, EV_APPLICATION_IMP} -- Implementation

	height: INTEGER
			-- Needed by `draw_straight_line'.
		deferred
		end

	width: INTEGER
			-- Needed by `draw_straight_line'.
		deferred
		end

feature -- Access

	font: EV_FONT
			-- Font used for drawing text.
		do
			if attached internal_font_imp as l_font then
				Result := l_font.attached_interface.twin
			else
				create Result
			end
		end

	foreground_color_internal: EV_COLOR
			-- Color used to draw primitives.
			-- Default: black.
		do
			if attached internal_foreground_color as l_color then
				create Result.make_with_8_bit_rgb (l_color.red_8_bit, l_color.green_8_bit, l_color.blue_8_bit)
			else
				create Result.make_with_8_bit_rgb (0, 0, 0)
			end
		end

	background_color_internal: EV_COLOR
			-- Color used for erasing of canvas.
			-- Default: white.
		do
			if attached internal_background_color as l_color then
				create Result.make_with_8_bit_rgb (l_color.red_8_bit, l_color.green_8_bit, l_color.blue_8_bit)
			else
				create Result.make_with_8_bit_rgb (255, 255, 255)
			end
		end

	line_width: INTEGER
			-- Line thickness.
		do
			Result := internal_line_width
		end

	drawing_mode: INTEGER
			-- Logical operation on pixels when drawing.

	clip_area: detachable EV_RECTANGLE
			-- Clip area used to clip drawing.
			-- If set to Void, no clipping is applied.

	tile: detachable EV_PIXMAP
			-- Pixmap that is used to fill instead of background_color.
			-- If set to Void, `background_color' is used to fill.

	dashed_line_style: BOOLEAN
			-- Are lines drawn dashed?
		do
			Result := internal_dashed_line_style
		end

feature -- Element change

	set_font (a_font: EV_FONT)
			-- Set `font' to `a_font'.
		do
			if internal_font_imp /= a_font.implementation then
				internal_font_imp ?= a_font.implementation
			end
		end

	set_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'.
		do
			internal_background_color := a_color
		end

	set_foreground_color (a_color: EV_COLOR)
			-- Assign `a_color' to `foreground_color'
		do
			internal_foreground_color := a_color
		end

	set_line_width (a_width: INTEGER)
			-- Assign `a_width' to `line_width'.
		do
			internal_line_width := a_width
		end

	set_drawing_mode (a_mode: INTEGER)
			-- Set drawing mode to `a_mode'.
		do
			drawing_mode := a_mode
		end

	set_clip_area (an_area: EV_RECTANGLE)
			-- Set an area to clip to.
		do
			clip_area := an_area
		end

	set_clip_region (a_region: EV_REGION)
			-- Set a region to clip to.
		do

		end

	remove_clipping
			-- Do not apply any clipping.
		do
			clip_area := void
		end

	set_tile (a_pixmap: EV_PIXMAP)
			-- Set tile used to fill figures.
			-- Set to Void to use `background_color' to fill.
		do
			tile := a_pixmap
		end

	remove_tile
			-- Do not apply a tile when filling.
		do
			tile := Void
		end

	enable_dashed_line_style
			-- Draw lines dashed.
		do
			internal_dashed_line_style := true
		end

	disable_dashed_line_style
			-- Draw lines solid.
		do
			internal_dashed_line_style := false
		end

feature -- Clearing operations

	clear
			-- Erase `Current' with `background_color'.
		do
			clear_rectangle (0, 0, width, height)
		end

	clear_rectangle (x, y, a_width, a_height: INTEGER)
			-- Erase rectangle specified with `background_color'.
		local
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
			color: detachable EV_COLOR_IMP
		do
			prepare_drawing
			color ?= background_color.implementation
			check color /= void end
			color.color.set
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_rect_ (create {NS_RECT}.make_with_coordinates (x, y, a_width, a_height))
			path.fill
			finish_drawing
		end

feature -- Drawing operations

	draw_point (x, y: INTEGER)
			-- Draw point at (`x', `y').
		do
			draw_segment (x, y, x, y+1)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
			draw_text_top_left (x, y - font.ascent, a_text)
		end

	draw_rotated_text (x, y: INTEGER; angle: REAL; a_text: READABLE_STRING_GENERAL)
			-- Draw rotated text `a_text' with left of baseline at (`x', `y') using `font'.
			-- Rotation is number of radians counter-clockwise from horizontal plane.
		do
			-- fixme rotate!
			draw_text_top_left (x, y, a_text)
		end

	draw_ellipsed_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			-- fixme make ellipsed
			draw_text_top_left (x, y, a_text)
		end

	draw_ellipsed_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			-- fixme make ellipsed
			draw_text_top_left (x, y, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		local
			l_string: NS_STRING
			l_string_drawing: NS_STRING_DRAWING_CAT
			l_attributes: NS_MUTABLE_DICTIONARY
			l_font: detachable EV_FONT_IMP
			l_color: detachable EV_COLOR_IMP
			trans: NS_AFFINE_TRANSFORM
			l_point: NS_POINT
		do
			create l_string.make_with_eiffel_string (a_text.as_string_8)
			create l_string_drawing
			l_font ?= font.implementation
			check l_font /= Void end
			l_color ?= foreground_color.implementation
			check l_color /= Void end

			create l_attributes.make_with_capacity_ (2)
			l_attributes.set_object__for_key_ (l_font.font, create {NS_STRING}.make_with_eiffel_string ("NSFont"))
			l_attributes.set_object__for_key_ (l_color.color, create {NS_STRING}.make_with_eiffel_string ("NSColor"))
			prepare_drawing

			create trans.make
			trans.translate_x_by__y_by_ (x, y)
			if not is_flipped then
				trans.translate_x_by__y_by_ (0, l_string_drawing.size_with_attributes_ (l_string, l_attributes).height)
				trans.scale_x_by__y_by_ (1.0, -1.0)
			end
			app_kit_additions.concat (trans)

			create l_point.make
			l_point.set_x (0)
			l_point.set_y (0)

			l_string_drawing.draw_at_point__with_attributes_ (l_string, l_point, l_attributes)

			finish_drawing
		end

	draw_segment (x1, y1, x2, y2: INTEGER)
			-- Draw line segment from (`x1', `y1') to (`x2', `y2').
		local
			path: NS_BEZIER_PATH
			l_point1, l_point2: NS_POINT
		do
			prepare_drawing
			create path.make
			path.set_line_width_ (internal_line_width)
			-- Unsupported type!
--			if internal_dashed_line_style then
--				path.set_line_dash_count_phase (create {ARRAYED_LIST[REAL]}.make_from_array (<<{REAL_32}1.0, {REAL_32}1.0>>), {REAL_32}0.0)
--			end
			create l_point1.make
			l_point1.set_x (x1)
			l_point1.set_y (y1)
			path.move_to_point_ (l_point1)

			create l_point2.make
			l_point2.set_x (x2)
			l_point2.set_y (y2)
			path.line_to_point_ (l_point2)
			path.stroke
			finish_drawing
		end

	draw_arc (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL)
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- Angles are measured in radians.
		do
		end

	draw_sub_pixel_buffer (x, y: INTEGER; a_pixel_buffer: EV_PIXEL_BUFFER; a_area: EV_RECTANGLE)
			-- Draw `area' of `a_pixel_buffer' with upper-left corner on (`x', `y').
		local
			pixel_buffer_imp: detachable EV_PIXEL_BUFFER_IMP
			source_rect, destination_rect: NS_RECT
			trans: NS_AFFINE_TRANSFORM
			l_point: NS_POINT
		do
			prepare_drawing
			pixel_buffer_imp ?= a_pixel_buffer.implementation
			check pixel_buffer_imp /= void end

			create trans.make
			trans.translate_x_by__y_by_ (x, y + a_area.height)
			trans.scale_x_by__y_by_ (1, -1)
			app_kit_additions.concat (trans)

			destination_rect := create {NS_RECT}.make_with_coordinates (0, 0, a_area.height, a_area.width)
			source_rect := create {NS_RECT}.make_with_coordinates (a_area.x, a_pixel_buffer.height - a_area.height - a_area.y, a_area.width, a_area.height)
			create l_point.make
			l_point.set_x (0)
			l_point.set_y (0)
			-- NSCompositeSourceOver = 2
			pixel_buffer_imp.image.composite_to_point__from_rect__operation_ (l_point, source_rect, 2)
--			pixel_buffer_imp.image.draw_in_rect (create {NS_RECT}.make_rect (a_x, a_y, a_area.width, a_area.height), create {NS_RECT}.make_rect (a_area.x, y_cocoa, a_area.width, a_area.height), 2, 1)

			finish_drawing
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
			-- Draw `a_pixmap' with upper-left corner on (`x', `y').
		local
			pixmap_imp: detachable EV_PIXMAP_IMP
			source_rect, destination_rect: NS_RECT
			trans: NS_AFFINE_TRANSFORM
			l_point: NS_POINT
		do
			pixmap_imp ?= a_pixmap.implementation
			check pixmap_imp /= Void end

			prepare_drawing

			create trans.make
			trans.translate_x_by__y_by_ (x, pixmap_imp.image.size.height.rounded + y)
			trans.scale_x_by__y_by_ (1, -1)
			app_kit_additions.concat (trans)

			destination_rect := create {NS_RECT}.make_with_coordinates (0, 0, a_pixmap.height, a_pixmap.width)
			source_rect := create {NS_RECT}.make_with_coordinates (0, 0, a_pixmap.width, a_pixmap.height)
--			pixmap_imp.image.draw_in_rect (destination_rect, source_rect, {NS_IMAGE}.composite_source_over, 1) -- did not work correctly for SD_NOTEBOOK_TAB_DRAWER_I.end_draw
			create l_point.make
			l_point.set_x (0)
			l_point.set_y (0)
			-- NSCompositeSourceOver
			pixmap_imp.image.draw_at_point__from_rect__operation__fraction_ (l_point, source_rect, 2, 1)
			finish_drawing
		end

	sub_pixmap (a_area: EV_RECTANGLE): EV_PIXMAP
			-- Pixmap region of `Current' represented by rectangle `area'
		local
			l_pixmap_imp: detachable EV_PIXMAP_IMP
		do
			create Result.make_with_size (a_area.width, a_area.height)
			l_pixmap_imp ?= Result.implementation
			check l_pixmap_imp /= Void end
			l_pixmap_imp.image.lock_focus
			-- NSCompositeSourceOver = 2
			image.draw_in_rect__from_rect__operation__fraction_ (
				create {NS_RECT}.make_with_coordinates (0, 0, a_area.width, a_area.height),
				create {NS_RECT}.make_with_coordinates (a_area.x, height - a_area.height - a_area.y, a_area.width, a_area.height),
				2, 1)
			l_pixmap_imp.image.unlock_focus
		end

	draw_sub_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; a_area: EV_RECTANGLE)
			-- Draw `area' of `a_pixmap' with upper-left corner on (`x', `y').
		local
			pixmap_imp: detachable EV_PIXMAP_IMP
--			color: NS_COLOR
--			path: NS_BEZIER_PATH
			trans: NS_AFFINE_TRANSFORM
			source_rect, destination_rect: NS_RECT
			l_point: NS_POINT
		do
			pixmap_imp ?= a_pixmap.implementation
			check pixmap_imp /= void end

			prepare_drawing

			create trans.make
			trans.translate_x_by__y_by_ (x, y + a_area.height)
			trans.scale_x_by__y_by_ (1, -1)
			app_kit_additions.concat (trans)

			destination_rect := create {NS_RECT}.make_with_coordinates (0, 0, a_area.height, a_area.width)
			source_rect := create {NS_RECT}.make_with_coordinates (a_area.x, a_pixmap.height - a_area.height - a_area.y, a_area.width, a_area.height)
--			pixmap_imp.image.draw_in_rect (destination_rect, source_rect, {NS_IMAGE}.composite_source_over, 1)
--			pixmap_imp.image.draw_at_point (create {NS_POINT}.make_point(0,0), source_rect, {NS_IMAGE}.composite_source_over, 1)
			create l_point.make
			l_point.set_x (0)
			l_point.set_y (0)
			-- NSCompositeSourceOver = 2
			pixmap_imp.image.composite_to_point__from_rect__operation_ (l_point, source_rect, 2)

--			create color.blue_color
--			color.color_with_alpha_component ({REAL_32}0.5).set
--			create path.make_with_rect ( create {NS_RECT}.make_rect (0, 0, a_area.width, a_area.height) )
--			path.set_line_width (internal_line_width)
--			path.fill
--			path.stroke

			finish_drawing
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'.
		local
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
		do
			prepare_drawing
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_rect_ (create {NS_RECT}.make_with_coordinates (x, y, a_width, a_height))
			path.set_line_width_ (internal_line_width)
			-- Unsupported type!
--			if internal_dashed_line_style then
--				path.set_line_dash_count_phase (create {ARRAYED_LIST[REAL]}.make_from_array (<<{REAL_32}1.0, {REAL_32}1.0>>), {REAL_32}0.0)
--			end
			path.stroke
			finish_drawing
		end

	draw_ellipse (x, y, a_width, a_height: INTEGER)
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
		local
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
		do
			prepare_drawing
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_oval_in_rect_ (create {NS_RECT}.make_with_coordinates (x, y, a_width, a_height))
			path.set_line_width_ (internal_line_width)
			-- Unsupported type!
--			if internal_dashed_line_style then
--				path.set_line_dash_count_phase (create {ARRAYED_LIST[REAL]}.make_from_array (<<{REAL_32}1.0, {REAL_32}1.0>>), {REAL_32}0.0)
--			end
			path.stroke
			finish_drawing
		end

	draw_polyline (points: ARRAY [EV_COORDINATE]; is_closed: BOOLEAN)
			-- Draw line segments between subsequent points in
			-- `points'. If `is_closed' draw line segment between first
			-- and last point in `points'.
		local
			path: NS_BEZIER_PATH
			i: INTEGER
			l_coord: EV_COORDINATE
			l_point: NS_POINT
		do
			prepare_drawing
			create path.make
			path.set_line_width_ (internal_line_width)
			-- Unsupported type!
--			if internal_dashed_line_style then
--				path.set_line_dash_count_phase (create {ARRAYED_LIST[REAL]}.make_from_array (<<{REAL_32}1.0, {REAL_32}1.0>>), {REAL_32}0.0)
--			end
			if not points.is_empty then
				l_coord := 	points.item (points.lower)
				create l_point.make
				l_point.set_x (l_coord.x)
				l_point.set_y (l_coord.y)
				path.move_to_point_ (l_point)
				from
					i := points.lower + 1
				until
					i > points.upper
				loop
					l_coord := 	points.item (i)
					create l_point.make
					l_point.set_x (l_coord.x)
					l_point.set_y (l_coord.y)
					path.line_to_point_ (l_point)
					i := i + 1
				end
				if is_closed then
					l_coord := 	points.item (points.lower)
					create l_point.make
					l_point.set_x (l_coord.x)
					l_point.set_y (l_coord.y)
					path.line_to_point_ (l_point)
				end
			end
			path.stroke
			finish_drawing
		end

	draw_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL)
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians
		do

		end

feature -- filling operations

	fill_rectangle (x, y, a_width, a_height: INTEGER)
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'. Fill with `background_color'.
		local
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
		do
			prepare_drawing
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_rect_ (create {NS_RECT}.make_with_coordinates (x, y, a_width, a_height))
			path.fill
			finish_drawing
		end

	fill_ellipse (x, y, a_width, a_height: INTEGER)
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Fill with `background_color'.
		local
			path: NS_BEZIER_PATH
			path_utils: NS_BEZIER_PATH_UTILS
		do
			prepare_drawing
			create path.make
			create path_utils
			path := path_utils.bezier_path_with_oval_in_rect_ (create {NS_RECT}.make_with_coordinates (x, y, a_width, a_height))
			path.fill
			finish_drawing
		end

	fill_polygon (points: ARRAY [EV_COORDINATE])
			-- Draw line segments between subsequent points in `points'.
			-- Fill all enclosed area's with `background_color'.
		local
			path: NS_BEZIER_PATH
			i: INTEGER
			l_coord: EV_COORDINATE
			l_point: NS_POINT
		do
			prepare_drawing
			create path.make
			if not points.is_empty then
				l_coord := 	points.item (points.lower)
				create l_point.make
				l_point.set_x (l_coord.x)
				l_point.set_y (l_coord.y)
				path.move_to_point_ (l_point)
				from
					i := points.lower + 1
				until
					i > points.upper
				loop
					l_coord := 	points.item (i)
					create l_point.make
					l_point.set_x (l_coord.x)
					l_point.set_y (l_coord.y)
					path.line_to_point_ (l_point)
					i := i + 1
				end
				l_coord := 	points.item (points.lower)
				create l_point.make
				l_point.set_x (l_coord.x)
				l_point.set_y (l_coord.y)
				path.line_to_point_ (l_point)
			end
			path.fill
			finish_drawing
		end

	fill_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL)
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians.
		do
		end

feature -- Implementation

	image: NS_IMAGE

feature {NONE} -- Implementation

	app_kit_additions: NS_APP_KIT_ADDITONS_CAT

feature {EV_ANY_HANDLER} -- Implementation

	is_flipped: BOOLEAN
		do
			Result := False
		end

	prepare_drawing
		local
			l_color: detachable EV_COLOR_IMP
			trans: NS_AFFINE_TRANSFORM
			gc: NS_GRAPHICS_CONTEXT
			gc_utils: NS_GRAPHICS_CONTEXT_UTILS
		do
			image.lock_focus
			if not is_flipped then
				create trans.make
				trans.translate_x_by__y_by_ (0.0, image.size.height)
				trans.scale_x_by__y_by_ (1.0, -1.0)
				app_kit_additions.concat (trans)
			end
			create gc_utils
			gc := gc_utils.current_context
			inspect drawing_mode
				when drawing_mode_and then
					-- NSCompositeSourceOver = 2
					gc.set_compositing_operation_ (2)
				when drawing_mode_copy then
					gc.set_compositing_operation_ (2)
				when drawing_mode_invert then
					gc.set_compositing_operation_ (2)
				when drawing_mode_or then
					gc.set_compositing_operation_ (2)
				when drawing_mode_xor then
					-- NSCompositeXOR = 10
					gc.set_compositing_operation_ (10)
			end
			l_color ?= foreground_color.implementation
			check l_color /= void end
			l_color.color.set
		end

	finish_drawing
		do
			image.unlock_focus
			-- update the view
			update_if_needed
		end

	internal_line_width: INTEGER

	internal_dashed_line_style: BOOLEAN

	internal_foreground_color: detachable EV_COLOR
			-- Color used to draw primitives.

	internal_background_color: detachable EV_COLOR
			-- Color used for erasing of canvas.
			-- Default: white.

	flush
			-- Force all queued expose events to be called.
		deferred
		end

	update_if_needed
			--
		deferred
		end

	internal_font_imp: detachable EV_FONT_IMP

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_DRAWABLE note option: stable attribute end;

end -- class EV_DRAWABLE_IMP
