indexing
	description: "SATS instrument log reader"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_LOG_SEARCHER

create
	make

feature{NONE} -- Initialization

	make (a_location: STRING) is
			-- Initialize `location' with `a_location'.
		require
			a_location_attached: a_location /= Void
			not_a_location_is_empty: not a_location.is_empty
		do
			create {LINKED_LIST [SAT_FILE_ANALYZER]} analyzers.make
			create file_searcher.make (a_location)
			log_file_pattern := ""
		end

feature -- Access

	log_file_pattern: STRING
			-- Pattern to match log files

	analyzers: LIST [SAT_FILE_ANALYZER]
			-- Instrument log analyzers registered in Current.

	last_found_log_files: LIST [STRING]
			-- Last found log files

feature -- Status report

	is_log_file_search_recursive: BOOLEAN
			-- Does subdirectories are recursively searched for log files?
			-- Only has effect when `location' is a directory.

	is_single_line_mode: BOOLEAN
			-- Is the log files stored in single line mode?
			-- Single line mode means that the section name and the record data are stored in the same line.

	is_analyzer_registered (a_analyzer: SAT_FILE_ANALYZER): BOOLEAN is
			-- Is `a_analyzer' registered in Current?
		require
			a_analyzer_attached: a_analyzer /= Void
		do
			Result := analyzers.has (a_analyzer)
		ensure
			good_result: Result = analyzers.has (a_analyzer)
		end

feature -- Basic operations

	set_is_single_line_mode (b: BOOLEAN) is
			-- Set `is_single_line_mode' with `b'.
		do
			is_single_line_mode := b
		ensure
			is_single_line_mode_set: is_single_line_mode = b
		end

	set_log_file_pattern (a_pattern: STRING) is
			-- Set `log_file_pattern' with `a_pattern'.
		require
			not_a_pattern_is_empty: not a_pattern.is_empty
		do
			log_file_pattern := a_pattern.twin
		ensure
			log_file_pattern_set: log_file_pattern.is_equal (a_pattern)
		end

	set_is_search_recursive (b: BOOLEAN) is
			-- Set `is_search_recursive' with `b'.
		do
			file_searcher.set_is_search_recursive (b)
		end

	search is
			-- Load log files in `location' and logs to registered log analyzer.
		local
			l_regex_matcher: RX_PCRE_REGULAR_EXPRESSION
			l_file_list: LINKED_LIST [STRING]
		do
				-- Initialize regular expression matcher.
			l_regex_matcher := file_searcher.regular_expression_matcher (log_file_pattern, (create{PLATFORM}).is_windows, True)
			file_searcher.set_veto_file_function (agent is_file_matched (?, l_regex_matcher))

				-- Search for log files.
			create {LINKED_LIST [STRING]} last_found_log_files.make
			file_searcher.search
			last_found_log_files := file_searcher.last_found_files.twin
		end

	analyze is
			-- Use `analyzers' to analyze log files in `last_found_log_files'.
		require
			last_found_files_attached: last_found_log_files /= Void
		local
--			l_cursor: CURSOR
--			l_file: PLAIN_TEXT_FILE
--			l_done: BOOLEAN
--			l_cur_section_name: STRING
--			l_line: STRING
--			l_interested_analyzers: LIST [SAT_INSTRUMENT_LOG_ANALYZER]
--			l_table: like analyzer_section_table
--			l_space_index: INTEGER
		do
--			l_cursor := last_found_log_files.cursor
--			from
--				l_table := analyzer_section_table
--				l_cur_section_name := ""
--				last_found_log_files.start
--				create l_file.make_open_read (last_found_log_files.item)
--				l_file.read_line
--				l_done := l_file.after
--			until
--				l_done
--			loop
--				l_line := l_file.last_string.twin
--				if not l_line.is_empty then
--					if is_single_line_mode then
--						l_space_index := l_line.index_of (' ', 1)
--						l_cur_section_name := l_line.substring (1, l_space_index - 1)
--						l_line := l_line.substring (l_space_index + 1, l_line.count)
--						l_interested_analyzers := l_table.item (l_cur_section_name)
--						if l_interested_analyzers /= Void then
--								-- If this is a data line in current section, dispatch it to all interested analyzers in `analyzers'.
--							l_interested_analyzers.do_all (agent {SAT_INSTRUMENT_LOG_ANALYZER}.process_record (l_cur_section_name, l_line))
--						end
--					else
--						if l_line.item (1) = '-' and then l_line.item (2) = '-' then
--								-- If this is a section starter
--							l_cur_section_name := l_line.substring (3, l_line.count)
--							l_interested_analyzers := l_table.item (l_cur_section_name)
--						else
--							if l_interested_analyzers /= Void then
--									-- If this is a data line in current section, dispatch it to all interested analyzers in `analyzers'.
--								l_interested_analyzers.do_all (agent {SAT_INSTRUMENT_LOG_ANALYZER}.process_record (l_cur_section_name, l_line))
--							end
--						end
--					end
--				end

--					-- Read next line, turn to next file in `last_found_log_files' if Current file is finished.
--				l_file.read_line
--				l_done := l_file.after
--				if l_done then
--					l_file.close
--					last_found_log_files.forth
--					l_done := last_found_log_files.after
--					if not l_done then
--						create l_file.make_open_read (last_found_log_files.item)
--						l_file.read_line
--						l_done := l_file.after
--					end
--				end
--			end
		end

feature -- Analyzer registration


feature{NONE} -- Implementation/Data

--	analyzer_section_table: HASH_TABLE [LIST [SAT_INSTRUMENT_LOG_ANALYZER], STRING]
--			-- Table for analyzers which are interested in some log sections
--			-- [List of analyzers in `analyzers' which are interested in the section, Section name]

	file_searcher: SAT_FILE_SEARCHER
			-- File searcher used to find files

feature{NONE} -- Implementation

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
	log_file_pattern_valid: log_file_pattern /= Void
	analyzers_attached: analyzers /= Void
--	analyzer_section_table_attached: analyzer_section_table /= Void
	file_searcher_attached: file_searcher /= Void

end
