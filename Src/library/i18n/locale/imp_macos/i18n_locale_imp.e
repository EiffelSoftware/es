indexing
	description: "Locale information retrieval on macosx."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_IMP

inherit
	I18N_LOCALE

feature -- Initialization

	make is
			-- Retrieve language
		do
			language_id := create ({EXECUTION_ENVIRONMENT}).get("LANG")
		end

end
