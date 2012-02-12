note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FILE_COORDINATOR_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSFileCoordinator

	add_file_presenter_ (a_file_presenter: detachable NS_FILE_PRESENTER_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
			a_file_presenter__item: POINTER
		do
			if attached a_file_presenter as a_file_presenter_attached then
				a_file_presenter__item := a_file_presenter_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			objc_add_file_presenter_ (l_objc_class.item, a_file_presenter__item)
		end

	remove_file_presenter_ (a_file_presenter: detachable NS_FILE_PRESENTER_PROTOCOL)
			-- Auto generated Objective-C wrapper.
		local
			l_objc_class: OBJC_CLASS
			a_file_presenter__item: POINTER
		do
			if attached a_file_presenter as a_file_presenter_attached then
				a_file_presenter__item := a_file_presenter_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			objc_remove_file_presenter_ (l_objc_class.item, a_file_presenter__item)
		end

	file_presenters: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_file_presenters (l_objc_class.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like file_presenters} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like file_presenters} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSFileCoordinator Externals

	objc_add_file_presenter_ (a_class_object: POINTER; a_file_presenter: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(Class)$a_class_object addFilePresenter:$a_file_presenter];
			 ]"
		end

	objc_remove_file_presenter_ (a_class_object: POINTER; a_file_presenter: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(Class)$a_class_object removeFilePresenter:$a_file_presenter];
			 ]"
		end

	objc_file_presenters (a_class_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object filePresenters];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFileCoordinator"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end