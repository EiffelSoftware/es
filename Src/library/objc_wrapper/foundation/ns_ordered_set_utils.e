note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_ORDERED_SET_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSOrderedSetCreation

	ordered_set: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set (l_objc_class.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_object_ (a_object: detachable NS_OBJECT): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_object_ (l_objc_class.item, a_object__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_object_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_object_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

--	ordered_set_with_objects__count_ (a_objects: UNSUPPORTED_TYPE; a_cnt: NATURAL_64): detachable NS_OBJECT
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			l_objc_class: OBJC_CLASS
--			a_objects__item: POINTER
--		do
--			if attached a_objects as a_objects_attached then
--				a_objects__item := a_objects_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			result_pointer := objc_ordered_set_with_objects__count_ (l_objc_class.item, a_objects__item, a_cnt)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like ordered_set_with_objects__count_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like ordered_set_with_objects__count_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	ordered_set_with_ordered_set_ (a_set: detachable NS_ORDERED_SET): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_ordered_set_ (l_objc_class.item, a_set__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_ordered_set_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_ordered_set_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_ordered_set__range__copy_items_ (a_set: detachable NS_ORDERED_SET; a_range: NS_RANGE; a_flag: BOOLEAN): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_ordered_set__range__copy_items_ (l_objc_class.item, a_set__item, a_range.item, a_flag)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_ordered_set__range__copy_items_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_ordered_set__range__copy_items_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_array_ (a_array: detachable NS_ARRAY): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_array_ (l_objc_class.item, a_array__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_array_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_array_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_array__range__copy_items_ (a_array: detachable NS_ARRAY; a_range: NS_RANGE; a_flag: BOOLEAN): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_array__range__copy_items_ (l_objc_class.item, a_array__item, a_range.item, a_flag)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_array__range__copy_items_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_array__range__copy_items_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_set_ (a_set: detachable NS_SET): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_set_ (l_objc_class.item, a_set__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_set_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_set_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	ordered_set_with_set__copy_items_ (a_set: detachable NS_SET; a_flag: BOOLEAN): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_ordered_set_with_set__copy_items_ (l_objc_class.item, a_set__item, a_flag)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ordered_set_with_set__copy_items_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ordered_set_with_set__copy_items_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSOrderedSetCreation Externals

	objc_ordered_set (a_class_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSet];
			 ]"
		end

	objc_ordered_set_with_object_ (a_class_object: POINTER; a_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithObject:$a_object];
			 ]"
		end

--	objc_ordered_set_with_objects__count_ (a_class_object: POINTER; a_objects: UNSUPPORTED_TYPE; a_cnt: NATURAL_64): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithObjects: count:$a_cnt];
--			 ]"
--		end

	objc_ordered_set_with_ordered_set_ (a_class_object: POINTER; a_set: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithOrderedSet:$a_set];
			 ]"
		end

	objc_ordered_set_with_ordered_set__range__copy_items_ (a_class_object: POINTER; a_set: POINTER; a_range: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithOrderedSet:$a_set range:*((NSRange *)$a_range) copyItems:$a_flag];
			 ]"
		end

	objc_ordered_set_with_array_ (a_class_object: POINTER; a_array: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithArray:$a_array];
			 ]"
		end

	objc_ordered_set_with_array__range__copy_items_ (a_class_object: POINTER; a_array: POINTER; a_range: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithArray:$a_array range:*((NSRange *)$a_range) copyItems:$a_flag];
			 ]"
		end

	objc_ordered_set_with_set_ (a_class_object: POINTER; a_set: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithSet:$a_set];
			 ]"
		end

	objc_ordered_set_with_set__copy_items_ (a_class_object: POINTER; a_set: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object orderedSetWithSet:$a_set copyItems:$a_flag];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSOrderedSet"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end