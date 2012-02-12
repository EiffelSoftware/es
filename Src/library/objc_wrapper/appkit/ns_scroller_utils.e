note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_SCROLLER_UTILS

inherit
	NS_CONTROL_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSScroller

	is_compatible_with_overlay_scrollers: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_is_compatible_with_overlay_scrollers (l_objc_class.item)
		end

	scroller_width_for_control_size__scroller_style_ (a_control_size: NATURAL_64; a_scroller_style: INTEGER_64): REAL_64
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_scroller_width_for_control_size__scroller_style_ (l_objc_class.item, a_control_size, a_scroller_style)
		end

	scroller_width_for_control_size_ (a_control_size: NATURAL_64): REAL_64
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_scroller_width_for_control_size_ (l_objc_class.item, a_control_size)
		end

	scroller_width: REAL_64
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_scroller_width (l_objc_class.item)
		end

	preferred_scroller_style: INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_preferred_scroller_style (l_objc_class.item)
		end

feature {NONE} -- NSScroller Externals

	objc_is_compatible_with_overlay_scrollers (a_class_object: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(Class)$a_class_object isCompatibleWithOverlayScrollers];
			 ]"
		end

	objc_scroller_width_for_control_size__scroller_style_ (a_class_object: POINTER; a_control_size: NATURAL_64; a_scroller_style: INTEGER_64): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(Class)$a_class_object scrollerWidthForControlSize:$a_control_size scrollerStyle:$a_scroller_style];
			 ]"
		end

	objc_scroller_width_for_control_size_ (a_class_object: POINTER; a_control_size: NATURAL_64): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(Class)$a_class_object scrollerWidthForControlSize:$a_control_size];
			 ]"
		end

	objc_scroller_width (a_class_object: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(Class)$a_class_object scrollerWidth];
			 ]"
		end

	objc_preferred_scroller_style (a_class_object: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(Class)$a_class_object preferredScrollerStyle];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSScroller"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end