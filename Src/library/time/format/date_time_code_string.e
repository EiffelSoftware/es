indexing
	description: "DATE/TIME to STRING_32 conversion"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class DATE_TIME_CODE_STRING
	inherit
		FIND_SEPARATOR_FACILITY
		DATE_TIME_FORMAT_CONVERTIONS_CODES
		DATE_TIME_TYPES

create

	make

feature -- Creation

	make (s: STRING_32) is
			-- Create code descriptors and hash-table from `s'.
		require
			s_exists: s /= Void
		local
			code: DATE_TIME_CODE
			i, pos1, pos2: INTEGER
			date_constants: DATE_CONSTANTS
		do
			create value.make (20)
				-- 20 is the number of special characters
			pos1 := 1
			pos2 := 1
			create date_constants
			days := date_constants.days_text.twin
				-- Short text representation of days
			long_days := date_constants.long_days_text.twin
				-- Long text representation of days
			months := date_constants.months_text.twin
				-- Short text representation of months
			long_months := date_constants.long_months_text.twin		--? Why twin??
				-- Long text representation of months
			
			from
				i := 1
			until
				pos1 >= s.count 
			loop
				pos2 := find_separator (s, pos1)
				extract_substrings (s, pos1, pos2)
				pos2 := abs (pos2)
-- 				substrg.to_lower	-- i18n
				if substrg.count > 0 then
-- 					substring found, create according
-- 					code and store it
					create code.make (substrg)
					value.put (code, i)
					i := i + 1
				end
				if substrg2.count > 0 then
-- 					add separator
					value.put (create {DATE_TIME_CODE}.make (substrg2), i)
					i := i + 1
					separators_used := True
				end
				pos1 := pos2 + 1
			end
			base_century := (create {C_DATE}).year_now // 100 * -100
				-- A negative value of `base_century' indicates that it has
				-- been calculated automatically, therefore '* -100'.
		ensure
			value_set: value /= Void
			base_century_set: base_century < 0 and (base_century \\ 100 = 0)
		end

feature -- Attributes

	value: HASH_TABLE [DATE_TIME_CODE, INTEGER]
			-- Hash-table representing the code string.

	name: STRING_32 is
			-- Name of the code string.
		local
			i: INTEGER
		do	
			create Result.make (1)
			from
				i := 1
			until
				value.item (i) = Void
			loop
				Result.append (value.item (i).name)
				Result.append (" ")
				i := i + 1
			end
		end

	base_century: INTEGER
			-- Base century, used when interpreting 2-digit year
			-- specifications.
			
feature -- Status report

	is_date (s: STRING_32): BOOLEAN is
			-- Does `s' contain a DATE?
		require
			non_empty_string: s /= Void and then not s.is_empty
		do
			build_parser (s)
			Result := parser.is_date
		end

	is_time (s: STRING_32): BOOLEAN is
			-- Does `s' contain a TIME?
		require
			non_empty_string: s /= Void and then not s.is_empty
		do
			build_parser (s)
			Result := parser.is_time
		end	

	is_date_time (s: STRING_32): BOOLEAN is
			-- Does `s' contain a DATE_TIME?
		require
			non_empty_string: s /= Void and then not s.is_empty
		do
			build_parser (s)
			Result := parser.is_date_time
		end

	is_value_valid (s: STRING_32): BOOLEAN is
			-- Does `s' contain a valid date or time as string representation?
		require
			non_empty_string: s /= Void and then not s.is_empty
		do
			build_parser (s)
			Result := parser.is_date or parser.is_time or parser.is_date_time
		end

	separators_used: BOOLEAN
			-- Does the code string contain any separators?
			
feature -- Status setting

	set_base_century (c: INTEGER) is
			-- Set base century to `c'.
		require
			base_valid: c > 0 and (c \\ 100 = 0)
		do
			base_century := c
		ensure
			base_century_set: base_century = c
		end

feature -- Interface

	correspond (s: STRING_32): BOOLEAN is
			-- Does the user string `s' correspond to the code string?
		require
			s_exists: s /= Void
		local
			pos1, pos2, i: INTEGER
			code: DATE_TIME_CODE
			has_seps: BOOLEAN
		do
			pos1 := 1
			pos2 := 1

			if s.count = 0 then
				Result := False
			else
				Result := True
				has_seps := has_separators (s)
			end
			from
				i := 1
			until
				pos1 > s.count
				or Result = False
			loop
				code := value.item (i)
				if has_seps then
					pos2 := find_separator (s, pos1)
				else
					pos2 := (pos1 + code.count_max - 1) * -1
				end
				extract_substrings (s, pos1, pos2)
				pos2 := abs (pos2)
				if code = Void then
					Result := false
				else
					if substrg.count > 0 then
						Result := substrg.count <= code.count_max and 
						substrg.count >= code.count_min
						if code.is_numeric then
							Result := Result and substrg.is_integer
							if code.value_max /= -1 and 
								code.value_min /= -1 then
								Result := Result and 
									substrg.to_integer <= code.value_max and
									substrg.to_integer >= code.value_min
							end
						elseif code.is_meridiem (code.value) then
							Result := Result and (substrg.as_upper.is_equal (am_suffix) or
								substrg.as_upper.is_equal (pm_suffix))
						elseif code.is_day_text (code.value) then 
							Result := Result and days.has (substrg)
						elseif code.is_full_day_text (code.value) then
							Result := Result and long_days.has (substrg)
						elseif code.is_month_text (code.value) then
							Result := Result and months.has (substrg)
						elseif code.is_full_month_text (code.value) then
							Result := Result and long_months.has (substrg)
						end
						i := i + 1
					end
					if has_seps then
						code := value.item (i)
						i := i + 1
						if code /= Void then
							Result := Result and (pos2 /= s.count) and 
								substrg2.is_equal (code.value)
						end
					end
					pos1 := pos2 + 1
				end
			end
		end	

	create_string (date_time: DATE_TIME): STRING_32 is
			-- Create the output of `date_time' according to the code string.
		require
			non_void: date_time /= Void
		local
			date: DATE
			time: TIME
			int, i, type: INTEGER
			double: DOUBLE
			l_tmp: STRING_32
		do
			create Result.make (1)
			date := date_time.date
			time := date_time.time
			from 
				i := 1
			until
				value.item (i) = Void
			loop
				type := value.item (i).type
				inspect
					type
				when Day_numeric_type then
					-- day-numeric
					Result.append (date.day.out)
				when Day_numeric_on_2_digits_type then
					-- day-numeric-on-2-digits
					int := date.day
					if int < 10 then
						Result.append ("0")
					end
					Result.append (int.out)
				when Day_text_type then
					-- day-text
					int := date.day_of_the_week
					Result.append (days.item (int))
				when Full_day_text_type then
					-- full day-text
					int := date.day_of_the_week
					Result.append (long_days.item (int))
				when Year_on_4_digits_type then
					-- year-on-4-digits
					-- Test if the year has four digits, if not put 0 to fill it
					l_tmp := date.year.out
					if l_tmp.count = 1 then
						Result.append ("000")
					elseif l_tmp.count = 2 then
						Result.append ("00")
					elseif l_tmp.count = 3 then
						Result.append ("0")
					end
					Result.append (l_tmp)
				when Year_on_2_digits_type then 
						-- Two digit year, we only keep the last two digits
					l_tmp := date.year.out
					if l_tmp.count > 2 then
						l_tmp.keep_tail (2)
					elseif l_tmp.count = 1 then
						Result.append_character ('0')
					end
					Result.append (l_tmp)
				when Month_numeric_type then
					-- month-numeric
					Result.append (date.month.out)
				when Month_numeric_on_2_digits_type then
					-- month-numeric-on-2-digits
					int := date.month
					if int < 10 then
						Result.append ("0")
					end
					Result.append (int.out)
				when Month_text_type then
					-- month-text
					int := date.month
					Result.append (months.item (int))
				when Full_month_text_type then
					-- full month-text
					int := date.month
					Result.append (long_months.item (int))
				when Hour_numeric_type then
					-- hour-numeric
					Result.append (time.hour.out)
				when Hour_numeric_on_2_digits_type then
					-- hour-numeric-on-2-digits
					int := time.hour
					if int < 10 then
						Result.append ("0")
					end
					Result.append (int.out)
				when Hour_12_clock_scale_type, Hour_12_on_2_digits then
					-- hour-12-clock-scale or hour-numeric
					int := time.hour
					if int < 12 then
						if int = 0 then
							int := 12
						end
					else
						if int /= 12 then 
							int := int - 12
						end
					end
					if type = Hour_12_on_2_digits and then int < 10 then
							-- Format padded with 0.
						Result.append ("0")
					end
					Result.append (int.out)
				when Minute_numeric_type then 
					-- minute-numeric
					Result.append (time.minute.out)
				when Minute_numeric_on_2_digits_type then
					-- minute-numeric-on-2-digits
					int := time.minute
					if int < 10 then
						Result.append ("0")
					end
					Result.append (int.out)
				when Second_numeric_type then
					-- second-numeric
					Result.append (time.second.out)
				when Second_numeric_on_2_digits_type then
					-- second-numeric-on-2-digits
					int := time.second
					if int < 10 then
						Result.append ("0")
					end
					Result.append (int.out)
				when Fractional_second_numeric_type,
					 Fractional_second_numeric_type_padded then
					-- fractional-second-numeric
					double := time.fractional_second * 
						10 ^ (value.item (i).count_max)
					int := double.truncated_to_integer
					if not (int = 0 and type = Fractional_second_numeric_type_padded) then
						Result.append (int.out)
					end
				when Meridiem_type then
					-- meridiem
					int := time.hour
					if int < 12 then
						Result.append (am_suffix)
					else
						Result.append (pm_suffix)
					end
				else -- a seprator or a user string
					Result.append (value.item (i).value)
				end
				i := i + 1
			end
		ensure
			string_exists: Result /= Void
			string_correspond: correspond (Result)
		end	
	
	create_date_string (date: DATE): STRING_32 is
				-- Create the output of `date' according to the code string.
		require
			date_exists: date /= Void
		local
			date_time: DATE_TIME
		do
			create date_time.make_by_date (date)
			Result := create_string (date_time)
		ensure
			string_exists: Result /= Void
			string_correspond: correspond (Result)
		end

	create_time_string (time: TIME): STRING_32 is
				-- Create the output of `time' according to the code string.
		require
			time_exists: time /= Void
		local
			date_time: DATE_TIME
		do
			create date_time.make_fine (1, 1, 1, time.hour, time.minute, 
				time.fine_second)
			Result := create_string (date_time)
		ensure
			string_exists: Result /= Void
			string_correspond: correspond (Result)
		end

	create_date_time (s: STRING_32): DATE_TIME is
			-- Create DATE_TIME according to `s'.
		require
			s_exist: s /= Void
			is_precise: precise
			s_correspond: correspond (s)
			valid: is_value_valid (s)
		local
			i: INTEGER
		do
			right_day_text := True
			build_parser (s)
			create Result.make_fine (parser.year, parser.month, parser.day, 
					parser.hour, parser.minute, parser.fine_second)
			if parser.day_text /= Void then
				i := Result.date.day_of_the_week
				right_day_text := parser.day_text.is_equal (days.item (i))
			end
		ensure
			date_time_exists: Result /= Void
			day_text_equal_day: right_day_text
		end

	create_date (s: STRING_32): DATE is
			-- Create a DATE according to the format in `s'.
		require
			s_exists: s /= Void
			is_precise: precise_date
			s_correspond: correspond (s)
		local
			tmp_code: DATE_TIME_CODE
			tmp_ht: HASH_TABLE [DATE_TIME_CODE, INTEGER]
			i: INTEGER
		do
			tmp_ht := value.twin
			i := value.count + 1
			if has_separators (s) then
				create tmp_code.make (" ")
				value.put (tmp_code, i)
				create tmp_code.make ("hh")
				value.put (tmp_code, i + 1)
				create tmp_code.make (":")
				value.put (tmp_code, i + 2)
				create tmp_code.make ("mi")
				value.put (tmp_code, i + 3)
				create tmp_code.make (":")
				value.put (tmp_code, i + 4)
				create tmp_code.make ("ss")
				value.put (tmp_code, i + 5)
				s.append (" 0:0:0")
				Result := create_date_time (s).date
				s.replace_substring_all (" 0:0:0", "")
			else
				create tmp_code.make ("[0]hh")
				value.put (tmp_code, i)
				create tmp_code.make ("[0]mi")
				value.put (tmp_code, i + 1)
				create tmp_code.make ("[0]ss")
				value.put (tmp_code, i + 2)
				s.append ("000000")
				Result := create_date_time (s).date
				s.remove_tail (6)
			end
			value := tmp_ht
		ensure
			date_exists: Result /= Void
			day_text_equal_day: right_day_text
		end

	create_time (s: STRING_32): TIME is
			-- Create a TIME according to the format in `s'.
		require
			s_exists: s /= Void
			is_precise: precise_time
			s_correspond: correspond (s)
		local
			tmp_code: DATE_TIME_CODE
			tmp_ht: HASH_TABLE [DATE_TIME_CODE, INTEGER]
			i: INTEGER
		do
			tmp_ht := value.twin
			i := value.count + 1
			if has_separators (s) then
				create tmp_code.make (" ")
				value.put (tmp_code, i)
				create tmp_code.make ("dd")
				value.put (tmp_code, i + 1)
				create tmp_code.make ("/")
				value.put (tmp_code, i + 2)
				create tmp_code.make ("mm")
				value.put (tmp_code, i + 3)
				create tmp_code.make ("/")
				value.put (tmp_code, i + 4)
				create tmp_code.make ("yy")
				value.put (tmp_code, i + 5)
				s.append (" 1/1/01")
				Result := create_date_time (s).time
				s.replace_substring_all (" 1/1/01", "")
			else
				create tmp_code.make ("[0]dd")
				value.put (tmp_code, i)
				create tmp_code.make ("[0]mm")
				value.put (tmp_code, i + 1)
				create tmp_code.make ("yy")
				value.put (tmp_code, i + 2)
				s.append ("010101")
				Result := create_date_time (s).time
				s.remove_tail (6)
			end
			value := tmp_ht
		ensure
			time_exists: Result /= Void
			time_correspond: create_time_string (Result).is_equal (s)
		end


	precise: BOOLEAN is
			-- Is the code string enough precise to create
			-- nn instance of type DATE_TIME?
		require
			not_void: value /= Void
		do
			Result := precise_date and precise_time
		end

	precise_date: BOOLEAN is
			-- Is the code string enough precise to create
			-- nn instance of type DATE?
		require
			not_void: value /= Void
		local
			code: DATE_TIME_CODE
			i, type: INTEGER
			has_day, has_month, has_year: BOOLEAN
		do
			from 
				i := 1
			until 
				value.item (i) = Void
			loop
				code := value.item (i).twin
				type := code.type
				if separators_used then
					inspect
						type
					when Day_numeric_type, Day_numeric_on_2_digits_type then
						has_day := True
					when Year_on_4_digits_type, Year_on_2_digits_type then
						has_year := True
					when Month_numeric_type,
						 Month_numeric_on_2_digits_type,
						 Month_text_type then
						has_month := True
					else
						-- Wrong format
					end
				else
					inspect
						type
					when Day_numeric_on_2_digits_type then
						has_day := True
					when Year_on_4_digits_type, Year_on_2_digits_type then
						has_year := True
					when Month_numeric_on_2_digits_type then
						has_month := True
					else
						-- Wrong format
					end
				end
				i := i + 1
			end
			Result := has_day and has_month and has_year
		end

	precise_time: BOOLEAN is
			-- Is the code string enough precise to create
			-- an instance of type TIME?
		require
			not_void: value /= Void
		local
			code: DATE_TIME_CODE
			i, type: INTEGER
			has_hour, has_minute, has_second: BOOLEAN
		do
			from 
				i := 1
			until 
				value.item (i) = Void
			loop
				code := value.item (i).twin
				type := code.type
				if separators_used then
					inspect
						type
					when Hour_numeric_type,
						 Hour_numeric_on_2_digits_type,
						 Hour_12_clock_scale_type then
						has_hour := True
					when Minute_numeric_type, Minute_numeric_on_2_digits_type then
						has_minute := True
					when Second_numeric_type, Second_numeric_on_2_digits_type then
						has_second := True
					else
						-- Wrong format
					end
				else
					inspect
						type
					when Hour_numeric_on_2_digits_type then
						has_hour := True
					when Minute_numeric_on_2_digits_type then
						has_minute := True
					when Second_numeric_on_2_digits_type then
						has_second := True
					else
						-- Wrong format
					end
				end
				i := i + 1
			end
			Result := has_hour and has_minute and has_second
		end

feature {NONE} -- Implementation
		
	parser: DATE_TIME_PARSER
			-- Instance of date-time string parser

	days: ARRAY [STRING_32]

	long_days : ARRAY [STRING_32]

	months: ARRAY [STRING_32]
	
	long_months : ARRAY [STRING_32]

	right_day_text: BOOLEAN
			-- Is the name of the day the right one?

	build_parser (s: STRING_32) is
			-- Build parser from `s'.
		require
			non_empty_string: s /= Void and then not s.is_empty
		do
			if parser = Void or else not equal (parser.source_string, s) then
				create parser.make (value)
				parser.set_day_array (days)
				parser.set_month_array (months)
				parser.set_base_century (base_century)
				parser.set_source_string (s)
				parser.parse
			end
		ensure
			parser_created: parser /= Void
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class DATE_TIME_CODE_STRING_32


