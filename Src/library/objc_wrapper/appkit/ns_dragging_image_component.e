note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_DRAGGING_IMAGE_COMPONENT

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_key_,
	make

feature {NONE} -- Initialization

	make_with_key_ (a_key: detachable NS_STRING)
			-- Initialize `Current'.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			make_with_pointer (objc_init_with_key_(allocate_object, a_key__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSDraggingImageComponent Externals

	objc_init_with_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingImageComponent *)$an_item initWithKey:$a_key];
			 ]"
		end

feature -- Properties

	key: detachable NS_STRING assign set_key
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_key (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like key} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like key} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_key (an_arg: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_key (item, an_arg__item)
		end

	contents: detachable NS_OBJECT assign set_contents
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_contents (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like contents} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like contents} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_contents (an_arg: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_contents (item, an_arg__item)
		end

	frame: NS_RECT assign set_frame
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_frame (item, Result.item)
		end

	set_frame (an_arg: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_frame (item, an_arg.item)
		end

feature {NONE} -- Properties Externals

	objc_key (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingImageComponent *)$an_item key];
			 ]"
		end

	objc_set_key (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingImageComponent *)$an_item setKey:$an_arg]
			 ]"
		end

	objc_contents (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingImageComponent *)$an_item contents];
			 ]"
		end

	objc_set_contents (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingImageComponent *)$an_item setContents:$an_arg]
			 ]"
		end

	objc_frame (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSRect *)$result_pointer = [(NSDraggingImageComponent *)$an_item frame];
			 ]"
		end

	objc_set_frame (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingImageComponent *)$an_item setFrame:*((NSRect *)$an_arg)]
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSDraggingImageComponent"
		end

end