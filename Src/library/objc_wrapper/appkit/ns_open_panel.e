note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_OPEN_PANEL

inherit
	NS_SAVE_PANEL
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_content_rect__style_mask__backing__defer_,
	make_with_content_rect__style_mask__backing__defer__screen_,
	makeial_first_responder,
	make

feature -- NSOpenPanel

	ur_ls: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_ur_ls (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like ur_ls} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like ur_ls} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	resolves_aliases: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_resolves_aliases (item)
		end

	set_resolves_aliases_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_resolves_aliases_ (item, a_flag)
		end

	can_choose_directories: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_can_choose_directories (item)
		end

	set_can_choose_directories_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_can_choose_directories_ (item, a_flag)
		end

	allows_multiple_selection: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_allows_multiple_selection (item)
		end

	set_allows_multiple_selection_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_allows_multiple_selection_ (item, a_flag)
		end

	can_choose_files: BOOLEAN
			-- Auto generated Objective-C wrapper.
		local
		do
			Result := objc_can_choose_files (item)
		end

	set_can_choose_files_ (a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_set_can_choose_files_ (item, a_flag)
		end

feature {NONE} -- NSOpenPanel Externals

	objc_ur_ls (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(NSOpenPanel *)$an_item URLs];
			 ]"
		end

	objc_resolves_aliases (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSOpenPanel *)$an_item resolvesAliases];
			 ]"
		end

	objc_set_resolves_aliases_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSOpenPanel *)$an_item setResolvesAliases:$a_flag];
			 ]"
		end

	objc_can_choose_directories (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSOpenPanel *)$an_item canChooseDirectories];
			 ]"
		end

	objc_set_can_choose_directories_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSOpenPanel *)$an_item setCanChooseDirectories:$a_flag];
			 ]"
		end

	objc_allows_multiple_selection (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSOpenPanel *)$an_item allowsMultipleSelection];
			 ]"
		end

	objc_set_allows_multiple_selection_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSOpenPanel *)$an_item setAllowsMultipleSelection:$a_flag];
			 ]"
		end

	objc_can_choose_files (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return [(NSOpenPanel *)$an_item canChooseFiles];
			 ]"
		end

	objc_set_can_choose_files_ (an_item: POINTER; a_flag: BOOLEAN)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				[(NSOpenPanel *)$an_item setCanChooseFiles:$a_flag];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSOpenPanel"
		end

end