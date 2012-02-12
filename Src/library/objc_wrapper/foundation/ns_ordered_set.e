note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_ORDERED_SET

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_COPYING_PROTOCOL
	NS_MUTABLE_COPYING_PROTOCOL
	NS_CODING_PROTOCOL
	NS_FAST_ENUMERATION_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_object_,
	make_with_ordered_set_,
	make_with_ordered_set__copy_items_,
	make_with_ordered_set__range__copy_items_,
	make_with_array_,
	make_with_array__copy_items_,
	make_with_array__range__copy_items_,
	make_with_set_,
	make_with_set__copy_items_,
	make

feature -- NSOrderedSet

	count: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_count (item)
		end

	object_at_index_ (a_idx: NATURAL_64): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_object_at_index_ (item, a_idx)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_at_index_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_at_index_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	index_of_object_ (a_object: detachable NS_OBJECT): NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			Result := objc_index_of_object_ (item, a_object__item)
		end

feature {NONE} -- NSOrderedSet Externals

	objc_count (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item count];
			 ]"
		end

	objc_object_at_index_ (an_item: POINTER; a_idx: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item objectAtIndex:$a_idx];
			 ]"
		end

	objc_index_of_object_ (an_item: POINTER; a_object: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item indexOfObject:$a_object];
			 ]"
		end

feature -- NSExtendedOrderedSet

--	get_objects__range_ (a_objects: UNSUPPORTED_TYPE; a_range: NS_RANGE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_objects__item: POINTER
--		do
--			if attached a_objects as a_objects_attached then
--				a_objects__item := a_objects_attached.item
--			end
--			objc_get_objects__range_ (item, a_objects__item, a_range.item)
--		end

	objects_at_indexes_ (a_indexes: detachable NS_INDEX_SET): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_indexes__item: POINTER
		do
			if attached a_indexes as a_indexes_attached then
				a_indexes__item := a_indexes_attached.item
			end
			result_pointer := objc_objects_at_indexes_ (item, a_indexes__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like objects_at_indexes_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like objects_at_indexes_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	first_object: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_first_object (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like first_object} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like first_object} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	last_object: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_last_object (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like last_object} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like last_object} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	is_equal_to_ordered_set_ (a_other: detachable NS_ORDERED_SET): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			Result := objc_is_equal_to_ordered_set_ (item, a_other__item)
		end

	contains_object_ (a_object: detachable NS_OBJECT): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			Result := objc_contains_object_ (item, a_object__item)
		end

	intersects_ordered_set_ (a_other: detachable NS_ORDERED_SET): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			Result := objc_intersects_ordered_set_ (item, a_other__item)
		end

	intersects_set_ (a_set: detachable NS_SET): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			Result := objc_intersects_set_ (item, a_set__item)
		end

	is_subset_of_ordered_set_ (a_other: detachable NS_ORDERED_SET): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			Result := objc_is_subset_of_ordered_set_ (item, a_other__item)
		end

	is_subset_of_set_ (a_set: detachable NS_SET): BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			Result := objc_is_subset_of_set_ (item, a_set__item)
		end

	object_enumerator: detachable NS_ENUMERATOR
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_object_enumerator (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_enumerator} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_enumerator} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	reverse_object_enumerator: detachable NS_ENUMERATOR
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_reverse_object_enumerator (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like reverse_object_enumerator} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like reverse_object_enumerator} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	reversed_ordered_set: detachable NS_ORDERED_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_reversed_ordered_set (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like reversed_ordered_set} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like reversed_ordered_set} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	array: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_array (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like array} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like array} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set: detachable NS_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_set (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like set} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like set} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

--	enumerate_objects_using_block_ (a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_enumerate_objects_using_block_ (item, )
--		end

--	enumerate_objects_with_options__using_block_ (a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_enumerate_objects_with_options__using_block_ (item, a_opts, )
--		end

--	enumerate_objects_at_indexes__options__using_block_ (a_s: detachable NS_INDEX_SET; a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_s__item: POINTER
--		do
--			if attached a_s as a_s_attached then
--				a_s__item := a_s_attached.item
--			end
--			objc_enumerate_objects_at_indexes__options__using_block_ (item, a_s__item, a_opts, )
--		end

--	index_of_object_passing_test_ (a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			Result := objc_index_of_object_passing_test_ (item, )
--		end

--	index_of_object_with_options__passing_test_ (a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			Result := objc_index_of_object_with_options__passing_test_ (item, a_opts, )
--		end

--	index_of_object_at_indexes__options__passing_test_ (a_s: detachable NS_INDEX_SET; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		local
--			a_s__item: POINTER
--		do
--			if attached a_s as a_s_attached then
--				a_s__item := a_s_attached.item
--			end
--			Result := objc_index_of_object_at_indexes__options__passing_test_ (item, a_s__item, a_opts, )
--		end

--	indexes_of_objects_passing_test_ (a_predicate: UNSUPPORTED_TYPE): detachable NS_INDEX_SET
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_indexes_of_objects_passing_test_ (item, )
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like indexes_of_objects_passing_test_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like indexes_of_objects_passing_test_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	indexes_of_objects_with_options__passing_test_ (a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): detachable NS_INDEX_SET
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_indexes_of_objects_with_options__passing_test_ (item, a_opts, )
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like indexes_of_objects_with_options__passing_test_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like indexes_of_objects_with_options__passing_test_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	indexes_of_objects_at_indexes__options__passing_test_ (a_s: detachable NS_INDEX_SET; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): detachable NS_INDEX_SET
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_s__item: POINTER
--		do
--			if attached a_s as a_s_attached then
--				a_s__item := a_s_attached.item
--			end
--			result_pointer := objc_indexes_of_objects_at_indexes__options__passing_test_ (item, a_s__item, a_opts, )
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like indexes_of_objects_at_indexes__options__passing_test_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like indexes_of_objects_at_indexes__options__passing_test_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	index_of_object__in_sorted_range__options__using_comparator_ (a_object: detachable NS_OBJECT; a_range: NS_RANGE; a_opts: NATURAL_64; a_cmp: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		local
--			a_object__item: POINTER
--		do
--			if attached a_object as a_object_attached then
--				a_object__item := a_object_attached.item
--			end
--			Result := objc_index_of_object__in_sorted_range__options__using_comparator_ (item, a_object__item, a_range.item, a_opts, )
--		end

--	sorted_array_using_comparator_ (a_cmptr: UNSUPPORTED_TYPE): detachable NS_ARRAY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_sorted_array_using_comparator_ (item, )
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like sorted_array_using_comparator_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like sorted_array_using_comparator_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	sorted_array_with_options__using_comparator_ (a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE): detachable NS_ARRAY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--		do
--			result_pointer := objc_sorted_array_with_options__using_comparator_ (item, a_opts, )
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like sorted_array_with_options__using_comparator_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like sorted_array_with_options__using_comparator_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	description_with_locale_ (a_locale: detachable NS_OBJECT): detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_locale__item: POINTER
		do
			if attached a_locale as a_locale_attached then
				a_locale__item := a_locale_attached.item
			end
			result_pointer := objc_description_with_locale_ (item, a_locale__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like description_with_locale_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like description_with_locale_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	description_with_locale__indent_ (a_locale: detachable NS_OBJECT; a_level: NATURAL_64): detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_locale__item: POINTER
		do
			if attached a_locale as a_locale_attached then
				a_locale__item := a_locale_attached.item
			end
			result_pointer := objc_description_with_locale__indent_ (item, a_locale__item, a_level)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like description_with_locale__indent_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like description_with_locale__indent_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSExtendedOrderedSet Externals

--	objc_get_objects__range_ (an_item: POINTER; a_objects: UNSUPPORTED_TYPE; a_range: POINTER)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSOrderedSet *)$an_item getObjects: range:*((NSRange *)$a_range)];
--			 ]"
--		end

	objc_objects_at_indexes_ (an_item: POINTER; a_indexes: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item objectsAtIndexes:$a_indexes];
			 ]"
		end

	objc_first_object (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item firstObject];
			 ]"
		end

	objc_last_object (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item lastObject];
			 ]"
		end

	objc_is_equal_to_ordered_set_ (an_item: POINTER; a_other: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item isEqualToOrderedSet:$a_other];
			 ]"
		end

	objc_contains_object_ (an_item: POINTER; a_object: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item containsObject:$a_object];
			 ]"
		end

	objc_intersects_ordered_set_ (an_item: POINTER; a_other: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item intersectsOrderedSet:$a_other];
			 ]"
		end

	objc_intersects_set_ (an_item: POINTER; a_set: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item intersectsSet:$a_set];
			 ]"
		end

	objc_is_subset_of_ordered_set_ (an_item: POINTER; a_other: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item isSubsetOfOrderedSet:$a_other];
			 ]"
		end

	objc_is_subset_of_set_ (an_item: POINTER; a_set: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSOrderedSet *)$an_item isSubsetOfSet:$a_set];
			 ]"
		end

	objc_object_enumerator (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item objectEnumerator];
			 ]"
		end

	objc_reverse_object_enumerator (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item reverseObjectEnumerator];
			 ]"
		end

	objc_reversed_ordered_set (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item reversedOrderedSet];
			 ]"
		end

	objc_array (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item array];
			 ]"
		end

	objc_set (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item set];
			 ]"
		end

--	objc_enumerate_objects_using_block_ (an_item: POINTER; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSOrderedSet *)$an_item enumerateObjectsUsingBlock:];
--			 ]"
--		end

--	objc_enumerate_objects_with_options__using_block_ (an_item: POINTER; a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSOrderedSet *)$an_item enumerateObjectsWithOptions:$a_opts usingBlock:];
--			 ]"
--		end

--	objc_enumerate_objects_at_indexes__options__using_block_ (an_item: POINTER; a_s: POINTER; a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSOrderedSet *)$an_item enumerateObjectsAtIndexes:$a_s options:$a_opts usingBlock:];
--			 ]"
--		end

--	objc_index_of_object_passing_test_ (an_item: POINTER; a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(NSOrderedSet *)$an_item indexOfObjectPassingTest:];
--			 ]"
--		end

--	objc_index_of_object_with_options__passing_test_ (an_item: POINTER; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(NSOrderedSet *)$an_item indexOfObjectWithOptions:$a_opts passingTest:];
--			 ]"
--		end

--	objc_index_of_object_at_indexes__options__passing_test_ (an_item: POINTER; a_s: POINTER; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(NSOrderedSet *)$an_item indexOfObjectAtIndexes:$a_s options:$a_opts passingTest:];
--			 ]"
--		end

--	objc_indexes_of_objects_passing_test_ (an_item: POINTER; a_predicate: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item indexesOfObjectsPassingTest:];
--			 ]"
--		end

--	objc_indexes_of_objects_with_options__passing_test_ (an_item: POINTER; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item indexesOfObjectsWithOptions:$a_opts passingTest:];
--			 ]"
--		end

--	objc_indexes_of_objects_at_indexes__options__passing_test_ (an_item: POINTER; a_s: POINTER; a_opts: NATURAL_64; a_predicate: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item indexesOfObjectsAtIndexes:$a_s options:$a_opts passingTest:];
--			 ]"
--		end

--	objc_index_of_object__in_sorted_range__options__using_comparator_ (an_item: POINTER; a_object: POINTER; a_range: POINTER; a_opts: NATURAL_64; a_cmp: UNSUPPORTED_TYPE): NATURAL_64
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(NSOrderedSet *)$an_item indexOfObject:$a_object inSortedRange:*((NSRange *)$a_range) options:$a_opts usingComparator:];
--			 ]"
--		end

--	objc_sorted_array_using_comparator_ (an_item: POINTER; a_cmptr: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item sortedArrayUsingComparator:];
--			 ]"
--		end

--	objc_sorted_array_with_options__using_comparator_ (an_item: POINTER; a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item sortedArrayWithOptions:$a_opts usingComparator:];
--			 ]"
--		end

	objc_description_with_locale_ (an_item: POINTER; a_locale: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item descriptionWithLocale:$a_locale];
			 ]"
		end

	objc_description_with_locale__indent_ (an_item: POINTER; a_locale: POINTER; a_level: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item descriptionWithLocale:$a_locale indent:$a_level];
			 ]"
		end

feature {NONE} -- Initialization

	make_with_object_ (a_object: detachable NS_OBJECT)
			-- Initialize `Current'.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			make_with_pointer (objc_init_with_object_(allocate_object, a_object__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

--	make_with_objects__count_ (a_objects: UNSUPPORTED_TYPE; a_cnt: NATURAL_64)
--			-- Initialize `Current'.
--		local
--			a_objects__item: POINTER
--		do
--			if attached a_objects as a_objects_attached then
--				a_objects__item := a_objects_attached.item
--			end
--			make_with_pointer (objc_init_with_objects__count_(allocate_object, a_objects__item, a_cnt))
--			if item = default_pointer then
--				-- TODO: handle initialization error.
--			end
--		end

	make_with_ordered_set_ (a_set: detachable NS_ORDERED_SET)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_ordered_set_(allocate_object, a_set__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_ordered_set__copy_items_ (a_set: detachable NS_ORDERED_SET; a_flag: BOOLEAN)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_ordered_set__copy_items_(allocate_object, a_set__item, a_flag))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_ordered_set__range__copy_items_ (a_set: detachable NS_ORDERED_SET; a_range: NS_RANGE; a_flag: BOOLEAN)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_ordered_set__range__copy_items_(allocate_object, a_set__item, a_range.item, a_flag))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_array_ (a_array: detachable NS_ARRAY)
			-- Initialize `Current'.
		local
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			make_with_pointer (objc_init_with_array_(allocate_object, a_array__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_array__copy_items_ (a_set: detachable NS_ARRAY; a_flag: BOOLEAN)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_array__copy_items_(allocate_object, a_set__item, a_flag))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_array__range__copy_items_ (a_set: detachable NS_ARRAY; a_range: NS_RANGE; a_flag: BOOLEAN)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_array__range__copy_items_(allocate_object, a_set__item, a_range.item, a_flag))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_set_ (a_set: detachable NS_SET)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_set_(allocate_object, a_set__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

	make_with_set__copy_items_ (a_set: detachable NS_SET; a_flag: BOOLEAN)
			-- Initialize `Current'.
		local
			a_set__item: POINTER
		do
			if attached a_set as a_set_attached then
				a_set__item := a_set_attached.item
			end
			make_with_pointer (objc_init_with_set__copy_items_(allocate_object, a_set__item, a_flag))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSOrderedSetCreation Externals

	objc_init_with_object_ (an_item: POINTER; a_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithObject:$a_object];
			 ]"
		end

--	objc_init_with_objects__count_ (an_item: POINTER; a_objects: UNSUPPORTED_TYPE; a_cnt: NATURAL_64): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithObjects: count:$a_cnt];
--			 ]"
--		end

	objc_init_with_ordered_set_ (an_item: POINTER; a_set: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithOrderedSet:$a_set];
			 ]"
		end

	objc_init_with_ordered_set__copy_items_ (an_item: POINTER; a_set: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithOrderedSet:$a_set copyItems:$a_flag];
			 ]"
		end

	objc_init_with_ordered_set__range__copy_items_ (an_item: POINTER; a_set: POINTER; a_range: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithOrderedSet:$a_set range:*((NSRange *)$a_range) copyItems:$a_flag];
			 ]"
		end

	objc_init_with_array_ (an_item: POINTER; a_array: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithArray:$a_array];
			 ]"
		end

	objc_init_with_array__copy_items_ (an_item: POINTER; a_set: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithArray:$a_set copyItems:$a_flag];
			 ]"
		end

	objc_init_with_array__range__copy_items_ (an_item: POINTER; a_set: POINTER; a_range: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithArray:$a_set range:*((NSRange *)$a_range) copyItems:$a_flag];
			 ]"
		end

	objc_init_with_set_ (an_item: POINTER; a_set: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithSet:$a_set];
			 ]"
		end

	objc_init_with_set__copy_items_ (an_item: POINTER; a_set: POINTER; a_flag: BOOLEAN): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOrderedSet *)$an_item initWithSet:$a_set copyItems:$a_flag];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSOrderedSet"
		end

end