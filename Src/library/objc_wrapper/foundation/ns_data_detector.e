note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_DATA_DETECTOR

inherit
	NS_REGULAR_EXPRESSION
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature {NONE} -- Initialization

--	make_with_types__error_ (a_checking_types: NATURAL_64; a_error: UNSUPPORTED_TYPE)
--			-- Initialize `Current'.
--		local
--			a_error__item: POINTER
--		do
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			make_with_pointer (objc_init_with_types__error_(allocate_object, a_checking_types, a_error__item))
--			if item = default_pointer then
--				-- TODO: handle initialization error.
--			end
--		end

feature {NONE} -- NSDataDetector Externals

--	objc_init_with_types__error_ (an_item: POINTER; a_checking_types: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSDataDetector *)$an_item initWithTypes:$a_checking_types error:];
--			 ]"
--		end

feature -- Properties

	checking_types: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_checking_types (item)
		end

feature {NONE} -- Properties Externals

	objc_checking_types (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSDataDetector *)$an_item checkingTypes];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSDataDetector"
		end

end