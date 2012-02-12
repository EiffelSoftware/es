note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_INCREMENTAL_STORE

inherit
	NS_PERSISTENT_STORE
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_persistent_store_coordinator__configuration_name__ur_l__options_,
	make

feature -- NSIncrementalStore

--	execute_request__with_context__error_ (a_request: detachable NS_PERSISTENT_STORE_REQUEST; a_context: detachable NS_MANAGED_OBJECT_CONTEXT; a_error: UNSUPPORTED_TYPE): detachable NS_OBJECT
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_request__item: POINTER
--			a_context__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_request as a_request_attached then
--				a_request__item := a_request_attached.item
--			end
--			if attached a_context as a_context_attached then
--				a_context__item := a_context_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			result_pointer := objc_execute_request__with_context__error_ (item, a_request__item, a_context__item, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like execute_request__with_context__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like execute_request__with_context__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	new_values_for_object_with_i_d__with_context__error_ (a_object_id: detachable NS_MANAGED_OBJECT_ID; a_context: detachable NS_MANAGED_OBJECT_CONTEXT; a_error: UNSUPPORTED_TYPE): detachable NS_INCREMENTAL_STORE_NODE
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_object_id__item: POINTER
--			a_context__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_object_id as a_object_id_attached then
--				a_object_id__item := a_object_id_attached.item
--			end
--			if attached a_context as a_context_attached then
--				a_context__item := a_context_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			result_pointer := objc_new_values_for_object_with_i_d__with_context__error_ (item, a_object_id__item, a_context__item, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like new_values_for_object_with_i_d__with_context__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like new_values_for_object_with_i_d__with_context__error_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	new_value_for_relationship__for_object_with_i_d__with_context__error_ (a_relationship: detachable NS_RELATIONSHIP_DESCRIPTION; a_object_id: detachable NS_MANAGED_OBJECT_ID; a_context: detachable NS_MANAGED_OBJECT_CONTEXT; a_error: UNSUPPORTED_TYPE): detachable NS_OBJECT
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_relationship__item: POINTER
--			a_object_id__item: POINTER
--			a_context__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_relationship as a_relationship_attached then
--				a_relationship__item := a_relationship_attached.item
--			end
--			if attached a_object_id as a_object_id_attached then
--				a_object_id__item := a_object_id_attached.item
--			end
--			if attached a_context as a_context_attached then
--				a_context__item := a_context_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			result_pointer := objc_new_value_for_relationship__for_object_with_i_d__with_context__error_ (item, a_relationship__item, a_object_id__item, a_context__item, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like new_value_for_relationship__for_object_with_i_d__with_context__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like new_value_for_relationship__for_object_with_i_d__with_context__error_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	obtain_permanent_i_ds_for_objects__error_ (a_array: detachable NS_ARRAY; a_error: UNSUPPORTED_TYPE): detachable NS_ARRAY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_array__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_array as a_array_attached then
--				a_array__item := a_array_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			result_pointer := objc_obtain_permanent_i_ds_for_objects__error_ (item, a_array__item, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like obtain_permanent_i_ds_for_objects__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like obtain_permanent_i_ds_for_objects__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	managed_object_context_did_register_objects_with_i_ds_ (a_object_i_ds: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_object_i_ds__item: POINTER
		do
			if attached a_object_i_ds as a_object_i_ds_attached then
				a_object_i_ds__item := a_object_i_ds_attached.item
			end
			objc_managed_object_context_did_register_objects_with_i_ds_ (item, a_object_i_ds__item)
		end

	managed_object_context_did_unregister_objects_with_i_ds_ (a_object_i_ds: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_object_i_ds__item: POINTER
		do
			if attached a_object_i_ds as a_object_i_ds_attached then
				a_object_i_ds__item := a_object_i_ds_attached.item
			end
			objc_managed_object_context_did_unregister_objects_with_i_ds_ (item, a_object_i_ds__item)
		end

	new_object_id_for_entity__reference_object_ (a_entity: detachable NS_ENTITY_DESCRIPTION; a_data: detachable NS_OBJECT): detachable NS_MANAGED_OBJECT_ID
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_entity__item: POINTER
			a_data__item: POINTER
		do
			if attached a_entity as a_entity_attached then
				a_entity__item := a_entity_attached.item
			end
			if attached a_data as a_data_attached then
				a_data__item := a_data_attached.item
			end
			result_pointer := objc_new_object_id_for_entity__reference_object_ (item, a_entity__item, a_data__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like new_object_id_for_entity__reference_object_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like new_object_id_for_entity__reference_object_} new_eiffel_object (result_pointer, False) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	reference_object_for_object_i_d_ (a_object_id: detachable NS_MANAGED_OBJECT_ID): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_object_id__item: POINTER
		do
			if attached a_object_id as a_object_id_attached then
				a_object_id__item := a_object_id_attached.item
			end
			result_pointer := objc_reference_object_for_object_i_d_ (item, a_object_id__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like reference_object_for_object_i_d_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like reference_object_for_object_i_d_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSIncrementalStore Externals

--	objc_execute_request__with_context__error_ (an_item: POINTER; a_request: POINTER; a_context: POINTER; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <CoreData/CoreData.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSIncrementalStore *)$an_item executeRequest:$a_request withContext:$a_context error:];
--			 ]"
--		end

--	objc_new_values_for_object_with_i_d__with_context__error_ (an_item: POINTER; a_object_id: POINTER; a_context: POINTER; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <CoreData/CoreData.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSIncrementalStore *)$an_item newValuesForObjectWithID:$a_object_id withContext:$a_context error:];
--			 ]"
--		end

--	objc_new_value_for_relationship__for_object_with_i_d__with_context__error_ (an_item: POINTER; a_relationship: POINTER; a_object_id: POINTER; a_context: POINTER; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <CoreData/CoreData.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSIncrementalStore *)$an_item newValueForRelationship:$a_relationship forObjectWithID:$a_object_id withContext:$a_context error:];
--			 ]"
--		end

--	objc_obtain_permanent_i_ds_for_objects__error_ (an_item: POINTER; a_array: POINTER; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <CoreData/CoreData.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSIncrementalStore *)$an_item obtainPermanentIDsForObjects:$a_array error:];
--			 ]"
--		end

	objc_managed_object_context_did_register_objects_with_i_ds_ (an_item: POINTER; a_object_i_ds: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSIncrementalStore *)$an_item managedObjectContextDidRegisterObjectsWithIDs:$a_object_i_ds];
			 ]"
		end

	objc_managed_object_context_did_unregister_objects_with_i_ds_ (an_item: POINTER; a_object_i_ds: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSIncrementalStore *)$an_item managedObjectContextDidUnregisterObjectsWithIDs:$a_object_i_ds];
			 ]"
		end

	objc_new_object_id_for_entity__reference_object_ (an_item: POINTER; a_entity: POINTER; a_data: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSIncrementalStore *)$an_item newObjectIDForEntity:$a_entity referenceObject:$a_data];
			 ]"
		end

	objc_reference_object_for_object_i_d_ (an_item: POINTER; a_object_id: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSIncrementalStore *)$an_item referenceObjectForObjectID:$a_object_id];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSIncrementalStore"
		end

end