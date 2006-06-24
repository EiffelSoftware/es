indexing
	description: "[
					This is a .po file entry for a string that is only used in the singular.
					The translated string is stored in msgstr.
					]"
	author: "leof@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"


class
	PO_FILE_ENTRY_SINGULAR

inherit
	PO_FILE_ENTRY
	redefine
		make, to_string
	end

create
	make

feature -- Creation
	make(a_msgid:STRING_GENERAL) is
			-- create new singular entry
		do
			Precursor(a_msgid)
			create msgstr_lines.make
		ensure then
			msgstr_lines_created: msgstr_lines /= Void
		end




feature --msgstr
	set_msgstr(a_msgstr:STRING_GENERAL) is
			-- set the translated value of the msgid
		require
			a_mesgstr_not_void: a_msgstr /= Void
		do
			msgid_lines.wipe_out
			msgstr_lines := break_line (a_msgstr.to_string_32)
		ensure
			msgstr_set: msgstr.is_equal (a_msgstr.to_string_32)
		end

feature --Access
	msgstr:STRING_32 is
		do
			Result := unbreak_line (msgid_lines)
		end


feature --output
	to_string:STRING_32 is
			-- outputs the entry as a string
		do
			Result := Precursor
			--add the msgstr
			Result.append_string(prepare_string ("msgstr", msgstr_lines))
		end


feature {NONE}
	--implementation

	msgstr_lines: LINKED_LIST[STRING_32]
end
