indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DICTIONARY_ENTRY

	feature
		make(an_original_singular, a_translated_singular: STRING_GENERAL) is
				-- create the entry for a singular-form string
				require
					singular_not_void: an_original_singular /= Void
					translated_singular_not_void: a_translated_singular /= Void
				do
					original_singular := an_original_singular.to_string_32
					singular_translation := a_translated_singular.to_string_32
					create plural_translations.make (1,4) -- there are at most 4 forms
				ensure
					original_singular_set: original_singular.is_equal (an_original_singular.as_string_32)
					singular_translation_set: singular_translation.is_equal (a_translated_singular.as_string_32)
					plural_translations_array_exists: plural_translations /= Void
				end

		make_with_plural(an_original_singular, a_translated_singular, an_original_plural: STRING_GENERAL) is
				-- create the entry for a string with both plural and singular forms
				-- the actual plural translations will have to be added by hand!
				require
					singular_not_void: an_original_singular /= Void
					translated_singular_not_void: a_translated_singular /= Void
				do
					make(an_original_singular, a_translated_singular)
					original_plural := an_original_plural.to_string_32
				ensure
					original_singular_set: original_singular.is_equal (an_original_singular.as_string_32)
					singular_translation_set: singular_translation.is_equal (a_translated_singular.as_string_32)
					original_plural_set: original_plural.is_equal (an_original_plural.as_string_32)
					plural_translations_array_exists: plural_translations /= Void
				end


	feature
		-- Contents
		original_singular: STRING_32
		original_plural: STRING_32
		singular_translation: STRING_32
		plural_translations: ARRAY[TUPLE[INTEGER,STRING_32]]

end
