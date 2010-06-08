note
	description: "Class to search for files/directories matching a given pattern"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FILE_SEARCHER

inherit
	OPERATING_ENVIRONMENT

create
	make_with_pattern,
	make_with_veto_function

feature{NONE} -- Initialization

	make_with_pattern (a_pattern: STRING) is
			-- Prepare current searcher using regular expression `a_pattern' to match files.
		require
			a_pattern_valid: a_pattern /= Void and then not a_pattern.is_empty
		local
			l_matcher: RX_PCRE_REGULAR_EXPRESSION
		do
			create l_matcher.make
			l_matcher.set_caseless (True)
			l_matcher.set_extended (True)
			l_matcher.compile (a_pattern)
			create file_found_actions.make

			set_veto_file_function (agent is_file_matched (?, l_matcher))
		end

	make_with_veto_function (a_function: like veto_file_function)
			-- Prepare current search using `a_function' as `veto_file_function'.
		do
			create file_found_actions.make
			set_veto_file_function (a_function)
		end

feature -- Access

	veto_file_function: FUNCTION [ANY, TUPLE [a_path: STRING], BOOLEAN]
			-- Function to decide whether a file `a_path' (absolute path included).
			-- should be included in `last_found_files'. If the return value is True, the file is included, otherwise, not included.
			-- If Void, every found file is included in `last_file_files'.

	file_found_actions: ACTION_SEQUENCE [TUPLE [a_path: STRING; a_name: STRING]]
			-- Actions to be performed if a file `a_path' is found.
			-- `a_name' is the file name or the last level directory name

feature -- Status report

	is_search_recursive: BOOLEAN
			-- Does subdirectories are recursively searched for files?
			-- Only has effect when `location' is a directory.
			-- Default: False

	is_dir_matched: BOOLEAN
			-- Should directories be matched?
			-- Default: False

feature -- Basic operations

	search (a_location: STRING)
			-- Search files in `a_location' satisfying `veto_file_function'.
			-- In the case of directory, all files in that directory (recursively, if enabled) will be loaded.
			-- For one particular testing session, there may be more than one files generated because
			-- every time the interpretor is start, a file is generated.
		local
			l_locations: LINKED_LIST [STRING]
		do
			create l_locations.make
			l_locations.extend (a_location)
			search_locations (l_locations)
		end

	search_locations (a_locations: LINKED_LIST [STRING])
			-- Search files in `a_locations' satisfying `veto_file_function' and store result in `last_found_files'.
			-- In the case of directory, all files in that directory (recursively, if enabled) will be loaded.
			-- For one particular testing session, there may be more than one files generated because
			-- every time the interpretor is start, a file is generated.
		do
			if not a_locations.is_empty then
				a_locations.do_all (agent search_files)
			end
		end

feature -- Setting

	set_is_search_recursive (b: BOOLEAN) is
			-- Set `is_search_recursive' with `b'.
		do
			is_search_recursive := b
		ensure
			is_search_recursive_set: is_search_recursive = b
		end

	set_is_dir_matched (b: BOOLEAN) is
			-- Set `is_dir_matched' with `b'.
		do
			is_dir_matched := b
		ensure
			is_dir_matched_set: is_search_recursive = b
		end

feature{NONE} -- Implementation

	set_veto_file_function (a_function: like veto_file_function) is
			-- Set `veto_file_function' with `a_func'.
		do
			veto_file_function := a_function
		ensure
			veto_file_function_set: veto_file_function = a_function
		end

	search_files (a_start_location: STRING) is
			-- Search for files matching `file_pattern' in location `a_start_location'.
			-- Depending on `is_search_recursive', subdirectories of `a_start_location' will be searched.
		require
			a_start_location_attached: a_start_location /= Void
		local
			l_dir: DIRECTORY
			l_file: RAW_FILE
			l_dot, l_dotdot: STRING
			l_entry: STRING
			l_location: FILE_NAME
			l_location_count: INTEGER
			l_veto_function: like veto_file_function
			l_is_dir_matched: BOOLEAN
			l_parts: LIST [STRING]
		do
			l_is_dir_matched := is_dir_matched
			l_veto_function := veto_file_function
			l_location_count := a_start_location.count
			l_dot := "."
			l_dotdot := ".."
			create l_file.make (a_start_location)
			if l_file.exists then
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
							l_location.extend (l_entry)

							create l_file.make (l_location)
							if l_file.is_directory then
								if l_is_dir_matched then
									match_location (l_location, l_entry)
								end
								if is_search_recursive then
									search_files (l_location)
								end
							else
								search_files (l_location)
							end
						end
						l_dir.readentry
					end
				else
					l_parts := a_start_location.split (directory_separator)
					match_location (a_start_location, l_parts.last)
				end
			end
		end

	match_location (a_location: STRING; a_name: STRING) is
			-- Try to match `a_location' against `veto_file_function'.
			-- If matched, call `file_found_actions'.
		require
			a_location_attached: a_location /= Void
		local
			l_veto_function: like veto_file_function
		do
			l_veto_function := veto_file_function
			if l_veto_function = Void or else l_veto_function.item ([a_location]) then
				file_found_actions.call ([a_location, a_name])
			end
		end

	is_file_matched (a_file_path: STRING; a_matcher: RX_PCRE_REGULAR_EXPRESSION): BOOLEAN is
			-- Does `a_file_path' match `a_matcher'?
		require
			a_file_path_attached: a_file_path /= Void
			a_matcher_attached: a_matcher /= Void
		do
			a_matcher.match (a_file_path)
			Result := a_matcher.has_matched
		end

end
