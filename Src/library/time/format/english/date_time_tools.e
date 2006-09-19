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
		do
			Result := "English"
		end

	days_text: ARRAY [STRING_32] is
		local
			t_s: STRING_32
		once
			create Result.make (1,7)
			create t_s.make_empty
			t_s.make_from_string ("SUN")
			Result.put (t_s.twin,1)
			t_s.make_from_string ("MON")
			Result.put (t_s.twin,2)
			t_s.make_from_string ("TUE")
			Result.put (t_s.twin,3)
			t_s.make_from_string ("WED")
			Result.put (t_s.twin,4)
			t_s.make_from_string ("THU")
			Result.put (t_s.twin,5)
			t_s.make_from_string ("FRI")
			Result.put (t_s.twin,6)
			t_s.make_from_string ("SAT")
			Result.put (t_s.twin,7)
			Result.compare_objects
		end

	months_text: ARRAY [STRING_32] is
		local
			t_s: STRING_32
		once
			create Result.make (1,12)
			create t_s.make_empty
			t_s.make_from_string ("JAN")
			Result.put (t_s.twin,1)
			t_s.make_from_string ("FEB")
			Result.put (t_s.twin,2)
			t_s.make_from_string ("MAR")
			Result.put (t_s.twin,3)
			t_s.make_from_string ("APR")
			Result.put (t_s.twin,4)
			t_s.make_from_string ("MAY")
			Result.put (t_s.twin,5)
			t_s.make_from_string ("JUN")
			Result.put (t_s.twin,6)
			t_s.make_from_string ("JUL")
			Result.put (t_s.twin,7)
			t_s.make_from_string ("AUG")
			Result.put (t_s.twin,8)
			t_s.make_from_string ("SEP")
			Result.put (t_s.twin,9)
			t_s.make_from_string ("OCT")
			Result.put (t_s.twin,10)
			t_s.make_from_string ("NOV")
			Result.put (t_s.twin,11)
			t_s.make_from_string ("DEC")
			Result.put (t_s.twin,12)
-- 			Result := <<
-- 				"JAN",
-- 				"FEB",
-- 				"MAR",
-- 				"APR",
-- 				"MAY",
-- 				"JUN",
-- 				"JUL",
-- 				"AUG",
-- 				"SEP",
-- 				"OCT",
-- 				"NOV",
-- 				"DEC"
-- 			>>
			Result.compare_objects
		end

	long_days_text: ARRAY [STRING_32] is
		local
			t_s : STRING_32
		once
			create Result.make (1,7)
			create t_s.make_empty
			t_s.make_from_string ("Sunday")
			Result.put (t_s.twin,1)
			t_s.make_from_string ("Monday")
			Result.put (t_s.twin,2)
			t_s.make_from_string ("Tuesday")
			Result.put (t_s.twin,3)
			t_s.make_from_string ("Wednesday")
			Result.put (t_s.twin,4)
			t_s.make_from_string ("Thursday")
			Result.put (t_s.twin,5)
			t_s.make_from_string ("Friday")
			Result.put (t_s.twin,6)
			t_s.make_from_string ("Saturday")
			Result.put (t_s.twin,7)
			Result.compare_objects
-- 			Result := <<
-- 				"SUNDAY",
-- 				"MONDAY",
-- 				"TUESDAY",
-- 				"WEDNESDAY",
-- 				"THURSDAY",
-- 				"FRIDAY",
-- 				"SATURDAY"
-- 				
-- 			>>
			Result.compare_objects
		end

	long_months_text: ARRAY [STRING_32] is
		once
-- 			Result := <<
-- 				"JANUARY",
-- 				"FEBRUARY",
-- 				"MARCH",
-- 				"APRIL",
-- 				"MAY",
-- 				"JUNE",
-- 				"JULY",
-- 				"AUGUST",
-- 				"SEPTEMBER",
-- 				"OCTOBER",
-- 				"NOVEMBER",
-- 				"DECEMBER"
-- 				>>
			Result.compare_objects
		end

	date_default_format_string: STRING_32 is
		do
			Result := "[0]mm/[0]dd/yyyy"
		end

	time_default_format_string: STRING_32 is
		do	
			Result := "hh12:[0]mi:[0]ss.ff3 AM"
		end

	default_format_string: STRING_32 is
		do
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


