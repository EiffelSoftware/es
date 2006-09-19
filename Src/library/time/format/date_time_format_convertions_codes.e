indexing
	description: "Format conversion codes used by the TIME library"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class DATE_TIME_FORMAT_CONVERTIONS_CODES

feature -- Day/Months names

	day_name : STRING_32 is
			-- Full day name e.g "Monday", "Tuesday"
		do
			Result := "D"
		end

	abbreviated_day_name : STRING_32 is
			-- 3 letters e.g "Mon", "Tue"
		do
			Result := "ddd"
		end

	month_name : STRING_32 is
			-- Full month name e.g "December", "January"
		do
			Result := "M"
		end

	abbreviated_month_name : STRING_32 is
		-- 3  letters e.g "Dec", "Jan"
		do
			Result := "mmm"
		end

feature -- Hours

	hour_24 : STRING_32 is
		-- 24 hour clock scale by default
		do
			Result := "hh"
		end

	hour_24_padded : STRING_32 is
		-- hour padded with '0' to 2 figures
		do
			Result := "[0]hh"
		end

	hour_12 : STRING_32 is
		-- 12 hour clock scale
		do
			Result := "hh12"
		end

	hour_12_padded : STRING_32 is
		-- 12 hour clock scale
		do
			Result := "[0]hh12"
		end

feature -- Minutes

	numeric_minute : STRING_32 is
		do
			Result := "mi"
		end

	numeric_minute_padded : STRING_32 is 
		-- minute padded with '0' to 2 digits
		do
			Result := "[0]mi"
		end

feature -- Seconds

	numeric_seconds : STRING_32 is
		do
			Result := "ss"
		end

	numeric_seconds_padded : STRING_32 is
		-- seconds padded with '0' to 2 digits	
		do
			Result := "[0]ss"
		end

	seconds_fractional : STRING_32 is
		do
			Result := "ff"
		end

feature -- Numeric Day

	day_numeric  : STRING_32 is
		do
			Result :=  "dd"
		end

	day_numeric_padded : STRING_32 is
			-- day number padded with '0' to 2 digits
		do
			Result := "[0]dd"
		end

feature -- Numeric Month

	month_numeric : STRING_32 is
		do
			Result := "mm"
		end

	month_numeric_padded : STRING_32 is
		--  month number padded with 'o' to 2 digits
		do
			Result := "[0]mm"
		end

feature -- Numeric Year

	long_year : STRING_32 is
			-- year - numeric (4 digits)
		do
			Result := "yyyy"
		end

	short_year : STRING_32 is
		-- year - numeric (4 digits)
		do
			Result := "yy"
		end

end -- class DATE_TIME_FORMAT_CONVERTIONS_CODES

