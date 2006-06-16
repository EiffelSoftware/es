indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PO_FILE_HEADERS
inherit
	PO_FILE_ENTRY_SINGULAR
	rename
		make as make_old
	export
		-- This is not a nice or elegant thing to do, I know.
		{NONE} make_old
	redefine
		msgstr
	end


create
	make

	feature
		--Creation
		make is
				-- makes new headers entry
			do
				make_old ("")
			end


	feature --Access
		has_header(key:STRING_GENERAL):BOOLEAN is
				-- does this header exist?
			require
				argument_not_void: key /= Void
			do
				Result := headers.has (key.to_string_32)
			end

		get_header(key:STRING_GENERAL):STRING_32 is
				-- get the content of this header
			require
				argument_not_void: key /= Void
				key_valid: has_header(key)
			do
				Result := headers.item (key.to_string_32)
			end

		msgstr: STRING_32 is
				-- Resturn the msgstr.
			do
				-- In this case the msgstr is _not_ stored in msgstr_lines like a normal entry,
				-- because the msgtr is a multi-line string where each line is a header. We keep them in a
				-- hash table to be able to access them individually by key
				from
					headers.start
				until
					headers.after
				loop
					Result.append (headers.key_for_iteration)
					Result.append (": ")
					Result.append (headers.item_for_iteration)
					Result.append ("%N")
					headers.forth
				end
			end



	feature --Modification

		add_header(key:STRING_GENERAL; value:STRING_GENERAL) is
			require
				arguments_not_void: key /= Void and value /= Void
				header_is_not_already_present: not headers.has(key.to_string_32)
			do
				headers.put (value.to_string_32, key.to_string_32)
			ensure
				header_set: has_header (key.to_string_32) and then get_header (key) = value.to_string_32
			end

		modify_header(key:STRING_GENERAL; value: STRING_GENERAL) is
			require
				arguments_not_void: key /= Void and value /= Void
				header_is_already_present: headers.has(key.to_string_32)
			do
				headers.replace (value.as_string_32, key.as_string_32)
			ensure
				header_changed: get_header (key).is_equal(value.to_string_32)
			end


	feature --Implementation
			headers: HASH_TABLE[STRING_32, STRING_32]
end
