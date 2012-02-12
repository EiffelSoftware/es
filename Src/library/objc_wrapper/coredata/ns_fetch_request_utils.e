note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FETCH_REQUEST_UTILS

inherit
	NS_PERSISTENT_STORE_REQUEST_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSFetchRequest

	fetch_request_with_entity_name_ (a_entity_name: detachable NS_STRING): detachable NS_FETCH_REQUEST
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_entity_name__item: POINTER
		do
			if attached a_entity_name as a_entity_name_attached then
				a_entity_name__item := a_entity_name_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_fetch_request_with_entity_name_ (l_objc_class.item, a_entity_name__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like fetch_request_with_entity_name_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like fetch_request_with_entity_name_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSFetchRequest Externals

	objc_fetch_request_with_entity_name_ (a_class_object: POINTER; a_entity_name: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fetchRequestWithEntityName:$a_entity_name];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFetchRequest"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end