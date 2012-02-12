note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_REGULAR_EXPRESSION

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end

	NS_COPYING_PROTOCOL
	NS_CODING_PROTOCOL

create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make

feature {NONE} -- Initialization

--	make_with_pattern__options__error_ (a_pattern: detachable NS_STRING; a_options: NATURAL_64; a_error: UNSUPPORTED_TYPE)
--			-- Initialize `Current'.
--		local
--			a_pattern__item: POINTER
--			a_error__item: POINTER
--		do
--			if attached a_pattern as a_pattern_attached then
--				a_pattern__item := a_pattern_attached.item
--			end
--			if attached a_error as a_error_attached then
--				a_error__item := a_error_attached.item
--			end
--			make_with_pointer (objc_init_with_pattern__options__error_(allocate_object, a_pattern__item, a_options, a_error__item))
--			if item = default_pointer then
--				-- TODO: handle initialization error.
--			end
--		end

feature {NONE} -- NSRegularExpression Externals

--	objc_init_with_pattern__options__error_ (an_item: POINTER; a_pattern: POINTER; a_options: NATURAL_64; a_error: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSRegularExpression *)$an_item initWithPattern:$a_pattern options:$a_options error:];
--			 ]"
--		end

feature -- Properties

	pattern: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_pattern (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like pattern} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like pattern} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	options: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_options (item)
		end

	number_of_capture_groups: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_number_of_capture_groups (item)
		end

feature {NONE} -- Properties Externals

	objc_pattern (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSRegularExpression *)$an_item pattern];
			 ]"
		end

	objc_options (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSRegularExpression *)$an_item options];
			 ]"
		end

	objc_number_of_capture_groups (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSRegularExpression *)$an_item numberOfCaptureGroups];
			 ]"
		end

feature -- NSMatching

--	enumerate_matches_in_string__options__range__using_block_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_string__item: POINTER
--		do
--			if attached a_string as a_string_attached then
--				a_string__item := a_string_attached.item
--			end
--			objc_enumerate_matches_in_string__options__range__using_block_ (item, a_string__item, a_options, a_range.item, )
--		end

	matches_in_string__options__range_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			result_pointer := objc_matches_in_string__options__range_ (item, a_string__item, a_options, a_range.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like matches_in_string__options__range_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like matches_in_string__options__range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	number_of_matches_in_string__options__range_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE): NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			Result := objc_number_of_matches_in_string__options__range_ (item, a_string__item, a_options, a_range.item)
		end

	first_match_in_string__options__range_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE): detachable NS_TEXT_CHECKING_RESULT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			result_pointer := objc_first_match_in_string__options__range_ (item, a_string__item, a_options, a_range.item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like first_match_in_string__options__range_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like first_match_in_string__options__range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	range_of_first_match_in_string__options__range_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE): NS_RANGE
			-- Auto generated Objective-C wrapper.
		local
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			create Result.make
			objc_range_of_first_match_in_string__options__range_ (item, Result.item, a_string__item, a_options, a_range.item)
		end

feature {NONE} -- NSMatching Externals

--	objc_enumerate_matches_in_string__options__range__using_block_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSRegularExpression *)$an_item enumerateMatchesInString:$a_string options:$a_options range:*((NSRange *)$a_range) usingBlock:];
--			 ]"
--		end

	objc_matches_in_string__options__range_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSRegularExpression *)$an_item matchesInString:$a_string options:$a_options range:*((NSRange *)$a_range)];
			 ]"
		end

	objc_number_of_matches_in_string__options__range_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSRegularExpression *)$an_item numberOfMatchesInString:$a_string options:$a_options range:*((NSRange *)$a_range)];
			 ]"
		end

	objc_first_match_in_string__options__range_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSRegularExpression *)$an_item firstMatchInString:$a_string options:$a_options range:*((NSRange *)$a_range)];
			 ]"
		end

	objc_range_of_first_match_in_string__options__range_ (an_item: POINTER; result_pointer: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				*(NSRange *)$result_pointer = [(NSRegularExpression *)$an_item rangeOfFirstMatchInString:$a_string options:$a_options range:*((NSRange *)$a_range)];
			 ]"
		end

feature -- NSReplacement

	string_by_replacing_matches_in_string__options__range__with_template_ (a_string: detachable NS_STRING; a_options: NATURAL_64; a_range: NS_RANGE; a_templ: detachable NS_STRING): detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_string__item: POINTER
			a_templ__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			if attached a_templ as a_templ_attached then
				a_templ__item := a_templ_attached.item
			end
			result_pointer := objc_string_by_replacing_matches_in_string__options__range__with_template_ (item, a_string__item, a_options, a_range.item, a_templ__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like string_by_replacing_matches_in_string__options__range__with_template_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like string_by_replacing_matches_in_string__options__range__with_template_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	replace_matches_in_string__options__range__with_template_ (a_string: detachable NS_MUTABLE_STRING; a_options: NATURAL_64; a_range: NS_RANGE; a_templ: detachable NS_STRING): NATURAL_64
			-- Auto generated Objective-C wrapper.
		local
			a_string__item: POINTER
			a_templ__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			if attached a_templ as a_templ_attached then
				a_templ__item := a_templ_attached.item
			end
			Result := objc_replace_matches_in_string__options__range__with_template_ (item, a_string__item, a_options, a_range.item, a_templ__item)
		end

	replacement_string_for_result__in_string__offset__template_ (a_result: detachable NS_TEXT_CHECKING_RESULT; a_string: detachable NS_STRING; a_offset: INTEGER_64; a_templ: detachable NS_STRING): detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			a_result__item: POINTER
			a_string__item: POINTER
			a_templ__item: POINTER
		do
			if attached a_result as a_result_attached then
				a_result__item := a_result_attached.item
			end
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			if attached a_templ as a_templ_attached then
				a_templ__item := a_templ_attached.item
			end
			result_pointer := objc_replacement_string_for_result__in_string__offset__template_ (item, a_result__item, a_string__item, a_offset, a_templ__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like replacement_string_for_result__in_string__offset__template_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like replacement_string_for_result__in_string__offset__template_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSReplacement Externals

	objc_string_by_replacing_matches_in_string__options__range__with_template_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER; a_templ: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSRegularExpression *)$an_item stringByReplacingMatchesInString:$a_string options:$a_options range:*((NSRange *)$a_range) withTemplate:$a_templ];
			 ]"
		end

	objc_replace_matches_in_string__options__range__with_template_ (an_item: POINTER; a_string: POINTER; a_options: NATURAL_64; a_range: POINTER; a_templ: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSRegularExpression *)$an_item replaceMatchesInString:$a_string options:$a_options range:*((NSRange *)$a_range) withTemplate:$a_templ];
			 ]"
		end

	objc_replacement_string_for_result__in_string__offset__template_ (an_item: POINTER; a_result: POINTER; a_string: POINTER; a_offset: INTEGER_64; a_templ: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSRegularExpression *)$an_item replacementStringForResult:$a_result inString:$a_string offset:$a_offset template:$a_templ];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSRegularExpression"
		end

end