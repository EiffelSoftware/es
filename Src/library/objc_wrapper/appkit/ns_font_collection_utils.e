note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FONT_COLLECTION_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSFontCollection

	font_collection_with_descriptors_ (a_query_descriptors: detachable NS_ARRAY): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_query_descriptors__item: POINTER
		do
			if attached a_query_descriptors as a_query_descriptors_attached then
				a_query_descriptors__item := a_query_descriptors_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_font_collection_with_descriptors_ (l_objc_class.item, a_query_descriptors__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like font_collection_with_descriptors_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like font_collection_with_descriptors_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	font_collection_with_all_available_descriptors: detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_font_collection_with_all_available_descriptors (l_objc_class.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like font_collection_with_all_available_descriptors} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like font_collection_with_all_available_descriptors} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	font_collection_with_locale_ (a_locale: detachable NS_LOCALE): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_locale__item: POINTER
		do
			if attached a_locale as a_locale_attached then
				a_locale__item := a_locale_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_font_collection_with_locale_ (l_objc_class.item, a_locale__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like font_collection_with_locale_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like font_collection_with_locale_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

--	show_font_collection__with_name__visibility__error_ (a_collection: detachable NS_FONT_COLLECTION; a_name: detachable NS_STRING; a_visibility: NATURAL_64; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			l_objc_class: OBJC_CLASS
--			a_collection__item: POINTER
--			a_name__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_collection as a_collection_attached then
--				a_collection__item := a_collection_attached.item
--			end
--			if attached a_name as a_name_attached then
--				a_name__item := a_name_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			Result := objc_show_font_collection__with_name__visibility__error_ (l_objc_class.item, a_collection__item, a_name__item, a_visibility, a_error__item)
--		end

--	hide_font_collection_with_name__visibility__error_ (a_name: detachable NS_STRING; a_visibility: NATURAL_64; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			l_objc_class: OBJC_CLASS
--			a_name__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_name as a_name_attached then
--				a_name__item := a_name_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			Result := objc_hide_font_collection_with_name__visibility__error_ (l_objc_class.item, a_name__item, a_visibility, a_error__item)
--		end

--	rename_font_collection_with_name__visibility__to_name__error_ (a_name: detachable NS_STRING; a_visibility: NATURAL_64; a_name: detachable NS_STRING; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			l_objc_class: OBJC_CLASS
--			a_name__item: POINTER
--			a_name__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_name as a_name_attached then
--				a_name__item := a_name_attached.item
--			end
--			if attached a_name as a_name_attached then
--				a_name__item := a_name_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			create l_objc_class.make_with_name (get_class_name)
--			check l_objc_class_registered: l_objc_class.registered end
--			Result := objc_rename_font_collection_with_name__visibility__to_name__error_ (l_objc_class.item, a_name__item, a_visibility, a_name__item, a_error__item)
--		end

	all_font_collection_names: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
		do
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_all_font_collection_names (l_objc_class.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like all_font_collection_names} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like all_font_collection_names} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	font_collection_with_name_ (a_name: detachable NS_STRING): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_name__item: POINTER
		do
			if attached a_name as a_name_attached then
				a_name__item := a_name_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_font_collection_with_name_ (l_objc_class.item, a_name__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like font_collection_with_name_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like font_collection_with_name_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	font_collection_with_name__visibility_ (a_name: detachable NS_STRING; a_visibility: NATURAL_64): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_name__item: POINTER
		do
			if attached a_name as a_name_attached then
				a_name__item := a_name_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_font_collection_with_name__visibility_ (l_objc_class.item, a_name__item, a_visibility)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like font_collection_with_name__visibility_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like font_collection_with_name__visibility_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSFontCollection Externals

	objc_font_collection_with_descriptors_ (a_class_object: POINTER; a_query_descriptors: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fontCollectionWithDescriptors:$a_query_descriptors];
			 ]"
		end

	objc_font_collection_with_all_available_descriptors (a_class_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fontCollectionWithAllAvailableDescriptors];
			 ]"
		end

	objc_font_collection_with_locale_ (a_class_object: POINTER; a_locale: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fontCollectionWithLocale:$a_locale];
			 ]"
		end

--	objc_show_font_collection__with_name__visibility__error_ (a_class_object: POINTER; a_collection: POINTER; a_name: POINTER; a_visibility: NATURAL_64; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(Class)$a_class_object showFontCollection:$a_collection withName:$a_name visibility:$a_visibility error:];
--			 ]"
--		end

--	objc_hide_font_collection_with_name__visibility__error_ (a_class_object: POINTER; a_name: POINTER; a_visibility: NATURAL_64; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(Class)$a_class_object hideFontCollectionWithName:$a_name visibility:$a_visibility error:];
--			 ]"
--		end

--	objc_rename_font_collection_with_name__visibility__to_name__error_ (a_class_object: POINTER; a_name: POINTER; a_visibility: NATURAL_64; a_name: POINTER; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <AppKit/AppKit.h>"
--		alias
--			"[
--				return [(Class)$a_class_object renameFontCollectionWithName:$a_name visibility:$a_visibility toName:$a_name error:];
--			 ]"
--		end

	objc_all_font_collection_names (a_class_object: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object allFontCollectionNames];
			 ]"
		end

	objc_font_collection_with_name_ (a_class_object: POINTER; a_name: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fontCollectionWithName:$a_name];
			 ]"
		end

	objc_font_collection_with_name__visibility_ (a_class_object: POINTER; a_name: POINTER; a_visibility: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object fontCollectionWithName:$a_name visibility:$a_visibility];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFontCollection"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end