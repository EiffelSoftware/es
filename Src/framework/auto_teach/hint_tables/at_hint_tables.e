note
	description: "Shared instances of the default hint tables."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINT_TABLES

inherit

	AT_COMMON

feature -- For use with contracts

	file_exists (a_path: READABLE_STRING_GENERAL): BOOLEAN
			-- Does the path contained in `a_path' point to an existing file?
		local
			l_info: FILE_INFO
		do
			create l_info.make
			l_info.update (a_path)
			Result := l_info.exists
		end

feature -- Hint tables

	default_auto_hint_table: AT_HINT_TABLE
			-- The default table for auto mode (smart table).
		once ("PROCESS")
			create {AT_DEFAULT_AUTO_HINT_TABLE} Result.make
		end

	default_manual_hint_table: AT_HINT_TABLE
			-- The default table for manual mode ("dumb" table, manual annotations required).
		once ("PROCESS")
			create {AT_DEFAULT_MANUAL_HINT_TABLE} Result.make
		end

	custom_hint_table: detachable AT_HINT_TABLE
			-- The currently loaded custom hint table.

		-- BUG in EiffelStudio! For some reason, I cannot step through this function
		-- with the debugger, no matter how many time I clean-compile.

	load_custom_hint_table (a_full_path: STRING)
			-- Loads a custom hint table from the specified file path
			-- and makes it accessible in `custom_hint_table'.
		require
			file_exists: file_exists (a_full_path)
		local
			l_table: AT_LOADABLE_HINT_TABLE
			l_failed: BOOLEAN
			l_exception_manager: EXCEPTION_MANAGER_FACTORY
			l_tri: AT_TRI_STATE_BOOLEAN
		do
			custom_hint_table := Void
			last_table_load_exception := Void
			if not l_failed then
				create l_table.make_from_file_path (a_full_path)
				custom_hint_table := l_table
				l_tri := custom_hint_table.visibility_for (enum_block_type.bt_feature, 1).visibility
			else
				create l_exception_manager
				last_table_load_exception := l_exception_manager.exception_manager.last_exception
			end
		ensure
			either_loaded_or_exception: attached custom_hint_table xor attached last_table_load_exception
		rescue
			if not l_failed then
				l_failed := True
				retry
			end
		end

	last_table_load_exception: EXCEPTION
			-- The exception occurred in the last call to `load_custom_hint_table', if any.

end
