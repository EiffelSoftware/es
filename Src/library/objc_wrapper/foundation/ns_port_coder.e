note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_PORT_CODER

inherit
	NS_CODER
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSPortCoder

	is_bycopy: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_is_bycopy (item)
		end

	is_byref: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_is_byref (item)
		end

--	encode_port_object_ (a_aport: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_aport__item: POINTER
--		do
--			if attached a_aport as a_aport_attached then
--				a_aport__item := a_aport_attached.item
--			end
--			objc_encode_port_object_ (item, a_aport__item)
--		end

--	decode_port_object: UNSUPPORTED_TYPE
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_decode_port_object (item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like decode_port_object} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like decode_port_object} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

feature {NONE} -- NSPortCoder Externals

	objc_is_bycopy (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSPortCoder *)$an_item isBycopy];
			 ]"
		end

	objc_is_byref (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSPortCoder *)$an_item isByref];
			 ]"
		end

--	objc_encode_port_object_ (an_item: POINTER; a_aport: POINTER)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSPortCoder *)$an_item encodePortObject:$a_aport];
--			 ]"
--		end

--	objc_decode_port_object (an_item: POINTER): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSPortCoder *)$an_item decodePortObject];
--			 ]"
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSPortCoder"
		end

end