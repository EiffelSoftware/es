note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_UBIQUITOUS_KEY_VALUE_STORE

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

feature -- NSUbiquitousKeyValueStore

	object_for_key_ (a_key: detachable NS_STRING): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			result_pointer := objc_object_for_key_ (item, a_key__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_for_key_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_for_key_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_object__for_key_ (an_object: detachable NS_OBJECT; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			an_object__item: POINTER
			a_key__item: POINTER
		do
			if attached an_object as an_object_attached then
				an_object__item := an_object_attached.item
			end
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_object__for_key_ (item, an_object__item, a_key__item)
		end

	remove_object_for_key_ (a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_remove_object_for_key_ (item, a_key__item)
		end

	string_for_key_ (a_key: detachable NS_STRING): detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			result_pointer := objc_string_for_key_ (item, a_key__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like string_for_key_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like string_for_key_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	array_for_key_ (a_key: detachable NS_STRING): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			result_pointer := objc_array_for_key_ (item, a_key__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like array_for_key_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like array_for_key_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	dictionary_for_key_ (a_key: detachable NS_STRING): detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			result_pointer := objc_dictionary_for_key_ (item, a_key__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like dictionary_for_key_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like dictionary_for_key_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	data_for_key_ (a_key: detachable NS_STRING): detachable NS_DATA
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			result_pointer := objc_data_for_key_ (item, a_key__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like data_for_key_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like data_for_key_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	long_long_for_key_ (a_key: detachable NS_STRING): INTEGER_64
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			Result := objc_long_long_for_key_ (item, a_key__item)
		end

	double_for_key_ (a_key: detachable NS_STRING): REAL_64
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			Result := objc_double_for_key_ (item, a_key__item)
		end

	bool_for_key_ (a_key: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			Result := objc_bool_for_key_ (item, a_key__item)
		end

	set_string__for_key_ (a_string: detachable NS_STRING; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_string__item: POINTER
			a_key__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_string__for_key_ (item, a_string__item, a_key__item)
		end

	set_data__for_key_ (a_data: detachable NS_DATA; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_data__item: POINTER
			a_key__item: POINTER
		do
			if attached a_data as a_data_attached then
				a_data__item := a_data_attached.item
			end
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_data__for_key_ (item, a_data__item, a_key__item)
		end

	set_array__for_key_ (an_array: detachable NS_ARRAY; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			an_array__item: POINTER
			a_key__item: POINTER
		do
			if attached an_array as an_array_attached then
				an_array__item := an_array_attached.item
			end
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_array__for_key_ (item, an_array__item, a_key__item)
		end

	set_dictionary__for_key_ (a_dictionary: detachable NS_DICTIONARY; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_dictionary__item: POINTER
			a_key__item: POINTER
		do
			if attached a_dictionary as a_dictionary_attached then
				a_dictionary__item := a_dictionary_attached.item
			end
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_dictionary__for_key_ (item, a_dictionary__item, a_key__item)
		end

	set_long_long__for_key_ (a_value: INTEGER_64; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_long_long__for_key_ (item, a_value, a_key__item)
		end

	set_double__for_key_ (a_value: REAL_64; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_double__for_key_ (item, a_value, a_key__item)
		end

	set_bool__for_key_ (a_value: BOOLEAN; a_key: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_key__item: POINTER
		do
			if attached a_key as a_key_attached then
				a_key__item := a_key_attached.item
			end
			objc_set_bool__for_key_ (item, a_value, a_key__item)
		end

	dictionary_representation: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_dictionary_representation (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like dictionary_representation} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like dictionary_representation} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	synchronize: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_synchronize (item)
		end

feature {NONE} -- NSUbiquitousKeyValueStore Externals

	objc_object_for_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item objectForKey:$a_key];
			 ]"
		end

	objc_set_object__for_key_ (an_item: POINTER; an_object: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setObject:$an_object forKey:$a_key];
			 ]"
		end

	objc_remove_object_for_key_ (an_item: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item removeObjectForKey:$a_key];
			 ]"
		end

	objc_string_for_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item stringForKey:$a_key];
			 ]"
		end

	objc_array_for_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item arrayForKey:$a_key];
			 ]"
		end

	objc_dictionary_for_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item dictionaryForKey:$a_key];
			 ]"
		end

	objc_data_for_key_ (an_item: POINTER; a_key: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item dataForKey:$a_key];
			 ]"
		end

	objc_long_long_for_key_ (an_item: POINTER; a_key: POINTER): INTEGER_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSUbiquitousKeyValueStore *)$an_item longLongForKey:$a_key];
			 ]"
		end

	objc_double_for_key_ (an_item: POINTER; a_key: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSUbiquitousKeyValueStore *)$an_item doubleForKey:$a_key];
			 ]"
		end

	objc_bool_for_key_ (an_item: POINTER; a_key: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSUbiquitousKeyValueStore *)$an_item boolForKey:$a_key];
			 ]"
		end

	objc_set_string__for_key_ (an_item: POINTER; a_string: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setString:$a_string forKey:$a_key];
			 ]"
		end

	objc_set_data__for_key_ (an_item: POINTER; a_data: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setData:$a_data forKey:$a_key];
			 ]"
		end

	objc_set_array__for_key_ (an_item: POINTER; an_array: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setArray:$an_array forKey:$a_key];
			 ]"
		end

	objc_set_dictionary__for_key_ (an_item: POINTER; a_dictionary: POINTER; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setDictionary:$a_dictionary forKey:$a_key];
			 ]"
		end

	objc_set_long_long__for_key_ (an_item: POINTER; a_value: INTEGER_64; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setLongLong:$a_value forKey:$a_key];
			 ]"
		end

	objc_set_double__for_key_ (an_item: POINTER; a_value: REAL_64; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setDouble:$a_value forKey:$a_key];
			 ]"
		end

	objc_set_bool__for_key_ (an_item: POINTER; a_value: BOOLEAN; a_key: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSUbiquitousKeyValueStore *)$an_item setBool:$a_value forKey:$a_key];
			 ]"
		end

	objc_dictionary_representation (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSUbiquitousKeyValueStore *)$an_item dictionaryRepresentation];
			 ]"
		end

	objc_synchronize (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSUbiquitousKeyValueStore *)$an_item synchronize];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSUbiquitousKeyValueStore"
		end

end