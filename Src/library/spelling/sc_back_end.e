note
	description: "[
		What to expect of any spell checker as back end.
		Effective descendants must redefine `check_word' or `check_words',
		since default behavior of both is to use other.
	]"

deferred class
	SC_BACK_END

inherit

	SC_LANGUAGE_UTILITY
		export
			{SC_BACK_END} all
		end

feature {NONE} -- Initialization

	make
			-- Create with default language.
		do
			failure_message := ""
			is_checked := False
			create {LINKED_LIST [SC_CORRECTION]} corrections.make
		ensure
			is_successful_set: is_successful
			is_checked_set: not is_checked
			last_corrections_empty: last_corrections.is_empty
			corrections_empty: corrections.is_empty
		end

feature -- Status

	language: SC_LANGUAGE
			-- Current language in use for spelling.
		deferred
		end

	is_language_available (a_language: SC_LANGUAGE): BOOLEAN
			-- Is `a_language' supported?
		deferred
		end

	set_language (a_language: SC_LANGUAGE)
			-- Set language to `a_language'.
		require
			language_available: is_language_available (a_language)
		deferred
		ensure
			language_set: language.is_equal (a_language)
		end

	is_word (text: READABLE_STRING_32): BOOLEAN
			-- Is given `text' single word according to back end?
		do
			Result := is_default_word (text)
		end

	words_of_text (text: READABLE_STRING_32): LIST [TUPLE [base, length: INTEGER]]
			-- Find word limits of `text' according to back end.
		do
			Result := default_words_of_text (text)
		ensure
			bases_positive: across Result as word all word.item.base >= 1 end
			lengths_positive: across Result as word all word.item.length >= 1 end
			intervals_sorted_and_disjoint: across 1 |..| (Result.count - 1) as index all Result [index.item].base + Result [index.item].length <= Result [index.item + 1].base end
			all_words: across Result as word all is_word (text.substring (word.item.base, word.item.base + word.item.length - 1)) end
		end

	is_successful: BOOLEAN
			-- Is there no failure?
		do
			Result := failure_message.is_empty
		ensure
			definition: Result = failure_message.is_empty
		end

	failure_message: READABLE_STRING_32
			-- Message in case of failure.

feature -- Checking operations

	check_word (word: READABLE_STRING_32)
			-- Check spelling of single `word'.
		require
			word_valid: is_word (word)
		local
			singleton: LINKED_LIST [STRING_32]
		do
			create singleton.make
			singleton.extend (word)
			check_words (singleton)
		ensure
			checked: is_checked = is_successful
			single_correction: is_successful implies last_corrections.count = 1
		end

	check_words (words: LIST [READABLE_STRING_32])
			-- Check all `words'.
		require
			words_valid: across words as word all is_word (word.item) end
		local
			text_corrections: LINKED_LIST [SC_CORRECTION]
		do
			create text_corrections.make
			across
				words as word
			loop
				check_word (word.item)
				text_corrections.extend (last_corrections.first)
			end
			corrections := text_corrections
		ensure
			checked: is_checked = is_successful
			counts_match: is_successful implies last_corrections.count = words.count
		end

	check_text (text: READABLE_STRING_32)
			-- Check spelling of whole `text'. Default behavior is
			-- to break text into words and check each of them.
		local
			limits: LIST [TUPLE [base, length: INTEGER]]
			words: LINKED_LIST [STRING_32]
		do
			limits := words_of_text (text)
			create words.make
			across
				limits as limit
			loop
				words.extend (text.substring (limit.item.base, limit.item.base + limit.item.length - 1))
			end
			check_words (words)
			if is_successful then
				corrections.start
				across
					limits as limit
				loop
						-- Base index in whole text.
					corrections.item.set_base_index (limit.item.base)
					corrections.forth
				end
			end
		ensure
			checked: is_checked = is_successful
		end

	is_checked: BOOLEAN
			-- Are corrections of last check completed?

	last_corrections: LIST [SC_CORRECTION]
			-- Last corrections for checking.
		require
			checked: is_checked
		do
			Result := corrections.deep_twin
		end

feature -- Dictionary operations

	extend_user_dictionary (word: READABLE_STRING_32)
			-- Add `word' to user dictionary. Changes are not made
			-- persistent, but only with `store_user_dictionary'.
		require
			word_valid: is_word (word)
		deferred
		end

	store_user_dictionary
			-- Make current user dictionary persistent.
		deferred
		end

	user_dictionary_words: SET [READABLE_STRING_32]
			-- All words in user dictionary. They are always treated
			-- as correct and can be used by spell checker as suggestions.
		deferred
		ensure
			object_comparison: Result.object_comparison
		end

	extend_ignore_dictionary (word: READABLE_STRING_32)
			-- Add `word' to ignore dictionary. Changes are not made
			-- persistent, but only with `store_ignore_dictionary'.
		require
			word_valid: is_word (word)
		deferred
		end

	store_ignore_dictionary
			-- Make current ignore dictionary persistent.
		deferred
		end

	ignore_dictionary_words: SET [READABLE_STRING_32]
			-- All words in ignore dictionary. They are always treated
			-- as correct, but never used by spell checker as suggestions.
		deferred
		ensure
			object_comparison: Result.object_comparison
		end

feature {NONE} -- Implementation

	corrections: LIST [SC_CORRECTION]
			-- Corrections for checking of word, words or text.

end
