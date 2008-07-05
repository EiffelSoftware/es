indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_FILE_SEARCHER

create
	make

feature{NONE} -- Initialization

	make (a_location: like location) is
			-- Initialize `location' with `a_location'.
		require
			a_location_attached: a_location /= Void
			not_a_location_is_empty: not a_location.is_empty
		do
			set_location (a_location)
		end

feature -- Access

	location: STRING
			-- The location where files are stored.
			-- Can be an file name or a directory
			-- In the case of directory, all files in that directory (recursively, if enabled) will be loaded.
			-- For one particular testing session, there may be more than one files generated because
			-- every time the interpretor is start, a file is generated.

	last_found_files: LIST [like location]
			-- List of files found by last invocation of `search'

	veto_file_function: FUNCTION [ANY, TUPLE [a_path: STRING], BOOLEAN]
			-- Function to decide whether a file `a_path' (absolute path included).
			-- should be included in `last_found_files'. If the return value is True, the file is included, otherwise, not included.
			-- If Void, every found file is included in `last_file_files'.

	regular_expression_matcher (a_pattern: STRING; a_case: BOOLEAN; a_extended: BOOLEAN): RX_PCRE_REGULAR_EXPRESSION is
			-- Regular expression matcher which matches `a_pattern'.
			-- `a_case' indicates if the matching is case-sensitive.
			-- `a_extended' indicates if extended regular expression format is used.
		do
			create Result.make
			Result.set_caseless (a_case)
			Result.set_extended (a_extended)
			Result.compile (a_pattern)
		end

feature -- Status report

	is_search_recursive: BOOLEAN
			-- Does subdirectories are recursively searched for files?
			-- Only has effect when `location' is a directory.

feature -- Basic operations

	search is
			-- Search files satisfying `veto_file_function' and store result in `last_found_files'.
		do
			create {LINKED_LIST [like location]} last_found_files.make
			search_files (location, last_found_files)
		end

feature -- Setting

	set_location (a_location: like location) is
			-- Set `location' with `a_location'.
		require
			a_location_attached: a_location /= Void
			not_a_location_is_empty: not a_location.is_empty
		do
			location := a_location.twin
		ensure
			location_set: location /= Void and then location.is_equal (a_location)
		end

	set_is_search_recursive (b: BOOLEAN) is
			-- Set `is_search_recursive' with `b'.
		do
			is_search_recursive := b
		ensure
			is_search_recursive_set: is_search_recursive = b
		end

	set_veto_file_function (a_function: like veto_file_function) is
			-- Set `veto_file_function' with `a_func'.
		do
			veto_file_function := a_function
		ensure
			veto_file_function_set: veto_file_function = a_function
		end

feature{NONE} -- Implementation

	search_files (a_start_location: like location; a_file_list: LIST [STRING]) is
			-- Search for files matching `file_pattern' in location `a_start_location' and
			-- store found files in `a_file_list'.
			-- If `a_start_location' is a file and it matches `file_pattern', it will be added in `a_file_list'.
			-- If `a_start_location' is a directory, all files that match `file_pattern' in it will be added into `a_file_list'.
			-- Depending on `is_search_recursive', subdirectories of `a_start_location' will be searched.
		require
			a_start_location_attached: a_start_location /= Void
			a_file_list_attached: a_file_list /= Void
		local
			l_dir: DIRECTORY
			l_file: RAW_FILE
			l_dot, l_dotdot: STRING
			l_entry: STRING
			l_location: STRING
			l_location_count: INTEGER
			l_veto_function: like veto_file_function
		do
			l_veto_function := veto_file_function
			l_location_count := a_start_location.count
			l_dot := "."
			l_dotdot := ".."
			create l_file.make (a_start_location)
			if l_file.is_directory then
				create l_dir.make_open_read (a_start_location)
				from
					l_dir.readentry
				until
					l_dir.lastentry = Void
				loop
					l_entry := l_dir.lastentry
						-- Ignore "." and "..".
					if not (l_entry.is_equal (l_dot) or l_entry.is_equal (l_dotdot)) then
							-- Concatenate new location.
						create l_location.make_from_string (a_start_location)
						create l_location.make (l_location_count + l_entry.count + 1)
						l_location.append (a_start_location)
						l_location.append_character (Operating_environment.directory_separator)
						l_location.append (l_entry)

						create l_file.make (l_location)
						if not l_file.is_directory or else is_search_recursive then
							search_files (l_location, a_file_list)
						end
					end
					l_dir.readentry
				end
			else
				if l_veto_function = Void then
					a_file_list.extend (a_start_location)
				elseif l_veto_function.item ([a_start_location]) then
					a_file_list.extend (a_start_location)
				end
			end
		end

invariant
	location_valid: location /= Void and then not location.is_empty

end
