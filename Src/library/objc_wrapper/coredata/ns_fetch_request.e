note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FETCH_REQUEST

inherit
	NS_PERSISTENT_STORE_REQUEST
		redefine
			wrapper_objc_class_name
		end

	NS_CODING_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make,
	make_with_entity_name_

feature {NONE} -- Initialization

	make_with_entity_name_ (a_entity_name: detachable NS_STRING)
			-- Initialize `Current'.
		local
			a_entity_name__item: POINTER
		do
			if attached a_entity_name as a_entity_name_attached then
				a_entity_name__item := a_entity_name_attached.item
			end
			make_with_pointer (objc_init_with_entity_name_(allocate_object, a_entity_name__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSFetchRequest Externals

	objc_init_with_entity_name_ (an_item: POINTER; a_entity_name: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item initWithEntityName:$a_entity_name];
			 ]"
		end

	objc_entity (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item entity];
			 ]"
		end

	objc_set_entity_ (an_item: POINTER; a_entity: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setEntity:$a_entity];
			 ]"
		end

	objc_entity_name (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item entityName];
			 ]"
		end

	objc_predicate (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item predicate];
			 ]"
		end

	objc_set_predicate_ (an_item: POINTER; a_predicate: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setPredicate:$a_predicate];
			 ]"
		end

	objc_sort_descriptors (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item sortDescriptors];
			 ]"
		end

	objc_set_sort_descriptors_ (an_item: POINTER; a_sort_descriptors: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setSortDescriptors:$a_sort_descriptors];
			 ]"
		end

	objc_fetch_limit (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item fetchLimit];
			 ]"
		end

	objc_set_fetch_limit_ (an_item: POINTER; a_limit: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setFetchLimit:$a_limit];
			 ]"
		end

	objc_result_type (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item resultType];
			 ]"
		end

	objc_set_result_type_ (an_item: POINTER; a_type: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setResultType:$a_type];
			 ]"
		end

	objc_includes_subentities (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item includesSubentities];
			 ]"
		end

	objc_set_includes_subentities_ (an_item: POINTER; a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setIncludesSubentities:$a_yes_no];
			 ]"
		end

	objc_includes_property_values (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item includesPropertyValues];
			 ]"
		end

	objc_set_includes_property_values_ (an_item: POINTER; a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setIncludesPropertyValues:$a_yes_no];
			 ]"
		end

	objc_returns_objects_as_faults (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item returnsObjectsAsFaults];
			 ]"
		end

	objc_set_returns_objects_as_faults_ (an_item: POINTER; a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setReturnsObjectsAsFaults:$a_yes_no];
			 ]"
		end

	objc_relationship_key_paths_for_prefetching (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item relationshipKeyPathsForPrefetching];
			 ]"
		end

	objc_set_relationship_key_paths_for_prefetching_ (an_item: POINTER; a_keys: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setRelationshipKeyPathsForPrefetching:$a_keys];
			 ]"
		end

	objc_includes_pending_changes (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item includesPendingChanges];
			 ]"
		end

	objc_set_includes_pending_changes_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setIncludesPendingChanges:$a_flag];
			 ]"
		end

	objc_returns_distinct_results (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item returnsDistinctResults];
			 ]"
		end

	objc_set_returns_distinct_results_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setReturnsDistinctResults:$a_flag];
			 ]"
		end

	objc_properties_to_fetch (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item propertiesToFetch];
			 ]"
		end

	objc_set_properties_to_fetch_ (an_item: POINTER; a_values: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setPropertiesToFetch:$a_values];
			 ]"
		end

	objc_fetch_offset (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item fetchOffset];
			 ]"
		end

	objc_set_fetch_offset_ (an_item: POINTER; a_offset: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setFetchOffset:$a_offset];
			 ]"
		end

	objc_fetch_batch_size (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item fetchBatchSize];
			 ]"
		end

	objc_set_fetch_batch_size_ (an_item: POINTER; a_bsize: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setFetchBatchSize:$a_bsize];
			 ]"
		end

	objc_should_refresh_refetched_objects (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSFetchRequest *)$an_item shouldRefreshRefetchedObjects];
			 ]"
		end

	objc_set_should_refresh_refetched_objects_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setShouldRefreshRefetchedObjects:$a_flag];
			 ]"
		end

	objc_properties_to_group_by (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item propertiesToGroupBy];
			 ]"
		end

	objc_set_properties_to_group_by_ (an_item: POINTER; a_array: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setPropertiesToGroupBy:$a_array];
			 ]"
		end

	objc_having_predicate (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFetchRequest *)$an_item havingPredicate];
			 ]"
		end

	objc_set_having_predicate_ (an_item: POINTER; a_predicate: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSFetchRequest *)$an_item setHavingPredicate:$a_predicate];
			 ]"
		end

feature -- NSFetchRequest

	entity: detachable NS_ENTITY_DESCRIPTION
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_entity (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like entity} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like entity} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_entity_ (a_entity: detachable NS_ENTITY_DESCRIPTION)
			-- Auto generated Objective-C wrapper.
		local
			a_entity__item: POINTER
		do
			if attached a_entity as a_entity_attached then
				a_entity__item := a_entity_attached.item
			end
			objc_set_entity_ (item, a_entity__item)
		end

	entity_name: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_entity_name (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like entity_name} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like entity_name} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	predicate: detachable NS_PREDICATE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_predicate (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like predicate} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like predicate} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_predicate_ (a_predicate: detachable NS_PREDICATE)
			-- Auto generated Objective-C wrapper.
		local
			a_predicate__item: POINTER
		do
			if attached a_predicate as a_predicate_attached then
				a_predicate__item := a_predicate_attached.item
			end
			objc_set_predicate_ (item, a_predicate__item)
		end

	sort_descriptors: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_sort_descriptors (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like sort_descriptors} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like sort_descriptors} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_sort_descriptors_ (a_sort_descriptors: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_sort_descriptors__item: POINTER
		do
			if attached a_sort_descriptors as a_sort_descriptors_attached then
				a_sort_descriptors__item := a_sort_descriptors_attached.item
			end
			objc_set_sort_descriptors_ (item, a_sort_descriptors__item)
		end

	fetch_limit: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_fetch_limit (item)
		end

	set_fetch_limit_ (a_limit: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_fetch_limit_ (item, a_limit)
		end

	result_type: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_result_type (item)
		end

	set_result_type_ (a_type: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_result_type_ (item, a_type)
		end

	includes_subentities: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_includes_subentities (item)
		end

	set_includes_subentities_ (a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_includes_subentities_ (item, a_yes_no)
		end

	includes_property_values: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_includes_property_values (item)
		end

	set_includes_property_values_ (a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_includes_property_values_ (item, a_yes_no)
		end

	returns_objects_as_faults: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_returns_objects_as_faults (item)
		end

	set_returns_objects_as_faults_ (a_yes_no: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_returns_objects_as_faults_ (item, a_yes_no)
		end

	relationship_key_paths_for_prefetching: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_relationship_key_paths_for_prefetching (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like relationship_key_paths_for_prefetching} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like relationship_key_paths_for_prefetching} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_relationship_key_paths_for_prefetching_ (a_keys: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_keys__item: POINTER
		do
			if attached a_keys as a_keys_attached then
				a_keys__item := a_keys_attached.item
			end
			objc_set_relationship_key_paths_for_prefetching_ (item, a_keys__item)
		end

	includes_pending_changes: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_includes_pending_changes (item)
		end

	set_includes_pending_changes_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_includes_pending_changes_ (item, a_flag)
		end

	returns_distinct_results: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_returns_distinct_results (item)
		end

	set_returns_distinct_results_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_returns_distinct_results_ (item, a_flag)
		end

	properties_to_fetch: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_properties_to_fetch (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like properties_to_fetch} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like properties_to_fetch} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_properties_to_fetch_ (a_values: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_values__item: POINTER
		do
			if attached a_values as a_values_attached then
				a_values__item := a_values_attached.item
			end
			objc_set_properties_to_fetch_ (item, a_values__item)
		end

	fetch_offset: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_fetch_offset (item)
		end

	set_fetch_offset_ (a_offset: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_fetch_offset_ (item, a_offset)
		end

	fetch_batch_size: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_fetch_batch_size (item)
		end

	set_fetch_batch_size_ (a_bsize: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_fetch_batch_size_ (item, a_bsize)
		end

	should_refresh_refetched_objects: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_should_refresh_refetched_objects (item)
		end

	set_should_refresh_refetched_objects_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_should_refresh_refetched_objects_ (item, a_flag)
		end

	properties_to_group_by: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_properties_to_group_by (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like properties_to_group_by} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like properties_to_group_by} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_properties_to_group_by_ (a_array: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_array__item: POINTER
		do
			if attached a_array as a_array_attached then
				a_array__item := a_array_attached.item
			end
			objc_set_properties_to_group_by_ (item, a_array__item)
		end

	having_predicate: detachable NS_PREDICATE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_having_predicate (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like having_predicate} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like having_predicate} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_having_predicate_ (a_predicate: detachable NS_PREDICATE)
			-- Auto generated Objective-C wrapper.
		local
			a_predicate__item: POINTER
		do
			if attached a_predicate as a_predicate_attached then
				a_predicate__item := a_predicate_attached.item
			end
			objc_set_having_predicate_ (item, a_predicate__item)
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFetchRequest"
		end

end