note
	description: "Central spell checking tool."

class
	SC_SPELL_CHECKER

inherit

	ANY
		redefine
			default_create
		end

create
	default_create, make_with_back_end

feature {NONE} -- Initialization

	default_create
			-- Create with default back end and language.
		do
			make_with_back_end (create {SC_GNU_ASPELL})
		end

	make_with_back_end (a_back_end: SC_BACK_END)
			-- Create with `a_back_end' and its current language.
		do
			set_back_end (a_back_end)
		ensure
			back_end_set: back_end = a_back_end
		end

feature -- Status

	language: SC_LANGUAGE
			-- Current language in use for spelling.
		do
			Result := back_end.language
		end

	is_language_available (a_language: SC_LANGUAGE): BOOLEAN
			-- Does current back end support `a_language'?
		do
			Result := back_end.is_language_available (a_language)
		end

	set_language (a_language: SC_LANGUAGE)
			-- Set language to `a_language'.
		require
			language_available: is_language_available (a_language)
		do
			back_end.set_language (a_language)
		ensure
			language_set: language.is_equal (a_language)
		end

	set_back_end (a_back_end: SC_BACK_END)
			-- Set back end to `a_back_end'.
		do
			is_word_checked := False
			are_words_checked := False
			is_text_checked := False
			back_end := a_back_end
		ensure
			back_end_set: back_end = a_back_end
		end

	is_word (text: READABLE_STRING_32): BOOLEAN
			-- Is given `text' single word?
		do
			Result := back_end.is_word (text)
		end

	words_of_text (text: READABLE_STRING_32): LIST [TUPLE [base, length: INTEGER]]
			-- Find word limits of `text' for spell checking.
		do
			Result := back_end.words_of_text (text)
		ensure
			bases_positive: across Result as word all word.item.base >= 1 end
			lengths_positive: across Result as word all word.item.length >= 1 end
			intervals_sorted_and_disjoint: across 1 |..| (Result.count - 1) as index all Result [index.item].base + Result [index.item].length <= Result [index.item + 1].base end
			all_words: across Result as word all is_word (text.substring (word.item.base, word.item.base + word.item.length - 1)) end
		end

	is_successful: BOOLEAN
			-- Is there no failure in any subsystem?
		do
			Result := failure_message.is_empty
		ensure
			definition: Result = failure_message.is_empty
		end

	failure_message: READABLE_STRING_32
			-- Message in case of subsystem failure.
		do
			Result := back_end.failure_message
		end

feature -- Checking operations

	check_word (word: READABLE_STRING_32)
			-- Check spelling of single `word'. Resets all other checks.
		require
			word_valid: is_word (word)
		do
			back_end.check_word (word)
			is_word_checked := back_end.is_checked
			are_words_checked := False
			is_text_checked := False
		ensure
			word_checked: is_word_checked = is_successful
		end

	check_words (words: LIST [READABLE_STRING_32])
			-- Check all `words'. Resets all other checks.
			-- May be more efficient than checking each word separately.
		require
			words_valid: words.for_all (agent is_word)
		do
			back_end.check_words (words)
			are_words_checked := back_end.is_checked
			is_word_checked := False
			is_text_checked := False
		ensure
			words_checked: are_words_checked = is_successful
			counts_match: is_successful implies back_end.last_corrections.count = words.count
		end

	check_text (text: READABLE_STRING_32)
			-- Check spelling of whole `text'. Resets all other checks.
		do
			back_end.check_text (text)
			is_text_checked := back_end.is_checked
			is_word_checked := False
			are_words_checked := False
		ensure
			text_checked: is_text_checked = is_successful
		end

	is_word_checked: BOOLEAN
			-- Is last check completed for word and not words or text?
		attribute
		ensure
			at_most_one_kind_checked: Result implies not (are_words_checked or is_text_checked)
			back_end_singleton: Result implies back_end.last_corrections.count = 1
		end

	are_words_checked: BOOLEAN
			-- Is last check completed for words and not word or text?
		attribute
		ensure
			at_most_one_kind_checked: Result implies not (is_word_checked or is_text_checked)
		end

	is_text_checked: BOOLEAN
			-- Is last check completed for text and not word or words?
		attribute
		ensure
			at_most_one_kind_checked: Result implies not (is_word_checked and are_words_checked)
		end

	last_word_correction: SC_CORRECTION
			-- Last correction for checking of word.
		require
			word_checked: is_word_checked
		do
			Result := back_end.last_corrections.first
		end

	last_words_corrections: LIST [SC_CORRECTION]
			-- Last corrections for checking of words.
		require
			words_checked: are_words_checked
		do
			Result := back_end.last_corrections
		end

	last_text_corrections: LIST [SC_CORRECTION]
			-- Last corrections for checking of text.
		require
			text_checked: is_text_checked
		do
			Result := back_end.last_corrections
		end

feature -- Dictionary operations

	extend_user_dictionary (word: READABLE_STRING_32)
			-- Add `word' to user dictionary. Changes are not made
			-- persistent, but only with `store_user_dictionary'.
		require
			word_valid: is_word (word)
		do
			back_end.extend_user_dictionary (word)
		end

	store_user_dictionary
			-- Make current user dictionary persistent.
		do
			back_end.store_user_dictionary
		end

	user_dictionary_words: SET [READABLE_STRING_32]
			-- All words in user dictionary. They are always treated
			-- as correct and can be used by spell checker as suggestions.
		do
			Result := back_end.user_dictionary_words
		ensure
			object_comparison: Result.object_comparison
		end

	extend_ignore_dictionary (word: READABLE_STRING_32)
			-- Add `word' to ignore dictionary. Changes are not made
			-- persistent, but only with `store_ignore_dictionary'.
		require
			word_valid: is_word (word)
		do
			back_end.extend_ignore_dictionary (word)
		end

	store_ignore_dictionary
			-- Make current ignore dictionary persistent.
		do
			back_end.store_ignore_dictionary
		end

	ignore_dictionary_words: SET [READABLE_STRING_32]
			-- All words in ignore dictionary. They are always treated
			-- as correct, but never used by spell checker as suggestions.
		do
			Result := back_end.ignore_dictionary_words
		ensure
			object_comparison: Result.object_comparison
		end

feature {NONE} -- Implementation

	back_end: SC_BACK_END
			-- Currently used back end.

invariant
	back_end_checked: (is_word_checked or are_words_checked or is_text_checked) implies back_end.is_checked

end
