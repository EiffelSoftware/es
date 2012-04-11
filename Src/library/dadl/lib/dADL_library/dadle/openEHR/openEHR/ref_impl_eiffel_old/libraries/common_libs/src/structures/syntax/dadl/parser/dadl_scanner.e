indexing
	component:   "openEHR Archetype Project"
	description: "Scanner for dADL syntax items"
	keywords:    "ADL, dADL"
	
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.biz>"
	copyright:   "Copyright (c) 2004 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/libraries/common_libs/src/structures/syntax/dadl/parser/dadl_scanner.l $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DADL_SCANNER

inherit
	YY_COMPRESSED_SCANNER_SKELETON
		rename
			make as make_compressed_scanner_skeleton,
			reset as reset_compressed_scanner_skeleton,
			output as print_out
		end

	DADL_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		end

	KL_IMPORTED_INTEGER_ROUTINES
	KL_IMPORTED_STRING_ROUTINES
	KL_SHARED_PLATFORM
	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

create
	make

feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= IN_CADL_BLOCK)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 40 then
if yy_act <= 20 then
if yy_act <= 10 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 64 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 64")
end
-- Ignore separators
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 65 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 65")
end
in_lineno := in_lineno + text_count
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 70 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 70")
end
-- Ignore comments
end
else
if yy_act = 4 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 71 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 71")
end
in_lineno := in_lineno + 1
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 75 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 75")
end
 -- 
	last_token := V_PATH
	last_string_value := text

end
end
else
if yy_act <= 8 then
if yy_act <= 7 then
if yy_act = 6 then
	yy_position := yy_position + 1
--|#line 82 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 82")
end
last_token := Minus_code
else
	yy_position := yy_position + 1
--|#line 83 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 83")
end
last_token := Plus_code
end
else
	yy_position := yy_position + 1
--|#line 84 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 84")
end
last_token := Star_code
end
else
if yy_act = 9 then
	yy_position := yy_position + 1
--|#line 85 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 85")
end
last_token := Slash_code
else
	yy_position := yy_position + 1
--|#line 86 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 86")
end
last_token := Caret_code
end
end
end
else
if yy_act <= 15 then
if yy_act <= 13 then
if yy_act <= 12 then
if yy_act = 11 then
	yy_position := yy_position + 1
--|#line 87 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 87")
end
last_token := Dot_code
else
	yy_position := yy_position + 1
--|#line 88 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 88")
end
last_token := Semicolon_code
end
else
	yy_position := yy_position + 1
--|#line 89 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 89")
end
last_token := Comma_code
end
else
if yy_act = 14 then
	yy_position := yy_position + 1
--|#line 90 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 90")
end
last_token := Colon_code
else
	yy_position := yy_position + 1
--|#line 91 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 91")
end
last_token := Exclamation_code
end
end
else
if yy_act <= 18 then
if yy_act <= 17 then
if yy_act = 16 then
	yy_position := yy_position + 1
--|#line 92 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 92")
end
last_token := Left_parenthesis_code
else
	yy_position := yy_position + 1
--|#line 93 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 93")
end
last_token := Right_parenthesis_code
end
else
	yy_position := yy_position + 1
--|#line 94 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 94")
end
last_token := Dollar_code
end
else
if yy_act = 19 then
	yy_position := yy_position + 2
--|#line 95 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 95")
end
last_token := SYM_DT_UNKNOWN
else
	yy_position := yy_position + 1
--|#line 96 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 96")
end
last_token := Question_mark_code
end
end
end
end
else
if yy_act <= 30 then
if yy_act <= 25 then
if yy_act <= 23 then
if yy_act <= 22 then
if yy_act = 21 then
	yy_position := yy_position + 1
--|#line 98 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 98")
end

			if in_interval then
				in_interval := False
			elseif start_block_received then
				in_interval := True
				start_block_received := False
			end
			last_token := SYM_INTERVAL_DELIM
		
else
	yy_position := yy_position + 1
--|#line 108 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 108")
end
last_token := Left_bracket_code
end
else
	yy_position := yy_position + 1
--|#line 109 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 109")
end
last_token := Right_bracket_code
end
else
if yy_act = 24 then
	yy_position := yy_position + 1
--|#line 111 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 111")
end
last_token := SYM_EQ
else
	yy_position := yy_position + 2
--|#line 113 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 113")
end
last_token := SYM_GE
end
end
else
if yy_act <= 28 then
if yy_act <= 27 then
if yy_act = 26 then
	yy_position := yy_position + 2
--|#line 114 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 114")
end
last_token := SYM_LE
else
	yy_position := yy_position + 1
--|#line 116 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 116")
end

			if in_interval then
				last_token := SYM_LT
				start_block_received := False
			else
				last_token := SYM_START_DBLOCK
				start_block_received := True
			end
		
end
else
	yy_position := yy_position + 1
--|#line 126 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 126")
end

			if in_interval then
				last_token := SYM_GT
			else
				last_token := SYM_END_DBLOCK
			end
		
end
else
if yy_act = 29 then
	yy_position := yy_position + 2
--|#line 134 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 134")
end
last_token := SYM_ELLIPSIS
else
	yy_position := yy_position + 3
--|#line 135 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 135")
end
last_token := SYM_LIST_CONTINUE
end
end
end
else
if yy_act <= 35 then
if yy_act <= 33 then
if yy_act <= 32 then
if yy_act = 31 then
	yy_position := yy_position + 4
--|#line 139 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 139")
end
last_token := SYM_TRUE
else
	yy_position := yy_position + 5
--|#line 141 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 141")
end
last_token := SYM_FALSE
end
else
	yy_position := yy_position + 4
--|#line 143 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 143")
end
last_token := SYM_VOID
end
else
if yy_act = 34 then
	yy_position := yy_position + 8
--|#line 145 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 145")
end
last_token := SYM_INFINITY
else
	yy_position := yy_position + 5
--|#line 148 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 148")
end
last_token := SYM_QUERY_FUNC
end
end
else
if yy_act <= 38 then
if yy_act <= 37 then
if yy_act = 36 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 151 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 151")
end

	last_token := V_URI
	last_string_value := text

else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 159 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 159")
end

					last_token := V_QUALIFIED_TERM_CODE_REF
					last_string_value := text_substring (2, text_count - 1)
			
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 164 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 164")
end

					last_token := ERR_V_QUALIFIED_TERM_CODE_REF
					last_string_value := text_substring (2, text_count - 1)
			
end
else
if yy_act = 39 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 169 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 169")
end

					last_token := V_LOCAL_TERM_CODE_REF
					last_string_value := text_substring (2, text_count - 1)
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 175 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 175")
end

					last_token := V_LOCAL_CODE
					last_string_value := text
			
end
end
end
end
end
else
if yy_act <= 60 then
if yy_act <= 50 then
if yy_act <= 45 then
if yy_act <= 43 then
if yy_act <= 42 then
if yy_act = 41 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 182 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 182")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 183 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 183")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 184 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 184")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
end
else
if yy_act = 44 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 191 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 191")
end

				last_token := V_ISO8601_EXTENDED_TIME
				last_string_value := text
		
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 192 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 192")
end

				last_token := V_ISO8601_EXTENDED_TIME
				last_string_value := text
		
end
end
else
if yy_act <= 48 then
if yy_act <= 47 then
if yy_act = 46 then
	yy_position := yy_position + 10
--|#line 199 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 199")
end

				last_token := V_ISO8601_EXTENDED_DATE
				last_string_value := text
		
else
	yy_position := yy_position + 7
--|#line 200 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 200")
end

				last_token := V_ISO8601_EXTENDED_DATE
				last_string_value := text
		
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 210 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 210")
end

				last_token := V_ISO8601_DURATION
				last_string_value := text
			
end
else
if yy_act = 49 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 211 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 211")
end

				last_token := V_ISO8601_DURATION
				last_string_value := text
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 217 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 217")
end

					last_token := V_TYPE_IDENTIFIER
					last_string_value := text
			
end
end
end
else
if yy_act <= 55 then
if yy_act <= 53 then
if yy_act <= 52 then
if yy_act = 51 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 222 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 222")
end

					last_token := V_GENERIC_TYPE_IDENTIFIER
					last_string_value := text
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 227 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 227")
end

					last_token := V_ATTRIBUTE_IDENTIFIER
					last_string_value := text
			
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 234 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 234")
end
				-- beginning of CADL block
				in_buffer.append_string (text)
				set_start_condition (IN_CADL_BLOCK)
				cadl_depth := 1
			
end
else
if yy_act = 54 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 241 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 241")
end
		-- got an open brace
				in_buffer.append_string (text)
				cadl_depth := cadl_depth + 1
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 245 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 245")
end
		-- got a close brace
				in_buffer.append_string (text)
				cadl_depth := cadl_depth - 1
				if cadl_depth = 0 then
					set_start_condition (INITIAL)
					last_token := V_CADL_BLOCK
					create last_string_value.make(in_buffer.count)
					last_string_value.append(in_buffer)
					in_lineno := in_lineno + in_buffer.occurrences('%N')
					in_buffer.wipe_out
				end
			
end
end
else
if yy_act <= 58 then
if yy_act <= 57 then
if yy_act = 56 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 262 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 262")
end

					last_token := V_INTEGER
					last_integer_value := text.to_integer
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 263 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 263")
end

					last_token := V_INTEGER
					last_integer_value := text.to_integer
			
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 270 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 270")
end

						last_token := V_REAL
						last_real_value := text.to_real
					
end
else
if yy_act = 59 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 271 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 271")
end

						last_token := V_REAL
						last_real_value := text.to_real
					
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 278 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 278")
end

					last_token := V_POINTER
					create last_pointer_value
			
end
end
end
end
else
if yy_act <= 70 then
if yy_act <= 65 then
if yy_act <= 63 then
if yy_act <= 62 then
if yy_act = 61 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 288 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 288")
end

				last_token := V_STRING
				last_string_value := text_substring (2, text_count - 1)
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 293 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 293")
end
				-- beginning of a string
				if text_count > 1 then
					in_buffer.append_string (text_substring (2, text_count))
				end
				set_start_condition (IN_STR)
			
end
else
	yy_position := yy_position + 2
--|#line 301 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 301")
end
in_buffer.append_character ('\')
end
else
if yy_act = 64 then
	yy_position := yy_position + 2
--|#line 303 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 303")
end
in_buffer.append_character ('"')
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 305 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 305")
end

				in_buffer.append_string (text)
	
end
end
else
if yy_act <= 68 then
if yy_act <= 67 then
if yy_act = 66 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 309 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 309")
end
in_buffer.append_string (text)
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 311 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 311")
end

				in_lineno := in_lineno + 1	-- match LF in line
				in_buffer.append_character ('%N')
			
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 316 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 316")
end
						-- match final end of string
				last_token := V_STRING

				if text_count > 1 then
					in_buffer.append_string (text_substring (1, text_count - 1))
				end

				create str_.make (in_buffer.count)
				str_.append_string (in_buffer)
				in_buffer.wipe_out
				last_string_value := str_
				set_start_condition (INITIAL)
			
end
else
if yy_act = 69 then
	yy_position := yy_position + 1
--|#line 329 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 329")
end
	-- Catch-all rules (no backing up)
				last_token := ERR_STRING
				set_start_condition (INITIAL)
			
else
	yy_position := yy_position + 3
--|#line 339 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 339")
end
last_token := V_CHARACTER; last_character_value := text_item (2)
end
end
end
else
if yy_act <= 75 then
if yy_act <= 73 then
if yy_act <= 72 then
if yy_act = 71 then
	yy_position := yy_position + 4
--|#line 341 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 341")
end
last_token := V_CHARACTER; last_character_value := '%N'
else
	yy_position := yy_position + 4
--|#line 342 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 342")
end
last_token := V_CHARACTER; last_character_value := '%R'
end
else
	yy_position := yy_position + 4
--|#line 343 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 343")
end
last_token := V_CHARACTER; last_character_value := '%T'
end
else
if yy_act = 74 then
	yy_position := yy_position + 4
--|#line 344 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 344")
end
last_token := V_CHARACTER; last_character_value := '%''
else
	yy_position := yy_position + 4
--|#line 345 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 345")
end
last_token := V_CHARACTER; last_character_value := '%H'
end
end
else
if yy_act <= 77 then
if yy_act = 76 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 347 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 347")
end
last_token := ERR_CHARACTER	-- Catch-all rules (no backing up)
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 348 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 348")
end
last_token := ERR_CHARACTER	-- Catch-all rules (no backing up)
end
else
if yy_act = 78 then
	yy_position := yy_position + 1
--|#line 352 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 352")
end
;
else
	yy_position := yy_position + 1
--|#line 0 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 0")
end
default_action
end
end
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0, 2 then
--|#line 0 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 0")
end
terminate
when 1 then
--|#line 0 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 0")
end
	-- Catch-all rules (no backing up)
				last_token := ERR_STRING
				set_start_condition (INITIAL)
			
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1754)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    8,    9,   10,    9,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,   23,   24,   24,
			   25,   25,   25,   26,   27,   28,   29,   30,   31,   32,
			   32,   32,   32,   33,   32,   34,   32,   32,   32,   32,
			   35,   36,   32,   32,   37,   32,   38,   32,   32,   32,
			   39,    8,   40,   41,    8,   42,   43,   43,   43,   43,
			   44,   43,   45,   43,   43,   43,   43,   46,   43,   43,
			   47,   43,   48,   43,   43,   43,   49,   50,    8,    8,
			    8,    8,    8,    8,    8,    8,    8,    8,   52,   68,
			   61,   53,   62,   52,  267,   61,   53,   62,   63,   74,

			   63,   75,   76,   76,   76,   76,   76,   74,   84,   76,
			   76,   76,   76,   76,   76,   84,   77,   84,   84,   85,
			  111,   86,  111,   74,   77,   79,   79,   79,   79,   79,
			   79,   96,   69,   92,   92,   90,   54,   89,   92,   92,
			   77,   54,   84,   77,   96,   85,   84,   63,   86,   63,
			   84,   77,   87,   87,   87,   87,   87,   87,   78,   98,
			   84,   90,  150,   89,   91,   88,   84,   77,   55,   56,
			   57,   58,   59,   55,   56,   57,   58,   59,   92,   88,
			  112,  110,  111,  253,  111,   99,  110,   96,  150,  110,
			   84,   91,   94,   94,   94,   94,   94,   94,   95,  110,

			   96,  142,  236,  236,   94,   94,   94,   94,   94,   94,
			   94,   94,   94,   94,   94,   94,   94,   94,   94,   94,
			   94,   94,   94,   94,   94,  113,  110,  163,  142,   94,
			   96,   96,   97,   96,   96,   96,   96,   96,   96,   96,
			   96,   96,   96,   96,   96,   97,   96,   96,   96,   96,
			   96,  100,  132,  163,  102,   96,  104,  115,  106,   84,
			  114,  114,  114,  116,  116,  116,   96,  132,   96,  151,
			   96,   96,  157,  246,  117,  117,   96,  295,  101,   96,
			  103,  124,  105,   96,   96,  107,  133,  226,  213,   96,
			  125,  125,  125,  125,  125,  125,  151,  241,   84,  157,

			  118,  118,  118,  134,  134,  134,  134,  134,  134,   74,
			  159,  135,  136,  136,  136,  136,  136,  137,  140,  140,
			  140,  140,  140,  140,  126,   74,   77,  136,  136,  136,
			  136,  136,  136,  137,  214,  242,   84,  159,  127,   84,
			  110,  128,   77,  129,  143,  161,  149,   92,   92,  138,
			  130,  138,  130,   77,  139,  139,  139,  139,  139,  139,
			   74,  152,  136,  136,  136,  136,  136,  136,   78,   77,
			  165,  143,  161,  149,  159,  110,  204,   77,  148,  148,
			  148,  148,  148,  148,  110,   84,   84,  132,  110,  155,
			  153,  156,  156,  156,  156,  156,  156,  165,   96,  157,

			  110,  160,  161,  204,   77,   87,   87,   87,   87,   87,
			   87,   96,  163,   84,  114,  114,  114,  214,   84,  144,
			   96,  165,  234,  132,   96,  145,  158,   96,  190,  162,
			   84,   96,  226,   96,   84,  146,  147,   96,  164,   84,
			   96,   96,   84,   96,   96,  199,  144,  197,  166,  114,
			  114,  114,  145,   84,   96,  190,   96,  212,  172,  172,
			  172,  146,  188,  147,  295,  167,  168,  169,  170,  171,
			  295,  110,  199,  197,  173,  173,  173,  175,  176,  176,
			  176,  176,  176,  176,  187,  187,  187,  187,  187,  139,
			  139,  139,  139,  139,  139,  201,   94,   94,   94,   94,

			   94,   94,   94,   94,   94,   94,   94,   94,   94,   94,
			   94,   94,   94,   94,   94,   94,   94,  134,  134,  134,
			  134,  134,  134,   74,  200,  185,  186,  186,  186,  186,
			  186,   74,  184,  186,  186,  186,  186,  186,  186,   84,
			   77,  139,  139,  139,  139,  139,  139,  115,   77,  140,
			  140,  140,  140,  140,  140,  202,  188,  189,  206,  184,
			  191,  191,  191,  191,  191,  191,  182,   77,   84,  192,
			  192,  192,  192,  192,  192,   77,  132,   84,   84,  110,
			  208,  202,   78,  189,  206,  198,  210,   88,  110,  193,
			  193,  193,  193,  193,  193,  202,   88,   84,  148,  148,

			  148,  148,  148,  148,  110,  245,   84,  208,  180,   96,
			  110,  179,  198,  210,  110,  194,   88,  204,  195,  110,
			  178,  203,   96,  155,  196,  155,  155,  155,  155,  155,
			  155,  155,  206,  156,  156,  156,  156,  156,  156,   96,
			  208,  177,  194,  210,  205,  195,   96,   96,   96,   84,
			  196,  246,   96,  114,  114,  114,  221,  174,  207,   96,
			   96,   96,  116,  116,  116,   96,  251,  209,   84,   96,
			  211,  175,  176,  176,  176,  176,  176,  176,   96,  117,
			  117,  120,   96,  221,  118,  118,  118,   96,  114,  114,
			  114,  225,  251,  114,  114,  114,  215,  110,  215,  154,

			   96,  216,  216,  216,  216,  216,  216,  217,   74,  152,
			  218,  219,  219,  219,  219,  219,  217,   74,  225,  219,
			  219,  219,  219,  219,  219,   77,  220,  220,  220,  220,
			  220,  220,   84,  228,   77,  191,  191,  191,  191,  191,
			  191,   84,  230,  228,  232,  222,  192,  192,  192,  192,
			  192,  192,   77,  232,  237,   83,  237,  269,  269,  269,
			  228,   77,   96,  243,   96,  238,   83,   78,   96,  230,
			  229,  232,  222,   73,  131,   96,   83,   96,  130,   84,
			  233,   96,   83,  193,  193,  193,  193,  193,  193,  240,
			  243,  239,  230,   83,   84,  257,  223,  223,  223,  223,

			  223,  223,   83,  145,   84,  224,  224,  224,  224,  224,
			  224,   96,  123,   84,   66,   64,  240,  256,  120,  231,
			  110,   84,  257,   82,   96,  249,  249,  249,  249,  249,
			  145,  216,  216,  216,  216,  216,  216,  216,  216,  216,
			  216,  216,  216,   74,  256,  218,  219,  219,  219,  219,
			  219,   74,   81,  219,  219,  219,  219,  219,  219,  243,
			   77,  223,  223,  223,  223,  223,  223,   80,   77,   73,
			   71,  224,  224,  224,  224,  224,  224,   84,   83,   84,
			   70,   96,  259,  259,  259,  259,  244,   77,  247,  247,
			  247,  247,  247,  247,   96,   77,  250,  196,   66,  251,

			   64,  295,   78,  295,  295,   83,  248,  248,  248,  248,
			  248,  248,   96,  254,  254,  254,  254,  254,  254,  261,
			  262,  261,  250,  196,  257,  252,  255,  255,  255,  255,
			  255,  255,  295,   96,  260,  260,  260,  260,  260,  260,
			  264,  264,  264,  264,  264,  264,   96,  288,  289,  288,
			  295,  258,  295,  295,  295,  295,  263,  239,  239,  239,
			  239,  239,  239,  265,  265,  265,  265,  265,  265,  266,
			  266,  266,  266,  266,  266,  268,  268,  268,  268,  268,
			  268,  261,  295,  261,  290,  295,  266,  266,  266,  266,
			  266,  266,  270,  270,  270,  270,  270,  270,  271,  271, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  271,  271,  271,  271,  263,  263,  263,  263,  263,  263,
			  272,  295,  272,  276,  276,  276,  276,  276,  263,  295,
			  295,  273,  275,  275,  275,  275,  275,  275,  277,  277,
			  277,  277,  277,  277,  278,  278,  278,  278,  278,  278,
			  279,  279,  279,  279,  279,  279,  280,  274,  280,  274,
			  274,  274,  274,  274,  274,  295,  295,  281,  283,  283,
			  283,  283,  283,  283,  284,  284,  284,  284,  284,  285,
			  285,  285,  285,  285,  285,  286,  286,  286,  286,  286,
			  286,  295,  295,  282,  287,  287,  287,  287,  287,  287,
			  282,  282,  282,  282,  282,  282,  291,  291,  291,  291,

			  291,  291,  292,  292,  292,  292,  292,  292,  293,  293,
			  293,  293,  293,  293,  288,  295,  288,  295,  295,  292,
			  292,  292,  292,  292,  292,  294,  294,  294,  294,  294,
			  294,  290,  290,  290,  290,  290,  290,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  290,   51,   51,   51,   51,   51,   51,   51,   51,
			   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
			   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
			   60,   60,   60,   60,   60,   60,   60,   60,   60,   60,
			   60,   60,   60,   60,   60,   60,   60,   60,   60,   60,

			   60,   60,   60,   60,   60,   60,   60,   60,   65,  295,
			   65,   65,   65,   65,   65,   65,   65,   65,   65,   65,
			   65,   65,   65,   65,  295,   65,   65,   65,   65,   65,
			   65,   65,   65,   65,   65,   65,   67,  295,   67,   67,
			   67,   67,   67,   67,   67,   67,   67,   67,   67,   67,
			   67,   67,   67,   67,   67,   67,   67,   67,   67,   67,
			   67,   67,   67,   67,   72,   72,   72,   72,  295,  295,
			  295,   72,  295,  295,  295,   72,   72,   72,   72,   72,
			   72,   72,   72,   83,   83,  295,   83,  295,   83,  295,
			  295,  295,   83,   83,   83,   83,   83,   83,   83,   83,

			   93,   93,  295,   93,  295,   93,   93,  295,  295,  295,
			   93,  295,  295,  295,   93,   93,   93,   93,   93,   93,
			   93,   93,  108,  108,  108,  108,  108,  108,  108,  108,
			  108,  108,  108,  108,  108,  108,  108,  108,  108,  108,
			  108,  108,  108,  108,  108,  108,  108,  108,  109,  295,
			  109,  109,  109,  109,  109,  109,  109,  109,  109,  109,
			  109,  109,  109,  109,  295,  109,  109,  109,  109,  109,
			  109,  109,  109,  109,  109,  109,  119,  119,  119,  119,
			  119,  119,  119,  119,  119,  119,  119,  119,  119,  119,
			  119,  119,  119,  119,  119,  119,  119,  119,  119,  119,

			  119,  119,  295,  119,  121,  121,  121,  121,  121,  121,
			  121,  121,  121,  121,  121,  121,  121,  121,  121,  121,
			  121,  121,  121,  121,  121,  121,  121,  121,  121,  121,
			  122,  295,  122,  122,  122,  122,  122,  122,  122,  122,
			  122,  122,  122,  122,  122,  122,  122,  122,  122,  122,
			  122,  122,  122,  122,  122,  122,  122,  122,   70,   70,
			   70,   70,   70,   70,   70,   70,   70,   70,   70,   70,
			   70,   70,   70,   70,   70,   70,   70,   70,   70,   70,
			   70,   70,   70,   70,   70,   70,  141,  295,  295,  141,
			  141,  295,  141,  141,  141,  295,  295,  295,  141,  141,

			  141,  141,  141,  141,  141,  141,   92,   92,  295,   92,
			  295,   92,   92,   92,  295,  295,   92,  295,  295,  295,
			   92,   92,   92,   92,   92,   92,   92,   92,  181,  181,
			  181,  181,  295,  295,  295,  181,  295,  295,  295,  181,
			  181,  181,  181,  181,  181,  181,  181,  183,  295,  295,
			  295,  295,  295,  183,  183,  295,  295,  295,  183,  295,
			  295,  295,  183,  183,  183,  183,  183,  183,  183,  183,
			  227,  295,  295,  295,  295,  227,  295,  227,  227,  295,
			  295,  295,  227,  295,  295,  295,  227,  227,  227,  227,
			  227,  227,  227,  227,  201,  201,  295,  295,  201,  201,

			  201,  201,  201,  201,  201,  201,  295,  295,  201,  295,
			  295,  295,  201,  201,  201,  201,  201,  201,  201,  201,
			  235,  295,  295,  295,  295,  295,  235,  235,  295,  295,
			  295,  235,  295,  295,  295,  235,  235,  235,  235,  235,
			  235,  235,  235,  226,  295,  295,  295,  295,  226,  295,
			  226,  226,  295,  295,  295,  226,  295,  295,  226,  226,
			  226,  226,  226,  226,  226,  226,  226,    7,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,

			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295, yy_Dummy>>,
			1, 755, 1000)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1754)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_chk_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    3,   14,
			    5,    3,    5,    4,  264,    6,    4,    6,    9,   23,

			    9,   23,   23,   23,   23,   23,   23,   24,   34,   24,
			   24,   24,   24,   24,   24,   33,   23,   36,   37,   33,
			   52,   34,   52,   25,   24,   25,   25,   25,   25,   25,
			   25,   43,   14,   39,   39,   37,    3,   36,   39,   39,
			   25,    4,   90,   23,   43,   33,  144,   63,   34,   63,
			   38,   24,   35,   35,   35,   35,   35,   35,   23,   44,
			   35,   37,   90,   36,   38,  144,  256,   25,    3,    3,
			    3,    3,    3,    4,    4,    4,    4,    4,   39,   35,
			   54,   56,  111,  247,  111,   44,   55,   44,   90,   57,
			   85,   38,   42,   42,   42,   42,   42,   42,   42,   58,

			   44,   85,  217,  217,   42,   42,   42,   42,   42,   42,
			   42,   42,   42,   42,   42,   42,   42,   42,   42,   42,
			   42,   42,   42,   42,   42,   54,   59,  104,   85,   42,
			   42,   42,   42,   42,   42,   42,   42,   42,   42,   42,
			   42,   42,   42,   42,   42,   42,   42,   42,   42,   42,
			   42,   45,   72,  104,   46,   96,   47,   56,   48,   91,
			   55,   55,   55,   57,   57,   57,   46,  246,   96,   91,
			   45,   47,   98,  245,   58,   58,   48,  234,   45,   46,
			   46,   69,   47,   45,   47,   48,   72,  227,  183,   48,
			   69,   69,   69,   69,   69,   69,   91,  226,  225,   98,

			   59,   59,   59,   74,   74,   74,   74,   74,   74,   75,
			  100,   75,   75,   75,   75,   75,   75,   75,   78,   78,
			   78,   78,   78,   78,   69,   76,   75,   76,   76,   76,
			   76,   76,   76,   76,  183,  227,   86,  100,   69,   89,
			  115,   69,   76,   69,   86,  102,   89,   93,   93,   77,
			  130,   77,  130,   75,   77,   77,   77,   77,   77,   77,
			   79,   93,   79,   79,   79,   79,   79,   79,   75,   76,
			  106,   86,  102,   89,  101,  116,  159,   79,   88,   88,
			   88,   88,   88,   88,  117,  221,   88,  214,  114,   97,
			   93,   97,   97,   97,   97,   97,   97,  106,  101,   99,

			  118,  101,  103,  159,   79,   87,   87,   87,   87,   87,
			   87,  101,  105,   87,  115,  115,  115,  213,  143,   87,
			   99,  107,  212,  181,  105,   87,   99,  103,  143,  103,
			  149,   97,  200,   99,  199,   87,   87,  105,  105,  151,
			  103,  209,  198,  107,   97,  151,   87,  149,  107,  116,
			  116,  116,   87,  196,  209,  143,  107,  181,  117,  117,
			  117,   87,  188,   87,   94,  114,  114,  114,  114,  114,
			  182,  168,  151,  149,  118,  118,  118,  125,  125,  125,
			  125,  125,  125,  125,  137,  137,  137,  137,  137,  138,
			  138,  138,  138,  138,  138,  154,   94,   94,   94,   94,

			   94,   94,   94,   94,   94,   94,   94,   94,   94,   94,
			   94,   94,   94,   94,   94,   94,   94,  134,  134,  134,
			  134,  134,  134,  135,  152,  135,  135,  135,  135,  135,
			  135,  136,  134,  136,  136,  136,  136,  136,  136,  142,
			  135,  139,  139,  139,  139,  139,  139,  168,  136,  140,
			  140,  140,  140,  140,  140,  157,  141,  142,  161,  134,
			  145,  145,  145,  145,  145,  145,  133,  135,  145,  146,
			  146,  146,  146,  146,  146,  136,  132,  146,  150,  167,
			  163,  157,  135,  142,  161,  150,  165,  145,  169,  147,
			  147,  147,  147,  147,  147,  158,  146,  147,  148,  148,

			  148,  148,  148,  148,  170,  235,  148,  163,  129,  158,
			  171,  128,  150,  165,  172,  148,  147,  160,  148,  173,
			  127,  158,  158,  155,  148,  155,  155,  155,  155,  155,
			  155,  156,  162,  156,  156,  156,  156,  156,  156,  160,
			  164,  126,  148,  166,  160,  148,  211,  162,  229,  189,
			  148,  235,  160,  167,  167,  167,  189,  124,  162,  211,
			  162,  229,  169,  169,  169,  164,  243,  164,  197,  166,
			  166,  176,  176,  176,  176,  176,  176,  176,  164,  170,
			  170,  119,  166,  189,  171,  171,  171,  233,  172,  172,
			  172,  197,  243,  173,  173,  173,  184,  109,  184,   95,

			  233,  184,  184,  184,  184,  184,  184,  185,  185,   92,
			  185,  185,  185,  185,  185,  185,  186,  186,  197,  186,
			  186,  186,  186,  186,  186,  185,  187,  187,  187,  187,
			  187,  187,  190,  202,  186,  191,  191,  191,  191,  191,
			  191,   83,  204,  203,  206,  190,  192,  192,  192,  192,
			  192,  192,  185,  207,  220,  191,  220,  267,  267,  267,
			  202,  186,  207,  230,  258,  220,  191,  185,  203,  204,
			  203,  206,  190,   73,   71,  207,  192,  258,   70,  222,
			  207,  203,  191,  193,  193,  193,  193,  193,  193,  222,
			  230,  220,  205,  191,  250,  251,  194,  194,  194,  194,

			  194,  194,  192,  193,  194,  195,  195,  195,  195,  195,
			  195,  205,   67,  195,   65,   64,  222,  250,   60,  205,
			   51,   32,  251,   31,  205,  238,  238,  238,  238,  238,
			  193,  215,  215,  215,  215,  215,  215,  216,  216,  216,
			  216,  216,  216,  218,  250,  218,  218,  218,  218,  218,
			  218,  219,   30,  219,  219,  219,  219,  219,  219,  231,
			  218,  223,  223,  223,  223,  223,  223,   28,  219,   22,
			   21,  224,  224,  224,  224,  224,  224,  240,  223,  224,
			   20,  231,  253,  253,  253,  253,  231,  218,  236,  236,
			  236,  236,  236,  236,  231,  219,  240,  224,   12,  244,

			   10,    7,  218,    0,    0,  223,  237,  237,  237,  237,
			  237,  237,  244,  248,  248,  248,  248,  248,  248,  255,
			  255,  255,  240,  224,  252,  244,  249,  249,  249,  249,
			  249,  249,    0,  252,  254,  254,  254,  254,  254,  254,
			  259,  259,  259,  259,  259,  259,  252,  286,  286,  286,
			    0,  252,    0,    0,    0,    0,  255,  260,  260,  260,
			  260,  260,  260,  261,  261,  261,  261,  261,  261,  262,
			  262,  262,  262,  262,  262,  265,  265,  265,  265,  265,
			  265,  266,    0,  266,  286,    0,  266,  266,  266,  266,
			  266,  266,  268,  268,  268,  268,  268,  268,  269,  269, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  269,  269,  269,  269,  270,  270,  270,  270,  270,  270,
			  271,    0,  271,  273,  273,  273,  273,  273,  266,    0,
			    0,  271,  272,  272,  272,  272,  272,  272,  275,  275,
			  275,  275,  275,  275,  276,  276,  276,  276,  276,  276,
			  277,  277,  277,  277,  277,  277,  278,  271,  278,  279,
			  279,  279,  279,  279,  279,    0,    0,  278,  280,  280,
			  280,  280,  280,  280,  281,  281,  281,  281,  281,  283,
			  283,  283,  283,  283,  283,  284,  284,  284,  284,  284,
			  284,    0,    0,  278,  285,  285,  285,  285,  285,  285,
			  287,  287,  287,  287,  287,  287,  288,  288,  288,  288,

			  288,  288,  289,  289,  289,  289,  289,  289,  291,  291,
			  291,  291,  291,  291,  292,    0,  292,    0,    0,  292,
			  292,  292,  292,  292,  292,  293,  293,  293,  293,  293,
			  293,  294,  294,  294,  294,  294,  294,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,  292,  296,  296,  296,  296,  296,  296,  296,  296,
			  296,  296,  296,  296,  296,  296,  296,  296,  296,  296,
			  296,  296,  296,  296,  296,  296,  296,  296,  296,  296,
			  297,  297,  297,  297,  297,  297,  297,  297,  297,  297,
			  297,  297,  297,  297,  297,  297,  297,  297,  297,  297,

			  297,  297,  297,  297,  297,  297,  297,  297,  298,    0,
			  298,  298,  298,  298,  298,  298,  298,  298,  298,  298,
			  298,  298,  298,  298,    0,  298,  298,  298,  298,  298,
			  298,  298,  298,  298,  298,  298,  299,    0,  299,  299,
			  299,  299,  299,  299,  299,  299,  299,  299,  299,  299,
			  299,  299,  299,  299,  299,  299,  299,  299,  299,  299,
			  299,  299,  299,  299,  300,  300,  300,  300,    0,    0,
			    0,  300,    0,    0,    0,  300,  300,  300,  300,  300,
			  300,  300,  300,  301,  301,    0,  301,    0,  301,    0,
			    0,    0,  301,  301,  301,  301,  301,  301,  301,  301,

			  302,  302,    0,  302,    0,  302,  302,    0,    0,    0,
			  302,    0,    0,    0,  302,  302,  302,  302,  302,  302,
			  302,  302,  303,  303,  303,  303,  303,  303,  303,  303,
			  303,  303,  303,  303,  303,  303,  303,  303,  303,  303,
			  303,  303,  303,  303,  303,  303,  303,  303,  304,    0,
			  304,  304,  304,  304,  304,  304,  304,  304,  304,  304,
			  304,  304,  304,  304,    0,  304,  304,  304,  304,  304,
			  304,  304,  304,  304,  304,  304,  305,  305,  305,  305,
			  305,  305,  305,  305,  305,  305,  305,  305,  305,  305,
			  305,  305,  305,  305,  305,  305,  305,  305,  305,  305,

			  305,  305,    0,  305,  306,  306,  306,  306,  306,  306,
			  306,  306,  306,  306,  306,  306,  306,  306,  306,  306,
			  306,  306,  306,  306,  306,  306,  306,  306,  306,  306,
			  307,    0,  307,  307,  307,  307,  307,  307,  307,  307,
			  307,  307,  307,  307,  307,  307,  307,  307,  307,  307,
			  307,  307,  307,  307,  307,  307,  307,  307,  308,  308,
			  308,  308,  308,  308,  308,  308,  308,  308,  308,  308,
			  308,  308,  308,  308,  308,  308,  308,  308,  308,  308,
			  308,  308,  308,  308,  308,  308,  309,    0,    0,  309,
			  309,    0,  309,  309,  309,    0,    0,    0,  309,  309,

			  309,  309,  309,  309,  309,  309,  310,  310,    0,  310,
			    0,  310,  310,  310,    0,    0,  310,    0,    0,    0,
			  310,  310,  310,  310,  310,  310,  310,  310,  311,  311,
			  311,  311,    0,    0,    0,  311,    0,    0,    0,  311,
			  311,  311,  311,  311,  311,  311,  311,  312,    0,    0,
			    0,    0,    0,  312,  312,    0,    0,    0,  312,    0,
			    0,    0,  312,  312,  312,  312,  312,  312,  312,  312,
			  313,    0,    0,    0,    0,  313,    0,  313,  313,    0,
			    0,    0,  313,    0,    0,    0,  313,  313,  313,  313,
			  313,  313,  313,  313,  314,  314,    0,    0,  314,  314,

			  314,  314,  314,  314,  314,  314,    0,    0,  314,    0,
			    0,    0,  314,  314,  314,  314,  314,  314,  314,  314,
			  315,    0,    0,    0,    0,    0,  315,  315,    0,    0,
			    0,  315,    0,    0,    0,  315,  315,  315,  315,  315,
			  315,  315,  315,  316,    0,    0,    0,    0,  316,    0,
			  316,  316,    0,    0,    0,  316,    0,    0,  316,  316,
			  316,  316,  316,  316,  316,  316,  316,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,

			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295, yy_Dummy>>,
			1, 755, 1000)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   85,   90,   14,   19,  901, 1667,   96,
			  897, 1667,  892, 1667,   81, 1667, 1667, 1667, 1667, 1667,
			  866,  855,  853,   84,   92,  108, 1667, 1667,  841, 1667,
			  826,  795,  796,   90,   83,  135,   92,   93,  125,  124,
			 1667, 1667,  175,   74,  130,  213,  209,  214,  219,    0,
			 1667,  814,  118, 1667,  174,  180,  175,  183,  193,  220,
			  740,    0, 1667,  145,  812,  808, 1667,  804,    0,  273,
			  775,  759,  236,  757,  286,  294,  310,  337,  301,  345,
			 1667, 1667, 1667,  716,    0,  165,  311,  388,  361,  314,
			  117,  234,  686,  338,  441,  683,  198,  374,  236,  363,

			  277,  341,  313,  370,  182,  367,  335,  386,    0,  691,
			 1667,  180, 1667, 1667,  382,  334,  369,  378,  394,  603,
			 1667,    0, 1667, 1667,  649,  461,  633,  612,  603,  600,
			  348, 1667,  560,  560,  500,  508,  516,  467,  472,  524,
			  532,  529,  514,  393,  121,  543,  552,  572,  581,  405,
			  553,  414,  501, 1667,  479,  608,  616,  512,  552,  341,
			  582,  516,  590,  548,  608,  555,  612,  573,  465,  582,
			  598,  604,  608,  613, 1667, 1667,  655, 1667, 1667, 1667,
			 1667,  407,  464,  282,  684,  693,  702,  709,  435,  624,
			  707,  718,  729,  766,  779,  788,  428,  643,  417,  409,

			  428,    0,  701,  711,  704,  754,  696,  705,    0,  384,
			    0,  589,  416,  365,  371,  814,  820,  185,  828,  836,
			  742,  360,  754,  844,  854,  273,  245,  283,    0,  591,
			  728,  824,    0,  630,  271,  599,  871,  889,  808, 1667,
			  852, 1667, 1667,  622,  855,  221,  251,  169,  896,  909,
			  769,  747,  876,  865,  917,  907,  141,    0,  707,  923,
			  940,  946,  952, 1667,   50,  958,  969,  740,  975,  981,
			  987,  998, 1005,  996, 1667, 1011, 1017, 1023, 1034, 1032,
			 1041, 1047, 1667, 1052, 1058, 1067,  935, 1073, 1079, 1085,
			 1667, 1091, 1102, 1108, 1114, 1667, 1151, 1179, 1207, 1235,

			 1256, 1273, 1295, 1321, 1347, 1375, 1403, 1429, 1457, 1479,
			 1501, 1520, 1543, 1567, 1593, 1616, 1640, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  295,    1,  296,  296,  297,  297,  295,  295,  295,
			  295,  295,  298,  295,  299,  295,  295,  295,  295,  295,
			  295,  295,  300,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  301,  301,  301,  301,  301,  301,  301,  302,
			  295,  295,  295,   42,   42,   42,   42,   42,   42,  303,
			  295,  304,  295,  295,  295,  304,  304,  304,  304,  304,
			  305,  306,  295,  295,  295,  298,  295,  307,  307,  307,
			  308,  295,  300,  300,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  301,  309,  301,  301,  301,  301,  301,
			  301,  301,  310,  302,   42,  295,   42,   42,   94,   42,

			   94,   42,   94,   42,   94,   42,   94,   42,  303,  304,
			  295,  295,  295,  295,  304,  304,  304,  304,  304,  305,
			  295,  306,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  311,  312,  295,  295,  295,  295,  295,  295,
			  295,  309,  301,  301,  301,  301,  301,  301,  301,  301,
			  301,  301,  295,  295,  295,  295,   94,   94,   42,   94,
			   42,   94,   42,   94,   42,   94,   42,  304,  304,  304,
			  304,  304,  304,  304,  295,  295,  295,  295,  295,  295,
			  295,  311,  312,  312,  295,  295,  295,  295,  309,  301,
			  301,   87,  191,  191,  301,  301,  301,  301,  301,  301,

			  313,  314,   94,   42,   94,   42,   94,   42,   94,   42,
			   94,   42,  315,  295,  300,  295,  295,  295,  295,  295,
			  295,  301,  301,  148,  301,  301,  316,  313,   94,   42,
			   94,   42,   94,   42,  315,  315,  295,  295,  295,  295,
			  301,  295,  295,   94,   42,  295,  295,  295,  295,  295,
			  301,   94,   42,  295,  295,  295,  301,   94,   42,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,    0,  295,  295,  295,  295,

			  295,  295,  295,  295,  295,  295,  295,  295,  295,  295,
			  295,  295,  295,  295,  295,  295,  295, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    5,    6,    1,    7,    1,    1,    8,
			    9,   10,   11,   12,   13,   14,   15,   16,   17,   18,
			   19,   20,   21,   21,   21,   22,   22,   22,   23,   24,
			   25,   26,   27,   28,    1,   29,   30,   30,   31,   32,
			   33,   30,   34,   35,   30,   30,   36,   37,   38,   39,
			   40,   41,   42,   43,   44,   45,   46,   47,   30,   48,
			   49,   50,   51,   52,   53,   54,    1,   55,   56,   57,

			   58,   59,   60,   56,   61,   62,   56,   56,   63,   64,
			   65,   66,   56,   67,   68,   69,   70,   71,   72,   73,
			   74,   75,   56,   76,   77,   78,   79,    1,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   82,   82,   82,   82,   82,   82,   82,   82,   82,   82,
			   82,   82,   82,   82,   82,   82,   82,   82,   82,   82,
			   82,   82,   82,   82,   82,   82,   82,   82,   82,   82,
			   82,   82,    1,    1,   83,   83,   83,   83,   83,   83,

			   83,   83,   83,   83,   83,   83,   83,   83,   83,   83,
			   83,   83,   83,   83,   83,   83,   83,   83,   83,   83,
			   83,   83,   83,   83,   84,   85,   85,   85,   85,   85,
			   85,   85,   85,   85,   85,   85,   85,   85,   85,   85,
			   86,   87,   87,   87,   87,   87,   87,   87,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    2,    3,    1,    4,    1,    1,    5,
			    6,    1,    1,    7,    8,    8,    9,   10,   10,   10,
			   10,   10,   11,   12,    1,   13,    1,   14,    1,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   15,
			   16,   17,   18,   16,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   19,   20,
			   21,   22,   23,   24,   25,   26,   27,   16,   28,   16,
			    1,    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,   80,   78,    1,
			    2,   15,   62,   18,   78,   16,   17,    8,    7,   13,
			    6,   11,    9,   56,   56,   56,   14,   12,   27,   24,
			   28,   20,   50,   50,   50,   49,   50,   50,   50,   22,
			   23,   10,   52,   52,   52,   52,   52,   52,   52,   53,
			   21,   66,   67,   68,   69,   66,   66,   66,   66,   66,
			   79,   54,   55,    1,    2,   62,   61,   76,   76,   76,
			    3,   29,    5,    0,    0,   56,   56,    0,    0,   56,
			   26,   25,   19,   50,    0,   50,   50,   50,   48,   50,
			   50,   50,    0,    0,   52,    0,   52,   52,   52,   52,

			   52,   52,   52,   52,   52,   52,   52,   52,   53,   66,
			   68,   67,   64,   63,   65,   66,   66,   66,   66,    0,
			   55,   54,   76,   70,   76,   76,   76,   76,   76,   76,
			    4,   30,    0,    0,   58,   56,   56,    0,    0,   57,
			   60,    0,   50,   50,   49,   49,   49,   49,   50,   50,
			   50,   50,    0,   39,    0,   40,   40,   52,   52,   52,
			   52,   52,   52,   52,   52,   52,   52,   66,   66,   66,
			   66,   66,   66,   66,   74,   77,   77,   75,   71,   72,
			   73,    5,    0,    0,    0,   56,   56,    0,   51,   50,
			   50,   50,   50,   50,   48,   48,   48,   50,   31,   33,

			    0,   36,   52,   52,   52,   52,   52,   52,   31,   31,
			   33,   33,    0,    0,    5,    0,   59,    0,   56,   56,
			   45,   32,   50,   50,   50,   35,    0,    0,   32,   32,
			   52,   52,   35,   35,    0,    0,    0,    0,    0,   45,
			   50,   38,   37,   52,   52,    0,    5,   47,    0,    0,
			   50,   52,   52,    0,    0,   44,   34,   34,   34,    0,
			    0,    0,    0,   44,   46,    0,   44,    0,    0,    0,
			    0,   43,    0,    0,   43,    0,    0,    0,   42,    0,
			    0,    0,   42,    0,    0,    0,   41,    0,    0,    0,
			   41,    0,   41,    0,    0,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 1667
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 295
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 296
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 79
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 80
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is true
			-- Is `position' used?

	INITIAL: INTEGER is 0
	IN_STR: INTEGER is 1
	IN_CADL_BLOCK: INTEGER is 2
			-- Start condition codes

feature -- User-defined features



feature {NONE} -- Local variables

	i_, nb_: INTEGER
	char_: CHARACTER
	str_: STRING
	code_: INTEGER

	cadl_depth: INTEGER

	in_interval: BOOLEAN

	start_block_received: BOOLEAN

feature {NONE} -- Initialization

	make is
			-- Create a new scanner.
		do
			make_compressed_scanner_skeleton
			create in_buffer.make (Init_buffer_size)
			in_lineno := 1
		end

feature -- Initialization

	reset is
			-- Reset scanner before scanning next input.
		do
			reset_compressed_scanner_skeleton
			in_lineno := 1
			in_buffer.wipe_out
		end

feature -- Access

	in_buffer: STRING
			-- Buffer for lexical tokens

	in_lineno: INTEGER
			-- Current line number

	is_operator: BOOLEAN
			-- Parsing an operator declaration?

feature {NONE} -- Constants

	Init_buffer_size: INTEGER is 256
				-- Initial size for `in_buffer'

invariant

	in_buffer_not_void: in_buffer /= Void

end
