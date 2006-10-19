indexing
	description: "[
				This class represents a .po file.
				.po files are collections of strings and (possibly) their localised translations for a given language.
				They consist of a collection of entries, each having an original  string in (what is assumed to be) English and
				its translation, or possibly its translation in several plural forms.
				Headers are stored in an entry for an empty original string.
				For more information about .po files, please consult 
						http://www.gnu.org/software/gettext/manual/
						and in particular
						http://www.gnu.org/software/gettext/manual/html_node/gettext_9.html#SEC9
				In typical GNU style, this is not entirely complete and rather badly organised, but we must live with it for now.
				]"
	author: "leof@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

class
	PO_FILE
create
	make_empty
feature
	--Creation
	make_empty is
			-- Makes a new, empty representation of a .po file
		do
			--create headers.
			create headers.make
			create entries.make (20)

			-- We (should) do everything in UTF-8
		    headers.add_header ("Content-Type", "text/plain; charset=UTF-8")

		    -- According to gettext doc this "should always be set to 8" (what's the point of having it then?)
		    headers.add_header ("Content-Transfer-Encoding", "8bit")

		    headers.add_header ("Last-Translator", "YOUR NAME HERE")
		    headers.add_header ("Language-Team", "YOUR TEAM HERE")
		    headers.add_header ("MIME-Version", "1.0")

		end

feature
	--Access
	get_entry(msgid:STRING_GENERAL):PO_FILE_ENTRY is
			-- get an entry by msgid
			require
				key_not_void: msgid /= Void
				entry_exists: has_entry(msgid.to_string_32)
			do
				Result := entries.item (msgid.to_string_32)
			ensure
				valid_result: Result /= Void
			end

feature
		--Modification
	add_entry(new: PO_FILE_ENTRY) is
			-- Adds an entry to the .po file
			-- Note: a .po file should not contain more then one entry with a given msgid
		require
			valid_new: new /= Void
			entry_not_already_present: not has_entry(new.msgid)
		do
			entries.put (new, new.msgid)
		ensure
			entry_added: has_entry(new.msgid)
		end

	has_entry(msgid: STRING_GENERAL):BOOLEAN is
			-- Is an entry with this msgid already in the .po file?
			-- (msgid is a unique key for entries)
		require
			msgid_not_void: msgid /= Void
		do
			Result := entries.has (msgid.to_string_32)
		end

feature
	-- Headers

	--Can be public because it does not allow anything dangerous to be done
	headers: PO_FILE_HEADERS

feature
	--Output

	to_string: STRING_32 is
			-- prints the whole .po file as a string_32
		do
			create Result.make_empty
			Result.append_string(headers.to_string)
			Result.append_string("%N")
			from
				entries.start
			until
				entries.after
			loop
				Result.append_string(entries.item_for_iteration.to_string)
				entries.forth
			end
		ensure
			valid_result: Result /= Void
		end



feature {NONE}
	--Implementation

	entries: HASH_TABLE[PO_FILE_ENTRY, STRING_32]
end
