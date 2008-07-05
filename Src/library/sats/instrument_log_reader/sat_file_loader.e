indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_FILE_LOADER

feature -- Access

	location: STRING
			-- Location (path + file name) of the file to load

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

feature -- Basic operations

	analyze is
			-- Use `analyzers' to analyze log files in `last_found_log_files'.
		local
			l_cursor: CURSOR
			l_file: PLAIN_TEXT_FILE
			l_done: BOOLEAN
			l_cur_section_name: STRING
			l_line: STRING
			l_interested_analyzers: LIST [SAT_FILE_ANALYZER]
			l_table: like analyzer_section_table
			l_space_index: INTEGER
		do
			from
				l_table := analyzer_section_table
				l_cur_section_name := ""
				create l_file.make_open_read (location)
				l_file.read_line
				l_done := l_file.after
			until
				l_done
			loop
				l_line := l_file.last_string.twin
				if not l_line.is_empty then
					if is_single_line_mode then
						l_space_index := l_line.index_of (' ', 1)
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
			a_analyzer.set_is_registered (True)
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
					l_analyzers.extend (a_analyzer)
					l_table.force (l_analyzers, l_section_name)
				end
				l_table.item (l_section_name).extend (a_analyzer)
				l_sections.forth
			end
		ensure
			a_analyzer_registered: is_analyzer_registered (a_analyzer) and then a_analyzer.is_registered
		end

	remove_analyzer (a_analyzer: SAT_FILE_ANALYZER) is
			-- Remove `a_analyzer' from `analyzers'.
		require
			a_analyzer_attached: a_analyzer /= Void
			a_analyzer_is_registered: is_analyzer_registered (a_analyzer) and then a_analyzer.is_registered
		local
			l_sections: LIST [STRING]
			l_table: like analyzer_section_table
			l_analyzers: LIST [SAT_FILE_ANALYZER]
		do
			analyzers.start
			analyzers.search (a_analyzer)
			analyzers.remove
			a_analyzer.set_is_registered (False)
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
			not_a_analyzer_is_registered: not is_analyzer_registered (a_analyzer) and then not a_analyzer.is_registered
		end

feature{NONE} -- Implementation/Data

	analyzer_section_table: HASH_TABLE [LIST [SAT_FILE_ANALYZER], STRING]
			-- Table for analyzers which are interested in some log sections
			-- [List of analyzers in `analyzers' which are interested in the section, Section name]

invariant
	location_attached: location /= Void

end
