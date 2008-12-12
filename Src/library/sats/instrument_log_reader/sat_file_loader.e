indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 74256 $"

class
	SAT_FILE_LOADER

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		local
			a: SAT_AGENT_BASED_FILE_ANALYZER
		do
			create {LINKED_LIST [SAT_FILE_ANALYZER]} analyzers.make
			create analyzer_section_table.make (10)
		end

feature -- Access

	analyzers: LIST [SAT_FILE_ANALYZER]
			-- Instrument log analyzers registered in Current.

feature -- Status report

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

	should_stop_loading: BOOLEAN
			-- Should loading be stopped?

feature -- Setting

	set_should_stop_loading (b: BOOLEAN) is
			-- Set `should_stop_loading' with `b'.
		do
			should_stop_loading := b
		ensure
			should_stop_loading_set: should_stop_loading = b
		end

feature -- Basic operations

	reset_analyzers is
			-- Reset `analyzers'.
		do
			analyzers.do_all (agent {SAT_FILE_ANALYZER}.reset)
		end

	load_file (a_file_name: STRING) is
			-- Use `analyzers' to analyze file `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void
		do
			load_files ((<<a_file_name>>).linear_representation)
		end

	load_files (a_file_list: LINEAR [STRING]) is
			-- Use `analyzers' to analyze files in `a_file_list'.
		require
			a_file_list_attached: a_file_list /= Void
		local
			l_cursor: CURSOR
			l_file: PLAIN_TEXT_FILE
			l_done: BOOLEAN
			l_cur_section_name: STRING
			l_line: STRING
			l_interested_analyzers: LIST [SAT_FILE_ANALYZER]
			l_table: like analyzer_section_table
			l_space_index: INTEGER
			l_location: STRING
		do
			if not a_file_list.is_empty then
				analyzers.do_all (agent {SAT_FILE_ANALYZER}.reset)

				l_table := analyzer_section_table
				l_cur_section_name := ""

				from
					a_file_list.start
				until
					a_file_list.after or else should_stop_loading
				loop
					l_location := a_file_list.item
					create l_file.make_open_read (l_location)
					from
						l_file.read_line
						l_done := l_file.after
					until
						l_done or else should_stop_loading
					loop
						l_line := l_file.last_string.twin
						l_line.replace_substring_all ("%R", "")
						if not l_line.is_empty then
							if is_single_line_mode then
								l_space_index := l_line.index_of ('%T', 1)
								l_cur_section_name := l_line.substring (1, l_space_index - 1)
								l_line := l_line.substring (l_space_index + 1, l_line.count)
								l_interested_analyzers := l_table.item (l_cur_section_name)
								if l_interested_analyzers /= Void then
										-- If this is a data line in current section, dispatch it to all interested analyzers in `analyzers'.
									l_interested_analyzers.do_all (agent {SAT_FILE_ANALYZER}.process_record (l_cur_section_name, l_line))
								end
							else
								if l_line.item (1) = '-' and then l_line.item (2) = '-' then
										-- If this is a section starter
									l_cur_section_name := l_line.substring (3, l_line.count)
									l_interested_analyzers := l_table.item (l_cur_section_name)
								else
									if l_interested_analyzers /= Void then
											-- If this is a data line in current section, dispatch it to all interested analyzers in `analyzers'.
										l_interested_analyzers.do_all (agent {SAT_FILE_ANALYZER}.process_record (l_cur_section_name, l_line))
									end
								end
							end
						end
						l_file.read_line
						l_done := l_file.after
					end
					l_file.close
					a_file_list.forth
				end
			end
		end

	load (a_file_searcher: SAT_FILE_SEARCHER) is
			-- Use `analyzers' to analyze files found by `a_file_searcher'.
		require
			a_file_searcher_attached: a_file_searcher /= Void
		do
			if not a_file_searcher.last_found_files.is_empty then
				load_files (a_file_searcher.last_found_files)
			end
		end

feature -- Setting

	set_is_single_line_mode (b: BOOLEAN) is
			-- Set `is_single_line_mode' with `b'.
		do
			is_single_line_mode := b
		ensure
			is_single_line_mode_set: is_single_line_mode = b
		end

feature -- Analyzer registration

	register_analyzer (a_analyzer: SAT_FILE_ANALYZER) is
			-- Register `a_analyzer' into `analyzers'.
		require
			a_analyzer_attached: a_analyzer /= Void
			not_is_a_analyzer_registered: not is_analyzer_registered (a_analyzer)
		local
			l_sections: LIST [STRING]
			l_table: like analyzer_section_table
			l_section_name: STRING
			l_analyzers: LINKED_LIST [SAT_FILE_ANALYZER]
		do
			analyzers.extend (a_analyzer)
			from
				l_table := analyzer_section_table
				l_sections := a_analyzer.sections
				l_sections.start
			until
				l_sections.after
			loop
				l_section_name := l_sections.item
				if not l_table.has (l_section_name) then
					create l_analyzers.make
					l_table.force (l_analyzers, l_section_name)
				end
				l_table.item (l_section_name).extend (a_analyzer)
				l_sections.forth
			end
		ensure
			a_analyzer_registered: is_analyzer_registered (a_analyzer) and then analyzers.count = old analyzers.count + 1
		end

	remove_analyzer (a_analyzer: SAT_FILE_ANALYZER) is
			-- Remove `a_analyzer' from `analyzers'.
		require
			a_analyzer_attached: a_analyzer /= Void
			a_analyzer_is_registered: is_analyzer_registered (a_analyzer)
		local
			l_sections: LIST [STRING]
			l_table: like analyzer_section_table
			l_analyzers: LIST [SAT_FILE_ANALYZER]
		do
			analyzers.start
			analyzers.search (a_analyzer)
			analyzers.remove
			from
				l_table := analyzer_section_table
				l_sections := a_analyzer.sections
				l_sections.start
			until
				l_sections.after
			loop
				l_analyzers := l_table.item (l_sections.item)
				l_analyzers.start
				l_analyzers.search (a_analyzer)
				l_analyzers.remove
				l_sections.forth
			end
		ensure
			not_a_analyzer_is_registered: not is_analyzer_registered (a_analyzer)
		end

feature{NONE} -- Implementation/Data

	analyzer_section_table: HASH_TABLE [LIST [SAT_FILE_ANALYZER], STRING]
			-- Table for analyzers which are interested in some log sections
			-- [List of analyzers in `analyzers' which are interested in the section, Section name]

	extend_file_list (a_file_list: LIST [STRING]; a_file: STRING) is
			-- Extend `a_file' into `a_file_list'.
		require
			a_file_list_attached: a_file_list /= Void
			a_file_attached: a_file /= Void
		do
			a_file_list.extend (a_file)
		ensure
			a_file_list_extended: a_file_list.count = old a_file_list.count + 1 and then a_file_list.has (a_file)
		end

end
