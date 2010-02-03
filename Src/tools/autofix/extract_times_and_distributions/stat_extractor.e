note
	description: "Summary description for {STAT_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STAT_EXTRACTOR

feature -- Constants

	output_file_name:STRING is "times.csv"
	separator:STRING is ","

feature -- Operations

	extract(a_source_dir, a_target_dir: STRING)
			-- extract stuff
		local
			l_dir: DIRECTORY
		do
			source_dir := a_source_dir
			target_dir := a_target_dir

			create output_file.make_open_write (target_dir+"\"+output_file_name)
			output_file.put_string ("Testcase"+separator+"No. of passing testcases"+separator+"No. of failing testcases"+separator+"Analysing-phase"+separator+"Generating-phase"+separator+"Validation-phase"+"%N")

			create l_dir.make_open_read(source_dir)
			from
				l_dir.start
				l_dir.readentry
			until
				l_dir.lastentry = void
			loop
				if not l_dir.lastentry.is_equal (".") and not l_dir.lastentry.is_equal ("..") then
					process_testcase(l_dir.lastentry)
				end
				l_dir.readentry
			end
			l_dir.close
		end

feature {NONE} -- Implementation

	source_dir, target_dir: STRING

	output_file: PLAIN_TEXT_FILE

	cur_passing_test_cases: INTEGER
	cur_failing_test_cases: INTEGER

	compute_passing_testcases(a_name: STRING)
			-- process a_name
		local
			a_dir: DIRECTORY
		do
			create a_dir.make_open_read (source_dir+"\"+a_name)

			from
				cur_passing_test_cases := 0
				cur_failing_test_cases := 0

				a_dir.start
				a_dir.readentry
			until
				a_dir.lastentry = void
			loop
				if a_dir.lastentry.starts_with ("TC__") then
					if a_dir.lastentry.has_substring ("__S__") then
						cur_passing_test_cases := cur_passing_test_cases + 1
					elseif a_dir.lastentry.has_substring ("__F__") then
						cur_failing_test_cases := cur_failing_test_cases + 1
					end
				end
				a_dir.readentry
			end
			a_dir.close
		end

	process_testcase(a_name: STRING)
			-- process testcase in `a_dir'
		local
			l_input_file: PLAIN_TEXT_FILE
					-- Input file

			l_analyizing_start, l_analyizing_end: INTEGER
			l_generation_start, l_generation_end: INTEGER
			l_validation_start, l_validation_end: INTEGER
					-- Start + end times

			l_analyze_time, l_generate_time, l_validate_time: STRING
					-- Durations

			l_result: STRING
					-- String that is printed for times

			l_total_fixes: INTEGER
					-- Total number of fixes

			l_cur_fix: INTEGER
					-- Number of current fix

			l_num_valid_fixes: INTEGER
					-- Number of valid fixes

			l_num_found_valid_fixes: INTEGER
					-- Number of valid fixes found so far

			l_fix_valid: ARRAY[BOOLEAN]
					-- Validty of fixes by ID

			l_found_fixes: ARRAY[INTEGER]
					-- Found valid fixes by ID

			l_distribution_output_file: PLAIN_TEXT_FILE
					-- Output file for distribution

			l_scaling_factor: DOUBLE
					-- Scaling factor for normalization

			l_index: INTEGER
					-- Counter
		do
			create l_input_file.make (source_dir+"\"+a_name+"\EIFGENs\project\AutoFix\log\proxy_log.txt")

			if l_input_file.exists then
				-- Gather data
				from
					l_analyizing_start := -1
					l_analyizing_end := -1
					l_generation_start := -1
					l_generation_end := -1
					l_validation_start := -1
					l_validation_end := -1

					l_cur_fix := 1
					l_num_valid_fixes := 0

					l_input_file.open_read
					l_input_file.start
				until
					l_input_file.after
				loop
					l_input_file.read_line

					if l_input_file.last_string.starts_with ("-- time stamp: ") then
						if l_input_file.last_string.starts_with ("-- time stamp: test case analyzing starts") then
							l_analyizing_start := l_input_file.last_string.split (';')[2].to_integer
						elseif l_input_file.last_string.starts_with ("-- time stamp: test case analyzing ends") then
							l_analyizing_end := l_input_file.last_string.split (';')[2].to_integer
						elseif l_input_file.last_string.starts_with ("-- time stamp: fix generation starts") then
							l_generation_start := l_input_file.last_string.split (';')[2].to_integer
						elseif l_input_file.last_string.starts_with ("-- time stamp: fix generation ends") then
							l_generation_end := l_input_file.last_string.split (';')[2].to_integer
							l_total_fixes := l_input_file.last_string.split (' ')[7].to_integer

							if l_total_fixes>0 then
								create l_fix_valid.make (1, l_total_fixes)
							end
						elseif l_input_file.last_string.starts_with ("-- time stamp: fix validation starts") then
							l_validation_start := l_input_file.last_string.split (';')[2].to_integer
						elseif l_input_file.last_string.starts_with ("-- time stamp: fix validation ends") then
							l_validation_end := l_input_file.last_string.split (';')[2].to_integer
						elseif l_input_file.last_string.starts_with ("-- time stamp: fix candidate validation starts") then
							l_input_file.read_line
							if l_input_file.last_string.has_substring ("Validity: True") then
								l_num_valid_fixes := l_num_valid_fixes + 1
								l_fix_valid[l_cur_fix] := True
							else
								l_fix_valid[l_cur_fix] := False
							end

							l_cur_fix := l_cur_fix + 1
						end
					end
				end

				l_input_file.close

				-- Calculate times
				if l_analyizing_end>0 and l_analyizing_start>0 then
					l_analyze_time := (l_analyizing_end-l_analyizing_start).out
				else
					l_analyze_time := "X"
				end

				if l_generation_end>0 and l_generation_start>0 then
					l_generate_time := (l_generation_end-l_generation_start).out
				else
					l_generate_time := "X"
				end

				if l_validation_end>0 and l_validation_start>0 then
					l_validate_time := (l_validation_end-l_validation_start).out
				else
					l_validate_time := "X"
				end

				compute_passing_testcases(a_name)

				l_result := a_name + separator + cur_passing_test_cases.out + separator + cur_failing_test_cases.out + separator + l_analyze_time + separator +  l_generate_time + separator + l_validate_time + "%N"
				io.put_string (l_result)
				output_file.put_string (l_result)

				-- Create distribution output
				create l_distribution_output_file.make_open_write (target_dir + "\" + a_name + ".csv")
				l_distribution_output_file.put_string ("Current fix"+separator+"Percentage of valid fixes found"+"%N")
				from
					create l_found_fixes.make (1, l_total_fixes)
					l_cur_fix := 1
				until
					l_cur_fix > l_total_fixes
				loop
					if l_num_valid_fixes>0 then
						if l_fix_valid[l_cur_fix] then
							l_num_found_valid_fixes := l_num_found_valid_fixes + 1
						end

						l_found_fixes[l_cur_fix] := l_num_found_valid_fixes

						l_distribution_output_file.put_string (l_cur_fix.out + separator + (l_num_found_valid_fixes/l_num_valid_fixes).out+"%N")
					else
						l_distribution_output_file.put_string (l_cur_fix.out + separator + (0).out+"%N")
					end

					l_cur_fix := l_cur_fix + 1
				end
				l_distribution_output_file.close

				-- Create normalized distribution output
				create l_distribution_output_file.make_open_write (target_dir + "\" + a_name + ".normalized.csv")
				from
					l_index := 1
					l_scaling_factor := l_total_fixes/100
				until
					l_index > 100
				loop
					if l_num_valid_fixes>0 then
						-- fixes to consider at this point
						l_cur_fix := (l_scaling_factor * l_index).floor
						if l_cur_fix>0 then
							l_distribution_output_file.put_string (l_index.out + separator + (l_found_fixes[l_cur_fix]/l_num_valid_fixes).out+"%N")
						else
							l_distribution_output_file.put_string (l_index.out + separator + (0/l_num_valid_fixes).out+"%N")
						end
					else
						l_distribution_output_file.put_string (l_index.out + separator + (0).out+"%N")
					end

					l_index := l_index + 1
				end
				l_distribution_output_file.close
			end
		end
end
