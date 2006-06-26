indexing
	description: "Abstract factory to create a I18N_LOCALE object."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_LOCALE_FACTORY

feature -- locale

	get_actual_locale: I18N_LOCALE is
		require
		deferred
		ensure
			Result /= Void
		end

end
