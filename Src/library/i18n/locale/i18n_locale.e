indexing
	description: "Objects to store the informations regarding the locale."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE

feature -- Access
	language_id: STRING
		-- Language id

feature {I18N_LOCALE_FACTORY} -- Basic operations
	set_language_id(a_id: STRING) is
			-- Set language id.
		require
			a_id /= Void and then not a_id.is_empty
		do
			language_id := a_id
		ensure
			language_id /= Void and then language_id.is_equal(a_id)
		end

invariant
	invariant_clause: True -- Your invariant here

end
