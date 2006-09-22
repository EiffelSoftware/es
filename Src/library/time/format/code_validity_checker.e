indexing
	description: "Facility routines to check the validity of a DATE_TIME_CODE"
	legal: "See notice at end of class." 
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class 
	CODE_VALIDITY_CHECKER
		inherit
			DATE_TIME_FORMAT_CONVERTIONS_CODES

feature -- Preconditions

	is_code (s: STRING_32): BOOLEAN is
			-- Is the string a code?
		require
			s_exists: s /= Void
		do
			Result :=
			is_day (s) or is_day0 (s) or is_day_text (s) or is_full_day_text (s) or
			is_month0 (s) or is_month_text (s) or is_full_month_text (s) or
			is_year2 (s) or is_year4 (s) or
			is_hour (s) or is_hour0 (s) or is_hour12 (s) or is_hour12_0 (s) or is_meridiem (s) or
			is_minus (s) or is_minute (s) or is_minute0 (s) or is_month (s) or
			is_second (s) or is_second0 (s) or is_fractional_second (s) or
			is_separator (s)
		end

	is_day (s: STRING_32): BOOLEAN is
			-- Is the code a day-numeric?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (day_numeric)
		ensure
			definition: Result = s.is_equal (day_numeric)
		end

	is_day0 (s: STRING_32): BOOLEAN is
			-- Is the code a day-numeric
			-- Padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (day_numeric_padded)
		ensure
			definition: Result = s.is_equal (day_numeric_padded)
		end

	is_day_text (s: STRING_32): BOOLEAN is
			-- Is the code a day-text?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (abbreviated_day_name)
		ensure
			definition: Result = s.is_equal (abbreviated_day_name)
		end

	is_full_day_text (s: STRING_32): BOOLEAN is
			-- is the cod a full day text)
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (day_name)
		ensure
			definition: Result = s.is_equal (day_name)
		end

	is_year4 (s: STRING_32): BOOLEAN is
			-- Is the code a year-numeric 
			-- On 4 figures?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (long_year)
		ensure
			definition: Result = s.is_equal (long_year)
		end


	is_year2 (s: STRING_32): BOOLEAN is
			-- Is the code a year-numeric 
			-- On 2 figures?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (short_year)
		ensure
			definition: Result = s.is_equal (short_year)
		end


	is_month (s: STRING_32): BOOLEAN is
			-- Is the code a month-numeric?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (month_numeric)
		ensure
			definition: Result = s.is_equal (month_numeric)
		end

	is_month0 (s: STRING_32): BOOLEAN is
			-- Is the code a month-numeric
			-- Padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (month_numeric_padded)
		ensure
			definition: Result = s.is_equal (month_numeric_padded)
		end


	is_month_text (s: STRING_32): BOOLEAN is
			-- Is the code a month-text?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (abbreviated_month_name)
		ensure
			definition: Result = s.is_equal (abbreviated_month_name)
		end

	is_full_month_text (s: STRING_32): BOOLEAN is
			-- Is the code a full month-text?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (month_name)
		ensure
			definition: Result = s.is_equal (month_name)
		end

	is_hour (s: STRING_32): BOOLEAN is
			-- Is the code a 24-hour-clock-scale?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (hour_24)
		ensure
			definition: Result = s.is_equal (hour_24)
		end


	is_hour0 (s: STRING_32): BOOLEAN is
			-- Is the code a 24-hour-clock-scale
			-- Padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (hour_24_padded)
		ensure
			definition: Result = s.is_equal (hour_24_padded)
		end


	is_hour12 (s: STRING_32): BOOLEAN is
			-- Is the code a 12-hour-clock-scale?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (hour_12)
		ensure
			definition: Result = s.is_equal (hour_12)
		end

	is_hour12_0 (s: STRING_32): BOOLEAN is
			-- Is the code a 12-hour-clock-scale padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (hour_12_padded)
		ensure
			definition: Result = s.is_equal (hour_12_padded)
		end

	is_minute (s: STRING_32): BOOLEAN is
			-- Is the code a minute-numeric?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (numeric_minute)
		ensure
			definition: Result = s.is_equal (numeric_minute)
		end


	is_minute0 (s: STRING_32): BOOLEAN is
			-- Is the code a minute-numeric
			-- Padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (numeric_minute_padded)
		ensure
			definition: Result = s.is_equal (numeric_minute_padded)
		end


	is_second (s: STRING_32): BOOLEAN is
			-- Is the code a second-numeric?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (numeric_seconds)
		ensure
			definition: Result = s.is_equal (numeric_seconds)
		end


	is_second0 (s: STRING_32): BOOLEAN is
			-- Is the code a second-numeric
			-- Padded with zero?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (numeric_seconds_padded)
		ensure
			definition: Result = s.is_equal (numeric_seconds_padded)
		end


	is_fractional_second (s: STRING_32): BOOLEAN is
			-- Is the code a fractional-second 
			-- With precision to n figures?
		require
			s_exists: s /= Void
		local
			substrg, substrg2: STRING_32
		do
			if s.count > 2 then
				substrg := s.substring (1, 2)
				substrg2 := s.substring (3, s.count)
				Result := substrg.is_equal (seconds_fractional) and substrg2.is_integer
			end
		ensure
			definition: Result = ((s.count > 2) and then (s.substring (1, 2).is_equal (seconds_fractional) and
									(s.substring (3, s.count)).is_integer))
		end
		
	
	is_fractional_second_padded (s: STRING_32): BOOLEAN is
			-- Is the code a fractional-second without zeros?
			-- With precision to n figures?
		require
			s_exists: s /= Void
		local
			substrg, substrg2: STRING_32
		do
			if s.count > 2 then
				substrg := s.substring (1, 2)
				substrg2 := s.substring (3, s.count)
				Result := substrg.is_equal (seconds_fractional_padded) and substrg2.is_integer
			end
		ensure
			definition: Result = ((s.count > 2) and then (s.substring (1, 2).is_equal (seconds_fractional_padded) and
									(s.substring (3, s.count)).is_integer))
		end
		

	is_colon (s: STRING_32): BOOLEAN is
			-- Is the code a separator-colomn?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (":")
		ensure
			definition: Result = s.is_equal (":")
		end


	is_slash (s: STRING_32): BOOLEAN is
			-- Is the code a separator-slash?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal ("/")
		ensure
			definition: Result = s.is_equal ("/")
		end


	is_minus (s: STRING_32): BOOLEAN is
			-- Is the code a separator-minus?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal ("-")
		ensure
			definition: Result = s.is_equal ("-")
		end


	is_comma (s: STRING_32): BOOLEAN is
			-- Is the code a separator-coma?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (",")
		ensure
			definition: Result = s.is_equal (",")
		end


	is_space (s: STRING_32): BOOLEAN is
			-- Is the code a separator-space?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (" ")
		ensure
			definition: Result = s.is_equal (" ")
		end


	is_dot (s: STRING_32): BOOLEAN is
			-- Is the code a separator-dot?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (".")
		ensure
			definition: Result = s.is_equal (".")
		end
	
	is_semi_colon (s : STRING_32): BOOLEAN is
			-- Is the code a separator-semi-colon?
		require
			s_exists: s /= Void
		do
			Result := s.is_equal (";")
		ensure
			definition: Result = s.is_equal (";")
		end

	is_separator (s: STRING_32): BOOLEAN is
			-- Is the code a seperator?
		require
			s_exists: s /= Void
		do
			Result := is_slash (s) or else is_colon (s) or else
				is_minus (s) or else is_comma (s) or else is_space (s) or else
				is_dot (s) or else is_semi_colon (s)
		ensure
			definition: Result = is_slash (s) or else is_colon (s) or else
						is_minus (s) or else is_comma (s) or else
						is_space (s) or else is_dot (s)
		end

	is_meridiem (s: STRING_32): BOOLEAN is
			-- Is the code a meridiem notation?
		require
			s_exists: s /= Void
		local
			tmp: STRING_32
		do
			tmp := s.as_upper
			Result := tmp.is_equal (am_suffix) or tmp.is_equal (pm_suffix)
		ensure
			definition: Result = s.as_upper.is_equal (am_suffix) or
								s.as_upper.is_equal (pm_suffix)
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




end -- class CODE_VALIDITY_CHECKER


