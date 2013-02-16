note
	description: "Correction for word or part of text checked for spelling."

class
	SC_CORRECTION

create
	make_from_correct_word, make_from_incorrect_word, make_from_word_without_suggestions, make_from_correct_text_part, make_from_incorrect_text_part, make_from_text_part_without_suggestions

feature {NONE} -- Initialization

	make_from_correct_word (word: READABLE_STRING_32)
			-- Create from correct `word'.
		do
			make_from_correct_text_part (1, word.count)
		ensure
			base_index_set: base_index = 1
			length_set: length = word.count
			is_correct_set: is_correct
			suggestions_empty: suggestions.is_empty
		end

	make_from_incorrect_word (word: READABLE_STRING_32; some_suggestions: LIST [READABLE_STRING_32])
			-- Create from incorrect `word' with `some_suggestions'.
		require
			suggestions_nonempty: not some_suggestions.is_empty
		do
			make_from_incorrect_text_part (1, word.count, some_suggestions)
		ensure
			base_index_set: base_index = 1
			length_set: length = word.count
			is_correct_set: not is_correct
			suggestions_set: suggestions.is_deep_equal (some_suggestions)
		end

	make_from_word_without_suggestions (word: READABLE_STRING_32)
			-- Create from `word' without any suggestions.
		do
			make_from_text_part_without_suggestions (1, word.count)
		ensure
			base_index_set: base_index = 1
			length_set: length = word.count
			is_correct_set: not is_correct
			suggestions_empty: suggestions.is_empty
		end

	make_from_correct_text_part (a_base_index: INTEGER; a_length: INTEGER)
			-- Create from correct word of text.
		require
			base_index_positive: a_base_index >= 1
			length_positive: a_length >= 1
		do
			make_from_text_part_without_suggestions (a_base_index, a_length)
			is_correct := True
		ensure
			base_index_set: base_index = a_base_index
			length_set: length = a_length
			is_correct_set: is_correct
			suggestions_empty: suggestions.is_empty
		end

	make_from_incorrect_text_part (a_base_index: INTEGER; a_length: INTEGER; some_suggestions: LIST [READABLE_STRING_32])
			-- Create from incorrect word of text with `some_suggestions'.
		require
			base_index_positive: a_base_index >= 1
			length_positive: a_length >= 1
			suggestions_nonempty: not some_suggestions.is_empty
		do
			base_index := a_base_index
			length := a_length
			suggestions := some_suggestions.deep_twin
		ensure
			base_index_set: base_index = a_base_index
			length_set: length = a_length
			is_correct_set: not is_correct
			suggestions_set: suggestions.is_deep_equal (some_suggestions)
		end

	make_from_text_part_without_suggestions (a_base_index: INTEGER; a_length: INTEGER)
			-- Create from word of text without any suggestions.
		require
			base_index_positive: a_base_index >= 1
			length_positive: a_length >= 1
		do
			base_index := a_base_index
			length := a_length
			create {LINKED_LIST [STRING_32]} suggestions.make
		ensure
			base_index_set: base_index = a_base_index
			length_set: length = a_length
			is_correct_set: not is_correct
			suggestions_empty: suggestions.is_empty
		end

feature -- Access

	base_index: INTEGER
			-- Lowest index of substring.
		attribute
		ensure
			positive: Result >= 1
		end

	length: INTEGER
			-- Number of characters of substring.
		attribute
		ensure
			positive: Result >= 1
		end

	last_index: INTEGER
			-- Highest index of substring.
		do
			Result := base_index + length - 1
		ensure
			definition: Result = base_index + length - 1
		end

	is_correct: BOOLEAN
			-- Is spelling correct according to checker?

	suggestions: LIST [READABLE_STRING_32]
			-- List of suggested replacements if incorrect.
			-- Empty if no suggestions found.
			-- Suggestion can be one word, but does not need to be.

feature -- Text operations

	set_base_index (a_base_index: INTEGER)
			-- Move correction to another base.
		require
			base_index_positive: a_base_index >= 1
		do
			base_index := a_base_index
		ensure
			base_index_set: base_index = a_base_index
		end

	substring (text: READABLE_STRING_32): STRING_32
			-- Find substring in `text' with limits of correction.
		require
			text_long_enough: text.count >= last_index
		do
			Result := text.substring (base_index, last_index)
		ensure
			definition: Result ~ text.substring (base_index, last_index)
		end

end
