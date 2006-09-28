indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_NLS_LOCALE


	inherit

		UC_IMPORTED_UTF16_ROUTINES
		SHARED_I18N_NLS_LCID_TOOLS
		SHARED_I18N_NLS_CONSTANTS


	feature -- Default locales

		system_locale: INTEGER is
			-- Encapsulation of GetSystemDefaultLCID
		external
			"C (): int| %"nls_locale.h%""
		alias
			"GetSystemDefaultLCID"
		end

		user_locale: INTEGER is
			-- Encapsulation of GetUserDefaultLCID
		external
			"C (): int| %"nls_locale.h%""
		alias
			"GetUserDefaultLCID"
		end


	feature -- date and time formatting

		short_date_format: STRING_32 is
				--
			do
				Result:= extract_locale_string (system_locale,nls_constants.locale_sshortdate,
												nls_constants.locale_sshortdate_maxlen)
			end

		long_date_format: STRING_32 is
				--
			do
				Result:= extract_locale_string (system_locale,nls_constants.locale_slongdate,
												nls_constants.locale_slongdate_maxlen)
			end


		am_suffix: STRING_32 is
				--
			do
				Result := extract_locale_string (system_locale, nls_constants.locale_s1159,
												nls_constants.locale_s1159_maxlen)
			end

		pm_suffix: STRING_32 is
				--
			do
				Result := extract_locale_string (system_locale, nls_constants.locale_s2359,
												nls_constants.locale_s2359_maxlen)
			end

		day_names: ARRAY[STRING_32] is
				--
			do
				Result := <<
								extract_locale_string (system_locale, nls_constants.locale_sdayname1,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname2,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname3,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname4,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname5,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname6,
												nls_constants.locale_sdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sdayname7,
												nls_constants.locale_sdayname_maxlen)
							>>
			end

		abbreviated_day_names: ARRAY[STRING_32] is
				--
			do
				Result := <<
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname1,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname2,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname3,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname4,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname5,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname6,
												nls_constants.locale_sabbrevdayname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevdayname7,
												nls_constants.locale_sabbrevdayname_maxlen)
							>>
			end

		month_names: ARRAY[STRING_32] is
				--
			do
				Result := <<
								extract_locale_string (system_locale, nls_constants.locale_smonthname1,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname2,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname3,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname4,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname5,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname6,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname7,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname8,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname9,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname10,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname11,
												nls_constants.locale_smonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_smonthname12,
												nls_constants.locale_smonthname_maxlen)
							>>
			end


	abbreviated_month_names: ARRAY[STRING_32] is
				--
			do
				Result := <<
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname1,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname2,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname3,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname4,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname5,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname6,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname7,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname8,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname9,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname10,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname11,
												nls_constants.locale_sabbrevmonthname_maxlen),
								extract_locale_string (system_locale, nls_constants.locale_sabbrevmonthname12,
												nls_constants.locale_sabbrevmonthname_maxlen)
							>>
			end


	feature -- number formatting

		value_decimal_separator: STRING_32
		value_numbers_after_decimnal_separator: STRING_32



	feature  -- internal LCID handling

		is_valid_locale(lcid:INTEGER; flags:INTEGER):BOOLEAN is
				-- encapsulation of IsValidLocaleName
		external
			"C (int, int): int| %"nls_locale.h%""
		alias
			"IsValidLocale"
		end

		is_supported_locale(lcid:INTEGER):BOOLEAN is
				-- Is the given LCID supported _and_ installed?
			do
				-- Possible flags, from winnls.h :
				--#define LCID_INSTALLED            0x00000001  // installed locale ids
				--#define LCID_SUPPORTED            0x00000002  // supported locale ids
				Result := is_valid_locale(lcid, 2)
			end

	feature {NONE} -- wrappers for GetLocaleInfo

		extract_locale_string(lcid: INTEGER; lc_ctype: INTEGER; bufferlen: INTEGER): STRING_32 is
				--
			local
				pointer: POINTER
			do
				pointer := c_extract_locale_string(lcid, lc_ctype, bufferlen)
				Result := pointer_to_string (pointer)
				pointer.memory_free
			end


		c_extract_locale_string(lcid: INTEGER; lc_ctype: INTEGER; bufferlen: INTEGER ): POINTER is
				--
			external
				"C(int, int, int): TCHAR * | %"nls_locale.h%""
			alias
				"extract_locale_string"
			end

		c_extract_locale_integer(lcid: INTEGER; lc_ctype: INTEGER): INTEGER is
				--
			external
				"C (int, int): int| %"nls_locale.h%""
			alias
				"extract_locale_int"
			end


	feature {NONE} -- utf16-LE (aka "wide string") handling

		pointer_to_string(ptr: POINTER): STRING_32 is
				-- takes a pointer to a utf16-LE string (the LE is important!)
				-- and returns the corresponding STRING_32 by means of Horrible Things
			require
				--pointer is not null, I suppose
				ptr_not_null: ptr /= default_pointer
			local
				managed_ptr: MANAGED_POINTER
				length: INTEGER
				counter: INTEGER
				a_least, a_most: INTEGER --high byte and low byte of current character
				a_low_most, a_low_least: INTEGER --high byte and low byte of next character
			do
				length := c_wcslen (ptr)
				create managed_ptr.share_from_pointer (ptr, length*2) --utf16: each character is 2 bytes.
				create Result.make_empty

				-- This code is based on append_utf16 in UC_STRING - this version is
				-- needed because strings returned by the Windows  NLS api are UT16-LE
				-- and therefore do not have a BOM, which append_utf16 requires
				-- (it will in fact cause an exception if the BOM is absent. is_valid_utf16 should check for it.)
				-- Also I don't like the idea of reading bytes into a STRING_8, reading the
				-- STRING_8 into a UC_STRING with append_utf16 and then turning the UC_STRING
				-- into a STRING_32.  Talk about efficiency...

				from
					counter := 0
					-- counter counts bytes not characters! 0-based as it is the offset from the pointer.
				until
					counter >= (length*2)
				loop
					a_least := managed_ptr.read_natural_8 (counter)
					a_most := managed_ptr.read_natural_8 (counter+1)
					if utf16.is_surrogate (a_most) then
						-- this is a surrogate, i.e a code point represented with 4 bytes
						-- we read the next character and glue the two together
						check utf16.is_high_surrogate (a_most) end
						check counter+2 < (length*2) end
						counter := counter + 2
						a_least := managed_ptr.read_natural_8 (counter)
						a_most := managed_ptr.read_natural_8 (counter+1)
						check utf16.is_low_surrogate (a_low_most) end
						Result.append_character (utf16.surrogate_from_bytes (a_most, a_least, a_low_most, a_low_least).to_character_32)
					else
						-- not a surrogate
						Result.append_character ((a_most*256 + a_least).to_character_32)
					end
					counter := counter + 2
				end

			end



		c_wcslen (ptr: POINTER): INTEGER is
		external
			"C (void *): EIF_INTEGER| %"nls_locale.h%""
		alias
			"wcslen"
		end




end
