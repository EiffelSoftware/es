indexing
	description: "English settings"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class 
	DATE_TIME_TOOLS	

inherit 	
	DATE_TIME_LANGUAGE_CONSTANTS

feature 

	name: STRING_32 is
		once
			Result := "English"
		end

	days_text: ARRAY [STRING_32] is
		once
			Result := <<
				("SUN").to_string_32,
				("MON").to_string_32,
				("TUE").to_string_32,
				("WED").to_string_32,
				("THU").to_string_32,
				("FRI").to_string_32,
				("SAT").to_string_32
				>>
			Result.compare_objects
		end

	months_text: ARRAY [STRING_32] is
		once
			Result := <<
				("JAN").to_string_32,
				("FEB").to_string_32,
				("MAR").to_string_32,
				("APR").to_string_32,
				("MAY").to_string_32,
				("JUN").to_string_32,
				("JUL").to_string_32,
				("AUG").to_string_32,
				("SEP").to_string_32,
				("OCT").to_string_32,
				("NOV").to_string_32,
				("DEC").to_string_32
			>>
			Result.compare_objects
		end

	long_days_text: ARRAY [STRING_32] is
		once
			Result := <<
				("SUNDAY").to_string_32,
				("MONDAY").to_string_32,
				("TUESDAY").to_string_32,
				("WEDNESDAY").to_string_32,
				("THURSDAY").to_string_32,
				("FRIDAY").to_string_32,
				("SATURDAY").to_string_32
			>>
			Result.compare_objects
		end

	long_months_text: ARRAY [STRING_32] is
		once
			Result := <<
				("JANUARY").to_string_32,
				("FEBRUARY").to_string_32,
				("MARCH").to_string_32,
				("APRIL").to_string_32,
				("MAY").to_string_32,
				("JUNE").to_string_32,
				("JULY").to_string_32,
				("AUGUST").to_string_32,
				("SEPTEMBER").to_string_32,
				("OCTOBER").to_string_32,
				("NOVEMBER").to_string_32,
				("DECEMBER").to_string_32
				>>
			Result.compare_objects
		end

	date_default_format_string: STRING_32 is
		once
			Result := "[0]mm/[0]dd/yyyy"
		end

	time_default_format_string: STRING_32 is
		once	
			Result := "hh12:[0]mi:[0]ss.ff3 AM"
		end

	default_format_string: STRING_32 is
		once
			Result := "[0]mm/[0]dd/yyyy hh12:[0]mi:[0]ss.ff3 AM";
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




end -- class DATE_TIME_TOOLS 


