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
			datasource_manager := Parser.parse_uri (a_uri)
			create system_locales
		end

feature -- Access

	get_locale ( a_locale_id : I18N_LOCALE_ID): I18N_LOCALE is
			--
		require
			a_locale_id_exists: a_locale_id /= Void
		local
			l_locale_info: I18N_LOCALE_INFO
			l_dictionary: I18N_DICTIONARY
		do
			if has_translations (a_locale_id) then
				l_dictionary := datasource_manager.get_dictionary (a_locale_id)
			else
				create {I18N_DUMMY_DICTIONARY}	l_dictionary
			end
			if has_formatting_info (a_locale_id) then
				l_locale_info := system_locales.get_locale_info (a_locale_id)
			else
				create l_locale_info.make -- will have default values	
			end
			create Result.make (l_dictionary, l_locale_info)
		end

	get_system_locale : I18N_LOCALE is
			--
		do
			Result := get_locale(system_locales.get_user_locale_info.id)
		end


feature -- Status report

	available_locales : LIST[I18N_LOCALE_ID] is
			-- list of available locales
		local
			temp: LINEAR[I18N_LOCALE_ID]
		do
			create {LINKED_LIST[I18N_LOCALE_ID]} Result.make
			Result.fill(system_locales.available_locales)
			temp := datasource_manager.available_locales
			from
				temp.start
			until
				temp.after
			loop
				if not Result.has (temp.item) then
					Result.extend (temp.item)
				end
				temp.forth
			end

		end

	has_translations (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		do
			Result:=datasource_manager.has_locale (a_locale_id)
		end

	has_formatting_info (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		do
			Result:=system_locales.has_locale (a_locale_id)
		end

	has_locale (a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			--
		local
			generic_script: I18N_LOCALE_ID
		do
			Result := system_locales.has_locale(a_locale_id) or datasource_manager.has_locale (a_locale_id)
		end

feature -- Implementation

	datasource_manager: I18N_DATASOURCE_MANAGER
	system_locales:I18N_SYSTEM_LOCALES

end
