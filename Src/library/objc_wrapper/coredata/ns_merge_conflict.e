note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_MERGE_CONFLICT

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_source__new_version__old_version__cached_snapshot__persisted_snapshot_,
	make

feature {NONE} -- Initialization

	make_with_source__new_version__old_version__cached_snapshot__persisted_snapshot_ (a_src_object: detachable NS_MANAGED_OBJECT; a_newvers: NATURAL_64; a_oldvers: NATURAL_64; a_cachesnap: detachable NS_DICTIONARY; a_persnap: detachable NS_DICTIONARY)
			-- Initialize `Current'.
		local
			a_src_object__item: POINTER
			a_cachesnap__item: POINTER
			a_persnap__item: POINTER
		do
			if attached a_src_object as a_src_object_attached then
				a_src_object__item := a_src_object_attached.item
			end
			if attached a_cachesnap as a_cachesnap_attached then
				a_cachesnap__item := a_cachesnap_attached.item
			end
			if attached a_persnap as a_persnap_attached then
				a_persnap__item := a_persnap_attached.item
			end
			make_with_pointer (objc_init_with_source__new_version__old_version__cached_snapshot__persisted_snapshot_(allocate_object, a_src_object__item, a_newvers, a_oldvers, a_cachesnap__item, a_persnap__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSMergeConflict Externals

	objc_init_with_source__new_version__old_version__cached_snapshot__persisted_snapshot_ (an_item: POINTER; a_src_object: POINTER; a_newvers: NATURAL_64; a_oldvers: NATURAL_64; a_cachesnap: POINTER; a_persnap: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergeConflict *)$an_item initWithSource:$a_src_object newVersion:$a_newvers oldVersion:$a_oldvers cachedSnapshot:$a_cachesnap persistedSnapshot:$a_persnap];
			 ]"
		end

feature -- Properties

	source_object: detachable NS_MANAGED_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_source_object (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like source_object} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like source_object} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	object_snapshot: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_object_snapshot (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like object_snapshot} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like object_snapshot} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	cached_snapshot: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_cached_snapshot (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like cached_snapshot} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like cached_snapshot} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	persisted_snapshot: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_persisted_snapshot (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like persisted_snapshot} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like persisted_snapshot} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	new_version_number: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_new_version_number (item)
		end

	old_version_number: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_old_version_number (item)
		end

feature {NONE} -- Properties Externals

	objc_source_object (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergeConflict *)$an_item sourceObject];
			 ]"
		end

	objc_object_snapshot (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergeConflict *)$an_item objectSnapshot];
			 ]"
		end

	objc_cached_snapshot (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergeConflict *)$an_item cachedSnapshot];
			 ]"
		end

	objc_persisted_snapshot (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergeConflict *)$an_item persistedSnapshot];
			 ]"
		end

	objc_new_version_number (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSMergeConflict *)$an_item newVersionNumber];
			 ]"
		end

	objc_old_version_number (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSMergeConflict *)$an_item oldVersionNumber];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSMergeConflict"
		end

end