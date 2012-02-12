note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_INCREMENTAL_STORE_NODE

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_object_i_d__with_values__version_,
	make

feature {NONE} -- Initialization

	make_with_object_i_d__with_values__version_ (a_object_id: detachable NS_MANAGED_OBJECT_ID; a_values: detachable NS_DICTIONARY; a_version: NATURAL_64)
			-- Initialize `Current'.
		local
			a_object_id__item: POINTER
			a_values__item: POINTER
		do
			if attached a_object_id as a_object_id_attached then
				a_object_id__item := a_object_id_attached.item
			end
			if attached a_values as a_values_attached then
				a_values__item := a_values_attached.item
			end
			make_with_pointer (objc_init_with_object_i_d__with_values__version_(allocate_object, a_object_id__item, a_values__item, a_version))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSIncrementalStoreNode Externals

	objc_init_with_object_i_d__with_values__version_ (an_item: POINTER; a_object_id: POINTER; a_values: POINTER; a_version: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSIncrementalStoreNode *)$an_item initWithObjectID:$a_object_id withValues:$a_values version:$a_version];
			 ]"
		end

	objc_update_with_values__version_ (an_item: POINTER; a_values: POINTER; a_version: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSIncrementalStoreNode *)$an_item updateWithValues:$a_values version:$a_version];
			 ]"
		end

	objc_object_id (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSIncrementalStoreNode *)$an_item objectID];
			 ]"
		end

	objc_version (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSIncrementalStoreNode *)$an_item version];
			 ]"
		end

	objc_value_for_property_description_ (an_item: POINTER; a_prop: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSIncrementalStoreNode *)$an_item valueForPropertyDescription:$a_prop];
			 ]"
		end

feature -- NSIncrementalStoreNode

	update_with_values__version_ (a_values: detachable NS_DICTIONARY; a_version: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		local
			a_values__item: POINTER
		do
			if attached a_values as a_values_attached then
				a_values__item := a_values_attached.item
			end
			objc_update_with_values__version_ (item, a_values__item, a_version)
		end

	object_id: detachable NS_MANAGED_OBJECT_ID
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_object_id (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_id} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_id} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	version: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_version (item)
		end

	value_for_property_description_ (a_prop: detachable NS_PROPERTY_DESCRIPTION): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_prop__item: POINTER
		do
			if attached a_prop as a_prop_attached then
				a_prop__item := a_prop_attached.item
			end
			result_pointer := objc_value_for_property_description_ (item, a_prop__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like value_for_property_description_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like value_for_property_description_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSIncrementalStoreNode"
		end

end