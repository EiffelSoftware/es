indexing
	description: "Code used by the DATE/TIME to STRING_32 conversion"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class DATE_TIME_CODE
		inherit
			CODE_VALIDITY_CHECKER
			DATE_TIME_TYPES

create

	make

feature -- Creation
	
	make (v: STRING_32) is
			-- Create code.
		require
			v_exists: v /= Void
-- 			v_is_code: is_code (v)
		do
			set_value (v)
		ensure
			value_set: value.is_equal (v)
		end

feature -- Change

	set_value (v: STRING_32) is
			-- Set all the attributes such as
			-- Value, count_max, etc.
		require
			v_exists: v /= Void
-- 			v_is_code: is_code (v)
		do
			value := v.twin
			if not is_code (v) then
				count_max := 10 --?
				count_max := 10 --?
				name := "user-string"
				value_max := 10 --?
				value_min := 10 --?
				is_text := True
				is_numeric := False
				type := User_string
			elseif is_day (value) then
				count_max := 2
				count_min := 1
				name := "day-numeric"
				value_max := 31
				value_min := 1
				is_text := False
				is_numeric := True
				type := Day_numeric_type
			elseif is_day0 (value) then
				count_max := 2
				count_min := 2
				name := "day-numeric-on-2-digits"
				value_max := 31
				value_min := 1	
				is_text := False
				is_numeric := True
				type := Day_numeric_on_2_digits_type
			elseif is_day_text (value) then
				count_max := 3
				count_min := 3
				name := "day-text"
				value_max := 7
				value_min := 1
				is_text := True
				is_numeric := False
				type := Day_text_type
			elseif is_full_day_text (value) then
				count_max := 2
				count_min := 2
				name := "full-day-text"
				value_max := -1
				value_min := -1
				is_text := True
				is_numeric := False
				type := Full_day_text_type
			elseif is_year4 (value) then
				count_max := 4
				count_min := 4
				name := "year-on-4-digits"
				is_text := False
				is_numeric := True
				type := Year_on_4_digits_type
				value_max := -1
				value_min := -1
			elseif is_year2 (value) then
				count_max := 2
				count_min := 2
				name := "year-on-2-digits"
				is_text := False
				is_numeric := True
				type := Year_on_2_digits_type
				value_max := -1
				value_min := -1
			elseif is_month (value) then
				count_max := 2
				count_min := 1
				name := "month-numeric"
				value_max := 12
				value_min := 1
				is_text := False
				is_numeric := True
				type := Month_numeric_type
			elseif is_month0 (value) then
				count_max := 2
				count_min := 2
				name := "month-numeric-on-2-digits"
				value_max := 12
				value_min := 1
				is_text := False
				is_numeric := True
				type := Month_numeric_on_2_digits_type
			elseif is_month_text (value) then
				count_max := 3
				count_min := 3
				name := "month-text"
				value_max := 12
				value_min := 1
				is_text := True
				is_numeric := False
				type := Month_text_type
			elseif is_full_month_text (value) then
				count_max := 2
				count_min := 2
				name := "full-month-text"
				value_max := -1
				value_min := -1
				is_text := True
				is_numeric := False
				type := Full_month_text_type
			elseif is_hour (value) then
				count_max := 2
				count_min := 1
				name := "hour-numeric"
				value_max := 24
				value_min := 0
				is_text := False
				is_numeric := True
				type := Hour_numeric_type
			elseif is_hour0 (value) then
				count_max := 2
				count_min := 2
				name := "hour-numeric-on-2-digits"
				value_max := 24
				value_min := 0
				is_text := False
				is_numeric := True
				type := Hour_numeric_on_2_digits_type
			elseif is_hour12 (value) then
				count_max := 2
				count_min := 1
				name := "hour-12-clock-scale"
				value_max := 12
				value_min := 0
				is_text := False
				is_numeric := True
				type := Hour_12_clock_scale_type
			elseif is_minute (value) then
				count_max := 2
				count_min := 1
				name := "minute-numeric"
				value_max := 59
				value_min := 0
				is_text := False
				is_numeric := True
				type := Minute_numeric_type
			elseif is_minute0 (value) then
				count_max := 2
				count_min := 2
				name := "minute-numeric-on-2-digits"
				value_max := 59
				value_min := 0
				is_text := False
				is_numeric := True
				type := Minute_numeric_on_2_digits_type
			elseif is_second (value) then
				count_max := 2
				count_min := 1
				name := "second-numeric"
				value_max := 59
				value_min := 0
				is_text := False
				is_numeric := True
				type := Second_numeric_type
			elseif is_second0 (value) then
				count_max := 2
				count_min := 2
				name := "second-numeric-on-2-digits"
				value_max := 59
				value_min := 0
				is_text := False
				is_numeric := True
				type := Second_numeric_on_2_digits_type
			elseif is_fractional_second (value) then
				count_max := value.substring (3, value.count).to_integer
				count_min := 1
				name := "fractional-second-numeric"
				is_text := False
				is_numeric := True
				type := Fractional_second_numeric_type
				value_max := -1
				value_min := -1
			elseif is_colon (value) then
				count_max := 1
				count_min := 1
				name := "colon"
				is_text := True
				is_numeric := False
				type := Colon_type
			elseif is_slash (value) then
				count_max := 1
				count_min := 1
				name := "slash"
				is_text := True
				is_numeric := False
				type := Slash_type
			elseif is_minus (value) then
				count_max := 1
				count_min := 1
				name := "minus"
				is_text := True
				is_numeric := False
				type := Minus_type
			elseif is_comma (value) then
				count_max := 1
				count_min := 1
				name := "comma"
				is_text := True
				is_numeric := False
				type := Comma_type
			elseif is_space (value) then
				count_max := 1
				count_min := 1
				name := "space"
				is_text := True
				is_numeric := False
				type := Space_type
			elseif is_dot (value) then
				count_max := 1
				count_min := 1
				name := "dot"
				is_text := True
				is_numeric := False
				type := Dot_type
			elseif is_meridiem (value) then
				count_max := 2
				count_min := 2
				name := "meridiem"
				is_text := True
				is_numeric := False
				type := Meridiem_type
			elseif is_hour12_0 (value) then
				count_max := 2
				count_min := 2
				name := "hour-12-clock-scale-on-2-digits"
				value_max := 12
				value_min := 0
				is_text := False
				is_numeric := True
				type := Hour_12_on_2_digits
			end
		ensure
			value_set: value.is_equal (v)
		end

feature -- Attributes

	value: STRING_32
			-- String code

	count_max: INTEGER
			-- Count max of the real value

	count_min: INTEGER
			-- Count min of the real value

	name: STRING_32
			-- Name of the code

	value_max: INTEGER
			-- Max of the real value

	value_min: INTEGER
			-- Min of the real value

	type: INTEGER
			-- Type number.

feature -- Status report

	is_text: BOOLEAN 
			-- Has the code a string value?

	is_numeric: BOOLEAN;
			-- Has the code a numeric value?

invariant
	text_or_numeric: is_text xor is_numeric

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
end -- class DATE_TIME_CODE


