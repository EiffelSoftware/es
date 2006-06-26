indexing
	description: "Object used to get the locale for the current platform."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_LOCALE_FACTORY

feature -- Basic Operations

	locale: I18N_LOCALE is
			-- Create the `locale' for the current platform.
		once
			create {I18N_LOCALE_IMP} Result
		end

end
