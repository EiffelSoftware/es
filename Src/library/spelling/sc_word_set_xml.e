note
	description: "Set of words persistent in XML file."

class
	SC_WORD_SET_XML

inherit

	SC_WORD_SET

create
	make_with_file

feature {NONE} -- Initialization

	make_with_file (a_file: FILE)
			-- Create with `a_file' for persistent storage.
		do
			make
			create {BINARY_SEARCH_TREE_SET [STRING_32]} words_cache.make
			words_cache.compare_objects
			file := a_file.deep_twin
			is_stored := True
		ensure
			successful: is_successful
			file_set: file.is_deep_equal (a_file)
			file_more_up_to_date: not is_loaded
		end

feature -- Access

	words: SET [READABLE_STRING_32]
			-- <Precursor>
		do
			update_cache_if_needed
			Result := words_cache
		end

feature -- Element change

	load
			-- <Precursor>
		local
			document_callback: XML_CALLBACKS_DOCUMENT
			parser: XML_PARSER
			elements: LIST [XML_ELEMENT]
			word: STRING_32
		do
			failure_message := ""
				-- File may not yet exist.
			if file.exists then
					-- File has to exists to check whether it is readable.
				if not file.is_readable then
					failure_message := "Unable to open file %"" + file.path.name + "%" for reading."
				else
					file.open_read
					create document_callback.make_null
					parser := (create {XML_LITE_PARSER_FACTORY}).new_parser
					parser.set_callbacks (document_callback)
					parser.parse_from_file (file)
					file.close
					if parser.error_occurred then
						if attached parser.error_message as message then
							failure_message := message
							if attached parser.error_position as position then
								failure_message := message + " (" + position.out + ")"
							end
								-- Make sure message is never empty in case of failure.
							if failure_message.is_empty then
								failure_message := "Parser failure with empty message."
							end
						else
							failure_message := "Unknown parser failure happened."
						end
					elseif attached document_callback.document.element_by_name (Element_set) as set then
						words_cache.wipe_out
						elements := set.elements
						elements.start
						from
						until
							not failure_message.is_empty or elements.off
						loop
							if elements.item.name /~ Element_word then
								failure_message := "Unexpected element %"" + elements.item.name + "%"."
							else
									-- Collect parts of same word.
								word := ""
								across
									elements.item.contents as part
								loop
									word.append (part.item.content)
								end
								if word.is_empty then
									failure_message := "Word is empty."
								else
									words_cache.extend (word)
								end
							end
							elements.forth
						variant
							elements.count - elements.index + 1
						end
					else
						failure_message := "Root element %"" + Element_set + "%" missing."
					end
				end
			else
					-- File does not exist, thus empty set.
				words_cache.wipe_out
			end
			if is_successful then
				set_synchronized
			end
		ensure then
			loaded: is_successful implies is_loaded
		end

	store
			-- <Precursor>
		local
			document: XML_DOCUMENT
			origin: XML_DECLARATION
			element: XML_ELEMENT
			all_words: LINEAR [READABLE_STRING_32]
			raw: XML_CHARACTER_DATA
			formatter: XML_FORMATTER
		do
			failure_message := ""
			create document.make
				-- XML declaration with default encoding.
			create origin.make_in_document (document, "1.0", Void, False)
				-- Root: set of words.
			create element.make_root (document, Element_set, Default_namespace)
			all_words := words_cache.linear_representation
			all_words.start
			from
			until
				all_words.off
			loop
					-- Append newline for prettier format.
				create raw.make_last (document.root_element, Default_newline)
					-- Careful to append children to parent with correct creation procedure.
				create element.make_last (document.root_element, Element_word, Default_namespace)
				create raw.make_last (element, all_words.item)
				all_words.forth
			end
			create raw.make_last (document.root_element, Default_newline)
			create formatter.make
				-- File has to exists to check whether it is writable.
			if file.is_creatable or (file.exists and then file.is_writable) then
					-- Create file if it does not yet exist.
				file.open_write
				formatter.set_output_file (file)
				formatter.process_document (document)
				file.close
				set_synchronized
			else
				failure_message := "Unable to open file %"" + file.path.name + "%" for writing."
			end
		ensure then
			stored: is_successful implies is_stored
		end

	extend (word: READABLE_STRING_32)
			-- <Precursor>
		do
			update_cache_if_needed
			if is_successful and not words_cache.has (word) then
				words_cache.extend (word)
				is_stored := False
			end
		end

	prune (word: READABLE_STRING_32)
			-- <Precursor>
		do
			update_cache_if_needed
			if is_successful and words_cache.has (word) then
				words_cache.prune (word)
				is_stored := False
			end
		end

feature {NONE} -- Implementation

	file: FILE
			-- File for persistent storage.

	words_cache: SET [READABLE_STRING_32]
			-- Current set of words. This may differ from file unless synchronized.
		attribute
		ensure
			all_words: Result.linear_representation.for_all (agent is_word)
		end

	is_loaded: BOOLEAN
			-- Is word set loaded from persistent storage?
			-- Or, equivalently, is cache equally or more up to date than file?

	is_stored: BOOLEAN
			-- Is word set stored to persistent storage?
			-- Or, equivalently, is file equally or more up to date than cache?

	is_synchronized: BOOLEAN
			-- Are file and cache are equally up to date?
			-- This does not take into account changes to file by other systems.
		do
			Result := is_loaded and is_stored
		ensure
			definition: is_loaded and is_stored
		end

	set_synchronized
			-- Mark file and cache as equally up to date.
		do
			is_loaded := True
			is_stored := True
		ensure
			set: is_synchronized
		end

	update_cache_if_needed
			-- Update cache with persistent storage unless it is more up to date.
		do
			failure_message := ""
			if not is_loaded then
				load
			end
		ensure
			up_to_date: is_successful implies is_loaded
		end

feature {NONE} -- XML processing

	Element_set: STRING_32 = "set"
			-- Name of XML element for set of words.

	Element_word: STRING_32 = "word"
			-- Name of XML element for word.

	Default_namespace: XML_NAMESPACE
			-- Default XML namespace.
		once
			create Result.make_default
		end

invariant
	most_up_to_date_exists: is_loaded or is_stored

end
