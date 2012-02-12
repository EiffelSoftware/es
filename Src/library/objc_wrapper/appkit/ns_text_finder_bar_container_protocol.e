note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_TEXT_FINDER_BAR_CONTAINER_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Required Methods

	find_bar_view_did_change_height
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_find_bar_view_did_change_height (item)
		end

feature {NONE} -- Required Methods Externals

	objc_find_bar_view_did_change_height (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSTextFinderBarContainer>)$an_item findBarViewDidChangeHeight];
			 ]"
		end

feature -- Optional Methods

	content_view: detachable NS_VIEW
			-- Auto generated Objective-C wrapper.
		require
			has_content_view: has_content_view
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

feature -- Status Report

	has_content_view: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_content_view (item)
		end

feature -- Status Report Externals

	objc_has_content_view (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(contentView)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_content_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSTextFinderBarContainer>)$an_item contentView];
			 ]"
		end

end