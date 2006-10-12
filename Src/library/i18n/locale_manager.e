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
			l_local_info: I18N_LOCALE_INFO
			l_dictionary: I18N_DICTIONARY
			l_locale: I18N_LOCALE
		do
			l_local_info := system_locales.get_locale_info (a_locale_id)
			l_dictionary := datasource_manager.get_dictionary (a_locale_id)
			create l_locale.make(l_dictionary,l_local_info)
			Result := l_locale
		end

	get_system_locale : I18N_LOCALE is
		--
		local
			l_local_info: I18N_LOCALE_INFO
			l_dictionary: I18N_DICTIONARY
			l_locale: I18N_LOCALE
		do
			l_local_info := system_locales.get_user_locale_info
			l_dictionary := datasource_manager.get_dictionary (l_local_info.id)
			create l_locale.make(l_dictionary,l_local_info)
			Result := l_locale
		end


feature -- Status report

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list of available locales
		local
			l_list:LINKED_LIST[I18N_LOCALE_ID]
			l_list2:LINEAR[I18N_LOCALE_ID]
		do
			create l_list.make
			l_list2 := system_locales.available_locales
			from
				l_list2.start
			until
				l_list2.after
			loop
				l_list.extend (l_list2.item)
				l_list2.forth
			end
			l_list2 := datasource_manager.available_locales
			from
				l_list2.start
			until
				l_list2.after
			loop
				if l_list.has (l_list2.item) then
					l_list.extend (l_list2.item)
					l_list.forth
				end
			end
			Result:=l_list

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
		do
			Result := system_locales.has_locale(a_locale_id) or datasource_manager.has_locale (a_locale_id)
		end

feature -- Implementation

	datasource_manager: I18N_DATASOURCE_MANAGER
	system_locales:I18N_SYSTEM_LOCALES

end
