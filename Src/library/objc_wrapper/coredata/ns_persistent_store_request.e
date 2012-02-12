note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_PERSISTENT_STORE_REQUEST

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_COPYING_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSPersistentStoreRequest

	affected_stores: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_affected_stores (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like affected_stores} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like affected_stores} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_affected_stores_ (a_stores: detachable NS_ARRAY)
			-- Auto generated Objective-C wrapper.
		local
			a_stores__item: POINTER
		do
			if attached a_stores as a_stores_attached then
				a_stores__item := a_stores_attached.item
			end
			objc_set_affected_stores_ (item, a_stores__item)
		end

	request_type: NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_request_type (item)
		end

feature {NONE} -- NSPersistentStoreRequest Externals

	objc_affected_stores (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSPersistentStoreRequest *)$an_item affectedStores];
			 ]"
		end

	objc_set_affected_stores_ (an_item: POINTER; a_stores: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				[(NSPersistentStoreRequest *)$an_item setAffectedStores:$a_stores];
			 ]"
		end

	objc_request_type (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSPersistentStoreRequest *)$an_item requestType];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSPersistentStoreRequest"
		end

end