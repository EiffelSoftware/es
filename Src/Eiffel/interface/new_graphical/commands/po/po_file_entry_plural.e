indexing
	description: "[
					Represents a .po file entry where the string should have its plural forms translated
				]"
	author: "leof@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	PO_FILE_ENTRY_PLURAL

inherit
	PO_FILE_ENTRY
	redefine
		make, to_string
	end

create
	make

feature --creation
	make(a_msgid:STRING_GENERAL) is
		do
			Precursor(a_msgid)
			create msgstr_n_lines.make (0, 2) --reasonable default values
			msgstr_n_lines.force (break_line (""),0) --ensure at least one msgstr. Otherwise some .po editors get fussy.
			create msgid_plural_lines.make
		ensure then
			msgstr_n_lines_created: msgstr_n_lines /= Void
		end

feature --Modification

	set_msgid_plural(a_plural:STRING_GENERAL) is
			-- set the untranslated plural string
			require
				argument_not_void: a_plural /= Void
			do
				msgid_plural_lines.wipe_out
				msgid_plural_lines := break_line (a_plural.as_string_32)
			ensure
				msgid_plural_set: msgid_plural.is_equal(a_plural.as_string_32)
			end

	set_msgstr_n(n:INTEGER; translation:STRING_GENERAL) is
			-- set the nth plural form translation
			require
				n_correct: n >= 0
				translation_non_void: translation /= Void
			do
				msgstr_n_lines.force (break_line (translation.as_string_32), n)
			ensure
				nth_plural_set: msgstr_n (n).is_equal(translation.as_string_32)
			end




feature --Access

	msgid_plural: STRING_32 is
		do
			Result := unbreak_line (msgid_plural_lines)
		end

	 has_msgstr_n (n: INTEGER):BOOLEAN is
	 		-- Does this entry have a translation for the nth plural of msgid_plural?
	 		require
	 			n_not_negative:  n>=0
	 		do
	 			Result := (msgstr_n_lines.valid_index (n) and then msgstr_n_lines.item (n) /= Void)
	 		end

	 msgstr_n (n:INTEGER):STRING_32 is
	 		-- get the translation for the nth plural form
	 		require
	 			translation_exists: has_msgstr_n(n)
	 		do
				Result := unbreak_line (msgstr_n_lines.item(n))
	 		end


feature --output
	to_string:STRING_32 is
			-- output the entry
		local
			counter: INTEGER
		do
			Result := Precursor
			Result.append_string(prepare_string ("msgid_plural", msgid_plural_lines))

			from
				counter := msgstr_n_lines.lower
			until
				counter > msgstr_n_lines.upper
			loop
				if msgstr_n_lines.valid_index (counter) and then msgstr_n_lines.item (counter) /= Void
					and then not msgstr_n_lines.item (counter).is_empty then

					Result.append_string (prepare_string ("msgstr["+counter.out+"]", msgstr_n_lines.item (counter)))
				end
				counter := counter + 1
			end
		end

feature {NONE} --Implementation
	msgstr_n_lines: ARRAY[LINKED_LIST[STRING_32]]
	msgid_plural_lines: LINKED_LIST[STRING_32]

end
