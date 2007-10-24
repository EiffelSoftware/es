indexing
	description:"Scanners for Eiffel parsers"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author:     "Arnaud PICHERY from an Eric Bezault model"
	date:       "$Date$"
	revision:   "$Revision$"

class EDITOR_EIFFEL_SCANNER

inherit

	EDITOR_SCANNER

	EDITOR_EIFFEL_SCANNER_SKELETON	

create
	make

feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= VERBATIM_STR1)
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
			yy_acclist := yy_acclist_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
			inspect yy_act
when 1 then
--|#line 35 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 35")
end
-- Ignore carriage return
when 2 then
--|#line 36 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 36")
end

					create {EDITOR_TOKEN_SPACE} curr_token.make(text_count)
					update_token_list
					
when 3 then
--|#line 40 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 40")
end

					if not in_comments then
						create {EDITOR_TOKEN_TABULATION} curr_token.make(text_count)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 4 then
--|#line 48 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 48")
end

					from i_ := 1 until i_ > text_count loop
						create {EDITOR_TOKEN_EOL} curr_token.make
						update_token_list
						i_ := i_ + 1
					end
					in_comments := False
					
when 5 then
--|#line 60 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 60")
end
 
						-- comments
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					in_comments := True	
					update_token_list					
				
when 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 then
--|#line 69 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 69")
end

						-- Symbols
					if not in_comments then
						create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 then
--|#line 90 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 90")
end
 
						-- Operator Symbol
					if not in_comments then
						create {EDITOR_TOKEN_OPERATOR} curr_token.make(text)					
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104 then
--|#line 120 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 120")
end

										-- Keyword
										if not in_comments then
											create {EDITOR_TOKEN_KEYWORD} curr_token.make(text)
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 105 then
--|#line 200 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 200")
end

										if not in_comments then
											if is_current_group_valid then
												tmp_classes := current_group.class_by_name (text, True)
												if not tmp_classes.is_empty then
													create {EDITOR_TOKEN_CLASS} curr_token.make (text)
													curr_token.set_pebble (stone_of_class (tmp_classes.first))
												else
													create {EDITOR_TOKEN_TEXT} curr_token.make (text)
												end
											else
												create {EDITOR_TOKEN_TEXT} curr_token.make (text)
											end							
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 106 then
--|#line 220 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 220")
end

										if not in_comments then
												create {EDITOR_TOKEN_TEXT} curr_token.make(text)											
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 107 then
--|#line 232 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 232")
end

										if not in_comments then
											create {EDITOR_TOKEN_TEXT} curr_token.make(text)										
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129 then
--|#line 246 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 246")
end

					if not in_comments then
						create {EDITOR_TOKEN_CHARACTER} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 130 then
--|#line 276 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 276")
end

					if not in_comments then
						code_ := text_substring (4, text_count - 2).to_integer
						if code_ > {CHARACTER}.Max_value then
							-- Character error. Consedered as text.
							create {EDITOR_TOKEN_TEXT} curr_token.make(text)
						else
							create {EDITOR_TOKEN_CHARACTER} curr_token.make(text)
						end						
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 131, 132 then
--|#line 291 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 291")
end

					-- Character error. Catch-all rules (no backing up)
					if not in_comments then
						create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 133 then
--|#line 314 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 314")
end

 				if not in_comments then
						-- Verbatim string opener.
					create {EDITOR_TOKEN_STRING} curr_token.make(text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					update_token_list
				end
			
when 134 then
--|#line 328 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 328")
end

				if not in_comments then
						-- Verbatim string opener.
					create {EDITOR_TOKEN_STRING} curr_token.make(text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					update_token_list
				end				
			
when 135 then
--|#line 343 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 343")
end
-- Ignore carriage return
when 136 then
--|#line 344 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 344")
end

							-- Verbatim string closer, possibly.
						create {EDITOR_TOKEN_STRING} curr_token.make(text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 137 then
--|#line 353 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 353")
end

							-- Verbatim string closer, possibly.
						create {EDITOR_TOKEN_STRING} curr_token.make(text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 138 then
--|#line 362 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 362")
end

						create {EDITOR_TOKEN_SPACE} curr_token.make(text_count)
						update_token_list						
					
when 139 then
--|#line 367 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 367")
end
						
						create {EDITOR_TOKEN_TABULATION} curr_token.make(text_count)
						update_token_list						
					
when 140 then
--|#line 372 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 372")
end

						from i_ := 1 until i_ > text_count loop
							create {EDITOR_TOKEN_EOL} curr_token.make
							update_token_list
							i_ := i_ + 1
						end						
					
when 141 then
--|#line 380 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 380")
end

						create {EDITOR_TOKEN_STRING} curr_token.make(text)
						update_token_list
					
when 142, 143 then
--|#line 386 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 386")
end

					-- Eiffel String
					if not in_comments then						
						create {EDITOR_TOKEN_STRING} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 144 then
--|#line 399 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 399")
end

					-- Eiffel Bit
					if not in_comments then
						create {EDITOR_TOKEN_NUMBER} curr_token.make(text)						
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 145, 146, 147, 148 then
--|#line 411 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 411")
end

						-- Eiffel Integer
						if not in_comments then
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 149, 150, 151, 152 then
--|#line 425 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 425")
end

						-- Bad Eiffel Integer
						if not in_comments then
							create {EDITOR_TOKEN_TEXT} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 153 then
	yy_end := yy_end - 1
--|#line 440 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 440")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 154, 155 then
--|#line 441 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 441")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 156 then
	yy_end := yy_end - 1
--|#line 443 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 443")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 157, 158 then
--|#line 444 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 444")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 159 then
--|#line 461 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 461")
end

					create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					update_token_list
					
when 160 then
--|#line 469 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 469")
end

					-- Error (considered as text)
				if not in_comments then
					create {EDITOR_TOKEN_TEXT} curr_token.make(text)
				else
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
				end
				update_token_list
				
when 161 then
--|#line 0 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 0")
end
default_action
			else
				last_token := yyError_token
				fatal_error ("fatal scanner internal error: no action found")
			end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0, 1 then
--|#line 0 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 0")
end
terminate
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 3067)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   27,   28,   29,   30,   31,   32,   33,
			   34,   35,   36,   37,   38,   39,   40,   40,   41,   40,
			   40,   42,   43,   44,   45,   46,   40,   47,   48,   49,
			   50,   51,   52,   53,   40,   40,   54,   55,   56,   57,
			    6,   58,   59,   60,   61,   62,   63,   64,   65,   65,
			   66,   65,   65,   67,   68,   69,   70,   71,   65,   72,
			   73,   74,   75,   76,   77,   78,   65,   65,   79,   80,
			   82,   83,   84,   85,   82,   83,   84,   85,   94,   94,

			  103,   95,   95,  101,  102,  105,  107,  106,  106,  106,
			  106,  104,  644,  109,  108,  110,  110,  111,  111,  109,
			  124,  110,  110,  111,  111,  823,  113,  114,  119,  120,
			  135,  109,  117,  111,  111,  111,  111,  121,  122,  124,
			  175,  545,  150,  177,  151,  538,   86,   96,  115,  637,
			   86,  427,  129,  425,  152,  116,  206,  124,  113,  114,
			  215,  116,  135,  215,  117,  222,   94,  263,  212,   95,
			  423,  129,  175,  116,  153,  177,  154,   87,  823,   97,
			  115,   87,  124,  124,  124,  124,  155,  188,  207,  129,
			  427,  124,  124,  124,  124,  124,  124,  124,  125,  124,

			  124,  124,  124,  126,  124,  127,  124,  124,  124,  124,
			  128,  124,  124,  124,  124,  124,  124,  124,   94,  189,
			  263,  385,  124,  129,  129,  129,  129,  129,  129,  129,
			  130,  129,  129,  129,  129,  131,  129,  132,  129,  129,
			  129,  129,  133,  129,  129,  129,  129,  129,  129,  129,
			  124,  124,  124,  124,  187,  189,  207,  209,  425,  124,
			  124,  124,  124,  124,  124,  124,  124,  124,  134,  124,
			  124,  124,  124,  124,  124,  124,  124,  124,  124,  124,
			  124,  124,  124,  124,  124,  124,  187,  189,  207,  209,
			  124,  129,  129,  129,  129,  129,  129,  129,  129,  129,

			  135,  129,  129,  129,  129,  129,  129,  129,  129,  129,
			  129,  129,  129,  129,  129,  129,  129,  129,  136,  124,
			  146,  170,  137,  274,  124,  138,  275,  171,  139,  156,
			  147,  140,  162,  157,  124,  124,  124,  124,  124,  163,
			  164,  423,  174,  186,  176,  165,  158,  273,  410,  279,
			  141,  129,  148,  172,  142,  276,  129,  143,  277,  173,
			  144,  159,  149,  145,  166,  160,  129,  129,  129,  129,
			  129,  167,  168,  178,  175,  187,  177,  169,  161,  273,
			  124,  279,  190,  179,  409,  180,  124,  202,  124,  181,
			  194,  124,  281,  198,  192,  124,  124,  191,  199,  130,

			  195,  203,  208,  141,  131,  182,  132,  142,  283,  193,
			  143,  133,  129,  144,  192,  183,  145,  184,  129,  204,
			  129,  185,  196,  129,  281,  200,  192,  129,  129,  193,
			  201,  130,  197,  205,  209,  141,  131,  148,  132,  142,
			  283,  193,  143,  133,  153,  144,  154,  149,  145,  159,
			  166,  196,  182,  160,  172,  285,  155,  167,  168,  204,
			  173,  197,  183,  169,  184,  200,  161,  287,  185,  148,
			  201,  408,  213,  205,  214,  214,  153,   94,  154,  149,
			   95,  159,  166,  196,  182,  160,  172,  285,  155,  167,
			  168,  204,  173,  197,  183,  169,  184,  200,  161,  287,

			  185,  214,  201,  218,  214,  205,  214,  216,  214,  221,
			  216,   94,  223,  124,   95,  212,  229,  386,  229,  229,
			   95,   94,  289,  280,   95,  407,   96,  406,  215,  291,
			  230,   94,  230,  230,  388,   94,  405,  404,   95,  255,
			  255,  255,  255,  264,  264,  129,  259,  259,  259,  259,
			  266,  266,  266,  256,  289,  281,  403,  219,   97,  216,
			  260,  291,  215,  109,  293,  261,  261,  262,  262,  109,
			   96,  262,  262,  262,  262,  278,  117,  124,  272,  257,
			  124,  402,  124,  263,   96,  256,  264,  264,  220,  299,
			  263,  284,  260,  216,  225,  124,  293,  226,   99,   99,

			   99,  386,   97,  401,  385,  116,  227,  279,  117,  129,
			  273,  116,  129,   99,  129,   99,   97,   99,   99,  228,
			  400,  299,   99,  285,   99,  309,  422,  129,   99,  124,
			   99,  399,  823,   99,   99,   99,   99,   99,   99,  233,
			  282,  398,  234,  235,  236,  237,  394,  394,  394,  394,
			  823,  238,  270,  270,  270,  270,  276,  309,  239,  277,
			  240,  129,  241,  242,  243,  244,  397,  245,  286,  246,
			  396,  395,  283,  247,  263,  248,  124,  393,  249,  250,
			  251,  252,  253,  254,  268,  268,  268,  268,  276,  290,
			  392,  277,  271,  124,  268,  268,  268,  268,  268,  268,

			  287,  124,  124,  294,  124,  296,  288,  295,  129,  297,
			  124,  292,  124,  391,  298,  124,  306,  300,  308,  304,
			  307,  291,  124,  305,  263,  129,  268,  268,  268,  268,
			  268,  268,  301,  129,  129,  296,  129,  296,  289,  297,
			  311,  297,  129,  293,  129,  302,  299,  129,  306,  302,
			  309,  306,  307,  310,  129,  307,  124,  313,  124,  124,
			  303,  124,  312,  316,  303,  317,  314,  318,  124,  124,
			  315,  390,  311,  389,  124,  217,  326,  302,  319,  384,
			  327,  320,  332,  333,  330,  311,  383,  124,  129,  313,
			  129,  129,  303,  129,  313,  321,  331,  322,  315,  323,

			  129,  129,  315,  321,  335,  322,  129,  323,  327,  124,
			  324,  328,  327,  325,  333,  333,  330,  124,  324,  129,
			  334,  325,  124,  329,  338,  340,  124,  337,  331,  124,
			  339,  124,  336,  341,  342,  321,  335,  322,  124,  323,
			  343,  129,  382,  330,  414,  414,  414,  414,  361,  129,
			  324,  232,  335,  325,  129,  331,  339,  341,  129,  337,
			   91,  129,  339,  129,  337,  341,  343,  124,  363,  350,
			  129,  351,  343,  344,  124,  345,  360,  356,  124,  352,
			  361,  357,  353,  346,  354,  355,  347,  358,  348,  349,
			  362,  359,  124,  365,  124,   90,   89,  373,  372,  129,

			  363,  350,  124,  351,  364,  350,  129,  351,  361,  358,
			  129,  352,   88,  359,  353,  352,  354,  355,  353,  358,
			  354,  355,  363,  359,  129,  365,  129,  366,  369,  373,
			  373,  124,  367,  370,  129,  376,  365,  375,  377,  379,
			  374,  378,  124,  368,  371,  124,  381,  213,  431,  214,
			  214,  380,  214,  215,  214,  214,  215,  217,  222,  369,
			  369,  212,  210,  129,  370,  370,  124,  377,  123,  375,
			  377,  379,  375,  379,  129,  371,  371,  129,  381,  214,
			  431,  218,  214,  381,  216,  118,   92,  216,  214,  223,
			  214,  221,  212,  266,  266,  266,   94,   91,  129,  385,

			  124,   90,   89,  215,  433,  430,  124,   88,  215,  387,
			  387,  387,  387,  229,  823,  229,  229,  230,   94,  230,
			  230,   95,   94,  434,   94,   95,  435,  385,  411,  411,
			  411,  411,  129,  424,  216,  219,  433,  431,  129,  216,
			  124,  412,  256,  412,  215,  823,  413,  413,  413,  413,
			  415,  415,  415,  415,  418,  435,  418,  823,  435,  419,
			  419,  419,  419,  437,  416,  823,  220,   96,  257,  432,
			  823,   96,  129,  823,  256,  216,  109,  124,  420,  420,
			  421,  421,  109,  439,  421,  421,  421,  421,  124,  117,
			  417,  436,  823,  264,  264,  437,  416,  124,  438,   97,

			  823,  433,  823,   97,  428,  428,  428,  428,  823,  129,
			  429,  429,  429,  429,  444,  439,  440,  445,  116,  124,
			  129,  117,  124,  437,  116,  268,  268,  268,  268,  129,
			  439,  442,  441,  422,  124,  268,  268,  268,  268,  268,
			  268,  447,  449,  446,  271,  124,  445,  443,  442,  445,
			  271,  129,  450,  451,  129,  452,  124,  448,  453,  124,
			  124,  823,  455,  442,  443,  426,  129,  268,  268,  268,
			  268,  268,  268,  447,  449,  447,  460,  129,  461,  443,
			  124,  124,  458,  463,  451,  451,  465,  453,  129,  449,
			  453,  129,  129,  454,  455,  456,  459,  124,  124,  471,

			  124,  470,  124,  124,  468,  474,  466,  462,  461,  457,
			  461,  464,  129,  129,  458,  463,  472,  469,  465,  467,
			  124,  473,  476,  475,  477,  455,  124,  458,  459,  129,
			  129,  471,  129,  471,  129,  129,  468,  475,  468,  463,
			  124,  459,  480,  465,  479,  481,  483,  478,  473,  469,
			  124,  469,  129,  473,  477,  475,  477,  482,  129,  484,
			  485,  124,  124,  487,  488,  489,  124,  124,  491,  486,
			  124,  493,  129,  823,  481,  124,  479,  481,  483,  479,
			  492,  490,  129,  496,  124,  823,  497,  823,  499,  483,
			  823,  485,  485,  129,  129,  487,  489,  489,  129,  129,

			  491,  487,  129,  493,  501,  494,  498,  129,  495,  823,
			  124,  124,  493,  491,  502,  496,  129,  500,  497,  124,
			  499,  124,  124,  506,  124,  503,  505,  508,  511,  124,
			  512,  504,  513,  510,  124,  515,  501,  496,  499,  514,
			  497,  507,  129,  129,  516,  509,  503,  124,  517,  501,
			  519,  129,  521,  129,  129,  508,  129,  503,  505,  508,
			  511,  129,  513,  505,  513,  511,  129,  515,  520,  124,
			  124,  515,  124,  509,  518,  526,  517,  509,  524,  129,
			  517,  522,  519,  523,  521,  124,  525,  527,  124,  528,
			  529,  530,  531,  124,  533,  124,  124,  823,  532,  823,

			  521,  129,  129,  823,  129,  386,  519,  527,  385,  823,
			  525,  823,  823,  523,  823,  523,  823,  129,  525,  527,
			  129,  529,  529,  531,  531,  129,  533,  129,  129,   94,
			  533,   99,  385,  535,  394,  394,  394,  394,  266,  266,
			  266,   99,  534,  534,  534,  534,  536,  536,  536,  536,
			  413,  413,  413,  413,  537,  537,  537,  537,  823,  549,
			  256,  539,  539,  539,  539,  540,  540,  540,  540,  541,
			  823,  541,  823,  823,  542,  542,  542,  542,  424,  416,
			  543,  543,  543,  543,  823,  823,  257,  419,  419,  419,
			  419,  549,  256,  823,  538,  544,  544,  544,  544,  546,

			  124,  420,  420,  421,  421,  417,  551,  553,  555,  823,
			  550,  416,  117,  546,  557,  421,  421,  421,  421,  823,
			  124,  547,  547,  547,  547,  823,  558,  429,  429,  429,
			  429,  548,  129,  559,  552,  545,  124,  124,  551,  553,
			  555,  271,  551,  124,  117,  554,  557,  556,  561,  560,
			  563,  124,  129,  124,  565,  271,  564,  566,  559,  124,
			  124,  271,  562,  549,  567,  559,  553,  271,  129,  129,
			  569,  570,  571,  573,  823,  129,  575,  555,  124,  557,
			  561,  561,  563,  129,  124,  129,  565,  568,  565,  567,
			  124,  129,  129,  572,  563,  574,  567,  124,  577,  579,

			  124,  581,  569,  571,  571,  573,  576,  580,  575,  578,
			  129,  124,  124,  583,  124,  585,  129,  584,  586,  569,
			  587,  124,  129,  589,  582,  573,  591,  575,  124,  129,
			  577,  579,  129,  581,  593,  595,  124,  592,  577,  581,
			  597,  579,  124,  129,  129,  583,  129,  585,  124,  585,
			  587,  588,  587,  129,  599,  589,  583,  590,  591,  594,
			  129,  124,  124,  124,  124,  598,  593,  595,  129,  593,
			  596,  601,  597,  600,  129,  124,  124,  603,  602,  124,
			  129,  606,  605,  589,  607,  608,  599,  124,  124,  591,
			  609,  595,  124,  129,  129,  129,  129,  599,  611,  604,

			  124,  610,  597,  601,  612,  601,  613,  129,  129,  603,
			  603,  129,  614,  607,  605,  615,  607,  609,  124,  129,
			  129,  618,  609,  124,  129,  617,  619,  124,  621,  623,
			  611,  605,  129,  611,  622,  616,  613,  124,  613,  625,
			  124,  124,  627,  620,  615,  124,  624,  615,  626,  124,
			  129,  628,  629,  619,  124,  129,  124,  617,  619,  129,
			  621,  623,  631,  633,  635,  124,  623,  617,  630,  129,
			  124,  625,  129,  129,  627,  621,  124,  129,  625,  632,
			  627,  129,  634,  629,  629,  823,  129,  823,  129,  124,
			  124,  823,  823,  823,  631,  633,  635,  129,   94,  823,

			  631,  385,  129,   94,  124,  823,  385,  823,  129,  823,
			   99,  633,  823,  823,  635,   99,  636,  636,  636,  636,
			  823,  129,  129,  536,  536,  536,  536,  639,  639,  639,
			  639,  640,  640,  640,  640,  823,  129,  638,  641,  641,
			  641,  641,  642,  642,  642,  642,  542,  542,  542,  542,
			  643,  643,  643,  643,  823,  651,  416,  645,  645,  645,
			  645,  646,  646,  646,  646,  124,  124,  538,  653,  638,
			  647,  647,  647,  647,  124,  642,  642,  642,  642,  650,
			  655,  649,  417,  429,  429,  429,  429,  651,  416,  648,
			  644,  823,  656,  124,  124,  661,  657,  129,  129,  652,

			  653,  545,  654,  658,  124,  124,  129,  659,  124,  660,
			  663,  651,  655,  664,  665,  666,  124,  662,  667,  124,
			  669,  648,  671,  116,  658,  129,  129,  661,  659,  673,
			  124,  653,  124,  668,  655,  658,  129,  129,  124,  659,
			  129,  661,  663,  670,  675,  665,  665,  667,  129,  663,
			  667,  129,  669,  124,  671,  124,  677,  124,  672,  678,
			  676,  673,  129,  124,  129,  669,  674,  679,  680,  681,
			  129,  124,  682,  683,  684,  671,  675,  685,  686,  687,
			  124,  124,  689,  691,  823,  129,  124,  129,  677,  129,
			  673,  679,  677,  690,  693,  129,  695,  124,  675,  679,

			  681,  681,  688,  129,  683,  683,  685,  124,  124,  685,
			  687,  687,  129,  129,  689,  691,  692,  696,  129,  697,
			  698,  699,  701,  694,  124,  691,  693,  700,  695,  129,
			  703,  124,  124,  704,  689,  705,  124,  124,  707,  129,
			  129,  702,  124,  709,  711,  124,  124,  706,  693,  697,
			  710,  697,  699,  699,  701,  695,  129,  708,  124,  701,
			  712,  713,  703,  129,  129,  705,  715,  705,  129,  129,
			  707,  124,  717,  703,  129,  709,  711,  129,  129,  707,
			  714,  124,  711,  721,  124,  124,  716,  823,  823,  709,
			  129,  823,  713,  713,  718,  823,  718,  823,  715,  719,

			  719,  719,  719,  129,  717,  719,  719,  719,  719,  257,
			  733,  735,  715,  129,  823,  721,  129,  129,  717,  720,
			  720,  720,  720,  642,  642,  642,  642,  723,  723,  723,
			  723,  724,  724,  724,  724,  823,  823,  722,  725,  725,
			  725,  725,  733,  735,  124,  538,  726,  726,  726,  726,
			  727,  727,  727,  727,  728,  734,  728,  124,  737,  726,
			  726,  726,  726,  730,  730,  730,  730,  644,  732,  722,
			  124,  739,  124,  124,  740,  741,  129,  731,  124,  736,
			  124,  738,  124,  743,  742,  124,  545,  735,  124,  129,
			  737,  744,  745,  746,  747,  124,  749,  124,  124,  124,

			  733,  751,  129,  739,  129,  129,  741,  741,  748,  731,
			  129,  737,  129,  739,  129,  743,  743,  129,  753,  755,
			  129,  757,  124,  745,  745,  747,  747,  129,  749,  129,
			  129,  129,  124,  751,  124,  124,  756,  750,  124,  759,
			  749,  761,  124,  124,  124,  752,  754,  763,  765,  758,
			  753,  755,  760,  757,  129,  124,  124,  124,  766,  767,
			  762,  764,  124,  124,  129,  124,  129,  129,  757,  751,
			  129,  759,  124,  761,  129,  129,  129,  753,  755,  763,
			  765,  759,  769,  771,  761,  124,  124,  129,  129,  129,
			  767,  767,  763,  765,  129,  129,  768,  129,  124,  124,

			  773,  780,  786,  770,  129,  719,  719,  719,  719,  124,
			  772,  823,  823,  823,  769,  771,  788,  129,  129,  719,
			  719,  719,  719,  774,  774,  774,  774,  417,  769,  823,
			  129,  129,  773,  780,  786,  771,  823,  823,  775,  823,
			  775,  129,  773,  776,  776,  776,  776,  777,  788,  777,
			  823,  124,  778,  778,  778,  778,  778,  778,  778,  778,
			  779,  779,  779,  779,  726,  726,  726,  726,  781,  781,
			  781,  781,  726,  726,  726,  726,  782,  782,  782,  782,
			  783,  790,  783,  129,  823,  784,  784,  784,  784,  785,
			  780,  792,  124,  789,  124,  791,  644,  787,  124,  124,

			  124,  794,  793,  124,  124,  795,  796,  124,  124,  124,
			  124,  798,  800,  790,  799,  797,  417,  802,  124,  823,
			  823,  786,  780,  792,  129,  790,  129,  792,  804,  788,
			  129,  129,  129,  794,  794,  129,  129,  796,  796,  129,
			  129,  129,  129,  798,  800,  124,  800,  798,  803,  802,
			  129,  801,  124,  805,  806,  124,  808,  807,  809,  124,
			  804,  124,  124,  810,  124,  776,  776,  776,  776,  811,
			  811,  811,  811,  778,  778,  778,  778,  129,  823,  823,
			  804,  823,  823,  802,  129,  806,  806,  129,  808,  808,
			  810,  129,  823,  129,  129,  810,  129,  778,  778,  778,

			  778,  812,  812,  812,  812,  813,  124,  813,  124,  538,
			  814,  814,  814,  814,  725,  725,  725,  725,  784,  784,
			  784,  784,  815,  815,  815,  815,  124,  124,  780,  124,
			  823,  124,  124,  817,  124,  124,  819,  124,  129,  821,
			  129,  820,  124,  816,  818,  124,  124,  774,  774,  774,
			  774,  823,  823,  823,  417,  823,  823,  823,  129,  129,
			  780,  129,  545,  129,  129,  817,  129,  129,  819,  129,
			  124,  821,  124,  821,  129,  817,  819,  129,  129,  814,
			  814,  814,  814,  822,  822,  822,  822,  538,  781,  781,
			  781,  781,  124,  812,  812,  812,  812,  823,  823,  823,

			  823,  823,  129,  823,  129,  112,  112,  112,  112,  112,
			  112,  112,  112,  112,  112,  112,  112,  823,  823,  823,
			  823,  823,  823,  644,  129,  823,  823,  823,  545,  823,
			  823,  823,  823,  644,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   93,   93,  823,   93,   93,   93,
			   93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
			   93,   93,   93,   93,   98,  823,  823,  823,  823,  823,
			  823,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   98,   98,   99,   99,  823,   99,   99,   99,

			   99,   99,   99,   99,   99,   99,   99,   99,   99,   99,
			   99,   99,   99,   99,  100,  100,  823,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  211,  211,  823,  211,  211,  211,
			  823,  823,  211,  211,  211,  211,  211,  211,  211,  211,
			  211,  211,  211,  211,  129,  129,  129,  129,  129,  129,
			  129,  129,  129,  129,  129,  212,  823,  823,  212,  823,
			  212,  212,  212,  212,  212,  212,  212,  212,  212,  212,
			  212,  212,  212,  212,  212,  219,  219,  823,  219,  219,
			  219,  219,  219,  219,  219,  219,  219,  219,  219,  219,

			  219,  219,  219,  219,  219,  220,  220,  823,  220,  220,
			  220,  220,  220,  220,  220,  220,  220,  220,  220,  220,
			  220,  220,  220,  220,  220,  224,  224,  823,  224,  224,
			  224,  224,  224,  224,  224,  224,  224,  224,  224,  224,
			  224,  224,  224,  224,  224,  231,  231,  823,  231,  231,
			  231,  231,  231,  231,  231,  231,  231,  231,  231,  231,
			  231,  231,  231,  231,  231,  258,  258,  258,  258,  258,
			  258,  258,  258,  823,  258,  258,  258,  258,  258,  258,
			  258,  258,  258,  258,  258,  265,  265,  265,  265,  265,
			  265,  265,  265,  265,  265,  265,  267,  267,  267,  267,

			  267,  267,  267,  267,  267,  267,  267,  269,  269,  269,
			  269,  269,  269,  269,  269,  269,  269,  269,  215,  215,
			  823,  215,  215,  215,  823,  215,  215,  215,  215,  215,
			  215,  215,  215,  215,  215,  215,  215,  215,  216,  216,
			  823,  216,  216,  216,  823,  216,  216,  216,  216,  216,
			  216,  216,  216,  216,  216,  216,  216,  216,  729,  729,
			  729,  729,  729,  729,  729,  729,  823,  729,  729,  729,
			  729,  729,  729,  729,  729,  729,  729,  729,    5,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823, yy_Dummy>>,
			1, 3000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823, yy_Dummy>>,
			1, 68, 3000)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 3067)
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
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    3,    3,    3,    3,    4,    4,    4,    4,   12,   15,

			   22,   12,   15,   16,   16,   23,   24,   23,   23,   23,
			   23,   22,  812,   25,   24,   25,   25,   25,   25,   26,
			   40,   26,   26,   26,   26,  112,   25,   25,   30,   30,
			   60,   27,   26,   27,   27,   27,   27,   32,   32,   38,
			   68,  781,   38,   69,   38,  774,    3,   12,   25,  535,
			    4,  427,   40,  425,   38,   25,   52,   52,   25,   25,
			   86,   26,   60,   86,   26,   86,   99,  112,   86,   99,
			  423,   38,   68,   27,   38,   69,   38,    3,  117,   12,
			   25,    4,   34,   34,   34,   34,   38,   47,   52,   52,
			  269,   47,   34,   34,   34,   34,   34,   34,   34,   34,

			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,  224,   47,
			  117,  224,   34,   47,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   35,   35,   35,   35,   71,   72,   77,   78,  267,  124,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   71,   72,   77,   78,
			   35,  124,   35,   35,   35,   35,   35,   35,   35,   35,

			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   36,   36,
			   37,   42,   36,  126,   37,   36,  126,   42,   36,   39,
			   37,   36,   41,   39,   46,   41,   43,   39,   44,   41,
			   41,  265,   43,   46,   44,   41,   39,  130,  254,  132,
			   36,   36,   37,   42,   36,  126,   37,   36,  126,   42,
			   36,   39,   37,   36,   41,   39,   46,   41,   43,   39,
			   44,   41,   41,   45,   43,   46,   44,   41,   39,  130,
			   45,  132,   48,   45,  253,   45,   48,   51,   50,   45,
			   49,   49,  133,   50,   73,   51,   53,   48,   50,   59,

			   49,   51,   53,   61,   59,   45,   59,   61,  135,   73,
			   61,   59,   45,   61,   48,   45,   61,   45,   48,   51,
			   50,   45,   49,   49,  133,   50,   73,   51,   53,   48,
			   50,   59,   49,   51,   53,   61,   59,   62,   59,   61,
			  135,   73,   61,   59,   63,   61,   63,   62,   61,   64,
			   66,   74,   70,   64,   67,  141,   63,   66,   66,   76,
			   67,   74,   70,   66,   70,   75,   64,  142,   70,   62,
			   75,  252,   82,   76,   82,   82,   63,   93,   63,   62,
			   93,   64,   66,   74,   70,   64,   67,  141,   63,   66,
			   66,   76,   67,   74,   70,   66,   70,   75,   64,  142,

			   70,   84,   75,   84,   84,   76,   85,   87,   85,   85,
			   87,  225,   87,  128,  225,   87,   96,  226,   96,   96,
			  226,   96,  143,  128,   96,  251,   93,  250,   82,  144,
			   97,  228,   97,   97,  228,   97,  249,  248,   97,  106,
			  106,  106,  106,  113,  113,  128,  109,  109,  109,  109,
			  114,  114,  114,  106,  143,  128,  247,   84,   93,   82,
			  109,  144,   85,  110,  145,  110,  110,  110,  110,  111,
			   96,  111,  111,  111,  111,  127,  110,  147,  125,  106,
			  127,  246,  125,  113,   97,  106,  264,  264,   84,  153,
			  114,  136,  109,   85,   95,  136,  145,   95,   95,   95,

			   95,  385,   96,  245,  385,  110,   95,  127,  110,  147,
			  125,  111,  127,   95,  125,   95,   97,   95,   95,   95,
			  244,  153,   95,  136,   95,  159,  264,  136,   95,  134,
			   95,  243,  263,   95,   95,   95,   95,   95,   95,  101,
			  134,  242,  101,  101,  101,  101,  238,  238,  238,  238,
			  116,  101,  116,  116,  116,  116,  131,  159,  101,  131,
			  101,  134,  101,  101,  101,  101,  241,  101,  137,  101,
			  240,  239,  134,  101,  263,  101,  137,  237,  101,  101,
			  101,  101,  101,  101,  115,  115,  115,  115,  131,  139,
			  236,  131,  116,  139,  115,  115,  115,  115,  115,  115,

			  137,  138,  140,  146,  150,  148,  138,  146,  137,  148,
			  146,  140,  152,  235,  150,  156,  155,  151,  156,  152,
			  155,  139,  151,  152,  115,  139,  115,  115,  115,  115,
			  115,  115,  151,  138,  140,  146,  150,  148,  138,  146,
			  160,  148,  146,  140,  152,  154,  150,  156,  155,  151,
			  156,  152,  155,  157,  151,  152,  158,  161,  162,  163,
			  154,  157,  158,  164,  151,  164,  163,  164,  164,  165,
			  167,  234,  160,  233,  170,  217,  170,  154,  164,  216,
			  172,  164,  174,  175,  173,  157,  215,  174,  158,  161,
			  162,  163,  154,  157,  158,  164,  173,  164,  163,  164,

			  164,  165,  167,  168,  177,  168,  170,  168,  170,  176,
			  164,  171,  172,  164,  174,  175,  173,  171,  168,  174,
			  176,  168,  178,  171,  179,  180,  181,  182,  173,  179,
			  183,  180,  178,  184,  186,  168,  177,  168,  186,  168,
			  187,  176,  211,  171,  257,  257,  257,  257,  193,  171,
			  168,  100,  176,  168,  178,  171,  179,  180,  181,  182,
			   91,  179,  183,  180,  178,  184,  186,  191,  196,  189,
			  186,  189,  187,  188,  190,  188,  191,  190,  188,  189,
			  193,  190,  189,  188,  189,  189,  188,  192,  188,  188,
			  194,  192,  195,  197,  194,   90,   89,  201,  199,  191,

			  196,  189,  199,  189,  195,  188,  190,  188,  191,  190,
			  188,  189,   88,  190,  189,  188,  189,  189,  188,  192,
			  188,  188,  194,  192,  195,  197,  194,  198,  200,  201,
			  199,  202,  198,  200,  199,  203,  195,  204,  205,  207,
			  202,  206,  208,  198,  200,  206,  209,  213,  273,  213,
			  213,  208,  214,  219,  214,  214,  219,   83,  219,  198,
			  200,  219,   55,  202,  198,  200,  275,  203,   33,  204,
			  205,  207,  202,  206,  208,  198,  200,  206,  209,  218,
			  273,  218,  218,  208,  220,   28,   11,  220,  221,  220,
			  221,  221,  220,  266,  266,  266,  227,   10,  275,  227,

			  272,    9,    8,  213,  276,  272,  278,    7,  214,  227,
			  227,  227,  227,  229,    5,  229,  229,  230,  229,  230,
			  230,  229,  230,  280,  386,  230,  281,  386,  255,  255,
			  255,  255,  272,  266,  213,  218,  276,  272,  278,  214,
			  282,  256,  255,  256,  221,    0,  256,  256,  256,  256,
			  259,  259,  259,  259,  260,  280,  260,    0,  281,  260,
			  260,  260,  260,  285,  259,    0,  218,  229,  255,  274,
			    0,  230,  282,    0,  255,  221,  261,  274,  261,  261,
			  261,  261,  262,  287,  262,  262,  262,  262,  286,  261,
			  259,  284,    0,  422,  422,  285,  259,  284,  286,  229,

			    0,  274,  270,  230,  270,  270,  270,  270,  271,  274,
			  271,  271,  271,  271,  290,  287,  288,  291,  261,  288,
			  286,  261,  290,  284,  262,  268,  268,  268,  268,  284,
			  286,  289,  288,  422,  292,  268,  268,  268,  268,  268,
			  268,  293,  296,  292,  270,  294,  290,  289,  288,  291,
			  271,  288,  295,  297,  290,  298,  295,  294,  299,  298,
			  300,    0,  303,  289,  288,  268,  292,  268,  268,  268,
			  268,  268,  268,  293,  296,  292,  305,  294,  307,  289,
			  305,  301,  306,  309,  295,  297,  311,  298,  295,  294,
			  299,  298,  300,  301,  303,  304,  306,  308,  314,  315,

			  310,  314,  312,  304,  313,  317,  312,  308,  305,  304,
			  307,  310,  305,  301,  306,  309,  316,  313,  311,  312,
			  316,  321,  318,  322,  323,  301,  318,  304,  306,  308,
			  314,  315,  310,  314,  312,  304,  313,  317,  312,  308,
			  319,  304,  320,  310,  324,  325,  327,  319,  316,  313,
			  320,  312,  316,  321,  318,  322,  323,  326,  318,  328,
			  330,  326,  329,  331,  332,  333,  334,  328,  337,  329,
			  338,  341,  319,    0,  320,  336,  324,  325,  327,  319,
			  340,  336,  320,  343,  340,    0,  343,    0,  350,  326,
			    0,  328,  330,  326,  329,  331,  332,  333,  334,  328,

			  337,  329,  338,  341,  351,  342,  344,  336,  342,    0,
			  344,  342,  340,  336,  346,  343,  340,  345,  343,  347,
			  350,  345,  346,  348,  349,  352,  353,  354,  355,  348,
			  356,  347,  358,  349,  356,  359,  351,  342,  344,  357,
			  342,  348,  344,  342,  360,  354,  346,  357,  361,  345,
			  363,  347,  365,  345,  346,  348,  349,  352,  353,  354,
			  355,  348,  356,  347,  358,  349,  356,  359,  364,  362,
			  367,  357,  364,  348,  362,  368,  360,  354,  367,  357,
			  361,  366,  363,  369,  365,  366,  370,  371,  372,  374,
			  375,  376,  377,  378,  379,  380,  376,    0,  378,    0,

			  364,  362,  367,    0,  364,  388,  362,  368,  388,    0,
			  367,    0,    0,  366,    0,  369,    0,  366,  370,  371,
			  372,  374,  375,  376,  377,  378,  379,  380,  376,  387,
			  378,  388,  387,  394,  394,  394,  394,  394,  424,  424,
			  424,  387,  387,  387,  387,  387,  411,  411,  411,  411,
			  412,  412,  412,  412,  413,  413,  413,  413,    0,  431,
			  411,  414,  414,  414,  414,  415,  415,  415,  415,  416,
			    0,  416,    0,    0,  416,  416,  416,  416,  424,  415,
			  417,  417,  417,  417,    0,    0,  411,  418,  418,  418,
			  418,  431,  411,    0,  413,  419,  419,  419,  419,  420,

			  432,  420,  420,  420,  420,  415,  433,  435,  437,    0,
			  432,  415,  420,  421,  439,  421,  421,  421,  421,  428,
			  430,  428,  428,  428,  428,  429,  440,  429,  429,  429,
			  429,  430,  432,  442,  434,  419,  434,  438,  433,  435,
			  437,  420,  432,  436,  420,  436,  439,  438,  443,  441,
			  445,  444,  430,  441,  447,  421,  446,  448,  440,  448,
			  446,  428,  444,  430,  449,  442,  434,  429,  434,  438,
			  451,  452,  453,  455,    0,  436,  458,  436,  450,  438,
			  443,  441,  445,  444,  454,  441,  447,  450,  446,  448,
			  456,  448,  446,  454,  444,  456,  449,  457,  459,  461,

			  460,  463,  451,  452,  453,  455,  457,  462,  458,  460,
			  450,  462,  464,  465,  466,  469,  454,  467,  470,  450,
			  471,  467,  456,  473,  464,  454,  475,  456,  476,  457,
			  459,  461,  460,  463,  477,  479,  472,  476,  457,  462,
			  481,  460,  474,  462,  464,  465,  466,  469,  482,  467,
			  470,  472,  471,  467,  485,  473,  464,  474,  475,  478,
			  476,  480,  484,  478,  486,  484,  477,  479,  472,  476,
			  480,  489,  481,  488,  474,  490,  488,  491,  490,  492,
			  482,  495,  496,  472,  497,  498,  485,  494,  498,  474,
			  499,  478,  500,  480,  484,  478,  486,  484,  501,  494,

			  502,  500,  480,  489,  502,  488,  503,  490,  488,  491,
			  490,  492,  504,  495,  496,  505,  497,  498,  507,  494,
			  498,  507,  499,  506,  500,  508,  509,  510,  511,  513,
			  501,  494,  502,  500,  512,  506,  502,  514,  503,  515,
			  512,  516,  517,  510,  504,  518,  514,  505,  516,  520,
			  507,  522,  523,  507,  522,  506,  524,  508,  509,  510,
			  511,  513,  525,  527,  529,  530,  512,  506,  524,  514,
			  532,  515,  512,  516,  517,  510,  526,  518,  514,  526,
			  516,  520,  528,  522,  523,    0,  522,    0,  524,  548,
			  528,    0,    0,    0,  525,  527,  529,  530,  636,    0,

			  524,  636,  532,  534,  550,    0,  534,    0,  526,    0,
			  636,  526,    0,    0,  528,  534,  534,  534,  534,  534,
			    0,  548,  528,  536,  536,  536,  536,  537,  537,  537,
			  537,  538,  538,  538,  538,    0,  550,  536,  539,  539,
			  539,  539,  540,  540,  540,  540,  541,  541,  541,  541,
			  542,  542,  542,  542,    0,  553,  540,  543,  543,  543,
			  543,  544,  544,  544,  544,  554,  556,  537,  559,  536,
			  545,  545,  545,  545,  552,  546,  546,  546,  546,  552,
			  561,  547,  540,  547,  547,  547,  547,  553,  540,  546,
			  542,    0,  562,  560,  558,  565,  562,  554,  556,  558,

			  559,  544,  560,  563,  564,  566,  552,  563,  568,  564,
			  569,  552,  561,  570,  571,  572,  570,  568,  573,  572,
			  575,  546,  577,  547,  562,  560,  558,  565,  562,  579,
			  580,  558,  576,  574,  560,  563,  564,  566,  574,  563,
			  568,  564,  569,  576,  583,  570,  571,  572,  570,  568,
			  573,  572,  575,  578,  577,  584,  585,  582,  578,  586,
			  584,  579,  580,  586,  576,  574,  582,  587,  588,  589,
			  574,  590,  592,  593,  594,  576,  583,  595,  596,  597,
			  594,  598,  601,  603,    0,  578,  600,  584,  585,  582,
			  578,  586,  584,  602,  605,  586,  607,  602,  582,  587,

			  588,  589,  600,  590,  592,  593,  594,  604,  606,  595,
			  596,  597,  594,  598,  601,  603,  604,  608,  600,  609,
			  610,  611,  613,  606,  610,  602,  605,  612,  607,  602,
			  615,  612,  614,  616,  600,  617,  618,  616,  619,  604,
			  606,  614,  620,  623,  625,  626,  622,  618,  604,  608,
			  624,  609,  610,  611,  613,  606,  610,  622,  624,  612,
			  628,  629,  615,  612,  614,  616,  631,  617,  618,  616,
			  619,  632,  635,  614,  620,  623,  625,  626,  622,  618,
			  630,  634,  624,  641,  630,  650,  634,    0,    0,  622,
			  624,    0,  628,  629,  638,    0,  638,    0,  631,  638,

			  638,  638,  638,  632,  635,  639,  639,  639,  639,  641,
			  653,  655,  630,  634,    0,  641,  630,  650,  634,  640,
			  640,  640,  640,  642,  642,  642,  642,  643,  643,  643,
			  643,  644,  644,  644,  644,    0,    0,  642,  645,  645,
			  645,  645,  653,  655,  654,  639,  646,  646,  646,  646,
			  647,  647,  647,  647,  648,  654,  648,  656,  659,  648,
			  648,  648,  648,  649,  649,  649,  649,  643,  652,  642,
			  660,  661,  652,  657,  662,  663,  654,  649,  662,  657,
			  664,  660,  666,  669,  668,  670,  646,  654,  668,  656,
			  659,  672,  673,  674,  675,  676,  679,  674,  678,  672,

			  652,  681,  660,  661,  652,  657,  662,  663,  678,  649,
			  662,  657,  664,  660,  666,  669,  668,  670,  683,  685,
			  668,  687,  688,  672,  673,  674,  675,  676,  679,  674,
			  678,  672,  680,  681,  682,  684,  686,  680,  690,  691,
			  678,  693,  692,  694,  686,  682,  684,  697,  699,  690,
			  683,  685,  692,  687,  688,  696,  698,  700,  702,  703,
			  696,  698,  702,  704,  680,  706,  682,  684,  686,  680,
			  690,  691,  708,  693,  692,  694,  686,  682,  684,  697,
			  699,  690,  711,  713,  692,  710,  714,  696,  698,  700,
			  702,  703,  696,  698,  702,  704,  710,  706,  712,  716,

			  717,  725,  733,  712,  708,  718,  718,  718,  718,  734,
			  716,    0,    0,    0,  711,  713,  737,  710,  714,  719,
			  719,  719,  719,  720,  720,  720,  720,  725,  710,    0,
			  712,  716,  717,  725,  733,  712,    0,    0,  721,    0,
			  721,  734,  716,  721,  721,  721,  721,  722,  737,  722,
			    0,  738,  722,  722,  722,  722,  723,  723,  723,  723,
			  724,  724,  724,  724,  726,  726,  726,  726,  727,  727,
			  727,  727,  728,  728,  728,  728,  730,  730,  730,  730,
			  731,  741,  731,  738,    0,  731,  731,  731,  731,  732,
			  730,  743,  736,  740,  732,  742,  723,  736,  740,  744,

			  742,  745,  744,  746,  748,  750,  751,  750,  752,  754,
			  756,  757,  759,  741,  758,  756,  730,  761,  758,    0,
			    0,  732,  730,  743,  736,  740,  732,  742,  763,  736,
			  740,  744,  742,  745,  744,  746,  748,  750,  751,  750,
			  752,  754,  756,  757,  759,  760,  758,  756,  762,  761,
			  758,  760,  762,  764,  765,  766,  769,  768,  770,  764,
			  763,  768,  770,  771,  772,  775,  775,  775,  775,  776,
			  776,  776,  776,  777,  777,  777,  777,  760,    0,    0,
			  762,    0,    0,  760,  762,  764,  765,  766,  769,  768,
			  770,  764,    0,  768,  770,  771,  772,  778,  778,  778,

			  778,  779,  779,  779,  779,  780,  785,  780,  787,  776,
			  780,  780,  780,  780,  782,  782,  782,  782,  783,  783,
			  783,  783,  784,  784,  784,  784,  789,  791,  782,  793,
			    0,  795,  797,  798,  799,  801,  802,  803,  785,  806,
			  787,  805,  807,  797,  801,  805,  809,  811,  811,  811,
			  811,    0,    0,    0,  782,    0,    0,    0,  789,  791,
			  782,  793,  784,  795,  797,  798,  799,  801,  802,  803,
			  816,  806,  818,  805,  807,  797,  801,  805,  809,  813,
			  813,  813,  813,  814,  814,  814,  814,  811,  815,  815,
			  815,  815,  820,  822,  822,  822,  822,    0,    0,    0,

			    0,    0,  816,    0,  818,  829,  829,  829,  829,  829,
			  829,  829,  829,  829,  829,  829,  829,    0,    0,    0,
			    0,    0,    0,  814,  820,    0,    0,    0,  815,    0,
			    0,    0,    0,  822,  824,  824,  824,  824,  824,  824,
			  824,  824,  824,  824,  824,  824,  824,  824,  824,  824,
			  824,  824,  824,  824,  825,  825,    0,  825,  825,  825,
			  825,  825,  825,  825,  825,  825,  825,  825,  825,  825,
			  825,  825,  825,  825,  826,    0,    0,    0,    0,    0,
			    0,  826,  826,  826,  826,  826,  826,  826,  826,  826,
			  826,  826,  826,  826,  827,  827,    0,  827,  827,  827,

			  827,  827,  827,  827,  827,  827,  827,  827,  827,  827,
			  827,  827,  827,  827,  828,  828,    0,  828,  828,  828,
			  828,  828,  828,  828,  828,  828,  828,  828,  828,  828,
			  828,  828,  828,  828,  830,  830,    0,  830,  830,  830,
			    0,    0,  830,  830,  830,  830,  830,  830,  830,  830,
			  830,  830,  830,  830,  831,  831,  831,  831,  831,  831,
			  831,  831,  831,  831,  831,  832,    0,    0,  832,    0,
			  832,  832,  832,  832,  832,  832,  832,  832,  832,  832,
			  832,  832,  832,  832,  832,  833,  833,    0,  833,  833,
			  833,  833,  833,  833,  833,  833,  833,  833,  833,  833,

			  833,  833,  833,  833,  833,  834,  834,    0,  834,  834,
			  834,  834,  834,  834,  834,  834,  834,  834,  834,  834,
			  834,  834,  834,  834,  834,  835,  835,    0,  835,  835,
			  835,  835,  835,  835,  835,  835,  835,  835,  835,  835,
			  835,  835,  835,  835,  835,  836,  836,    0,  836,  836,
			  836,  836,  836,  836,  836,  836,  836,  836,  836,  836,
			  836,  836,  836,  836,  836,  837,  837,  837,  837,  837,
			  837,  837,  837,    0,  837,  837,  837,  837,  837,  837,
			  837,  837,  837,  837,  837,  838,  838,  838,  838,  838,
			  838,  838,  838,  838,  838,  838,  839,  839,  839,  839,

			  839,  839,  839,  839,  839,  839,  839,  840,  840,  840,
			  840,  840,  840,  840,  840,  840,  840,  840,  841,  841,
			    0,  841,  841,  841,    0,  841,  841,  841,  841,  841,
			  841,  841,  841,  841,  841,  841,  841,  841,  842,  842,
			    0,  842,  842,  842,    0,  842,  842,  842,  842,  842,
			  842,  842,  842,  842,  842,  842,  842,  842,  843,  843,
			  843,  843,  843,  843,  843,  843,    0,  843,  843,  843,
			  843,  843,  843,  843,  843,  843,  843,  843,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823, yy_Dummy>>,
			1, 3000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823, yy_Dummy>>,
			1, 68, 3000)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   88,   92, 1014, 2978, 1005,  999,  997,
			  992,  980,   91,    0, 2978,   92,   93, 2978, 2978, 2978,
			 2978, 2978,   83,   87,   87,   95,  101,  113,  958, 2978,
			  102, 2978,  110,  941,  162,  230,  281,  286,  101,  299,
			   82,  297,  283,  298,  300,  342,  296,  153,  348,  353,
			  350,  357,  119,  358, 2978,  905, 2978, 2978,    0,  363,
			   92,  366,  403,  403,  419,    0,  415,  416,   96,   99,
			  421,  207,  221,  360,  414,  422,  429,  219,  213, 2978,
			 2978,    0,  470,  954,  499,  504,  158,  505,  910,  893,
			  891,  855, 2978,  470, 2978,  587,  514,  528,    0,  159,

			  840,  632,    0, 2978, 2978, 2978,  519, 2978, 2978,  526,
			  545,  551,  107,  523,  530,  664,  632,  160, 2978, 2978,
			 2978, 2978, 2978, 2978,  221,  544,  285,  542,  475,    0,
			  313,  618,  316,  344,  591,  359,  557,  638,  663,  655,
			  664,  421,  437,  479,  495,  517,  672,  539,  674,    0,
			  666,  684,  674,  541,  712,  671,  677,  723,  718,  584,
			  710,  713,  720,  721,  730,  731,    0,  725,  770,    0,
			  736,  779,  740,  752,  749,  750,  771,  755,  784,  791,
			  793,  788,  779,  797,  801,    0,  800,  806,  840,  836,
			  836,  829,  846,  801,  856,  854,  834,  843,  894,  864,

			  895,  863,  893,  897,  890,  900,  907,  905,  904,  899,
			 2978,  831,    0,  945,  950,  779,  772,  772,  977,  951,
			  982,  986,    0,    0,  211,  504,  510,  989,  524, 1011,
			 1015, 2978, 2978,  762,  760,  702,  679,  666,  626,  660,
			  659,  655,  630,  620,  609,  592,  570,  545,  526,  525,
			  516,  514,  460,  373,  337, 1008, 1026,  824, 2978, 1030,
			 1039, 1058, 1064,  614,  566,  281,  973,  198, 1105,  130,
			 1084, 1090,  962,  905, 1039,  928,  974,    0,  968,    0,
			  985,  988, 1002,    0, 1059, 1031, 1050, 1035, 1081, 1096,
			 1084, 1087, 1096, 1094, 1107, 1118, 1092, 1119, 1121, 1124,

			 1122, 1143,    0, 1112, 1165, 1142, 1152, 1144, 1159, 1135,
			 1162, 1137, 1164, 1162, 1160, 1158, 1182, 1167, 1188, 1202,
			 1212, 1187, 1185, 1190, 1199, 1215, 1223, 1212, 1229, 1224,
			 1230, 1218, 1226, 1227, 1228,    0, 1237, 1224, 1232,    0,
			 1246, 1237, 1273, 1251, 1272, 1283, 1284, 1281, 1291, 1286,
			 1254, 1270, 1295, 1276, 1295, 1281, 1296, 1309, 1298, 1305,
			 1306, 1310, 1331, 1307, 1334, 1318, 1347, 1332, 1337, 1349,
			 1340, 1349, 1350,    0, 1351, 1352, 1358, 1359, 1355, 1351,
			 1357,    0, 2978, 2978, 2978,  594, 1017, 1422, 1398, 2978,
			 2978, 2978, 2978, 2978, 1414, 2978, 2978, 2978, 2978, 2978,

			 2978, 2978, 2978, 2978, 2978, 2978, 2978, 2978, 2978, 2978,
			 2978, 1426, 1430, 1434, 1441, 1445, 1454, 1460, 1467, 1475,
			 1481, 1495, 1073,  110, 1418,   93,    0,   91, 1501, 1507,
			 1482, 1410, 1462, 1458, 1498, 1471, 1505, 1468, 1499, 1466,
			 1488, 1515, 1495, 1514, 1513, 1501, 1522, 1520, 1521, 1528,
			 1540, 1523, 1533, 1534, 1546, 1526, 1552, 1559, 1533, 1551,
			 1562, 1552, 1573, 1567, 1574, 1563, 1576, 1583,    0, 1581,
			 1580, 1582, 1598, 1570, 1604, 1573, 1590, 1587, 1625, 1601,
			 1623, 1593, 1610,    0, 1624, 1613, 1626,    0, 1638, 1636,
			 1637, 1636, 1641,    0, 1649, 1643, 1632, 1646, 1650, 1655,

			 1654, 1651, 1662, 1664, 1674, 1677, 1685, 1680, 1675, 1685,
			 1689, 1674, 1702, 1697, 1699, 1692, 1703, 1697, 1707,    0,
			 1711,    0, 1716, 1717, 1718, 1712, 1738, 1722, 1752, 1734,
			 1727,    0, 1732,    0, 1796,  138, 1803, 1807, 1811, 1818,
			 1822, 1826, 1830, 1837, 1841, 1850, 1855, 1863, 1751,    0,
			 1766,    0, 1836, 1812, 1827,    0, 1828,    0, 1856, 1825,
			 1855, 1833, 1858, 1869, 1866, 1852, 1867,    0, 1870, 1863,
			 1878, 1879, 1881, 1884, 1900, 1887, 1894, 1873, 1915, 1886,
			 1892,    0, 1919, 1897, 1917, 1913, 1925, 1933, 1930, 1931,
			 1933,    0, 1934, 1935, 1942, 1945, 1940, 1941, 1943,    0,

			 1948, 1928, 1959, 1949, 1969, 1947, 1970, 1943, 1979, 1981,
			 1986, 1987, 1993, 1988, 1994, 1983, 1999, 2001, 1998, 1989,
			 2004,    0, 2008, 1994, 2020, 2014, 2007,    0, 2022, 2023,
			 2046, 2032, 2033,    0, 2043, 2029, 1791, 2978, 2079, 2085,
			 2099, 2049, 2103, 2107, 2111, 2118, 2126, 2130, 2139, 2143,
			 2047,    0, 2134, 2076, 2106, 2062, 2119, 2135,    0, 2114,
			 2132, 2122, 2140, 2141, 2142,    0, 2144,    0, 2150, 2149,
			 2147,    0, 2161, 2162, 2159, 2160, 2157,    0, 2160, 2148,
			 2194, 2158, 2196, 2169, 2197, 2170, 2206, 2191, 2184,    0,
			 2200, 2190, 2204, 2193, 2205,    0, 2217, 2204, 2218, 2205,

			 2219,    0, 2224, 2225, 2225,    0, 2227,    0, 2234,    0,
			 2247, 2233, 2260, 2240, 2248,    0, 2261, 2251, 2285, 2299,
			 2303, 2323, 2332, 2336, 2340, 2267, 2344, 2348, 2352, 2978,
			 2356, 2365, 2356, 2269, 2271,    0, 2354, 2273, 2313,    0,
			 2360, 2348, 2362, 2358, 2361, 2360, 2365,    0, 2366,    0,
			 2369, 2370, 2370,    0, 2371,    0, 2372, 2368, 2380, 2378,
			 2407, 2373, 2414, 2394, 2421, 2422, 2417,    0, 2423, 2422,
			 2424, 2429, 2426,    0,   85, 2445, 2449, 2453, 2477, 2481,
			 2490,   81, 2494, 2498, 2502, 2468,    0, 2470,    0, 2488,
			    0, 2489,    0, 2491,    0, 2493,    0, 2494, 2484, 2496,

			    0, 2497, 2489, 2499,    0, 2507, 2505, 2504,    0, 2508,
			    0, 2527,   52, 2559, 2563, 2568, 2532,    0, 2534,    0,
			 2554,    0, 2573, 2978, 2633, 2653, 2673, 2693, 2713, 2596,
			 2733, 2744, 2764, 2784, 2804, 2824, 2844, 2864, 2875, 2886,
			 2897, 2917, 2937, 2957, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  823,    1,  824,  824,  823,  823,  823,  823,  823,
			  823,  823,  825,  826,  823,  827,  828,  823,  823,  823,
			  823,  823,  823,  823,  823,  829,  829,  829,  823,  823,
			  823,  823,  823,  823,  823,  823,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,  823,  823,  823,  823,  830,  831,
			  831,  831,  831,  831,  831,  831,  831,  831,  831,  831,
			  831,  831,  831,  831,  831,  831,  831,  831,  831,  823,
			  823,  832,  823,  823,  832,  823,  833,  834,  823,  823,
			  823,  823,  823,  825,  823,  835,  825,  825,  826,  827,

			  836,  836,  836,  823,  823,  823,  823,  823,  823,  837,
			  829,  829,  829,  838,  839,  840,  829,  829,  823,  823,
			  823,  823,  823,  823,   35,   35,   35,   35,   35,  831,
			  831,  831,  831,  831,   35,  831,   35,   35,   35,   35,
			   35,  831,  831,  831,  831,  831,   35,   35,  831,  831,
			   35,   35,   35,  831,  831,  831,   35,   35,   35,  831,
			  831,  831,   35,   35,   35,   35,  831,  831,  831,  831,
			   35,   35,  831,  831,   35,  831,   35,  831,   35,   35,
			   35,   35,  831,  831,  831,  831,   35,  831,   35,  831,
			   35,   35,  831,  831,   35,   35,  831,  831,   35,   35,

			  831,  831,   35,   35,  831,  831,   35,  831,   35,  831,
			  823,  830,  832,  823,  823,  841,  842,  823,  832,  833,
			  834,  823,  832,  832,  835,  827,  827,  835,  835,  825,
			  825,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  829,  829,  829,  838,  838,  839,  839,  840,  840,
			  829,  829,   35,  831,   35,   35,  831,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,   35,  831,  831,   35,  831,

			   35,   35,  831,  831,   35,   35,  831,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,   35,   35,   35,
			   35,  831,  831,  831,  831,  831,   35,  831,   35,   35,
			  831,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,   35,   35,   35,   35,   35,
			  831,  831,  831,  831,  831,  831,   35,   35,  831,  831,
			   35,  831,   35,  831,   35,  831,   35,   35,   35,  831,
			  831,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,  823,  823,  823,  835,  835,  835,  835,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,

			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  829,  829,  838,  838,  839,  839,  268,  840,  829,  829,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,   35,  831,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,   35,  831,  831,
			   35,  831,   35,  831,   35,  831,   35,   35,  831,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,   35,  831,  831,   35,  831,

			   35,  831,   35,  831,   35,  831,   35,   35,  831,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,  835,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  837,  829,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,

			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,  835,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  843,
			   35,  831,   35,  831,   35,  831,   35,   35,  831,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,

			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,   35,  831,   35,  831,   35,  831,
			   35,  831,   35,  831,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,   35,  831,   35,  831,   35,
			  831,   35,  831,   35,  831,   35,  831,   35,  831,   35,

			  831,   35,  831,   35,  831,   35,  831,   35,  831,   35,
			  831,  823,  823,  823,  823,  823,   35,  831,   35,  831,
			   35,  831,  823,    0,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    5,    6,    7,    8,    9,   10,    8,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   22,   22,   22,   22,   22,   23,   23,   24,   25,
			   26,   27,   28,   29,    8,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,
			   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,
			   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,

			   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
			   75,   76,   77,   78,   79,   80,   81,   82,   83,   84,
			   85,   86,   87,   88,    8,   89,    1,    1,    1,    1,
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
			    0,    1,    2,    3,    4,    5,    1,    6,    1,    1,
			    7,    8,    1,    1,    1,    1,    1,    1,    9,    1,
			   10,   11,   12,   13,    1,    1,    1,    1,    1,    1,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   14,   15,   16,    1,    1,    1,    1,
			   17,    1,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   18,   19,   20,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    2,    3,    4,    6,    9,   11,
			   14,   17,   20,   23,   26,   29,   32,   34,   37,   40,
			   43,   46,   49,   52,   55,   58,   62,   66,   70,   73,
			   76,   79,   82,   85,   87,   91,   95,   99,  103,  107,
			  111,  115,  119,  123,  127,  131,  135,  139,  143,  147,
			  151,  155,  159,  163,  167,  170,  172,  175,  178,  180,
			  183,  186,  189,  192,  195,  198,  201,  204,  207,  210,
			  213,  216,  219,  222,  225,  228,  231,  234,  237,  240,
			  243,  246,  248,  250,  252,  255,  257,  259,  261,  262,
			  263,  264,  265,  266,  267,  268,  269,  272,  275,  276,

			  277,  278,  279,  280,  281,  282,  283,  285,  286,  287,
			  287,  289,  291,  292,  294,  295,  296,  296,  298,  299,
			  300,  301,  302,  303,  304,  306,  308,  310,  312,  315,
			  316,  317,  318,  319,  321,  323,  324,  326,  328,  330,
			  332,  334,  335,  336,  337,  338,  339,  341,  344,  345,
			  347,  349,  351,  353,  354,  355,  356,  358,  360,  362,
			  363,  364,  365,  368,  370,  372,  375,  377,  378,  379,
			  381,  383,  385,  386,  387,  389,  390,  392,  393,  395,
			  397,  399,  402,  403,  404,  405,  407,  409,  410,  412,
			  413,  415,  417,  418,  419,  421,  423,  424,  425,  427,

			  429,  430,  431,  433,  435,  436,  437,  439,  440,  442,
			  443,  444,  444,  445,  446,  446,  446,  446,  447,  449,
			  450,  451,  452,  454,  456,  456,  458,  460,  460,  460,
			  462,  464,  465,  467,  468,  469,  470,  471,  472,  473,
			  474,  475,  476,  477,  478,  479,  480,  481,  482,  483,
			  484,  485,  486,  487,  488,  489,  491,  491,  491,  492,
			  494,  495,  497,  499,  499,  502,  504,  507,  509,  512,
			  514,  516,  516,  518,  519,  521,  524,  525,  527,  530,
			  532,  534,  535,  538,  540,  542,  543,  545,  546,  548,
			  549,  551,  552,  554,  555,  557,  559,  560,  561,  563,

			  564,  567,  569,  571,  572,  574,  576,  577,  578,  580,
			  581,  583,  584,  586,  587,  589,  590,  592,  594,  596,
			  598,  600,  601,  602,  603,  604,  605,  607,  608,  610,
			  612,  613,  614,  616,  617,  620,  622,  624,  625,  628,
			  630,  632,  633,  635,  636,  638,  640,  642,  644,  646,
			  648,  649,  650,  651,  652,  653,  654,  656,  658,  659,
			  660,  662,  663,  665,  666,  668,  669,  671,  673,  675,
			  676,  677,  678,  681,  683,  685,  686,  688,  689,  691,
			  692,  695,  697,  698,  699,  700,  701,  702,  702,  703,
			  704,  705,  706,  707,  708,  709,  710,  711,  712,  713,

			  714,  715,  716,  717,  718,  719,  720,  721,  722,  723,
			  724,  725,  727,  727,  729,  729,  731,  731,  731,  731,
			  733,  735,  737,  737,  737,  737,  737,  737,  737,  739,
			  741,  743,  744,  746,  747,  749,  750,  752,  753,  755,
			  756,  758,  760,  761,  762,  764,  765,  767,  768,  770,
			  771,  773,  774,  777,  779,  781,  782,  784,  786,  787,
			  788,  790,  791,  793,  794,  796,  797,  800,  802,  804,
			  805,  807,  808,  810,  811,  813,  814,  816,  817,  819,
			  820,  822,  823,  826,  828,  830,  831,  834,  836,  838,
			  839,  841,  842,  845,  847,  849,  851,  852,  853,  855,

			  856,  858,  859,  861,  862,  864,  865,  867,  869,  870,
			  871,  873,  874,  876,  877,  879,  880,  882,  883,  886,
			  888,  891,  893,  895,  896,  898,  899,  901,  902,  904,
			  905,  908,  910,  913,  915,  915,  916,  917,  919,  919,
			  919,  921,  921,  925,  925,  927,  927,  927,  929,  932,
			  934,  937,  939,  941,  942,  945,  947,  950,  952,  954,
			  955,  957,  958,  960,  961,  963,  964,  967,  969,  971,
			  972,  974,  975,  977,  978,  980,  981,  983,  984,  986,
			  987,  990,  992,  994,  995,  997,  998, 1000, 1001, 1003,
			 1004, 1007, 1009, 1011, 1012, 1014, 1015, 1017, 1018, 1021,

			 1023, 1025, 1026, 1028, 1029, 1031, 1032, 1034, 1035, 1037,
			 1038, 1040, 1041, 1043, 1044, 1046, 1047, 1049, 1050, 1052,
			 1053, 1056, 1058, 1060, 1061, 1063, 1064, 1067, 1069, 1071,
			 1072, 1074, 1075, 1078, 1080, 1082, 1083, 1083, 1084, 1084,
			 1086, 1086, 1087, 1088, 1092, 1092, 1092, 1094, 1094, 1095,
			 1095, 1098, 1100, 1102, 1103, 1105, 1106, 1109, 1111, 1113,
			 1114, 1116, 1117, 1119, 1120, 1123, 1125, 1128, 1130, 1132,
			 1133, 1136, 1138, 1140, 1141, 1143, 1144, 1147, 1149, 1151,
			 1152, 1154, 1155, 1157, 1158, 1160, 1161, 1163, 1164, 1167,
			 1169, 1171, 1172, 1174, 1175, 1178, 1180, 1182, 1183, 1185,

			 1186, 1189, 1191, 1193, 1194, 1197, 1199, 1202, 1204, 1207,
			 1209, 1211, 1212, 1214, 1215, 1218, 1220, 1222, 1223, 1223,
			 1224, 1224, 1224, 1224, 1228, 1228, 1229, 1230, 1230, 1230,
			 1231, 1232, 1233, 1235, 1236, 1239, 1241, 1243, 1244, 1247,
			 1249, 1251, 1252, 1254, 1255, 1257, 1258, 1261, 1263, 1266,
			 1268, 1270, 1271, 1274, 1276, 1279, 1281, 1283, 1284, 1286,
			 1287, 1289, 1290, 1292, 1293, 1295, 1296, 1299, 1301, 1303,
			 1304, 1306, 1307, 1310, 1312, 1313, 1313, 1314, 1314, 1316,
			 1316, 1316, 1317, 1318, 1318, 1319, 1322, 1324, 1327, 1329,
			 1332, 1334, 1337, 1339, 1342, 1344, 1347, 1349, 1351, 1352,

			 1355, 1357, 1359, 1360, 1363, 1365, 1367, 1368, 1371, 1373,
			 1376, 1378, 1379, 1381, 1381, 1383, 1384, 1387, 1389, 1392,
			 1394, 1397, 1399, 1401, 1401, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  141,  141,  162,  160,  161,    3,  160,  161,    4,
			  161,    1,  160,  161,    2,  160,  161,   10,  160,  161,
			  143,  160,  161,  107,  160,  161,   17,  160,  161,  143,
			  160,  161,  160,  161,   11,  160,  161,   12,  160,  161,
			   31,  160,  161,   30,  160,  161,    8,  160,  161,   29,
			  160,  161,    6,  160,  161,   32,  160,  161,  145,  152,
			  160,  161,  145,  152,  160,  161,  145,  152,  160,  161,
			    9,  160,  161,    7,  160,  161,   36,  160,  161,   34,
			  160,  161,   35,  160,  161,  160,  161,  105,  106,  160,
			  161,  105,  106,  160,  161,  105,  106,  160,  161,  105,

			  106,  160,  161,  105,  106,  160,  161,  105,  106,  160,
			  161,  105,  106,  160,  161,  105,  106,  160,  161,  105,
			  106,  160,  161,  105,  106,  160,  161,  105,  106,  160,
			  161,  105,  106,  160,  161,  105,  106,  160,  161,  105,
			  106,  160,  161,  105,  106,  160,  161,  105,  106,  160,
			  161,  105,  106,  160,  161,  105,  106,  160,  161,  105,
			  106,  160,  161,  105,  106,  160,  161,   15,  160,  161,
			  160,  161,   16,  160,  161,   33,  160,  161,  160,  161,
			  106,  160,  161,  106,  160,  161,  106,  160,  161,  106,
			  160,  161,  106,  160,  161,  106,  160,  161,  106,  160,

			  161,  106,  160,  161,  106,  160,  161,  106,  160,  161,
			  106,  160,  161,  106,  160,  161,  106,  160,  161,  106,
			  160,  161,  106,  160,  161,  106,  160,  161,  106,  160,
			  161,  106,  160,  161,  106,  160,  161,  106,  160,  161,
			   13,  160,  161,   14,  160,  161,  141,  161,  139,  161,
			  140,  161,  135,  141,  161,  138,  161,  141,  161,  141,
			  161,    3,    4,    1,    2,   37,  143,  142,  142, -133,
			  143, -294, -134,  143, -295,  107,  143,  131,  131,  131,
			    5,   23,   24,  155,  158,   18,   20,  145,  152,  145,
			  152,  152,  144,  152,  152,  152,  144,  152,   28,   25,

			   22,   21,   26,   27,  105,  106,  105,  106,  105,  106,
			  105,  106,   42,  105,  106,  106,  106,  106,  106,   42,
			  106,  105,  106,  106,  105,  106,  105,  106,  105,  106,
			  105,  106,  105,  106,  106,  106,  106,  106,  106,  105,
			  106,   54,  105,  106,  106,   54,  106,  105,  106,  105,
			  106,  105,  106,  106,  106,  106,  105,  106,  105,  106,
			  105,  106,  106,  106,  106,   66,  105,  106,  105,  106,
			  105,  106,   73,  105,  106,   66,  106,  106,  106,   73,
			  106,  105,  106,  105,  106,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  105,  106,  105,  106,   82,

			  105,  106,  106,  106,  106,   82,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  105,  106,  106,  106,  105,
			  106,  105,  106,  106,  106,  105,  106,  105,  106,  106,
			  106,  105,  106,  105,  106,  106,  106,  105,  106,  106,
			  105,  106,  106,   19,  141,  139,  140,  135,  141,  141,
			  141,  138,  136,  141,  137,  141,  142,  143,  142,  143,
			 -133,  143, -134,  143,  131,  108,  131,  131,  131,  131,
			  131,  131,  131,  131,  131,  131,  131,  131,  131,  131,
			  131,  131,  131,  131,  131,  131,  131,  131,  131,  155,
			  158,  153,  155,  158,  153,  145,  152,  145,  152,  148,

			  151,  152,  151,  152,  147,  150,  152,  150,  152,  146,
			  149,  152,  149,  152,  145,  152,  105,  106,  106,  105,
			  106,   40,  105,  106,  106,   40,  106,   41,  105,  106,
			   41,  106,  105,  106,  106,   44,  105,  106,   44,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  105,  106,  106,
			  106,  105,  106,  106,   57,  105,  106,  105,  106,   57,
			  106,  106,  105,  106,  105,  106,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  105,  106,  105,  106,  105,  106,  105,  106,

			  106,  106,  106,  106,  106,  105,  106,  106,  105,  106,
			  105,  106,  106,  106,  105,  106,  106,   78,  105,  106,
			   78,  106,  105,  106,  106,   80,  105,  106,   80,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  105,  106,
			  105,  106,  105,  106,  105,  106,  105,  106,  106,  106,
			  106,  106,  106,  106,  105,  106,  105,  106,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  105,  106,  105,  106,  106,  106,  106,   97,  105,
			  106,   97,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,  104,  105,  106,  104,  106,  159,  136,  137,

			  142,  142,  142,  125,  123,  124,  126,  127,  132,  128,
			  129,  109,  110,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  155,  158,  155,  158,  155,
			  158,  154,  157,  145,  152,  145,  152,  145,  152,  145,
			  152,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  105,  106,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,   55,  105,  106,   55,  106,  105,
			  106,  106,  105,  106,  105,  106,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,   64,  105,  106,

			  105,  106,   64,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,   74,  105,  106,   74,  106,  105,  106,
			  106,   76,  105,  106,   76,  106,  105,  106,  106,  105,
			  106,  106,   81,  105,  106,   81,  106,  105,  106,  105,
			  106,  106,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  105,  106,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,   95,  105,  106,   95,  106,   96,  105,
			  106,   96,  106,  105,  106,  106,  105,  106,  106,  105,

			  106,  106,  105,  106,  106,  102,  105,  106,  102,  106,
			  103,  105,  106,  103,  106,  132,  155,  155,  158,  155,
			  158,  154,  155,  157,  158,  154,  157,  145,  152,   38,
			  105,  106,   38,  106,   39,  105,  106,   39,  106,  105,
			  106,  106,   45,  105,  106,   45,  106,   46,  105,  106,
			   46,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,   52,  105,  106,   52,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,   62,  105,  106,
			   62,  106,  105,  106,  106,  105,  106,  106,  105,  106,

			  106,  105,  106,  106,   69,  105,  106,   69,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,   75,  105,
			  106,   75,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,   91,  105,  106,   91,  106,  105,  106,
			  106,  105,  106,  106,   94,  105,  106,   94,  106,  105,
			  106,  106,  105,  106,  106,  100,  105,  106,  100,  106,
			  105,  106,  106,  130,  155,  158,  158,  155,  154,  155,
			  157,  158,  154,  157,  153,   43,  105,  106,   43,  106,

			  105,  106,  106,  105,  106,  106,   49,  105,  106,  105,
			  106,   49,  106,  106,  105,  106,  106,  105,  106,  106,
			   56,  105,  106,   56,  106,   58,  105,  106,   58,  106,
			  105,  106,  106,   60,  105,  106,   60,  106,  105,  106,
			  106,  105,  106,  106,   65,  105,  106,   65,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,   77,  105,  106,   77,  106,  105,
			  106,  106,  105,  106,  106,   84,  105,  106,   84,  106,
			  105,  106,  106,  105,  106,  106,   87,  105,  106,   87,
			  106,  105,  106,  106,   89,  105,  106,   89,  106,   90,

			  105,  106,   90,  106,   92,  105,  106,   92,  106,  105,
			  106,  106,  105,  106,  106,   99,  105,  106,   99,  106,
			  105,  106,  106,  155,  154,  155,  157,  158,  158,  154,
			  156,  158,  156,  105,  106,  106,   47,  105,  106,   47,
			  106,  105,  106,  106,   51,  105,  106,   51,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,   63,  105,
			  106,   63,  106,   67,  105,  106,   67,  106,  105,  106,
			  106,   70,  105,  106,   70,  106,   71,  105,  106,   71,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,   88,  105,  106,   88,

			  106,  105,  106,  106,  105,  106,  106,  101,  105,  106,
			  101,  106,  158,  158,  154,  155,  157,  158,  157,   48,
			  105,  106,   48,  106,   50,  105,  106,   50,  106,   53,
			  105,  106,   53,  106,   59,  105,  106,   59,  106,   61,
			  105,  106,   61,  106,   68,  105,  106,   68,  106,  105,
			  106,  106,   79,  105,  106,   79,  106,  105,  106,  106,
			   86,  105,  106,   86,  106,  105,  106,  106,   93,  105,
			  106,   93,  106,   98,  105,  106,   98,  106,  158,  157,
			  158,  157,  158,  157,   72,  105,  106,   72,  106,   83,
			  105,  106,   83,  106,   85,  105,  106,   85,  106,  157,

			  158, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 2978
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 823
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 824
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is true
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is true
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 161
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 162
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	VERBATIM_STR1: INTEGER is 1
			-- Start condition codes

feature -- User-defined features



indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- EDITOR_EIFFEL_SCANNER
