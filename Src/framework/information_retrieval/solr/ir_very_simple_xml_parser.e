note
	description: "[
		This is a crazily simple xml parser to analyze the raw string from Solr query execution
		This class should be removed when better xml parsers are available.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_VERY_SIMPLE_XML_PARSER

create
	make

feature{NONE} -- Initialization

	make (a_file: STRING)
			-- Initialize.
		do
			file := a_file
		end

feature -- Basic operations

	analyze_file
			-- Analyze data in `file', make result available in `last_result'.
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_is_in_doc: BOOLEAN
			l_field: IR_FIELD
			l_result: IR_QUERY_RESULT
			l_document: IR_DOCUMENT
		do
			create l_result.make
			create l_file.make_open_read (file)
			from
				l_file.read_line
			until
				l_file.exhausted
			loop
				l_line := l_file.last_string.twin
				l_line.left_adjust
				l_line.right_adjust
				if l_line ~ "<doc>" then
					l_is_in_doc := True
					create l_document.make (10)
					l_result.extend_document (l_document)
				elseif l_line ~ "</doc>" then
					l_is_in_doc := False
				else
					if l_is_in_doc then
						l_field := pair_from_line (l_line)
						l_document.force_last (l_field)
					end
				end

				l_file.read_line
			end
			last_result := l_result
		end

feature -- Access

	file: STRING
			-- Name of the file storing data

	last_result: IR_QUERY_RESULT
			-- Result analyzed by last `analyze_file'

feature{NONE} -- Implementation

	pair_from_line (a_line: STRING): IR_FIELD
			-- Key-value pair from `a_line'
		local
			l_key_start_index: INTEGER
			l_key_end_index: INTEGER
			l_value_start_index: INTEGER
			l_value_end_index: INTEGER
			l_key: STRING
			l_value: STRING
			l_fvalue: IR_VALUE
		do
				-- Find out the key name.
			l_key_start_index := a_line.substring_index ("name=%"", 1) + 6
			l_key_end_index := a_line.substring_index ("%">", l_key_start_index) - 1
			l_key := a_line.substring (l_key_start_index, l_key_end_index)

				-- Find out value.
			l_value_start_index := l_key_end_index + 3
			l_value_end_index := a_line.substring_index ("</", l_value_start_index + 1) - 1
			l_value := a_line.substring (l_value_start_index, l_value_end_index)

			if l_value.is_integer then
				create Result.make_as_integer (l_key, l_value.to_integer, 1.0)
			elseif l_value.is_double then
				create Result.make_as_double (l_key, l_value.to_double, 1.0)
			else
				create Result.make_as_string (l_key, l_value, 1.0)
			end
		end

end
