indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_LOCALE_FACTORY

feature -- Basic Operations

	platform: PLATFORM

	factory: I18N_LOCALE_FACTORY is
			-- Factory used for get_locale feature
		once
			if platform.is_windows then
				create {I18N_LOCALE_WINDOWS} Result
			elseif platform.is_unix then
				create {I18N_LOCALE_LINUX} Result
--			elseif is_mac then
--				create {I18N_LOCALE_MACOSX} Result
--				there is no query under class PLATFORM for macosx other than the unix one
			end
		end


invariant
	invariant_clause: True -- Your invariant here

end -- class SHARED_FACTORY
