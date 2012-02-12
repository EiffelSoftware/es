note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_MUTABLE_ORDERED_SET

inherit
	NS_ORDERED_SET
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_capacity_,
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

feature -- NSMutableOrderedSet

	insert_object__at_index_ (a_object: detachable NS_OBJECT; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			objc_insert_object__at_index_ (item, a_object__item, a_idx)
		end

	remove_object_at_index_ (a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_remove_object_at_index_ (item, a_idx)
		end

	replace_object_at_index__with_object_ (a_idx: NATURAL_64; a_object: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			objc_replace_object_at_index__with_object_ (item, a_idx, a_object__item)
		end

feature {NONE} -- NSMutableOrderedSet Externals

	objc_insert_object__at_index_ (an_item: POINTER; a_object: POINTER; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item insertObject:$a_object atIndex:$a_idx];
			 ]"
		end

	objc_remove_object_at_index_ (an_item: POINTER; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeObjectAtIndex:$a_idx];
			 ]"
		end

	objc_replace_object_at_index__with_object_ (an_item: POINTER; a_idx: NATURAL_64; a_object: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item replaceObjectAtIndex:$a_idx withObject:$a_object];
			 ]"
		end

feature -- NSExtendedMutableOrderedSet

	add_object_ (a_object: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			objc_add_object_ (item, a_object__item)
		end

--	add_objects__count_ (a_objects: UNSUPPORTED_TYPE; a_count: NATURAL_64)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_objects__item: POINTER
--		do
--			if attached a_objects as a_objects_attached then
--				a_objects__item := a_objects_attached.item
--			end
--			objc_add_objects__count_ (item, a_objects__item, a_count)
--		end

	add_objects_from_array_ (a_array: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			objc_add_objects_from_array_ (item, a_array__item)
		end

	exchange_object_at_index__with_object_at_index_ (a_idx1: NATURAL_64; a_idx2: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_exchange_object_at_index__with_object_at_index_ (item, a_idx1, a_idx2)
		end

	move_objects_at_indexes__to_index_ (a_indexes: detachable NS_INDEX_SET; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
			a_indexes__item: POINTER
		do
			if attached a_indexes as a_indexes_attached then
				a_indexes__item := a_indexes_attached.item
			end
			objc_move_objects_at_indexes__to_index_ (item, a_indexes__item, a_idx)
		end

	insert_objects__at_indexes_ (a_objects: detachable NS_ARRAY; a_indexes: detachable NS_INDEX_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_objects__item: POINTER
			a_indexes__item: POINTER
		do
			if attached a_objects as a_objects_attached then
				a_objects__item := a_objects_attached.item
			end
			if attached a_indexes as a_indexes_attached then
				a_indexes__item := a_indexes_attached.item
			end
			objc_insert_objects__at_indexes_ (item, a_objects__item, a_indexes__item)
		end

	set_object__at_index_ (a_obj: detachable NS_OBJECT; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
			a_obj__item: POINTER
		do
			if attached a_obj as a_obj_attached then
				a_obj__item := a_obj_attached.item
			end
			objc_set_object__at_index_ (item, a_obj__item, a_idx)
		end

--	replace_objects_in_range__with_objects__count_ (a_range: NS_RANGE; a_objects: UNSUPPORTED_TYPE; a_count: NATURAL_64)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_objects__item: POINTER
--		do
--			if attached a_objects as a_objects_attached then
--				a_objects__item := a_objects_attached.item
--			end
--			objc_replace_objects_in_range__with_objects__count_ (item, a_range.item, a_objects__item, a_count)
--		end

	replace_objects_at_indexes__with_objects_ (a_indexes: detachable NS_INDEX_SET; a_objects: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_indexes__item: POINTER
			a_objects__item: POINTER
		do
			if attached a_indexes as a_indexes_attached then
				a_indexes__item := a_indexes_attached.item
			end
			if attached a_objects as a_objects_attached then
				a_objects__item := a_objects_attached.item
			end
			objc_replace_objects_at_indexes__with_objects_ (item, a_indexes__item, a_objects__item)
		end

	remove_objects_in_range_ (a_range: NS_RANGE)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_remove_objects_in_range_ (item, a_range.item)
		end

	remove_objects_at_indexes_ (a_indexes: detachable NS_INDEX_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_indexes__item: POINTER
		do
			if attached a_indexes as a_indexes_attached then
				a_indexes__item := a_indexes_attached.item
			end
			objc_remove_objects_at_indexes_ (item, a_indexes__item)
		end

	remove_all_objects
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_remove_all_objects (item)
		end

	remove_object_ (a_object: detachable NS_OBJECT)
			-- Auto generated Objective-C wrapper.
		local
			a_object__item: POINTER
		do
			if attached a_object as a_object_attached then
				a_object__item := a_object_attached.item
			end
			objc_remove_object_ (item, a_object__item)
		end

	remove_objects_in_array_ (a_array: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			objc_remove_objects_in_array_ (item, a_array__item)
		end

	intersect_ordered_set_ (a_other: detachable NS_ORDERED_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_intersect_ordered_set_ (item, a_other__item)
		end

	minus_ordered_set_ (a_other: detachable NS_ORDERED_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_minus_ordered_set_ (item, a_other__item)
		end

	union_ordered_set_ (a_other: detachable NS_ORDERED_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_union_ordered_set_ (item, a_other__item)
		end

	intersect_set_ (a_other: detachable NS_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_intersect_set_ (item, a_other__item)
		end

	minus_set_ (a_other: detachable NS_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_minus_set_ (item, a_other__item)
		end

	union_set_ (a_other: detachable NS_SET)
			-- Auto generated Objective-C wrapper.
		local
			a_other__item: POINTER
		do
			if attached a_other as a_other_attached then
				a_other__item := a_other_attached.item
			end
			objc_union_set_ (item, a_other__item)
		end

--	sort_using_comparator_ (a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_sort_using_comparator_ (item, )
--		end

--	sort_with_options__using_comparator_ (a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_sort_with_options__using_comparator_ (item, a_opts, )
--		end

--	sort_range__options__using_comparator_ (a_range: NS_RANGE; a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--		do
--			objc_sort_range__options__using_comparator_ (item, a_range.item, a_opts, )
--		end

feature {NONE} -- NSExtendedMutableOrderedSet Externals

	objc_add_object_ (an_item: POINTER; a_object: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item addObject:$a_object];
			 ]"
		end

--	objc_add_objects__count_ (an_item: POINTER; a_objects: UNSUPPORTED_TYPE; a_count: NATURAL_64)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSMutableOrderedSet *)$an_item addObjects: count:$a_count];
--			 ]"
--		end

	objc_add_objects_from_array_ (an_item: POINTER; a_array: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item addObjectsFromArray:$a_array];
			 ]"
		end

	objc_exchange_object_at_index__with_object_at_index_ (an_item: POINTER; a_idx1: NATURAL_64; a_idx2: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item exchangeObjectAtIndex:$a_idx1 withObjectAtIndex:$a_idx2];
			 ]"
		end

	objc_move_objects_at_indexes__to_index_ (an_item: POINTER; a_indexes: POINTER; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item moveObjectsAtIndexes:$a_indexes toIndex:$a_idx];
			 ]"
		end

	objc_insert_objects__at_indexes_ (an_item: POINTER; a_objects: POINTER; a_indexes: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item insertObjects:$a_objects atIndexes:$a_indexes];
			 ]"
		end

	objc_set_object__at_index_ (an_item: POINTER; a_obj: POINTER; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item setObject:$a_obj atIndex:$a_idx];
			 ]"
		end

--	objc_replace_objects_in_range__with_objects__count_ (an_item: POINTER; a_range: POINTER; a_objects: UNSUPPORTED_TYPE; a_count: NATURAL_64)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSMutableOrderedSet *)$an_item replaceObjectsInRange:*((NSRange *)$a_range) withObjects: count:$a_count];
--			 ]"
--		end

	objc_replace_objects_at_indexes__with_objects_ (an_item: POINTER; a_indexes: POINTER; a_objects: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item replaceObjectsAtIndexes:$a_indexes withObjects:$a_objects];
			 ]"
		end

	objc_remove_objects_in_range_ (an_item: POINTER; a_range: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeObjectsInRange:*((NSRange *)$a_range)];
			 ]"
		end

	objc_remove_objects_at_indexes_ (an_item: POINTER; a_indexes: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeObjectsAtIndexes:$a_indexes];
			 ]"
		end

	objc_remove_all_objects (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeAllObjects];
			 ]"
		end

	objc_remove_object_ (an_item: POINTER; a_object: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeObject:$a_object];
			 ]"
		end

	objc_remove_objects_in_array_ (an_item: POINTER; a_array: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item removeObjectsInArray:$a_array];
			 ]"
		end

	objc_intersect_ordered_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item intersectOrderedSet:$a_other];
			 ]"
		end

	objc_minus_ordered_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item minusOrderedSet:$a_other];
			 ]"
		end

	objc_union_ordered_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item unionOrderedSet:$a_other];
			 ]"
		end

	objc_intersect_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item intersectSet:$a_other];
			 ]"
		end

	objc_minus_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item minusSet:$a_other];
			 ]"
		end

	objc_union_set_ (an_item: POINTER; a_other: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSMutableOrderedSet *)$an_item unionSet:$a_other];
			 ]"
		end

--	objc_sort_using_comparator_ (an_item: POINTER; a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSMutableOrderedSet *)$an_item sortUsingComparator:];
--			 ]"
--		end

--	objc_sort_with_options__using_comparator_ (an_item: POINTER; a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSMutableOrderedSet *)$an_item sortWithOptions:$a_opts usingComparator:];
--			 ]"
--		end

--	objc_sort_range__options__using_comparator_ (an_item: POINTER; a_range: POINTER; a_opts: NATURAL_64; a_cmptr: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSMutableOrderedSet *)$an_item sortRange:*((NSRange *)$a_range) options:$a_opts usingComparator:];
--			 ]"
--		end

feature {NONE} -- Initialization

	make_with_capacity_ (a_num_items: NATURAL_64)
			-- Initialize `Current'.
		local
		do
			make_with_pointer (objc_init_with_capacity_(allocate_object, a_num_items))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSMutableOrderedSetCreation Externals

	objc_init_with_capacity_ (an_item: POINTER; a_num_items: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMutableOrderedSet *)$an_item initWithCapacity:$a_num_items];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSMutableOrderedSet"
		end

end