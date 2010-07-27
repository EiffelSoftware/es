note
	description: "This class will be responsible for parsing the performance file generated from rapidminer validation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_PERFORMANCE_PARSER

feature -- Interface

	parse_performance
			-- Parses the performance file from rapidminer. The loction of the file is in `RM_ENVIRONMENT.performance_file_path'
		local
			l_file: PLAIN_TEXT_FILE
			rm_conts: RM_CONSTANTS
			l_line: STRING
		do
			-- currently we only need the accuracy. if later we need some other performance metrics, they should be parsed here.
			create rm_conts
			create l_file.make_open_read (rm_conts.rm_environment.performance_file_path)
			if l_file.exists then
				--first two lines are the dates
				l_file.read_line
				l_file.read_line
				-- read the accuracy line
				l_file.read_line
				l_line := l_file.last_string
				if l_line.substring (11, 17) ~ "100.00%%" then
					is_accurate := True
				end

			end
		end

feature -- Access

	is_accurate: BOOLEAN
		-- The result from `parse_performance'

end
