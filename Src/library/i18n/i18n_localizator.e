indexing
	description: "Provides functions for translation and templates solving."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALIZATOR

create {SHARED_I18N_LOCALIZATOR}
	make

feature {NONE} -- Initialization

	make is
			-- Creation procedure.
		local
			l_source_factory: I18N_DATASOURCE_FACTORY
			l_structure_factory: I18N_DATASTRUCTURE_FACTORY
				-- Temporary factories
		do
			-- Initialization of attributes
			language := ""
			resources_path := ""

			-- Create the template formatter
			create i18n_template_formatter.make

			-- Create the datasource
			create l_source_factory.make
			use_datasource(l_source_factory.last_datasource)

			-- Create the datastructure
			create l_structure_factory.make
			use_datastructure(l_structure_factory.last_datastructure)

			load

			l_structure_factory.use_hash_table
			use_datastructure(l_structure_factory.last_datastructure)
		ensure
			valid_datasource: i18n_datasource /= Void
			valid_datastructure: i18n_datastructure /= Void
			valid_template_formatter: i18n_template_formatter /= Void
			valid_language: language /= Void
			valid_resource_path: resources_path /= Void
		end

feature -- Settings and update

	load is
			-- Load the localizator.
		require
			new_i18n_datasource /= Void and then new_i18n_datasource.is_ready
		do
			i18n_datasource := new_i18n_datasource
			i18n_datastructure := new_i18n_datastructure
			reset_times
			start_loading_timer
			i18n_datastructure.load(i18n_datasource)
			stop_loading_timer
			new_i18n_datasource := Void
		end

	new_i18n_datasource: I18N_DATASOURCE
		-- Reference to the new datasource

	new_i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the new datastructure

	set_language (a_string: STRING) is
			-- set the language
		require
			a_string /= Void
		do
			language := a_string
		ensure
			language_set: language.is_equal(a_string)
		end

	set_resources_path (a_path: STRING) is
			-- Set the path where to look for translation files
		require
			path_not_void: a_path /= Void
		do
			resources_path := a_path
		ensure
			path_set: resources_path.is_equal(a_path)
		end

feature -- Setting datasource

	use_mo_file is
			-- Load translations from the MO file for current language.
			-- See `i18n_set_language' to specify the language (fallback is system language,
			-- `i18n_language' will be updated accordingly) and
			-- `i18n_set_resources_path' to specify where to look for files
			-- (fallback is current working directory). If no file can be loaded an empty
			-- source will be used and `i18n_source_error' will be set.
		local
			sys_lang, dir_separator: STRING
		do
			source_error := True
			dir_separator := Operating_environment.directory_separator.out
			if not language.is_empty then
				-- give preference to language, and then to path
				if not resources_path.is_empty then
					-- asked language in asked path
					use_mo_file_with_name (resources_path + dir_separator +	language + ".mo", language)
				end
				if source_error then
					-- asked language in working directory
					use_mo_file_with_name (Operating_environment.current_directory_name_representation +
						dir_separator + language + ".mo", language)
				end
			end
			if source_error then
				-- language fallback
				sys_lang := (create {SHARED_LOCALE_FACTORY}).locale.language_id
				if not resources_path.is_empty then
					-- system language in asked path
					use_mo_file_with_name (resources_path + dir_separator +	sys_lang + ".mo", sys_lang)
				end
				if source_error then
					-- system language in working directory
					use_mo_file_with_name (Operating_environment.current_directory_name_representation +
						dir_separator + sys_lang + ".mo", sys_lang)
				end
			end
			-- `source_error' is left as needed by the last call to `i18n_use_mo_file_with_name'
		end

	use_mo_file_with_name (a_name, a_language: STRING) is
			-- Load translations from MO file `a_name', you are encouraged to specify the language you
			-- are using as `a_language'. If the file cannot be used `i18n_source_error' will be set and
			-- an empty source will be used.
		require
			name_not_void: a_name /= Void
			name_not_empty: not a_name.is_empty -- use use_mo_file' instead
			language_not_void: a_language /= Void
		local
			source_factory: I18N_DATASOURCE_FACTORY
		do
			create source_factory.make
			source_factory.use_mo_file (a_name)
			if source_factory.last_datasource /= Void then
				use_datasource (source_factory.last_datasource)
				language := a_language
				source_error := False
			else
				source_factory.use_empty_source
				use_datasource (source_factory.last_datasource)
				source_error := True
			end
		ensure
			no_error_then_language_set: not source_error implies language.is_equal(a_language)
		end

	use_datasource (a_datasource: I18N_DATASOURCE) is
			-- Use this datasource.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			new_i18n_datasource := a_datasource
		ensure
			datasource_set: new_i18n_datasource = a_datasource
		end

feature -- Setting datastructure

	use_heap is
			-- Use hashing to retrieve translated strings.
			-- Fallback to a dummy datastructure on error.
		local
			structure_factory: I18N_DATASTRUCTURE_FACTORY
		do
			create structure_factory.make
			structure_factory.use_hash_table
			if structure_factory.last_datastructure /= Void then
				use_datastructure (structure_factory.last_datastructure)
				structure_error := False
			else
				structure_factory.use_dummy
				use_datastructure (structure_factory.last_datastructure)
				structure_error := True
			end
		end

	use_binary_search is
			-- Use binary search to retrieve translated strings.
			-- Fallback to a dummy datastructure on error.
		local
			structure_factory: I18N_DATASTRUCTURE_FACTORY
		do
			create structure_factory.make
			structure_factory.use_binary_search
			if structure_factory.last_datastructure /= Void then
				use_datastructure (structure_factory.last_datastructure)
				structure_error := False
			else
				structure_factory.use_dummy
				use_datastructure (structure_factory.last_datastructure)
				structure_error := True
			end
		end

	use_datastructure (a_datastructure: I18N_DATASTRUCTURE) is
			-- Use this datastructure.
		require
			valid_datastructure: a_datastructure /= Void
		do
			new_i18n_datastructure := a_datastructure
		ensure
			datastructure_set: new_i18n_datastructure = a_datastructure
		end

feature {SHARED_I18N_LOCALIZATOR} -- Basic operations

	translate (a_string: STRING_GENERAL): STRING_32 is
			-- What's the translated version of the string?
		require
			valid_string: a_string /= Void
		do
			start_translation_timer
			Result := i18n_datastructure.translate(a_string, "", 1)
			stop_translation_timer
		ensure
			valid_result: Result /= Void
		end

	translate_plural (a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th translated plural of the string?
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
		do
			start_translation_timer
			Result := i18n_datastructure.translate(a_singular, a_plural, a_num)
			stop_translation_timer
		ensure
			valid_result: Result /= Void
		end

	solve_template (a_string: STRING_32; a_args: TUPLE): STRING_32 is
			-- What's the completed form of the template?
			-- NOTE: this feature doesn't connect to the datastructure!
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		do
			Result := i18n_template_formatter.solve_template(a_string, a_args)
		ensure
			valid_result: Result /= Void
		end

feature -- Status

	source_error: BOOLEAN
		-- True if the lats requested datasource could not be used.

	structure_error: BOOLEAN
		-- True if the last requested datastructure could not be used.

	language : STRING
		-- Last requested language; NOTE: this doesn't necessarily reflect the currently used one.

	resources_path: STRING
		-- Path where the translation files are located

feature {NONE} -- Implementation

	i18n_datasource: I18N_DATASOURCE
		-- Reference to the datasource

	i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the datastructure

	i18n_template_formatter: I18N_TEMPLATE_FORMATTER
		-- Reference to the template formatter

feature {SHARED_I18N_LOCALIZATOR} -- Timing access

	translation_time, loading_time: TIME_DURATION
		-- Total translation/loading time

feature {NONE} -- Timing implementation

	translation_timer, loading_timer: TIME
		-- Time of last translation/loading timer start

	reset_times is
			-- Reset all the timers.
		do
			create translation_time.make_by_seconds(0)
			create loading_time.make_by_seconds(0)
		end

	start_translation_timer is
			-- Starts the translation timer.
		do
			create translation_timer.make_now
		end

	stop_translation_timer is
			-- Stops the translation timer and add the duration to translation_time.
		require
			translation_time /= Void
			translation_timer /= Void
		local
			now: TIME
		do
			create now.make_now
			translation_time := translation_time + (now.duration - translation_timer.duration)
		end

	start_loading_timer is
			-- Start the translation timer.
		do
			create loading_timer.make_now
		end

	stop_loading_timer is
			-- Stops the loading timer and add the duration to loading_time.
		require
			loading_time /= Void
			loading_timer /= Void
		local
			now: TIME
		do
			create now.make_now
			loading_time := loading_time + (now.duration - loading_timer.duration)
		end

invariant

	valid_datasource: i18n_datasource /= Void
	ready_new_datasource_if_exists: new_i18n_datasource /= Void implies new_i18n_datasource.is_ready
	valid_datastructure: i18n_datastructure /= Void
	valid_template_formatter: i18n_template_formatter /= Void
	valid_language: language /= Void
	valid_resource_path: resources_path /= Void

end
