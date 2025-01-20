note
	description: "EiffelVision SVG content. Implementation interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "screen, root, window, visual, top"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_DRAWABLE_TO_SVG_I

inherit
	EV_DRAWABLE_I
		redefine
			interface,
			draw_pixel_buffer
		end

create
	make

feature {EV_ANY} -- Initialization

	old_make (an_interface: attached like interface)
			-- Create `Current', a screen object.
		do
			assign_interface (an_interface)
		end

	make
			-- Initialize `Current'
		do
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	destroy
			-- Destroy underlying native toolkit objects.
			-- Render `Current' unusable.
			-- Any feature calls after a call to destroy are
			-- invalid.
		do
			set_is_initialized (True)
		end

feature {NONE} -- Implementation

	foreground_color_internal: detachable EV_COLOR
			-- Color of foreground features like text.


	background_color_internal: detachable EV_COLOR
			-- Color displayed behind foreground features.

	font_internal: detachable EV_FONT

feature -- Element change

	set_foreground_color (a_color: like foreground_color)
			-- Assign `a_color' to `foreground_color'.
		do
			foreground_color_internal := a_color
		end

	set_background_color (a_color: like background_color)
			-- Assign `a_color' to `foreground_color'.
		do
			background_color_internal := a_color
		end

	set_default_colors
			-- Set foreground and background color to their default values.
		do
			-- FIXME
			foreground_color_internal := Void
			background_color_internal := Void
		end


feature -- Access

	font: EV_FONT
			-- Typeface appearance for `Current'.
		do
			Result := font_internal
			if Result = Void then
				create Result
				font_internal := Result
			end
		end

feature -- Element change

	set_font (a_font: EV_FONT)
			-- Assign `a_font' to `font'.
		do
			font_internal := a_font
		end

feature -- Access

	width: INTEGER
			-- Horizontal size in pixels.
		do
			Result := attached_interface.internal_width
		end

	height: INTEGER
		-- Vertical size in pixels.
		do
			Result := attached_interface.internal_height
		end

	line_width: INTEGER
			-- Line thickness.

	drawing_mode: INTEGER
			-- Logical operation on pixels when drawing.

	clip_area: detachable EV_RECTANGLE
			-- Clip area used to clip drawing.
			-- If set to Void, no clipping is applied.

	tile: detachable EV_PIXMAP
			-- Pixmap that is used to instead of background_color.
			-- If set to Void, `background_color' is used to fill.

	dashed_line_style: BOOLEAN
			-- Are lines drawn dashed?

feature -- Duplication

	sub_pixmap (area: EV_RECTANGLE): EV_PIXMAP
			-- Pixmap region of `Current' represented by rectangle `area'
		do
			create Result  -- FIXME
			check False end
		end

feature -- Element change

	set_line_width (a_width: INTEGER)
			-- Assign `a_width' to `line_width'.
		do
			line_width := a_width
		end

	set_drawing_mode (a_mode: INTEGER)
			-- Set drawing mode to `a_logical_mode'.
		do
			drawing_mode := a_mode
		end

	set_clip_area (an_area: EV_RECTANGLE)
			-- Set area which will be refreshed.
		do
			clip_area := an_area
		end

	set_clip_region (a_region: EV_REGION)
			-- Set region which will be refreshed.
		do
			-- FIXME
		end

	remove_clipping
			-- Do not apply any clipping.
		do
			-- FIXME
		end

	set_tile (a_pixmap: EV_PIXMAP)
			-- Set tile used to fill figures.
			-- Set to Void to use `background_color' to fill.
		do
			check implemented: False end
		end

	remove_tile
			-- Do not apply a tile when filling.
		do
			tile := Void
		end

	enable_dashed_line_style
			-- Draw lines dashed.
		do
			dashed_line_style := True
		end

	disable_dashed_line_style
			-- Draw lines solid.
		do
			dashed_line_style := False
		end

	set_anti_aliasing (value: BOOLEAN)
			-- Enable (if `value`) or disable (if `not value`) anti-aliasing (if supported) when drawing.
		do
		end

feature -- Clearing and drawing operations

	redraw
			-- Force `Current' to redraw itself.
		do
			check implemented: False end
		end

	clear
			-- Erase `Current' with `background_color'.
		do
			check implemented: False end
		end

	clear_rectangle (x1, y1, a_width, a_height: INTEGER)
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height' in `background_color'.
		do
			check implemented: False end
		end

feature -- Drawing operations

	draw_point (x, y: INTEGER)
			-- Draw point at (`x', 'y').
		do
			check implemented: False end
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
			check implemented: False end
		end

	draw_rotated_text (x, y: INTEGER; angle: REAL a_text: READABLE_STRING_GENERAL)
			-- Draw rotated text `a_text' with left of baseline at (`x', `y') using `font'.
			-- Rotation is number of radians counter-clockwise from horizontal plane.
		do
			check implemented: False end
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		local
			o: like output
			h: INTEGER
		do
			o := output
			o.put_string ("<text")

			if attached font as ft then
				h := ft.height * (1 + a_text.occurrences ('%N'))
			end

			o.put_string (" x=%"")
			output_integer_value (x)
			o.put_string ("%"")

			o.put_string (" y=%"")
			output_integer_value (y + h)
			o.put_string ("%"")

			o.put_string (" style=%"")
			if attached font as ft then
				inspect ft.weight
				when {EV_FONT_CONSTANTS}.weight_bold then
					o.put_string ("font-weight:bold;")
				when {EV_FONT_CONSTANTS}.weight_thin then
					o.put_string ("font-weight:thin;")
				else
				end
				inspect ft.shape
				when {EV_FONT_CONSTANTS}.shape_italic then
					o.put_string ("font-style:italic;")
				else
				end
				o.put_string ("font-family:")
				o.put_string ({UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (ft.name))
				o.put_string (";")

				o.put_string ("font-size:")
				o.put_string ((text_size_factor * ft.height_in_points).out)
				o.put_string ("px;")
			end

			output_style_inside (True)

			o.put_string ("%"")

			o.put_string (">")
			o.put_string (xml_encoded_string (a_text)) --{UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (a_text))
			o.put_string ("</text>%N")
		end

	draw_ellipsed_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			-- TODO
			check implemented: False end
		end

	draw_ellipsed_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			-- TODO
			check implemented: False end
		end

	draw_segment (x1, y1, x2, y2: INTEGER)
			-- Draw line segment from (`x1', 'y1') to (`x2', 'y2').
		local
			o: like output
		do
			o := output
			o.put_string ("<line")

			o.put_string (" x1=%"")
			output_integer_value (x1)
			o.put_string ("%"")
			o.put_string (" y1=%"")
			output_integer_value (y1)
			o.put_string ("%"")

			o.put_string (" x2=%"")
			output_integer_value (x2)
			o.put_string ("%"")
			o.put_string (" y2=%"")
			output_integer_value (y2)
			o.put_string ("%"")

			o.put_string (" style=%"stroke-linecap:square;")

			output_style_inside (False)

			o.put_string ("%"")
			o.put_string ("/>%N")
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
			-- Draw `a_pixmap' with upper-left corner on (`x', 'y').
		local
			b64: BASE64
			s: STRING_8
			o: like output
			t: FILE
			mp: MANAGED_POINTER
		do
			t := new_temporary_file
			t.close
			a_pixmap.save_to_named_path (create {EV_PNG_FORMAT}, t.path)

			create mp.make (t.count)
			t.open_read
			t.read_to_managed_pointer (mp, 0, mp.count)
			t.close
			safe_delete (t)

			if attached mp.read_special_natural_8 (0, mp.count) as spec then
				create b64
				s := b64.bytes_encoded_string (spec)
			end

			if s /= Void and then not s.is_empty then
				o := output
				o.put_string ("<image ")

				o.put_string (" width=%"")
				output_integer_value (a_pixmap.width)
				o.put_string ("%"")

				o.put_string (" height=%"")
				output_integer_value (a_pixmap.height)
				o.put_string ("%"")

				o.put_string (" xlink:href=%"data:image/png;base64,")
				o.put_string (s)
				o.put_string ("%"")

				o.put_string (" x=%"")
				output_integer_value (x)
				o.put_string ("%"")

				o.put_string (" y=%"")
				output_integer_value (y)
				o.put_string ("%"")

				o.put_string (" style=%"")

				output_style_inside (False)

				o.put_string ("paint-order:stroke fill markers%"")
				o.put_string ("/>%N")

			end
		end

	draw_pixel_buffer (x, y: INTEGER; a_pixel_buffer: EV_PIXEL_BUFFER)
			-- Draw `a_pixel_buffer' with upper-left corner on (`x', `y').
		local
			b64: BASE64
			s: STRING_8
			o: like output
			t: FILE
			mp: MANAGED_POINTER
		do
			t := new_temporary_file
			t.close
			a_pixel_buffer.save_to_named_path (t.path)


			create mp.make (t.count)
			t.open_read
			t.read_to_managed_pointer (mp, 0, mp.count)
			t.close
			safe_delete (t)
			if attached mp.read_special_natural_8 (0, mp.count) as spec then
				create b64
				s := b64.bytes_encoded_string (spec)
			end

			if s /= Void and then not s.is_empty then
				o := output
				o.put_string ("<image ")

				o.put_string (" width=%"")
				output_integer_value (a_pixel_buffer.width)
				o.put_string ("%"")

				o.put_string (" height=%"")
				output_integer_value (a_pixel_buffer.height)
				o.put_string ("%"")

				o.put_string (" xlink:href=%"data:image/png;base64,")
				o.put_string (s)
				o.put_string ("%"")

				o.put_string (" x=%"")
				output_integer_value (x)
				o.put_string ("%"")

				o.put_string (" y=%"")
				output_integer_value (y)
				o.put_string ("%"")

				o.put_string (" style=%"")

				output_style_inside (False)

				o.put_string ("paint-order:stroke fill markers%"")
				o.put_string ("/>%N")

			end
		end

	draw_sub_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; area: EV_RECTANGLE)
			-- Draw `area' of `a_pixmap' with upper-left corner on (`x', `y').
		do
				-- TODO: optimize?
			draw_pixmap (x, y, a_pixmap.sub_pixmap (area))
		end

	draw_sub_pixel_buffer (x, y: INTEGER; a_pixel_buffer: EV_PIXEL_BUFFER; area: EV_RECTANGLE)
			-- Draw `area' of `a_pixel_buffer' with upper-left corner on (`x', `y').
		do
				-- TODO: optimize?
			draw_pixel_buffer (x, y, a_pixel_buffer.sub_pixel_buffer (area))
		end

	draw_arc (x, y, a_bounding_width, a_bounding_height: INTEGER;
		a_start_angle, an_aperture: REAL)
			-- Draw a part of an ellipse defined by a rectangular area with an
			-- upper left corner at `x',`y', width `a_bounding_width' and height
			-- `a_bounding_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- Angles are measured in radians.
		local
			o: like output
			l_starting_point, l_ending_point: EV_COORDINATE
			cx, cy: REAL_64
			d: STRING
		do
			-- FIXME: works only for a_bounding_width = a_bounding_height
			o := output
			cx := (x + (a_bounding_width / 2))
			cy := (y + (a_bounding_height / 2))
			l_starting_point := polar_to_cartesian_coordinate (cx, cy, a_bounding_width / 2, a_start_angle)
			l_ending_point := polar_to_cartesian_coordinate (cx, cy, a_bounding_width / 2, a_start_angle + an_aperture)

--			draw_rectangle (x, y, a_bounding_width, a_bounding_height)
--			o.put_string ("<circle cx=%""+x.out+"%" cy=%""+ y.out+"%" r=%"3%" fill=%"#000%"/>")
--			o.put_string ("<circle cx=%""+cx.out+"%" cy=%""+ cy.out+"%" r=%"3%" fill=%"green%"/>")
--			o.put_string ("<circle cx=%""+l_starting_point.x.out+"%" cy=%""+l_starting_point.y.out+"%" r=%"3%" fill=%"blue%"/>")
--			o.put_string ("<circle cx=%""+l_ending_point.x.out+"%" cy=%""+l_ending_point.y.out+"%" r=%"3%"  fill=%"red%"/>")

			create d.make_empty

			d.append ("M ")
			d.append (real_to_string (l_starting_point.x_precise))
			d.append (",")
			d.append (real_to_string (l_starting_point.y_precise))

			d.append (" A ")
			d.append (real_to_string (a_bounding_width / 2))
			d.append (" ")
			d.append (real_to_string (a_bounding_height / 2))
			d.append (" 0")
			if an_aperture > pi / 2 then
				d.append (" 0")
			else
				d.append (" 1")
			end
			d.append (" 0")
			d.append (" ")
			d.append (real_to_string (l_ending_point.x_precise))
			d.append (",")
			d.append (real_to_string (l_ending_point.y_precise))

			o.put_string ("<path")

			o.put_string (" d=%"")
			o.put_string (d)
			o.put_string ("%"")


			o.put_string (" style=%"")

			output_style_inside (False)

			o.put_string ("%"/>%N")
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
			-- Draw rectangle with upper-left corner on (`x', 'y')
			-- with size `a_width' and `a_height'.
		local
			o: like output
		do
			o := output
			o.put_string ("<polyline")

			o.put_string (" points=%"")

			o.put_string (x.out); o.put_character (','); o.put_string (y.out); o.put_character (' ')
			o.put_string ((x + a_width).out); o.put_character (','); o.put_string (y.out); o.put_character (' ')
			o.put_string ((x + a_width).out); o.put_character (','); o.put_string ((y + a_height).out); o.put_character (' ')
			o.put_string (x.out); o.put_character (','); o.put_string ((y + a_height).out); o.put_character (' ')
			o.put_string (x.out); o.put_character (','); o.put_string (y.out); o.put_character (' ')

			o.put_string ("%"")

			o.put_string (" style=%"stroke-linecap:square;")

			output_style_inside (False)

			o.put_string ("%"")
			o.put_string ("/>%N")
		end

	draw_ellipse (x, y, a_bounding_width, a_bounding_height: INTEGER)
			-- Draw an ellipse defined by a rectangular area with an
			-- upper left corner at `x',`y', width `a_bounding_width' and height
			-- `a_bounding_height'.
		local
			o: like output
		do
			o := output
			o.put_string ("<ellipse")

			o.put_string (" cx=%"")
			output_real_value (x + (a_bounding_width / 2))
			o.put_string ("%"")

			o.put_string (" cy=%"")
			output_real_value (y + (a_bounding_height / 2))
			o.put_string ("%"")

			o.put_string (" rx=%"")
			output_real_value (a_bounding_width / 2)
			o.put_string ("%"")

			o.put_string (" ry=%"")
			output_real_value (a_bounding_height / 2)
			o.put_string ("%"")

			o.put_string (" style=%"")

			output_style_inside (False)

			o.put_string ("paint-order:stroke fill markers%"")
			o.put_string ("/>%N")
		end

	draw_polyline (points: ARRAY [EV_COORDINATE]; is_closed: BOOLEAN)
			-- Draw line segments between subsequent points in
			-- `points'. If `is_closed' draw line segment between first
			-- and last point in `points'.
		local
			o: like output
			i, n: INTEGER
			l_is_using_path: BOOLEAN
		do
			o := output
			l_is_using_path := False
			if l_is_using_path then
				o.put_string ("<path d=%"M ")
				from
					i := 1
					n := points.count
				until
					i > n
				loop
					if i > 1 then
						o.put_character (' ')
						o.put_character ('L')
						o.put_character (' ')
					end
					o.put_string (real_to_string (points [i].x_precise))
					o.put_character (',')
					o.put_string (real_to_string (points [i].y_precise))
					i := i + 1
				end
				if is_closed then
					o.put_character ('z')
				end
				o.put_string ("%"")
			else
				o.put_string ("<polyline  points=%"")
				from
					i := 1
					n := points.count
				until
					i > n
				loop
					o.put_string (real_to_string (points [i].x_precise))
					o.put_character (',')
					o.put_string (real_to_string (points [i].y_precise))
					o.put_character (' ')
					i := i + 1
				end
				if is_closed then
					o.put_string (real_to_string (points [1].x_precise))
					o.put_character (',')
					o.put_string (real_to_string (points [1].y_precise))
				end
				o.put_string ("%"")
			end

			o.put_string (" style=%"stroke-linecap:square;")

			output_style_inside (False)

			o.put_string ("%"")
			o.put_string ("/>%N")
		end

	draw_pie_slice (x, y, a_bounding_width, a_bounding_height: INTEGER;
	a_start_angle, an_aperture: REAL)
			-- Draw part of an ellipse defined by a rectangular area with an
			-- upper left corner at `x',`y', width `a_bounding_width' and height
			-- `a_bounding_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', 'y').
			-- Angles are measured in radians.
		do
			check implemented: False end
		end

feature -- Drawing operations (filled)

	fill_rectangle (x, y, a_width, a_height: INTEGER)
			-- Draw rectangle with upper-left corner on (`x', 'y')
			-- with size `a_width' and `a_height'. Fill with `background_color'.
		local
			o: like output
		do
			o := output
			o.put_string ("<polyline")

			o.put_string (" points=%"")

			o.put_string (x.out); o.put_character (','); o.put_string (y.out); o.put_character (' ')
			o.put_string ((x + a_width).out); o.put_character (','); o.put_string (y.out); o.put_character (' ')
			o.put_string ((x + a_width).out); o.put_character (','); o.put_string ((y + a_height).out); o.put_character (' ')
			o.put_string (x.out); o.put_character (','); o.put_string ((y + a_height).out); o.put_character (' ')
			o.put_string (x.out); o.put_character (','); o.put_string (y.out); o.put_character (' ')

			o.put_string ("%"")

			o.put_string (" style=%"")

			output_style_inside (True)

			o.put_string ("%"")
			o.put_string ("/>%N")
		end

	fill_ellipse (x, y, a_bounding_width, a_bounding_height: INTEGER)
			-- Fill an ellipse defined by a rectangular area with an
			-- upper left corner at `x',`y', width `a_bounding_width' and height
			-- `a_bounding_height'.
		local
			o: like output
		do
			o := output
			o.put_string ("<ellipse")

			o.put_string (" cx=%"")
			output_real_value (x + (a_bounding_width / 2))
			o.put_string ("%"")

			o.put_string (" cy=%"")
			output_real_value (y + (a_bounding_height / 2))
			o.put_string ("%"")

			o.put_string (" rx=%"")
			output_real_value (a_bounding_width / 2)
			o.put_string ("%"")

			o.put_string (" ry=%"")
			output_real_value (a_bounding_height / 2)
			o.put_string ("%"")

			o.put_string (" style=%"")
			output_style_inside (True)
			o.put_string ("paint-order:stroke fill markers%"")
			o.put_string ("/>%N")
		end

	fill_polygon (points: ARRAY [EV_COORDINATE])
			-- Draw line segments between subsequent points in `points'.
			-- Fill with `background_color'.
		local
			o: like output
			i, n: INTEGER
		do
			o := output
			o.put_string ("<polyline")

			o.put_string (" points=%"")

			from
				i := 1
				n := points.count
			until
				i > n
			loop
				o.put_string (real_to_string (points [i].x_precise))
				o.put_character (',')
				o.put_string (real_to_string (points [i].y_precise))
				o.put_character (' ')
				i := i + 1
			end
			o.put_string ("%"")

			o.put_string (" style=%"")
			output_style_inside (True)
			o.put_string ("%"")
			o.put_string ("/>%N")
		end

	fill_pie_slice (x, y, a_bounding_width, a_bounding_height: INTEGER;
	a_start_angle, an_aperture: REAL)
			-- Fill part of an ellipse defined by a rectangular area with an
			-- upper left corner at `x',`y', width `a_bounding_width' and height
			-- `a_bounding_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', 'y').
			-- Angles are measured in radians.
		do
			-- TODO
			check implemented: False end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	new_temporary_file: FILE
		local
			p: PATH
		do
			p := {EXECUTION_ENVIRONMENT}.temporary_directory_path
			if p = Void then
				create p.make_current
			end
			p := p.extended (".tmp-img-svg-")
			create {RAW_FILE} Result.make_open_temporary_with_prefix (p.name)
		end

	safe_delete (f: FILE)
		local
			retried: BOOLEAN
		do
			if not retried then
				f.delete
			end
		rescue
			retried := True
			retry
		end

	text_size_factor: INTEGER = 2

	output_style_inside (is_filled: BOOLEAN)
		local
			o: like output
		do
			o := output
			if is_filled then
				if attached foreground_color as col then
					o.put_string ("fill:")
					output_color (col)
					o.put_string (";")
				else
					o.put_string ("fill:none;")
				end
				o.put_string ("stroke:none;")
			else
				o.put_string ("fill:none;")
				if attached foreground_color as col then
					o.put_string ("stroke:")
					output_color (col)
					o.put_string (";")
				else
					o.put_string ("stroke:none;")
				end
			end
			if line_width > 0 and line_width /= 1 then
				o.put_string ("stroke-width:"+ line_width.out +";")
			end
		end

	output_integer_value (i: INTEGER)
		do
			attached_interface.output.put_string (i.out)
		end

	output_real_value (r: REAL_64)
		do
			attached_interface.output.put_string (real_to_string (r))
		end

	real_to_string (r: REAL_64): STRING
		do
			Result := real_format.formatted (r)
			if Result.ends_with (".0") then
				Result.remove_tail (2)
--			elseif Result.index_of ('.', 1) > 0 then
--				Result.keep_head (Result.index_of ('.', 1) - 1)
			end
		end

	output_color (c: EV_COLOR)
		local
			o: like output
		do
			o := output
			o.put_character ('#')
			o.put_string (c.red_8_bit.to_natural_8.to_hex_string.as_lower)
			o.put_string (c.green_8_bit.to_natural_8.to_hex_string.as_lower)
			o.put_string (c.blue_8_bit.to_natural_8.to_hex_string.as_lower)
		end

	output: FILE
		do
			Result := attached_interface.output
		end

	polar_to_cartesian_coordinate (cx, cy: REAL_64; r: REAL_64; a_angle: REAL): EV_COORDINATE
		local
			x,y: REAL_64
		do
			x := cx + r * {SINGLE_MATH}.cosine (a_angle)
			y := cy - r * {SINGLE_MATH}.sine (a_angle)
			create Result.make_precise (x, y)
		end

	xml_encoded_string (s: READABLE_STRING_GENERAL): STRING_8
			-- `s' converted to ASCII string_8, by escaping some character with XML entities.
		local
			i, n: INTEGER
			l_code: NATURAL_32
			c: CHARACTER_8
		do
			create Result.make (s.count + s.count // 10)
			n := s.count
			from i := 1 until i > n loop
				l_code := s.code (i)
				if l_code <= {CHARACTER_8}.max_ascii_value.to_natural_32 then
					c := l_code.to_character_8
					inspect c
					when '%"' then Result.append_string ("&quot;")
					when '&' then Result.append_string ("&amp;")
					when '%'' then Result.append_string ("&apos;")
					when '<' then Result.append_string ("&lt;")
					when '>' then Result.append_string ("&gt;")
					else
						Result.append_character (c)
					end
				else
					Result.append_character ('&')
					Result.append_character ('#')
					Result.append_natural_32 (l_code)
					Result.append_character (';')
				end
				i := i + 1
			end
		end

	real_format: FORMAT_DOUBLE
		once
			create Result.make (1, 4)
			Result.hide_trailing_zeros
		end

	interface: detachable ES_DRAWABLE_TO_SVG note option: stable attribute end;

note
	copyright:	"Copyright (c) 1984-2025, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class EV_SVG_I











