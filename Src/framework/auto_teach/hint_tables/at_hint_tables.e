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
		local
			l_path: PATH
		once ("PROCESS")
				-- This is the default table, that users should never touch (and break).
				-- If it can't be loaded, then we have a bug and we can't do much with it.
				-- Therefore, we don't catch loading exceptions.
			create l_path.make_from_string (default_tables_directory)
			create {AT_LOADABLE_HINT_TABLE} Result.make_from_file_path (l_path.extended ("default_auto_table.txt").out)
		end

	default_manual_hint_table: AT_HINT_TABLE
			-- The default table for manual mode ("dumb" table, manual annotations required).
		local
			l_path: PATH
		once ("PROCESS")
				-- See comment above.
			create l_path.make_from_string (default_tables_directory)
			create {AT_LOADABLE_HINT_TABLE} Result.make_from_file_path (l_path.extended ("default_manual_table.txt").out)
		end

	custom_hint_table: detachable AT_HINT_TABLE
			-- The currently loaded custom hint table.

	load_custom_hint_table (a_full_path: STRING)
			-- Loads a custom hint table from the specified file path
			-- and makes it accessible in `custom_hint_table'.
		require
			file_exists: file_exists (a_full_path)
		local
			l_table: AT_LOADABLE_HINT_TABLE
			l_failed: BOOLEAN
			l_exception_manager: EXCEPTION_MANAGER_FACTORY
		do
			custom_hint_table := Void
			last_table_load_exception := Void
			if not l_failed then
				create {AT_LOADABLE_HINT_TABLE} custom_hint_table.make_from_file_path (a_full_path)
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

feature {NONE} -- Implementation

	default_tables_directory: DIRECTORY_NAME
			-- Directory containing the default tables.
		local
			l_ee: EXECUTION_ENVIRONMENT
			l_path: DIRECTORY_NAME
			l_dir: DIRECTORY
		once
			create l_ee

				-- 1. Delivery of installation
			create l_path.make_from_string (l_ee.get ("ISE_EIFFEL"))
			l_path.extend ("studio")
			l_path.extend ("tools")
			l_path.extend ("autoteach")
			create l_dir.make (l_path)

				-- 2. Delivery of development version
			if not l_dir.exists then
				create l_path.make_from_string (l_ee.get ("EIFFEL_SRC"))
				l_path.extend ("Delivery")
				l_path.extend ("studio")
				l_path.extend ("tools")
				l_path.extend ("autoteach")
			end

			Result := l_path
		end

end
