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
		once
			Result := "DD"
		ensure
			Definition: Result.is_equal("DD")
		end

	abbreviated_day_name : STRING_32 is
			-- 3 letters e.g "Mon", "Tue"
		once
			Result := "ddd"
		ensure
			Definition: Result.is_equal("ddd")
		end

	month_name : STRING_32 is
			-- Full month name e.g "December", "January"
		once
			Result := "MM"
		ensure
			Definition: Result.is_equal("MM")
		end

	abbreviated_month_name : STRING_32 is
		-- 3  letters e.g "Dec", "Jan"
		once
			Result := "mmm"
		ensure
			Definition: Result.is_equal("mmm")
		end

feature -- Hours

	hour_24 : STRING_32 is
		-- 24 hour clock scale by default
		once
			Result := "hh"
		ensure
			Definition: Result.is_equal("hh")
		end

	hour_24_padded : STRING_32 is
		-- hour padded with '0' to 2 figures
		once
			Result := "[0]hh"
		ensure
			Definition: Result.is_equal("[0]hh")
		end

	hour_12 : STRING_32 is
		-- 12 hour clock scale
		once
			Result := "hh12"
		ensure
			Definition: Result.is_equal("hh12")
		end

	hour_12_padded : STRING_32 is
		-- 12 hour clock scale
		once
			Result := "[0]hh12"
		ensure
			Definition: Result.is_equal("[0]hh12")
		end

feature -- Minutes

	numeric_minute : STRING_32 is
		once
			Result := "mi"
		ensure
			Definition: Result.is_equal("mi")
		end

	numeric_minute_padded : STRING_32 is 
		-- minute padded with '0' to 2 digits
		once
			Result := "[0]mi"
		ensure
			Definition: Result.is_equal("[0]mi")
		end

feature -- Seconds

	numeric_seconds : STRING_32 is
		once
			Result := "ss"
		ensure
			Definition: Result.is_equal("ss")
		end

	numeric_seconds_padded : STRING_32 is
		-- seconds padded with '0' to 2 digits	
		once
			Result := "[0]ss"
		ensure
			Definition: Result.is_equal("[0]ss")
		end

	seconds_fractional : STRING_32 is
		once
			Result := "ff"
		ensure
			Definition: Result.is_equal("ff")
		end
	
	seconds_fractional_padded: STRING_32 is
		once
			Result := "FF"
		ensure
			Definition: Result.is_equal ("FF")
		end

feature -- Numeric Day

	day_numeric  : STRING_32 is
		once
			Result :=  "dd"
		ensure
			Definition: Result.is_equal("dd")
		end

	day_numeric_padded : STRING_32 is
			-- day number padded with '0' to 2 digits
		once
			Result := "[0]dd"
		ensure
			Definition: Result.is_equal("[0]dd")
		end

feature -- Numeric Month

	month_numeric : STRING_32 is
		once
			Result := "mm"
		ensure
			Definition: Result.is_equal("mm")
		end

	month_numeric_padded : STRING_32 is
		--  month number padded with 'o' to 2 digits
		once
			Result := "[0]mm"
		ensure
			Definition: Result.is_equal("[0]mm")
		end

feature -- Numeric Year

	long_year : STRING_32 is
			-- year - numeric (4 digits)
		once
			Result := "yyyy"
		ensure
			Definition: Result.is_equal("yyyy")
		end

	short_year : STRING_32 is
		-- year - numeric (4 digits)
		once
			Result := "yy"
		ensure
			Definition: Result.is_equal("yy")
		end

feature -- Meridiem

	am_suffix : STRING_32 is
			-- am suffix
		once
			Result := "AM"
		ensure
			Definition: Result.is_equal("AM")
		end
	
	pm_suffix: STRING_32 is
			-- pm suffix
		once
			Result := "PM"
		ensure
			Definition: Result.is_equal("PM")
		end

end -- class DATE_TIME_FORMAT_CONVERTIONS_CODES