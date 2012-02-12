note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_DRAGGING_DESTINATION_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

	dragging_entered_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL): NATURAL_64
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_entered_: has_dragging_entered_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			Result := objc_dragging_entered_ (item, a_sender__item)
		end

	dragging_updated_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL): NATURAL_64
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_updated_: has_dragging_updated_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			Result := objc_dragging_updated_ (item, a_sender__item)
		end

	dragging_exited_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_exited_: has_dragging_exited_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			objc_dragging_exited_ (item, a_sender__item)
		end

	prepare_for_drag_operation_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_prepare_for_drag_operation_: has_prepare_for_drag_operation_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			Result := objc_prepare_for_drag_operation_ (item, a_sender__item)
		end

	perform_drag_operation_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_perform_drag_operation_: has_perform_drag_operation_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			Result := objc_perform_drag_operation_ (item, a_sender__item)
		end

	conclude_drag_operation_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		require
			has_conclude_drag_operation_: has_conclude_drag_operation_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			objc_conclude_drag_operation_ (item, a_sender__item)
		end

	dragging_ended_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_ended_: has_dragging_ended_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			objc_dragging_ended_ (item, a_sender__item)
		end

	wants_periodic_dragging_updates: BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_wants_periodic_dragging_updates: has_wants_periodic_dragging_updates
		local
		do
			Result := objc_wants_periodic_dragging_updates (item)
		end

	update_dragging_items_for_drag_ (a_sender: detachable NS_DRAGGING_INFO_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		require
			has_update_dragging_items_for_drag_: has_update_dragging_items_for_drag_
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			objc_update_dragging_items_for_drag_ (item, a_sender__item)
		end

feature -- Status Report

	has_dragging_entered_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_entered_ (item)
		end

	has_dragging_updated_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_updated_ (item)
		end

	has_dragging_exited_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_exited_ (item)
		end

	has_prepare_for_drag_operation_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_prepare_for_drag_operation_ (item)
		end

	has_perform_drag_operation_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_perform_drag_operation_ (item)
		end

	has_conclude_drag_operation_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_conclude_drag_operation_ (item)
		end

	has_dragging_ended_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_ended_ (item)
		end

	has_wants_periodic_dragging_updates: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_wants_periodic_dragging_updates (item)
		end

	has_update_dragging_items_for_drag_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_update_dragging_items_for_drag_ (item)
		end

feature -- Status Report Externals

	objc_has_dragging_entered_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingEntered:)];
			 ]"
		end

	objc_has_dragging_updated_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingUpdated:)];
			 ]"
		end

	objc_has_dragging_exited_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingExited:)];
			 ]"
		end

	objc_has_prepare_for_drag_operation_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(prepareForDragOperation:)];
			 ]"
		end

	objc_has_perform_drag_operation_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(performDragOperation:)];
			 ]"
		end

	objc_has_conclude_drag_operation_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(concludeDragOperation:)];
			 ]"
		end

	objc_has_dragging_ended_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingEnded:)];
			 ]"
		end

	objc_has_wants_periodic_dragging_updates (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(wantsPeriodicDraggingUpdates)];
			 ]"
		end

	objc_has_update_dragging_items_for_drag_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(updateDraggingItemsForDrag:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_dragging_entered_ (an_item: POINTER; a_sender: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingDestination>)$an_item draggingEntered:$a_sender];
			 ]"
		end

	objc_dragging_updated_ (an_item: POINTER; a_sender: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingDestination>)$an_item draggingUpdated:$a_sender];
			 ]"
		end

	objc_dragging_exited_ (an_item: POINTER; a_sender: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingDestination>)$an_item draggingExited:$a_sender];
			 ]"
		end

	objc_prepare_for_drag_operation_ (an_item: POINTER; a_sender: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingDestination>)$an_item prepareForDragOperation:$a_sender];
			 ]"
		end

	objc_perform_drag_operation_ (an_item: POINTER; a_sender: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingDestination>)$an_item performDragOperation:$a_sender];
			 ]"
		end

	objc_conclude_drag_operation_ (an_item: POINTER; a_sender: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingDestination>)$an_item concludeDragOperation:$a_sender];
			 ]"
		end

	objc_dragging_ended_ (an_item: POINTER; a_sender: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingDestination>)$an_item draggingEnded:$a_sender];
			 ]"
		end

	objc_wants_periodic_dragging_updates (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingDestination>)$an_item wantsPeriodicDraggingUpdates];
			 ]"
		end

	objc_update_dragging_items_for_drag_ (an_item: POINTER; a_sender: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingDestination>)$an_item updateDraggingItemsForDrag:$a_sender];
			 ]"
		end

end