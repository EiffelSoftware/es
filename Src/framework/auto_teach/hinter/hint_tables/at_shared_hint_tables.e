note
	description: "Shared instances of the default hint tables."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_SHARED_HINT_TABLES


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

feature {NONE} -- Hint tables

	default_unannotated_hint_table: AT_HINT_TABLE
			-- The default table for unannotated (no hints) classes.
		once ("PROCESS")
			create {AT_DEFAULT_UNANNOTATED_HINT_TABLE} Result.make
		end

	default_annotated_hint_table: AT_HINT_TABLE
			-- The default table for annotated (with hints) classes.
		once ("PROCESS")
			create {AT_DEFAULT_ANNOTATED_HINT_TABLE} Result.make
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
				create l_table.make_from_file_path (a_full_path)
				custom_hint_table := l_table
			else
				create l_exception_manager
				last_table_load_exception := l_exception_manager.exception_manager.last_exception
			end
		ensure
			either_loaded_or_exception:	attached custom_hint_table xor attached last_table_load_exception
		rescue
			if not l_failed then
				l_failed := True
				retry
			end
		end

	last_table_load_exception: EXCEPTION
		-- The exception occurred in the last call to `load_custom_hint_table', if any.

end
