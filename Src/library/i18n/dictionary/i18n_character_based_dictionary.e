indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_CHARACTER_BASED_DICTIONARY
inherit
	I18N_DICTIONARY
		redefine
			make
		end


feature -- Initialization

	make(a_plural_form:INTEGER;a_number_of_entries:INTEGER) is
			-- create the datastructure
		do
			Precursor(a_plural_form,a_number_of_entries)
			create singular_char_tree
			create plural_char_tree
		end

feature  -- Manipulation

	-- this should be restricted

	extend (a_entry : I18N_DICTIONARY_ENTRY) is
			-- add a_entry in the datastructure
		do
			if a_entry.original_plural /= Void then
				-- entry has no plurals
				singular_char_tree.insert (a_entry, a_entry.original_singular)
			else
				-- entry has plurasl
				plural_char_tree.insert (a_entry, a_entry.original_plural)
			end
			count := count + 1
		end

feature -- Access

	has (original : STRING_GENERAL) : BOOLEAN is
			-- is there an entry with original?
		do
			Result := singular_char_tree.has_key (original.as_string_32)
			if not Result then
				Result := plural_char_tree.has_key (original.as_string_32)
			end
		end

	has_plural (original_singular, original_plural : STRING_GENERAL; plural_number : INTEGER) : BOOLEAN is
			--
		local
			entry: I18N_DICTIONARY_ENTRY
		do
			if singular_char_tree.has_key (original_singular.as_string_32) then
				entry := plural_char_tree.get (original_plural.as_string_32)
				if entry.plural_translations.item(reduce (plural_number)) /= Void then
					Result := True
				end
			end
		end

	get_singular ( original : STRING_GENERAL) : STRING_32 is
			-- get the translation of `original'
			-- in the singular form
		do
			Result := singular_char_tree.get (original.as_string_32).singular_translation
		end

	get_plural (original_singular, original_plural : STRING_GENERAL; plural_number : INTEGER) : STRING_32 is
			-- get the translation of `original_singular'
			-- in the given plural form
		do
			Result := plural_char_tree.get(original_plural.as_string_32).plural_translations.item(reduce (plural_number))
		end

feature --Information


		count: INTEGER

			-- number of entries in the dictionary
feature {NONE}  -- Implementation

	singular_char_tree: CHARACTER_TREE[I18N_DICTIONARY_ENTRY]
			-- tree that contains all entries without plurals

	plural_char_tree: CHARACTER_TREE[I18N_DICTIONARY_ENTRY]
			-- tree that contains all entries with plurals

end
