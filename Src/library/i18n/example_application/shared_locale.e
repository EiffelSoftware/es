indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_LOCALE

feature -- Initialization

	locale: I18N_LOCALE is
			--
		do
			if current_locale /= Void then
				Result := current_locale
			else
				create locale_manager.make (Operating_environment.Current_directory_name_representation+
											Operating_environment.Directory_separator.out+"mo_files")
				current_locale := locale_manager.get_system_locale
				available_locales := locale_manager.available_locales
				Result := current_locale
			end
		end

	set_locale (a_locale: STRING_32) is
			--
		local
			l_locale_id: I18N_LOCALE_ID
		do
			create l_locale_id.make_from_string (a_locale)
			from
				available_locales.start
			until
				available_locales.after or else
				available_locales.item.is_equal (l_locale_id)
			loop
				available_locales.forth
			end
			current_locale := locale_manager.get_locale (available_locales.item)
		end




feature {NONE} -- Locale

	locale_manager: I18N_LOCALE_MANAGER
	current_locale: I18N_LOCALE
	available_locales: LIST[I18N_LOCALE_ID]

end
