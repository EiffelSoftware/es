note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_TEXT_CHECKING_RESULT

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

feature -- Properties

	result_type: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_result_type (item)
		end

	range: NS_RANGE
			-- Auto generated Objective-C wrapper.
		do
			create Result.make
			objc_range (item, Result.item)
		end

	orthography: detachable NS_ORTHOGRAPHY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_orthography (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like orthography} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like orthography} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	grammar_details: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_grammar_details (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like grammar_details} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like grammar_details} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	date: detachable NS_DATE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_date (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like date} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like date} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	time_zone: detachable NS_TIME_ZONE
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_time_zone (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like time_zone} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like time_zone} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	duration: REAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_duration (item)
		end

	components: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_components (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like components} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like components} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

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

	replacement_string: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_replacement_string (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like replacement_string} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like replacement_string} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	regular_expression: detachable NS_REGULAR_EXPRESSION
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_regular_expression (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like regular_expression} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like regular_expression} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	phone_number: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_phone_number (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like phone_number} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like phone_number} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	address_components: detachable NS_DICTIONARY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_address_components (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like address_components} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like address_components} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	number_of_ranges: NATURAL_64
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_number_of_ranges (item)
		end

feature {NONE} -- Properties Externals

	objc_result_type (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSTextCheckingResult *)$an_item resultType];
			 ]"
		end

	objc_range (an_item: POINTER; result_pointer: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				*(NSRange *)$result_pointer = [(NSTextCheckingResult *)$an_item range];
			 ]"
		end

	objc_orthography (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item orthography];
			 ]"
		end

	objc_grammar_details (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item grammarDetails];
			 ]"
		end

	objc_date (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item date];
			 ]"
		end

	objc_time_zone (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item timeZone];
			 ]"
		end

	objc_duration (an_item: POINTER): REAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSTextCheckingResult *)$an_item duration];
			 ]"
		end

	objc_components (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item components];
			 ]"
		end

	objc_url (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item URL];
			 ]"
		end

	objc_replacement_string (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item replacementString];
			 ]"
		end

	objc_regular_expression (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item regularExpression];
			 ]"
		end

	objc_phone_number (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item phoneNumber];
			 ]"
		end

	objc_address_components (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item addressComponents];
			 ]"
		end

	objc_number_of_ranges (an_item: POINTER): NATURAL_64
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(NSTextCheckingResult *)$an_item numberOfRanges];
			 ]"
		end

feature -- NSTextCheckingResultOptional

	range_at_index_ (a_idx: NATURAL_64): NS_RANGE
			-- Auto generated Objective-C wrapper.
		local
		do
			create Result.make
			objc_range_at_index_ (item, Result.item, a_idx)
		end

	result_by_adjusting_ranges_with_offset_ (a_offset: INTEGER_64): detachable NS_TEXT_CHECKING_RESULT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_result_by_adjusting_ranges_with_offset_ (item, a_offset)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like result_by_adjusting_ranges_with_offset_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like result_by_adjusting_ranges_with_offset_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSTextCheckingResultOptional Externals

	objc_range_at_index_ (an_item: POINTER; result_pointer: POINTER; a_idx: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				*(NSRange *)$result_pointer = [(NSTextCheckingResult *)$an_item rangeAtIndex:$a_idx];
			 ]"
		end

	objc_result_by_adjusting_ranges_with_offset_ (an_item: POINTER; a_offset: INTEGER_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSTextCheckingResult *)$an_item resultByAdjustingRangesWithOffset:$a_offset];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSTextCheckingResult"
		end

end