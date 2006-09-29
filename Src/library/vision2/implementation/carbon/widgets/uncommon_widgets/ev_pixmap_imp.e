indexing
	description: "EiffelVision pixmap, Carbon implementation."
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
			initialize
		end

	EV_PRIMITIVE_IMP
		undefine
			foreground_color,
			background_color,
			set_foreground_color,
			set_background_color,
			on_event
		redefine
			interface,
			width,
			height,
			destroy,
			dispose,
			initialize,
			minimum_width,
			minimum_height
		end

	EV_PIXMAP_ACTION_SEQUENCES_IMP
		redefine
			interface,
			destroy
		end
	HIVIEW_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CARBONEVENTS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CGIMAGE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CFSTRING_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CFBUNDLE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CGDATAPROVIDER_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end
	CFBASE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			ret: INTEGER
			struct_ptr: POINTER
		do
			base_make (an_interface)

			ret := hiimage_view_create_external (null, $struct_ptr)
			set_c_object (struct_ptr)
			ret := hiview_set_visible_external (struct_ptr, 1)
		end

	initialize is
			-- Initialize `Current'
		local
			ret: INTEGER
			target, h_ret: POINTER
		do
			Precursor {EV_PRIMITIVE_IMP}

			ret := hiview_set_drawing_enabled_external (c_object, 1)
			event_id := app_implementation.get_id (current)  --getting an id from the application
			target := get_control_event_target_external(c_object)
			--h_ret := app_implementation.install_event_handler (event_id, target, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventMouseDown)
			expandable := false
			init_default_values
		end



feature -- Drawing operations

	redraw is
			-- Force `Current' to redraw itself.
		local
			ret: INTEGER
		do
			ret := hiview_set_needs_display_external (c_object, 1)
		end

	flush is
			-- Ensure that the appearance of `Current' is updated on screen
			-- immediately. Any changes that have not yet been reflected will
			-- become visible.
		local
			ret : INTEGER
		do
			ret := hiview_set_needs_display_external (c_object, 1)
		end

	update_if_needed is
			-- Update `Current' if needed.
		do
		end

feature -- Measurement

	width: INTEGER is
			-- Width of the pixmap in pixels.
		local
			ret : INTEGER
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
			rect_ptr : POINTER
		do
			create rect.make_new_unshared
			ret := hiview_get_frame_external (c_object, rect.item)
			create size.make_shared (rect.size.item)
			Result := size.width.rounded
		end

	height: INTEGER is
			-- height of the pixmap.
		local
			ret : INTEGER
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
			rect_ptr : POINTER
		do
			create rect.make_new_unshared
			ret := hiview_get_frame_external (c_object, rect.item)
			create size.make_shared (rect.size.item)
			Result := size.height.rounded
		end

feature -- Element change

	read_from_named_file (file_name: STRING_GENERAL) is
			-- Attempt to load pixmap data from a file specified by `file_name'.
		local
			url, provider : POINTER
			a_file_name, a_dir : C_STRING
			ret : INTEGER
			point : CGPOINT_STRUCT
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
		do
			create a_file_name.make (file_name)
			create a_dir.make("./")

			url := cfbundle_copy_resource_url_external (cfbundle_get_main_bundle_external, c_string_to_cfstring_ptr(a_file_name), null, c_string_to_cfstring_ptr(a_dir))
			if url = null then
				create a_dir.make ("./../../../")
				url := cfbundle_copy_resource_url_external (cfbundle_get_main_bundle_external, c_string_to_cfstring_ptr(a_file_name), null, c_string_to_cfstring_ptr(a_dir))

			end

			if url /= null then
				provider := cgdata_provider_create_with_url_external (url)
				drawable := cgimage_create_with_pngdata_provider_external (provider, null, 1, kCGRenderingIntentDefault)

				cgdata_provider_release_external (provider)
				cfrelease_external (url)

				ret := hiview_set_drawing_enabled_external (c_object, 1)
				ret := hiimage_view_set_image_external (c_object, drawable)

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
		local
			ret: INTEGER
		do
			ret := hiimage_view_set_scale_to_fit_external (c_object, 1)
			set_size (a_x, a_y)
		end

	set_size (a_width, a_height: INTEGER) is
			-- Set the size of the pixmap to `a_width' by `a_height'.
		local
			ret : INTEGER
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
		do
			create rect.make_new_unshared
			create size.make_shared (rect.size)

			ret := hiview_get_frame_external (c_object, rect.item)

			size.set_height(a_height)
			size.set_width (a_width)

			ret := hiview_set_frame_external (c_object, rect.item)
			internal_width := a_width
			internal_height := a_height
		end

	reset_for_buffering (a_width, a_height: INTEGER) is
			-- Resets the size of the pixmap without keeping original image or clearing background.
		local

		do
			if a_width /= width or else a_height /= height then
				-- so what?
			end
		end

		set_mask (a_mask: EV_BITMAP) is
			-- Set the Bitmap used for masking `Current'.
		local
			a_mask_imp: EV_BITMAP_IMP
			ret: INTEGER
		do
			a_mask_imp ?= a_mask.implementation
			drawable := cgimage_create_with_mask_external (drawable, a_mask_imp.drawable)
			ret := hiimage_view_set_image_external (c_object, drawable)
		end

feature -- Access

	minimum_width: INTEGER is
			-- Minimum width that the widget may occupy.
	do
		Result := internal_width
	end

	minimum_height: INTEGER is
			-- Minimum width that the widget may occupy.
	do
		Result := internal_height
	end

	image_ptr: POINTER

	raw_image_data: EV_RAW_IMAGE_DATA is
		do
		end

feature -- Duplication

	copy_pixmap (other: EV_PIXMAP) is
			-- Update `Current' to have same appearance as `other'.
			-- (So as to satisfy `is_equal'.)
		local
			other_imp: EV_PIXMAP_IMP
			ret: INTEGER
		do
			other_imp ?= other.implementation
			drawable := other_imp.drawable
			mask := other_imp.mask
			internal_xpm_data := other_imp.internal_xpm_data

			ret := hiimage_view_set_image_external (c_object, drawable)
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

	internal_height: INTEGER
	internal_width: INTEGER

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
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- EV_PIXMAP_IMP

