indexing
	description: "EiffelVision color selection dialog."

class
	EV_COLOR_DIALOG_IMP

inherit
	EV_COLOR_DIALOG_I
		redefine
			interface
		end

	EV_STANDARD_DIALOG_IMP
		redefine
			interface,
			initialize,
			show
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a directory selection dialog with `par' as
			-- parent.
		do
			base_make (an_interface)

		end

	initialize is
			-- Connect action sequences to button signals.
		do
			Precursor {EV_STANDARD_DIALOG_IMP}

			enable_closeable
			forbid_resize
			set_is_initialized (True)
		end

	show is
			--
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					NColorPickerInfo theColorInfo;
					NPickColor (&theColorInfo);
				}
			]"
		end


feature -- Access

	color: EV_COLOR is
			-- Currently selected color.
		do
		end

feature -- Element change

	set_color (a_color: EV_COLOR) is
			-- Set `color' to `a_color'.
		do
		end

feature {NONE} -- Implementation

	internal_set_color: EV_COLOR
		-- Color explicitly set with `set_color'.

feature {NONE} -- Externals


feature {EV_ANY_I} -- Implementation

	interface: EV_COLOR_DIALOG;

indexing
	copyright:	"Copyright (c) 2006: The ETH Eiffel.Mac Team"


end -- class EV_COLOR_DIALOG_IMP

