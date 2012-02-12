note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_MERGE_POLICY

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_merge_type_,
	make

feature {NONE} -- Initialization

	make_with_merge_type_ (a_ty: NATURAL_64)
			-- Initialize `Current'.
		local
		do
			make_with_pointer (objc_init_with_merge_type_(allocate_object, a_ty))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSMergePolicy Externals

	objc_init_with_merge_type_ (an_item: POINTER; a_ty: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return (EIF_POINTER)[(NSMergePolicy *)$an_item initWithMergeType:$a_ty];
			 ]"
		end

--	objc_resolve_conflicts__error_ (an_item: POINTER; a_list: POINTER; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <CoreData/CoreData.h>"
--		alias
--			"[
--				return [(NSMergePolicy *)$an_item resolveConflicts:$a_list error:];
--			 ]"
--		end

feature -- NSMergePolicy

--	resolve_conflicts__error_ (a_list: detachable NS_ARRAY; a_error: UNSUPPORTED_TYPE): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		local
--			a_list__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_list as a_list_attached then
--				a_list__item := a_list_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			Result := objc_resolve_conflicts__error_ (item, a_list__item, a_error__item)
--		end

feature -- Properties

	merge_type: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_merge_type (item)
		end

feature {NONE} -- Properties Externals

	objc_merge_type (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <CoreData/CoreData.h>"
		alias
			"[
				return [(NSMergePolicy *)$an_item mergeType];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSMergePolicy"
		end

end