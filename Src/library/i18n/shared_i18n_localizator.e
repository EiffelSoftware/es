indexing
	description: "Shared class to load always the same localizator."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_I18N_LOCALIZATOR

feature {NONE} -- Basic operations
	i18n(a_string: STRING_GENERAL): STRING_32 is
			-- What's the localized version of the string?
			-- NOTE: Should change the name?
		require
			valid_string: a_string /= Void
		do
			Result := localizator.translate(a_string)
		ensure
			valid_result: Result /= Void
		end

	i18n_pl(a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th plural of the string?
			-- NOTE: Should change the name?
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
		do
			Result := localizator.translate_plural(a_singular, a_plural, a_num)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp(a_string: STRING_GENERAL; a_args: TUPLE): STRING_32 is
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
			l_string := localizator.translate(a_string)
			Result := localizator.solve_template(l_string, a_args)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp_pl(a_singular, a_plural: STRING_GENERAL; a_args: TUPLE; i_th: INTEGER): STRING_32 is
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
			l_string := localizator.translate_plural(a_singular, a_plural, i_th)
			Result := localizator.solve_template(l_string, a_args)
		ensure
			valid_result: Result /= Void
		end


feature -- Settings and update
	i18n_use_datasource(a_datasource: I18N_DATASOURCE) is
			-- Use this datasource.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			localizator.use_datasource(a_datasource)
		end

	i18n_use_datastructure(a_datastructure: I18N_DATASTRUCTURE) is
			-- Use this datastructure.
		require
			valid_datastructure: a_datastructure /= Void
		do
			localizator.use_datastructure(a_datastructure)
		end

	i18n_load is
			-- Load the translated strings from the new datasource into the new datastructure.
		do
			localizator.load
		end

	-- OBSOLETE: should pass a valid datasource and a valid datastructure to the localizator, the work
	--           of selecting the path and the language identifier is done out of the i18n library.
	-- See functions above for more details.

	i18n_set_resources_path (a_path: STRING) is
			-- Set path where to look for MO file, default is working directory
		do
			localizator.set_resources_path (a_path)
		end

	i18n_set_language (identifier: STRING) is
			-- ISO639-2 code for the language to load
		do
			localizator.set_language_identifier (identifier)
		end


feature {NONE} -- Implementation
	localizator: I18N_LOCALIZATOR is
			-- Unique instance of the localizator
		once
			create Result.make
		end

invariant
	valid_localizator: localizator /= Void

end
