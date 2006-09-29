indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_FILE_MANAGER inherit

		I18N_DATASOURCE_MANAGER
		redefine
			make
		end

	feature
		-- Creation
		make (an_uri: STRING_GENERAL) is
			do
				Precursor(an_uri)
			end


	feature
		-- Access
		get_dictionary(a_locale: I18N_LOCALE_ID): I18N_DICTIONARY is
				-- return appropriate dictionary
				do

				end

		available_locales: LINEAR[I18N_LOCALE_ID] is
				--
				do

				end



end
