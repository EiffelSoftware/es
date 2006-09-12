indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATE_FORMATTER

	feature
		-- Creation
		make (locale_info: I18N_LOCALE_INFO) is
				-- do
				do
					info := locale_info
				end

	feature
		-- Access


	feature {NONE}
		-- Implementation
			info: I18N_LOCALE_INFO


end
