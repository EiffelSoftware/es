note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_INCREMENTAL_STORE_UTILS

inherit
	NS_PERSISTENT_STORE_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSIncrementalStore

	identifier_for_new_store_at_ur_l_ (a_store_url: detachable NS_URL): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_store_url__item: POINTER
		do
			if attached a_store_url as a_store_url_attached then
				a_store_url__item := a_store_url_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_identifier_for_new_store_at_ur_l_ (l_objc_class.item, a_store_url__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like identifier_for_new_store_at_ur_l_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like identifier_for_new_store_at_ur_l_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSIncrementalStore Externals

	objc_identifier_for_new_store_at_ur_l_ (a_class_object: POINTER; a_store_url: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object identifierForNewStoreAtURL:$a_store_url];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSIncrementalStore"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end