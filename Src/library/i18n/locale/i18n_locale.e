indexing
	description: "Objects to store the informations regarding the locale."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_LOCALE


feature -- Access

	language_id: STRING
		-- Language id

invariant
	language_not_void: language_id /= Void

end
