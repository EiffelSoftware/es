note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_DRAGGING_SOURCE_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Required Methods

	dragging_session__source_operation_mask_for_dragging_context_ (a_session: detachable NS_DRAGGING_SESSION; a_context: INTEGER_64): NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
			a_session__item: POINTER
		do
			if attached a_session as a_session_attached then
				a_session__item := a_session_attached.item
			end
			Result := objc_dragging_session__source_operation_mask_for_dragging_context_ (item, a_session__item, a_context)
		end

feature {NONE} -- Required Methods Externals

	objc_dragging_session__source_operation_mask_for_dragging_context_ (an_item: POINTER; a_session: POINTER; a_context: INTEGER_64): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingSource>)$an_item draggingSession:$a_session sourceOperationMaskForDraggingContext:$a_context];
			 ]"
		end

feature -- Optional Methods

	dragging_session__will_begin_at_point_ (a_session: detachable NS_DRAGGING_SESSION; a_screen_point: NS_POINT)
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_session__will_begin_at_point_: has_dragging_session__will_begin_at_point_
		local
			a_session__item: POINTER
		do
			if attached a_session as a_session_attached then
				a_session__item := a_session_attached.item
			end
			objc_dragging_session__will_begin_at_point_ (item, a_session__item, a_screen_point.item)
		end

	dragging_session__moved_to_point_ (a_session: detachable NS_DRAGGING_SESSION; a_screen_point: NS_POINT)
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_session__moved_to_point_: has_dragging_session__moved_to_point_
		local
			a_session__item: POINTER
		do
			if attached a_session as a_session_attached then
				a_session__item := a_session_attached.item
			end
			objc_dragging_session__moved_to_point_ (item, a_session__item, a_screen_point.item)
		end

	dragging_session__ended_at_point__operation_ (a_session: detachable NS_DRAGGING_SESSION; a_screen_point: NS_POINT; a_operation: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		require
			has_dragging_session__ended_at_point__operation_: has_dragging_session__ended_at_point__operation_
		local
			a_session__item: POINTER
		do
			if attached a_session as a_session_attached then
				a_session__item := a_session_attached.item
			end
			objc_dragging_session__ended_at_point__operation_ (item, a_session__item, a_screen_point.item, a_operation)
		end

	ignore_modifier_keys_for_dragging_session_ (a_session: detachable NS_DRAGGING_SESSION): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_ignore_modifier_keys_for_dragging_session_: has_ignore_modifier_keys_for_dragging_session_
		local
			a_session__item: POINTER
		do
			if attached a_session as a_session_attached then
				a_session__item := a_session_attached.item
			end
			Result := objc_ignore_modifier_keys_for_dragging_session_ (item, a_session__item)
		end

feature -- Status Report

	has_dragging_session__will_begin_at_point_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_session__will_begin_at_point_ (item)
		end

	has_dragging_session__moved_to_point_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_session__moved_to_point_ (item)
		end

	has_dragging_session__ended_at_point__operation_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_dragging_session__ended_at_point__operation_ (item)
		end

	has_ignore_modifier_keys_for_dragging_session_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_ignore_modifier_keys_for_dragging_session_ (item)
		end

feature -- Status Report Externals

	objc_has_dragging_session__will_begin_at_point_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingSession:willBeginAtPoint:)];
			 ]"
		end

	objc_has_dragging_session__moved_to_point_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingSession:movedToPoint:)];
			 ]"
		end

	objc_has_dragging_session__ended_at_point__operation_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(draggingSession:endedAtPoint:operation:)];
			 ]"
		end

	objc_has_ignore_modifier_keys_for_dragging_session_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(ignoreModifierKeysForDraggingSession:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_dragging_session__will_begin_at_point_ (an_item: POINTER; a_session: POINTER; a_screen_point: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingSource>)$an_item draggingSession:$a_session willBeginAtPoint:*((NSPoint *)$a_screen_point)];
			 ]"
		end

	objc_dragging_session__moved_to_point_ (an_item: POINTER; a_session: POINTER; a_screen_point: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingSource>)$an_item draggingSession:$a_session movedToPoint:*((NSPoint *)$a_screen_point)];
			 ]"
		end

	objc_dragging_session__ended_at_point__operation_ (an_item: POINTER; a_session: POINTER; a_screen_point: POINTER; a_operation: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(id <NSDraggingSource>)$an_item draggingSession:$a_session endedAtPoint:*((NSPoint *)$a_screen_point) operation:$a_operation];
			 ]"
		end

	objc_ignore_modifier_keys_for_dragging_session_ (an_item: POINTER; a_session: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(id <NSDraggingSource>)$an_item ignoreModifierKeysForDraggingSession:$a_session];
			 ]"
		end

end