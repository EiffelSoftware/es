note
	description: "Summary description for {RM_LINEAR_REGRESSION_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
class
	RM_LINEAR_REGRESSION_PARSER

create
	make

feature{NONE} -- Create
	make(a_model_file_path: STRING)
			-- `a_model_file_path' the path to the model file.
		do
			model_file_path := a_model_file_path
		end

feature -- Interface

	parse_linear_regression
			-- parses the linear regression from the file located at `model_file_path'
		local
			l_model_file: PLAIN_TEXT_FILE
		do
			create l_model_file.make_open_read (model_file_path)
			create last_linear_regression.make ("")
			if not l_model_file.is_empty then
				l_model_file.start
				-- just skip the first line, since it holds the date
				l_model_file.read_line
				-- remove the date from the beginning of the second line
				l_model_file.read_line
				parse_line(cleaned_line(l_model_file.last_string))
				from until l_model_file.end_of_file loop
					l_model_file.read_line
					parse_line(l_model_file.last_string)
				end
			end
		end

feature -- Access

	last_linear_regression: RM_LINEAR_REGRESSION

feature{NONE} -- Internal data holders

	model_file_path: STRING

feature{NONE} -- Implementation

	parse_line(a_line: STRING)
			-- Parses a line from a linear regression model file line. Puts the
			-- parsed regressors in the `last_linear_regression'
		local
			l_list: LIST [STRING]
			l_value: DOUBLE
		do
			if not a_line.is_empty then
				if a_line.starts_with ("+") then
					a_line.keep_tail (a_line.count - 2)
				end
				if a_line.has ('*') then
					l_list := a_line.split ('*')
					l_list[1].left_adjust
					l_list[1].right_adjust
					l_list[2].left_adjust
					l_list[2].right_adjust
					if l_list[1].is_double then
						l_value := l_list[1].to_double
						last_linear_regression.add_regressor (l_list[2], l_value)
					end
				else
					if a_line.is_double then
						l_value := a_line.to_double
						last_linear_regression.add_regressor (last_linear_regression.constant_regressor, l_value)
					end
				end
			end
		end

	cleaned_line(a_line: STRING): STRING
			-- Currently rapidminer prints the first line of the linear regression at the same line
			-- where it prints the date. The date is irrelevant and must be cleaned. This feature
			-- takes care of that - deleted the date in the beginning and returns the cleaned line.
		do
			-- cut the string until the second space character
			Result :=  a_line.substring (a_line.index_of (' ', 1) + 1, a_line.count)
			Result :=  Result.substring (Result.index_of (' ', 1), Result.count)
			Result.left_adjust
		end

end
