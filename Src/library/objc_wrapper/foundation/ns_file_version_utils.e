note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FILE_VERSION_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSFileVersion

	current_version_of_item_at_ur_l_ (a_url: detachable NS_URL): detachable NS_FILE_VERSION
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_current_version_of_item_at_ur_l_ (l_objc_class.item, a_url__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like current_version_of_item_at_ur_l_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like current_version_of_item_at_ur_l_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	other_versions_of_item_at_ur_l_ (a_url: detachable NS_URL): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_other_versions_of_item_at_ur_l_ (l_objc_class.item, a_url__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like other_versions_of_item_at_ur_l_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like other_versions_of_item_at_ur_l_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	unresolved_conflict_versions_of_item_at_ur_l_ (a_url: detachable NS_URL): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_unresolved_conflict_versions_of_item_at_ur_l_ (l_objc_class.item, a_url__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like unresolved_conflict_versions_of_item_at_ur_l_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like unresolved_conflict_versions_of_item_at_ur_l_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	version_of_item_at_ur_l__for_persistent_identifier_ (a_url: detachable NS_URL; a_persistent_identifier: detachable NS_OBJECT): detachable NS_FILE_VERSION
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_url__item: POINTER
			a_persistent_identifier__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			if attached a_persistent_identifier as a_persistent_identifier_attached then
				a_persistent_identifier__item := a_persistent_identifier_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_version_of_item_at_ur_l__for_persistent_identifier_ (l_objc_class.item, a_url__item, a_persistent_identifier__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like version_of_item_at_ur_l__for_persistent_identifier_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like version_of_item_at_ur_l__for_persistent_identifier_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

--	add_version_of_item_at_ur_l__with_contents_of_ur_l__options__error_ (a_url: detachable NS_URL; a_contents_url: detachable NS_URL; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE): detachable NS_FILE_VERSION
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			l_objc_class: OBJC_CLASS
--			a_url__item: POINTER
--			a_contents_url__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			if attached a_contents_url as a_contents_url_attached then
--				a_contents_url__item := a_contents_url_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			result_pointer := objc_add_version_of_item_at_ur_l__with_contents_of_ur_l__options__error_ (l_objc_class.item, a_url__item, a_contents_url__item, a_options, a_out_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like add_version_of_item_at_ur_l__with_contents_of_ur_l__options__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like add_version_of_item_at_ur_l__with_contents_of_ur_l__options__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	temporary_directory_url_for_new_version_of_item_at_ur_l_ (a_url: detachable NS_URL): detachable NS_URL
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_temporary_directory_url_for_new_version_of_item_at_ur_l_ (l_objc_class.item, a_url__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like temporary_directory_url_for_new_version_of_item_at_ur_l_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like temporary_directory_url_for_new_version_of_item_at_ur_l_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

--	remove_other_versions_of_item_at_ur_l__error_ (a_url: detachable NS_URL; a_out_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			l_objc_class: OBJC_CLASS
--			a_url__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			Result := objc_remove_other_versions_of_item_at_ur_l__error_ (l_objc_class.item, a_url__item, a_out_error__item)
--		end

feature {NONE} -- NSFileVersion Externals

	objc_current_version_of_item_at_ur_l_ (a_class_object: POINTER; a_url: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object currentVersionOfItemAtURL:$a_url];
			 ]"
		end

	objc_other_versions_of_item_at_ur_l_ (a_class_object: POINTER; a_url: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object otherVersionsOfItemAtURL:$a_url];
			 ]"
		end

	objc_unresolved_conflict_versions_of_item_at_ur_l_ (a_class_object: POINTER; a_url: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object unresolvedConflictVersionsOfItemAtURL:$a_url];
			 ]"
		end

	objc_version_of_item_at_ur_l__for_persistent_identifier_ (a_class_object: POINTER; a_url: POINTER; a_persistent_identifier: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object versionOfItemAtURL:$a_url forPersistentIdentifier:$a_persistent_identifier];
			 ]"
		end

--	objc_add_version_of_item_at_ur_l__with_contents_of_ur_l__options__error_ (a_class_object: POINTER; a_url: POINTER; a_contents_url: POINTER; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(Class)$a_class_object addVersionOfItemAtURL:$a_url withContentsOfURL:$a_contents_url options:$a_options error:];
--			 ]"
--		end

	objc_temporary_directory_url_for_new_version_of_item_at_ur_l_ (a_class_object: POINTER; a_url: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object temporaryDirectoryURLForNewVersionOfItemAtURL:$a_url];
			 ]"
		end

--	objc_remove_other_versions_of_item_at_ur_l__error_ (a_class_object: POINTER; a_url: POINTER; a_out_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(Class)$a_class_object removeOtherVersionsOfItemAtURL:$a_url error:];
--			 ]"
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFileVersion"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end