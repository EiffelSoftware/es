note
	description: "EiffelVision label, Cocoa implementation."
	author:	"Daniel Furrer"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LABEL_IMP

inherit
	EV_LABEL_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			make,
			set_background_color,
			set_foreground_color
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			set_text
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			set_font
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create text_field.make
			text_field.set_translates_autoresizing_mask_into_constraints_ (False)
			text_field.set_editable_ (False)
			text_field.set_bordered_ (False)
			text_field.set_draws_background_ (False)
			cocoa_view := text_field

			align_text_center

			Precursor {EV_PRIMITIVE_IMP}
			disable_tabable_from
			disable_tabable_to
		end

feature -- Status setting

	align_text_top
			-- Set vertical text alignment of current label to top.
		do
			check
				not_implemented: False
			end
		end

	align_text_vertical_center
			-- Set text alignment of current label to be in the center vertically.
		do
			check
				not_implemented: False
			end
		end

	align_text_bottom
			-- Set vertical text alignment of current label to bottom.
		do
			check
				not_implemented: False
			end
		end

	set_text (a_text: READABLE_STRING_GENERAL)
			-- Assign `a_text' to `text'.
		do
			Precursor {EV_TEXTABLE_IMP} (a_text)
			text_field.set_string_value_ (create {NS_STRING}.make_with_eiffel_string (a_text.as_string_8))
		end

	set_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'
		local
			color: NS_COLOR
			l_color_utils: NS_COLOR_UTILS
		do
			Precursor {EV_PRIMITIVE_IMP} (a_color)
			create l_color_utils
			color := l_color_utils.color_with_calibrated_red__green__blue__alpha_ (a_color.red.to_double, a_color.green.to_double, a_color.blue.to_double, 1.0)
			text_field.set_background_color_ (color)
		end

	set_foreground_color (a_color: EV_COLOR)
			-- <Precursor>
		local
			color: NS_COLOR
			l_color_utils: NS_COLOR_UTILS
		do
			Precursor {EV_PRIMITIVE_IMP} (a_color)
			create l_color_utils
			color := l_color_utils.color_with_calibrated_red__green__blue__alpha_ (a_color.red.to_double, a_color.green.to_double, a_color.blue.to_double, 1.0)
			text_field.set_text_color_ (color)
		end

	set_font (a_font: EV_FONT)
			-- <Precursor>
		do
			Precursor {EV_FONTABLE_IMP} (a_font)
			check attached {EV_FONT_IMP} a_font.implementation as font_imp then
				-- NSTodo: font is not of the proper size. Fix bug
--				text_field.set_font_ (font_imp.font)
			end
		end

feature {EV_ANY_I} -- Implementation

	text_field: NS_TEXT_FIELD

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_LABEL note option: stable attribute end;

end --class LABEL_IMP
