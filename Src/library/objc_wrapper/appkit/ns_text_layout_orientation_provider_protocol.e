note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_TEXT_LAYOUT_ORIENTATION_PROVIDER_PROTOCOL

inherit
	NS_COMMON

feature -- Required Methods

	layout_orientation: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_layout_orientation (item)
		end

feature {NONE} -- Required Methods Externals

	objc_layout_orientation (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSTextLayoutOrientationProvider>)$an_item layoutOrientation];
			 ]"
		end

end