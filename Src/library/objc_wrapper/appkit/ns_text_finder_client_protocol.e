note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_TEXT_FINDER_CLIENT_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

--	string_at_index__effective_range__ends_with_search_boundary_ (a_character_index: NATURAL_64; a_out_range: UNSUPPORTED_TYPE; a_out_flag: UNSUPPORTED_TYPE): detachable NS_STRING
--			-- Auto generated Objective-C wrapper.
--		require
--			has_string_at_index__effective_range__ends_with_search_boundary_: has_string_at_index__effective_range__ends_with_search_boundary_
--		local
--			result_pointer: POINTER
--			a_out_range__item: POINTER
--			a_out_flag__item: POINTER
--		do
--			if attached a_out_range as a_out_range_attached then
--				a_out_range__item := a_out_range_attached.item
--			end
--			if attached a_out_flag as a_out_flag_attached then
--				a_out_flag__item := a_out_flag_attached.item
--			end
--			result_pointer := objc_string_at_index__effective_range__ends_with_search_boundary_ (item, a_character_index, a_out_range__item, a_out_flag__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like string_at_index__effective_range__ends_with_search_boundary_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like string_at_index__effective_range__ends_with_search_boundary_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	string_length: NATURAL_64
			-- Auto generated Objective-C wrapper.
		require
			has_string_length: has_string_length
		local
		do
			Result := objc_string_length (item)
		end

	scroll_range_to_visible_ (a_range: NS_RANGE)
			-- Auto generated Objective-C wrapper.
		require
			has_scroll_range_to_visible_: has_scroll_range_to_visible_
		local
		do
			objc_scroll_range_to_visible_ (item, a_range.item)
		end

	should_replace_characters_in_ranges__with_strings_ (a_ranges: detachable NS_ARRAY; a_strings: detachable NS_ARRAY): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_should_replace_characters_in_ranges__with_strings_: has_should_replace_characters_in_ranges__with_strings_
		local
			a_ranges__item: POINTER
			a_strings__item: POINTER
		do
			if attached a_ranges as a_ranges_attached then
				a_ranges__item := a_ranges_attached.item
			end
			if attached a_strings as a_strings_attached then
				a_strings__item := a_strings_attached.item
			end
			Result := objc_should_replace_characters_in_ranges__with_strings_ (item, a_ranges__item, a_strings__item)
		end

	replace_characters_in_range__with_string_ (a_range: NS_RANGE; a_string: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		require
			has_replace_characters_in_range__with_string_: has_replace_characters_in_range__with_string_
		local
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			objc_replace_characters_in_range__with_string_ (item, a_range.item, a_string__item)
		end

	did_replace_characters
			-- Auto generated Objective-C wrapper.
		require
			has_did_replace_characters: has_did_replace_characters
		local
		do
			objc_did_replace_characters (item)
		end

--	content_view_at_index__effective_character_range_ (a_index: NATURAL_64; a_out_range: UNSUPPORTED_TYPE): detachable NS_VIEW
--			-- Auto generated Objective-C wrapper.
--		require
--			has_content_view_at_index__effective_character_range_: has_content_view_at_index__effective_character_range_
--		local
--			result_pointer: POINTER
--			a_out_range__item: POINTER
--		do
--			if attached a_out_range as a_out_range_attached then
--				a_out_range__item := a_out_range_attached.item
--			end
--			result_pointer := objc_content_view_at_index__effective_character_range_ (item, a_index, a_out_range__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like content_view_at_index__effective_character_range_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like content_view_at_index__effective_character_range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	rects_for_character_range_ (a_range: NS_RANGE): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		require
			has_rects_for_character_range_: has_rects_for_character_range_
		local
			result_pointer: POINTER
		do
			result_pointer := objc_rects_for_character_range_ (item, a_range.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like rects_for_character_range_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like rects_for_character_range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	draw_characters_in_range__for_content_view_ (a_range: NS_RANGE; a_view: detachable NS_VIEW)
			-- Auto generated Objective-C wrapper.
		require
			has_draw_characters_in_range__for_content_view_: has_draw_characters_in_range__for_content_view_
		local
			a_view__item: POINTER
		do
			if attached a_view as a_view_attached then
				a_view__item := a_view_attached.item
			end
			objc_draw_characters_in_range__for_content_view_ (item, a_range.item, a_view__item)
		end

feature -- Status Report

--	has_string_at_index__effective_range__ends_with_search_boundary_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_string_at_index__effective_range__ends_with_search_boundary_ (item)
--		end

	has_string_length: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_string_length (item)
		end

	has_scroll_range_to_visible_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_scroll_range_to_visible_ (item)
		end

	has_should_replace_characters_in_ranges__with_strings_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_should_replace_characters_in_ranges__with_strings_ (item)
		end

	has_replace_characters_in_range__with_string_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_replace_characters_in_range__with_string_ (item)
		end

	has_did_replace_characters: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_did_replace_characters (item)
		end

--	has_content_view_at_index__effective_character_range_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_content_view_at_index__effective_character_range_ (item)
--		end

	has_rects_for_character_range_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_rects_for_character_range_ (item)
		end

	has_draw_characters_in_range__for_content_view_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_draw_characters_in_range__for_content_view_ (item)
		end

feature -- Status Report Externals

--	objc_has_string_at_index__effective_range__ends_with_search_boundary_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(stringAtIndex:effectiveRange:endsWithSearchBoundary:)];
--			 ]"
--		end

	objc_has_string_length (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(stringLength)];
			 ]"
		end

	objc_has_scroll_range_to_visible_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(scrollRangeToVisible:)];
			 ]"
		end

	objc_has_should_replace_characters_in_ranges__with_strings_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(shouldReplaceCharactersInRanges:withStrings:)];
			 ]"
		end

	objc_has_replace_characters_in_range__with_string_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(replaceCharactersInRange:withString:)];
			 ]"
		end

	objc_has_did_replace_characters (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(didReplaceCharacters)];
			 ]"
		end

--	objc_has_content_view_at_index__effective_character_range_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(contentViewAtIndex:effectiveCharacterRange:)];
--			 ]"
--		end

	objc_has_rects_for_character_range_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(rectsForCharacterRange:)];
			 ]"
		end

	objc_has_draw_characters_in_range__for_content_view_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(drawCharactersInRange:forContentView:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

--	objc_string_at_index__effective_range__ends_with_search_boundary_ (an_item: POINTER; a_character_index: NATURAL_64; a_out_range: UNSUPPORTED_TYPE; a_out_flag: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(id <NSTextFinderClient>)$an_item stringAtIndex:$a_character_index effectiveRange: endsWithSearchBoundary:];
--			 ]"
--		end

	objc_string_length (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSTextFinderClient>)$an_item stringLength];
			 ]"
		end

	objc_scroll_range_to_visible_ (an_item: POINTER; a_range: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSTextFinderClient>)$an_item scrollRangeToVisible:*((NSRange *)$a_range)];
			 ]"
		end

	objc_should_replace_characters_in_ranges__with_strings_ (an_item: POINTER; a_ranges: POINTER; a_strings: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSTextFinderClient>)$an_item shouldReplaceCharactersInRanges:$a_ranges withStrings:$a_strings];
			 ]"
		end

	objc_replace_characters_in_range__with_string_ (an_item: POINTER; a_range: POINTER; a_string: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSTextFinderClient>)$an_item replaceCharactersInRange:*((NSRange *)$a_range) withString:$a_string];
			 ]"
		end

	objc_did_replace_characters (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSTextFinderClient>)$an_item didReplaceCharacters];
			 ]"
		end

--	objc_content_view_at_index__effective_character_range_ (an_item: POINTER; a_index: NATURAL_64; a_out_range: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(id <NSTextFinderClient>)$an_item contentViewAtIndex:$a_index effectiveCharacterRange:];
--			 ]"
--		end

	objc_rects_for_character_range_ (an_item: POINTER; a_range: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSTextFinderClient>)$an_item rectsForCharacterRange:*((NSRange *)$a_range)];
			 ]"
		end

	objc_draw_characters_in_range__for_content_view_ (an_item: POINTER; a_range: POINTER; a_view: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSTextFinderClient>)$an_item drawCharactersInRange:*((NSRange *)$a_range) forContentView:$a_view];
			 ]"
		end

end