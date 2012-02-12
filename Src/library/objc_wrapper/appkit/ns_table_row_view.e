note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_TABLE_ROW_VIEW

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

feature -- NSTableRowView

	draw_background_in_rect_ (a_dirty_rect: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_draw_background_in_rect_ (item, a_dirty_rect.item)
		end

	draw_selection_in_rect_ (a_dirty_rect: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_draw_selection_in_rect_ (item, a_dirty_rect.item)
		end

	draw_separator_in_rect_ (a_dirty_rect: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_draw_separator_in_rect_ (item, a_dirty_rect.item)
		end

	draw_dragging_destination_feedback_in_rect_ (a_dirty_rect: NS_RECT)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_draw_dragging_destination_feedback_in_rect_ (item, a_dirty_rect.item)
		end

	view_at_column_ (a_column: INTEGER_64): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_view_at_column_ (item, a_column)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like view_at_column_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like view_at_column_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSTableRowView Externals

	objc_draw_background_in_rect_ (an_item: POINTER; a_dirty_rect: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item drawBackgroundInRect:*((NSRect *)$a_dirty_rect)];
			 ]"
		end

	objc_draw_selection_in_rect_ (an_item: POINTER; a_dirty_rect: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item drawSelectionInRect:*((NSRect *)$a_dirty_rect)];
			 ]"
		end

	objc_draw_separator_in_rect_ (an_item: POINTER; a_dirty_rect: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item drawSeparatorInRect:*((NSRect *)$a_dirty_rect)];
			 ]"
		end

	objc_draw_dragging_destination_feedback_in_rect_ (an_item: POINTER; a_dirty_rect: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item drawDraggingDestinationFeedbackInRect:*((NSRect *)$a_dirty_rect)];
			 ]"
		end

	objc_view_at_column_ (an_item: POINTER; a_column: INTEGER_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableRowView *)$an_item viewAtColumn:$a_column];
			 ]"
		end

feature -- Properties

	selection_highlight_style: INTEGER_64 assign set_selection_highlight_style
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_selection_highlight_style (item)
		end

	set_selection_highlight_style (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_selection_highlight_style (item, an_arg)
		end

	is_emphasized: BOOLEAN assign set_emphasized
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_emphasized (item)
		end

	set_emphasized (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_emphasized (item, an_arg)
		end

	is_group_row_style: BOOLEAN assign set_group_row_style
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_group_row_style (item)
		end

	set_group_row_style (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_group_row_style (item, an_arg)
		end

	is_selected: BOOLEAN assign set_selected
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_selected (item)
		end

	set_selected (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_selected (item, an_arg)
		end

	is_floating: BOOLEAN assign set_floating
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_floating (item)
		end

	set_floating (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_floating (item, an_arg)
		end

	is_target_for_drop_operation: BOOLEAN assign set_target_for_drop_operation
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_target_for_drop_operation (item)
		end

	set_target_for_drop_operation (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_target_for_drop_operation (item, an_arg)
		end

	dragging_destination_feedback_style: INTEGER_64 assign set_dragging_destination_feedback_style
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_dragging_destination_feedback_style (item)
		end

	set_dragging_destination_feedback_style (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_dragging_destination_feedback_style (item, an_arg)
		end

	indentation_for_drop_operation: REAL_64 assign set_indentation_for_drop_operation
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_indentation_for_drop_operation (item)
		end

	set_indentation_for_drop_operation (an_arg: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_indentation_for_drop_operation (item, an_arg)
		end

	interior_background_style: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_interior_background_style (item)
		end

	background_color: detachable NS_COLOR assign set_background_color
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_background_color (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like background_color} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like background_color} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_background_color (an_arg: detachable NS_COLOR)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_background_color (item, an_arg__item)
		end

	number_of_columns: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_number_of_columns (item)
		end

feature {NONE} -- Properties Externals

	objc_selection_highlight_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item selectionHighlightStyle];
			 ]"
		end

	objc_set_selection_highlight_style (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setSelectionHighlightStyle:$an_arg]
			 ]"
		end

	objc_is_emphasized (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item isEmphasized];
			 ]"
		end

	objc_set_emphasized (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setEmphasized:$an_arg]
			 ]"
		end

	objc_is_group_row_style (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item isGroupRowStyle];
			 ]"
		end

	objc_set_group_row_style (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setGroupRowStyle:$an_arg]
			 ]"
		end

	objc_is_selected (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item isSelected];
			 ]"
		end

	objc_set_selected (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setSelected:$an_arg]
			 ]"
		end

	objc_is_floating (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item isFloating];
			 ]"
		end

	objc_set_floating (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setFloating:$an_arg]
			 ]"
		end

	objc_is_target_for_drop_operation (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item isTargetForDropOperation];
			 ]"
		end

	objc_set_target_for_drop_operation (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setTargetForDropOperation:$an_arg]
			 ]"
		end

	objc_dragging_destination_feedback_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item draggingDestinationFeedbackStyle];
			 ]"
		end

	objc_set_dragging_destination_feedback_style (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setDraggingDestinationFeedbackStyle:$an_arg]
			 ]"
		end

	objc_indentation_for_drop_operation (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item indentationForDropOperation];
			 ]"
		end

	objc_set_indentation_for_drop_operation (an_item: POINTER; an_arg: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setIndentationForDropOperation:$an_arg]
			 ]"
		end

	objc_interior_background_style (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item interiorBackgroundStyle];
			 ]"
		end

	objc_background_color (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTableRowView *)$an_item backgroundColor];
			 ]"
		end

	objc_set_background_color (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTableRowView *)$an_item setBackgroundColor:$an_arg]
			 ]"
		end

	objc_number_of_columns (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTableRowView *)$an_item numberOfColumns];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSTableRowView"
		end

end