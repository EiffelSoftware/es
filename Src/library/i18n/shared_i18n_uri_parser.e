indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_I18N_URI_PARSER

	feature
		-- Access

		parser: I18N_URI_PARSER is
				-- shared I18N_URI_PARSER
			once
				create Result
			ensure
				result_not_void: Result /= Void
			end


end
