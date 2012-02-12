note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_SCROLL_VIEW

inherit
	NS_VIEW
		redefine
			wrapper_objc_class_name
		end

	NS_TEXT_FINDER_BAR_CONTAINER_PROTOCOL
		undefine
			content_view,
			objc_content_view
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_frame_,
	make

feature -- NSScrollView

	document_visible_rect: NS_RECT
			-- Auto generated Objective-C wrapper.
		local
		do
			create Result.make
			objc_document_visible_rect (item, Result.item)
		end

	content_size: NS_SIZE
			-- Auto generated Objective-C wrapper.
		local
		do
			create Result.make
			objc_content_size (item, Result.item)
		end

	set_document_view_ (a_view: detachable NS_VIEW)
			-- Auto generated Objective-C wrapper.
		local
			a_view__item: POINTER
		do
			if attached a_view as a_view_attached then
				a_view__item := a_view_attached.item
			end
			objc_set_document_view_ (item, a_view__item)
		end

	document_view: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_document_view (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like document_view} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like document_view} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_content_view_ (a_content_view: detachable NS_CLIP_VIEW)
			-- Auto generated Objective-C wrapper.
		local
			a_content_view__item: POINTER
		do
			if attached a_content_view as a_content_view_attached then
				a_content_view__item := a_content_view_attached.item
			end
			objc_set_content_view_ (item, a_content_view__item)
		end

	content_view: detachable NS_CLIP_VIEW
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_content_view (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like content_view} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like content_view} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_document_cursor_ (an_obj: detachable NS_CURSOR)
			-- Auto generated Objective-C wrapper.
		local
			an_obj__item: POINTER
		do
			if attached an_obj as an_obj_attached then
				an_obj__item := an_obj_attached.item
			end
			objc_set_document_cursor_ (item, an_obj__item)
		end

	document_cursor: detachable NS_CURSOR
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_document_cursor (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like document_cursor} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like document_cursor} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_border_type_ (a_type: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_border_type_ (item, a_type)
		end

	border_type: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_border_type (item)
		end

	set_background_color_ (a_color: detachable NS_COLOR)
			-- Auto generated Objective-C wrapper.
		local
			a_color__item: POINTER
		do
			if attached a_color as a_color_attached then
				a_color__item := a_color_attached.item
			end
			objc_set_background_color_ (item, a_color__item)
		end

	background_color: detachable NS_COLOR
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_background_color (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like background_color} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like background_color} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_draws_background_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_draws_background_ (item, a_flag)
		end

	draws_background: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_draws_background (item)
		end

	set_has_vertical_scroller_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_has_vertical_scroller_ (item, a_flag)
		end

	has_vertical_scroller: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_has_vertical_scroller (item)
		end

	set_has_horizontal_scroller_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_has_horizontal_scroller_ (item, a_flag)
		end

	has_horizontal_scroller: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_has_horizontal_scroller (item)
		end

	set_vertical_scroller_ (an_object: detachable NS_SCROLLER)
			-- Auto generated Objective-C wrapper.
		local
			an_object__item: POINTER
		do
			if attached an_object as an_object_attached then
				an_object__item := an_object_attached.item
			end
			objc_set_vertical_scroller_ (item, an_object__item)
		end

	vertical_scroller: detachable NS_SCROLLER
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_vertical_scroller (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like vertical_scroller} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like vertical_scroller} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_horizontal_scroller_ (an_object: detachable NS_SCROLLER)
			-- Auto generated Objective-C wrapper.
		local
			an_object__item: POINTER
		do
			if attached an_object as an_object_attached then
				an_object__item := an_object_attached.item
			end
			objc_set_horizontal_scroller_ (item, an_object__item)
		end

	horizontal_scroller: detachable NS_SCROLLER
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_horizontal_scroller (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like horizontal_scroller} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like horizontal_scroller} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	autohides_scrollers: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_autohides_scrollers (item)
		end

	set_autohides_scrollers_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_autohides_scrollers_ (item, a_flag)
		end

	set_horizontal_line_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_horizontal_line_scroll_ (item, a_value)
		end

	set_vertical_line_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_vertical_line_scroll_ (item, a_value)
		end

	set_line_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_line_scroll_ (item, a_value)
		end

	horizontal_line_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_horizontal_line_scroll (item)
		end

	vertical_line_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_vertical_line_scroll (item)
		end

	line_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_line_scroll (item)
		end

	set_horizontal_page_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_horizontal_page_scroll_ (item, a_value)
		end

	set_vertical_page_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_vertical_page_scroll_ (item, a_value)
		end

	set_page_scroll_ (a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_page_scroll_ (item, a_value)
		end

	horizontal_page_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_horizontal_page_scroll (item)
		end

	vertical_page_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_vertical_page_scroll (item)
		end

	page_scroll: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_page_scroll (item)
		end

	set_scrolls_dynamically_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_scrolls_dynamically_ (item, a_flag)
		end

	scrolls_dynamically: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_scrolls_dynamically (item)
		end

	tile
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_tile (item)
		end

	scroller_style: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_scroller_style (item)
		end

	set_scroller_style_ (a_new_scroller_style: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_scroller_style_ (item, a_new_scroller_style)
		end

	scroller_knob_style: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_scroller_knob_style (item)
		end

	set_scroller_knob_style_ (a_new_scroller_knob_style: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_scroller_knob_style_ (item, a_new_scroller_knob_style)
		end

	flash_scrollers
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_flash_scrollers (item)
		end

	horizontal_scroll_elasticity: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_horizontal_scroll_elasticity (item)
		end

	set_horizontal_scroll_elasticity_ (a_elasticity: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_horizontal_scroll_elasticity_ (item, a_elasticity)
		end

	vertical_scroll_elasticity: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_vertical_scroll_elasticity (item)
		end

	set_vertical_scroll_elasticity_ (a_elasticity: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_vertical_scroll_elasticity_ (item, a_elasticity)
		end

	uses_predominant_axis_scrolling: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_uses_predominant_axis_scrolling (item)
		end

	set_uses_predominant_axis_scrolling_ (a_predominant_axis_scrolling: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_uses_predominant_axis_scrolling_ (item, a_predominant_axis_scrolling)
		end

feature {NONE} -- NSScrollView Externals

	objc_document_visible_rect (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSRect *)$result_pointer = [(NSScrollView *)$an_item documentVisibleRect];
			 ]"
		end

	objc_content_size (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSSize *)$result_pointer = [(NSScrollView *)$an_item contentSize];
			 ]"
		end

	objc_set_document_view_ (an_item: POINTER; a_view: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setDocumentView:$a_view];
			 ]"
		end

	objc_document_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item documentView];
			 ]"
		end

	objc_set_content_view_ (an_item: POINTER; a_content_view: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setContentView:$a_content_view];
			 ]"
		end

	objc_content_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item contentView];
			 ]"
		end

	objc_set_document_cursor_ (an_item: POINTER; an_obj: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setDocumentCursor:$an_obj];
			 ]"
		end

	objc_document_cursor (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item documentCursor];
			 ]"
		end

	objc_set_border_type_ (an_item: POINTER; a_type: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setBorderType:$a_type];
			 ]"
		end

	objc_border_type (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item borderType];
			 ]"
		end

	objc_set_background_color_ (an_item: POINTER; a_color: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setBackgroundColor:$a_color];
			 ]"
		end

	objc_background_color (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item backgroundColor];
			 ]"
		end

	objc_set_draws_background_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setDrawsBackground:$a_flag];
			 ]"
		end

	objc_draws_background (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item drawsBackground];
			 ]"
		end

	objc_set_has_vertical_scroller_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHasVerticalScroller:$a_flag];
			 ]"
		end

	objc_has_vertical_scroller (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item hasVerticalScroller];
			 ]"
		end

	objc_set_has_horizontal_scroller_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHasHorizontalScroller:$a_flag];
			 ]"
		end

	objc_has_horizontal_scroller (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item hasHorizontalScroller];
			 ]"
		end

	objc_set_vertical_scroller_ (an_item: POINTER; an_object: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setVerticalScroller:$an_object];
			 ]"
		end

	objc_vertical_scroller (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item verticalScroller];
			 ]"
		end

	objc_set_horizontal_scroller_ (an_item: POINTER; an_object: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHorizontalScroller:$an_object];
			 ]"
		end

	objc_horizontal_scroller (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item horizontalScroller];
			 ]"
		end

	objc_autohides_scrollers (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item autohidesScrollers];
			 ]"
		end

	objc_set_autohides_scrollers_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setAutohidesScrollers:$a_flag];
			 ]"
		end

	objc_set_horizontal_line_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHorizontalLineScroll:$a_value];
			 ]"
		end

	objc_set_vertical_line_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setVerticalLineScroll:$a_value];
			 ]"
		end

	objc_set_line_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setLineScroll:$a_value];
			 ]"
		end

	objc_horizontal_line_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item horizontalLineScroll];
			 ]"
		end

	objc_vertical_line_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item verticalLineScroll];
			 ]"
		end

	objc_line_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item lineScroll];
			 ]"
		end

	objc_set_horizontal_page_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHorizontalPageScroll:$a_value];
			 ]"
		end

	objc_set_vertical_page_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setVerticalPageScroll:$a_value];
			 ]"
		end

	objc_set_page_scroll_ (an_item: POINTER; a_value: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setPageScroll:$a_value];
			 ]"
		end

	objc_horizontal_page_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item horizontalPageScroll];
			 ]"
		end

	objc_vertical_page_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item verticalPageScroll];
			 ]"
		end

	objc_page_scroll (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item pageScroll];
			 ]"
		end

	objc_set_scrolls_dynamically_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setScrollsDynamically:$a_flag];
			 ]"
		end

	objc_scrolls_dynamically (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item scrollsDynamically];
			 ]"
		end

	objc_tile (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item tile];
			 ]"
		end

	objc_scroller_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item scrollerStyle];
			 ]"
		end

	objc_set_scroller_style_ (an_item: POINTER; a_new_scroller_style: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setScrollerStyle:$a_new_scroller_style];
			 ]"
		end

	objc_scroller_knob_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item scrollerKnobStyle];
			 ]"
		end

	objc_set_scroller_knob_style_ (an_item: POINTER; a_new_scroller_knob_style: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setScrollerKnobStyle:$a_new_scroller_knob_style];
			 ]"
		end

	objc_flash_scrollers (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item flashScrollers];
			 ]"
		end

	objc_horizontal_scroll_elasticity (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item horizontalScrollElasticity];
			 ]"
		end

	objc_set_horizontal_scroll_elasticity_ (an_item: POINTER; a_elasticity: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHorizontalScrollElasticity:$a_elasticity];
			 ]"
		end

	objc_vertical_scroll_elasticity (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item verticalScrollElasticity];
			 ]"
		end

	objc_set_vertical_scroll_elasticity_ (an_item: POINTER; a_elasticity: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setVerticalScrollElasticity:$a_elasticity];
			 ]"
		end

	objc_uses_predominant_axis_scrolling (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item usesPredominantAxisScrolling];
			 ]"
		end

	objc_set_uses_predominant_axis_scrolling_ (an_item: POINTER; a_predominant_axis_scrolling: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setUsesPredominantAxisScrolling:$a_predominant_axis_scrolling];
			 ]"
		end

feature -- NSRulerSupport

	set_rulers_visible_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_rulers_visible_ (item, a_flag)
		end

	rulers_visible: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_rulers_visible (item)
		end

	set_has_horizontal_ruler_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_has_horizontal_ruler_ (item, a_flag)
		end

	has_horizontal_ruler: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_has_horizontal_ruler (item)
		end

	set_has_vertical_ruler_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_has_vertical_ruler_ (item, a_flag)
		end

	has_vertical_ruler: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_has_vertical_ruler (item)
		end

	set_horizontal_ruler_view_ (a_ruler: detachable NS_RULER_VIEW)
			-- Auto generated Objective-C wrapper.
		local
			a_ruler__item: POINTER
		do
			if attached a_ruler as a_ruler_attached then
				a_ruler__item := a_ruler_attached.item
			end
			objc_set_horizontal_ruler_view_ (item, a_ruler__item)
		end

	horizontal_ruler_view: detachable NS_RULER_VIEW
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_horizontal_ruler_view (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like horizontal_ruler_view} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like horizontal_ruler_view} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_vertical_ruler_view_ (a_ruler: detachable NS_RULER_VIEW)
			-- Auto generated Objective-C wrapper.
		local
			a_ruler__item: POINTER
		do
			if attached a_ruler as a_ruler_attached then
				a_ruler__item := a_ruler_attached.item
			end
			objc_set_vertical_ruler_view_ (item, a_ruler__item)
		end

	vertical_ruler_view: detachable NS_RULER_VIEW
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_vertical_ruler_view (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like vertical_ruler_view} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like vertical_ruler_view} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSRulerSupport Externals

	objc_set_rulers_visible_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setRulersVisible:$a_flag];
			 ]"
		end

	objc_rulers_visible (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item rulersVisible];
			 ]"
		end

	objc_set_has_horizontal_ruler_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHasHorizontalRuler:$a_flag];
			 ]"
		end

	objc_has_horizontal_ruler (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item hasHorizontalRuler];
			 ]"
		end

	objc_set_has_vertical_ruler_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHasVerticalRuler:$a_flag];
			 ]"
		end

	objc_has_vertical_ruler (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item hasVerticalRuler];
			 ]"
		end

	objc_set_horizontal_ruler_view_ (an_item: POINTER; a_ruler: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setHorizontalRulerView:$a_ruler];
			 ]"
		end

	objc_horizontal_ruler_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item horizontalRulerView];
			 ]"
		end

	objc_set_vertical_ruler_view_ (an_item: POINTER; a_ruler: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setVerticalRulerView:$a_ruler];
			 ]"
		end

	objc_vertical_ruler_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSScrollView *)$an_item verticalRulerView];
			 ]"
		end

feature -- NSFindBarSupport

	set_find_bar_position_ (a_position: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_find_bar_position_ (item, a_position)
		end

	find_bar_position: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_find_bar_position (item)
		end

feature {NONE} -- NSFindBarSupport Externals

	objc_set_find_bar_position_ (an_item: POINTER; a_position: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSScrollView *)$an_item setFindBarPosition:$a_position];
			 ]"
		end

	objc_find_bar_position (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSScrollView *)$an_item findBarPosition];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSScrollView"
		end

end