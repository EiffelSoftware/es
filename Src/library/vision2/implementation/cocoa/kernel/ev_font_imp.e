note
	description: "Eiffel Vision font. Cocoa implementation."
	author:	"Daniel Furrer"
	keywords: "character, face, height, family, weight, shape, bold, italic"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FONT_IMP

inherit
 	EV_FONT_I
		redefine
			interface,
			string_size,
			line_height
		end

	EV_ANY_IMP
		redefine
			interface
		end

	EV_FONT_CONSTANTS

	NS_FONT_MANAGER_UTILS

create
	make

feature {NONE} -- Initialization

	make
			-- Set up `Current'
		local
			l_font_utils: NS_FONT_UTILS
		do
			create l_font_utils
				-- Note: if fontSize is 0 or negative, return the system font at the default size.
			font := l_font_utils.system_font_of_size_ (0)

			create preferred_families
			set_shape (shape_regular)
			set_weight (weight_regular)
			set_family (family_screen)
			set_is_initialized (True)

			preferred_families.internal_add_actions.extend (agent update_preferred_faces)
			preferred_families.internal_remove_actions.extend (preferred_families.internal_add_actions.first)
		end

feature -- Access

	family: INTEGER
			-- Preferred font category.

	char_set: INTEGER
			-- Charset

	weight: INTEGER
			-- Preferred font thickness.

	shape: INTEGER
			-- Preferred font slant.

	height: INTEGER
			-- Preferred font height measured in screen pixels.

	height_in_points: INTEGER
			-- Preferred font height measured in points.
		do
			Result := font.point_size.rounded
		end

	line_height: INTEGER
			-- <Precursor>
		do
			Result := font.point_size.rounded
		end

feature -- Element change

	set_family (a_family: INTEGER)
			-- Set `a_family' as preferred font category.
		do
			family := a_family
--			font := shared_font_manager.convert_font__to_family_ (font, create {NS_STRING}.make_with_eiffel_string (""))
		end

	set_face_name (a_face: READABLE_STRING_GENERAL)
			-- Set the face name for current.
		do
			font := shared_font_manager.convert_font__to_face_ (font, create {NS_STRING}.make_with_eiffel_string (a_face.as_string_8))
		end

	set_weight (a_weight: INTEGER)
			-- Set `a_weight' as preferred font thickness.
		do
			weight := a_weight
				-- NSFontBoldTrait = 2
			if weight > weight_regular then
				font := shared_font_manager.convert_font__to_have_trait_ (font, 2)
			else
				font := shared_font_manager.convert_font__to_not_have_trait_ (font, 2)
			end
		end

	set_shape (a_shape: INTEGER)
			-- Set `a_shape' as preferred font slant.
		do
			shape := a_shape
				-- NSFontItalicTrait = 1
			if shape = Shape_italic then
				font := shared_font_manager.convert_font__to_have_trait_ (font, 1)
			else
				font := shared_font_manager.convert_font__to_not_have_trait_ (font, 1)
			end
		end

	set_height (a_height: INTEGER)
			-- Set `a_height' as preferred font size in screen pixels
		local
			l_resolution: INTEGER
			l_points: REAL_64
		do
			height := a_height
				-- Convert pixels to points
			l_resolution := (create {EV_SCREEN}).vertical_resolution
			l_points := (a_height / l_resolution) * 72
			font := shared_font_manager.convert_font__to_size_ (font, l_points)
		end

	set_height_in_points (a_height: INTEGER)
			-- Set `a_height' as preferred font size in screen pixels
		local
			l_resolution: INTEGER
		do
			l_resolution := (create {EV_SCREEN}).vertical_resolution
				-- Convert points to pixels
			height := ((a_height * l_resolution) / 72).rounded
			font := shared_font_manager.convert_font__to_size_ (font, a_height.to_real)
		end

feature -- Status report

	name: STRING_32
			-- Face name chosen by toolkit.
		local
			i: INTEGER
		do
			Result := font.font_name.to_eiffel_string.as_string_32
				-- The OS X font name may be name-Bold, but we're just interested in the first part.
			i := Result.index_of ('-', 1)
			if i /= 0 then
				Result.keep_head (i - 1)
			end
		end

	ascent: INTEGER
			-- Vertical distance from the origin of the drawing operation to the top of the drawn character.
		do
			Result := font.ascender.floor
		end

	descent: INTEGER
			-- Vertical distance from the origin of the drawing operation to the bottom of the drawn character.
		do
			Result := - font.descender.floor
		end

	width: INTEGER
			-- Character width of current fixed-width font.
		do
			Result := string_width ("x")
		end

	minimum_width: INTEGER
			-- Width of the smallest character in the font.
		do
			Result := string_width ("1")
		end

	maximum_width: INTEGER
			-- Width of the biggest character in the font.
		do
			Result := string_width ("W")
		end

	string_size (a_string: READABLE_STRING_GENERAL): TUPLE [width: INTEGER; height: INTEGER; left_offset: INTEGER; right_offset: INTEGER]
			-- `Result' is [width, height, left_offset, right_offset] in pixels of `a_string' in the
			-- current font, taking into account line breaks ('%N').
		local
			l_string: NS_STRING
			l_attributed_string: NS_ATTRIBUTED_STRING
			l_attributes: NS_MUTABLE_DICTIONARY
			l_size: NS_SIZE
		do
			create l_string.make_with_eiffel_string (a_string.as_string_8)
			create l_attributes.make
			l_attributes.set_object__for_key_ (font, create {NS_STRING}.make_with_eiffel_string ("NSFont"))
			create l_attributed_string.make_with_string__attributes_ (l_string, l_attributes)

				-- Note: the size attribute is not automatically generated by the wrapper
			l_size := l_attributed_string.size

			create Result.default_create
			Result.width := l_size.width.rounded
			Result.height := l_size.height.rounded
		end

	string_width (a_string: READABLE_STRING_GENERAL): INTEGER
			-- Width in pixels of `a_string' in the current font.
		do
			Result := string_size (a_string).width
		end

	horizontal_resolution: INTEGER
			-- Horizontal resolution of screen for which the font is designed.
		do
			Result := (create {EV_SCREEN}).horizontal_resolution
		end

	vertical_resolution: INTEGER
			-- Vertical resolution of screen for which the font is designed.
		do
			Result := (create {EV_SCREEN}).vertical_resolution
		end

	is_proportional: BOOLEAN
			-- Can characters in the font have different sizes?
		do
			Result:= font.is_fixed_pitch
		end

feature {NONE} -- Implementation

	update_font_face
		do
		end

	update_preferred_faces (a_face: STRING_32)
		do
		end

feature {EV_ANY_I} -- Implementation

	font: NS_FONT;

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_FONT note option: stable attribute end

invariant
	shape_valid: shape = Shape_regular or shape = Shape_italic
end -- class EV_FONT_IMP
