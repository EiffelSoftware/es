indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOCALE_TEST

	inherit
		SHARED_I18N_PLURAL_TOOLS
create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			l : TIME
			t: I18N_CHARACTER_BASED_DICTIONARY
			qqw: I18N_FORMAT_STRING_PARSER
			sfh: I18N_BINARY_SEARCH_ARRAY_DICTIONAY
		do
			io.put_string ("%N###############%N")
			io.put_string ("%NTest:%N")
			interactive
--			test_all_locales
			io.put_string ("%N###############%N")
		end


feature --Tests

	test_all_locales is
			-- test for all locales
		local
			l_list: LINEAR[I18N_LOCALE_ID]
			t : I18N_SYSTEM_LOCALES
		do
			create t
			l_list := t.available_locales
			from
				l_list.start
			until
				l_list.after
			loop
				io.put_string ("Test of locale: "+t.get_locale_info (l_list.item).id.name+"%N")
				test_day_months_names (t.get_locale_info (l_list.item))
				test_date_time_formatter ("local_date_time: &c, day: &A%N", t.get_locale_info (l_list.item))
				test_currency_info (t.get_locale_info (l_list.item))
				test_currency_formatter (9.234, t.get_locale_info (l_list.item))
				test_value_info (t.get_locale_info (l_list.item))
				test_value_formatter (9.234, t.get_locale_info (l_list.item))
				l_list.forth
			end
		end



	interactive is
			-- Test with interaction
		local
			t : I18N_SYSTEM_LOCALES
			l : I18N_LOCALE_ID
		do
			from
				io.put_string ("Press ENTER")
				io.read_line
			until
				io.last_string.is_equal("q")
			loop
				io.put_string ("usage:%N%
								% q: quit%N%
								% l: list of locales%N%
								% locale name to test it%N%
								%type your choice: ")
				io.read_line
				io.new_line
				create l.make_from_string (io.last_string)
				if io.last_string.is_equal ("l") then
					list_locales
				elseif not io.last_string.is_equal ("q") then
					create t
					if t.has_locale (l) then
						test_day_months_names (t.get_locale_info (l))
						test_date_time_formatter ("local_date_time: &c, day: &A%N", t.get_locale_info (l))
						test_currency_info (t.get_locale_info (l))
						test_currency_formatter (9.234, t.get_locale_info (l))
						test_value_info (t.get_locale_info (l))
						test_value_formatter (9.234, t.get_locale_info (l))
					else
						io.put_string ("%NNot available%N")
					end
				end
			end
			io.put_string ("Bye :-)")
		end


	list_locales is
			--
		local
			l: I18N_SYSTEM_LOCALES
			t_l : LINEAR[I18N_LOCALE_ID]
		do
			create l
			t_l := l.available_locales
			from
				t_l.start
			until
				t_l.after
			loop
				io.put_string (t_l.item.name+"%N")
				t_l.forth
			end
		end

	test_currency_formatter (a_value: DOUBLE;locale: I18N_LOCALE_INFO) is
			-- test the currency formatter with `a_value'
		local
			currency_formatter: I18N_CURRENCY_FORMATTER
		do
			io.put_string ("CURRENCY FORMATTER TEST%N")
			create currency_formatter.make (locale)
			io.put_string ("    Original value: "+a_value.out+"%N")
			io.put_string ("    Formatted: "+currency_formatter.format_currency (a_value))
			io.new_line
		end

	test_value_formatter (a_value: DOUBLE;locale: I18N_LOCALE_INFO) is
			-- test the currency formatter with `a_value'
		local
			value_formatter: I18N_VALUE_FORMATTER
		do
			io.put_string ("VALUE FORMATTER TEST%N")
			create value_formatter.make (locale)
			io.put_string ("    Original value: "+a_value.out+"%N")
			io.put_string ("    Formatted: "+value_formatter.format_real_64 (a_value))
			io.new_line
		end

	test_date_time_formatter (a_format_string: STRING_32;locale: I18N_LOCALE_INFO) is
			-- test date/time formatter with the format string  `a_format_string'
			-- and the current time
		local
			time: TIME
			date: DATE
			ll: I18N_FORMAT_STRING
		do
			io.put_string ("DATE TIME FORMATTER TEST%N")
			create time.make_now
			create date.make_now
			create ll.make (a_format_string,locale)
			io.put_string ("    Original string: "+a_format_string+"%N")
			io.put_string ("    formatted string: "+ll.filled (date,time,locale)+"%N")
		end


	test_day_months_names (locale : I18N_LOCALE_INFO) is
			-- print to `io' all day/month names
		do
			io.put_string ("DAY/MONTH NAMES TEST%N")
			io.put_string ("    Abbreviated day names:%N")
			locale.abbreviated_day_names.do_all (agent print_string (?))
			io.put_string ("    Full day names:%N")
			locale.day_names.do_all (agent print_string (?))
			io.put_string ("    Abbreviated month names:%N")
			locale.abbreviated_month_names.do_all (agent print_string (?))
			io.put_string ("    Full month names:%N")
			locale.month_names.do_all (agent print_string (?))
		end

	test_value_info  (locale : I18N_LOCALE_INFO) is
			-- print to `io' all value related fields
		do
			io.put_string ("VALUE INFO TEST%N")
			io.put_string ("    value dec separator: '"+locale.value_decimal_separator+"'%N")
			io.put_string ("    value numb after dec. sep: '"+locale.value_numbers_after_decimal_separator.out+"'%N")
			io.put_string ("    value gr. sep.: '"+locale.value_group_separator+"'%N")
			io.put_string ("    value nr list sep.: '"+locale.value_number_list_separator+"'%N")
			io.put_string ("    Grouping: ")
			locale.value_grouping.do_all (agent io.put_integer (?))
			io.put_new_line
		end

	test_currency_info (locale : I18N_LOCALE_INFO) is
			-- print to `io' all currency related fields
		do
			io.put_string ("CURRENCY INFO TEST%N")
			io.put_string("    cur dec sep: '"+locale.currency_decimal_separator+"'%N")
			io.put_string("    cur gr.sep: '"+locale.currency_group_separator+"'%N")
			io.put_string ("    Grouping: ")
			locale.currency_grouping.do_all (agent io.put_integer (?))
			io.put_new_line
			io.put_string("    cur nr list sep: '"+locale.currency_number_list_separator+"'%N")
			io.put_string("    cur num after dec: '"+locale.currency_numbers_after_decimal_separator.out+"'%N")
			io.put_string("    currency symbol:'"+locale.currency_symbol+"'%N")
			io.put_string ("    symbol location: "+locale.currency_symbol_location.out+"%N")

			io.put_string("    INT cur dec sep: '"+locale.currency_international_decimal_separator+"'%N")
			io.put_string("    INT cur gr.sep: '"+locale.currency_international_group_separator+"'%N")
			io.put_string ("    INT Grouping: ")
			locale.currency_international_grouping.do_all (agent io.put_integer (?))
			io.put_new_line
			io.put_string("    INT cur nr list sep: '"+locale.currency_international_number_list_separator+"'%N")
			io.put_string("    INT cur num after dec: '"+locale.currency_international_numbers_after_decimal_separator.out+"'%N")
			io.put_string("    INT currency symbol:'"+locale.currency_international_symbol+"'%N")
			io.put_string ("    INT symbol location: "+locale.currency_international_symbol_location.out+"%N")
		end



feature {NONE} -- Help function

	print_string (a_string: STRING_32) is
			--
		do
			io.put_string ("  "+a_string+"%N")
		end

end
