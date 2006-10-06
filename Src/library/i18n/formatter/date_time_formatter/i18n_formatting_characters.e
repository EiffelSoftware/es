class I18N_FORMATTING_CHARACTERS

feature -- Constants

day_of_month: CHARACTER is	'e'
	--Day of the month as digits without leading zeros for single digit days.
day_of_month_padded: CHARACTER is	'd'
	--  The day of the month as a decimal number (range 01 to 31)
abbreviated_day_name: CHARACTER is	'a'
	--  Abbreviated day of the week
day_name: CHARACTER is	'A'
	--  The full weekday name according to the current locale.
day_of_year: CHARACTER is	'j'
	--  The day of the year as a decimal number (range 001 to 366).
day_of_week: CHARACTER is	'u'
	-- The day of the week as a decimal, range 1 to 7, Monday being 1.
day_of_week_0: CHARACTER is 'w'
	-- The day of the week as a decimal, range 0 to 6, Sunday being 0.
month : CHARACTER is '1'
	--  Month as digits without leading zeros for single digit months.
month_padded: CHARACTER is	'm'
	--  The month as a decimal number (range 01 to 12).
abbreviated_month_name1: CHARACTER is	'b'
	-- Abbreviated month name
abbreviated_month_name2: CHARACTER is	'h'
	-- Abbreviated month name
month_name: CHARACTER is 'B'
	--  Month full name
century_number: CHARACTER is 'C'
	--  The century number (year/100) as a 2-digit integer
week_number_iso: CHARACTER is 'V'
	--  The ISO 8601:1988 week number of the current year as a decimal number, range 01 to 53, where week 1 is the first
week_number_sunday_as_first: CHARACTER is 'U'
	--  The week number of the current year as a decimal number, range 00 to 53, starting with the first Sunday as the first
week_number_monday_as_first: CHARACTER is	'W'
	--  The week number of the current year as a decimal number, range 00 to 53, starting with the first Monday as the first day of week 01
century_number_iso: CHARACTER is	'G'
	--  The ISO 8601 year with century as a decimal number.
century_number_iso_2: CHARACTER is	'g'
	--  The ISO 8601 year with century as a decimal number, but without century, i.e., with a 2-digit year (00-99).
year_1 : CHARACTER is '?'
	--  Year represented only by the last digit.
year_2: CHARACTER is	'y'
	--  The year as a decimal number without a century (range 00 to 99).
year_4: CHARACTER is	'Y'
	--  Year represented by full four or five digits, depending on the calendar used.
era : CHARACTER is '9'
	--  Period/era string as specified by the CAL_SERASTRING value.
hour_12_padded: CHARACTER is	'l'
	--  Hours without leading zeros for single-digit hours (12-hour clock).
hour_12: CHARACTER is	'I'
	--  Hours with leading zeros for single-digit hours (12-hour clock).
hour_24: CHARACTER is	'k'
	--  Hours without leading zeros for single-digit hours (24-hour clock).
hour_24_padded: CHARACTER is	'H'
	--  Hours with leading zeros for single-digit hours (24-hour clock).
minutes : CHARACTER is '2'
	--  Minutes without leading zeros for single-digit minutes.
minutes_padded: CHARACTER is	'M'
	--  The minute as a decimal number (range 00 to 59)
seconds: CHARACTER is	'S'
	--  Seconds without leading zeros for single-digit seconds.
seconds_padded : CHARACTER is '3'
	--  The second as a decimal number (range 00 to 60).
second_fraction_padded : CHARACTER is '4'
	--  First digit of fractional second
second_fraction : CHARACTER is '5'
	-- First seven digits of fractional second, if = 0 empty string
am_pm_1 : CHARACTER is '6'
	--  One-character time marker string. (Am/pm -> a/p)
am_pm_lowercase: CHARACTER is	'p'
	--  Multi-character time marker string  Lowercase
am_pm_uppercase: CHARACTER is	'P'
	--  Multi-character time marker string     Uppercase
local_date_time: CHARACTER is	'c'
	--  The preferred date and time representation for the current locale.
usa_date: CHARACTER is	'D'
	--  Equivalent to %m/%d/%y. (Yecch  for Americans only.
iso_date: CHARACTER	is	'F'
	--  Equivalent to %Y-%m-%d (the ISO 8601 date format).
--iso_date_TIME ??
	--  ISO 8061 date time format: "yyyy-MM-ddTHH:mm:ss"
am_pm_time: CHARACTER is	'r'
	--  The time in a.m. or p.m. notation. In the POSIX locale this is equivalent to `%I:%M:%S %p'
short_time_24h: CHARACTER is	'R'
	--  The time in 24-hour notation (%H:%M)
time_24h: CHARACTER is	'T'
	--  The time in 24-hour notation (%H:%M:%S).
new_line: CHARACTER is	'n'
	--  New line character
tab: CHARACTER is	't'
	--  Insert a Tab
local_date: CHARACTER is	'x'
	--  The preferred date representation for the current locale without the time.
locale_time: CHARACTER is	'X'
	--  The preferred time representation for the current locale without the date.
time_zone_offset: CHARACTER is	'z'
	--  Time zone as hour offeset from GMT (Required to emit RFC 822-conformant dates (using "%a, %d %b %Y %H:%M:%S %z"))
time_zone_name: CHARACTER is	'Z'
	--  The time zone or name or abbreviation.

feature -- Modified Characters with %E

modifier_character_1: CHARACTER is	'E'

modified_date_time: CHARACTER is	'c'
	-- Replaced by the locale's alternative appropriate date and time representation.
modified_base_year_name: CHARACTER is	'C'
	-- Replaced by the name of the base year (period) in the locale's alternative representation.
modified_date: CHARACTER is	'x'
	-- Replaced by the locale's alternative date representation.
modified_time: CHARACTER is	'X'
	-- Replaced by the locale's alternative time representation.
modified_base_year_offset: CHARACTER is	'y'
	-- Replaced by the offset from %EC (year only) in the locale's alternative representation. 
modified_year: CHARACTER is	'Y'
	-- Replaced by the full alternative year representation.

feature -- Modified Characters with %O

modifier_character_2: CHARACTER is	'O'

modified_day_of_month_0_padded: CHARACTER is	'd'
	-- Replaced by the day of the month, using the locale's alternative numeric symbols, filled as needed with leading zeros if there is any alternative symbol for zero; otherwise, with leading spaces.
modified_day_of_month_space_padded : CHARACTER is	'e'
	-- Replaced by the day of the month, using the locale's alternative numeric symbols, filled as needed with leading spaces.
modified_time_24h: CHARACTER is	'H'
	-- Replaced by the hour (24-hour clock) using the locale's alternative numeric symbols.
modified_time_12h: CHARACTER is	'I'
	-- Replaced by the hour (12-hour clock) using the locale's alternative numeric symbols.
modified_month: CHARACTER is	'm'
	-- Replaced by the month using the locale's alternative numeric symbols.
modified_minutes: CHARACTER is	'M'
	-- Replaced by the minutes using the locale's alternative numeric symbols.
modified_seconds: CHARACTER	is	'S'
	-- Replaced by the seconds using the locale's alternative numeric symbols.
modified_weekday: CHARACTER is	'u'
	-- Replaced by the weekday as a number in the locale's alternative representation (Monday=1).
modified_week_number: CHARACTER is	'U'
	-- Replaced by the week number of the year (Sunday as the first day of the week, rules corresponding to %U ) using the locale's alternative numeric symbols. 
modified_week_number_monday_as_first_1: CHARACTER is	'V'
	-- Replaced by the week number of the year (Monday as the first day of the week, rules corresponding to %V ) using the locale's alternative numeric symbols. 
modified_week_number_sunday_as_first: CHARACTER is	'w'
	-- Replaced by the number of the weekday (Sunday=0) using the locale's alternative numeric symbols.
modified_week_number_monday_as_first_2: CHARACTER is	'W'
	-- Replaced by the week number of the year (Monday as the first day of the week) using the locale's alternative numeric symbols.
modified_era: CHARACTER is	'y'
	-- Replaced by the year (offset from %C ) using the locale's alternative numeric symbols. 

time_separator : CHARACTER is '8'
	--  Time separator
hour_separator : CHARACTER is '9'
	--  Hour separator
escape_character: CHARACTER is	'&'
	--   escape character (to avoid character interpretation)
end
