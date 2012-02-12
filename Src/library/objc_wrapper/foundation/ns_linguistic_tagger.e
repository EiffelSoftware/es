note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_LINGUISTIC_TAGGER

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_tag_schemes__options_,
	make

feature {NONE} -- Initialization

	make_with_tag_schemes__options_ (a_tag_schemes: detachable NS_ARRAY; a_opts: NATURAL_64)
			-- Initialize `Current'.
		local
			a_tag_schemes__item: POINTER
		do
			if attached a_tag_schemes as a_tag_schemes_attached then
				a_tag_schemes__item := a_tag_schemes_attached.item
			end
			make_with_pointer (objc_init_with_tag_schemes__options_(allocate_object, a_tag_schemes__item, a_opts))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSLinguisticTagger Externals

	objc_init_with_tag_schemes__options_ (an_item: POINTER; a_tag_schemes: POINTER; a_opts: NATURAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item initWithTagSchemes:$a_tag_schemes options:$a_opts];
			 ]"
		end

	objc_tag_schemes (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item tagSchemes];
			 ]"
		end

	objc_set_string_ (an_item: POINTER; a_string: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSLinguisticTagger *)$an_item setString:$a_string];
			 ]"
		end

	objc_string (an_item: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item string];
			 ]"
		end

	objc_set_orthography__range_ (an_item: POINTER; a_orthography: POINTER; a_range: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSLinguisticTagger *)$an_item setOrthography:$a_orthography range:*((NSRange *)$a_range)];
			 ]"
		end

--	objc_orthography_at_index__effective_range_ (an_item: POINTER; a_char_index: NATURAL_64; a_effective_range: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item orthographyAtIndex:$a_char_index effectiveRange:];
--			 ]"
--		end

	objc_string_edited_in_range__change_in_length_ (an_item: POINTER; a_new_range: POINTER; a_delta: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSLinguisticTagger *)$an_item stringEditedInRange:*((NSRange *)$a_new_range) changeInLength:$a_delta];
			 ]"
		end

--	objc_enumerate_tags_in_range__scheme__options__using_block_ (an_item: POINTER; a_range: POINTER; a_tag_scheme: POINTER; a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSLinguisticTagger *)$an_item enumerateTagsInRange:*((NSRange *)$a_range) scheme:$a_tag_scheme options:$a_opts usingBlock:];
--			 ]"
--		end

	objc_sentence_range_for_range_ (an_item: POINTER; result_pointer: POINTER; a_range: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				*(NSRange *)$result_pointer = [(NSLinguisticTagger *)$an_item sentenceRangeForRange:*((NSRange *)$a_range)];
			 ]"
		end

--	objc_tag_at_index__scheme__token_range__sentence_range_ (an_item: POINTER; a_char_index: NATURAL_64; a_tag_scheme: POINTER; a_token_range: UNSUPPORTED_TYPE; a_sentence_range: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item tagAtIndex:$a_char_index scheme:$a_tag_scheme tokenRange: sentenceRange:];
--			 ]"
--		end

--	objc_tags_in_range__scheme__options__token_ranges_ (an_item: POINTER; a_range: POINTER; a_tag_scheme: POINTER; a_opts: NATURAL_64; a_token_ranges: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item tagsInRange:*((NSRange *)$a_range) scheme:$a_tag_scheme options:$a_opts tokenRanges:];
--			 ]"
--		end

--	objc_possible_tags_at_index__scheme__token_range__sentence_range__scores_ (an_item: POINTER; a_char_index: NATURAL_64; a_tag_scheme: POINTER; a_token_range: UNSUPPORTED_TYPE; a_sentence_range: UNSUPPORTED_TYPE; a_scores: UNSUPPORTED_TYPE): POINTER
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return (EIF_POINTER)[(NSLinguisticTagger *)$an_item possibleTagsAtIndex:$a_char_index scheme:$a_tag_scheme tokenRange: sentenceRange: scores:];
--			 ]"
--		end

feature -- NSLinguisticTagger

	tag_schemes: detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_tag_schemes (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like tag_schemes} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like tag_schemes} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_string_ (a_string: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		local
			a_string__item: POINTER
		do
			if attached a_string as a_string_attached then
				a_string__item := a_string_attached.item
			end
			objc_set_string_ (item, a_string__item)
		end

	string: detachable NS_STRING
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
		do
			result_pointer := objc_string (item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like string} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like string} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	set_orthography__range_ (a_orthography: detachable NS_ORTHOGRAPHY; a_range: NS_RANGE)
			-- Auto generated Objective-C wrapper.
		local
			a_orthography__item: POINTER
		do
			if attached a_orthography as a_orthography_attached then
				a_orthography__item := a_orthography_attached.item
			end
			objc_set_orthography__range_ (item, a_orthography__item, a_range.item)
		end

--	orthography_at_index__effective_range_ (a_char_index: NATURAL_64; a_effective_range: UNSUPPORTED_TYPE): detachable NS_ORTHOGRAPHY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_effective_range__item: POINTER
--		do
--			if attached a_effective_range as a_effective_range_attached then
--				a_effective_range__item := a_effective_range_attached.item
--			end
--			result_pointer := objc_orthography_at_index__effective_range_ (item, a_char_index, a_effective_range__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like orthography_at_index__effective_range_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like orthography_at_index__effective_range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

	string_edited_in_range__change_in_length_ (a_new_range: NS_RANGE; a_delta: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_string_edited_in_range__change_in_length_ (item, a_new_range.item, a_delta)
		end

--	enumerate_tags_in_range__scheme__options__using_block_ (a_range: NS_RANGE; a_tag_scheme: detachable NS_STRING; a_opts: NATURAL_64; a_block: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_tag_scheme__item: POINTER
--		do
--			if attached a_tag_scheme as a_tag_scheme_attached then
--				a_tag_scheme__item := a_tag_scheme_attached.item
--			end
--			objc_enumerate_tags_in_range__scheme__options__using_block_ (item, a_range.item, a_tag_scheme__item, a_opts, )
--		end

	sentence_range_for_range_ (a_range: NS_RANGE): NS_RANGE
			-- Auto generated Objective-C wrapper.
		local
		do
			create Result.make
			objc_sentence_range_for_range_ (item, Result.item, a_range.item)
		end

--	tag_at_index__scheme__token_range__sentence_range_ (a_char_index: NATURAL_64; a_tag_scheme: detachable NS_STRING; a_token_range: UNSUPPORTED_TYPE; a_sentence_range: UNSUPPORTED_TYPE): detachable NS_STRING
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_tag_scheme__item: POINTER
--			a_token_range__item: POINTER
--			a_sentence_range__item: POINTER
--		do
--			if attached a_tag_scheme as a_tag_scheme_attached then
--				a_tag_scheme__item := a_tag_scheme_attached.item
--			end
--			if attached a_token_range as a_token_range_attached then
--				a_token_range__item := a_token_range_attached.item
--			end
--			if attached a_sentence_range as a_sentence_range_attached then
--				a_sentence_range__item := a_sentence_range_attached.item
--			end
--			result_pointer := objc_tag_at_index__scheme__token_range__sentence_range_ (item, a_char_index, a_tag_scheme__item, a_token_range__item, a_sentence_range__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like tag_at_index__scheme__token_range__sentence_range_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like tag_at_index__scheme__token_range__sentence_range_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	tags_in_range__scheme__options__token_ranges_ (a_range: NS_RANGE; a_tag_scheme: detachable NS_STRING; a_opts: NATURAL_64; a_token_ranges: UNSUPPORTED_TYPE): detachable NS_ARRAY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_tag_scheme__item: POINTER
--			a_token_ranges__item: POINTER
--		do
--			if attached a_tag_scheme as a_tag_scheme_attached then
--				a_tag_scheme__item := a_tag_scheme_attached.item
--			end
--			if attached a_token_ranges as a_token_ranges_attached then
--				a_token_ranges__item := a_token_ranges_attached.item
--			end
--			result_pointer := objc_tags_in_range__scheme__options__token_ranges_ (item, a_range.item, a_tag_scheme__item, a_opts, a_token_ranges__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like tags_in_range__scheme__options__token_ranges_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like tags_in_range__scheme__options__token_ranges_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

--	possible_tags_at_index__scheme__token_range__sentence_range__scores_ (a_char_index: NATURAL_64; a_tag_scheme: detachable NS_STRING; a_token_range: UNSUPPORTED_TYPE; a_sentence_range: UNSUPPORTED_TYPE; a_scores: UNSUPPORTED_TYPE): detachable NS_ARRAY
--			-- Auto generated Objective-C wrapper.
--		local
--			result_pointer: POINTER
--			a_tag_scheme__item: POINTER
--			a_token_range__item: POINTER
--			a_sentence_range__item: POINTER
--			a_scores__item: POINTER
--		do
--			if attached a_tag_scheme as a_tag_scheme_attached then
--				a_tag_scheme__item := a_tag_scheme_attached.item
--			end
--			if attached a_token_range as a_token_range_attached then
--				a_token_range__item := a_token_range_attached.item
--			end
--			if attached a_sentence_range as a_sentence_range_attached then
--				a_sentence_range__item := a_sentence_range_attached.item
--			end
--			if attached a_scores as a_scores_attached then
--				a_scores__item := a_scores_attached.item
--			end
--			result_pointer := objc_possible_tags_at_index__scheme__token_range__sentence_range__scores_ (item, a_char_index, a_tag_scheme__item, a_token_range__item, a_sentence_range__item, a_scores__item)
--			if result_pointer /= default_pointer then
--				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
--					check attached {like possible_tags_at_index__scheme__token_range__sentence_range__scores_} existing_eiffel_object as valid_result then
--						Result := valid_result
--					end
--				else
--					check attached {like possible_tags_at_index__scheme__token_range__sentence_range__scores_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
--						Result := valid_result_pointer
--					end
--				end
--			end
--		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSLinguisticTagger"
		end

end