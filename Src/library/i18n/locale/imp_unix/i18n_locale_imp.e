indexing
	description: "Locale information retrieval on Linux."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_IMP

inherit
	I18N_LOCALE
	redefine
		default_create
	end

creation
	default_create

feature -- Initialization

	default_create is
			-- Retrieve language
		do
			language_id := (create {EXECUTION_ENVIRONMENT}).get("LANG")
			if language_id = Void then
				language_id := ""
			end
		ensure then
			valid_language_id: language_id /= Void
		end

end
