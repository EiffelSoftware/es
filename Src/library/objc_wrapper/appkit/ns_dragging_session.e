note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_DRAGGING_SESSION

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSDraggingSession

--	enumerate_dragging_items_with_options__for_view__classes__search_options__using_block_ (a_enum_opts: NATURAL_64; a_view: detachable NS_VIEW; a_class_array: detachable NS_ARRAY; a_search_options: detachable NS_DICTIONARY; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_view__item: POINTER
--			a_class_array__item: POINTER
--			a_search_options__item: POINTER
--		do
--			if attached a_view as a_view_attached then
--				a_view__item := a_view_attached.item
--			end
--			if attached a_class_array as a_class_array_attached then
--				a_class_array__item := a_class_array_attached.item
--			end
--			if attached a_search_options as a_search_options_attached then
--				a_search_options__item := a_search_options_attached.item
--			end
--			objc_enumerate_dragging_items_with_options__for_view__classes__search_options__using_block_ (item, a_enum_opts, a_view__item, a_class_array__item, a_search_options__item, )
--		end

feature {NONE} -- NSDraggingSession Externals

--	objc_enumerate_dragging_items_with_options__for_view__classes__search_options__using_block_ (an_item: POINTER; a_enum_opts: NATURAL_64; a_view: POINTER; a_class_array: POINTER; a_search_options: POINTER; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				[(NSDraggingSession *)$an_item enumerateDraggingItemsWithOptions:$a_enum_opts forView:$a_view classes:$a_class_array searchOptions:$a_search_options usingBlock:];
--			 ]"
--		end

feature -- Properties

	dragging_formation: INTEGER_64 assign set_dragging_formation
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_dragging_formation (item)
		end

	set_dragging_formation (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_dragging_formation (item, an_arg)
		end

	animates_to_starting_positions_on_cancel_or_fail: BOOLEAN assign set_animates_to_starting_positions_on_cancel_or_fail
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_animates_to_starting_positions_on_cancel_or_fail (item)
		end

	set_animates_to_starting_positions_on_cancel_or_fail (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_animates_to_starting_positions_on_cancel_or_fail (item, an_arg)
		end

	dragging_leader_index: INTEGER_64 assign set_dragging_leader_index
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_dragging_leader_index (item)
		end

	set_dragging_leader_index (an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_dragging_leader_index (item, an_arg)
		end

	dragging_pasteboard: detachable NS_PASTEBOARD
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_dragging_pasteboard (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like dragging_pasteboard} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like dragging_pasteboard} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	dragging_sequence_number: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_dragging_sequence_number (item)
		end

	dragging_location: NS_POINT
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_dragging_location (item, Result.item)
		end

feature {NONE} -- Properties Externals

	objc_dragging_formation (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSDraggingSession *)$an_item draggingFormation];
			 ]"
		end

	objc_set_dragging_formation (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingSession *)$an_item setDraggingFormation:$an_arg]
			 ]"
		end

	objc_animates_to_starting_positions_on_cancel_or_fail (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSDraggingSession *)$an_item animatesToStartingPositionsOnCancelOrFail];
			 ]"
		end

	objc_set_animates_to_starting_positions_on_cancel_or_fail (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingSession *)$an_item setAnimatesToStartingPositionsOnCancelOrFail:$an_arg]
			 ]"
		end

	objc_dragging_leader_index (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSDraggingSession *)$an_item draggingLeaderIndex];
			 ]"
		end

	objc_set_dragging_leader_index (an_item: POINTER; an_arg: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSDraggingSession *)$an_item setDraggingLeaderIndex:$an_arg]
			 ]"
		end

	objc_dragging_pasteboard (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSDraggingSession *)$an_item draggingPasteboard];
			 ]"
		end

	objc_dragging_sequence_number (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSDraggingSession *)$an_item draggingSequenceNumber];
			 ]"
		end

	objc_dragging_location (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				*(NSPoint *)$result_pointer = [(NSDraggingSession *)$an_item draggingLocation];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSDraggingSession"
		end

end