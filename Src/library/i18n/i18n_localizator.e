indexing
	description: "Provides functions for translation and templates solving."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
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
		do
			if new_i18n_datasource /= Void and new_i18n_datastructure /= Void then
				i18n_datasource := new_i18n_datasource
				i18n_datastructure := new_i18n_datastructure
				i18n_datastructure.load(i18n_datasource)
				new_i18n_datasource := Void
				new_i18n_datastructure := Void
			end
		end

feature {SHARED_I18N_LOCALIZATOR} -- Basic operations

	translate(a_string: STRING_GENERAL): STRING_32 is
			-- What's the translated version of the string?
		require
			valid_string: a_string /= Void
		do
			Result := i18n_datastructure.translate(a_string, "", 1)
		ensure
			valid_result: Result /= Void
		end

	translate_plural(a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th translated plural of the string?
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
		do
			Result := i18n_datastructure.translate(a_singular, a_plural, a_num)
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

	new_i18n_datasource: I18N_DATASOURCE
		-- Reference to the new datasource

	new_i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the new datastructure

	i18n_template_formatter: I18N_TEMPLATE_FORMATTER
		-- Reference to the template formatter

invariant
	valid_datasource: i18n_datasource /= Void and then i18n_datasource.is_ready
	valid_datastructure: i18n_datastructure /= Void
	valid_template_formatter: i18n_template_formatter /= Void

end
