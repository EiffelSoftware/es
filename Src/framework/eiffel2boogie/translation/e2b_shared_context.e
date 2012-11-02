note
	description: "Summary description for {E2B_SHARED_TRANSLATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SHARED_CONTEXT

feature {NONE} -- Access

	translation_pool: E2B_TRANSLATION_POOL
			-- Shared translation pool.
		once
			create Result.make
		end

	name_translator: E2B_NAME_TRANSLATOR
			-- Shared global name translator.
		once
			create Result
		end

	translation_mapping: E2B_SPECIAL_MAPPING
			-- Shared mapping for special translations.
		once
			create Result.make
		end

feature -- Access (public)

	options: E2B_OPTIONS
			-- Sahred translation options.
		once
			create Result.make
		end

	helper: E2B_HELPER
			-- Shared helper.
		once
			create Result
		end

end
