note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_POPOVER_DELEGATE_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

	popover_should_close_ (a_popover: detachable NS_POPOVER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_popover_should_close_: has_popover_should_close_
		local
			a_popover__item: POINTER
		do
			if attached a_popover as a_popover_attached then
				a_popover__item := a_popover_attached.item
			end
			Result := objc_popover_should_close_ (item, a_popover__item)
		end

	detachable_window_for_popover_ (a_popover: detachable NS_POPOVER): detachable NS_WINDOW
			-- Auto generated Objective-C wrapper.
		require
			has_detachable_window_for_popover_: has_detachable_window_for_popover_
		local
			result_pointer: POINTER
			a_popover__item: POINTER
		do
			if attached a_popover as a_popover_attached then
				a_popover__item := a_popover_attached.item
			end
			result_pointer := objc_detachable_window_for_popover_ (item, a_popover__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like detachable_window_for_popover_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like detachable_window_for_popover_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	popover_will_show_ (a_notification: detachable NS_NOTIFICATION)
			-- Auto generated Objective-C wrapper.
		require
			has_popover_will_show_: has_popover_will_show_
		local
			a_notification__item: POINTER
		do
			if attached a_notification as a_notification_attached then
				a_notification__item := a_notification_attached.item
			end
			objc_popover_will_show_ (item, a_notification__item)
		end

	popover_did_show_ (a_notification: detachable NS_NOTIFICATION)
			-- Auto generated Objective-C wrapper.
		require
			has_popover_did_show_: has_popover_did_show_
		local
			a_notification__item: POINTER
		do
			if attached a_notification as a_notification_attached then
				a_notification__item := a_notification_attached.item
			end
			objc_popover_did_show_ (item, a_notification__item)
		end

	popover_will_close_ (a_notification: detachable NS_NOTIFICATION)
			-- Auto generated Objective-C wrapper.
		require
			has_popover_will_close_: has_popover_will_close_
		local
			a_notification__item: POINTER
		do
			if attached a_notification as a_notification_attached then
				a_notification__item := a_notification_attached.item
			end
			objc_popover_will_close_ (item, a_notification__item)
		end

	popover_did_close_ (a_notification: detachable NS_NOTIFICATION)
			-- Auto generated Objective-C wrapper.
		require
			has_popover_did_close_: has_popover_did_close_
		local
			a_notification__item: POINTER
		do
			if attached a_notification as a_notification_attached then
				a_notification__item := a_notification_attached.item
			end
			objc_popover_did_close_ (item, a_notification__item)
		end

feature -- Status Report

	has_popover_should_close_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_popover_should_close_ (item)
		end

	has_detachable_window_for_popover_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_detachable_window_for_popover_ (item)
		end

	has_popover_will_show_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_popover_will_show_ (item)
		end

	has_popover_did_show_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_popover_did_show_ (item)
		end

	has_popover_will_close_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_popover_will_close_ (item)
		end

	has_popover_did_close_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_popover_did_close_ (item)
		end

feature -- Status Report Externals

	objc_has_popover_should_close_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(popoverShouldClose:)];
			 ]"
		end

	objc_has_detachable_window_for_popover_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(detachableWindowForPopover:)];
			 ]"
		end

	objc_has_popover_will_show_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(popoverWillShow:)];
			 ]"
		end

	objc_has_popover_did_show_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(popoverDidShow:)];
			 ]"
		end

	objc_has_popover_will_close_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(popoverWillClose:)];
			 ]"
		end

	objc_has_popover_did_close_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(popoverDidClose:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_popover_should_close_ (an_item: POINTER; a_popover: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSPopoverDelegate>)$an_item popoverShouldClose:$a_popover];
			 ]"
		end

	objc_detachable_window_for_popover_ (an_item: POINTER; a_popover: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSPopoverDelegate>)$an_item detachableWindowForPopover:$a_popover];
			 ]"
		end

	objc_popover_will_show_ (an_item: POINTER; a_notification: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSPopoverDelegate>)$an_item popoverWillShow:$a_notification];
			 ]"
		end

	objc_popover_did_show_ (an_item: POINTER; a_notification: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSPopoverDelegate>)$an_item popoverDidShow:$a_notification];
			 ]"
		end

	objc_popover_will_close_ (an_item: POINTER; a_notification: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSPopoverDelegate>)$an_item popoverWillClose:$a_notification];
			 ]"
		end

	objc_popover_did_close_ (an_item: POINTER; a_notification: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSPopoverDelegate>)$an_item popoverDidClose:$a_notification];
			 ]"
		end

end