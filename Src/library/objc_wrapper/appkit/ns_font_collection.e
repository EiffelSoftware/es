note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FONT_COLLECTION

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_COPYING_PROTOCOL
	NS_MUTABLE_COPYING_PROTOCOL
	NS_CODING_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSFontCollection

	query_descriptors: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_query_descriptors (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like query_descriptors} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like query_descriptors} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	exclusion_descriptors: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_exclusion_descriptors (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like exclusion_descriptors} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like exclusion_descriptors} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	matching_descriptors: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_matching_descriptors (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like matching_descriptors} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like matching_descriptors} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	matching_descriptors_with_options_ (a_options: detachable NS_DICTIONARY): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_options__item: POINTER
		do
			if attached a_options as a_options_attached then
				a_options__item := a_options_attached.item
			end
			result_pointer := objc_matching_descriptors_with_options_ (item, a_options__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like matching_descriptors_with_options_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like matching_descriptors_with_options_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	matching_descriptors_for_family_ (a_family: detachable NS_STRING): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_family__item: POINTER
		do
			if attached a_family as a_family_attached then
				a_family__item := a_family_attached.item
			end
			result_pointer := objc_matching_descriptors_for_family_ (item, a_family__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like matching_descriptors_for_family_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like matching_descriptors_for_family_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	matching_descriptors_for_family__options_ (a_family: detachable NS_STRING; a_options: detachable NS_DICTIONARY): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_family__item: POINTER
			a_options__item: POINTER
		do
			if attached a_family as a_family_attached then
				a_family__item := a_family_attached.item
			end
			if attached a_options as a_options_attached then
				a_options__item := a_options_attached.item
			end
			result_pointer := objc_matching_descriptors_for_family__options_ (item, a_family__item, a_options__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like matching_descriptors_for_family__options_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like matching_descriptors_for_family__options_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSFontCollection Externals

	objc_query_descriptors (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item queryDescriptors];
			 ]"
		end

	objc_exclusion_descriptors (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item exclusionDescriptors];
			 ]"
		end

	objc_matching_descriptors (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item matchingDescriptors];
			 ]"
		end

	objc_matching_descriptors_with_options_ (an_item: POINTER; a_options: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item matchingDescriptorsWithOptions:$a_options];
			 ]"
		end

	objc_matching_descriptors_for_family_ (an_item: POINTER; a_family: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item matchingDescriptorsForFamily:$a_family];
			 ]"
		end

	objc_matching_descriptors_for_family__options_ (an_item: POINTER; a_family: POINTER; a_options: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFontCollection *)$an_item matchingDescriptorsForFamily:$a_family options:$a_options];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFontCollection"
		end

end