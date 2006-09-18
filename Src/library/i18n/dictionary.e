indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DICTIONARY

	inherit
		I18N_PLURAL_TOOLS

feature -- Manipulation

	extend (a_entry : I18N_DICTIONARY_ENTRY) is
			-- add a_entry in the datastructure
		require
			a_entry_exists: a_entry /= Void
			-- not already in datastructure
		deferred
		end

feature -- Access

	has (original : STRING_GENERAL) : BOOLEAN is
			-- is there an entry with original?
		require
			original_exists: original /= Void
		deferred
		end

	has_plural (original_singular, original_plural : STRING_GENERAL; plural_form : INTEGER) : BOOLEAN is
			--
		require
			original_singular_exists: original_singular /= Void
			original_plural_exists: original_plural /= Void
			valid_plural_form: plural_form >= 0
		deferred
		end

	get_singular ( original : STRING_GENERAL) : STRING_32 is
			-- get the translation of `original'
			-- in the singular form
		require
			original_exists: original /= Void
			translation_exists: has (original)
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_plural (original_singular, original_plural : STRING_GENERAL; plural_form : INTEGER) : STRING_32 is
			-- get the translation of `original_singular'
			-- in the given plural form
		require
			original_singular_exists: original_singular /= Void
			original_plural_exists: original_plural /= Void
			valid_plural_form: plural_form >= 0
		deferred
		ensure
			result_exists: Result /= Void
		end
end
