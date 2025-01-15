note
	description: "[
						Pixmaps drawn on `point'.
	
					  p1 --------- p2
					  |............
					  |............
					  |............
					 p3
					 
					 point.x = p1.x and point.y = p1.y
					 
					 An alternative EV_MODEL_IMAGE exists using EV_PIXEL_BUFFER instead of EV_PIXMAP.

			]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "figure, picture, pixmap"
	date: "$Date$"
	revision: "$Revision$"
	see_also: "{EV_MODEL_IMAGE}"

class
	EV_MODEL_PICTURE

inherit
	EV_MODEL_ATOMIC
		redefine
			default_create,
			recursive_transform,
			default_line_width,
			border_width
		end

	EV_MODEL_SINGLE_POINTED
		undefine
			default_create,
			point_count
		end

	EV_SHARED_SCALE_FACTORY
		undefine
			default_create
		end

create
	default_create,
	make_with_point,
	make_with_pixel_buffer,
	make_with_identified_pixel_buffer,
	make_with_pixmap,
	make_with_identified_pixmap,
	make_with_position

feature {NONE} -- Initialization

	default_create
			-- Create in (0, 0)
		do
			Precursor {EV_MODEL_ATOMIC}
			pixmap_factory.register_pixmap (default_pixmap)
			id_pixmap := default_pixmap
			scaled_pixmap := pixmap
			is_default_pixmap_used := True
			create point_array.make_empty (3)
			point_array.extend (create {EV_COORDINATE}.make (0, 0))
			point_array.extend (create {EV_COORDINATE}.make (0, 0))
			point_array.extend (create {EV_COORDINATE}.make (0, 0))
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
			-- Create with `a_pixmap'.
		require
			a_pixmap_not_void: a_pixmap /= Void
		do
			default_create
			set_pixmap (a_pixmap)
		end

	make_with_identified_pixmap (an_id_pixmap: EV_IDENTIFIED_PIXMAP)
			-- Create with `an_id_pixmap'.
		require
			an_id_pixmap_not_void: an_id_pixmap /= Void
		do
			default_create
			set_identified_pixmap (an_id_pixmap)
		end

	make_with_pixel_buffer (a_pix: EV_PIXEL_BUFFER)
			-- Create with `a_pix'.
		require
			a_pix_not_void: a_pix /= Void
		do
			default_create
			set_pixel_buffer (a_pix)
		end

	make_with_identified_pixel_buffer (an_id_pixel_buffer: EV_IDENTIFIED_PIXEL_BUFFER)
			-- Create with `an_id_pixel_buffer'.
		require
			an_id_pixel_buffer_not_void: an_id_pixel_buffer /= Void
		do
			default_create
			set_identified_pixel_buffer (an_id_pixel_buffer)
		end

feature -- Access

	pixmap: detachable EV_PIXMAP
			-- Pixmap that is displayed.
		do
			if attached id_pixmap as id_pix then
				Result := id_pix.pixmap
			end
		end

	pixel_buffer: detachable EV_PIXEL_BUFFER
			-- Pixel buffer that is displayed.
		do
			if attached id_pixel_buffer as id_pix then
				Result := id_pix.pixel_buffer
			end
		end

	angle: DOUBLE = 0.0
			-- Since not rotatable

	point_x: INTEGER
			-- x position of `point'.
		do
			Result := point_array.item (0).x
		end

	point_y: INTEGER
			-- y position of `point'.
		do
			Result := point_array.item (0).y
		end

feature -- Status report

	width: INTEGER
			-- Width of pixmap.
		do
			Result := as_integer (point_array.item (1).x_precise - point_array.item (0).x_precise)
		end

	height: INTEGER
			-- Height of Pixmap.
		do
			Result := as_integer (point_array.item (2).y_precise - point_array.item (0).y_precise)
		end

	is_default_pixmap_used: BOOLEAN
			-- Is `Current' using a default pixmap?

	is_rotatable: BOOLEAN = False
			-- Is rotatable? (No)

	is_scalable: BOOLEAN = True
			-- Is scalable? (Yes)

	is_transformable: BOOLEAN = False
			-- Is transformable? (No)

feature -- Visitor

	project (a_projector: EV_MODEL_DRAWING_ROUTINES)
			-- <Precursor>
		do
			a_projector.draw_figure_picture (Current)
		end

feature -- Status setting

	set_pixmap (a_pixmap: EV_PIXMAP)
			-- Set `pixmap' to `a_pixmap'.
		require
			a_pixmap_not_void: a_pixmap /= Void
		do
			set_identified_pixmap (pixmap_factory.registered_pixmap (a_pixmap))
		ensure
			pixmap_assigned: pixmap = a_pixmap
		end

	set_identified_pixmap (an_id_pixmap: EV_IDENTIFIED_PIXMAP)
			-- Set `id_pixmap' to `an_id_pixmap' and initialize `scaled_pixmap'.
		require
			an_id_pixmap_not_void: an_id_pixmap /= Void
		local
			pix: EV_PIXMAP
		do
			id_pixmap := an_id_pixmap
			pix := an_id_pixmap.pixmap
			pixmap_factory.register_pixmap (an_id_pixmap)
			scaled_pixmap := pixmap
			is_default_pixmap_used := False
			point_array.item (1).set_x_precise (point_array.item (0).x_precise + pix.width)
			point_array.item (2).set_y_precise (point_array.item (0).y_precise + pix.height)
			invalidate
			center_invalidate
		ensure
			set: id_pixmap = an_id_pixmap
		end

	set_pixel_buffer (a_pixel_buffer: EV_PIXEL_BUFFER)
			-- Set `pixel_buffer' to `a_pixel_buffer'.
		require
			a_pixel_buffer_not_void: a_pixel_buffer /= Void
		do
			set_identified_pixel_buffer (pixel_buffer_factory.registered_pixel_buffer (a_pixel_buffer))
		ensure
			pixel_buffer_assigned: pixel_buffer = a_pixel_buffer
		end

	set_identified_pixel_buffer (an_id_pixel_buffer: EV_IDENTIFIED_PIXEL_BUFFER)
			-- Set `id_pixel_buffer' to `an_id_pixel_buffer' and initialize `scaled_pixel_buffer'.
		require
			an_id_pixel_buffer_not_void: an_id_pixel_buffer /= Void
		local
			pix: EV_PIXEL_BUFFER
		do
			id_pixel_buffer := an_id_pixel_buffer
			pix := an_id_pixel_buffer.pixel_buffer
			pixel_buffer_factory.register_pixel_buffer (an_id_pixel_buffer)
			scaled_pixel_buffer := pixel_buffer
			if is_default_pixmap_used then
				id_pixmap := Void
				is_default_pixmap_used := False
			end
			point_array.item (1).set_x_precise (point_array.item (0).x_precise + pix.width)
			point_array.item (2).set_y_precise (point_array.item (0).y_precise + pix.height)
			invalidate
			center_invalidate
		ensure
			set: id_pixel_buffer = an_id_pixel_buffer
		end

	set_point_position (ax, ay: INTEGER)
			-- Set position of `point' to `a_point'.
		local
			a_delta_x, a_delta_y: DOUBLE
			l_point_array: like point_array
			p0, p1, p2: EV_COORDINATE
		do
			l_point_array := point_array
			p0 := l_point_array.item (0)
			p1 := l_point_array.item (1)
			p2 := l_point_array.item (2)

			a_delta_x := ax - p0.x_precise
			a_delta_y := ay - p0.y_precise
			p0.set_precise (ax, ay)
			p1.set_precise (p1.x_precise + a_delta_x, p1.y_precise + a_delta_y)
			p2.set_precise (p2.x_precise + a_delta_x, p2.y_precise + a_delta_y)
			invalidate
			center_invalidate
		end

feature -- Events

	position_on_figure (a_x, a_y: INTEGER): BOOLEAN
			-- Is (`a_x', `a_y') on this figure?
		local
			ax, ay: DOUBLE
			p0: EV_COORDINATE
			l_point_array: like point_array
		do
			l_point_array := point_array
			p0 := l_point_array.item (0)
			ax := p0.x_precise
			ay := p0.y_precise
			Result := point_on_rectangle (a_x, a_y, ax, ay, l_point_array.item (1).x_precise, l_point_array.item (2).y_precise)
		end

feature {EV_MODEL_GROUP}

	recursive_transform (a_transformation: EV_MODEL_TRANSFORMATION)
			-- Same as transform but without precondition
			-- is_transformable and without invalidating
			-- groups center
		do
			Precursor {EV_MODEL_ATOMIC} (a_transformation)
			update_scaled_pixmap
		end

feature {EV_MODEL_DRAWER}

	scaled_pixmap: like pixmap
			-- Scaled version of `pixmap'.

	scaled_pixel_buffer: like pixel_buffer
			-- Scaled version of `pixel_buffer'.

feature {NONE} -- Implementation

	id_pixmap: detachable EV_IDENTIFIED_PIXMAP

	id_pixel_buffer: detachable EV_IDENTIFIED_PIXEL_BUFFER

	default_pixmap: EV_IDENTIFIED_PIXMAP
			-- Pixmap set by `default_create'.
		once
			Result := pixmap_factory.registered_pixmap (create {EV_PIXMAP})
			pixmap_factory.register_pixmap (Result)
		end

	set_center
			-- Set the center.
		local
			l_point_array: like point_array
			p0: EV_COORDINATE
		do
			l_point_array := point_array
			p0 := l_point_array.item (0)
			center.set_precise ((p0.x_precise + l_point_array.item (1).x_precise) / 2, (p0.y_precise + l_point_array.item (2).y_precise) / 2)
			is_center_valid := True
		end

	update_scaled_pixmap
			-- Scale `pixmap' store result in `scaled_pixmap'.
		do
			if attached scaled_pixmap as spix and attached id_pixmap as id_pix then
				if spix.width /= width or else spix.height /= height then
					scaled_pixmap := pixmap_factory.scaled_pixmap (id_pix, width.max (1), height.max (1))
				end
			end
			if attached scaled_pixel_buffer as spix and attached id_pixel_buffer as id_pix then
				if spix.width /= width or else spix.height /= height then
					scaled_pixel_buffer := pixel_buffer_factory.scaled_pixel_buffer (id_pix, width.max (1), height.max (1))
				end
			end
		end

	default_line_width: INTEGER = 0
		-- <Precursor>

	border_width: INTEGER = 0
		-- <Precursor>

invariant
	pixmap_exists: pixmap /= Void or pixel_buffer /= Void

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




end -- class EV_MODEL_PICTURE


