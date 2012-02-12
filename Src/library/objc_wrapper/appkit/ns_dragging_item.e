note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_DRAGGING_ITEM

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_pasteboard_writer_,
	make

feature {NONE} -- Initialization

	make_with_pasteboard_writer_ (a_pasteboard_writer: detachable NS_PASTEBOARD_WRITING_PROTOCOL)
			-- Initialize `Current'.
		local
			a_pasteboard_writer__item: POINTER
		do
			if attached a_pasteboard_writer as a_pasteboard_writer_attached then
				a_pasteboard_writer__item := a_pasteboard_writer_attached.item
			end
			make_with_pointer (objc_init_with_pasteboard_writer_(allocate_object, a_pasteboard_writer__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSDraggingItem Externals

	objc_init_with_pasteboard_writer_ (an_item: POINTER; a_pasteboard_writer: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingItem *)$an_item initWithPasteboardWriter:$a_pasteboard_writer];
			 ]"
		end

	objc_set_dragging_frame__contents_ (an_item: POINTER; a_frame: POINTER; a_contents: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingItem *)$an_item setDraggingFrame:*((NSRect *)$a_frame) contents:$a_contents];
			 ]"
		end

feature -- NSDraggingItem

	set_dragging_frame__contents_ (a_frame: NS_RECT; a_contents: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			a_contents__item: POINTER
		do
			if attached a_contents as a_contents_attached then
				a_contents__item := a_contents_attached.item
			end
			objc_set_dragging_frame__contents_ (item, a_frame.item, a_contents__item)
		end

feature -- Properties

	item_objc: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_item (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like item_objc} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like item_objc} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	dragging_frame: NS_RECT assign set_dragging_frame
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_dragging_frame (item, Result.item)
		end

	set_dragging_frame (an_arg: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_dragging_frame (item, an_arg.item)
		end

	image_components: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_image_components (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like image_components} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like image_components} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- Properties Externals

	objc_item (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingItem *)$an_item item];
			 ]"
		end

	objc_dragging_frame (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSRect *)$result_pointer = [(NSDraggingItem *)$an_item draggingFrame];
			 ]"
		end

	objc_set_dragging_frame (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingItem *)$an_item setDraggingFrame:*((NSRect *)$an_arg)]
			 ]"
		end

	objc_image_components (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingItem *)$an_item imageComponents];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSDraggingItem"
		end

end