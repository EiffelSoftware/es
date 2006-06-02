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

	originals: LIST[STRING_32]
		-- Original string

	translateds: LIST[STRING_32]
		-- Translated string

feature -- Status report
	has_plural: BOOLEAN is
			-- Has this string a plural form?
		require
			valid_originals: originals /= Void
		do
			Result := originals.count > 1
		end

	has_translation(i_th: INTEGER): BOOLEAN is
			-- Is there the i_th translated version?
		do
			if i_th <= translateds.count then
				Result := (translateds /= Void) and then (translateds.i_th(i_th) /= Void)
			end
		end

feature -- Basic operations
	get_original(i_th: INTEGER): STRING_32 is
			-- Which is the i_th plural of the original string?
		require
			valid_originals: originals /= Void
		do
			if i_th = 1 or not has_plural then
				Result := originals.i_th(1)
			else
				Result := originals.i_th(2)
			end
		end

	get_translated(i_th: INTEGER): STRING_32 is
			-- Which is the i_th plural of the translated string?
		require
			valid_translateds: translateds /= Void
		do
			if (i_th <= translateds.count and then translateds.i_th(i_th) /= Void) then
				Result := translateds.i_th(i_th)
			else
				Result := translateds.i_th(translateds.count)
			end
		end

	set_hash(a_hash: INTEGER) is
			-- Set the hash of the original string.
		do
			hash := a_hash
		ensure
			hash_set: hash = a_hash
		end

	set_originals(a_originals: LIST[STRING_32]) is
			-- Set the i_th original string.
		require
			valid_string: a_originals /= Void
		do
			originals := a_originals
		ensure
			originals_set: originals.count = a_originals.count
		end

	set_translateds(a_translateds: LIST[STRING_32]) is
			-- Set the i_th translated string.
		require
			valid_string: a_translateds /= Void
		do
			translateds := a_translateds
		ensure
			translateds_set: translateds.count = a_translateds.count
		end

feature {NONE} -- Implementation
	id: INTEGER
		-- Sequence number into the mo file

invariant
	invariant_clause: True -- Your invariant here

end
