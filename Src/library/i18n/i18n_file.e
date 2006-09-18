indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_FILE

feature
	-- creation
	make (path: STRING_GENERAL) is
			-- attempts to open the file at path - if opened or/and valid is not true after make was called something went wrong.
		deferred
		end

 feature
 	-- information
 	locale: STRING_32 is
 			-- target locale of the file, possibly derived from the file name
 		deferred
 		end

 	plural_form: INTEGER
 			-- the plural form used by the file
 			-- This may have exactly 10 values:
 			-- 0: unknown/unitialised/no plural support
 			-- 1: Only one form (Chinese, Japanese, Korean, Turkish etc..)
 			-- 2: Two forms, singular used for one only (Germanic languages: English uses this)
 			-- 3: Two forms, singular used for zero and one (Romanic languages)
 			-- 4: Three forms, special case for zero (Baltic languages, e.g Latvian)
 			-- 5: Three forms, special cases for one and two (Irish, Arabic, etc.)
 			-- 6: Three forms, special case for numbers ending in 1[2-9] (Lithuanian)
 			-- 7: Three forms, special cases for numbers ending in 1 and 2, 3, 4, except those ending in 1[1-4] (Slavic languages)
 			-- 8: Three forms, special case for one and some numbers ending in 2, 3, or 4 (Polish)
 			-- 9: Four forms, special case for one and all numbers ending in 02, 03, or 04 (Slovenian)	
 			-- See I18N_PLURAL_TOOLS for more information

	entry_count: INTEGER
				-- Number of entries in the file.

	feature
		--entry access

		entry_has_plurals(i: INTEGER): BOOLEAN is
				-- does this entry have any plurals?
			require
				open_and_valid: open and valid
				i_valid_index: i < 10 and i >= 0
			deferred

			end


		original_singular_string(i: INTEGER):STRING_32 is
				-- Get the original singular string for this entry
			require
				open_and_valid: open and valid
				i_valid_index: i < 10 and i >= 0
			deferred
			end

		original_plural_string(i:INTEGER):STRING_32 is
				--  Get the original plural string for this entry. May return Void if there are none!
			require
				open_and_valid: open and valid
				plurals_exist: entry_has_plurals(i)
			deferred
			end

		translated_plural_strings(i:INTEGER):ARRAY[TUPLE[INTEGER,STRING_32]] is
				--  get the translated plural string for this entry. May return Void if there are none!
			require
				open_and_valid: open and valid
				plurals_exist: entry_has_plurals(i)
			deferred
			end

		translated_singular_string(i:INTEGER):STRING_32 is
				-- get the translated singular string for this entry
			require
				open_and_valid: open and valid
				i_valid_index: i < 10 and i >= 0
			deferred
			end

 feature
 	-- mechanics

	open: BOOLEAN -- is the file opened?
	valid: BOOLEAN -- could the file be parsed correctly?

	close is
			-- closes the file
		require
			open -- can't close file if not open
		deferred
		end


invariant
	plural_form_correct: plural_form < 10 and plural_form >= 0
	valid_only_if_opened: valid implies open

end
