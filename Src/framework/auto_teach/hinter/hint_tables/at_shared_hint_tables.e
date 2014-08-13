note
	description: "Shared instances of the default hint tables."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_SHARED_HINT_TABLES

feature {NONE}

	default_unannotated_hint_table: AT_HINT_TABLE
			-- The default table for unannotated (no hints) classes.
		once ("PROCESS")
				-- TODO: Replace the following back with UNANNOTATED!!!!!
			create {AT_DEFAULT_ANNOTATED_HINT_TABLE} Result.make
		end

	default_annotated_hint_table: AT_HINT_TABLE
			-- The default table for annotated (with hints) classes.
		once ("PROCESS")
			create {AT_DEFAULT_ANNOTATED_HINT_TABLE} Result.make
		end

	custom_hint_table: detachable AT_HINT_TABLE
			-- The currently loaded custom hint table.

	load_custom_hint_table (a_full_path: STRING)
			-- Loads a custom hint table from the specified file path\
			-- and makes it accessible in `custom_hint_table'.
		do
				-- TODO load from file
		end

end
