note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_ATS_TYPESETTER

inherit
	NS_TYPESETTER
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSGlyphStorageInterface

--	get_glyphs_in_range__glyphs__character_indexes__glyph_inscriptions__elastic_bits_ (a_glyphs_range: NS_RANGE; a_glyph_buffer: UNSUPPORTED_TYPE; a_char_index_buffer: UNSUPPORTED_TYPE; a_inscribe_buffer: UNSUPPORTED_TYPE; a_elastic_buffer: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		local
--			a_glyph_buffer__item: POINTER
--			a_char_index_buffer__item: POINTER
--			a_inscribe_buffer__item: POINTER
--			a_elastic_buffer__item: POINTER
--		do
--			if attached a_glyph_buffer as a_glyph_buffer_attached then
--				a_glyph_buffer__item := a_glyph_buffer_attached.item
--			end
--			if attached a_char_index_buffer as a_char_index_buffer_attached then
--				a_char_index_buffer__item := a_char_index_buffer_attached.item
--			end
--			if attached a_inscribe_buffer as a_inscribe_buffer_attached then
--				a_inscribe_buffer__item := a_inscribe_buffer_attached.item
--			end
--			if attached a_elastic_buffer as a_elastic_buffer_attached then
--				a_elastic_buffer__item := a_elastic_buffer_attached.item
--			end
--			Result := objc_get_glyphs_in_range__glyphs__character_indexes__glyph_inscriptions__elastic_bits_ (item, a_glyphs_range.item, a_glyph_buffer__item, a_char_index_buffer__item, a_inscribe_buffer__item, a_elastic_buffer__item)
--		end

feature {NONE} -- NSGlyphStorageInterface Externals

--	objc_get_glyphs_in_range__glyphs__character_indexes__glyph_inscriptions__elastic_bits_ (an_item: POINTER; a_glyphs_range: POINTER; a_glyph_buffer: UNSUPPORTED_TYPE; a_char_index_buffer: UNSUPPORTED_TYPE; a_inscribe_buffer: UNSUPPORTED_TYPE; a_elastic_buffer: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(NSATSTypesetter *)$an_item getGlyphsInRange:*((NSRange *)$a_glyphs_range) glyphs: characterIndexes: glyphInscriptions: elasticBits:];
--			 ]"
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSATSTypesetter"
		end

end