note
	description: "General utility for text processing with Unicode."

class
	SC_LANGUAGE_UTILITY

inherit

	SC_LANGUAGE_DATA
		export
			{SC_LANGUAGE_UTILITY} all
		end

feature -- Access

	Default_separator: STRING_32 = ", "
			-- String used to separate strings like words.

	Default_newline: STRING_32 = "%N"
			-- Newline used for normalization.

	Default_source_code_language: SC_LANGUAGE
			-- Usual natural language of source code.
		once
				-- American English.
			create Result.make_with_region ("en", "US")
		end

	Default_punctuation: STRING_32
			-- Standard definition of punctuation in words.
		once
			create Result.make_empty
			across
				Middle_letter as punctuation
			loop
				Result.append_character (punctuation.item)
			end
			across
				Middle_number_letter as punctuation
			loop
				Result.append_character (punctuation.item)
			end
		end

	default_words_of_text (text: READABLE_STRING_32): LIST [TUPLE [base, length: INTEGER]]
			-- Find default word limits of Unicode `text' for spell checking.
		do
			Result := words_of_text_with_punctuation (text, Default_punctuation)
		ensure
			bases_positive: across Result as word all word.item.base >= 1 end
			lengths_positive: across Result as word all word.item.length >= 1 end
			intervals_sorted_and_disjoint: across 1 |..| (Result.count - 1) as index all Result [index.item].base + Result [index.item].length <= Result [index.item + 1].base end
			all_words: across Result as word all is_default_word (text.substring (word.item.base, word.item.base + word.item.length - 1)) end
		end

	words_of_text_with_punctuation (text, punctuation: READABLE_STRING_32): LIST [TUPLE [base, length: INTEGER]]
			-- Find word limits of Unicode `text' for spell checking
			-- with characters of `punctuation' valid between letters.
		local
			left, right: TUPLE [base, length: INTEGER]
		do
				-- Only few ideas from default word boundary specification
				-- of Unicode Standard Annex #29 about text segmentation
				-- are implemented. However, algorithm would need to be adapted anyway,
				-- since words like "32.3" are not desired for this purpose.
			Result := letter_substrings (text)
				-- Now merge raw words across certain punctuation.
				-- For example, "can't" should be treated as one word, not two.
			Result.start
			from
			until
				Result.off
			loop
				left := Result.item
				Result.forth
				if not Result.off then
					right := Result.item
					if left.base + left.length + 1 = right.base then
							-- There is exactly one character between `left' and `right' substring.
						if punctuation.has (text [right.base - 1]) then
								-- Character belongs to word punctuation, thus merge words.
							Result.remove
							Result.back
							Result.replace ([left.base, left.length + right.length + 1])
						end
					end
				end
			variant
				Result.count - Result.index + 1
			end
		ensure
			bases_positive: across Result as word all word.item.base >= 1 end
			lengths_positive: across Result as word all word.item.length >= 1 end
			intervals_sorted_and_disjoint: across 1 |..| (Result.count - 1) as index all Result [index.item].base + Result [index.item].length <= Result [index.item + 1].base end
			all_words: across Result as word all is_word_with_punctuation (text.substring (word.item.base, word.item.base + word.item.length - 1), punctuation) end
		end

	is_default_word (text: READABLE_STRING_32): BOOLEAN
			-- Is given `text' single word using default punctuation?
		do
			Result := is_word_with_punctuation (text, Default_punctuation)
		ensure
			not_empty_word: text.is_empty implies not Result
			has_letter: Result implies across text as character some is_letter (character.item) end
		end

	is_word_with_punctuation (text, punctuation: READABLE_STRING_32): BOOLEAN
			-- Is given `text' single word?
			-- Characters from `punctuation' are valid between letters.
		local
			last_letter, now_letter: BOOLEAN
			index: INTEGER
		do
			if not text.is_empty then
				Result := True
				index := 0
				from
				until
					not Result or index = text.count
				loop
					index := index + 1
					now_letter := is_letter (text [index])
					if index = 1 or index = text.count then
						Result := now_letter
					elseif not now_letter then
							-- Word punctuation has to be between two letters.
						if punctuation.has (text [index]) then
							Result := last_letter
						else
							Result := False
						end
					end
					last_letter := now_letter
				variant
					text.count - index
				end
			end
		ensure
			not_empty_word: text.is_empty implies not Result
			has_letter: Result implies across text as character some is_letter (character.item) end
		end

	segment_text (text, separator: READABLE_STRING_32): LIST [STRING_32]
			-- Break up `text' on `separator'. If `separator' is prefix or suffix of
			-- `text', then first or last segment, respectively, is empty.
		require
			separator_nonempty: not separator.is_empty
		local
			base, limit: INTEGER
		do
			create {LINKED_LIST [STRING_32]} Result.make
			base := 1
			from
			until
				base = text.count + 1
			loop
					-- Find next separator.
				limit := text.substring_index (separator, base)
				if limit = 0 then
						-- Last segment is nonempty.
					Result.extend (text.substring (base, text.count))
					base := text.count + 1
				else
					Result.extend (text.substring (base, limit - 1))
					base := limit + separator.count
				end
			variant
				text.count - base + 1
			end
			if text.is_empty or limit /= 0 then
					-- Last segment is empty.
				Result.extend ("")
			end
		ensure
			nonempty: not Result.is_empty
			inversion_correct: concatenate_texts (Result, separator) ~ text
		end

	concatenate_texts (texts: LIST [READABLE_STRING_32]; separator: READABLE_STRING_32): STRING_32
			-- Concatenate `texts' with `separator' between.
		do
			Result := ""
			across
				texts as text
			loop
					-- It is separator, not terminator.
				if not text.is_first then
					Result.append (separator)
				end
				Result.append (text.item)
			end
		ensure
			separators_limited: Result.count >= (texts.count - 1) * separator.count
		end

	first_newline (text: READABLE_STRING_32): TUPLE [base, length: INTEGER]
			-- Index and length of first Unicode newline in `text', if any.
			-- Both zero if no newline present. Newline may be more than one character.
			-- Longer newlines are matched first, for example first newline
			-- found in "Hello%R%NWorld" is "%R%N" and not "%R".
		local
			index: INTEGER
		do
			Result := [0, 0]
			across
				Newlines as newline
			loop
				index := text.substring_index (newline.item, 1)
				if index /= 0 and (Result.base = 0 or index < Result.base) then
						-- First newline or earlier one found.
					Result.base := index
					Result.length := newline.item.count
				end
			end
		ensure
			base_nonnegative: Result.base >= 0
			length_nonnegative: Result.length >= 0
			no_newline: (Result.base = 0) = (Result.length = 0)
			valid_limits: Result.base /= 0 implies (1 <= Result.base and Result.base + Result.length <= text.count + 1)
			newline_present: Result.base /= 0 implies (Newlines.has (text.substring (Result.base, Result.base + Result.length - 1)))
		end

feature {NONE} -- Implementation

	letter_substrings (text: READABLE_STRING_32): LIST [TUPLE [base, length: INTEGER]]
			-- Find substring limits of Unicode `text' only consisting of letters.
		local
			last_in_word, current_in_word: BOOLEAN
		do
			create {LINKED_LIST [TUPLE [INTEGER, INTEGER]]} Result.make
			across
				text as character
			loop
				current_in_word := is_letter (character.item)
				if current_in_word then
					if last_in_word then
						Result.last.length := Result.last.length + 1
					else
						Result.extend ([character.cursor_index, 1])
					end
				end
				last_in_word := current_in_word
			end
		ensure
			bases_positive: across Result as substring all substring.item.base >= 1 end
			lengths_positive: across Result as substring all substring.item.length >= 1 end
			substrings_sorted_disjoint_and_fewest_possible: across 1 |..| (Result.count - 1) as index all Result [index.item].base + Result [index.item].length < Result [index.item + 1].base end
			only_letters: across Result as substring all across substring.item.base |..| (substring.item.base + substring.item.length - 1) as index all is_letter (text [index.item]) end end
		end

	is_letter (character: CHARACTER_32): BOOLEAN
			-- Does Unicode `character' belong to major general category letter?
		do
			Result := contains (Letter_intervals_sorted, character.code)
		end

	contains (set: ARRAY [TUPLE [base, length: INTEGER]]; element: INTEGER): BOOLEAN
			-- Does `set' given by sorted and disjoint intervals contain `element'?
		require
			set_sorted_and_disjoint: across 1 |..| (set.count - 1) as index all set [index.item].base + set [index.item].length <= set [index.item + 1].base end
		local
			low, high, middle: INTEGER
		do
				-- Binary search to find interval.
			low := set.lower
			high := set.upper
			if set [low].base <= element then
				if element < set [high].base then
						-- Not in last interval.
					from
					invariant
						set.lower <= low and low < high and high <= set.upper
						set [low].base <= element and element < set [high].base
					until
						high - low = 1
					loop
						middle := (low + high) // 2
							-- Now low < middle < high.
						if set [middle].base <= element then
							low := middle
						else
							high := middle
						end
					variant
						high - low - 1
					end
				else
						-- Maybe in last interval.
					low := high
				end
				Result := element < set [low].base + set [low].length
			end
		end

invariant
	default_newline_is_newline: Newlines.has (Default_newline)

end
