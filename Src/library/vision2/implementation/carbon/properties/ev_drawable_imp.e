indexing
	description: "EiffelVision drawable. GTK implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
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
		undefine
			copy,
			default_create
		end

	PLATFORM
		undefine
			copy,
			default_create
		end

	MATH_CONST
	HIVIEW_FUNCTIONS_EXTERNAL
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CONTROLS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL
	CARBONEVENTSCORE_FUNCTIONS_EXTERNAL



feature {NONE} -- Initialization

	initialize is
			-- Initialize `Current'
		do



		end

	init_default_values is
			-- Set default values. Call during initialization.
		do
		end

feature {EV_DRAWABLE_IMP} -- Implementation

	pix_to_draw: POINTER

	gc: POINTER
			-- Pointer to GdkGC struct.
			-- The graphics context applied to the primitives.
			-- Line style, width, colors, etc. are defined in here.

	gcvalues: POINTER
			-- Pointer to GdkGCValues struct.
			-- Is allocated during creation but has to be updated
			-- every time it is accessed.

	drawable: POINTER is
			-- Pointer to the GdkWindow of `c_object'.
		deferred
		end

	mask: POINTER is
			-- Pointer to the mask used by `Current'
		deferred
		end

	line_style: INTEGER
			-- Dash-style used when drawing lines.

	cap_style: INTEGER is
			-- Style used for drawing end of lines.
		do
		end

	join_style: INTEGER is
			-- Way in which lines are joined together.				
		do
		end

	gc_clip_area: EV_RECTANGLE
			-- Clip area currently used by `gc'.

	height: INTEGER is
			-- Needed by `draw_straight_line'.
		deferred
		end

	width: INTEGER is
			-- Needed by `draw_straight_line'.
		deferred
		end

feature -- Access

	font: EV_FONT is
			-- Font used for drawing text.
		do
		end

	foreground_color: EV_COLOR is
			-- Color used to draw primitives.
		do
		end

	background_color: EV_COLOR is
			-- Color used for erasing of canvas.
			-- Default: white.
		do
		end

	line_width: INTEGER is
			-- Line thickness.
		do
		end

	drawing_mode: INTEGER is
			-- Logical operation on pixels when drawing.
		do
		end

	clip_area: EV_RECTANGLE is
			-- Clip area used to clip drawing.
			-- If set to Void, no clipping is applied.
		do
		end

	tile: EV_PIXMAP
			-- Pixmap that is used to fill instead of background_color.
			-- If set to Void, `background_color' is used to fill.

	dashed_line_style: BOOLEAN is
			-- Are lines drawn dashed?
		do
		end

feature -- Element change

	set_font (a_font: EV_FONT) is
			-- Set `font' to `a_font'.
		do
		end

	set_background_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `background_color'.
		do
		end

	set_foreground_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `foreground_color'
		do
		end

	set_line_width (a_width: INTEGER) is
			-- Assign `a_width' to `line_width'.
		do
		end

	set_drawing_mode (a_mode: INTEGER) is
			-- Set drawing mode to `a_mode'.
		do
		end

	set_clip_area (an_area: EV_RECTANGLE) is
			-- Set an area to clip to.
		do
		end

	remove_clip_area is
			-- Do not apply any clipping.
		do
		end

	set_tile (a_pixmap: EV_PIXMAP) is
			-- Set tile used to fill figures.
			-- Set to Void to use `background_color' to fill.
		do
		end

	remove_tile is
			-- Do not apply a tile when filling.
		do
		end

	enable_dashed_line_style is
			-- Draw lines dashed.
		do
		end

	disable_dashed_line_style is
			-- Draw lines solid.
		do
		end

feature -- Clearing operations

	clear is
			-- Erase `Current' with `background_color'.
		do
		end

	clear_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Erase rectangle specified with `background_color'.
		do
		end

feature -- Drawing operations

	draw_point (x, y: INTEGER) is
			-- Draw point at (`x', `y').
		do
		end

	draw_text (x, y: INTEGER; a_text: STRING_GENERAL) is
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
		end

	draw_rotated_text (x, y: INTEGER; angle: REAL; a_text: STRING_GENERAL) is
			-- Draw rotated text `a_text' with left of baseline at (`x', `y') using `font'.
			-- Rotation is number of radians counter-clockwise from horizontal plane.
		do
		end

	draw_ellipsed_text (x, y: INTEGER; a_text: STRING_GENERAL; clipping_width: INTEGER) is
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
		end

	draw_ellipsed_text_top_left (x, y: INTEGER; a_text: STRING_GENERAL; clipping_width: INTEGER) is
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
		end

	draw_text_top_left (x, y: INTEGER; a_text: STRING_GENERAL) is
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		do
		end

	draw_text_internal (x, y: INTEGER; a_text: STRING_GENERAL; draw_from_baseline: BOOLEAN; a_width: INTEGER; a_angle: REAL) is
			-- Draw `a_text' at (`x', `y') using `font'.
		do
		end

	draw_segment (x1, y1, x2, y2: INTEGER) is
			-- Draw line segment from (`x1', 'y1') to (`x2', 'y2').
		do
		end

	draw_arc (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- Angles are measured in radians.
		do
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP) is
			-- Draw `a_pixmap' with upper-left corner on (`x', `y').
		local
			image_ref, url, provider : POINTER
			a_file_name, a_dir : C_STRING
			ret : INTEGER
			c_point, a_point : CGPOINT_STRUCT
			c_size, a_size : CGSIZE_STRUCT
			c_rect, a_rect : CGRECT_STRUCT
			a_imp : EV_PIXMAP_IMP
			c_imp: EV_WIDGET_IMP
			target,  event_ptr, null: POINTER
			event: OPAQUE_EVENT_REF_STRUCT
		do

        			c_imp ?= current
        			if c_imp /=void then
						ret := hiview_set_drawing_enabled_external (c_imp.c_object, 1)
						create c_rect.make_new_unshared
						ret := hiview_get_frame_external (c_imp.c_object, c_rect.item)

						create c_size.make_shared (c_rect.size.item)
						create c_point.make_shared(c_rect.origin.item)

						create a_rect.make_new_unshared
						create a_point.make_new_unshared
						create a_size.make_new_unshared
						a_point.set_x (c_point.x + x)
						a_point.set_y (c_point.y + y)
						a_size.set_height(a_pixmap.height)
						a_size.set_width (a_pixmap.width)
						a_rect.set_origin (a_point.item)
						a_rect.set_size (a_size.item)

						a_imp ?= a_pixmap.implementation
						if a_imp /= void then
							pix_to_draw := a_imp.drawable
							target := get_control_event_target_external(c_imp.c_object)
							create event.make_new_unshared
							event_ptr := event.item
							ret := create_event_external (null, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventControlDraw, 0, kEventAttributeUserEvent, $event_ptr)
							--kEventAttributeUserEvent
							ret :=  send_event_to_event_target_external (event.item, target)
							io.put_string("%N send  Event and ret: " + ret.out)
						--	ret := hiview_draw_cgimage_external (c_imp.c_object, a_rect.item ,a_imp.image_ptr)
						end

        			end
        		end

       frozen kEventAttributeUserEvent: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kEventAttributeUserEvent"
	end

       draw (a_inevent: POINTER) is
       		-- executet by the eventhandler to draw into context
        local
        	ret: INTEGER
        	context: CGCONTEXT_STRUCT
        	null: POINTER
        do
        	create context.make_new_unshared
        	ret := get_event_parameter_external (a_inevent, {carbonevents_anon_enums}.kEventParamCGContextRef,  {carbonevents_anon_enums}.typeCGContextRef, null, 4, null, context.item)
        	io.put_string("%N callback and ret: " + ret.out)
        end



	draw_full_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; x_src, y_src, src_width, src_height: INTEGER) is
		do
		end

	sub_pixmap (area: EV_RECTANGLE): EV_PIXMAP is
			-- Pixmap region of `Current' represented by rectangle `area'
		do
		end

	draw_sub_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; area: EV_RECTANGLE) is
			-- Draw `area' of `a_pixmap' with upper-left corner on (`x', `y').
		do
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'.
		do
		end

	draw_ellipse (x, y, a_width, a_height: INTEGER) is
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
		do
		end

	draw_polyline (points: ARRAY [EV_COORDINATE]; is_closed: BOOLEAN) is
			-- Draw line segments between subsequent points in
			-- `points'. If `is_closed' draw line segment between first
			-- and last point in `points'.
		do
		end

	draw_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians
		do
		end

feature -- filling operations

	fill_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'. Fill with `background_color'.
		do
		end

	fill_ellipse (x, y, a_width, a_height: INTEGER) is
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Fill with `background_color'.
		do
		end

	fill_polygon (points: ARRAY [EV_COORDINATE]) is
			-- Draw line segments between subsequent points in `points'.
			-- Fill all enclosed area's with `background_color'.
		do
		end

	fill_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians.
		do
		end

feature {NONE} -- Implemention

	coord_array_to_gdkpoint_array (pts: ARRAY [EV_COORDINATE]): ARRAY [INTEGER] is
			-- Low-level conversion.
		require
			pts_exists: pts /= Void
		do
		ensure
			Result_exists: Result /= Void
			same_size: pts.count = Result.count / 2
		end

feature {EV_GTK_DEPENDENT_APPLICATION_IMP, EV_ANY_I} -- Implementation

	pixbuf_from_drawable: POINTER is
			-- Return a GdkPixbuf object from the current Gdkpixbuf structure
		do
		end

	pixbuf_from_drawable_at_position (src_x, src_y, dest_x, dest_y, a_width, a_height: INTEGER): POINTER is
			-- Return a GdkPixbuf object from the current Gdkpixbuf structure
		do
		end

	pixbuf_from_drawable_with_size (a_width, a_height: INTEGER): POINTER is
			-- Return a GdkPixbuf object from the current Gdkpixbuf structure with dimensions `a_width' * `a_height'
		do
		end

feature {NONE} -- Implementation

	draw_mask_on_pixbuf (a_pixbuf_ptr, a_mask_ptr: POINTER) is
		do
		end

	app_implementation: EV_APPLICATION_IMP is
			-- Return the instance of EV_APPLICATION_IMP.
		deferred
		end

	internal_foreground_color: EV_COLOR
			-- Color used to draw primitives.

	internal_background_color: EV_COLOR
			-- Color used for erasing of canvas.
			-- Default: white.

	flush is
			-- Force all queued expose events to be called.
		deferred
		end

	update_if_needed is
			-- Force update of `Current' if needed
		deferred
		end

	whole_circle: INTEGER is 23040
		-- Number of 1/64 th degrees in a full circle (360 * 64)

	radians_to_gdk_angle: INTEGER is 3667 --
			-- Multiply radian by this to get no of (1/64) degree segments.

	internal_font_imp: EV_FONT_IMP

	interface: EV_DRAWABLE

	gdk_gc_unref (a_gc: POINTER) is
			-- void   gdk_gc_unref		  (GdkGC	    *gc);
		do
		end

	set_dashes_pattern (a_gc, dash_pattern: POINTER) is
			-- Set the dashes pattern for gc `a_gc', `dash_pattern' is a pointer to a two count gint8[]] denoting the pattern.
		do
		end

invariant
	gc_not_void: is_usable implies gc /= default_pointer

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_DRAWABLE_IMP

