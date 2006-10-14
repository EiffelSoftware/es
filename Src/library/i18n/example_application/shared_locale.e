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
			create locale_manager.make (Operating_environment.Current_directory_name_representation+
										Operating_environment.Directory_separator.out+"mo_files")
			Result := locale_manager.get_system_locale
		end



feature {NONE} -- Locale

	locale_manager: I18N_LOCALE_MANAGER

end
