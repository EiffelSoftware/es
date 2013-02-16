use_basics
		-- Independent example for basic usage of spell checker.
	local
		spell_checker: SC_SPELL_CHECKER
		language: SC_LANGUAGE
		correction: SC_CORRECTION
	do
		create spell_checker
		create language.make_with_region ("en", "GB")
		spell_checker.set_language (language)
		spell_checker.check_word ("inexistent")
		if spell_checker.is_word_checked then
			correction := spell_checker.last_word_correction
			if correction.is_correct then
				print ("Spelling is correct.%N")
			else
				print ("Spelling is incorrect")
				across
					correction.suggestions as suggestion
				loop
					if suggestion.is_first then
						print (". What about: ")
					else
						print (", ")
					end
					print (suggestion.item)
				end
				print ("?%N")
			end
		else
			print ("Spell checker failed: ")
			print (spell_checker.failure_message)
			print ('%N')
		end
	end
