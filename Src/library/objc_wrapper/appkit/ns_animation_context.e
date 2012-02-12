note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_ANIMATION_CONTEXT

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

feature -- NSAnimationContext

	set_duration_ (a_duration: REAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_duration_ (item, a_duration)
		end

	duration: REAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_duration (item)
		end

--	timing_function: detachable UNSUPPORTED_TYPE
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_timing_function (item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like timing_function} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like timing_function} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	set_timing_function_ (a_new_timing_function: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_set_timing_function_ (item, )
--		end

--	completion_handler: UNSUPPORTED_TYPE
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			Result := objc_completion_handler (item)
--		end

--	set_completion_handler_ (a_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_set_completion_handler_ (item, )
--		end

feature {NONE} -- NSAnimationContext Externals

	objc_set_duration_ (an_item: POINTER; a_duration: REAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSAnimationContext *)$an_item setDuration:$a_duration];
			 ]"
		end

	objc_duration (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSAnimationContext *)$an_item duration];
			 ]"
		end

--	objc_timing_function (an_item: POINTER): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSAnimationContext *)$an_item timingFunction];
--			 ]"
--		end

--	objc_set_timing_function_ (an_item: POINTER; a_new_timing_function: POINTER)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				[(NSAnimationContext *)$an_item setTimingFunction:$a_new_timing_function];
--			 ]"
--		end

--	objc_completion_handler (an_item: POINTER): UNSUPPORTED_TYPE
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(NSAnimationContext *)$an_item completionHandler];
--			 ]"
--		end

--	objc_set_completion_handler_ (an_item: POINTER; a_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				[(NSAnimationContext *)$an_item setCompletionHandler:];
--			 ]"
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSAnimationContext"
		end

end