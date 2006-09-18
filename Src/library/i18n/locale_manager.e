indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_MANAGER

	inherit
		SHARED_I18N_URI_PARSER

create make

feature -- Initialization

	make (a_uri : STRING_GENERAL) is
			-- Creation procedure
		require
			a_uri_exists: a_uri /= Void
		do
		end

feature -- Access

	get_locale ( a_locale_id : I18N_LOCALE_ID) : I18N_LOCALE is
			--
		require
			a_locale_id_exists: a_locale_id /= Void
		do
		end

	get_system_locale : I18N_LOCALE is
			--
		do
		end


feature -- Status report

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list of available locales
		do
		end

	has_translations (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		do
		end

	has_locale_info (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		do
		end

	has_locale (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		do
		end

feature -- Implementation

	dictionary_manager: I18N_DICTIONARY_MANAGER

end
