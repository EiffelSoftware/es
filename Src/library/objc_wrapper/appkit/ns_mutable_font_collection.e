note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_MUTABLE_FONT_COLLECTION

inherit
	NS_FONT_COLLECTION
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSMutableFontCollection

	set_query_descriptors_ (a_descriptors: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_descriptors__item: POINTER
		do
			if attached a_descriptors as a_descriptors_attached then
				a_descriptors__item := a_descriptors_attached.item
			end
			objc_set_query_descriptors_ (item, a_descriptors__item)
		end

	set_exclusion_descriptors_ (a_descriptors: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_descriptors__item: POINTER
		do
			if attached a_descriptors as a_descriptors_attached then
				a_descriptors__item := a_descriptors_attached.item
			end
			objc_set_exclusion_descriptors_ (item, a_descriptors__item)
		end

	add_query_for_descriptors_ (a_descriptors: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_descriptors__item: POINTER
		do
			if attached a_descriptors as a_descriptors_attached then
				a_descriptors__item := a_descriptors_attached.item
			end
			objc_add_query_for_descriptors_ (item, a_descriptors__item)
		end

	remove_query_for_descriptors_ (a_descriptors: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_descriptors__item: POINTER
		do
			if attached a_descriptors as a_descriptors_attached then
				a_descriptors__item := a_descriptors_attached.item
			end
			objc_remove_query_for_descriptors_ (item, a_descriptors__item)
		end

feature {NONE} -- NSMutableFontCollection Externals

	objc_set_query_descriptors_ (an_item: POINTER; a_descriptors: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSMutableFontCollection *)$an_item setQueryDescriptors:$a_descriptors];
			 ]"
		end

	objc_set_exclusion_descriptors_ (an_item: POINTER; a_descriptors: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSMutableFontCollection *)$an_item setExclusionDescriptors:$a_descriptors];
			 ]"
		end

	objc_add_query_for_descriptors_ (an_item: POINTER; a_descriptors: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSMutableFontCollection *)$an_item addQueryForDescriptors:$a_descriptors];
			 ]"
		end

	objc_remove_query_for_descriptors_ (an_item: POINTER; a_descriptors: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSMutableFontCollection *)$an_item removeQueryForDescriptors:$a_descriptors];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSMutableFontCollection"
		end

end