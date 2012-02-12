note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_JSON_SERIALIZATION_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSJSONSerialization

	is_valid_json_object_ (a_obj: detachable NS_OBJECT): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
			a_obj__item: POINTER
		do
			if attached a_obj as a_obj_attached then
				a_obj__item := a_obj_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			Result := objc_is_valid_json_object_ (l_objc_class.item, a_obj__item)
		end

--	data_with_json_object__options__error_ (a_obj: detachable NS_OBJECT; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): detachable NS_DATA
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			l_objc_class: OBJC_CLASS
--			a_obj__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_obj as a_obj_attached then
--				a_obj__item := a_obj_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			result_pointer := objc_data_with_json_object__options__error_ (l_objc_class.item, a_obj__item, a_opt, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like data_with_json_object__options__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like data_with_json_object__options__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	json_object_with_data__options__error_ (a_data: detachable NS_DATA; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): detachable NS_OBJECT
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			l_objc_class: OBJC_CLASS
--			a_data__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_data as a_data_attached then
--				a_data__item := a_data_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			result_pointer := objc_json_object_with_data__options__error_ (l_objc_class.item, a_data__item, a_opt, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like json_object_with_data__options__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like json_object_with_data__options__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	write_json_object__to_stream__options__error_ (a_obj: detachable NS_OBJECT; a_stream: detachable NS_OUTPUT_STREAM; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): INTEGER_64
--			-- Auto generated Objective-C wrapper.
--		local
--			l_objc_class: OBJC_CLASS
--			a_obj__item: POINTER
--			a_stream__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_obj as a_obj_attached then
--				a_obj__item := a_obj_attached.item
--			end
--			if attached a_stream as a_stream_attached then
--				a_stream__item := a_stream_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			Result := objc_write_json_object__to_stream__options__error_ (l_objc_class.item, a_obj__item, a_stream__item, a_opt, a_error__item)
--		end

--	json_object_with_stream__options__error_ (a_stream: detachable NS_INPUT_STREAM; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): detachable NS_OBJECT
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			l_objc_class: OBJC_CLASS
--			a_stream__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_stream as a_stream_attached then
--				a_stream__item := a_stream_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			result_pointer := objc_json_object_with_stream__options__error_ (l_objc_class.item, a_stream__item, a_opt, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like json_object_with_stream__options__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like json_object_with_stream__options__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

feature {NONE} -- NSJSONSerialization Externals

	objc_is_valid_json_object_ (a_class_object: POINTER; a_obj: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(Class)$a_class_object isValidJSONObject:$a_obj];
			 ]"
		end

--	objc_data_with_json_object__options__error_ (a_class_object: POINTER; a_obj: POINTER; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(Class)$a_class_object dataWithJSONObject:$a_obj options:$a_opt error:];
--			 ]"
--		end

--	objc_json_object_with_data__options__error_ (a_class_object: POINTER; a_data: POINTER; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(Class)$a_class_object JSONObjectWithData:$a_data options:$a_opt error:];
--			 ]"
--		end

--	objc_write_json_object__to_stream__options__error_ (a_class_object: POINTER; a_obj: POINTER; a_stream: POINTER; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): INTEGER_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(Class)$a_class_object writeJSONObject:$a_obj toStream:$a_stream options:$a_opt error:];
--			 ]"
--		end

--	objc_json_object_with_stream__options__error_ (a_class_object: POINTER; a_stream: POINTER; a_opt: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(Class)$a_class_object JSONObjectWithStream:$a_stream options:$a_opt error:];
--			 ]"
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSJSONSerialization"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end