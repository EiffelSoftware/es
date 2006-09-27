indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DICTIONARY

	inherit
		SHARED_I18N_PLURAL_TOOLS


feature -- Creation

	make(a_plural_form:INTEGER) is
			-- Create an empty dictionary with the given plural form
			require
				valid_plural_form: plural_tools.valid_plural_form (plural_form)
			do
				plural_form := a_plural_form
			ensure
				plural_form_set: a_plural_form = plural_form
			end



feature  -- Manipulation

	-- this should be restricted

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

	has_plural (original_singular, original_plural : STRING_GENERAL; plural_number : INTEGER) : BOOLEAN is
			--
		require
			original_singular_exists: original_singular /= Void
			original_plural_exists: original_plural /= Void
			valid_plural_number: plural_number >= 0
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

	get_plural (original_singular, original_plural : STRING_GENERAL; plural_number : INTEGER) : STRING_32 is
			-- get the translation of `original_singular'
			-- in the given plural form
		require
			original_singular_exists: original_singular /= Void
			original_plural_exists: original_plural /= Void
			valid_plural_number: plural_number >= 0
			translation_exists:has_plural (original_singular, original_plural, plural_number)
		deferred
		ensure
			result_exists: Result /= Void
		end

	feature --Information

		plural_form: INTEGER --valid constant from I18N_PLURAL_TOOLS

		count: INTEGER is
				 deferred
				 ensure
				 	count_non_negative: Result >= 0
				 end
			-- number of entries in the dictionary

	feature {NONE} --Helpers
		reduce(a_plural_form:INTEGER):INTEGER is
				-- reduce a given plural forms to a smallest one
			require
				a_plural_form >= 0
			do
				Result := plural_tools.reduce (plural_form, a_plural_form)
			end

end
