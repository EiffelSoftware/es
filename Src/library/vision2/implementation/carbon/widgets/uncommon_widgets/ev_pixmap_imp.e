indexing
	description: "EiffelVision pixmap, GTK implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "drawable, primitives, figures, buffer, bitmap, picture"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_PIXMAP_IMP

inherit
	EV_PIXMAP_I
		redefine
			interface,
			flush,
			save_to_named_file
		end

	EV_DRAWABLE_IMP
		redefine
			interface,
			make,
			width,
			height,
			destroy,
			drawable
		end

	EV_PRIMITIVE_IMP
		undefine
			foreground_color,
			background_color,
			set_foreground_color,
			set_background_color,
			needs_event_box
		redefine
			interface,
			width,
			height,
			destroy,
			dispose,
			initialize
		end

	EV_PIXMAP_ACTION_SEQUENCES_IMP
		redefine
			needs_event_box,
			interface,
			destroy
		end
	HIVIEW_FUNCTIONS_EXTERNAL
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL
	CGIMAGE_FUNCTIONS_EXTERNAL
	CFSTRING_FUNCTIONS_EXTERNAL
	CFBUNDLE_FUNCTIONS_EXTERNAL
	CGDATAPROVIDER_FUNCTIONS_EXTERNAL
	CFBASE_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is True
		-- Needed to receive events on GtkImage

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			err, ret : INTEGER
			struct_ptr : POINTER
			target: POINTER
			point : CGPOINT_STRUCT
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
		do

			base_make (an_interface)
			err := hiimage_view_create_external( null, $struct_ptr )

			set_c_object ( struct_ptr )
			id := app_implementation.get_id (current)  --getting an id from the application
			target := get_control_event_target_external(struct_ptr)

					create rect.make_new_unshared
					create point.make_new_unshared
					create size.make_new_unshared
					point.set_x (50)
					point.set_y (50)
					size.set_height(50)
					size.set_width (50)
					rect.set_origin (point.item)
					rect.set_size (size.item)
					ret := hiview_set_frame_external (c_object, rect.item)
			app_implementation.install_event_handler (id, target, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventMouseDown)

		end




	initialize is
			-- Initialize `Current'
		do
		end

feature -- Drawing operations

	redraw is
			-- Force `Current' to redraw itself.
		do
		end

	flush is
			-- Ensure that the appearance of `Current' is updated on screen
			-- immediately. Any changes that have not yet been reflected will
			-- become visible.
		local
			err : INTEGER
		do
			err := set_control_visibility_external (c_object, 1, 1)
		end

	update_if_needed is
			-- Update `Current' if needed.
		do
		end

feature -- Measurement

	width: INTEGER is
			-- Width of the pixmap in pixels.
		do
		end

	height: INTEGER is
			-- height of the pixmap.
		do
		end

feature -- Element change





	read_from_named_file (file_name: STRING_GENERAL) is
			-- Attempt to load pixmap data from a file specified by `file_name'.
		local
			image_ref, url, provider : POINTER
			a_file_name, a_dir : C_STRING
			ret : INTEGER
			point : CGPOINT_STRUCT
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT


		do
			create a_file_name.make (file_name)
			create a_dir.make("./")
			print("before")

			url := cfbundle_copy_resource_url_external (cfbundle_get_main_bundle_external, c_string_to_cfstring_ptr(a_file_name), null, null)
				if url /= null then
					print ("got url")
					provider := cgdata_provider_create_with_url_external (url)

					image_ref := cgimage_create_with_pngdata_provider_external (provider, null, 1, kCGRenderingIntentDefault)

				--	cgdata_provider_release_external (provider)
				--	cfrelease_external (url)

					ret := hiimage_view_set_image_external (c_object, image_ref)
					ret := hiimage_view_set_opaque_external(c_object, 0 );
						print ("%N" + "image set ret: " + ret.out + "%Nis valid?: " + hiview_is_valid_external(c_object).out)
        			ret := hiimage_view_set_alpha_external( c_object, 0.3 );

        		--	ret := hiview_set_zorder_external( c_object, kHIViewZOrderBelow, null )
				--	ret := hiview_set_visible_external( c_object, 50 )

				end


		end

	c_string_to_cfstring_ptr(c_str: C_STRING):POINTER is
			local
				null_ptr:POINTER
			do
				Result:= cfstring_create_with_cstring_external(null_ptr, c_str.item,  kCFStringEncodingASCII)
			end

	frozen kCGRenderingIntentDefault: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCGRenderingIntentDefault"
	end

	frozen kCFStringEncodingASCII: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kCFStringEncodingASCII"
	end

	frozen kHIViewZOrderBelow: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kHIViewZOrderBelow"
	end

	set_with_default is
			-- Initialize the pixmap with the default
			-- pixmap (Vision2 logo)
		do
		end

	stretch (a_x, a_y: INTEGER) is
			-- Stretch the image to fit in size `a_x' by `a_y'.
		do
		end

	set_size (a_width, a_height: INTEGER) is
			-- Set the size of the pixmap to `a_width' by `a_height'.
		do
		end

	reset_for_buffering (a_width, a_height: INTEGER) is
			-- Resets the size of the pixmap without keeping original image or clearing background.
		do
		end

	set_mask (a_mask: EV_BITMAP) is
			-- Set the GdkBitmap used for masking `Current'.
		do
		end

feature -- Access

	raw_image_data: EV_RAW_IMAGE_DATA is
		do
		end

feature -- Duplication

	copy_pixmap (other: EV_PIXMAP) is
			-- Update `Current' to have same appearance as `other'.
			-- (So as to satisfy `is_equal'.)
		do
		end

feature {EV_ANY_I, EV_GTK_DEPENDENT_APPLICATION_IMP} -- Implementation

	set_pixmap_from_pixbuf (a_pixbuf: POINTER) is
			-- Construct `Current' from GdkPixbuf `a_pixbuf'
		do
		end

	copy_from_gdk_data (a_src_pix, a_src_mask: POINTER; a_width, a_height: INTEGER) is
			-- Update `Current' to use passed gdk pixmap data.
		do
		end

feature {EV_ANY_I} -- Implementation

	drawable: POINTER
			-- Pointer to the GdkPixmap image data.

	mask: POINTER
			-- Pointer to the GdkBitmap used for masking.

feature {EV_GTK_DEPENDENT_APPLICATION_IMP, EV_ANY_I} -- Implementation

	internal_xpm_data: POINTER
		-- Pointer to the appropriate XPM image used for the default stock cursor if any

feature {EV_STOCK_PIXMAPS_IMP, EV_PIXMAPABLE_IMP} -- Implementation

	set_pixmap (gdkpix, gdkmask: POINTER) is
			-- Set the GtkPixmap using Gdk pixmap data and mask.
		do
		end

	set_from_xpm_data (a_xpm_data: POINTER) is
			-- Pixmap symbolizing a piece of information.
		require
			xpm_data_not_null: a_xpm_data /= NULL
		do
		end

	set_from_stock_id (a_stock_id: POINTER) is
			-- Pixmap symbolizing a piece of information
		require
			a_stock_id_not_null: a_stock_id /= NULL
		do
		end

feature {NONE} -- Implementation

	save_to_named_file (a_format: EV_GRAPHICAL_FORMAT; a_filename: FILE_NAME) is
			-- Save `Current' in `a_format' to `a_filename'
		do
		end

	destroy is
			-- Destroy the pixmap and resources.
		do
		end

	dispose is
			-- Clear up resources if needed in object disposal.
		do
		end

feature {NONE} -- Externals

	default_pixmap_xpm: POINTER is
		do
		end

feature {NONE} -- Constants

	Default_color_depth: INTEGER is -1
			-- Default color depth, use the one from gdk_root_parent.

	Monochrome_color_depth: INTEGER is 1
			-- Black and White color depth (for mask).

feature {EV_ANY_I} -- Implementation

	interface: EV_PIXMAP;

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




end -- EV_PIXMAP_IMP

