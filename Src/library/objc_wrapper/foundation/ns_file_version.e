note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FILE_VERSION

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature -- NSFileVersion

--	replace_item_at_ur_l__options__error_ (a_url: detachable NS_URL; a_options: NATURAL_64; a_error: UNSUPPORTED_TYPE): detachable NS_URL
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_url__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			result_pointer := objc_replace_item_at_ur_l__options__error_ (item, a_url__item, a_options, a_error__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like replace_item_at_ur_l__options__error_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like replace_item_at_ur_l__options__error_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	remove_and_return_error_ (a_out_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			a_out_error__item: POINTER
--		do
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			Result := objc_remove_and_return_error_ (item, a_out_error__item)
--		end

feature {NONE} -- NSFileVersion Externals

--	objc_replace_item_at_ur_l__options__error_ (an_item: POINTER; a_url: POINTER; a_options: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSFileVersion *)$an_item replaceItemAtURL:$a_url options:$a_options error:];
--			 ]"
--		end

--	objc_remove_and_return_error_ (an_item: POINTER; a_out_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(NSFileVersion *)$an_item removeAndReturnError:];
--			 ]"
--		end

feature -- Properties

	url: detachable NS_URL
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_url (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like url} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like url} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	localized_name: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_localized_name (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like localized_name} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like localized_name} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	localized_name_of_saving_computer: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_localized_name_of_saving_computer (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like localized_name_of_saving_computer} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like localized_name_of_saving_computer} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	modification_date: detachable NS_DATE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_modification_date (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like modification_date} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like modification_date} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	persistent_identifier: detachable NS_CODING_PROTOCOL
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_persistent_identifier (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like persistent_identifier} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like persistent_identifier} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	is_conflict: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_conflict (item)
		end

	is_resolved: BOOLEAN assign set_resolved
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_resolved (item)
		end

	set_resolved (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_resolved (item, an_arg)
		end

	is_discardable: BOOLEAN assign set_discardable
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_is_discardable (item)
		end

	set_discardable (an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_discardable (item, an_arg)
		end

feature {NONE} -- Properties Externals

	objc_url (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileVersion *)$an_item URL];
			 ]"
		end

	objc_localized_name (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileVersion *)$an_item localizedName];
			 ]"
		end

	objc_localized_name_of_saving_computer (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileVersion *)$an_item localizedNameOfSavingComputer];
			 ]"
		end

	objc_modification_date (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileVersion *)$an_item modificationDate];
			 ]"
		end

	objc_persistent_identifier (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileVersion *)$an_item persistentIdentifier];
			 ]"
		end

	objc_is_conflict (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSFileVersion *)$an_item isConflict];
			 ]"
		end

	objc_is_resolved (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSFileVersion *)$an_item isResolved];
			 ]"
		end

	objc_set_resolved (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSFileVersion *)$an_item setResolved:$an_arg]
			 ]"
		end

	objc_is_discardable (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSFileVersion *)$an_item isDiscardable];
			 ]"
		end

	objc_set_discardable (an_item: POINTER; an_arg: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSFileVersion *)$an_item setDiscardable:$an_arg]
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFileVersion"
		end

end