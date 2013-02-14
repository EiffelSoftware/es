note
	description: "Test suite for spell checker library."

class
	SC_TEST_SUITE

inherit

	SC_LANGUAGE_UTILITY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Run all tests and usage example.
		local
			usage_example: SC_USAGE_EXAMPLE
		do
				-- Test internal system.
			test_language_utility
			test_word_set
			print ('%N')
				-- Finally, run usage example. External system.
			create usage_example
			print ('%N')
		end

feature {NONE} -- Language utility

	test_language_utility
			-- Test language data and utility.
		do
			print ("Testing language utility%N")
			test_language_data
			test_words_of_text
			test_word_predicate
			test_text_segmentation
			test_newline_search
		end

	test_language_data
			-- Check language data.
		do
			print ("%TTesting language data%N")
			check
				line_feed_is_newline: Newlines.has ("%N")
			end
			check
				middle_letter: Middle_letter.has (':')
				middle_number_letter: Middle_number_letter.has ('%'') and Middle_number_letter.has ('.')
			end
		end

	test_words_of_text
			-- Test text segmentation into words for spell checking.
		local
			tests: LINKED_LIST [TUPLE [text: STRING_32; words: ARRAY [STRING_32]]]
			words: LIST [TUPLE [base, length: INTEGER]]
		do
			print ("%TTesting words of text%N")
			create tests.make
			tests.extend ([{STRING_32} "The quick brown fox jumps over the lazy dog", <<"The", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog">>])
			tests.extend ([{STRING_32} "", <<>>])
			tests.extend ([{STRING_32} " ", <<>>])
			tests.extend ([{STRING_32} "dog", <<"dog">>])
			tests.extend ([{STRING_32} " dog  ", <<"dog">>])
			tests.extend ([{STRING_32} "can't", <<"can't">>])
			tests.extend ([{STRING_32} "0 1 32.3", <<>>])
			tests.extend ([{STRING_32} "The quick (%"brown%") fox can't jump 32.3 feet, right?", <<"The", "quick", "brown", "fox", "can't", "jump", "feet", "right">>])
			tests.extend ([{STRING_32} "priority_queue `text'", <<"priority", "queue", "text">>])
			across
				tests as test
			loop
				words := words_of_text (test.item.text)
				check
					counts_equal: words.count = test.item.words.count
				end
				words.start
				across
					test.item.words as word
				loop
					check
						equal: word.item ~ test.item.text.substring (words.item.base, words.item.base + words.item.length - 1)
					end
					words.forth
				end
			end
		end

	test_word_predicate
			-- Test predicate about word property of string.
		local
			tests: LINKED_LIST [TUPLE [text: STRING_32; word: BOOLEAN]]
		do
			print ("%TTesting word predicate%N")
			create tests.make
				-- Empty word is not word.
			tests.extend ([{STRING_32} "", False])
			tests.extend ([{STRING_32} " ", False])
			tests.extend ([{STRING_32} "dog", True])
			tests.extend ([{STRING_32} "dog ", False])
			tests.extend ([{STRING_32} "can't", True])
			tests.extend ([{STRING_32} "32.3", False])
			tests.extend ([{STRING_32} "priority_queue", False])
			across
				tests as test
			loop
				check
					word_as_expected: is_word (test.item.text) = test.item.word
				end
			end
		end

	test_text_segmentation
			-- Test segmentation of texts.
		local
			separator: STRING_32
			outputs: LINKED_LIST [ARRAY [STRING_32]]
			input: STRING_32
			segments: LIST [STRING_32]
		do
			print ("%TTesting text segmentation%N")
			separator := Default_separator
			create outputs.make
			outputs.extend (<<"">>)
			outputs.extend (<<"", "">>)
			outputs.extend (<<"", "", "">>)
			outputs.extend (<<",">>)
			outputs.extend (<<"first", "last">>)
			outputs.extend (<<"0", "1", "1">>)
			across
				outputs as output
			loop
				create {ARRAYED_LIST [STRING_32]} segments.make_from_array (output.item)
				input := concatenate_texts (segments, separator)
				segments := segment_text (input, separator)
				check
					counts_equal: segments.count = output.item.count
				end
				segments.start
				across
					output.item as segment
				loop
					check
						equal: segment.item ~ segments.item
					end
					segments.forth
				end
			end
		end

	test_newline_search
			-- Test search for first newline of text.
		local
			tests: LINKED_LIST [TUPLE [text: STRING_32; newline: TUPLE [base, length: INTEGER]]]
			newline: TUPLE [base, length: INTEGER]
		do
			print ("%TTesting newline search%N")
			create tests.make
				-- Even empty word is not word.
			tests.extend ([{STRING_32} "", [0, 0]])
			tests.extend ([{STRING_32} "Where is there a newline?", [0, 0]])
			tests.extend ([{STRING_32} "Hello%NWorld", [6, 1]])
			tests.extend ([{STRING_32} "Hello%RWorld", [6, 1]])
			tests.extend ([{STRING_32} "Hello%R%NWorld", [6, 2]])
			tests.extend ([{STRING_32} "%NHello%NWorld%N", [1, 1]])
			tests.extend ([Default_newline, [1, Default_newline.count]])
			across
				tests as test
			loop
				test.item.newline.compare_objects
				newline := first_newline (test.item.text)
				newline.compare_objects
				check
					newline_as_expected: newline.is_equal (test.item.newline)
				end
			end
		end

feature {NONE} -- Word set

	test_word_set
			-- Test kinds of word sets.
		do
			print ("Testing word set%N")
			test_word_set_xml_usage
			test_word_set_xml_parser
		end

	test_word_set_xml_usage
			-- Test general usage of XML word set.
		local
			file: FILE_NAME
			word_set: SC_WORD_SET_XML
			word: STRING_32
		do
			print ("%TTesting XML word set usage%N")
			create file.make
			file.set_subdirectory ("tests")
			file.set_subdirectory ("word_set")
			file.set_file_name ("valid.xml")
			create word_set.make_with_file (create {PLAIN_TEXT_FILE}.make_with_name (file.string))
			word_set.load
			check
				successful: word_set.is_successful
			end
			word := "subtree"
			check
				not_present: not word_set.has (word)
			end
			word_set.extend (word)
			check
				successful: word_set.is_successful
			end
			word_set.store
			check
				successful: word_set.is_successful
			end
			word_set.prune (word)
			check
				successful: word_set.is_successful
			end
			word_set.load
			check
				successful: word_set.is_successful
				present_again: word_set.has (word)
			end
			word_set.prune (word)
			check
				successful: word_set.is_successful
			end
			word_set.store
			check
				successful: word_set.is_successful
			end
		end

	test_word_set_xml_parser
			-- Test XML word set with various files.
		local
			folder, file: FILE_NAME
			tests: LINKED_LIST [TUPLE [filename: STRING_32; success: BOOLEAN]]
			word_set: SC_WORD_SET_XML
		do
			print ("%TTesting XML word set parser%N")
			create folder.make
			folder.set_subdirectory ("tests")
			folder.set_subdirectory ("word_set")
			create tests.make
			tests.extend ([{STRING_32} "empty_word.xml", False])
			tests.extend ([{STRING_32} "no_root.xml", False])
			tests.extend ([{STRING_32} "nonexistent.xml", True])
			tests.extend ([{STRING_32} "not_well-formed.xml", False])
			tests.extend ([{STRING_32} "unexpected_element.xml", False])
			tests.extend ([{STRING_32} "unknown_root_element.xml", False])
			tests.extend ([{STRING_32} "valid.xml", True])
			across
				tests as test
			loop
				file := folder.twin
				file.set_file_name (test.item.filename)
				create word_set.make_with_file (create {PLAIN_TEXT_FILE}.make_with_name (file.string))
				word_set.load
				check
					successful_as_expected: word_set.is_successful = test.item.success
				end
			end
		end

end
