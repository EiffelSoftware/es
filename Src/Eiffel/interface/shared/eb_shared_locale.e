class
        EB_SHARED_LOCALE

inherit
	EB_SHARED_PREFERENCES


feature -- locale

        locale:I18N_LOCALE is
                -- Shared locale
        local
                locale_manager: I18N_LOCALE_MANAGER
		id: I18N_LOCALE_ID
        once
                create locale_manager.make("/home/leo/semesterarbeit/es_mo/")
		if preferences_initialized then
			create id.make_from_string(preferences.dialog_data.dialog_locale_preference.string_value)
			if locale_manager.has_locale(id) then
				Result := locale_manager.get_locale(id)
			else	
				Result := locale_manager.get_system_locale
			end
		else
			Result := locale_manager.get_system_locale
		end
        end

end

