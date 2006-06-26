indexing
	description: "Shared class to load always the same localizator."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_I18N_LOCALIZATOR

feature {NONE} -- Basic operations

	i18n (a_string: STRING_GENERAL): STRING_32 is
			-- What is the translation of `a_string'?
		require
			valid_string: a_string /= Void
		do
			Result := i18n_localizator.translate(a_string)
		ensure
			valid_result: Result /= Void
		end

	i18n_pl (a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
			-- What's the `a_num'-th plural of the string?
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
		do
			Result := i18n_localizator.translate_plural(a_singular, a_plural, a_num)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp (a_string: STRING_GENERAL; a_args: TUPLE): STRING_32 is
			-- Translate and do variables substitution on the template `a_string'
			-- NOTE: Should change the name!
		obsolete
			"You should use a different template engine! The built-in one will be removed."
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		local
			l_string: STRING_32
				-- Temporary string
		do
			l_string := i18n_localizator.translate(a_string)
			Result := i18n_localizator.solve_template(l_string, a_args)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp_pl (a_singular, a_plural: STRING_GENERAL; a_args: TUPLE; i_th: INTEGER): STRING_32 is
			-- Return plural form of the template `a_string' for `i_th' items and do variables substitution
			-- NOTE: Should change the name!
		obsolete
			"You should use a different template engine! The built-in one will be removed."
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
			valid_args: a_args /= Void
		local
			l_string: STRING_32
				-- Temporary string
		do
			l_string := i18n_localizator.translate_plural(a_singular, a_plural, i_th)
			Result := i18n_localizator.solve_template(l_string, a_args)
		ensure
			valid_result: Result /= Void
		end

feature -- Settings and update

	i18n_set_language (a_string: STRING) is
			-- set the language
		require
			a_string /= Void
		do
			i18n_localizator.set_language(a_string)
		ensure
			i18n_language /= Void and then i18n_language.is_equal (a_string)
		end

	i18n_set_resources_path (a_path: STRING) is
			-- Set the path where to look for translation files
		require
			path_not_void: a_path /= Void
		do
			i18n_localizator.set_resources_path(a_path)
		ensure
			i18n_resources_path /= Void and then i18n_resources_path.is_equal (a_path)
		end

	i18n_load is
			-- Load the translated strings from the new datasource into the new datastructure.
		do
			i18n_localizator.load
		end

feature -- Setting datasource

	i18n_use_mo_file is
			-- Load translations from the MO file for current language.
			-- See `i18n_set_language' to specify the language (fallback is system language,
			-- `i18n_language' will be updated accordingly) and
			-- `i18n_set_resources_path' to specify where to look for files
			-- (fallback is current working directory). If no file can be loaded an empty
			-- source will be used and `i18n_source_error' will be set.
		require
			i18n_language /= Void
			i18n_resources_path /= Void
		do
			i18n_localizator.use_mo_file
		end

	i18n_use_mo_file_with_name (a_name, a_language: STRING) is
			-- Load translations from MO file `a_name', you are encouraged to specify the language you
			-- are using as `a_language'. If the file cannot be used `i18n_source_error' will be set and
			-- an empty source will be used.
		require
			name_not_void: a_name /= Void
			name_not_empty: not a_name.is_empty -- use i18n_use_mo_file' instead
			language_not_void: a_language /= Void
		do
			i18n_localizator.use_mo_file_with_name(a_name, a_language)
		ensure
			no_error_then_language_set: not i18n_source_error implies i18n_language.is_equal(a_language)
		end

	i18n_use_datasource (a_datasource: I18N_DATASOURCE) is
			-- Use `a_datasource' to load translations.
			-- You are responsible to supply a valid `a_datasource', `i18n_source_error' is not updated.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			i18n_localizator.use_datasource(a_datasource)
		end

feature -- Setting datastructure

	i18n_use_heap is
			-- Use hashing to retrieve translated strings.
			-- Fallback to a dummy datastructure on error.
		do
			i18n_localizator.use_heap
		end

	i18n_use_binary_search is
			-- Use binary search to retrieve translated strings.
			-- Fallback to a dummy datastructure on error.
		do
			i18n_localizator.use_binary_search
		end

	i18n_use_datastructure (a_datastructure: I18N_DATASTRUCTURE) is
			-- Use `a_datastructure' to keep translations in memory and retrieve them.
			-- You are responsible to supply a `valid a_datastructure', `i18n_structure_error' is not updated.
		require
			valid_datastructure: a_datastructure /= Void
		do
			i18n_localizator.use_datastructure(a_datastructure)
		end

feature -- Status

	i18n_source_error: BOOLEAN is
			-- True if the lats requested datasource could not be used.
		do
			Result := i18n_localizator.source_error
		end

	i18n_structure_error: BOOLEAN is
			-- True if the last requested datastructure could not be used.
		do
			Result := i18n_localizator.structure_error
		end

	i18n_language: STRING is
			-- Last requested language; NOTE: this doesn't necessarily reflect the currently used one.
		do
			Result := i18n_localizator.language
		end

	i18n_resources_path: STRING is
			-- Path where the translation files are located
		do
			Result := i18n_localizator.resources_path
		end

feature -- Time statistics

	i18n_translation_time: STRING is
			-- What is the actual translation time?
		do
			Result := i18n_localizator.translation_time.fine_seconds_count.out
		end

	i18n_loading_time: STRING is
			-- What is the actual loading time?
		do
			Result := i18n_localizator.loading_time.fine_seconds_count.out
		end

feature {NONE} -- Implementation

	i18n_localizator: I18N_LOCALIZATOR is
			-- Unique instance of the localizator
		once
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

end
