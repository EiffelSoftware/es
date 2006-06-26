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
		end

feature -- Loading
	use_datasource(a_datasource: I18N_DATASOURCE) is
			-- Use this datasource.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			new_i18n_datasource := a_datasource
		ensure
			datasource_set: new_i18n_datasource = a_datasource
		end

	use_datastructure(a_datastructure: I18N_DATASTRUCTURE) is
			-- Use this datastructure.
		require
			valid_datastructure: a_datastructure /= Void
		do
			new_i18n_datastructure := a_datastructure
		ensure
			datastructure_set: new_i18n_datastructure = a_datastructure
		end

	load is
			-- Load the localizator.
		require
			new_i18n_datasource /= Void
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

feature {SHARED_I18N_LOCALIZATOR} -- Basic operations
	translate(a_string: STRING_GENERAL): STRING_32 is
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

	translate_plural(a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
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

	solve_template(a_string: STRING_32; a_args: TUPLE): STRING_32 is
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

feature {NONE} -- Implementation

	i18n_datasource: I18N_DATASOURCE
		-- Reference to the datasource

	i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the datastructure

	i18n_template_formatter: I18N_TEMPLATE_FORMATTER
		-- Reference to the template formatter


feature {SHARED_I18N_LOCALIZATOR} -- Timing access

	translation_time, loading_time: TIME_DURATION


feature {NONE} -- Timing implementation

	translation_timer, loading_timer: TIME

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
	valid_datasource: i18n_datasource /= Void and then i18n_datasource.is_ready
	valid_datastructure: i18n_datastructure /= Void
	valid_template_formatter: i18n_template_formatter /= Void

end
