note
	description: "Usage example of spell checker library."

class
	SC_USAGE_EXAMPLE

inherit

	SC_LANGUAGE_UTILITY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Run parts of usage example.
		do
			create checker
			check
				successful: checker.is_successful
			end
			check_words
			check_texts
			check_available_languages
			use_dictionaries
			check_language_change
		end

feature {NONE} -- Examples

	check_words
			-- Check single words.
		local
			words: LINKED_LIST [STRING_32]
		do
			print ("Checking single words%N")
			create words.make
			words.extend ("accommodation")
			words.extend ("antidisestablishmentarianism")
			words.extend ("inexistent")
			words.extend ("misspelt")
			words.extend ("misspelled")
			across
				words as word
			loop
				print ("%TChecking spelling of word %"" + word.item + "%".%N")
				checker.check_word (word.item)
				check
					checked: checker.is_word_checked
				end
				comment_correction (checker.last_word_correction)
			end
		end

	check_texts
			-- Check whole texts.
		local
			texts: LINKED_LIST [STRING_32]
		do
			print ("Checking whole texts%N")
			create texts.make
			texts.extend ("Any corrections or changes in the report are fonud there.")
			texts.extend ("Let's recurse in any subtree.")
			texts.extend ("The quick (%"brown%") fox can't jump 32.3 feet, right?")
			texts.extend ("Thus fulness of exposition is necessary for accuracy.")
			across
				texts as text
			loop
				print ("%TChecking spelling of text %"" + text.item + "%".%N")
				checker.check_text (text.item)
				check
					checked: checker.is_text_checked
				end
				across
					checker.last_text_corrections as correction
				loop
					print ("%T%TPart %"" + correction.item.substring (text.item) + "%".%N")
					comment_correction (correction.item)
				end
			end
		end

	check_available_languages
			-- Find out whether languages are available.
		local
			languages: LINKED_LIST [SC_LANGUAGE]
		do
			print ("Checking availability of languages%N")
			create languages.make
			languages.extend (create {SC_LANGUAGE}.make_with_region ("en", "GB"))
			languages.extend (Default_source_code_language)
			languages.extend (create {SC_LANGUAGE}.make_with_region ("nan", "TW"))
			languages.extend (create {SC_LANGUAGE}.make ("en"))
			languages.extend (create {SC_LANGUAGE}.make_with_region ("pt", "BR"))
			across
				languages as language
			loop
				print ("%TLanguage " + language.item.out + " is ")
				if not checker.is_language_available (language.item) then
					print ("not ")
				end
				print ("available.%N")
			end
		end

	use_dictionaries
			-- Use both kinds of dictionaries.
		local
			word: STRING_32
		do
			print ("Using dictionaries%N")
				-- User dictionary.
			word := "subtree"
			checker.check_word (word)
			check
				checked: checker.is_word_checked
			end
			checker.extend_user_dictionary (word)
			check
				successful: checker.is_successful
				extended: checker.user_dictionary_words.has (word)
			end
			checker.check_word (word)
			check
				checked: checker.is_word_checked
				correct: checker.last_word_correction.is_correct
			end
			checker.store_user_dictionary
			check
				successful: checker.is_successful
			end
			checker.check_word (word)
			check
				checked: checker.is_word_checked
				correct: checker.last_word_correction.is_correct
			end
				-- Ignore dictionary.
			word := "recurse"
			checker.check_word (word)
			check
				checked: checker.is_word_checked
			end
			checker.extend_ignore_dictionary (word)
			check
				successful: checker.is_successful
				extended: checker.ignore_dictionary_words.has (word)
			end
			checker.check_word (word)
			check
				checked: checker.is_word_checked
				correct: checker.last_word_correction.is_correct
			end
			checker.store_ignore_dictionary
			check
				successful: checker.is_successful
			end
			checker.check_word (word)
			check
				checked: checker.is_word_checked
				correct: checker.last_word_correction.is_correct
			end
		end

	check_language_change
			-- Check spelling in another language.
		local
			back_end: SC_GNU_ASPELL
		do
			print ("Checking change of language%N")
			checker.set_language (Default_source_code_language)
			check
				checker_successful: checker.is_successful
			end
			check_words
			create back_end.make_with_language (Default_source_code_language)
			check
				back_end_successful: back_end.is_successful
			end
			checker.set_back_end (back_end)
			check
				checker_successful: checker.is_successful
			end
			check_texts
		end

feature {NONE} -- Implementation

	checker: SC_SPELL_CHECKER
			-- Spell checker in use.

	comment_correction (correction: SC_CORRECTION)
			-- Give comment based on `correction' in natural language.
		do
			print ("%T%T%T")
			if correction.is_correct then
				print ("It is correct.%N")
			else
				inspect correction.suggestions.count
				when 0 then
					print ("No suggestions found. Is it misspelled?")
				when 1 then
					print ("One suggestion found: ")
				else
					print (correction.suggestions.count)
					print (" suggestions found: ")
				end
				if not correction.suggestions.is_empty then
					print (concatenate_texts (correction.suggestions, Default_separator))
					print (".%N")
				end
			end
		end

end
