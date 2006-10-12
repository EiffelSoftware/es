indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_SYSTEM_LOCALES


feature -- Informations

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list of available locales
		do
			Result := host_locale.available_locales
		ensure
--			correct_result: Result = host_locale.available_locales
		end

	has_locale (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is the locale with a_locale_id available?
		do
			Result := host_locale.is_available (a_locale_id)
					-- or host_locale.is_available (create {I18N_LOCALE_ID}.make(a_locale_id.language, a_locale_id.region, Void))
		ensure
			correct_result: Result = host_locale.is_available (a_locale_id)
		end

	get_locale_info (a_locale_id: I18N_LOCALE_ID): I18N_LOCALE_INFO is
			--
		do
			Result := host_locale.make_from_locale (a_locale_id)
		ensure
			Result_exists: Result /= Void
		end

	get_user_locale_info: I18N_LOCALE_INFO is
			-- get the default locale info
		do
			Result := host_locale.make_from_user_locale
		end


feature {NONE} -- Implementation

	host_locale : I18N_HOST_LOCALE is
			--
		once
			create {I18N_HOST_LOCALE_IMP} Result
		end


end
