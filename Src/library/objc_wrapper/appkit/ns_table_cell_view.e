note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_TABLE_CELL_VIEW

inherit
	NS_VIEW
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_frame_,
	make

feature -- Properties

	object_value: detachable NS_OBJECT assign set_object_value
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_object_value (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_value} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_value} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_object_value (an_arg: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_object_value (item, an_arg__item)
		end

	text_field: detachable NS_TEXT_FIELD assign set_text_field
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_text_field (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like text_field} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like text_field} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_text_field (an_arg: detachable NS_TEXT_FIELD)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_text_field (item, an_arg__item)
		end

	image_view: detachable NS_IMAGE_VIEW assign set_image_view
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_image_view (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like image_view} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like image_view} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_image_view (an_arg: detachable NS_IMAGE_VIEW)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_image_view (item, an_arg__item)
		end

	background_style: INTEGER_64 assign set_background_style
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_background_style (item)
		end

	set_background_style (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_background_style (item, an_arg)
		end

	row_size_style: INTEGER_64 assign set_row_size_style
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_row_size_style (item)
		end

	set_row_size_style (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_row_size_style (item, an_arg)
		end

	dragging_image_components: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_dragging_image_components (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like dragging_image_components} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like dragging_image_components} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- Properties Externals

	objc_object_value (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableCellView *)$an_item objectValue];
			 ]"
		end

	objc_set_object_value (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableCellView *)$an_item setObjectValue:$an_arg]
			 ]"
		end

	objc_text_field (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableCellView *)$an_item textField];
			 ]"
		end

	objc_set_text_field (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableCellView *)$an_item setTextField:$an_arg]
			 ]"
		end

	objc_image_view (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableCellView *)$an_item imageView];
			 ]"
		end

	objc_set_image_view (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableCellView *)$an_item setImageView:$an_arg]
			 ]"
		end

	objc_background_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableCellView *)$an_item backgroundStyle];
			 ]"
		end

	objc_set_background_style (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableCellView *)$an_item setBackgroundStyle:$an_arg]
			 ]"
		end

	objc_row_size_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableCellView *)$an_item rowSizeStyle];
			 ]"
		end

	objc_set_row_size_style (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableCellView *)$an_item setRowSizeStyle:$an_arg]
			 ]"
		end

	objc_dragging_image_components (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableCellView *)$an_item draggingImageComponents];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSTableCellView"
		end

end