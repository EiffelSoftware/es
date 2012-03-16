note
	component:   "openEHR Archetype Project"
	description: "Scanner for dADL syntax items"
	keywords:    "ADL, dADL"
	
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.com>"
	copyright:   "Copyright (c) 2004 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: https://svn.origo.ethz.ch/abel/trunk/libraries/openehr/src/dadl_syntax/parser/dadl_scanner.e $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DADL_SCANNER

inherit
	ANY_VALIDATOR
		rename
			reset as validator_reset
		end

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

	valid_start_condition (sc: INTEGER): BOOLEAN
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= IN_CADL_BLOCK)
		end

feature {NONE} -- Implementation

	yy_build_tables
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

	yy_execute_action (yy_act: INTEGER)
			-- Execute semantic action.
		do
if yy_act <= 35 then
if yy_act <= 18 then
if yy_act <= 9 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 68 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 68")
end
-- Ignore separators
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 69 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 69")
end
in_lineno := in_lineno + text_count
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 74 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 74")
end
-- Ignore comments
end
else
if yy_act = 4 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 75 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 75")
end
in_lineno := in_lineno + 1
else
	yy_position := yy_position + 1
--|#line 79 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 79")
end
last_token := Minus_code
end
end
else
if yy_act <= 7 then
if yy_act = 6 then
	yy_position := yy_position + 1
--|#line 80 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 80")
end
last_token := Plus_code
else
	yy_position := yy_position + 1
--|#line 81 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 81")
end
last_token := Star_code
end
else
if yy_act = 8 then
	yy_position := yy_position + 1
--|#line 82 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 82")
end
last_token := Slash_code
else
	yy_position := yy_position + 1
--|#line 83 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 83")
end
last_token := Caret_code
end
end
end
else
if yy_act <= 14 then
if yy_act <= 12 then
if yy_act <= 11 then
if yy_act = 10 then
	yy_position := yy_position + 1
--|#line 84 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 84")
end
last_token := Dot_code
else
	yy_position := yy_position + 1
--|#line 85 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 85")
end
last_token := Semicolon_code
end
else
	yy_position := yy_position + 1
--|#line 86 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 86")
end
last_token := Comma_code
end
else
if yy_act = 13 then
	yy_position := yy_position + 1
--|#line 87 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 87")
end
last_token := Colon_code
else
	yy_position := yy_position + 1
--|#line 88 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 88")
end
last_token := Exclamation_code
end
end
else
if yy_act <= 16 then
if yy_act = 15 then
	yy_position := yy_position + 1
--|#line 89 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 89")
end
last_token := Left_parenthesis_code
else
	yy_position := yy_position + 1
--|#line 90 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 90")
end
last_token := Right_parenthesis_code
end
else
if yy_act = 17 then
	yy_position := yy_position + 1
--|#line 91 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 91")
end
last_token := Dollar_code
else
	yy_position := yy_position + 2
--|#line 92 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 92")
end
last_token := SYM_DT_UNKNOWN
end
end
end
end
else
if yy_act <= 27 then
if yy_act <= 23 then
if yy_act <= 21 then
if yy_act <= 20 then
if yy_act = 19 then
	yy_position := yy_position + 1
--|#line 93 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 93")
end
last_token := Question_mark_code
else
	yy_position := yy_position + 1
--|#line 95 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 95")
end

			if in_interval then
				in_interval := False
			elseif start_block_received then
				in_interval := True
				start_block_received := False
			end
			last_token := SYM_INTERVAL_DELIM
		
end
else
	yy_position := yy_position + 1
--|#line 105 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 105")
end
last_token := Left_bracket_code
end
else
if yy_act = 22 then
	yy_position := yy_position + 1
--|#line 106 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 106")
end
last_token := Right_bracket_code
else
	yy_position := yy_position + 1
--|#line 108 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 108")
end
last_token := SYM_EQ
end
end
else
if yy_act <= 25 then
if yy_act = 24 then
	yy_position := yy_position + 2
--|#line 110 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 110")
end
last_token := SYM_GE
else
	yy_position := yy_position + 2
--|#line 111 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 111")
end
last_token := SYM_LE
end
else
if yy_act = 26 then
	yy_position := yy_position + 1
--|#line 113 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 113")
end

			if in_interval then
				last_token := SYM_LT
				start_block_received := False
			else
				last_token := SYM_START_DBLOCK
				start_block_received := True
				block_depth := block_depth + 1
			end
		
else
	yy_position := yy_position + 1
--|#line 124 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 124")
end

			if in_interval then
				last_token := SYM_GT
			else
				last_token := SYM_END_DBLOCK
				block_depth := block_depth - 1
			end
		
end
end
end
else
if yy_act <= 31 then
if yy_act <= 29 then
if yy_act = 28 then
	yy_position := yy_position + 2
--|#line 133 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 133")
end
last_token := SYM_ELLIPSIS
else
	yy_position := yy_position + 3
--|#line 134 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 134")
end
last_token := SYM_LIST_CONTINUE
end
else
if yy_act = 30 then
	yy_position := yy_position + 4
--|#line 138 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 138")
end
last_token := SYM_TRUE
else
	yy_position := yy_position + 5
--|#line 140 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 140")
end
last_token := SYM_FALSE
end
end
else
if yy_act <= 33 then
if yy_act = 32 then
	yy_position := yy_position + 8
--|#line 142 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 142")
end
last_token := SYM_INFINITY
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 146 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 146")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
end
else
if yy_act = 34 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 147 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 147")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 148 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 148")
end

				last_token := V_ISO8601_EXTENDED_DATE_TIME
				last_string_value := text
		
end
end
end
end
end
else
if yy_act <= 53 then
if yy_act <= 44 then
if yy_act <= 40 then
if yy_act <= 38 then
if yy_act <= 37 then
if yy_act = 36 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 155 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 155")
end

				last_token := V_ISO8601_EXTENDED_TIME
				last_string_value := text
		
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 156 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 156")
end

				last_token := V_ISO8601_EXTENDED_TIME
				last_string_value := text
		
end
else
	yy_position := yy_position + 10
--|#line 163 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 163")
end

				last_token := V_ISO8601_EXTENDED_DATE
				last_string_value := text
		
end
else
if yy_act = 39 then
	yy_position := yy_position + 7
--|#line 164 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 164")
end

				last_token := V_ISO8601_EXTENDED_DATE
				last_string_value := text
		
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 174 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 174")
end

				last_token := V_ISO8601_DURATION
				last_string_value := text
			
end
end
else
if yy_act <= 42 then
if yy_act = 41 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 175 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 175")
end

				last_token := V_ISO8601_DURATION
				last_string_value := text
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 181 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 181")
end

					last_token := V_TYPE_IDENTIFIER
					last_string_value := text
			
end
else
if yy_act = 43 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 186 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 186")
end

					last_token := V_GENERIC_TYPE_IDENTIFIER
					last_string_value := text
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 191 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 191")
end

					last_token := V_ATTRIBUTE_IDENTIFIER
					last_string_value := text
			
end
end
end
else
if yy_act <= 49 then
if yy_act <= 47 then
if yy_act <= 46 then
if yy_act = 45 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 198 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 198")
end
				-- beginning of CADL block
				if block_depth = 1 then
					in_buffer.append_string (text)
					set_start_condition (IN_CADL_BLOCK)
					cadl_depth := 1
				else
					last_token := ERR_CADL_MISPLACED
				end
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 209 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 209")
end
		-- got an open brace
				in_buffer.append_string (text)
				cadl_depth := cadl_depth + 1
			
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 213 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 213")
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
else
if yy_act = 48 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 230 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 230")
end

					last_token := V_INTEGER
					last_integer_value := text.to_integer
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 231 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 231")
end

					last_token := V_INTEGER
					last_integer_value := text.to_integer
			
end
end
else
if yy_act <= 51 then
if yy_act = 50 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 238 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 238")
end

						last_token := V_REAL
						last_real_value := text.to_real
					
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 239 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 239")
end

						last_token := V_REAL
						last_real_value := text.to_real
					
end
else
if yy_act = 52 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 246 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 246")
end

				last_token := V_STRING
				last_string_value := text_substring (2, text_count - 1)
			
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 251 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 251")
end
				-- beginning of a string
				if text_count > 1 then
					in_buffer.append_string (text_substring (2, text_count))
				end
				set_start_condition (IN_STR)
			
end
end
end
end
else
if yy_act <= 62 then
if yy_act <= 58 then
if yy_act <= 56 then
if yy_act <= 55 then
if yy_act = 54 then
	yy_position := yy_position + 2
--|#line 259 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 259")
end
in_buffer.append_character ('\')
else
	yy_position := yy_position + 2
--|#line 261 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 261")
end
in_buffer.append_character ('"')
end
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 263 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 263")
end

				in_buffer.append_string (text)
	
end
else
if yy_act = 57 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 267 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 267")
end
in_buffer.append_string (text)
else
	yy_position := yy_position + 1
--|#line 269 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 269")
end

				in_lineno := in_lineno + 1	-- match LF in line
				in_buffer.append_character ('%N')
			
end
end
else
if yy_act <= 60 then
if yy_act = 59 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 274 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 274")
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
			
else
	yy_position := yy_position + 1
--|#line 287 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 287")
end
	-- Catch-all rules (no backing up)
				last_token := ERR_STRING
				set_start_condition (INITIAL)
			
end
else
if yy_act = 61 then
	yy_position := yy_position + 3
--|#line 297 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 297")
end
last_token := V_CHARACTER; last_character_value := text_item (2)
else
	yy_position := yy_position + 4
--|#line 299 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 299")
end
last_token := V_CHARACTER; last_character_value := '%N'
end
end
end
else
if yy_act <= 66 then
if yy_act <= 64 then
if yy_act = 63 then
	yy_position := yy_position + 4
--|#line 300 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 300")
end
last_token := V_CHARACTER; last_character_value := '%R'
else
	yy_position := yy_position + 4
--|#line 301 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 301")
end
last_token := V_CHARACTER; last_character_value := '%T'
end
else
if yy_act = 65 then
	yy_position := yy_position + 4
--|#line 302 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 302")
end
last_token := V_CHARACTER; last_character_value := '%''
else
	yy_position := yy_position + 4
--|#line 303 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 303")
end
last_token := V_CHARACTER; last_character_value := '%H'
end
end
else
if yy_act <= 68 then
if yy_act = 67 then
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 305 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 305")
end
last_token := ERR_CHARACTER	-- Catch-all rules (no backing up)
else
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 306 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 306")
end
last_token := ERR_CHARACTER	-- Catch-all rules (no backing up)
end
else
if yy_act = 69 then
	yy_position := yy_position + 1
--|#line 310 "dadl_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'dadl_scanner.l' at line 310")
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

	yy_execute_eof_action (yy_sc: INTEGER)
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

	yy_nxt_template: SPECIAL [INTEGER]
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1032)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			    0,    8,    9,   10,    9,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,   23,   23,   24,
			   24,   24,   25,   26,   27,   28,   29,   30,   31,   31,
			   31,   31,   32,   31,   33,   31,   31,   31,   34,   31,
			   31,   35,   31,   31,   31,   31,   36,    8,   37,   38,
			    8,   39,   39,   39,   39,   40,   39,   41,   39,   39,
			   39,   39,   39,   42,   39,   39,   39,   43,   44,    8,
			    8,    8,    8,    8,    8,    8,    8,    8,   46,   62,
			   55,   47,   56,   46,   73,   55,   47,   56,   57,   66,
			   57,   67,   67,   67,   67,   67,   66,   73,   69,   69,

			   69,   69,   69,   73,   75,   68,   82,   83,   87,   87,
			   84,   73,   68,   87,   57,   87,   57,   75,   63,   88,
			   87,   76,   48,   75,  122,   73,  193,   48,   68,   82,
			   83,   75,   84,  195,  195,   68,   77,  180,   78,   78,
			   78,   78,   78,  168,   76,   75,   80,  122,   49,   50,
			   51,   52,   53,   49,   50,   51,   52,   53,  142,   77,
			   89,  142,   79,  108,  108,  108,  108,  108,   80,   73,
			   73,  138,   90,   90,   90,   91,   73,   92,   92,   92,
			   93,   93,  100,  123,   94,   94,   94,   87,  124,   75,
			   75,  101,  101,  101,  101,  101,   75,   66,  153,  109,

			  109,  109,  109,  109,  110,   87,  123,  114,   87,  111,
			  124,  111,   73,   68,  112,  112,  112,  112,  112,  137,
			  153,  102,   66,   87,  109,  109,  109,  109,  109,   73,
			  114,   73,   75,   87,  103,  104,   68,  105,   68,   73,
			  115,   87,  120,  120,  120,  120,  120,  154,  106,   75,
			  106,   75,  155,  136,  125,  126,  127,  128,  129,   75,
			  166,   68,   73,  115,   73,  141,  141,  141,  141,  121,
			  154,   91,   90,   90,   90,  155,   79,   78,   78,   78,
			   78,   78,   75,  166,   75,  135,   87,   90,   90,   90,
			  116,  121,   87,  185,  185,  185,  117,  130,  130,  130,

			   73,  167,  132,  118,  119,  131,  131,  131,  108,  108,
			  108,  108,  108,  116,  112,  112,  112,  112,  112,  117,
			   75,   96,  139,   87,  167,  118,  119,  133,  134,  134,
			  134,  134,  134,   66,   73,  140,  140,  140,  140,  140,
			  112,  112,  112,  112,  112,  139,   73,   73,   73,   68,
			   90,   90,   90,   87,   75,  107,   92,   92,   92,  106,
			  145,  145,  145,  145,  145,   73,   75,   75,   75,   87,
			  143,   99,   68,   73,  179,  152,  144,   73,  146,  146,
			  146,  146,  146,   60,   79,   75,  147,  147,  147,  147,
			  147,   87,  143,   75,   87,  184,  179,   75,  152,  144,

			  174,   73,   79,  133,  134,  134,  134,  134,  134,   73,
			   79,   73,  160,  160,  160,  160,  160,  184,   93,   93,
			  148,   75,  148,  174,  120,  120,  120,  120,  120,   75,
			   58,   75,   96,   94,   94,   94,  177,  177,  177,  177,
			  149,   87,  162,  150,  156,   72,  156,  151,   71,  157,
			  157,  157,  157,  157,   70,   90,   90,   90,   90,   90,
			   90,   73,   65,  149,   64,  162,  150,  158,   66,  151,
			  159,  159,  159,  159,  159,  145,  145,  145,  145,  145,
			   60,   75,   81,   81,   68,   81,   58,   81,  161,  146,
			  146,  146,  146,  146,   74,  221,  221,  147,  147,  147,

			  147,  147,   74,  169,  221,  169,  221,   68,  221,  221,
			  221,  161,   73,  170,  221,   74,  117,   74,  163,  163,
			  163,  163,  163,  221,   74,  164,  164,  164,  164,  164,
			   73,  221,   75,  221,  221,  221,  171,   74,  198,  117,
			  198,  221,   73,  165,  165,  165,  165,  165,  199,  221,
			   75,  157,  157,  157,  157,  157,  157,  157,  157,  157,
			  157,   66,   75,  159,  159,  159,  159,  159,  221,  221,
			  221,  200,  172,  202,  202,  202,  202,   68,  163,  163,
			  163,  163,  163,  164,  164,  164,  164,  164,  165,  165,
			  165,  165,  165,  221,  221,  172,  221,  221,   73,   74,

			   68,  173,  221,  221,   74,  221,   73,   74,  175,  175,
			  175,  175,  175,  176,  176,  176,  176,  176,   75,  221,
			  221,  221,   74,  173,  221,  221,   75,   74,  221,  221,
			   74,  187,  188,  187,  188,  178,  181,  181,  181,  181,
			  181,  182,  182,  182,  182,  182,  183,  186,  186,  186,
			  186,  186,  190,  190,  190,  190,  190,  178,  171,  171,
			  171,  171,  171,  221,  189,  221,  221,  221,  183,  191,
			  191,  191,  191,  191,  192,  192,  192,  192,  192,  194,
			  194,  194,  194,  194,  187,  221,  187,  221,  221,  192,
			  192,  192,  192,  192,  196,  196,  196,  196,  196,  197,

			  197,  197,  197,  197,  189,  189,  189,  189,  189,  201,
			  201,  201,  201,  201,  221,  221,  221,  189,  203,  203,
			  203,  203,  203,  204,  204,  204,  204,  204,  205,  205,
			  205,  205,  205,  206,  221,  206,  200,  200,  200,  200,
			  200,  221,  221,  207,  209,  209,  209,  209,  209,  210,
			  210,  210,  210,  211,  211,  211,  211,  211,  212,  212,
			  212,  212,  212,  221,  221,  221,  208,  213,  213,  213,
			  213,  213,  214,  215,  214,  215,  208,  208,  208,  208,
			  208,  217,  217,  217,  217,  217,  218,  218,  218,  218,
			  218,  219,  219,  219,  219,  219,  220,  220,  220,  220,

			  220,  214,  221,  214,  221,  216,  218,  218,  218,  218,
			  218,  216,  216,  216,  216,  216,   59,  221,   59,   59,
			   59,   59,   59,   59,  221,   59,   59,   59,  221,  221,
			  221,  221,  221,  221,  216,   45,   45,   45,   45,   45,
			   45,   45,   45,   45,   45,   45,   45,   54,   54,   54,
			   54,   54,   54,   54,   54,   54,   54,   54,   54,   61,
			  221,   61,   61,   61,   61,   61,   61,   61,   61,   61,
			   61,   74,  221,   74,   74,   74,   74,  221,   74,   85,
			   85,   85,   85,   85,   85,   85,   85,   85,   85,   86,
			  221,   86,   86,   86,   86,   86,   86,  221,   86,   86,

			   86,   95,   95,   95,   95,   95,   95,   95,   95,   95,
			   95,  221,   95,   97,   97,   97,   97,   97,   97,   97,
			   97,   97,   97,   98,  221,   98,   98,   98,   98,   98,
			   98,   98,   98,   98,   98,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  113,  113,  113,
			  113,  113,  113,  221,  113,    7,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221, yy_Dummy>>,
			1, 33, 1000)
		end

	yy_chk_template: SPECIAL [INTEGER]
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1032)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_chk_template_1 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    3,   14,
			    5,    3,    5,    4,   31,    6,    4,    6,    9,   23,
			    9,   23,   23,   23,   23,   23,   24,   32,   24,   24,

			   24,   24,   24,   33,   31,   23,   40,   41,   49,   50,
			   42,   35,   24,   51,   57,   52,   57,   32,   14,   48,
			   53,   32,    3,   33,   82,   34,  190,    4,   23,   40,
			   41,   35,   42,  193,  193,   24,   33,  175,   34,   34,
			   34,   34,   34,  158,   32,   34,   35,   82,    3,    3,
			    3,    3,    3,    4,    4,    4,    4,    4,  142,   33,
			   48,  113,   34,   66,   66,   66,   66,   66,   35,   73,
			   74,  105,   49,   49,   49,   50,   76,   51,   51,   51,
			   52,   52,   63,   83,   53,   53,   53,   90,   84,   73,
			   74,   63,   63,   63,   63,   63,   76,   67,  122,   67,

			   67,   67,   67,   67,   67,  126,   83,   76,   91,   68,
			   84,   68,   77,   67,   68,   68,   68,   68,   68,  104,
			  122,   63,   69,   92,   69,   69,   69,   69,   69,   79,
			   76,   80,   77,   93,   63,   63,   67,   63,   69,  116,
			   77,   94,   79,   79,   79,   79,   79,  123,  106,   79,
			  106,   80,  124,  103,   90,   90,   90,   90,   90,  116,
			  153,   69,  151,   77,   78,  110,  110,  110,  110,   80,
			  123,  126,   91,   91,   91,  124,  116,   78,   78,   78,
			   78,   78,  151,  153,   78,  102,  125,   92,   92,   92,
			   78,   80,  127,  180,  180,  180,   78,   93,   93,   93,

			  152,  154,  100,   78,   78,   94,   94,   94,  108,  108,
			  108,  108,  108,   78,  111,  111,  111,  111,  111,   78,
			  152,   95,  108,   86,  154,   78,   78,  101,  101,  101,
			  101,  101,  101,  109,  114,  109,  109,  109,  109,  109,
			  112,  112,  112,  112,  112,  108,  115,  117,  121,  109,
			  125,  125,  125,  128,  114,   65,  127,  127,  127,   64,
			  117,  117,  117,  117,  117,  118,  115,  117,  121,  129,
			  114,   61,  109,  119,  174,  121,  115,  161,  118,  118,
			  118,  118,  118,   59,  117,  118,  119,  119,  119,  119,
			  119,  130,  114,  119,  131,  179,  174,  161,  121,  115,

			  167,  183,  118,  134,  134,  134,  134,  134,  134,  144,
			  119,  120,  141,  141,  141,  141,  141,  179,  128,  128,
			  120,  183,  120,  167,  120,  120,  120,  120,  120,  144,
			   58,  120,   54,  129,  129,  129,  170,  170,  170,  170,
			  120,   45,  144,  120,  139,   30,  139,  120,   29,  139,
			  139,  139,  139,  139,   27,  130,  130,  130,  131,  131,
			  131,  143,   21,  120,   20,  144,  120,  140,  140,  120,
			  140,  140,  140,  140,  140,  145,  145,  145,  145,  145,
			   12,  143,  227,  227,  140,  227,   10,  227,  143,  146,
			  146,  146,  146,  146,  145,    7,    0,  147,  147,  147,

			  147,  147,  145,  160,    0,  160,    0,  140,    0,    0,
			    0,  143,  149,  160,    0,  146,  147,  145,  148,  148,
			  148,  148,  148,    0,  145,  149,  149,  149,  149,  149,
			  150,    0,  149,    0,    0,    0,  160,  146,  197,  147,
			  197,    0,  162,  150,  150,  150,  150,  150,  197,    0,
			  150,  156,  156,  156,  156,  156,  157,  157,  157,  157,
			  157,  159,  162,  159,  159,  159,  159,  159,    0,    0,
			    0,  197,  162,  199,  199,  199,  199,  159,  163,  163,
			  163,  163,  163,  164,  164,  164,  164,  164,  165,  165,
			  165,  165,  165,    0,    0,  162,    0,    0,  172,  164,

			  159,  163,    0,    0,  165,    0,  178,  165,  168,  168,
			  168,  168,  168,  169,  169,  169,  169,  169,  172,    0,
			    0,    0,  164,  163,    0,    0,  178,  165,    0,    0,
			  165,  182,  182,  182,  182,  172,  176,  176,  176,  176,
			  176,  177,  177,  177,  177,  177,  178,  181,  181,  181,
			  181,  181,  185,  185,  185,  185,  185,  172,  186,  186,
			  186,  186,  186,    0,  182,    0,    0,    0,  178,  187,
			  187,  187,  187,  187,  188,  188,  188,  188,  188,  191,
			  191,  191,  191,  191,  192,    0,  192,    0,    0,  192,
			  192,  192,  192,  192,  194,  194,  194,  194,  194,  195,

			  195,  195,  195,  195,  196,  196,  196,  196,  196,  198,
			  198,  198,  198,  198,    0,    0,    0,  192,  201,  201,
			  201,  201,  201,  202,  202,  202,  202,  202,  203,  203,
			  203,  203,  203,  204,    0,  204,  205,  205,  205,  205,
			  205,    0,    0,  204,  206,  206,  206,  206,  206,  207,
			  207,  207,  207,  209,  209,  209,  209,  209,  210,  210,
			  210,  210,  210,    0,    0,    0,  204,  211,  211,  211,
			  211,  211,  212,  212,  212,  212,  213,  213,  213,  213,
			  213,  214,  214,  214,  214,  214,  215,  215,  215,  215,
			  215,  217,  217,  217,  217,  217,  219,  219,  219,  219,

			  219,  218,    0,  218,    0,  212,  218,  218,  218,  218,
			  218,  220,  220,  220,  220,  220,  224,    0,  224,  224,
			  224,  224,  224,  224,    0,  224,  224,  224,    0,    0,
			    0,    0,    0,    0,  218,  222,  222,  222,  222,  222,
			  222,  222,  222,  222,  222,  222,  222,  223,  223,  223,
			  223,  223,  223,  223,  223,  223,  223,  223,  223,  225,
			    0,  225,  225,  225,  225,  225,  225,  225,  225,  225,
			  225,  226,    0,  226,  226,  226,  226,    0,  226,  228,
			  228,  228,  228,  228,  228,  228,  228,  228,  228,  229,
			    0,  229,  229,  229,  229,  229,  229,    0,  229,  229,

			  229,  230,  230,  230,  230,  230,  230,  230,  230,  230,
			  230,    0,  230,  231,  231,  231,  231,  231,  231,  231,
			  231,  231,  231,  232,    0,  232,  232,  232,  232,  232,
			  232,  232,  232,  232,  232,  233,  233,  233,  233,  233,
			  233,  233,  233,  233,  233,  233,  233,  234,  234,  234,
			  234,  234,  234,    0,  234,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221, yy_Dummy>>,
			1, 33, 1000)
		end

	yy_base_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   75,   80,   13,   18,  495,  955,   86,
			  483,  955,  474,  955,   71,  955,  955,  955,  955,  955,
			  450,  447,  955,   74,   81,  955,  955,  429,  955,  423,
			  418,   80,   93,   99,  121,  107,  955,  955,  955,    0,
			   78,   70,   71,    0,  955,  435,  955,  955,  113,  102,
			  103,  107,  109,  114,  363,    0,  955,  112,  427,  377,
			  955,  363,    0,  174,  356,  340,  146,  182,  197,  207,
			  955,  955,  955,  165,  166,    0,  172,  208,  260,  225,
			  227,    0,   89,  151,  146,    0,  317,  955,  955,  955,
			  181,  202,  217,  227,  235,  252,  955,    0,  955,  955,

			  294,  311,  277,  245,  211,  163,  246,  955,  291,  318,
			  248,  297,  323,  135,  330,  342,  235,  343,  361,  369,
			  407,  344,  158,  213,  221,  280,  199,  286,  347,  363,
			  385,  388,  955,  955,  387,  955,  955,  955,  955,  432,
			  453,  395,  132,  457,  405,  458,  472,  480,  501,  508,
			  526,  258,  296,  229,  264,    0,  534,  539,  126,  546,
			  491,  373,  538,  561,  566,  571,    0,  366,  591,  596,
			  419,  955,  594,  955,  333,  123,  619,  624,  602,  351,
			  276,  630,  619,  397,    0,  635,  641,  652,  657,  955,
			   85,  662,  672,  116,  677,  682,  687,  526,  692,  556,

			  955,  701,  706,  711,  721,  719,  727,  732,  955,  736,
			  741,  750,  760,  759,  764,  769,  955,  774,  789,  779,
			  794,  955,  834,  846,  815,  858,  868,  477,  878,  888,
			  900,  912,  922,  934,  944, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,  221,    1,  222,  222,  223,  223,  221,  221,  221,
			  221,  221,  224,  221,  225,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  226,  226,  226,  226,  226,  221,  221,  221,  227,
			  227,  227,  227,  228,  221,  229,  221,  221,  221,  229,
			  229,  229,  229,  229,  230,  231,  221,  221,  221,  224,
			  221,  232,  232,  232,  233,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  226,  234,  226,  226,  226,  226,
			  226,  227,  227,  227,  227,  228,  229,  221,  221,  221,
			  229,  229,  229,  229,  229,  230,  221,  231,  221,  221,

			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  234,  226,  226,  226,  226,  226,  226,
			  226,  226,  227,  227,  227,  229,  229,  229,  229,  229,
			  229,  229,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  234,  226,  226,   78,  145,  145,  221,  226,
			  226,  226,  226,  227,  227,  227,  221,  221,  221,  221,
			  221,  226,  226,  221,  120,  120,  227,  227,  221,  221,
			  221,  221,  226,  221,  227,  221,  221,  221,  226,  227,
			  221,  221,  221,  226,  227,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,

			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,    0,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    5,    6,    1,    7,    1,    1,    8,
			    9,   10,   11,   12,   13,   14,   15,   16,   17,   17,
			   18,   19,   20,   20,   20,   21,   21,   21,   22,   23,
			   24,   25,   26,   27,    1,   28,   29,   29,   30,   31,
			   32,   29,   33,   34,   29,   29,   35,   36,   37,   29,
			   38,   29,   39,   40,   41,   42,   29,   43,   29,   44,
			   45,   46,   47,   48,   49,   50,    1,   51,   52,   52,

			   53,   54,   55,   52,   56,   57,   52,   52,   58,   59,
			   60,   52,   52,   52,   61,   62,   63,   64,   52,   65,
			   52,   66,   52,   67,   68,   69,    1,    1,   70,   70,
			   70,   70,   70,   70,   70,   70,   70,   70,   70,   70,
			   70,   70,   70,   70,   71,   71,   71,   71,   71,   71,
			   71,   71,   71,   71,   71,   71,   71,   71,   71,   71,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
			   72,   72,    1,    1,   73,   73,   73,   73,   73,   73,

			   73,   73,   73,   73,   73,   73,   73,   73,   73,   73,
			   73,   73,   73,   73,   73,   73,   73,   73,   73,   73,
			   73,   73,   73,   73,   74,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   76,   77,   77,   77,   77,   77,   77,   77,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    2,    3,    1,    1,    1,    1,    1,
			    1,    1,    1,    4,    1,    1,    1,    5,    5,    5,
			    5,    6,    1,    1,    7,    1,    4,    1,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    8,    1,    9,    1,    1,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,   10,   11,    1,   12,
			    1,    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,   71,   69,    1,
			    2,   14,   53,   17,   69,   15,   16,    7,    6,   12,
			    5,   10,    8,   48,   48,   13,   11,   26,   23,   27,
			   19,   42,   42,   42,   41,   42,   21,   22,    9,   44,
			   44,   44,   44,   45,   20,   57,   58,   59,   60,   57,
			   57,   57,   57,   57,   70,   46,   47,    1,    2,   53,
			   52,   67,   67,   67,    3,   28,    0,   48,    0,   48,
			   25,   24,   18,    0,   42,    0,   42,   42,   42,   40,
			   42,   44,   44,   44,   44,   45,   57,   59,   55,   54,
			   56,   57,   57,   57,   57,    0,   47,   46,   67,   61,

			   67,   67,   67,   67,   67,   67,    4,   29,   50,   48,
			    0,    0,   49,    0,   42,   42,   41,   41,   41,   41,
			   42,   42,   44,   44,   44,   57,   57,   57,   57,   57,
			   57,   57,   65,   68,   68,   66,   62,   63,   64,    0,
			   48,    0,   43,   42,   42,   42,   42,   42,    0,   40,
			   40,   40,   30,   44,   44,   30,    0,   51,    0,   48,
			   37,   31,   42,    0,   42,   42,   31,   44,    0,    0,
			    0,   37,   42,   40,   44,   39,    0,    0,   42,   44,
			    0,    0,   36,   32,   32,    0,    0,    0,    0,   36,
			   38,    0,   36,    0,    0,    0,    0,   35,    0,    0,

			   35,    0,    0,    0,   34,    0,    0,    0,   34,    0,
			    0,    0,   33,    0,    0,    0,   33,    0,   33,    0,
			    0,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER = 955
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER = 221
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER = 222
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER = 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN = false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN = false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN = false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER = 70
			-- Number of rules

	yyEnd_of_buffer: INTEGER = 71
			-- End of buffer rule code

	yyLine_used: BOOLEAN = false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN = true
			-- Is `position' used?

	INITIAL: INTEGER = 0
	IN_STR: INTEGER = 1
	IN_CADL_BLOCK: INTEGER = 2
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

	block_depth: INTEGER

feature {NONE} -- Initialization

	make
			-- Create a new scanner.
		do
			make_compressed_scanner_skeleton
			create in_buffer.make (Init_buffer_size)
			in_lineno := 1
		end

feature -- Initialization

	reset
			-- Reset scanner before scanning next input.
		do
			reset_compressed_scanner_skeleton
			in_lineno := 1
			in_buffer.wipe_out
			validator_reset
		end

	validate
		do
		end

feature -- Access

	in_buffer: STRING
			-- Buffer for lexical tokens

	in_lineno: INTEGER
			-- Current line number

	is_operator: BOOLEAN
			-- Parsing an operator declaration?

feature {NONE} -- Constants

	Init_buffer_size: INTEGER = 256
				-- Initial size for `in_buffer'

invariant
	in_buffer_not_void: in_buffer /= Void

end
