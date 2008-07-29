indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_FILE_SEARCHER

create
	make_with_pattern

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
			create {LINKED_LIST [STRING]} locations.make

			set_veto_file_function (agent is_file_matched (?, l_matcher))
		end

feature -- Access

	locations: LIST [STRING]
			-- List of locations to search

	last_found_files: LIST [STRING]
			-- List of files found by last invocation of `search' or `search_locations'

	veto_file_function: FUNCTION [ANY, TUPLE [a_path: STRING], BOOLEAN]
			-- Function to decide whether a file `a_path' (absolute path included).
			-- should be included in `last_found_files'. If the return value is True, the file is included, otherwise, not included.
			-- If Void, every found file is included in `last_file_files'.

	file_found_action: PROCEDURE [ANY, TUPLE [a_path: STRING]]
			-- Action to be performed if a file `a_path' is found.

feature -- Status report

	is_search_recursive: BOOLEAN
			-- Does subdirectories are recursively searched for files?
			-- Only has effect when `location' is a directory.

	is_dir_matched: BOOLEAN
			-- Should directories be matched?

feature -- Basic operations

	search is
			-- Search files in `locations' satisfying `veto_file_function' and store result in `last_found_files'.
			-- In the case of directory, all files in that directory (recursively, if enabled) will be loaded.
			-- For one particular testing session, there may be more than one files generated because
			-- every time the interpretor is start, a file is generated.
		local
			l_locations: like locations
		do
			create {LINKED_LIST [STRING]} last_found_files.make
			l_locations := locations
			if not l_locations.is_empty then
				l_locations.do_all (agent search_files (?, last_found_files))
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

	set_veto_file_function (a_function: like veto_file_function) is
			-- Set `veto_file_function' with `a_func'.
		do
			veto_file_function := a_function
		ensure
			veto_file_function_set: veto_file_function = a_function
		end

	set_file_found_action (a_action: like file_found_action) is
			-- Set `file_found_action' with `a_action'.			
		do
			file_found_action := a_action
		ensure
			file_found_action_set: file_found_action = a_action
		end

feature{NONE} -- Implementation

	search_files (a_start_location: STRING; a_file_list: LIST [STRING]) is
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
			l_file_found_action: like file_found_action
			l_is_dir_matched: BOOLEAN
		do
			l_is_dir_matched := is_dir_matched
			l_file_found_action := file_found_action
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
						if l_file.is_directory then
							if l_is_dir_matched then
								match_location (l_location, a_file_list)
							end
							if is_search_recursive then
								search_files (l_location, a_file_list)
							end
						else
							search_files (l_location, a_file_list)
						end
					end
					l_dir.readentry
				end
			else
				match_location (a_start_location, a_file_list)
			end
		end

	match_location (a_location: STRING; a_result_list: like last_found_files) is
			-- Try to match `a_location' against `veto_file_function'.
			-- If matched, store `a_location' into `a_result_list'.
		require
			a_location_attached: a_location /= Void
			a_result_list_attached: a_result_list /= Void
		local
			l_veto_function: like veto_file_function
			l_file_found_action: like file_found_action
		do
			l_veto_function := veto_file_function
			l_file_found_action := file_found_action
			if l_veto_function = Void or else l_veto_function.item ([a_location]) then
				a_result_list.extend (a_location)
				if l_file_found_action /= Void then
					l_file_found_action.call ([a_location])
				end
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

invariant
	locations_attached: locations /= Void

end
