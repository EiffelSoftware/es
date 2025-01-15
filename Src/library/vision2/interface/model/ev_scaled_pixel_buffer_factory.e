note
	description: "[
			Objects that is a factory for scaled pixel_buffers.
			Reduces memory usage and speed up systems with only a few different pixel_buffers and a
			lot of EV_MODEL_PICTURE objects which uses this pixel_buffers and get uniformly scaled.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SCALED_PIXEL_BUFFER_FACTORY

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Create an EV_SCALED_PIXEL_BUFFER_FACTORY
		do
			create scaled_pixel_buffers.make_filled (Void, 1, max_table_size)
			create orginal_pixel_buffers.make_filled (Void, 1, max_table_size)
		end

feature -- Access

	registered_pixel_buffer (a_pixel_buffer: EV_PIXEL_BUFFER): EV_IDENTIFIED_PIXEL_BUFFER
			-- Return new identified font for `a_pixel_buffer'.
		require
			a_pixel_buffer_not_Void: a_pixel_buffer /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > max_table_size or else
				orginal_pixel_buffers.item (i) = Void or else
				orginal_pixel_buffers.item (i) = a_pixel_buffer
			loop
				i := i + 1
			end
			create Result.make_with_id (a_pixel_buffer, i)
		ensure
			result_not_Void: Result /= Void
		end

	scaled_pixel_buffer (an_id_pixel_buffer: EV_IDENTIFIED_PIXEL_BUFFER; a_width, a_height: INTEGER): EV_PIXEL_BUFFER
			-- `an_id_pixel_buffer' scaled to `a_height' and `a_width'.
		require
			an_id_pixel_buffer_not_Void: an_id_pixel_buffer /= Void
			a_hight_positive: a_height > 0
			a_width_positive: a_width > 0
		do
			if an_id_pixel_buffer.id > max_table_size then
				Result := scaled_pixel_buffer_internal (an_id_pixel_buffer.pixel_buffer, a_width, a_height)
			else
				check
					an_id_pixel_buffer_is_in_table: orginal_pixel_buffers.item (an_id_pixel_buffer.id) = an_id_pixel_buffer.pixel_buffer
				end
				Result := scaled_pixel_buffers.item (an_id_pixel_buffer.id)
				if not attached Result or else Result.height /= a_height or else Result.width /= a_width then
					Result := scaled_pixel_buffer_internal (an_id_pixel_buffer.pixel_buffer, a_width, a_height)
					scaled_pixel_buffers.put (Result, an_id_pixel_buffer.id)
				end
			end
		end

feature -- Element change

	register_pixel_buffer (an_id_pixel_buffer: EV_IDENTIFIED_PIXEL_BUFFER)
			-- Register `an_id_pixel_buffer' in the factory.
		local
			i: INTEGER
		do
			i := an_id_pixel_buffer.id
			if i <= max_table_size and then orginal_pixel_buffers.item (i) /= an_id_pixel_buffer.pixel_buffer then
				orginal_pixel_buffers.put (an_id_pixel_buffer.pixel_buffer, i)
			end
		end

feature {NONE} -- Implementation

	scaled_pixel_buffers: ARRAY [detachable EV_PIXEL_BUFFER]
			-- Table of scaled pixel_buffers.

	orginal_pixel_buffers: ARRAY [detachable EV_PIXEL_BUFFER]
			-- Table of orginal pixel_buffers for `scaled_pixel_buffers'.

	max_table_size: INTEGER = 200
			-- Maxmimum size of `scaled_pixel_buffers' and `orginal_pixel_buffers'.

	scaled_pixel_buffer_internal (a_pixel_buffer: EV_PIXEL_BUFFER; a_width, a_height: INTEGER): EV_PIXEL_BUFFER
			-- `a_font' scaled to `a_height'.
		require
			a_pixel_buffer_not_Void: a_pixel_buffer /= Void
			a_height_positive: a_height > 0
			a_width_positive: a_width > 0
		do
			if a_pixel_buffer.height = a_height and then a_pixel_buffer.width = a_width then
				Result := a_pixel_buffer
			else
				Result := a_pixel_buffer.stretched (a_width, a_height)
			end
		ensure
			Result_not_Void: Result /= Void
		end

invariant
	scaled_pixel_buffers_not_Void: scaled_pixel_buffers /= Void
	orginal_pixel_buffers_not_Void: orginal_pixel_buffers /= Void

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

end
