indexing
	description: "Factory to create a I18N_LOCALE object under macosx."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_MACOSX_LOCALE_FACTORY

inherit
	I18N_LOCALE_FACTORY

feature -- Locale
	get_actual_locale: I18N_LOCALE is
		require else
		local
			environment: EXECUTION_ENVIRONMENT
		do
			create Result
			create environment
			Result.set_language_id(environment.get("LANG"))
		ensure then
		end

invariant
	invariant_clause: True -- Your invariant here

end
