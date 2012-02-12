note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_POPOVER

inherit
	NS_RESPONDER
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSPopover

	show_relative_to_rect__of_view__preferred_edge_ (a_positioning_rect: NS_RECT; a_positioning_view: detachable NS_VIEW; a_preferred_edge: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
			a_positioning_view__item: POINTER
		do
			if attached a_positioning_view as a_positioning_view_attached then
				a_positioning_view__item := a_positioning_view_attached.item
			end
			objc_show_relative_to_rect__of_view__preferred_edge_ (item, a_positioning_rect.item, a_positioning_view__item, a_preferred_edge)
		end

	perform_close_ (a_sender: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			a_sender__item: POINTER
		do
			if attached a_sender as a_sender_attached then
				a_sender__item := a_sender_attached.item
			end
			objc_perform_close_ (item, a_sender__item)
		end

	close
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_close (item)
		end

feature {NONE} -- NSPopover Externals

	objc_show_relative_to_rect__of_view__preferred_edge_ (an_item: POINTER; a_positioning_rect: POINTER; a_positioning_view: POINTER; a_preferred_edge: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item showRelativeToRect:*((NSRect *)$a_positioning_rect) ofView:$a_positioning_view preferredEdge:$a_preferred_edge];
			 ]"
		end

	objc_perform_close_ (an_item: POINTER; a_sender: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item performClose:$a_sender];
			 ]"
		end

	objc_close (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item close];
			 ]"
		end

feature -- Properties

	delegate: detachable NS_POPOVER_DELEGATE_PROTOCOL assign set_delegate
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_delegate (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like delegate} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like delegate} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_delegate (an_arg: detachable NS_POPOVER_DELEGATE_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_delegate (item, an_arg__item)
		end

	appearance: INTEGER_64 assign set_appearance
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_appearance (item)
		end

	set_appearance (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_appearance (item, an_arg)
		end

	behavior: INTEGER_64 assign set_behavior
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_behavior (item)
		end

	set_behavior (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_behavior (item, an_arg)
		end

	animates: BOOLEAN assign set_animates
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_animates (item)
		end

	set_animates (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_animates (item, an_arg)
		end

	content_view_controller: detachable NS_VIEW_CONTROLLER assign set_content_view_controller
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_content_view_controller (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like content_view_controller} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like content_view_controller} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_content_view_controller (an_arg: detachable NS_VIEW_CONTROLLER)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_content_view_controller (item, an_arg__item)
		end

	content_size: NS_SIZE assign set_content_size
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_content_size (item, Result.item)
		end

	set_content_size (an_arg: NS_SIZE)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_content_size (item, an_arg.item)
		end

	is_shown: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_shown (item)
		end

	positioning_rect: NS_RECT assign set_positioning_rect
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_positioning_rect (item, Result.item)
		end

	set_positioning_rect (an_arg: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_positioning_rect (item, an_arg.item)
		end

feature {NONE} -- Properties Externals

	objc_delegate (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSPopover *)$an_item delegate];
			 ]"
		end

	objc_set_delegate (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setDelegate:$an_arg]
			 ]"
		end

	objc_appearance (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSPopover *)$an_item appearance];
			 ]"
		end

	objc_set_appearance (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setAppearance:$an_arg]
			 ]"
		end

	objc_behavior (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSPopover *)$an_item behavior];
			 ]"
		end

	objc_set_behavior (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setBehavior:$an_arg]
			 ]"
		end

	objc_animates (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSPopover *)$an_item animates];
			 ]"
		end

	objc_set_animates (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setAnimates:$an_arg]
			 ]"
		end

	objc_content_view_controller (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSPopover *)$an_item contentViewController];
			 ]"
		end

	objc_set_content_view_controller (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setContentViewController:$an_arg]
			 ]"
		end

	objc_content_size (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSSize *)$result_pointer = [(NSPopover *)$an_item contentSize];
			 ]"
		end

	objc_set_content_size (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setContentSize:*((NSSize *)$an_arg)]
			 ]"
		end

	objc_is_shown (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSPopover *)$an_item isShown];
			 ]"
		end

	objc_positioning_rect (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSRect *)$result_pointer = [(NSPopover *)$an_item positioningRect];
			 ]"
		end

	objc_set_positioning_rect (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSPopover *)$an_item setPositioningRect:*((NSRect *)$an_arg)]
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSPopover"
		end

end