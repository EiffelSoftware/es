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
if yy_act <= 13 then
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
 last_token := CMPLT 
end
else
if yy_act = 3 then
--|#line 25 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 25")
end
 last_token := CMPGT 
else
--|#line 26 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 26")
end
 last_token := CMPNE 
end
end
else
if yy_act <= 6 then
if yy_act = 5 then
--|#line 27 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 27")
end
 last_token := COLON 
else
--|#line 28 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 28")
end
 last_token := COMMA 
end
else
--|#line 29 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 29")
end
 last_token := DOT 
end
end
else
if yy_act <= 10 then
if yy_act <= 9 then
if yy_act = 8 then
--|#line 30 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 30")
end
 last_token := EQUALS 
else
--|#line 31 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 31")
end
 last_token := IDENTIFIER; last_string_value := text 
end
else
--|#line 32 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 32")
end
 last_token := INTEGER_CONSTANT; last_string_value := text 
end
else
if yy_act <= 12 then
if yy_act = 11 then
--|#line 33 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 33")
end
 last_token := L_BRACE 
else
--|#line 34 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 34")
end
 last_token := L_BRACKET 
end
else
--|#line 35 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 35")
end
 last_token := L_PAREN 
end
end
end
else
if yy_act <= 19 then
if yy_act <= 16 then
if yy_act <= 15 then
if yy_act = 14 then
--|#line 36 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 36")
end
 last_token := MAPSTO 
else
--|#line 37 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 37")
end
 last_token := MULT 
end
else
--|#line 38 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 38")
end
 last_token := OR_TOK 
end
else
if yy_act <= 18 then
if yy_act = 17 then
--|#line 39 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 39")
end
 last_token := OROR 
else
--|#line 40 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 40")
end
 last_token := QUESTIONMARK 
end
else
--|#line 41 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 41")
end
 last_token := R_BRACE 
end
end
else
if yy_act <= 22 then
if yy_act <= 21 then
if yy_act = 20 then
--|#line 42 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 42")
end
 last_token := R_BRACKET 
else
--|#line 43 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 43")
end
 last_token := R_PAREN 
end
else
--|#line 44 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 44")
end
 last_token := SEMICOLON 
end
else
if yy_act <= 24 then
if yy_act = 23 then
--|#line 46 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 46")
end
 last_token := WAND 
else
--|#line 48 "lexer.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'lexer.l' at line 48")
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
			    0,    4,    5,    6,    4,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   23,   24,   25,   26,   28,   31,   34,   32,   31,
			   29,   29,   27,   29,   31,   30,   27,   31,   35,   35,
			   35,   31,   33,   35,   31,    3,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,   11,   21,   32,   25,   31,
			   11,   29,   27,   14,   21,   13,    5,   31,    3,    0,
			    0,   21,   25,    0,   31,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   38,   45,   34,   45,   45,   45,   45,
			   45,   18,   45,   19,   21,   45,   45,   45,   45,   45,
			   45,   22,   45,   45,   45,   19,   45,   30,   45,   19,
			   45,   25,   10,   45,   45,   45, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   35,    1,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,    0, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    1,    1,    1,    4,    1,    1,    1,
			    5,    6,    7,    1,    8,    9,   10,   11,   12,   12,
			   12,   12,   12,   12,   12,   12,   12,   12,   13,   14,
			   15,   16,   17,   18,    1,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   20,    1,   21,    1,   19,    1,   19,   19,   19,

			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
			   19,   19,   19,   22,   23,   24,    1,    1,    1,    1,
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
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   26,   24,    1,   25,   13,   21,   15,
			    6,   24,    7,   24,   10,    5,   22,    2,    8,    3,
			   18,    9,   12,   20,   11,   16,   19,    1,   23,   10,
			    4,    9,    0,   17,   14,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 45
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 35
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 36
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

	yyNb_rules: INTEGER is 25
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 26
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
			-- Start condition codes

feature -- User-defined features



end