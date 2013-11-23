note
	description: "Summary description for {E2B_SHARED_TRANSLATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SHARED_CONTEXT

feature {NONE} -- Access: stateful

	translation_pool: E2B_TRANSLATION_POOL
			-- Shared translation pool.
		once
			create Result.make
		end

	boogie_universe: IV_UNIVERSE
			-- Shared boogie universe.
		do
			Result := boogie_universe_cell.item
		end

	autoproof_errors: LINKED_LIST [E2B_AUTOPROOF_ERROR]
			-- List of autoproof errors.
		once
			create Result.make
		end

feature {NONE} -- Access: stateless

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
			-- Shared translation options.
		once
			create Result.make
		end

	helper: E2B_HELPER
			-- Shared helper.
		once
			create Result
		end

feature {NONE} -- Implementation

	boogie_universe_cell: CELL [IV_UNIVERSE]
			-- Once cell holding shared boogie universe instance.
		once
			create Result.put (Void)
		end

end
