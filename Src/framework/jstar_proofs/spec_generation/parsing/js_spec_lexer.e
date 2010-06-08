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
if yy_act <= 16 then
if yy_act <= 8 then
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
if yy_act = 7 then
--|#line 29 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 29")
end
 last_token := CMPNE; last_string_value := text 
else
--|#line 30 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 30")
end
 last_token := COLON 
end
end
end
else
if yy_act <= 12 then
if yy_act <= 10 then
if yy_act = 9 then
--|#line 31 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 31")
end
 last_token := COMMA 
else
--|#line 32 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 32")
end
 last_token := DOT 
end
else
if yy_act = 11 then
--|#line 33 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 33")
end
 last_token := EQUALS; last_string_value := text 
else
--|#line 34 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 34")
end
 last_token := FALSE_TOK 
end
end
else
if yy_act <= 14 then
if yy_act = 13 then
--|#line 35 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 35")
end
 last_token := TRUE_TOK 
else
--|#line 36 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 36")
end
 last_token := WHERE 
end
else
if yy_act = 15 then
--|#line 37 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 37")
end
 last_token := IDENTIFIER; last_string_value := text 
else
--|#line 38 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 38")
end
 last_token := IFF 
end
end
end
end
else
if yy_act <= 24 then
if yy_act <= 20 then
if yy_act <= 18 then
if yy_act = 17 then
--|#line 39 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 39")
end
 last_token := IMP 
else
--|#line 40 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 40")
end
 last_token := INTEGER_CONSTANT; last_string_value := text 
end
else
if yy_act = 19 then
--|#line 41 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 41")
end
 last_token := L_BRACE 
else
--|#line 42 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 42")
end
 last_token := L_BRACKET 
end
end
else
if yy_act <= 22 then
if yy_act = 21 then
--|#line 43 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 43")
end
 last_token := L_PAREN 
else
--|#line 44 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 44")
end
 last_token := MAPSTO 
end
else
if yy_act = 23 then
--|#line 45 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 45")
end
 last_token := MULT 
else
--|#line 46 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 46")
end
 last_token := OROR 
end
end
end
else
if yy_act <= 28 then
if yy_act <= 26 then
if yy_act = 25 then
--|#line 47 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 47")
end
 last_token := QUESTIONMARK 
else
--|#line 48 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 48")
end
 last_token := R_BRACE 
end
else
if yy_act = 27 then
--|#line 49 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 49")
end
 last_token := R_BRACKET 
else
--|#line 50 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 50")
end
 last_token := R_PAREN 
end
end
else
if yy_act <= 30 then
if yy_act = 29 then
--|#line 51 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 51")
end
 last_token := SEMICOLON 
else
--|#line 54 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 54")
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
			   22,   23,   24,   23,   25,   26,   27,   23,   23,   23,
			   23,   23,   23,   23,   28,   29,   30,   31,   32,   32,
			   32,   32,   33,   43,   33,   32,   32,   32,   32,   32,
			   32,   33,   39,   56,   55,   54,   53,   52,   51,   50,
			   49,   48,   47,   46,   45,   34,   42,   41,   44,   40,
			   38,   37,   36,   34,   35,   34,   57,    3,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    5,    5,
			    6,    6,    5,   30,    6,    8,    8,   32,   32,   33,
			   33,   32,   58,   54,   52,   49,   48,   47,   45,   43,
			   42,   41,   40,   37,   36,   34,   28,   25,   30,   24,
			   21,   20,   19,   16,   15,   13,    3,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   76,   77,   36,   38,   77,   22,   77,
			   77,   77,   77,   61,   77,   56,   59,   77,   77,   54,
			   53,   52,   77,    0,   42,   36,   77,   77,   37,   77,
			   32,   77,   45,   26,   51,   77,   46,   44,   77,    0,
			   32,   28,   32,   40,   77,   39,   77,   25,   28,   24,
			   77,   77,   26,    0,   25,    0,    0,   77,   50, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   57,    1,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   58,   58,   58,   57,   57,   58,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   58,
			   58,   58,   58,   57,   57,   57,   57,   58,   58,   58,
			   57,   57,   58,   58,   58,   58,   58,    0,   57, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    4,    1,    1,    5,    6,    1,    1,
			    7,    8,    9,    1,   10,   11,   12,   13,   14,   14,
			   14,   14,   14,   14,   14,   14,   14,   14,   15,   16,
			   17,   18,   19,   20,    1,   21,   21,   21,   21,   21,
			   22,   21,   21,   21,   21,   21,   21,   21,   23,   21,
			   21,   21,   21,   21,   24,   21,   21,   21,   21,   21,
			   21,   25,    1,   26,    1,   21,    1,   27,   21,   21,

			   21,   28,   21,   21,   29,   21,   21,   21,   30,   21,
			   21,   21,   21,   21,   31,   32,   21,   33,   21,   34,
			   21,   21,   21,   35,   36,   37,    1,    1,    1,    1,
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
			    1,    1,    1,    1,    2,    1,    1,    1,    1,    1,
			    1,    2,    2,    2,    2,    1,    1,    2,    2,    2,
			    2,    2,    2,    2,    2,    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   32,   30,    1,    1,    2,   30,   21,
			   28,   23,    9,   30,   10,   30,   18,    8,   29,    4,
			   11,    6,   25,   15,   15,   15,   20,   27,   15,   19,
			   30,   26,    1,    0,   18,    7,    3,    0,    5,   15,
			   15,   15,   15,    0,   24,    0,   17,   15,   15,   15,
			   22,   16,   15,   13,   15,   12,   14,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 77
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 57
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 58
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

	yyNb_rules: INTEGER is 31
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 32
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
			-- Start condition codes

feature -- User-defined features



end
