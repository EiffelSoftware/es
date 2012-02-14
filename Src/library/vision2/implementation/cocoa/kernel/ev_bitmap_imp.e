note
	description: "EiffelVision Bitmap. Cocoa implementation"
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_BITMAP_IMP

inherit
	EV_BITMAP_I
		redefine
			interface
		end

	EV_DRAWABLE_IMP
		redefine
			interface,
			make
		end

create
	make

feature -- Initialization

	make
			-- Set up action sequence connections and create graphics context.
		do
			Precursor {EV_DRAWABLE_IMP}
			set_default_colors
			set_is_initialized (True)
		end

feature -- Status Setting

	set_size (a_width, a_height: INTEGER)
			-- Set the size of the pixmap to `a_width' by `a_height'.
		local
			l_size: NS_SIZE
		do
			create l_size.make
			l_size.set_width (a_width)
			l_size.set_height (a_height)
			image.set_size_ (l_size)
		end

feature -- Access

	width: INTEGER
		-- Width in pixels of mask bitmap.
		do
			Result := image.size.width.rounded
		end

	height: INTEGER
		-- Width in pixels of mask bitmap.
		do
			Result := image.size.height.rounded
		end

feature {NONE} -- Implementation

	redraw
			-- Redraw the entire area.
		do
			-- Not needed for masking implementation.
		end

	set_default_colors
			-- Set foreground and background color to their default values.
		do
			if attached {EV_COLOR_IMP} background_color.implementation as l_color then
				image.set_background_color_ (l_color.color)
			end
		end

	destroy
		do
			set_is_destroyed (True)
		end

	dispose
			-- Cleanup
		do
		end

	flush
			-- Force all queued draw to be called.
		do
		end

	update_if_needed
			-- Update `Current' if needed.
		do
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_BITMAP note option: stable attribute end;

end -- class EV_BITMAP_IMP
