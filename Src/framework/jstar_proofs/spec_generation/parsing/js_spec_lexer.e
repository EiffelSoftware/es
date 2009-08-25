class JS_SPEC_LEXER

inherit
    YY_COMPRESSED_SCANNER_SKELETON
    
    JS_SPEC_TOKENS
    export {NONE} all end
    
create
    make

feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (sc = INITIAL)
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
if yy_act <= 14 then
if yy_act <= 7 then
if yy_act <= 4 then
if yy_act <= 2 then
if yy_act = 1 then
--|#line 22 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 22")
end
-- Whitespace. Do nothing.
else
--|#line 24 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 24")
end
 last_token := BANG 
end
else
if yy_act = 3 then
--|#line 25 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 25")
end
 last_token := CMPLE; last_string_value := text 
else
--|#line 26 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 26")
end
 last_token := CMPLT; last_string_value := text 
end
end
else
if yy_act <= 6 then
if yy_act = 5 then
--|#line 27 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 27")
end
 last_token := CMPGE; last_string_value := text 
else
--|#line 28 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 28")
end
 last_token := CMPGT; last_string_value := text 
end
else
--|#line 29 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 29")
end
 last_token := CMPNE; last_string_value := text 
end
end
else
if yy_act <= 11 then
if yy_act <= 9 then
if yy_act = 8 then
--|#line 30 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 30")
end
 last_token := COLON 
else
--|#line 31 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 31")
end
 last_token := COMMA 
end
else
if yy_act = 10 then
--|#line 32 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 32")
end
 last_token := DOT 
else
--|#line 33 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 33")
end
 last_token := EQUALS; last_string_value := text 
end
end
else
if yy_act <= 13 then
if yy_act = 12 then
--|#line 34 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 34")
end
 last_token := FALSE_TOK 
else
--|#line 35 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 35")
end
 last_token := TRUE_TOK 
end
else
--|#line 36 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 36")
end
 last_token := IDENTIFIER; last_string_value := text 
end
end
end
else
if yy_act <= 21 then
if yy_act <= 18 then
if yy_act <= 16 then
if yy_act = 15 then
--|#line 37 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 37")
end
 last_token := INTEGER_CONSTANT; last_string_value := text 
else
--|#line 38 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 38")
end
 last_token := L_BRACE 
end
else
if yy_act = 17 then
--|#line 39 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 39")
end
 last_token := L_BRACKET 
else
--|#line 40 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 40")
end
 last_token := L_PAREN 
end
end
else
if yy_act <= 20 then
if yy_act = 19 then
--|#line 41 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 41")
end
 last_token := MAPSTO 
else
--|#line 42 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 42")
end
 last_token := MULT 
end
else
--|#line 43 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 43")
end
 last_token := OROR 
end
end
else
if yy_act <= 25 then
if yy_act <= 23 then
if yy_act = 22 then
--|#line 44 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 44")
end
 last_token := QUESTIONMARK 
else
--|#line 45 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 45")
end
 last_token := R_BRACE 
end
else
if yy_act = 24 then
--|#line 46 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 46")
end
 last_token := R_BRACKET 
else
--|#line 47 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 47")
end
 last_token := R_PAREN 
end
end
else
if yy_act <= 27 then
if yy_act = 26 then
--|#line 48 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 48")
end
 last_token := SEMICOLON 
else
--|#line 51 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 51")
end
 last_token := ERROR_TOK 
end
else
--|#line 0 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 0")
end
default_action
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			terminate
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    4,    5,    6,    7,    4,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   23,   24,   25,   26,   22,   22,   22,   22,   22,
			   22,   27,   28,   29,   38,   35,   45,   44,   43,   42,
			   41,   40,   31,   30,   37,   36,   34,   33,   31,   32,
			   31,   30,   46,   46,   46,   46,   39,    3,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,   28,   47,   43,   41,   40,   38,
			   37,   36,   31,   30,   24,   23,   20,   18,   15,   14,
			   12,    5,    3,    0,    0,    0,   28,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   52,   57,   49,   57,   57,   57,   57,
			   57,   57,   37,   57,   32,   35,   57,   57,   30,   57,
			   29,   57,    0,   20,   16,   57,   57,   57,   24,   57,
			   41,   29,   57,   57,   57,    0,   14,   10,   21,   57,
			    9,   11,   57,   10,    0,    0,   57,   33, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   46,    1,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   46,   46,   46,   46,   46,
			   46,   46,   47,   47,   47,   46,   46,   46,   46,   46,
			   46,   46,   46,   46,   46,   47,   47,   47,   46,   46,
			   47,   47,   46,   47,   47,   47,    0,   46, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    4,    1,    1,    5,    1,    1,    1,
			    6,    7,    8,    1,    9,   10,   11,   12,   13,   13,
			   13,   13,   13,   13,   13,   13,   13,   13,   14,   15,
			   16,   17,   18,   19,    1,   20,   20,   20,   20,   20,
			   21,   20,   20,   20,   20,   20,   20,   20,   20,   20,
			   20,   20,   20,   20,   22,   20,   20,   20,   20,   20,
			   20,   23,    1,   24,    1,   20,    1,   25,   20,   20,

			   20,   26,   20,   20,   20,   20,   20,   20,   27,   20,
			   20,   20,   20,   20,   28,   29,   20,   30,   20,   20,
			   20,   20,   20,   31,   32,   33,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    2,    1,    1,    1,    1,
			    1,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    2,    2,    2,    1,    1,    2,    2,    2,    2,    2,
			    2,    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   29,   27,    1,   28,    2,   18,   25,
			   20,    9,   27,   10,   27,   15,    8,   26,    4,   11,
			    6,   22,   14,   14,   14,   17,   24,   16,   27,   23,
			    1,   15,    7,    3,    5,   14,   14,   14,    0,   21,
			   14,   14,   19,   14,   13,   12,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 57
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 46
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 47
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

	yyNb_rules: INTEGER is 28
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 29
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
			-- Start condition codes

feature -- User-defined features



end
