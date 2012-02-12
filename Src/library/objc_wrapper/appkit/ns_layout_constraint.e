note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_LAYOUT_CONSTRAINT

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_ANIMATABLE_PROPERTY_CONTAINER_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- Properties

	priority: REAL_32 assign set_priority
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_priority (item)
		end

	set_priority (an_arg: REAL_32)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_priority (item, an_arg)
		end

	should_be_archived: BOOLEAN assign set_should_be_archived
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_should_be_archived (item)
		end

	set_should_be_archived (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_should_be_archived (item, an_arg)
		end

	first_item: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_first_item (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like first_item} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like first_item} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	first_attribute: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_first_attribute (item)
		end

	relation: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_relation (item)
		end

	second_item: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_second_item (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like second_item} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like second_item} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	second_attribute: INTEGER_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_second_attribute (item)
		end

	multiplier: REAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_multiplier (item)
		end

	constant: REAL_64 assign set_constant
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_constant (item)
		end

	set_constant (an_arg: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_constant (item, an_arg)
		end

feature {NONE} -- Properties Externals

	objc_priority (an_item: POINTER): REAL_32
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item priority];
			 ]"
		end

	objc_set_priority (an_item: POINTER; an_arg: REAL_32)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSLayoutConstraint *)$an_item setPriority:$an_arg]
			 ]"
		end

	objc_should_be_archived (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item shouldBeArchived];
			 ]"
		end

	objc_set_should_be_archived (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSLayoutConstraint *)$an_item setShouldBeArchived:$an_arg]
			 ]"
		end

	objc_first_item (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSLayoutConstraint *)$an_item firstItem];
			 ]"
		end

	objc_first_attribute (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item firstAttribute];
			 ]"
		end

	objc_relation (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item relation];
			 ]"
		end

	objc_second_item (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSLayoutConstraint *)$an_item secondItem];
			 ]"
		end

	objc_second_attribute (an_item: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item secondAttribute];
			 ]"
		end

	objc_multiplier (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item multiplier];
			 ]"
		end

	objc_constant (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSLayoutConstraint *)$an_item constant];
			 ]"
		end

	objc_set_constant (an_item: POINTER; an_arg: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSLayoutConstraint *)$an_item setConstant:$an_arg]
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSLayoutConstraint"
		end

end