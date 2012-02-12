note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_EXTENSIONS_CAT

inherit
	NS_CATEGORY_COMMON

feature -- NSExtensions

	set_icon_ (a_ns_file_wrapper: NS_FILE_WRAPPER; a_icon: detachable NS_IMAGE)
			-- Auto generated Objective-C wrapper.
		local
			a_icon__item: POINTER
		do
			if attached a_icon as a_icon_attached then
				a_icon__item := a_icon_attached.item
			end
			objc_set_icon_ (a_ns_file_wrapper.item, a_icon__item)
		end

	icon (a_ns_file_wrapper: NS_FILE_WRAPPER): detachable NS_IMAGE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_icon (a_ns_file_wrapper.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like icon} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like icon} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSExtensions Externals

	objc_set_icon_ (an_item: POINTER; a_icon: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSFileWrapper *)$an_item setIcon:$a_icon];
			 ]"
		end

	objc_icon (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileWrapper *)$an_item icon];
			 ]"
		end

end