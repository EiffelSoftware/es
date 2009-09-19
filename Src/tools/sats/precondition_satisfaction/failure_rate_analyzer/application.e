indexing
	description : "ps_failure_rate_analyzer application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			if argument_count /= 3 then
				io.put_string ("Usage: ps_failure_rate_analyzer <file_path> <test_run_length> <time_unit>%N")
				io.put_string ("This program takes a autotest result file and output detailed information on object suggestion success rate.%N")
				io.put_string ("<file_path> is the full path of a autotest result file.%N")
				io.put_string ("<test_run_length> is the length in second of a test run. All data beyond this time will be ignored.%N")
				io.put_string ("<time_unit> is unit in second of analysis granularity. For example, 60 means a minute%N")
			else
				result_file_path := argument (1)
				test_run_length := argument (2).to_integer
				time_unit := argument (3).to_integer
				unit_count := test_run_length // time_unit
				create suggestions.make
				create failed_suggestions.make
				create suggestions_per_unit.make (1, unit_count)
				create failed_suggestions_per_unit.make (1, unit_count)
				create mixed_suggestions.make (1, unit_count)
				load_file
				analyze_data
			end
		end

feature -- Access

	result_file_path: STRING
			-- Full path to the proxy result file

	time_unit: INTEGER
			-- Unit in second of time analysis

	unit_count: INTEGER

	test_run_length: INTEGER
			-- Length in second of test run
			-- All data beyond this length will be ignored

	suggestions: LINKED_LIST [TUPLE [class_name: STRING; feature_name: STRING; start_time: INTEGER; end_time: INTEGER; duration: INTEGER; success_flag: INTEGER]]
			-- List of suggestions made by AutoTest during the test run

	failed_suggestions: LINKED_LIST [TUPLE [class_name: STRING; feature_name: STRING; assertion: STRING; start_time: INTEGER]]
			-- List of failed suggestions

	suggestions_per_unit: ARRAY [INTEGER]

	failed_suggestions_per_unit: ARRAY [INTEGER]

	mixed_suggestions: ARRAY [DS_LINKED_LIST [STRING]]

feature{NONE} -- Implementation

	load_file is
			-- Load data from `result_file_path'.
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_parts: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_start_time: INTEGER
			l_end_time: INTEGER
			l_duration: INTEGER
			l_success_flag: INTEGER
			l_assertion: STRING
		do
			create l_file.make_open_read (result_file_path)

				-- Go to the precondition evaluation overhead section in the file.
			from
				l_file.read_line
				l_line := l_file.last_string.twin
			until
				l_line.has_substring ("--[Precondition evaluation overhead]")
			loop
				l_file.read_line
				l_line := l_file.last_string.twin
			end
			l_file.read_line

				-- Load precondition suggestions made by AutoTest.
			from
				l_file.read_line
				l_line := l_file.last_string.twin
			until
				l_line.is_empty
			loop
				l_parts := l_line.split ('%T')
				l_class_name := l_parts.i_th (1)
				l_feature_name := l_parts.i_th (2)
				l_assertion := l_parts.i_th (3)
				l_start_time := l_parts.i_th (4).to_integer
				l_start_time := l_parts.i_th (5).to_integer
				l_end_time := l_parts.i_th (6).to_integer
				l_duration := l_parts.i_th (7).to_integer
				l_success_flag := l_parts.i_th (8).to_integer

				suggestions.extend ([l_class_name, l_feature_name, l_start_time, l_end_time, l_duration, l_success_flag])
				l_file.read_line
				l_line := l_file.last_string.twin
			end

				-- Go to the failed proposal section in the file.
			from
				l_file.read_line
				l_line := l_file.last_string.twin
			until
				l_line.has_substring ("--[Failed precondition proposal]")
			loop
				l_file.read_line
				l_line := l_file.last_string.twin
			end
			l_file.read_line

				-- Load precondition failed suggestions made by AutoTest.
			from
				l_file.read_line
				l_line := l_file.last_string.twin
			until
				l_line.is_empty
			loop
				l_parts := l_line.split ('%T')
				l_class_name := l_parts.i_th (1)
				l_feature_name := l_parts.i_th (2)
				l_assertion := l_parts.i_th (3)
				l_start_time := l_parts.i_th (4).to_integer
				failed_suggestions.extend ([l_class_name, l_feature_name, l_assertion, l_start_time])
				l_file.read_line
				l_line := l_file.last_string.twin
			end
			l_file.close
		end

	analyze_data is
			-- Analyze data.
		local
			l_unit: INTEGER
			l_start_time: INTEGER
			l_end_time: INTEGER
			l_str: STRING
			l_list: DS_LINKED_LIST [STRING]
			l_sorter: DS_QUICK_SORTER [STRING]
			l_sorted_list: SORTED_TWO_WAY_LIST [STRING]
		do
			from
				l_unit := 1
				suggestions.start
				failed_suggestions.start
			until
				l_unit > unit_count
			loop
				l_start_time := (l_unit - 1) * time_unit
				l_end_time := l_unit * time_unit
				from
				until
					suggestions.after or suggestions.item.start_time >= l_end_time
				loop
					if suggestions.item.start_time >= l_start_time then
						create l_str.make (64)
						if suggestions.item.start_time < 1000 then
							l_str.append ("0")
						end
						l_str.append (suggestions.item.start_time.out)
						l_str.append ("%T")
						l_str.append (suggestions.item.class_name)

						l_str.append ("%T")
						l_str.append (suggestions.item.feature_name)

						l_str.append ("%T")
						l_str.append (suggestions.item.success_flag.out)
						if mixed_suggestions.item (l_unit) = Void then
							create l_list.make
							mixed_suggestions.put (l_list, l_unit)
						else
							l_list := mixed_suggestions.item (l_unit)
						end
						l_list.force_last (l_str)
						suggestions_per_unit.put (suggestions_per_unit.item (l_unit) + 1, l_unit)
					end
					suggestions.forth
				end

				from
				until
					failed_suggestions.after or failed_suggestions.item.start_time >= l_end_time
				loop
					if failed_suggestions.item.start_time >= l_start_time then
						create l_str.make (64)
						if failed_suggestions.item.start_time < 1000 then
							l_str.append ("0")
						end
						l_str.append (failed_suggestions.item.start_time.out)
						l_str.append ("%T")
						l_str.append (failed_suggestions.item.class_name)

						l_str.append ("%T")
						l_str.append (failed_suggestions.item.feature_name)

						l_str.append ("%T")
						l_str.append (failed_suggestions.item.assertion)
						if mixed_suggestions.item (l_unit) = Void then
							create l_list.make
							mixed_suggestions.put (l_list, l_unit)
						else
							l_list := mixed_suggestions.item (l_unit)
						end
						l_list.force_last (l_str)
						failed_suggestions_per_unit.put (failed_suggestions_per_unit.item (l_unit) + 1, l_unit)
					end
					failed_suggestions.forth
				end

					-- Print out result.
				create l_sorted_list.make
				if mixed_suggestions.item (l_unit) /= Void then
					mixed_suggestions.item (l_unit).do_all (agent l_sorted_list.extend)
				end

				l_sorted_list.sort
				io.put_string (l_unit.out + "%N")
				from
					l_sorted_list.start
				until
					l_sorted_list.after
				loop
					io.put_string (l_sorted_list.item + "%N")
					l_sorted_list.forth
				end
				io.put_string ("------------------------------------------%N%N")

				l_unit := l_unit + 1
			end

			io.put_string ("%N%N")
			io.put_string ("--Failures in minute%N")
			io.put_string ("--Minute%TProposed suggestions%TFailed suggestions%N")
			from
				l_unit := 1
			until
				l_unit > unit_count
			loop
				io.put_string ((l_unit * 60).out + "%T" + suggestions_per_unit.item (l_unit).out + "%T" + failed_suggestions_per_unit.item (l_unit).out + "%N")
				l_unit := l_unit + 1
			end
		end

end
