note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_TEXT_FINDER

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_CODING_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSTextFinder

	perform_action_ (a_op: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_perform_action_ (item, a_op)
		end

	validate_action_ (a_op: INTEGER_64): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_validate_action_ (item, a_op)
		end

	cancel_find_indicator
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_cancel_find_indicator (item)
		end

	note_client_string_will_change
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_note_client_string_will_change (item)
		end

feature {NONE} -- NSTextFinder Externals

	objc_perform_action_ (an_item: POINTER; a_op: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item performAction:$a_op];
			 ]"
		end

	objc_validate_action_ (an_item: POINTER; a_op: INTEGER_64): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTextFinder *)$an_item validateAction:$a_op];
			 ]"
		end

	objc_cancel_find_indicator (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item cancelFindIndicator];
			 ]"
		end

	objc_note_client_string_will_change (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item noteClientStringWillChange];
			 ]"
		end

feature -- Properties

	client: detachable NS_TEXT_FINDER_CLIENT_PROTOCOL assign set_client
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_client (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like client} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like client} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_client (an_arg: detachable NS_TEXT_FINDER_CLIENT_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_client (item, an_arg__item)
		end

	find_bar_container: detachable NS_TEXT_FINDER_BAR_CONTAINER_PROTOCOL assign set_find_bar_container
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_find_bar_container (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like find_bar_container} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like find_bar_container} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_find_bar_container (an_arg: detachable NS_TEXT_FINDER_BAR_CONTAINER_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		local
			an_arg__item: POINTER
		do
			if attached an_arg as an_arg_attached then
				an_arg__item := an_arg_attached.item
			end
			objc_set_find_bar_container (item, an_arg__item)
		end

	find_indicator_needs_update: BOOLEAN assign set_find_indicator_needs_update
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_find_indicator_needs_update (item)
		end

	set_find_indicator_needs_update (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_find_indicator_needs_update (item, an_arg)
		end

	is_incremental_searching_enabled: BOOLEAN assign set_incremental_searching_enabled
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_incremental_searching_enabled (item)
		end

	set_incremental_searching_enabled (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_incremental_searching_enabled (item, an_arg)
		end

	incremental_searching_should_dim_content_view: BOOLEAN assign set_incremental_searching_should_dim_content_view
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_incremental_searching_should_dim_content_view (item)
		end

	set_incremental_searching_should_dim_content_view (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_incremental_searching_should_dim_content_view (item, an_arg)
		end

	incremental_match_ranges: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_incremental_match_ranges (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like incremental_match_ranges} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like incremental_match_ranges} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- Properties Externals

	objc_client (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextFinder *)$an_item client];
			 ]"
		end

	objc_set_client (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item setClient:$an_arg]
			 ]"
		end

	objc_find_bar_container (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextFinder *)$an_item findBarContainer];
			 ]"
		end

	objc_set_find_bar_container (an_item: POINTER; an_arg: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item setFindBarContainer:$an_arg]
			 ]"
		end

	objc_find_indicator_needs_update (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTextFinder *)$an_item findIndicatorNeedsUpdate];
			 ]"
		end

	objc_set_find_indicator_needs_update (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item setFindIndicatorNeedsUpdate:$an_arg]
			 ]"
		end

	objc_is_incremental_searching_enabled (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTextFinder *)$an_item isIncrementalSearchingEnabled];
			 ]"
		end

	objc_set_incremental_searching_enabled (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item setIncrementalSearchingEnabled:$an_arg]
			 ]"
		end

	objc_incremental_searching_should_dim_content_view (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSTextFinder *)$an_item incrementalSearchingShouldDimContentView];
			 ]"
		end

	objc_set_incremental_searching_should_dim_content_view (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSTextFinder *)$an_item setIncrementalSearchingShouldDimContentView:$an_arg]
			 ]"
		end

	objc_incremental_match_ranges (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextFinder *)$an_item incrementalMatchRanges];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSTextFinder"
		end

end