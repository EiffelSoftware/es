indexing
	description: "Objects used to create the right factory, and only once."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_LOCALE_FACTORY

feature -- Basic Operations

	factory: I18N_LOCALE_FACTORY is
			-- Factory used for get_locale feature
		local
			platform: PLATFORM
		once
			create platform
			if platform.is_windows then
				create {I18N_WINDOWS_LOCALE_FACTORY} Result
			elseif platform.is_unix then
				create {I18N_LINUX_LOCALE_FACTORY} Result
--			elseif platform.is_mac then
--				create {I18N_MACOSX_LOCALE_FACTORY} Result
--				there is no query under class PLATFORM for macosx other than the unix one
			end
		end

invariant

	invariant_clause: True -- Your invariant here

end
