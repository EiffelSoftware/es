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
--|#line 32 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 32")
end
-- Ignore carriage return
when 2 then
--|#line 33 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 33")
end

					create {EDITOR_TOKEN_SPACE} curr_token.make(text_count)
					update_token_list
					
when 3 then
--|#line 37 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 37")
end

					if not in_comments then
						create {EDITOR_TOKEN_TABULATION} curr_token.make(text_count)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 4 then
--|#line 45 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 45")
end

					from i_ := 1 until i_ > text_count loop
						create {EDITOR_TOKEN_EOL} curr_token.make
						update_token_list
						i_ := i_ + 1
					end
					in_comments := False
					
when 5 then
--|#line 57 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 57")
end
 
						-- comments
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					in_comments := True	
					update_token_list					
				
when 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 then
--|#line 66 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 66")
end

						-- Symbols
					if not in_comments then
						create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 then
--|#line 87 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 87")
end
 
						-- Operator Symbol
					if not in_comments then
						create {EDITOR_TOKEN_OPERATOR} curr_token.make(text)					
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104 then
--|#line 117 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 117")
end

										-- Keyword
										if not in_comments then
											create {EDITOR_TOKEN_KEYWORD} curr_token.make(text)
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 105 then
--|#line 197 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 197")
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
--|#line 217 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 217")
end

										if not in_comments then
												create {EDITOR_TOKEN_TEXT} curr_token.make(text)											
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 107 then
--|#line 229 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 229")
end

										if not in_comments then
											create {EDITOR_TOKEN_TEXT} curr_token.make(text)										
										else
											create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
										end
										update_token_list
										
when 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129 then
--|#line 243 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 243")
end

					if not in_comments then
						create {EDITOR_TOKEN_CHARACTER} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 130 then
--|#line 273 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 273")
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
--|#line 288 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 288")
end

					-- Character error. Catch-all rules (no backing up)
					if not in_comments then
						create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 133 then
--|#line 311 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 311")
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
--|#line 325 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 325")
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
--|#line 340 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 340")
end
-- Ignore carriage return
when 136 then
--|#line 341 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 341")
end

							-- Verbatim string closer, possibly.
						create {EDITOR_TOKEN_STRING} curr_token.make(text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 137 then
--|#line 350 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 350")
end

							-- Verbatim string closer, possibly.
						create {EDITOR_TOKEN_STRING} curr_token.make(text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 138 then
--|#line 359 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 359")
end

						create {EDITOR_TOKEN_SPACE} curr_token.make(text_count)
						update_token_list						
					
when 139 then
--|#line 364 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 364")
end
						
						create {EDITOR_TOKEN_TABULATION} curr_token.make(text_count)
						update_token_list						
					
when 140 then
--|#line 369 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 369")
end

						from i_ := 1 until i_ > text_count loop
							create {EDITOR_TOKEN_EOL} curr_token.make
							update_token_list
							i_ := i_ + 1
						end						
					
when 141 then
--|#line 377 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 377")
end

						create {EDITOR_TOKEN_STRING} curr_token.make(text)
						update_token_list
					
when 142, 143 then
--|#line 383 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 383")
end

					-- Eiffel String
					if not in_comments then						
						create {EDITOR_TOKEN_STRING} curr_token.make(text)
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 144 then
--|#line 396 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 396")
end

					-- Eiffel Bit
					if not in_comments then
						create {EDITOR_TOKEN_NUMBER} curr_token.make(text)						
					else
						create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
					end
					update_token_list
					
when 145, 146 then
--|#line 408 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 408")
end

						-- Eiffel Integer
						if not in_comments then
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 147 then
--|#line 418 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 418")
end

							-- Eiffel Integer Error (considered as text)
						if not in_comments then
							create {EDITOR_TOKEN_TEXT} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 148 then
	yy_end := yy_end - 1
--|#line 430 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 430")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 149, 150 then
--|#line 431 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 431")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 151 then
	yy_end := yy_end - 1
--|#line 433 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 433")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 152, 153 then
--|#line 434 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 434")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							create {EDITOR_TOKEN_NUMBER} curr_token.make(text)
						else
							create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
						end
						update_token_list
						
when 154 then
--|#line 451 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 451")
end

					create {EDITOR_TOKEN_TEXT} curr_token.make(text)
					update_token_list
					
when 155 then
--|#line 459 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 459")
end

					-- Error (considered as text)
				if not in_comments then
					create {EDITOR_TOKEN_TEXT} curr_token.make(text)
				else
					create {EDITOR_TOKEN_COMMENT} curr_token.make(text)
				end
				update_token_list
				
when 156 then
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
		once
			Result := yy_fixed_array (<<
			    0,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   40,   41,   40,   40,
			   42,   43,   44,   45,   46,   40,   47,   48,   49,   50,
			   51,   52,   53,   40,   40,   54,   55,   56,   57,   58,
			   59,   60,   61,   62,   63,   64,   65,   66,   66,   67,
			   66,   66,   68,   69,   70,   71,   72,   66,   73,   74,
			   75,   76,   77,   78,   79,   66,   66,   80,   81,   83,
			   84,   85,   86,   83,   84,   85,   86,   95,   95,  104,

			   96,   96,  102,  103,  106,  108,  107,  107,  107,  105,
			  117,  118,  109,  119,  120,  110,  632,  111,  111,  112,
			  110,  144,  111,  111,  112,  122,  110,  113,  112,  112,
			  112,  145,  113,  122,  168,  533,  133,  186,  154,  173,
			  169,  122,  155,  526,   87,   97,  122,  625,   87,  114,
			  209,  209,  209,  146,  415,  156,  115,  127,  175,  113,
			  415,  115,  403,  147,  113,  127,  170,  115,  133,  187,
			  157,  173,  171,  127,  158,   88,  402,   98,  127,   88,
			  401,  114,  122,  122,  122,  204,  122,  159,  185,  209,
			  175,  122,  122,  122,  122,  122,  122,  123,  122,  122,

			  122,  122,  124,  122,  125,  122,  122,  122,  122,  126,
			  122,  122,  122,  122,  122,  122,  122,  205,  127,  400,
			  185,  122,  187,  127,  127,  127,  127,  127,  127,  128,
			  127,  127,  127,  127,  129,  127,  130,  127,  127,  127,
			  127,  131,  127,  127,  127,  127,  127,  127,  127,  122,
			  122,  122,  198,  205,  187,  207,  399,  199,  122,  122,
			  122,  122,  122,  122,  122,  122,  132,  122,  122,  122,
			  122,  122,  122,  122,  122,  122,  122,  122,  122,  122,
			  122,  122,  122,  122,  198,  205,  122,  207,  122,  199,
			  127,  127,  127,  127,  127,  127,  127,  127,  133,  127,

			  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,
			  127,  127,  127,  127,  127,  127,  134,  122,  127,  122,
			  135,  122,  148,  136,  149,  160,  137,  172,  122,  138,
			  122,  122,  161,  162,  150,  398,  174,  397,  163,  214,
			  184,  396,  214,   95,  221,  395,   96,  211,  139,  127,
			  394,  127,  140,  127,  151,  141,  152,  164,  142,  173,
			  127,  143,  127,  127,  165,  166,  153,  176,  175,  188,
			  167,  266,  185,  122,  122,  192,  122,  177,  272,  178,
			  200,  122,  146,  179,  189,  193,  196,  122,  122,  274,
			  128,  197,  147,  206,  201,  129,  393,  130,  276,  180,

			  392,  190,  131,  266,  391,  127,  127,  194,  127,  181,
			  272,  182,  202,  127,  146,  183,  191,  195,  198,  127,
			  127,  274,  128,  199,  147,  207,  203,  129,  139,  130,
			  276,  151,  140,  152,  131,  141,  157,  164,  142,  180,
			  158,  143,  170,  153,  165,  166,  190,  194,  171,  181,
			  167,  182,  202,  159,  278,  183,  212,  195,  213,  213,
			  139,  191,  390,  151,  140,  152,  203,  141,  157,  164,
			  142,  180,  158,  143,  170,  153,  165,  166,  190,  194,
			  171,  181,  167,  182,  202,  159,  278,  183,  213,  195,
			  217,  213,  213,  191,  213,  220,  215,   95,  203,  215,

			   96,  222,  389,  388,  211,  228,  267,  228,  228,  268,
			   95,  214,  386,   96,  385,  229,  384,  229,  229,  280,
			   95,  383,  382,   96,  254,  254,  254,  258,  258,  258,
			  269,  216,  110,  270,  260,  260,  261,  255,  269,  282,
			  259,  270,  215,  218,  113,   97,  110,  214,  261,  261,
			  261,  280,  377,  263,  263,  263,  122,  265,   97,  376,
			  375,  122,  269,  256,  122,  270,  273,   95,   97,  255,
			  378,  282,  259,  115,  219,  275,  113,   98,  215,  224,
			  231,  284,  225,  100,  100,  100,   92,  115,  127,  266,
			   98,  226,  264,  127,   91,   90,  127,  100,  274,  100,

			   98,  100,  100,  227,   89,  271,  100,  276,  100,  216,
			  122,  208,  100,  284,  100,  121,  116,  100,  100,  100,
			  100,  100,  100,  232,   93,   92,  233,  234,  235,  236,
			   95,  379,   91,   96,   96,  237,  277,  272,  286,  122,
			  122,  238,  127,  239,  281,  240,  241,  242,  243,  279,
			  244,  283,  245,  122,   90,  122,  246,  122,  247,  292,
			  122,  248,  249,  250,  251,  252,  253,   89,  278,  285,
			  286,  127,  127,  287,  289,  122,  282,  288,  290,  811,
			  122,  280,  297,  284,  122,  127,  298,  127,  293,  127,
			  303,  292,  127,  122,  291,  299,  295,  122,  122,  300,

			  301,  286,  122,  294,  302,  289,  289,  127,  305,  290,
			  290,  296,  127,  304,  299,  306,  127,  122,  300,  811,
			  295,  122,  304,  308,  811,  127,  292,  299,  295,  127,
			  127,  300,  302,  320,  127,  296,  302,  122,  811,  122,
			  306,  319,  811,  296,  307,  304,  309,  306,  310,  127,
			  311,  122,  314,  127,  315,  308,  316,  326,  325,  328,
			  321,  312,  323,  122,  313,  320,  122,  317,  122,  127,
			  318,  127,  322,  320,  324,  122,  308,  122,  314,  327,
			  315,  333,  316,  127,  314,  329,  315,  122,  316,  326,
			  326,  328,  323,  317,  323,  127,  318,  330,  127,  317,

			  127,  332,  318,  331,  324,  334,  324,  127,  122,  127,
			  335,  328,  336,  334,  122,  811,  811,  330,  351,  127,
			  214,   95,  352,  214,  381,  221,  811,  379,  211,  330,
			  378,  811,  122,  332,  354,  332,  356,  334,  811,  358,
			  127,  353,  336,  343,  336,  344,  127,  337,  122,  338,
			  351,  349,  122,  345,  352,  350,  346,  339,  347,  348,
			  340,  355,  341,  342,  127,  122,  354,  366,  356,  811,
			  122,  358,  365,  354,  369,  343,  122,  344,  368,  343,
			  127,  344,  357,  351,  127,  345,  370,  352,  346,  345,
			  347,  348,  346,  356,  347,  348,  359,  127,  122,  366,

			  362,  360,  127,  372,  366,  363,  370,  367,  127,  371,
			  368,  122,  361,  122,  358,  374,  364,  419,  370,  811,
			  373,  209,  209,  209,  212,  122,  213,  213,  362,  811,
			  127,  421,  362,  363,  811,  372,  811,  363,  811,  368,
			  811,  372,  811,  127,  364,  127,  122,  374,  364,  419,
			  122,  213,  374,  213,  213,  418,  213,  127,  217,  213,
			  209,  215,  811,  421,  215,  213,  222,  213,  220,  211,
			   95,  422,  228,  378,  228,  228,  811,   95,  127,  214,
			   96,  811,  127,  380,  380,  380,  229,  419,  229,  229,
			  420,   95,  423,  811,   96,  387,  387,  387,  122,  404,

			  404,  404,  405,  423,  405,  811,  214,  406,  406,  406,
			  215,  218,  255,  407,  407,  407,  408,  408,  408,  811,
			  214,  411,  421,  411,  423,   97,  412,  412,  412,  409,
			  127,  110,  122,  413,  413,  414,  425,  215,  256,   97,
			  811,  811,  219,  113,  255,  110,  427,  414,  414,  414,
			  424,  215,  416,  416,  416,  410,  122,   98,  417,  417,
			  417,  409,  433,  122,  127,  811,  432,  428,  425,  430,
			  122,   98,  115,  426,  122,  113,  435,  437,  427,  439,
			  122,  122,  425,  429,  441,  431,  115,  122,  127,  434,
			  811,  264,  438,  436,  433,  127,  122,  264,  433,  430,

			  440,  430,  127,  443,  122,  427,  127,  449,  435,  437,
			  122,  439,  127,  127,  448,  431,  441,  431,  122,  127,
			  446,  435,  442,  444,  439,  437,  451,  122,  127,  453,
			  122,  122,  441,  459,  447,  443,  127,  445,  452,  449,
			  450,  462,  127,  122,  456,  122,  449,  454,  458,  460,
			  127,  461,  446,  122,  443,  446,  463,  457,  451,  127,
			  455,  453,  127,  127,  464,  459,  447,  122,  122,  447,
			  453,  465,  451,  463,  466,  127,  456,  127,  468,  456,
			  459,  461,  467,  461,  469,  127,  122,  470,  463,  457,
			  471,  122,  457,  472,  473,  122,  465,  475,  476,  127,

			  127,  122,  474,  465,  477,  122,  467,  122,  479,  122,
			  469,  480,  481,  478,  467,  122,  469,  484,  127,  471,
			  485,  811,  471,  127,  486,  473,  473,  127,  122,  475,
			  477,  811,  482,  127,  475,  483,  477,  127,  122,  127,
			  479,  127,  488,  481,  481,  479,  122,  127,  494,  484,
			  490,  122,  485,  122,  122,  487,  487,  489,  122,  491,
			  127,  493,  498,  492,  484,  811,  495,  485,  499,  500,
			  127,  501,  503,  122,  489,  504,  502,  505,  127,  496,
			  496,  507,  491,  127,  122,  127,  127,  487,  508,  489,
			  127,  491,  122,  493,  499,  493,  509,  497,  497,  514,

			  499,  501,  510,  501,  503,  127,  122,  505,  503,  505,
			  122,  496,  511,  507,  122,  506,  127,  513,  515,  122,
			  509,  516,  512,  517,  127,  518,  519,  122,  509,  497,
			  122,  515,  520,  521,  511,  122,   95,  537,  127,  378,
			   95,  811,  127,  378,  511,  379,  127,  507,  378,  513,
			  515,  127,  100,  517,  513,  517,  811,  519,  519,  127,
			   95,  811,  127,  378,  521,  521,  539,  127,  541,  537,
			  100,  811,  100,  522,  522,  522,  523,  387,  387,  387,
			  524,  524,  524,  406,  406,  406,  811,  525,  525,  525,
			  527,  527,  527,  255,  528,  528,  528,  529,  539,  529,

			  541,  811,  530,  530,  530,  543,  122,  409,  531,  531,
			  531,  412,  412,  412,  532,  532,  532,  536,  534,  256,
			  413,  413,  414,  545,  546,  255,  526,  535,  535,  535,
			  113,  547,  534,  410,  414,  414,  414,  543,  127,  409,
			  417,  417,  417,  540,  122,  122,  122,  811,  542,  537,
			  122,  549,  551,  533,  538,  545,  547,  548,  122,  264,
			  544,  122,  113,  547,  552,  553,  264,  555,  122,  550,
			  554,  557,  122,  264,  558,  541,  127,  127,  127,  264,
			  543,  559,  127,  549,  551,  122,  539,  561,  563,  549,
			  127,  565,  545,  127,  556,  567,  553,  553,  122,  555,

			  127,  551,  555,  557,  127,  122,  559,  560,  569,  122,
			  562,  568,  122,  559,  571,  122,  122,  127,  564,  561,
			  563,  566,  122,  565,  573,  572,  557,  567,  570,  122,
			  127,  574,  575,  577,  122,  579,  122,  127,  581,  561,
			  569,  127,  563,  569,  127,  583,  571,  127,  127,  576,
			  565,  578,  585,  567,  127,  582,  573,  573,  122,  122,
			  571,  127,  122,  575,  575,  577,  127,  579,  127,  122,
			  581,  580,  122,  587,  122,  586,  588,  583,  584,  122,
			  589,  577,  122,  579,  585,  590,  591,  583,  122,  594,
			  127,  127,  593,  595,  127,  596,  597,  122,  122,  599,

			  601,  127,  602,  581,  127,  587,  127,  587,  589,  592,
			  585,  127,  589,  122,  127,  122,  603,  591,  591,  600,
			  127,  595,  598,  122,  593,  595,  605,  597,  597,  127,
			  127,  599,  601,  122,  603,  604,  606,  607,  609,  611,
			  122,  593,  613,  610,  122,  127,  615,  127,  603,  122,
			  122,  601,  122,  612,  599,  127,  608,  614,  605,  122,
			  616,  617,  619,  122,  621,  127,  811,  605,  607,  607,
			  609,  611,  127,  623,  613,  611,  127,  122,  615,  622,
			  620,  127,  127,  122,  127,  613,  122,  122,  609,  615,
			  122,  127,  617,  617,  619,  127,  621,  122,  618,  811,

			  811,  524,  524,  524,  811,  623,  627,  627,  627,  127,
			  811,  623,  621,   95,  626,  127,  378,  811,  127,  127,
			  811,  811,  127,  811,  811,  100,  624,  624,  624,  127,
			  619,  628,  628,  628,  629,  629,  629,  630,  630,  630,
			  530,  530,  530,  122,  811,  526,  626,  631,  631,  631,
			  409,  633,  633,  633,  634,  634,  634,  635,  635,  635,
			  630,  630,  630,  637,  122,  417,  417,  417,  639,  638,
			  122,  122,  811,  636,  122,  127,  410,  641,  122,  640,
			  643,  644,  409,  649,  646,  645,  632,  642,  647,  122,
			  122,  651,  652,  533,  648,  122,  127,  653,  122,  655,

			  639,  639,  127,  127,  115,  636,  127,  650,  657,  641,
			  127,  641,  643,  646,  654,  649,  646,  647,  122,  643,
			  647,  127,  127,  651,  653,  122,  649,  127,  656,  653,
			  127,  655,  659,  122,  661,  122,  658,  122,  122,  651,
			  657,  663,  660,  122,  665,  666,  655,  662,  664,  122,
			  127,  667,  668,  669,  122,  670,  671,  127,  673,  674,
			  657,  675,  122,  677,  659,  127,  661,  127,  659,  127,
			  127,  679,  672,  663,  661,  127,  665,  667,  122,  663,
			  665,  127,  122,  667,  669,  669,  127,  671,  671,  681,
			  673,  675,  678,  675,  127,  677,  122,  122,  676,  683,

			  122,  684,  685,  679,  673,  686,  680,  687,  688,  122,
			  127,  689,  122,  122,  127,  682,  691,  693,  695,  692,
			  122,  681,  690,  122,  679,  122,  697,  699,  127,  127,
			  677,  683,  127,  685,  685,  122,  694,  687,  681,  687,
			  689,  127,  122,  689,  127,  127,  696,  683,  691,  693,
			  695,  693,  127,  698,  691,  127,  700,  127,  697,  699,
			  701,  122,  702,  703,  122,  122,  122,  127,  695,  705,
			  704,  707,  707,  707,  127,  706,  811,  706,  697,  709,
			  707,  707,  707,  811,  811,  699,  811,  811,  701,  708,
			  708,  708,  701,  127,  703,  703,  127,  127,  127,  811,

			  122,  705,  705,  811,  811,  256,  630,  630,  630,  721,
			  526,  709,  811,  711,  711,  711,  712,  712,  712,  710,
			  713,  713,  713,  714,  714,  714,  715,  715,  715,  716,
			  811,  716,  127,  723,  714,  714,  714,  718,  718,  718,
			  720,  721,  122,  122,  122,  725,  122,  727,  122,  729,
			  719,  710,  632,  722,  724,  728,  122,  726,  122,  122,
			  730,  731,  533,  122,  122,  723,  733,  734,  735,  122,
			  811,  122,  721,  122,  127,  127,  127,  725,  127,  727,
			  127,  729,  719,  736,  737,  723,  725,  729,  127,  727,
			  127,  127,  731,  731,  732,  127,  127,  739,  733,  735,

			  735,  127,  122,  127,  122,  127,  122,  741,  122,  738,
			  743,  745,  744,  122,  122,  737,  737,  740,  747,  742,
			  122,  122,  749,  122,  751,  746,  733,  122,  122,  739,
			  753,  748,  750,  752,  127,  122,  127,  755,  127,  741,
			  127,  739,  743,  745,  745,  127,  127,  122,  122,  741,
			  747,  743,  127,  127,  749,  127,  751,  747,  122,  127,
			  127,  122,  753,  749,  751,  753,  754,  127,  757,  755,
			  122,  122,  756,  759,  122,  122,  758,  761,  811,  127,
			  127,  707,  707,  707,  811,  811,  760,  707,  707,  707,
			  127,  774,  811,  127,  762,  762,  762,  811,  755,  811,

			  757,  811,  127,  127,  757,  759,  127,  127,  759,  761,
			  763,  768,  763,  811,  811,  764,  764,  764,  761,  765,
			  811,  765,  122,  774,  766,  766,  766,  766,  766,  766,
			  767,  767,  767,  714,  714,  714,  773,  410,  769,  769,
			  769,  122,  776,  768,  714,  714,  714,  770,  770,  770,
			  771,  122,  771,  122,  127,  772,  772,  772,  775,  777,
			  768,  778,  779,  780,  122,  782,  632,  122,  774,  122,
			  122,  122,  781,  127,  776,  783,  784,  122,  122,  122,
			  786,  788,  122,  127,  787,  127,  410,  785,  122,  790,
			  776,  778,  768,  778,  780,  780,  127,  782,  792,  127,

			  122,  127,  127,  127,  782,  794,  789,  784,  784,  127,
			  127,  127,  786,  788,  127,  122,  788,  793,  791,  786,
			  127,  790,  122,  122,  795,  796,  798,  797,  122,  122,
			  792,  122,  127,  764,  764,  764,  122,  794,  790,  799,
			  799,  799,  766,  766,  766,  811,  811,  127,  811,  794,
			  792,  766,  766,  766,  127,  127,  796,  796,  798,  798,
			  127,  127,  122,  127,  800,  800,  800,  801,  127,  801,
			  122,  122,  802,  802,  802,  713,  713,  713,  526,  772,
			  772,  772,  803,  803,  803,  122,  122,  122,  768,  811,
			  805,  122,  122,  807,  127,  122,  808,  809,  804,  122,

			  122,  806,  127,  127,  122,  762,  762,  762,  802,  802,
			  802,  810,  810,  810,  410,  122,  122,  127,  127,  127,
			  768,  533,  805,  127,  127,  807,  122,  127,  809,  809,
			  805,  127,  127,  807,  811,  811,  127,  769,  769,  769,
			  800,  800,  800,  811,  526,  811,  811,  127,  127,  811,
			  632,  262,  262,  262,  811,  811,  811,  811,  127,  127,
			  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,
			  811,  811,  811,  811,  811,  811,  533,  811,  811,  632,
			   82,   82,   82,   82,   82,   82,   82,   82,   82,   82,
			   82,   82,   82,   82,   82,   82,   82,   82,   82,   82,

			   94,   94,  811,   94,   94,   94,   94,   94,   94,   94,
			   94,   94,   94,   94,   94,   94,   94,   94,   94,   94,
			   99,  811,  811,  811,  811,  811,  811,   99,   99,   99,
			   99,   99,   99,   99,   99,   99,   99,   99,   99,   99,
			  100,  100,  811,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  101,  101,  811,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  210,  210,  811,  210,  210,  210,  811,  811,  210,  210,
			  210,  210,  210,  210,  210,  210,  210,  210,  210,  210,

			  211,  811,  811,  211,  811,  211,  211,  211,  211,  211,
			  211,  211,  211,  211,  211,  211,  211,  211,  211,  211,
			  218,  218,  811,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  219,  219,  811,  219,  219,  219,  219,  219,  219,  219,
			  219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
			  223,  223,  811,  223,  223,  223,  223,  223,  223,  223,
			  223,  223,  223,  223,  223,  223,  223,  223,  223,  223,
			  230,  230,  811,  230,  230,  230,  230,  230,  230,  230,
			  230,  230,  230,  230,  230,  230,  230,  230,  230,  230,

			  257,  257,  257,  257,  257,  257,  257,  257,  811,  257,
			  257,  257,  257,  257,  257,  257,  257,  257,  257,  257,
			  214,  214,  811,  214,  214,  214,  811,  214,  214,  214,
			  214,  214,  214,  214,  214,  214,  214,  214,  214,  214,
			  215,  215,  811,  215,  215,  215,  811,  215,  215,  215,
			  215,  215,  215,  215,  215,  215,  215,  215,  215,  215,
			  717,  717,  717,  717,  717,  717,  717,  717,  811,  717,
			  717,  717,  717,  717,  717,  717,  717,  717,  717,  717,
			    5,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,

			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    3,
			    3,    3,    3,    4,    4,    4,    4,   12,   15,   22,

			   12,   15,   16,   16,   23,   24,   23,   23,   23,   22,
			   30,   30,   24,   32,   32,   25,  800,   25,   25,   25,
			   26,   37,   26,   26,   26,   37,   27,   25,   27,   27,
			   27,   37,   26,   40,   42,  769,   61,   47,   39,   69,
			   42,   47,   39,  762,    3,   12,   39,  523,    4,   25,
			   58,   58,   58,   37,  415,   39,   25,   37,   70,   25,
			  262,   26,  253,   37,   26,   40,   42,   27,   61,   47,
			   39,   69,   42,   47,   39,    3,  252,   12,   39,    4,
			  251,   25,   34,   34,   34,   52,   52,   39,   72,   58,
			   70,   34,   34,   34,   34,   34,   34,   34,   34,   34,

			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   52,   52,  250,
			   72,   34,   73,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   35,
			   35,   35,   76,   78,   73,   79,  249,   76,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   76,   78,  122,   79,   35,   76,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,

			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   36,   36,  122,   38,
			   36,   43,   38,   36,   38,   41,   36,   43,   41,   36,
			   44,   46,   41,   41,   38,  248,   44,  247,   41,   87,
			   46,  246,   87,  100,   87,  245,  100,   87,   36,   36,
			  244,   38,   36,   43,   38,   36,   38,   41,   36,   43,
			   41,   36,   44,   46,   41,   41,   38,   45,   44,   48,
			   41,  128,   46,   48,   45,   49,   49,   45,  130,   45,
			   51,   50,   63,   45,   48,   49,   50,   53,   51,  131,
			   60,   50,   63,   53,   51,   60,  243,   60,  133,   45,

			  242,   48,   60,  128,  241,   48,   45,   49,   49,   45,
			  130,   45,   51,   50,   63,   45,   48,   49,   50,   53,
			   51,  131,   60,   50,   63,   53,   51,   60,   62,   60,
			  133,   64,   62,   64,   60,   62,   65,   67,   62,   71,
			   65,   62,   68,   64,   67,   67,   74,   75,   68,   71,
			   67,   71,   77,   65,  139,   71,   83,   75,   83,   83,
			   62,   74,  240,   64,   62,   64,   77,   62,   65,   67,
			   62,   71,   65,   62,   68,   64,   67,   67,   74,   75,
			   68,   71,   67,   71,   77,   65,  139,   71,   85,   75,
			   85,   85,   86,   74,   86,   86,   88,   94,   77,   88,

			   94,   88,  239,  238,   88,   97,  124,   97,   97,  124,
			   97,   83,  236,   97,  235,   98,  234,   98,   98,  140,
			   98,  233,  232,   98,  107,  107,  107,  110,  110,  110,
			  129,  216,  111,  129,  111,  111,  111,  107,  124,  141,
			  110,  124,   83,   85,  111,   94,  112,   86,  112,  112,
			  112,  140,  215,  115,  115,  115,  126,  123,   97,  214,
			  210,  123,  129,  107,  132,  129,  126,  223,   98,  107,
			  223,  141,  110,  111,   85,  132,  111,   94,   86,   96,
			  101,  142,   96,   96,   96,   96,   92,  112,  126,  123,
			   97,   96,  115,  123,   91,   90,  132,   96,  126,   96,

			   98,   96,   96,   96,   89,  125,   96,  132,   96,   84,
			  125,   55,   96,  142,   96,   33,   28,   96,   96,   96,
			   96,   96,   96,  102,   11,   10,  102,  102,  102,  102,
			  224,  225,    9,  224,  225,  102,  134,  125,  143,  136,
			  134,  102,  125,  102,  136,  102,  102,  102,  102,  135,
			  102,  137,  102,  145,    8,  137,  102,  135,  102,  151,
			  138,  102,  102,  102,  102,  102,  102,    7,  134,  138,
			  143,  136,  134,  144,  146,  150,  136,  144,  146,    5,
			  144,  135,  150,  137,  148,  145,  150,  137,  149,  135,
			  155,  151,  138,  149,  148,  153,  152,  154,  155,  153,

			  154,  138,  156,  149,  157,  144,  146,  150,  156,  144,
			  146,  152,  144,  158,  150,  159,  148,  160,  150,    0,
			  149,  163,  155,  165,    0,  149,  148,  153,  152,  154,
			  155,  153,  154,  170,  156,  149,  157,  161,    0,  168,
			  156,  168,    0,  152,  161,  158,  162,  159,  162,  160,
			  162,  162,  166,  163,  166,  165,  166,  173,  172,  175,
			  169,  162,  171,  172,  162,  170,  169,  166,  174,  161,
			  166,  168,  169,  168,  171,  176,  161,  179,  162,  174,
			  162,  178,  162,  162,  166,  176,  166,  178,  166,  173,
			  172,  175,  169,  162,  171,  172,  162,  180,  169,  166,

			  174,  181,  166,  177,  169,  182,  171,  176,  177,  179,
			  184,  174,  185,  178,  184,    0,    0,  176,  190,  178,
			  218,  227,  190,  218,  227,  218,    0,  378,  218,  180,
			  378,    0,  189,  181,  191,  177,  194,  182,    0,  195,
			  177,  189,  184,  187,  185,  187,  184,  186,  188,  186,
			  190,  188,  186,  187,  190,  188,  187,  186,  187,  187,
			  186,  192,  186,  186,  189,  192,  191,  199,  194,    0,
			  193,  195,  197,  189,  201,  187,  197,  187,  202,  186,
			  188,  186,  193,  188,  186,  187,  203,  188,  187,  186,
			  187,  187,  186,  192,  186,  186,  196,  192,  200,  199,

			  198,  196,  193,  205,  197,  198,  201,  200,  197,  204,
			  202,  206,  196,  204,  193,  207,  198,  266,  203,    0,
			  206,  209,  209,  209,  212,  268,  212,  212,  196,    0,
			  200,  269,  198,  196,    0,  205,    0,  198,    0,  200,
			    0,  204,    0,  206,  196,  204,  271,  207,  198,  266,
			  265,  213,  206,  213,  213,  265,  217,  268,  217,  217,
			  209,  219,    0,  269,  219,  220,  219,  220,  220,  219,
			  226,  273,  228,  226,  228,  228,    0,  228,  271,  212,
			  228,    0,  265,  226,  226,  226,  229,  265,  229,  229,
			  267,  229,  274,    0,  229,  237,  237,  237,  267,  254,

			  254,  254,  255,  273,  255,    0,  213,  255,  255,  255,
			  212,  217,  254,  256,  256,  256,  258,  258,  258,    0,
			  220,  259,  267,  259,  274,  228,  259,  259,  259,  258,
			  267,  260,  275,  260,  260,  260,  278,  213,  254,  229,
			    0,    0,  217,  260,  254,  261,  280,  261,  261,  261,
			  277,  220,  263,  263,  263,  258,  277,  228,  264,  264,
			  264,  258,  284,  279,  275,    0,  283,  281,  278,  282,
			  281,  229,  260,  279,  283,  260,  286,  289,  280,  290,
			  285,  287,  277,  281,  292,  282,  261,  293,  277,  285,
			    0,  263,  288,  287,  284,  279,  288,  264,  283,  281,

			  291,  282,  281,  296,  291,  279,  283,  300,  286,  289,
			  294,  290,  285,  287,  298,  281,  292,  282,  298,  293,
			  299,  285,  294,  297,  288,  287,  302,  303,  288,  304,
			  301,  297,  291,  308,  299,  296,  291,  297,  303,  300,
			  301,  310,  294,  305,  306,  307,  298,  305,  307,  309,
			  298,  314,  299,  309,  294,  297,  315,  306,  302,  303,
			  305,  304,  301,  297,  311,  308,  299,  312,  311,  297,
			  303,  316,  301,  310,  312,  305,  306,  307,  313,  305,
			  307,  309,  317,  314,  318,  309,  313,  319,  315,  306,
			  320,  319,  305,  321,  323,  322,  311,  324,  325,  312,

			  311,  321,  322,  316,  326,  327,  312,  329,  330,  331,
			  313,  333,  334,  329,  317,  333,  318,  336,  313,  319,
			  336,    0,  320,  319,  337,  321,  323,  322,  337,  324,
			  325,    0,  335,  321,  322,  335,  326,  327,  335,  329,
			  330,  331,  338,  333,  334,  329,  338,  333,  341,  336,
			  339,  340,  336,  342,  341,  343,  337,  344,  339,  345,
			  337,  346,  342,  340,  335,    0,  341,  335,  348,  349,
			  335,  351,  352,  349,  338,  353,  350,  354,  338,  347,
			  341,  356,  339,  340,  350,  342,  341,  343,  357,  344,
			  339,  345,  357,  346,  342,  340,  358,  347,  341,  361,

			  348,  349,  359,  351,  352,  349,  359,  353,  350,  354,
			  355,  347,  362,  356,  360,  355,  350,  363,  364,  365,
			  357,  367,  360,  368,  357,  369,  370,  371,  358,  347,
			  369,  361,  371,  372,  359,  373,  379,  419,  359,  379,
			  624,    0,  355,  624,  362,  381,  360,  355,  381,  363,
			  364,  365,  624,  367,  360,  368,    0,  369,  370,  371,
			  380,    0,  369,  380,  371,  372,  421,  373,  423,  419,
			  381,    0,  380,  380,  380,  380,  387,  387,  387,  387,
			  404,  404,  404,  405,  405,  405,    0,  406,  406,  406,
			  407,  407,  407,  404,  408,  408,  408,  409,  421,  409,

			  423,    0,  409,  409,  409,  425,  418,  408,  410,  410,
			  410,  411,  411,  411,  412,  412,  412,  418,  413,  404,
			  413,  413,  413,  427,  428,  404,  406,  416,  416,  416,
			  413,  430,  414,  408,  414,  414,  414,  425,  418,  408,
			  417,  417,  417,  422,  420,  422,  424,    0,  424,  418,
			  426,  431,  433,  412,  420,  427,  428,  429,  432,  413,
			  426,  429,  413,  430,  434,  435,  416,  437,  434,  432,
			  436,  439,  436,  414,  440,  422,  420,  422,  424,  417,
			  424,  441,  426,  431,  433,  438,  420,  443,  446,  429,
			  432,  447,  426,  429,  438,  449,  434,  435,  442,  437,

			  434,  432,  436,  439,  436,  444,  440,  442,  451,  445,
			  444,  450,  448,  441,  453,  450,  452,  438,  445,  443,
			  446,  448,  454,  447,  457,  455,  438,  449,  452,  455,
			  442,  458,  459,  461,  460,  463,  462,  444,  465,  442,
			  451,  445,  444,  450,  448,  467,  453,  450,  452,  460,
			  445,  462,  469,  448,  454,  466,  457,  455,  470,  466,
			  452,  455,  464,  458,  459,  461,  460,  463,  462,  468,
			  465,  464,  472,  473,  474,  472,  476,  467,  468,  476,
			  477,  460,  478,  462,  469,  478,  479,  466,  480,  483,
			  470,  466,  484,  485,  464,  486,  487,  482,  486,  489,

			  491,  468,  492,  464,  472,  473,  474,  472,  476,  482,
			  468,  476,  477,  488,  478,  490,  493,  478,  479,  490,
			  480,  483,  488,  494,  484,  485,  496,  486,  487,  482,
			  486,  489,  491,  495,  492,  494,  495,  497,  499,  501,
			  498,  482,  503,  500,  502,  488,  505,  490,  493,  500,
			  504,  490,  506,  502,  488,  494,  498,  504,  496,  508,
			  510,  511,  513,  510,  515,  495,    0,  494,  495,  497,
			  499,  501,  498,  517,  503,  500,  502,  514,  505,  516,
			  514,  500,  504,  518,  506,  502,  512,  516,  498,  504,
			  520,  508,  510,  511,  513,  510,  515,  536,  512,    0,

			    0,  524,  524,  524,    0,  517,  525,  525,  525,  514,
			    0,  516,  514,  522,  524,  518,  522,    0,  512,  516,
			    0,    0,  520,    0,    0,  522,  522,  522,  522,  536,
			  512,  526,  526,  526,  527,  527,  527,  528,  528,  528,
			  529,  529,  529,  538,    0,  525,  524,  530,  530,  530,
			  528,  531,  531,  531,  532,  532,  532,  533,  533,  533,
			  534,  534,  534,  535,  540,  535,  535,  535,  541,  540,
			  542,  544,    0,  534,  546,  538,  528,  547,  548,  546,
			  549,  550,  528,  553,  551,  550,  530,  548,  551,  552,
			  554,  557,  558,  532,  552,  558,  540,  559,  556,  561,

			  541,  540,  542,  544,  535,  534,  546,  556,  563,  547,
			  548,  546,  549,  550,  560,  553,  551,  550,  560,  548,
			  551,  552,  554,  557,  558,  564,  552,  558,  562,  559,
			  556,  561,  565,  562,  567,  568,  564,  566,  570,  556,
			  563,  571,  566,  572,  573,  574,  560,  570,  572,  574,
			  560,  575,  576,  577,  578,  580,  581,  564,  583,  584,
			  562,  585,  586,  589,  565,  562,  567,  568,  564,  566,
			  570,  591,  582,  571,  566,  572,  573,  574,  582,  570,
			  572,  574,  588,  575,  576,  577,  578,  580,  581,  593,
			  583,  584,  590,  585,  586,  589,  590,  592,  588,  595,

			  594,  596,  597,  591,  582,  598,  592,  599,  600,  598,
			  582,  601,  600,  602,  588,  594,  603,  605,  607,  604,
			  608,  593,  602,  604,  590,  606,  611,  613,  590,  592,
			  588,  595,  594,  596,  597,  610,  606,  598,  592,  599,
			  600,  598,  614,  601,  600,  602,  610,  594,  603,  605,
			  607,  604,  608,  612,  602,  604,  616,  606,  611,  613,
			  617,  612,  618,  619,  620,  622,  618,  610,  606,  623,
			  622,  627,  627,  627,  614,  626,    0,  626,  610,  629,
			  626,  626,  626,    0,    0,  612,    0,    0,  616,  628,
			  628,  628,  617,  612,  618,  619,  620,  622,  618,    0,

			  638,  623,  622,    0,    0,  629,  630,  630,  630,  641,
			  627,  629,    0,  631,  631,  631,  632,  632,  632,  630,
			  633,  633,  633,  634,  634,  634,  635,  635,  635,  636,
			    0,  636,  638,  643,  636,  636,  636,  637,  637,  637,
			  640,  641,  642,  644,  640,  647,  648,  649,  645,  651,
			  637,  630,  631,  642,  645,  650,  652,  648,  654,  650,
			  656,  657,  634,  658,  656,  643,  661,  662,  663,  664,
			    0,  662,  640,  666,  642,  644,  640,  647,  648,  649,
			  645,  651,  637,  666,  667,  642,  645,  650,  652,  648,
			  654,  650,  656,  657,  660,  658,  656,  669,  661,  662,

			  663,  664,  660,  662,  668,  666,  670,  671,  672,  668,
			  673,  675,  674,  676,  678,  666,  667,  670,  679,  672,
			  674,  680,  681,  682,  685,  678,  660,  684,  686,  669,
			  687,  680,  684,  686,  660,  688,  668,  691,  670,  671,
			  672,  668,  673,  675,  674,  676,  678,  692,  694,  670,
			  679,  672,  674,  680,  681,  682,  685,  678,  696,  684,
			  686,  698,  687,  680,  684,  686,  690,  688,  699,  691,
			  690,  700,  698,  701,  702,  704,  700,  705,    0,  692,
			  694,  706,  706,  706,    0,    0,  704,  707,  707,  707,
			  696,  721,    0,  698,  708,  708,  708,    0,  690,    0,

			  699,    0,  690,  700,  698,  701,  702,  704,  700,  705,
			  709,  713,  709,    0,    0,  709,  709,  709,  704,  710,
			    0,  710,  722,  721,  710,  710,  710,  711,  711,  711,
			  712,  712,  712,  714,  714,  714,  720,  713,  715,  715,
			  715,  720,  725,  713,  716,  716,  716,  718,  718,  718,
			  719,  726,  719,  724,  722,  719,  719,  719,  724,  728,
			  718,  729,  730,  731,  728,  733,  711,  730,  720,  732,
			  734,  736,  732,  720,  725,  738,  739,  738,  740,  742,
			  745,  747,  744,  726,  746,  724,  718,  744,  746,  749,
			  724,  728,  718,  729,  730,  731,  728,  733,  751,  730,

			  748,  732,  734,  736,  732,  753,  748,  738,  739,  738,
			  740,  742,  745,  747,  744,  754,  746,  752,  750,  744,
			  746,  749,  750,  752,  756,  757,  759,  758,  756,  760,
			  751,  758,  748,  763,  763,  763,  773,  753,  748,  764,
			  764,  764,  765,  765,  765,    0,    0,  754,    0,  752,
			  750,  766,  766,  766,  750,  752,  756,  757,  759,  758,
			  756,  760,  775,  758,  767,  767,  767,  768,  773,  768,
			  777,  779,  768,  768,  768,  770,  770,  770,  764,  771,
			  771,  771,  772,  772,  772,  781,  783,  785,  770,    0,
			  786,  787,  789,  790,  775,  791,  793,  794,  785,  795,

			  793,  789,  777,  779,  797,  799,  799,  799,  801,  801,
			  801,  802,  802,  802,  770,  804,  806,  781,  783,  785,
			  770,  772,  786,  787,  789,  790,  808,  791,  793,  794,
			  785,  795,  793,  789,    0,    0,  797,  803,  803,  803,
			  810,  810,  810,    0,  799,    0,    0,  804,  806,    0,
			  802,  825,  825,  825,    0,    0,    0,    0,  808,  818,
			  818,  818,  818,  818,  818,  818,  818,  818,  818,  818,
			    0,    0,    0,    0,    0,    0,  803,    0,    0,  810,
			  812,  812,  812,  812,  812,  812,  812,  812,  812,  812,
			  812,  812,  812,  812,  812,  812,  812,  812,  812,  812,

			  813,  813,    0,  813,  813,  813,  813,  813,  813,  813,
			  813,  813,  813,  813,  813,  813,  813,  813,  813,  813,
			  814,    0,    0,    0,    0,    0,    0,  814,  814,  814,
			  814,  814,  814,  814,  814,  814,  814,  814,  814,  814,
			  815,  815,    0,  815,  815,  815,  815,  815,  815,  815,
			  815,  815,  815,  815,  815,  815,  815,  815,  815,  815,
			  816,  816,    0,  816,  816,  816,  816,  816,  816,  816,
			  816,  816,  816,  816,  816,  816,  816,  816,  816,  816,
			  817,  817,    0,  817,  817,  817,    0,    0,  817,  817,
			  817,  817,  817,  817,  817,  817,  817,  817,  817,  817,

			  819,    0,    0,  819,    0,  819,  819,  819,  819,  819,
			  819,  819,  819,  819,  819,  819,  819,  819,  819,  819,
			  820,  820,    0,  820,  820,  820,  820,  820,  820,  820,
			  820,  820,  820,  820,  820,  820,  820,  820,  820,  820,
			  821,  821,    0,  821,  821,  821,  821,  821,  821,  821,
			  821,  821,  821,  821,  821,  821,  821,  821,  821,  821,
			  822,  822,    0,  822,  822,  822,  822,  822,  822,  822,
			  822,  822,  822,  822,  822,  822,  822,  822,  822,  822,
			  823,  823,    0,  823,  823,  823,  823,  823,  823,  823,
			  823,  823,  823,  823,  823,  823,  823,  823,  823,  823,

			  824,  824,  824,  824,  824,  824,  824,  824,    0,  824,
			  824,  824,  824,  824,  824,  824,  824,  824,  824,  824,
			  826,  826,    0,  826,  826,  826,    0,  826,  826,  826,
			  826,  826,  826,  826,  826,  826,  826,  826,  826,  826,
			  827,  827,    0,  827,  827,  827,    0,  827,  827,  827,
			  827,  827,  827,  827,  827,  827,  827,  827,  827,  827,
			  828,  828,  828,  828,  828,  828,  828,  828,    0,  828,
			  828,  828,  828,  828,  828,  828,  828,  828,  828,  828,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,

			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   87,   91,  679, 2780,  665,  651,  628,
			  620,  618,   90,    0, 2780,   91,   92, 2780, 2780, 2780,
			 2780, 2780,   82,   86,   86,   97,  102,  108,  590, 2780,
			   85, 2780,   87,  589,  162,  229,  280,   88,  282,  109,
			   96,  291,   97,  284,  293,  337,  294,  104,  336,  339,
			  344,  351,  149,  350, 2780,  555, 2780, 2780,  130,    0,
			  355,   99,  392,  349,  391,  407,    0,  403,  405,   96,
			  115,  409,  142,  189,  413,  411,  210,  423,  217,  212,
			 2780, 2780,    0,  454,  606,  486,  490,  337,  494,  602,
			  592,  590,  581, 2780,  490, 2780,  572,  503,  513,    0,

			  336,  569,  616,    0, 2780, 2780, 2780,  504, 2780, 2780,
			  507,  514,  528, 2780,    0,  533, 2780, 2780, 2780, 2780,
			 2780, 2780,  249,  524,  469,  573,  519,    0,  338,  493,
			  346,  342,  527,  350,  603,  620,  602,  618,  623,  421,
			  490,  497,  548,  592,  643,  616,  644,    0,  647,  656,
			  638,  612,  664,  651,  660,  661,  665,  664,  684,  672,
			  680,  700,  714,  684,    0,  679,  720,    0,  702,  729,
			  694,  731,  726,  725,  731,  711,  738,  771,  750,  740,
			  750,  769,  774,    0,  777,  779,  815,  811,  811,  795,
			  778,  788,  828,  833,  803,  790,  864,  839,  868,  834,

			  861,  837,  832,  849,  876,  870,  874,  869, 2780,  901,
			  549,    0,  922,  949,  552,  545,  528,  954,  818,  959,
			  963,    0,    0,  560,  623,  624,  963,  814,  970,  984,
			 2780, 2780,  511,  510,  505,  503,  501,  975,  492,  491,
			  451,  393,  389,  385,  339,  334,  330,  326,  324,  245,
			  208,  169,  165,  151,  979,  987,  993, 2780,  996, 1006,
			 1013, 1027,  101, 1032, 1038,  913,  875,  961,  888,  902,
			    0,  909,    0,  934,  955,  995,    0, 1019, 1005, 1026,
			  999, 1033, 1035, 1037, 1033, 1043, 1030, 1044, 1059, 1028,
			 1046, 1067, 1051, 1050, 1073,    0, 1054, 1094, 1081, 1091,

			 1074, 1093, 1079, 1090, 1081, 1106, 1103, 1108, 1093, 1116,
			 1104, 1131, 1130, 1149, 1118, 1119, 1138, 1138, 1155, 1154,
			 1157, 1164, 1158, 1165, 1153, 1161, 1167, 1168,    0, 1170,
			 1165, 1172,    0, 1178, 1179, 1201, 1186, 1191, 1209, 1221,
			 1214, 1217, 1216, 1222, 1224, 1230, 1212, 1248, 1222, 1236,
			 1247, 1238, 1243, 1238, 1240, 1273, 1239, 1255, 1263, 1269,
			 1277, 1262, 1279, 1272, 1281, 1282,    0, 1284, 1286, 1293,
			 1294, 1290, 1291, 1298,    0, 2780, 2780, 2780,  820, 1329,
			 1353, 1338, 2780, 2780, 2780, 2780, 2780, 1357, 2780, 2780,
			 2780, 2780, 2780, 2780, 2780, 2780, 2780, 2780, 2780, 2780,

			 2780, 2780, 2780, 2780, 1360, 1363, 1367, 1370, 1374, 1382,
			 1388, 1391, 1394, 1400, 1414,   95, 1407, 1420, 1369, 1289,
			 1407, 1319, 1408, 1333, 1409, 1366, 1413, 1376, 1387, 1424,
			 1394, 1418, 1421, 1404, 1431, 1432, 1435, 1432, 1448, 1425,
			 1437, 1444, 1461, 1441, 1468, 1472, 1446, 1445, 1475, 1449,
			 1478, 1475, 1479, 1465, 1485, 1492,    0, 1491, 1494, 1495,
			 1497, 1481, 1499, 1483, 1525, 1492, 1522, 1512, 1532, 1506,
			 1521,    0, 1535, 1533, 1537,    0, 1542, 1546, 1545, 1546,
			 1551,    0, 1560, 1552, 1543, 1556, 1561, 1562, 1576, 1553,
			 1578, 1559, 1565, 1579, 1586, 1596, 1577, 1597, 1603, 1585,

			 1612, 1608, 1607, 1596, 1613, 1602, 1615,    0, 1622,    0,
			 1626, 1627, 1649, 1613, 1640, 1624, 1650, 1644, 1646,    0,
			 1653,    0, 1706,  136, 1681, 1686, 1711, 1714, 1717, 1720,
			 1727, 1731, 1734, 1737, 1740, 1745, 1660,    0, 1706,    0,
			 1727, 1726, 1733,    0, 1734,    0, 1737, 1735, 1741, 1734,
			 1748, 1751, 1752, 1741, 1753,    0, 1761, 1745, 1758, 1763,
			 1781, 1766, 1796, 1776, 1788, 1784, 1800, 1792, 1798,    0,
			 1801, 1795, 1806, 1802, 1812, 1818, 1815, 1816, 1817,    0,
			 1818, 1819, 1841, 1827, 1822, 1824, 1825,    0, 1845, 1810,
			 1859, 1838, 1860, 1843, 1863, 1847, 1864, 1865, 1872, 1874,

			 1875, 1878, 1876, 1870, 1886, 1884, 1888, 1870, 1883,    0,
			 1898, 1878, 1924, 1898, 1905,    0, 1919, 1923, 1929, 1930,
			 1927,    0, 1928, 1927, 1333, 2780, 1960, 1951, 1969, 1946,
			 1986, 1993, 1996, 2000, 2003, 2006, 2014, 2017, 1963,    0,
			 2007, 1976, 2005, 1985, 2006, 2011,    0, 2002, 2009, 1999,
			 2022, 2016, 2019,    0, 2021,    0, 2027, 2028, 2026,    0,
			 2065, 2037, 2034, 2035, 2032,    0, 2036, 2037, 2067, 2055,
			 2069, 2059, 2071, 2062, 2083, 2082, 2076,    0, 2077, 2070,
			 2084, 2075, 2086,    0, 2090, 2082, 2091, 2088, 2098,    0,
			 2133, 2104, 2110,    0, 2111,    0, 2121,    0, 2124, 2120,

			 2134, 2131, 2137,    0, 2138, 2129, 2161, 2167, 2174, 2195,
			 2204, 2207, 2210, 2178, 2213, 2218, 2224, 2780, 2227, 2235,
			 2204, 2159, 2185,    0, 2216, 2200, 2214,    0, 2227, 2229,
			 2230, 2231, 2232, 2225, 2233,    0, 2234,    0, 2240, 2241,
			 2241,    0, 2242,    0, 2245, 2238, 2251, 2248, 2263, 2246,
			 2285, 2265, 2286, 2274, 2278,    0, 2291, 2292, 2294, 2293,
			 2292,    0,   84, 2313, 2319, 2322, 2331, 2344, 2352,   76,
			 2355, 2359, 2362, 2299,    0, 2325,    0, 2333,    0, 2334,
			    0, 2348,    0, 2349,    0, 2350, 2342, 2354,    0, 2355,
			 2347, 2358,    0, 2363, 2364, 2362,    0, 2367,    0, 2385,

			   57, 2388, 2391, 2417, 2378,    0, 2379,    0, 2389,    0,
			 2420, 2780, 2479, 2499, 2519, 2539, 2559, 2579, 2449, 2599,
			 2619, 2639, 2659, 2679, 2699, 2441, 2719, 2739, 2759, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  811,    1,  812,  812,  811,  811,  811,  811,  811,
			  811,  811,  813,  814,  811,  815,  816,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   35,   35,   35,   35,
			   35,   35,   35,   35,  811,  811,  811,  811,  811,  817,
			  818,  818,  818,  818,  818,  818,  818,  818,  818,  818,
			  818,  818,  818,  818,  818,  818,  818,  818,  818,  818,
			  811,  811,  819,  811,  811,  819,  811,  820,  821,  811,
			  811,  811,  811,  811,  813,  811,  822,  813,  813,  814,

			  815,  823,  823,  823,  811,  811,  811,  811,  811,  811,
			  824,  811,  811,  811,  825,  811,  811,  811,  811,  811,
			  811,  811,   35,   35,   35,   35,   35,  818,  818,  818,
			  818,  818,   35,  818,   35,   35,   35,   35,   35,  818,
			  818,  818,  818,  818,   35,   35,  818,  818,   35,   35,
			   35,  818,  818,  818,   35,   35,   35,  818,  818,  818,
			   35,   35,   35,   35,  818,  818,  818,  818,   35,   35,
			  818,  818,   35,  818,   35,  818,   35,   35,   35,   35,
			  818,  818,  818,  818,   35,  818,   35,  818,   35,   35,
			  818,  818,   35,   35,  818,  818,   35,   35,  818,  818,

			   35,   35,  818,  818,   35,  818,   35,  818,  811,  811,
			  817,  819,  811,  811,  826,  827,  811,  819,  820,  821,
			  811,  819,  819,  822,  815,  815,  822,  822,  813,  813,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  825,  811,  811,   35,  818,   35,   35,  818,
			  818,   35,  818,   35,  818,   35,  818,   35,  818,   35,
			  818,   35,  818,   35,  818,   35,  818,   35,   35,  818,
			  818,   35,  818,   35,   35,  818,  818,   35,   35,  818,

			  818,   35,  818,   35,  818,   35,  818,   35,  818,   35,
			   35,   35,   35,   35,  818,  818,  818,  818,  818,   35,
			  818,   35,   35,  818,  818,   35,  818,   35,  818,   35,
			  818,   35,  818,   35,  818,   35,  818,   35,   35,   35,
			   35,   35,   35,  818,  818,  818,  818,  818,  818,   35,
			   35,  818,  818,   35,  818,   35,  818,   35,  818,   35,
			   35,   35,  818,  818,  818,   35,  818,   35,  818,   35,
			  818,   35,  818,   35,  818,  811,  811,  811,  822,  822,
			  822,  822,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,

			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  825,  811,  811,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,   35,
			  818,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,   35,  818,  818,   35,  818,
			   35,  818,   35,  818,   35,   35,  818,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,   35,  818,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,   35,  818,  818,   35,  818,

			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,  822,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  824,  811,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,

			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,  822,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  828,   35,  818,
			   35,  818,   35,  818,   35,   35,  818,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,

			   35,  818,   35,  818,   35,  818,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811,  811,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,   35,  818,   35,  818,   35,  818,   35,  818,
			   35,  818,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,   35,  818,   35,  818,   35,  818,   35,
			  818,   35,  818,   35,  818,   35,  818,   35,  818,   35,
			  818,   35,  818,   35,  818,   35,  818,   35,  818,  811,

			  811,  811,  811,  811,   35,  818,   35,  818,   35,  818,
			  811,    0,  811,  811,  811,  811,  811,  811,  811,  811,
			  811,  811,  811,  811,  811,  811,  811,  811,  811, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    5,    6,    7,    8,    9,   10,    8,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   22,   22,   22,   22,   22,   22,   22,   23,   24,
			   25,   26,   27,   28,    8,   29,   30,   31,   32,   33,
			   34,   35,   36,   37,   38,   39,   40,   41,   42,   43,
			   44,   45,   46,   47,   48,   49,   50,   51,   52,   53,
			   54,   55,   56,   57,   58,   59,   60,   61,   62,   63,

			   64,   65,   66,   67,   68,   69,   70,   71,   72,   73,
			   74,   75,   76,   77,   78,   79,   80,   81,   82,   83,
			   84,   85,   86,   87,    8,   88,    1,    1,    1,    1,
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
			   10,   11,   12,    1,    1,    1,    1,    1,    1,   10,
			   10,   10,   10,   10,   10,   13,   13,   13,   13,   13,
			   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
			   13,   13,   14,   15,   16,    1,    1,    1,    1,   17,
			    1,   10,   10,   10,   10,   10,   10,   13,   13,   13,
			   13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
			   13,   13,   13,   13,   18,   19,   20,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    2,    3,    4,    6,    9,   11,
			   14,   17,   20,   23,   26,   29,   32,   34,   37,   40,
			   43,   46,   49,   52,   55,   58,   62,   66,   70,   73,
			   76,   79,   82,   85,   87,   91,   95,   99,  103,  107,
			  111,  115,  119,  123,  127,  131,  135,  139,  143,  147,
			  151,  155,  159,  163,  167,  170,  172,  175,  178,  181,
			  183,  186,  189,  192,  195,  198,  201,  204,  207,  210,
			  213,  216,  219,  222,  225,  228,  231,  234,  237,  240,
			  243,  246,  249,  251,  253,  255,  258,  260,  262,  264,
			  265,  266,  267,  268,  269,  270,  271,  272,  275,  278,

			  279,  280,  281,  282,  283,  284,  285,  286,  288,  289,
			  290,  290,  292,  294,  295,  295,  296,  297,  298,  299,
			  300,  301,  302,  304,  306,  308,  310,  313,  314,  315,
			  316,  317,  319,  321,  322,  324,  326,  328,  330,  332,
			  333,  334,  335,  336,  337,  339,  342,  343,  345,  347,
			  349,  351,  352,  353,  354,  356,  358,  360,  361,  362,
			  363,  366,  368,  370,  373,  375,  376,  377,  379,  381,
			  383,  384,  385,  387,  388,  390,  391,  393,  395,  397,
			  400,  401,  402,  403,  405,  407,  408,  410,  411,  413,
			  415,  416,  417,  419,  421,  422,  423,  425,  427,  428,

			  429,  431,  433,  434,  435,  437,  438,  440,  441,  442,
			  443,  443,  444,  445,  445,  445,  445,  446,  448,  449,
			  450,  451,  453,  455,  455,  457,  459,  459,  459,  461,
			  463,  464,  466,  467,  468,  469,  470,  471,  472,  473,
			  474,  475,  476,  477,  478,  479,  480,  481,  482,  483,
			  484,  485,  486,  487,  488,  490,  490,  490,  491,  493,
			  494,  496,  498,  499,  501,  502,  504,  505,  507,  510,
			  511,  513,  516,  518,  520,  521,  524,  526,  528,  529,
			  531,  532,  534,  535,  537,  538,  540,  541,  543,  545,
			  546,  547,  549,  550,  553,  555,  557,  558,  560,  562,

			  563,  564,  566,  567,  569,  570,  572,  573,  575,  576,
			  578,  580,  582,  584,  586,  587,  588,  589,  590,  591,
			  593,  594,  596,  598,  599,  600,  602,  603,  606,  608,
			  610,  611,  614,  616,  618,  619,  621,  622,  624,  626,
			  628,  630,  632,  634,  635,  636,  637,  638,  639,  640,
			  642,  644,  645,  646,  648,  649,  651,  652,  654,  655,
			  657,  659,  661,  662,  663,  664,  667,  669,  671,  672,
			  674,  675,  677,  678,  681,  683,  684,  685,  686,  687,
			  688,  688,  689,  690,  691,  692,  693,  694,  695,  696,
			  697,  698,  699,  700,  701,  702,  703,  704,  705,  706,

			  707,  708,  709,  710,  711,  713,  713,  715,  715,  717,
			  717,  717,  717,  719,  721,  723,  723,  725,  727,  729,
			  730,  732,  733,  735,  736,  738,  739,  741,  742,  744,
			  746,  747,  748,  750,  751,  753,  754,  756,  757,  759,
			  760,  763,  765,  767,  768,  770,  772,  773,  774,  776,
			  777,  779,  780,  782,  783,  786,  788,  790,  791,  793,
			  794,  796,  797,  799,  800,  802,  803,  805,  806,  808,
			  809,  812,  814,  816,  817,  820,  822,  824,  825,  827,
			  828,  831,  833,  835,  837,  838,  839,  841,  842,  844,
			  845,  847,  848,  850,  851,  853,  855,  856,  857,  859,

			  860,  862,  863,  865,  866,  868,  869,  872,  874,  877,
			  879,  881,  882,  884,  885,  887,  888,  890,  891,  894,
			  896,  899,  901,  901,  902,  903,  905,  905,  905,  907,
			  907,  911,  911,  913,  913,  913,  915,  918,  920,  923,
			  925,  927,  928,  931,  933,  936,  938,  940,  941,  943,
			  944,  946,  947,  949,  950,  953,  955,  957,  958,  960,
			  961,  963,  964,  966,  967,  969,  970,  972,  973,  976,
			  978,  980,  981,  983,  984,  986,  987,  989,  990,  993,
			  995,  997,  998, 1000, 1001, 1003, 1004, 1007, 1009, 1011,
			 1012, 1014, 1015, 1017, 1018, 1020, 1021, 1023, 1024, 1026,

			 1027, 1029, 1030, 1032, 1033, 1035, 1036, 1038, 1039, 1042,
			 1044, 1046, 1047, 1049, 1050, 1053, 1055, 1057, 1058, 1060,
			 1061, 1064, 1066, 1068, 1069, 1069, 1070, 1070, 1072, 1072,
			 1073, 1074, 1078, 1078, 1078, 1080, 1080, 1081, 1081, 1084,
			 1086, 1088, 1089, 1091, 1092, 1095, 1097, 1099, 1100, 1102,
			 1103, 1105, 1106, 1109, 1111, 1114, 1116, 1118, 1119, 1122,
			 1124, 1126, 1127, 1129, 1130, 1133, 1135, 1137, 1138, 1140,
			 1141, 1143, 1144, 1146, 1147, 1149, 1150, 1153, 1155, 1157,
			 1158, 1160, 1161, 1164, 1166, 1168, 1169, 1171, 1172, 1175,
			 1177, 1179, 1180, 1183, 1185, 1188, 1190, 1193, 1195, 1197,

			 1198, 1200, 1201, 1204, 1206, 1208, 1209, 1209, 1210, 1210,
			 1210, 1210, 1214, 1214, 1215, 1216, 1216, 1216, 1217, 1218,
			 1219, 1221, 1222, 1225, 1227, 1229, 1230, 1233, 1235, 1237,
			 1238, 1240, 1241, 1243, 1244, 1247, 1249, 1252, 1254, 1256,
			 1257, 1260, 1262, 1265, 1267, 1269, 1270, 1272, 1273, 1275,
			 1276, 1278, 1279, 1281, 1282, 1285, 1287, 1289, 1290, 1292,
			 1293, 1296, 1298, 1299, 1299, 1300, 1300, 1302, 1302, 1302,
			 1303, 1304, 1304, 1305, 1308, 1310, 1313, 1315, 1318, 1320,
			 1323, 1325, 1328, 1330, 1333, 1335, 1337, 1338, 1341, 1343,
			 1345, 1346, 1349, 1351, 1353, 1354, 1357, 1359, 1362, 1364,

			 1365, 1367, 1367, 1369, 1370, 1373, 1375, 1378, 1380, 1383,
			 1385, 1387, 1387, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  141,  141,  157,  155,  156,    3,  155,  156,    4,
			  156,    1,  155,  156,    2,  155,  156,   10,  155,  156,
			  143,  155,  156,  107,  155,  156,   17,  155,  156,  143,
			  155,  156,  155,  156,   11,  155,  156,   12,  155,  156,
			   31,  155,  156,   30,  155,  156,    8,  155,  156,   29,
			  155,  156,    6,  155,  156,   32,  155,  156,  145,  147,
			  155,  156,  145,  147,  155,  156,  145,  147,  155,  156,
			    9,  155,  156,    7,  155,  156,   36,  155,  156,   34,
			  155,  156,   35,  155,  156,  155,  156,  105,  106,  155,
			  156,  105,  106,  155,  156,  105,  106,  155,  156,  105,

			  106,  155,  156,  105,  106,  155,  156,  105,  106,  155,
			  156,  105,  106,  155,  156,  105,  106,  155,  156,  105,
			  106,  155,  156,  105,  106,  155,  156,  105,  106,  155,
			  156,  105,  106,  155,  156,  105,  106,  155,  156,  105,
			  106,  155,  156,  105,  106,  155,  156,  105,  106,  155,
			  156,  105,  106,  155,  156,  105,  106,  155,  156,  105,
			  106,  155,  156,  105,  106,  155,  156,   15,  155,  156,
			  155,  156,   16,  155,  156,   33,  155,  156,  147,  155,
			  156,  155,  156,  106,  155,  156,  106,  155,  156,  106,
			  155,  156,  106,  155,  156,  106,  155,  156,  106,  155,

			  156,  106,  155,  156,  106,  155,  156,  106,  155,  156,
			  106,  155,  156,  106,  155,  156,  106,  155,  156,  106,
			  155,  156,  106,  155,  156,  106,  155,  156,  106,  155,
			  156,  106,  155,  156,  106,  155,  156,  106,  155,  156,
			  106,  155,  156,   13,  155,  156,   14,  155,  156,  141,
			  156,  139,  156,  140,  156,  135,  141,  156,  138,  156,
			  141,  156,  141,  156,    3,    4,    1,    2,   37,  143,
			  142,  142, -133,  143, -289, -134,  143, -290,  107,  143,
			  131,  131,  131,    5,   23,   24,  150,  153,   18,   20,
			  145,  147,  145,  147,  144,  147,   28,   25,   22,   21,

			   26,   27,  105,  106,  105,  106,  105,  106,  105,  106,
			   42,  105,  106,  106,  106,  106,  106,   42,  106,  105,
			  106,  106,  105,  106,  105,  106,  105,  106,  105,  106,
			  105,  106,  106,  106,  106,  106,  106,  105,  106,   54,
			  105,  106,  106,   54,  106,  105,  106,  105,  106,  105,
			  106,  106,  106,  106,  105,  106,  105,  106,  105,  106,
			  106,  106,  106,   66,  105,  106,  105,  106,  105,  106,
			   73,  105,  106,   66,  106,  106,  106,   73,  106,  105,
			  106,  105,  106,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  105,  106,  105,  106,   82,  105,  106,

			  106,  106,  106,   82,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  105,  106,  106,  106,  105,  106,  105,
			  106,  106,  106,  105,  106,  105,  106,  106,  106,  105,
			  106,  105,  106,  106,  106,  105,  106,  106,  105,  106,
			  106,   19,  147,  141,  139,  140,  135,  141,  141,  141,
			  138,  136,  141,  137,  141,  142,  143,  142,  143, -133,
			  143, -134,  143,  131,  108,  131,  131,  131,  131,  131,
			  131,  131,  131,  131,  131,  131,  131,  131,  131,  131,
			  131,  131,  131,  131,  131,  131,  131,  131,  150,  153,
			  148,  150,  153,  148,  145,  147,  145,  147,  146,  145,

			  147,  147,  105,  106,  106,  105,  106,   40,  105,  106,
			  106,   40,  106,   41,  105,  106,   41,  106,  105,  106,
			  106,   44,  105,  106,   44,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  105,  106,  106,  106,  105,  106,  106,
			   57,  105,  106,  105,  106,   57,  106,  106,  105,  106,
			  105,  106,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  105,  106,
			  105,  106,  105,  106,  105,  106,  106,  106,  106,  106,
			  106,  105,  106,  106,  105,  106,  105,  106,  106,  106,

			  105,  106,  106,   78,  105,  106,   78,  106,  105,  106,
			  106,   80,  105,  106,   80,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  105,  106,  105,  106,  105,  106,
			  105,  106,  105,  106,  106,  106,  106,  106,  106,  106,
			  105,  106,  105,  106,  106,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  105,  106,  105,
			  106,  106,  106,  106,   97,  105,  106,   97,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  104,  105,
			  106,  104,  106,  154,  136,  137,  142,  142,  142,  125,
			  123,  124,  126,  127,  132,  128,  129,  109,  110,  111,

			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  150,  153,  150,  153,  150,  153,  149,  152,  145,
			  147,  145,  147,  145,  147,  145,  147,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,  105,  106,  105,  106,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			   55,  105,  106,   55,  106,  105,  106,  106,  105,  106,
			  105,  106,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,   64,  105,  106,  105,  106,   64,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,

			  105,  106,  106,  105,  106,  106,  105,  106,  106,   74,
			  105,  106,   74,  106,  105,  106,  106,   76,  105,  106,
			   76,  106,  105,  106,  106,  105,  106,  106,   81,  105,
			  106,   81,  106,  105,  106,  105,  106,  106,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  105,  106,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,   95,
			  105,  106,   95,  106,   96,  105,  106,   96,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  102,  105,  106,  102,  106,  103,  105,  106,  103,

			  106,  132,  150,  150,  153,  150,  153,  149,  150,  152,
			  153,  149,  152,  145,  147,   38,  105,  106,   38,  106,
			   39,  105,  106,   39,  106,  105,  106,  106,   45,  105,
			  106,   45,  106,   46,  105,  106,   46,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			   52,  105,  106,   52,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,   62,  105,  106,   62,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			   69,  105,  106,   69,  106,  105,  106,  106,  105,  106,

			  106,  105,  106,  106,   75,  105,  106,   75,  106,  105,
			  106,  106,  105,  106,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,   91,
			  105,  106,   91,  106,  105,  106,  106,  105,  106,  106,
			   94,  105,  106,   94,  106,  105,  106,  106,  105,  106,
			  106,  100,  105,  106,  100,  106,  105,  106,  106,  130,
			  150,  153,  153,  150,  149,  150,  152,  153,  149,  152,
			  148,   43,  105,  106,   43,  106,  105,  106,  106,  105,
			  106,  106,   49,  105,  106,  105,  106,   49,  106,  106,

			  105,  106,  106,  105,  106,  106,   56,  105,  106,   56,
			  106,   58,  105,  106,   58,  106,  105,  106,  106,   60,
			  105,  106,   60,  106,  105,  106,  106,  105,  106,  106,
			   65,  105,  106,   65,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,  105,  106,  106,  105,  106,  106,
			   77,  105,  106,   77,  106,  105,  106,  106,  105,  106,
			  106,   84,  105,  106,   84,  106,  105,  106,  106,  105,
			  106,  106,   87,  105,  106,   87,  106,  105,  106,  106,
			   89,  105,  106,   89,  106,   90,  105,  106,   90,  106,
			   92,  105,  106,   92,  106,  105,  106,  106,  105,  106,

			  106,   99,  105,  106,   99,  106,  105,  106,  106,  150,
			  149,  150,  152,  153,  153,  149,  151,  153,  151,  105,
			  106,  106,   47,  105,  106,   47,  106,  105,  106,  106,
			   51,  105,  106,   51,  106,  105,  106,  106,  105,  106,
			  106,  105,  106,  106,   63,  105,  106,   63,  106,   67,
			  105,  106,   67,  106,  105,  106,  106,   70,  105,  106,
			   70,  106,   71,  105,  106,   71,  106,  105,  106,  106,
			  105,  106,  106,  105,  106,  106,  105,  106,  106,  105,
			  106,  106,   88,  105,  106,   88,  106,  105,  106,  106,
			  105,  106,  106,  101,  105,  106,  101,  106,  153,  153,

			  149,  150,  152,  153,  152,   48,  105,  106,   48,  106,
			   50,  105,  106,   50,  106,   53,  105,  106,   53,  106,
			   59,  105,  106,   59,  106,   61,  105,  106,   61,  106,
			   68,  105,  106,   68,  106,  105,  106,  106,   79,  105,
			  106,   79,  106,  105,  106,  106,   86,  105,  106,   86,
			  106,  105,  106,  106,   93,  105,  106,   93,  106,   98,
			  105,  106,   98,  106,  153,  152,  153,  152,  153,  152,
			   72,  105,  106,   72,  106,   83,  105,  106,   83,  106,
			   85,  105,  106,   85,  106,  152,  153, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 2780
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 811
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 812
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

	yyNb_rules: INTEGER is 156
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 157
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
