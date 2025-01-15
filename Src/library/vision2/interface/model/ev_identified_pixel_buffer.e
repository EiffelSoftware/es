note
	description: "Objects that is a pixel buffer with an id."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_IDENTIFIED_PIXEL_BUFFER
	
create
	make_with_id
	
feature {NONE} -- Initialisation

	make_with_id (a_pixbuf: like pixel_buffer; an_id: like id)
			-- Create an EV_IDENTIFIED_PIXEL_BUFFER containing `a_pixbuf' with `an_id'.
		require
			a_pixbuf_not_void: a_pixbuf /= Void
			an_id_positive: an_id > 0
		do
			pixel_buffer := a_pixbuf
			id := an_id
		ensure
			set: pixel_buffer = a_pixbuf and id = an_id
		end

feature -- Access

	pixel_buffer: EV_PIXEL_BUFFER
		-- Font
	
	id: INTEGER
		-- id for `pixel_buffer'.
	
invariant
	pixel_buffer_not_void: pixel_buffer /= Void
	id_positive: id >= 0

note
	copyright:	"Copyright (c) 1984-2025, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_IDENTIFIED_PIXMAP

