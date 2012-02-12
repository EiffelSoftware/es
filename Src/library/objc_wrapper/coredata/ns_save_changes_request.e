note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_SAVE_CHANGES_REQUEST

inherit
	NS_PERSISTENT_STORE_REQUEST
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_inserted_objects__updated_objects__deleted_objects__locked_objects_,
	make

feature {NONE} -- Initialization

	make_with_inserted_objects__updated_objects__deleted_objects__locked_objects_ (a_inserted_objects: detachable NS_SET; a_updated_objects: detachable NS_SET; a_deleted_objects: detachable NS_SET; a_locked_objects: detachable NS_SET)
			-- Initialize `Current'.
		local
			a_inserted_objects__item: POINTER
			a_updated_objects__item: POINTER
			a_deleted_objects__item: POINTER
			a_locked_objects__item: POINTER
		do
			if attached a_inserted_objects as a_inserted_objects_attached then
				a_inserted_objects__item := a_inserted_objects_attached.item
			end
			if attached a_updated_objects as a_updated_objects_attached then
				a_updated_objects__item := a_updated_objects_attached.item
			end
			if attached a_deleted_objects as a_deleted_objects_attached then
				a_deleted_objects__item := a_deleted_objects_attached.item
			end
			if attached a_locked_objects as a_locked_objects_attached then
				a_locked_objects__item := a_locked_objects_attached.item
			end
			make_with_pointer (objc_init_with_inserted_objects__updated_objects__deleted_objects__locked_objects_(allocate_object, a_inserted_objects__item, a_updated_objects__item, a_deleted_objects__item, a_locked_objects__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSSaveChangesRequest Externals

	objc_init_with_inserted_objects__updated_objects__deleted_objects__locked_objects_ (an_item: POINTER; a_inserted_objects: POINTER; a_updated_objects: POINTER; a_deleted_objects: POINTER; a_locked_objects: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSSaveChangesRequest *)$an_item initWithInsertedObjects:$a_inserted_objects updatedObjects:$a_updated_objects deletedObjects:$a_deleted_objects lockedObjects:$a_locked_objects];
			 ]"
		end

	objc_inserted_objects (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSSaveChangesRequest *)$an_item insertedObjects];
			 ]"
		end

	objc_updated_objects (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSSaveChangesRequest *)$an_item updatedObjects];
			 ]"
		end

	objc_deleted_objects (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSSaveChangesRequest *)$an_item deletedObjects];
			 ]"
		end

	objc_locked_objects (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSSaveChangesRequest *)$an_item lockedObjects];
			 ]"
		end

feature -- NSSaveChangesRequest

	inserted_objects: detachable NS_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_inserted_objects (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like inserted_objects} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like inserted_objects} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	updated_objects: detachable NS_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_updated_objects (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like updated_objects} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like updated_objects} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	deleted_objects: detachable NS_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_deleted_objects (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like deleted_objects} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like deleted_objects} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	locked_objects: detachable NS_SET
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_locked_objects (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like locked_objects} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like locked_objects} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSSaveChangesRequest"
		end

end