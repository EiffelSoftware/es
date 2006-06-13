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
			-- NOTE: For the moment, should set path manually!
			-- Feel free to suggest a way for determining the path
			-- (Wiki: http://eiffersoftware.origo.ethz.ch/index.php/Internationalization)
			set_path("/home/etienne/messages.mo")
			create i18n_datastructure.make_with_file(path_to_file)
			create i18n_template_formatter.make
		ensure
			valid_datastructure: i18n_datastructure /= Void
			valid_template_formatter: i18n_template_formatter /= Void
		end

feature {SHARED_I18N_LOCALIZATOR} -- Basic operations
	translate(a_string: STRING_GENERAL): STRING_32 is
			-- What's the translated version of the string?
		require
			valid_string: a_string /= Void
		do
			Result := i18n_datastructure.translate([a_string, ""], 1)
		ensure
			valid_result: Result /= Void
		end

	translate_plural(a_string: TUPLE[STRING_GENERAL, STRING_GENERAL]; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th translated plural of the string?
		require
			valid_string: a_string /= Void
		local
			temp_string: STRING_GENERAL
				-- Temporary string
		do
			Result := i18n_datastructure.translate(a_string, a_num)
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

	set_path(a_path: STRING) is
			-- Set path_to_file to a_file.
		require
			valid_path: a_path /= Void
			non_empty_path: not a_path.is_empty
		do
			path_to_file := a_path
		ensure
			valid_path_to_file: path_to_file /= Void
			path_to_file_set: path_to_file.is_equal(a_path)
		end


feature {NONE} -- Implementation
	path_to_file: STRING
		-- Path to the localization file

	i18n_datastructure: I18N_DATASTRUCTURE
		-- Reference to the datastructure

	i18n_template_formatter: I18N_TEMPLATE_FORMATTER
		-- Reference to the template formatter

invariant
	valid_datastructure: i18n_datastructure /= Void
	valid_template_formatter: i18n_template_formatter /= Void

end
