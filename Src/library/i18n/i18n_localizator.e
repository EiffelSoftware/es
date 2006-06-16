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
		do
			-- Create the template formatter
			create i18n_template_formatter.make

			-- Create the datasource
			create i18n_datasource_factory.make_empty
			i18n_datasource := i18n_datasource_factory.last_datasource

			-- Create the datastructure
			create i18n_datastructure_factory.make_with_datasource (i18n_datasource)
			i18n_datastructure := i18n_datastructure_factory.last_datastructure
		ensure
			valid_datasource: i18n_datasource /= Void
			valid_datastructure: i18n_datastructure /= Void
			valid_template_formatter: i18n_template_formatter /= Void
		end

feature -- Loading
	set_resources_path(a_path: STRING) is
			-- Set the resources path.
		require
			valid_path: a_path /= Void
			not_empty_path: not a_path.is_empty
		do
			-- CCONTI
			-- To be implemented
		ensure
			valid_resources_path: resources_path /= Void
			resources_path_set: resources_path.is_equal(a_path)
		end

	set_language_identifier(a_identifier: STRING) is
			-- Set the language identifier.
		require
			valid_identifier: a_identifier /= Void
			not_empty_identifier: not a_identifier.is_empty
		do
			-- CCONTI
			-- To be implemented
		ensure
			valid_language_identifier: language_identifier /= Void
			language_identifier_set: language_identifier.is_equal(a_identifier)
		end

	load is
			-- Loads data, using actual parameters
		do
			-- CCONTI
			-- Should change this to use the two functions above!

			-- Create the datasource
				-- NOTE: For the moment, should set path manually!
				-- Feel free to suggest a way for determining the path
				-- (Wiki: http://eiffersoftware.origo.ethz.ch/index.php/Internationalization)
			i18n_datasource_factory.use_mo_file("/home/etienne/messages.mo")
			if i18n_datasource_factory.last_datasource = Void then
				i18n_datasource_factory.use_empty_source
			end

			-- Create the datastructure
			create i18n_datastructure_factory.make_with_datasource(i18n_datasource_factory.last_datasource)
			i18n_datastructure_factory.use_hash_table
			if i18n_datastructure_factory.last_datastructure = Void then
				i18n_datastructure_factory.use_dummy
			end
			i18n_datastructure := i18n_datastructure_factory.last_datastructure
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
		local
			temp_string: STRING_GENERAL
				-- Temporary string
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
	resources_path: STRING
		-- Path where to find the resources

	language_identifier: STRING
		-- Language identifier to be used

	i18n_datasource: I18N_DATASOURCE
		-- Reference to the datasource

	i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the datastructure

	i18n_template_formatter: I18N_TEMPLATE_FORMATTER
		-- Reference to the template formatter

	i18n_datastructure_factory: I18N_DATASTRUCTURE_FACTORY
		-- Reference to the datastructure factory

	i18n_datasource_factory: I18N_DATASOURCE_FACTORY
		-- Reference to the datasource factory

invariant
	valid_datastructure: i18n_datastructure /= Void
	valid_template_formatter: i18n_template_formatter /= Void

end
