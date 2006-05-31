indexing
	description: "Object containing original and translated strings, for localization purposes."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_STRING

create {I18N_DATASTRUCTURE}
	make_with_id

feature {NONE} -- Initialization

	make_with_id(a_id: INTEGER) is
			-- Initialize `Current'.
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

feature -- Access
	hash: INTEGER
		-- Hash of the string

	original: ARRAY[STRING_32]
		-- Original string

	translated: ARRAY[STRING_32]
		-- Translated string

feature -- Status report
	has_plural: BOOLEAN is
			-- Has this string a plural form?
		require
			valid_original: original /= Void
		do
			Result := original.count > 1
		end

	has_translation(i_th: INTEGER): BOOLEAN is
			-- Is there the i_th translated version?
		do
			if i_th <= translated.upper then
				Result := (translated /= Void) and then (translated.item(i_th) /= Void)
			end
		end

feature -- Basic operations
	get_original(i_th: INTEGER): STRING_32 is
			-- Which is the i_th plural of the original string?
		require
			valid_original: original /= Void
		do
			if i_th = 1 then
				Result := original.item(1)
			else
				Result := original.item(2)
			end
		end

	get_translated(i_th: INTEGER): STRING_32 is
			-- Which is the i_th plural of the translated string?
		require
			valid_translated: translated /= Void
		do
			if (i_th <= translated.upper and then translated.item(i_th) /= Void) then
				Result := translated.item(i_th)
			end
		end


	set_hash(a_hash: INTEGER) is
			-- Set the hash of the original string.
		do
			hash := a_hash
		ensure
			hash_set: hash = a_hash
		end

	set_originals(a_strings: LIST[STRING_32]) is
			-- Set the i_th original string.
		require
			valid_string: a_strings /= Void
		do
			create original.make(1, 2)
			original.put(a_strings.i_th(1), 1)
			original.put(a_strings.i_th(2), 2)
		ensure
			original_set: original.count = a_strings.count
		end

	set_translateds(a_strings: LIST[STRING_32]) is
			-- Set the i_th translated string.
		require
			valid_string: a_strings /= Void
		do
			create translated.make(0, (a_strings.count -1))
			translated.fill(a_strings)
--			from
--				a_strings.start
--			until
--				a_strings.after
--			loop
--				translated.put(a_strings.item, a_strings.index)
--				a_strings.forth
--			end
		ensure
			translated_set: translated.count = a_strings.count
		end


feature {NONE} -- Implementation
	id: INTEGER
		-- Sequence number into the mo file

invariant
	invariant_clause: True -- Your invariant here

end
