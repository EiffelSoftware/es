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
--|#line 45 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 45")
end
-- Ignore carriage return
when 2 then
--|#line 46 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 46")
end

					curr_token := new_space (text_count)
					update_token_list
					
when 3 then
--|#line 50 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 50")
end

					if not in_comments then
						curr_token := new_tabulation (text_count)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 4 then
--|#line 58 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 58")
end

					from i_ := 1 until i_ > text_count loop
						curr_token := new_eol
						update_token_list
						i_ := i_ + 1
					end
					in_comments := False
					
when 5 then
--|#line 70 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 70")
end
 
						-- comments
					curr_token := new_comment (text)
					in_comments := True	
					update_token_list					
				
when 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 then
--|#line 79 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 79")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 then
--|#line 100 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 100")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105 then
--|#line 130 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 130")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
when 106 then
--|#line 211 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 211")
end

										if not in_comments then
											if is_current_group_valid then
												tmp_classes := current_group.class_by_name (text, True)
												if not tmp_classes.is_empty then
													curr_token := new_class (text)
													curr_token.set_pebble (stone_of_class (tmp_classes.first))
												else
													curr_token := new_text (text)
												end
											else
												curr_token := new_text (text)
											end							
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
when 107 then
--|#line 231 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 231")
end

										if not in_comments then
											curr_token := new_text (text)											
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
when 108 then
--|#line 243 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 243")
end

										if not in_comments then
											curr_token := new_text (text)										
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
when 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130 then
--|#line 257 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 257")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 131 then
--|#line 287 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 287")
end

					if not in_comments then
						code_ := text_substring (4, text_count - 2).to_integer
						if code_ > {CHARACTER}.Max_value then
							-- Character error. Consedered as text.
							curr_token := new_text (text)
						else
							curr_token := new_character (text)
						end						
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 132 then
--|#line 302 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 302")
end

					-- Character error. Catch-all rules (no backing up)
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 133 then
--|#line 324 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 324")
end

 				if not in_comments then
						-- Verbatim string opener.
					curr_token := new_string (text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					curr_token := new_comment (text)
					update_token_list
				end
			
when 134 then
--|#line 338 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 338")
end

				if not in_comments then
						-- Verbatim string opener.
					curr_token := new_string (text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					curr_token := new_comment (text)
					update_token_list
				end				
			
when 135 then
--|#line 353 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 353")
end
-- Ignore carriage return
when 136 then
--|#line 354 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 354")
end

							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 137 then
--|#line 363 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 363")
end

							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
when 138 then
--|#line 372 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 372")
end

						curr_token := new_space (text_count)
						update_token_list						
					
when 139 then
--|#line 377 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 377")
end
						
						curr_token := new_tabulation (text_count)
						update_token_list						
					
when 140 then
--|#line 382 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 382")
end

						from i_ := 1 until i_ > text_count loop
							curr_token := new_eol
							update_token_list
							i_ := i_ + 1
						end						
					
when 141 then
--|#line 390 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 390")
end

						curr_token := new_string (text)
						update_token_list
					
when 142, 143 then
--|#line 396 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 396")
end

					-- Eiffel String
					if not in_comments then						
						curr_token := new_string (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 144 then
--|#line 409 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 409")
end

					-- Eiffel Bit
					if not in_comments then
						curr_token := new_number (text)						
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
when 145, 146, 147, 148 then
--|#line 421 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 421")
end

						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 149, 150, 151, 152 then
--|#line 435 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 435")
end

						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 153 then
	yy_end := yy_end - 1
--|#line 450 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 450")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 154, 155 then
--|#line 451 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 451")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 156 then
	yy_end := yy_end - 1
--|#line 453 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 453")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 157, 158 then
--|#line 454 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 454")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
when 159 then
--|#line 471 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 471")
end

					curr_token := new_text (text)
					update_token_list
					
when 160 then
--|#line 479 "editor_eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_eiffel_scanner.l' at line 479")
end

					-- Error (considered as text)
				if not in_comments then
					curr_token := new_text (text)
				else
					curr_token := new_comment (text)
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
			create an_array.make (0, 9917)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			yy_nxt_template_3 (an_array)
			yy_nxt_template_4 (an_array)
			yy_nxt_template_5 (an_array)
			yy_nxt_template_6 (an_array)
			yy_nxt_template_7 (an_array)
			yy_nxt_template_8 (an_array)
			yy_nxt_template_9 (an_array)
			yy_nxt_template_10 (an_array)
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
			    6,    6,    6,   81,   82,   83,   84,   85,   86,   87,

			   89,   90,   91,   92,  138,  140,  867,  141,  141,  141,
			  141,   89,   90,   91,   92,  139,  142,  144, 1048,  145,
			  145,  146,  146,  764,  143,  154,  155, 1048,  108,  944,
			  152,  109,  156,  157,  757,  108, 1048,  129,  109,  129,
			  129,  159,  159,  159,  144,  130,  145,  145,  146,  146,
			  271,  271,  271,  272,  272,  380,   93,  148,  149,  151,
			  386,  944,  152,  273,  273,  273,  618,   93,  144,  386,
			  146,  146,  146,  146,  274,  274,  274,  110,  386,  150,
			  159,  159,  159,  408,  408,  408,  151,   94,  616,  148,
			  149,   95,   96,   97,   98,   99,  100,  101,   94,  387,

			  387,  614,   95,   96,   97,   98,   99,  100,  101,  111,
			  151,  150,  409,  409,  112,  113,  114,  115,  116,  117,
			  118,  121,  122,  123,  124,  125,  126,  127,  131,  132,
			  133,  134,  135,  136,  137,  159,  159,  159,  159,  386,
			  410,  410,  410,  522,  522,  159,  159,  159,  159,  159,
			  159,  160,  159,  159,  159,  159,  161,  159,  162,  159,
			  159,  159,  159,  163,  164,  159,  159,  159,  159,  159,
			  159,  411,  411,  411,  618,  159,  616,  165,  165,  165,
			  165,  165,  165,  166,  165,  165,  165,  165,  167,  165,
			  168,  165,  165,  165,  165,  169,  170,  165,  165,  165,

			  165,  165,  165,  614,  378,  378,  378,  378,  171,  172,
			  173,  174,  175,  176,  177,  159,  580,  178,  379,  288,
			  159,  159,  159,  525,  520,  159,  412,  159,  159,  407,
			  342,  159,  165,  165,  165,  159,  105,  104,  159,  214,
			  103,  389,  389,  389,  380,  215,  102,  165,  159,  179,
			  379,  288,  165,  165,  165,  387,  387,  165, 1003,  165,
			  165,  159,  180,  165,  275,  270,  181,  165,  159,  182,
			  165,  216,  183,  159,  159,  184,  190,  217,  254,  159,
			  165,  386,  158,  159,  608,  165,  191,  165,  153,  159,
			 1003,  106,  159,  165,  185,  613,  105,  165,  186,  104,

			  165,  187,  103,  102,  188,  165,  165,  189,  192,  387,
			  387,  165,  521,  521,  521,  165, 1048,  165,  193,  165,
			  159,  165,  159, 1048,  165,  194,  159,  195, 1048,  165,
			  159,  200,  159,  159,  159,  201,  218,  196,  159,  159,
			 1048, 1048,  159, 1048,  220,  159, 1048,  159,  202,  613,
			 1048,  159,  165, 1048,  165, 1048, 1048,  197,  165,  198,
			 1048, 1048,  165,  203,  165,  165,  165,  204,  219,  199,
			  165,  165, 1048, 1048,  165, 1048,  221,  165, 1048,  165,
			  205,  159, 1048,  165,  159,  159,  206, 1048,  159, 1048,
			 1048,  159,  222,  207,  208,  159, 1048, 1048,  159,  209,

			 1048,  230,  223, 1048,  224,  159, 1048, 1048,  225,  232,
			 1048, 1048,  284,  165,  285,  285,  165,  165,  210, 1048,
			  165, 1048,  159,  165,  226,  211,  212,  165,  159, 1048,
			  165,  213,  234,  231,  227,  159,  228,  165, 1048,  159,
			  229,  233,  238,  159,  246,  159, 1048,  235,  159,  159,
			  159,  242,  239,  159,  165,  159,  243, 1048,  247,  159,
			  165,  159,  250,  252,  236, 1048,  159,  165,  286, 1048,
			 1048,  165,  159, 1048,  240,  165,  248,  165, 1048,  237,
			  165,  165,  165,  244,  241,  165, 1048,  165,  245, 1048,
			  249,  165, 1048,  165,  251,  253, 1048, 1048,  165,  287,

			  523,  523,  523,  179,  165,  256,  257,  258,  259,  260,
			  261,  262,  166,  524,  524,  524, 1048,  167, 1048,  168,
			  382,  382,  382,  382,  169,  170,  277,  278,  279,  280,
			  281,  282,  283, 1048,  383,  179,  192,  285, 1048,  285,
			  292,  159,  159,  159,  166, 1048,  193, 1048, 1048,  167,
			  144,  168,  385,  385,  385,  385,  169,  170,  263,  264,
			  265,  266,  267,  268,  269, 1048,  383, 1048,  192,  263,
			  264,  265,  266,  267,  268,  269,  185, 1048,  193,  216,
			  186, 1048,  165,  187,  165,  217,  188, 1048, 1048,  189,
			 1048, 1048,  151,  286,  165,  263,  264,  265,  266,  267,

			  268,  269,  159,  159,  159, 1048, 1048,  197,  185,  198,
			 1048,  216,  186, 1048,  165,  187,  165,  217,  188,  199,
			 1048,  189, 1048, 1048,  287, 1048,  165,  159,  159,  159,
			 1048, 1048,  263,  264,  265,  266,  267,  268,  269,  197,
			 1048,  198,  277,  278,  279,  280,  281,  282,  283,  311,
			  311,  199,  277,  278,  279,  280,  281,  282,  283,  263,
			  264,  265,  266,  267,  268,  269,  203,  210, 1048,  165,
			  204,  165,  219,  165,  211,  212, 1048,  165,  226,  165,
			  213,  165, 1048,  205,  165,  165,  165,  221,  227,  165,
			  228,  159,  159,  159,  229, 1048,  165, 1048,  203,  210,

			  165,  165,  204,  165,  219,  165,  211,  212, 1048,  165,
			  226,  165,  213,  165, 1048,  205,  165,  165,  165,  221,
			  227,  165,  228,  165,  233,  165,  229,  236,  165,  231,
			 1048,  165,  165,  165,  165,  165,  165,  526,  526,  526,
			 1048, 1048,  237,  165,  240, 1048,  165, 1048,  165, 1048,
			  165,  527,  527,  527,  241,  165,  233,  165,  248,  236,
			  165,  231, 1048,  165, 1048,  165,  165,  165,  165,  165,
			 1048,  165,  249, 1048,  237,  165,  240,  165,  165,  244,
			  165,  165,  165, 1048,  245,  285,  241,  289,  285,  165,
			  248,  251,  165, 1048, 1048,  165,  165,  165,  165,  253,

			 1048,  165, 1048,  165,  249, 1048, 1048,  165,  165,  165,
			 1048,  244,  286,  165, 1048,  286,  245,  293, 1048, 1048,
			  276,  165, 1048,  251,  159,  159,  159,  165,  165,  165,
			  165,  253, 1048, 1048, 1048,  393,  393,  393,  393,  165,
			  165,  290,  287, 1048, 1048,  287, 1048,  301, 1048, 1048,
			  276,  309,  277,  278,  279,  280,  281,  282,  283,  310,
			  310,  310,  277,  278,  279,  280,  281,  282,  283, 1048,
			 1048,  108,  291, 1048,  109,  394,  277,  278,  279,  280,
			  281,  282,  283,  312,  312,  312,  277,  278,  279,  280,
			  281,  282,  283,  313,  313,  313,  277,  278,  279,  280, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  281,  282,  283,  294,  295,  296,  297,  298,  299,  300,
			  314, 1048, 1048,  277,  278,  279,  280,  281,  282,  283,
			  110, 1048, 1048,  327, 1048,  327,  327, 1048,  108, 1048,
			 1048,  109, 1048,  302,  303,  304,  305,  306,  307,  308,
			 1048,  328, 1048,  328,  328, 1048,  108, 1048,  603,  109,
			  603, 1048,  111,  604,  604,  604,  604,  112,  113,  114,
			  115,  116,  117,  118,  316, 1048, 1048,  317,  120,  120,
			  120,  605,  605,  605,  605, 1048,  318,  110, 1048,  108,
			 1048, 1048,  109,  120, 1048,  120, 1048,  120,  120,  319,
			 1048, 1048,  120,  108,  120,  110,  109, 1048,  120, 1048,

			  120, 1048, 1048,  120,  120,  120,  120,  120,  120,  111,
			  108, 1048, 1048,  109,  112,  113,  114,  115,  116,  117,
			  118, 1048, 1048,  108, 1048, 1048,  109,  111,  110,  159,
			  159,  159,  112,  113,  114,  115,  116,  117,  118,  609,
			  108,  609,  110,  109,  610,  610,  610,  610, 1048, 1048,
			  320,  321,  322,  323,  324,  325,  326, 1048,  108,  110,
			  111,  109,  159,  159,  159,  112,  113,  114,  115,  116,
			  117,  118,  110,  108,  111, 1048,  109, 1048,  329,  112,
			  113,  114,  115,  116,  117,  118, 1048,  108, 1048,  110,
			  109,  111, 1048,  330,  330,  330,  112,  113,  114,  115,

			  116,  117,  118, 1048,  111,  108,  331,  331,  109,  112,
			  113,  114,  115,  116,  117,  118,  108, 1048, 1048,  109,
			 1048,  111,  110,  332,  332,  332,  112,  113,  114,  115,
			  116,  117,  118, 1048,  108, 1048,  110,  109,  159,  159,
			  159,  389,  389,  389,  121,  122,  123,  124,  125,  126,
			  127, 1048,  108, 1048,  111,  109,  333,  333,  333,  112,
			  113,  114,  115,  116,  117,  118,  108, 1048,  111,  109,
			  334, 1048, 1048,  112,  113,  114,  115,  116,  117,  118,
			  108,  615, 1048,  109,  277,  278,  279,  280,  281,  282,
			  283,  121,  122,  123,  124,  125,  126,  127,  342, 1048,

			 1048,  335,  121,  122,  123,  124,  125,  126,  127,  108,
			 1048, 1048,  109,  629,  629,  629, 1048,  336,  336,  336,
			  121,  122,  123,  124,  125,  126,  127,  277,  278,  279,
			  280,  281,  282,  283, 1048,  337,  337, 1048,  121,  122,
			  123,  124,  125,  126,  127,  630,  630,  630, 1048,  338,
			  338,  338,  121,  122,  123,  124,  125,  126,  127,  165,
			  165,  165, 1048,  339,  339,  339,  121,  122,  123,  124,
			  125,  126,  127,  342,  165,  165,  165,  165,  165,  165,
			  343,  344,  345,  346,  347,  348,  349,  342,  165,  165,
			  165, 1048,  340, 1048, 1048,  121,  122,  123,  124,  125,

			  126,  127,  350, 1048, 1048,  351,  352,  353,  354,  731,
			  731,  731, 1048, 1048,  355, 1048,  342,  732,  732,  732,
			 1048,  356, 1048,  357, 1048,  358,  359,  360,  361,  342,
			  362,  159,  363, 1048, 1048,  159,  364, 1048,  365,  342,
			 1048,  366,  367,  368,  369,  370,  371, 1048,  159,  342,
			 1048, 1048,  128,  128,  128,  343,  344,  345,  346,  347,
			  348,  349,  342,  165,  159,  159,  159,  165,  372,  343,
			  344,  345,  346,  347,  348,  349, 1048, 1048,  311,  311,
			  165,  277,  278,  279,  280,  281,  282,  283,  343,  344,
			  345,  346,  347,  348,  349,  373,  373,  373,  343,  344,

			  345,  346,  347,  348,  349,  159,  159,  159,  374,  374,
			 1048,  343,  344,  345,  346,  347,  348,  349,  375,  375,
			  375,  343,  344,  345,  346,  347,  348,  349,  376,  376,
			  376,  343,  344,  345,  346,  347,  348,  349, 1048, 1048,
			  165,  377,  165, 1048,  343,  344,  345,  346,  347,  348,
			  349,  144,  165,  384,  384,  385,  385, 1048, 1048,  284,
			 1048,  285,  285, 1048,  152,  604,  604,  604,  604,  159,
			 1048, 1048,  165,  395,  165,  309,  277,  278,  279,  280,
			  281,  282,  283, 1048,  165, 1048,  159,  159, 1048, 1048,
			  401,  159, 1048,  151, 1048, 1048,  152,  391,  391,  391,

			  391,  165, 1048, 1048,  159,  396, 1048,  391,  391,  391,
			  391,  391,  391,  159, 1048,  286,  159,  159,  165,  165,
			  159,  397,  402,  165,  398,  285, 1048,  285,  285, 1048,
			  159, 1048, 1048,  159,  403, 1048,  165,  386, 1048,  391,
			  391,  391,  391,  391,  391,  165,  287, 1048,  165,  165,
			  159,  396,  165,  399,  159, 1048,  400, 1048,  165, 1048,
			  165, 1048,  165, 1048, 1048,  165,  404,  159,  402,  405,
			  165, 1048,  399, 1048, 1048,  400,  165,  165,  165, 1048,
			 1048,  286,  165,  396, 1048, 1048,  165,  165,  165, 1048,
			  165,  165,  165,  165,  758,  758,  758,  758,  404,  165,

			  402,  406,  165,  165,  399, 1048, 1048,  400,  165,  165,
			  165,  159,  287, 1048,  165,  415,  165,  159, 1048,  165,
			  165,  159,  406,  165, 1048,  165,  165, 1048,  159,  165,
			  404,  165, 1048, 1048,  159,  165,  413,  414,  417, 1048,
			  159,  165,  159,  165,  421, 1048,  165,  416,  165,  165,
			  159,  159,  159,  165,  406,  159, 1048,  159,  165, 1048,
			  165,  165, 1048,  165, 1048, 1048,  165,  159,  414,  414,
			  418,  159,  165,  165,  165,  159,  422, 1048, 1048,  159,
			  419,  416,  418, 1048,  159, 1048, 1048,  165,  165,  165,
			  165, 1048,  423,  165,  165,  165,  420, 1048, 1048,  165,

			  165, 1048, 1048,  165,  159,  165,  165,  165,  159, 1048,
			  422,  165,  420,  416,  418, 1048,  165,  165, 1048,  165,
			  165,  159,  165, 1048,  424,  165,  165,  165,  420,  165,
			 1048, 1048,  165,  165, 1048,  165,  165,  165,  165,  424,
			  165, 1048,  422,  159,  425,  165,  427,  159,  426,  165,
			  428,  165,  165,  165,  165,  159,  165, 1048,  165,  159,
			  159,  165, 1048, 1048,  165,  165, 1048,  165,  165, 1048,
			 1048,  424,  159,  429, 1048,  165,  427,  165,  427,  165,
			  428, 1048,  428, 1048,  165, 1048,  165,  165,  165, 1048,
			  165,  165,  165, 1048,  159, 1048,  165,  431,  159,  159,

			  165, 1048,  441,  159,  165,  430,  159, 1048,  165, 1048,
			  165,  159,  432,  433,  435,  430,  159, 1048,  436,  159,
			  165,  165, 1048,  165, 1048, 1048,  165, 1048,  434,  433,
			  165,  165, 1048,  165,  442,  165, 1048,  440,  165,  165,
			  165, 1048,  165,  165,  434,  433,  437,  430,  165,  165,
			  438,  165,  165,  165,  165,  165,  165,  159,  437,  159,
			  434,  159,  438,  159,  442,  165,  165, 1048,  439,  440,
			 1048,  165, 1048,  443,  159,  165,  159,  165, 1048, 1048,
			  165,  165,  165,  444, 1048, 1048,  165,  165,  165,  165,
			  437,  165,  165,  165,  438,  165,  442, 1048,  165,  159, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_nxt_template_3 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  440, 1048, 1048,  159, 1048,  444,  165,  165,  165,  165,
			 1048, 1048,  165,  159,  165,  444,  159,  159, 1048,  165,
			 1048, 1048,  159,  447,  165,  448,  159,  449,  445, 1048,
			  159,  165,  159,  159,  165,  165,  165, 1048,  450,  159,
			  165,  451,  165, 1048,  446,  165,  165, 1048,  165,  165,
			 1048, 1048,  165, 1048,  165,  452, 1048,  453,  165,  454,
			  446, 1048,  165, 1048,  165,  165,  165,  165,  165,  165,
			  455,  165,  165,  456,  165,  760,  446,  760,  165,  165,
			  761,  761,  761,  761,  165,  452, 1048,  453, 1048,  454,
			 1048, 1048,  159,  165, 1048,  165,  159, 1048, 1048,  165,

			  455,  165,  457,  456, 1048,  165,  159, 1048,  459,  159,
			  159,  165, 1048,  458,  165, 1048,  165,  452, 1048,  453,
			  460,  454, 1048,  159,  165,  165,  165,  165,  165,  159,
			  159,  159,  455, 1048,  458,  456, 1048,  165,  165, 1048,
			  461,  165,  165, 1048, 1048,  458,  165, 1048,  165, 1048,
			  461, 1048,  462,  159, 1048,  165,  463,  159,  165,  165,
			 1048,  165,  462, 1048,  464, 1048, 1048,  165, 1048,  165,
			  159,  165,  165,  159,  165,  466, 1048,  159, 1048,  165,
			 1048, 1048,  461,  159,  165,  165,  469,  159,  464,  165,
			  159,  165,  465,  165,  462, 1048,  464, 1048, 1048,  165,

			  159,  165,  165,  165,  165,  165,  165,  466,  159,  165,
			 1048,  165,  159,  159, 1048,  165,  165,  159,  470,  165,
			 1048, 1048,  165, 1048,  466,  159,  467, 1048,  470,  159,
			  159,  471,  165,  159, 1048,  165,  165,  165,  165,  165,
			  165,  165,  468,  472,  165,  165,  159,  165,  165,  165,
			 1048,  165,  165, 1048,  165,  159, 1048,  165,  468,  473,
			  470,  165,  165,  472,  165,  165, 1048,  165,  165,  165,
			  165,  165,  159,  165,  468,  472, 1048, 1048,  165,  165,
			  165,  474, 1048,  165,  165, 1048,  165,  165,  165, 1048,
			  165,  474,  475, 1048,  476,  159,  165, 1048, 1048,  159,

			  165,  159,  477, 1048,  165,  478,  487,  479,  480, 1048,
			  488, 1048,  159,  474,  762,  762,  762,  762, 1048, 1048,
			  165, 1048,  165, 1048,  481, 1048,  482,  165,  389,  389,
			  389,  165,  165,  165,  483, 1048, 1048,  484,  489,  485,
			  486,  481,  490,  482,  165, 1048,  159, 1048, 1048,  165,
			  159,  483, 1048,  165,  484,  165,  485,  486,  489,  492,
			  165,  165,  490,  491, 1048,  165, 1048,  159,  615, 1048,
			  165,  493, 1048,  481, 1048,  482, 1048,  285,  165,  285,
			  292,  165,  165,  483,  159,  165,  484,  165,  485,  486,
			  489,  492,  165,  165,  490,  492, 1048,  165, 1048,  165,

			  159, 1048,  165,  494,  159,  494,  165, 1048,  165, 1048,
			 1048,  165,  165,  622,  165,  496,  165,  159,  165, 1048,
			  495, 1048,  159,  165,  165,  497,  159,  165,  165,  165,
			  498,  159,  165,  286, 1048,  503,  165,  494,  165,  159,
			  165,  499, 1048,  165,  165,  622,  165,  496,  159,  165,
			  165, 1048,  496, 1048,  165,  165,  165,  500,  165,  504,
			 1048, 1048,  501,  165,  287, 1048,  165,  504,  165,  500,
			 1048,  165, 1048,  502,  501, 1048, 1048,  165,  165,  165,
			  165,  165,  159,  165, 1048,  502,  159,  506,  159,  165,
			  159,  504,  159,  165,  509, 1048,  507, 1048,  165,  505,

			  165,  500,  165,  165,  165,  159,  501,  159,  513,  165,
			  165,  165, 1048,  165,  165,  165,  513,  502,  165,  506,
			  165,  165,  165, 1048,  165,  165,  510,  508,  508,  510,
			  165,  506,  165,  513, 1048, 1048,  165,  165,  165,  165,
			  159,  165,  165,  165,  159,  513, 1048,  512,  165,  610,
			  610,  610,  610,  165, 1048,  513, 1048,  511, 1048,  508,
			 1048,  510,  165, 1048,  165,  513, 1048, 1048,  165, 1048,
			  165, 1048,  165,  165,  165,  165,  165,  513, 1048,  512,
			  165,  863,  863,  863,  863,  165, 1048,  513, 1048,  512,
			  256,  257,  258,  259,  260,  261,  262, 1048,  256,  257,

			  258,  259,  260,  261,  262,  277,  278,  279,  280,  281,
			  282,  283, 1048, 1048,  514,  256,  257,  258,  259,  260,
			  261,  262, 1048, 1048,  515,  515,  515,  256,  257,  258,
			  259,  260,  261,  262,  516,  516,  528,  256,  257,  258,
			  259,  260,  261,  262,  517,  517,  517,  256,  257,  258,
			  259,  260,  261,  262,  536, 1048,  518,  518,  518,  256,
			  257,  258,  259,  260,  261,  262,  519, 1048, 1048,  256,
			  257,  258,  259,  260,  261,  262,  310,  310,  310,  277,
			  278,  279,  280,  281,  282,  283,  312,  312,  312,  277,
			  278,  279,  280,  281,  282,  283,  313,  313,  313,  277,

			  278,  279,  280,  281,  282,  283,  314, 1048, 1048,  277,
			  278,  279,  280,  281,  282,  283,  285, 1048,  289,  285,
			 1048, 1048,  529,  530,  531,  532,  533,  534,  535,  286,
			 1048, 1048,  286, 1048,  293, 1048, 1048,  276, 1048, 1048,
			  537,  538,  539,  540,  541,  542,  543,  287, 1048, 1048,
			  287, 1048,  301, 1048,  286,  276, 1048,  286, 1048,  293,
			 1048, 1048,  276,  286, 1048, 1048,  286, 1048,  293, 1048,
			  623,  276,  290,  286,  159, 1048,  286, 1048,  293, 1048,
			 1048,  276, 1048,  286, 1048, 1048,  286,  159,  293, 1048,
			 1048,  276, 1048,  286, 1048, 1048,  286, 1048,  293, 1048,

			 1048,  276,  624,  291, 1048, 1048,  165,  277,  278,  279,
			  280,  281,  282,  283,  864,  864,  864,  864, 1048,  165,
			  294,  295,  296,  297,  298,  299,  300,  286, 1048, 1048,
			  286, 1048,  293, 1048, 1048,  276, 1048, 1048,  302,  303,
			  304,  305,  306,  307,  308,  294,  295,  296,  297,  298,
			  299,  300, 1048,  544,  294,  295,  296,  297,  298,  299,
			  300,  545,  545,  545,  294,  295,  296,  297,  298,  299,
			  300,  546,  546, 1048,  294,  295,  296,  297,  298,  299,
			  300,  547,  547,  547,  294,  295,  296,  297,  298,  299,
			  300,  286, 1048, 1048,  286, 1048,  293, 1048, 1048,  276,

			  277,  278,  279,  280,  281,  282,  283,  277,  278,  279,
			  280,  281,  282,  283, 1048,  548,  548,  548,  294,  295,
			  296,  297,  298,  299,  300,  287, 1048, 1048,  287, 1048,
			  301, 1048, 1048,  276,  287, 1048,  165,  287,  165,  301,
			 1048, 1048,  276, 1048,  287, 1048, 1048,  287,  165,  301,
			 1048, 1048,  276, 1048,  287, 1048, 1048,  287, 1048,  301,
			 1048, 1048,  276, 1048,  287, 1048, 1048,  287,  165,  301,
			  165, 1048,  276,  144, 1048,  612,  612,  612,  612,  549,
			  165, 1048,  294,  295,  296,  297,  298,  299,  300,  287,
			 1048, 1048,  287, 1048,  301, 1048, 1048,  276, 1048,  287, yy_Dummy>>,
			1, 1000, 2000)
		end

	yy_nxt_template_4 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 1048, 1048,  287, 1048,  301, 1048, 1048,  276,  277,  278,
			  279,  280,  281,  282,  283,  151,  302,  303,  304,  305,
			  306,  307,  308, 1048,  550,  302,  303,  304,  305,  306,
			  307,  308,  551,  551,  551,  302,  303,  304,  305,  306,
			  307,  308,  552,  552, 1048,  302,  303,  304,  305,  306,
			  307,  308,  553,  553,  553,  302,  303,  304,  305,  306,
			  307,  308,  277,  278,  279,  280,  281,  282,  283,  277,
			  278,  279,  280,  281,  282,  283, 1048,  554,  554,  554,
			  302,  303,  304,  305,  306,  307,  308,  555, 1048, 1048,
			  302,  303,  304,  305,  306,  307,  308,  556,  556,  556,

			  277,  278,  279,  280,  281,  282,  283,  557,  557,  557,
			  277,  278,  279,  280,  281,  282,  283,  108, 1048, 1048,
			  558, 1048, 1048, 1048,  108, 1048, 1048,  109, 1048, 1048,
			 1048,  559,  159,  159,  109, 1048,  159,  159,  108,  159,
			 1048,  558, 1048,  159, 1048,  108,  621, 1048,  561,  159,
			  159,  560,  560,  560,  560,  108,  159,  144,  558,  611,
			  611,  612,  612,  108,  165,  165,  558, 1048,  165,  165,
			  152,  165, 1048,  108, 1048,  165,  558, 1048,  622, 1048,
			 1048,  165,  165,  108, 1048, 1048,  558, 1048,  165,  761,
			  761,  761,  761,  108, 1048, 1048,  558, 1048, 1048,  151,

			 1048, 1048,  152,  320,  321,  322,  323,  324,  325,  326,
			  121,  122,  123,  124,  125,  126,  127,  121,  122,  123,
			  124,  125,  126,  127,  320,  321,  322,  323,  324,  325,
			  326,  320,  321,  322,  323,  324,  325,  326, 1048, 1048,
			 1048,  320,  321,  322,  323,  324,  325,  326,  562,  320,
			  321,  322,  323,  324,  325,  326,  563,  563,  563,  320,
			  321,  322,  323,  324,  325,  326,  564,  564, 1048,  320,
			  321,  322,  323,  324,  325,  326,  565,  565,  565,  320,
			  321,  322,  323,  324,  325,  326,  108, 1048, 1048,  558,
			  602,  602,  602,  602, 1048, 1048,  108, 1048, 1048,  558,

			 1048, 1048, 1048,  327,  379,  327,  327,  165,  108,  165,
			 1048,  109, 1048,  606,  606,  606,  606, 1048, 1048,  165,
			  619,  619,  619,  619, 1048, 1048,  328,  607,  328,  328,
			  380,  108, 1048, 1048,  109, 1048,  379, 1048, 1048,  165,
			 1048,  165, 1048,  108, 1048, 1048,  109,  868,  868,  868,
			  868,  165, 1048,  608, 1048,  108, 1048,  110,  109,  607,
			  394, 1048, 1048,  620,  620,  620,  620, 1048, 1048,  566,
			  566,  566,  320,  321,  322,  323,  324,  325,  326,  567,
			  110, 1048,  320,  321,  322,  323,  324,  325,  326,  111,
			  108, 1048,  110,  109,  112,  113,  114,  115,  116,  117,

			  118, 1048,  108,  394,  110,  109,  870,  870,  870,  870,
			  108, 1048,  111,  109, 1048, 1048, 1048,  112,  113,  114,
			  115,  116,  117,  118,  111,  108, 1048, 1048,  109,  112,
			  113,  114,  115,  116,  117,  118,  111,  108, 1048,  110,
			  109,  112,  113,  114,  115,  116,  117,  118, 1048,  108,
			 1048,  110,  109, 1048, 1048, 1048,  108, 1048, 1048,  109,
			 1048, 1048,  941,  108,  941, 1048,  109,  942,  942,  942,
			  942,  111, 1048, 1048,  110, 1048,  112,  113,  114,  115,
			  116,  117,  118,  111,  108, 1048,  110,  109,  112,  113,
			  114,  115,  116,  117,  118, 1048,  121,  122,  123,  124,

			  125,  126,  127, 1048,  108, 1048,  111,  109,  568,  568,
			  568,  112,  113,  114,  115,  116,  117,  118,  111, 1048,
			  569,  569,  569,  112,  113,  114,  115,  116,  117,  118,
			 1048,  943,  943,  943,  943,  121,  122,  123,  124,  125,
			  126,  127,  121,  122,  123,  124,  125,  126,  127,  121,
			  122,  123,  124,  125,  126,  127, 1048,  343,  344,  345,
			  346,  347,  348,  349, 1048, 1048, 1048,  570,  570,  570,
			  121,  122,  123,  124,  125,  126,  127,  343,  344,  345,
			  346,  347,  348,  349, 1048, 1048, 1048,  571,  571,  571,
			  121,  122,  123,  124,  125,  126,  127, 1048, 1048, 1048,

			  572,  343,  344,  345,  346,  347,  348,  349,  578,  573,
			  573,  573,  343,  344,  345,  346,  347,  348,  349,  579,
			  756,  756,  756,  756, 1048, 1048,  581,  947,  947,  947,
			  947, 1048, 1048,  582, 1048,  574,  574, 1048,  343,  344,
			  345,  346,  347,  348,  349,  575,  575,  575,  343,  344,
			  345,  346,  347,  348,  349,  584,  948,  948,  948,  948,
			  757, 1048,  585,  576,  576,  576,  343,  344,  345,  346,
			  347,  348,  349, 1048, 1048, 1048,  577, 1048, 1048,  343,
			  344,  345,  346,  347,  348,  349,  583,  583,  583,  583,
			  343,  344,  345,  346,  347,  348,  349,  586, 1048, 1048,

			 1048,  343,  344,  345,  346,  347,  348,  349,  343,  344,
			  345,  346,  347,  348,  349,  343,  344,  345,  346,  347,
			  348,  349,  587,  165, 1048,  165, 1048, 1048, 1048,  588,
			  763,  763,  763,  763, 1048,  165,  589,  343,  344,  345,
			  346,  347,  348,  349,  343,  344,  345,  346,  347,  348,
			  349,  590, 1048, 1048, 1048,  165, 1048,  165,  591,  343,
			  344,  345,  346,  347,  348,  349,  592,  165, 1048, 1048,
			  764, 1048, 1048,  593,  950,  950,  950,  950, 1048,  343,
			  344,  345,  346,  347,  348,  349,  594,  765, 1048,  612,
			  612,  612,  612,  595,  942,  942,  942,  942, 1048, 1048,

			  596, 1048, 1048, 1048,  343,  344,  345,  346,  347,  348,
			  349,  343,  344,  345,  346,  347,  348,  349,  343,  344,
			  345,  346,  347,  348,  349,  597, 1048, 1048, 1048,  394,
			 1048, 1048,  598,  343,  344,  345,  346,  347,  348,  349,
			  343,  344,  345,  346,  347,  348,  349,  599,  343,  344,
			  345,  346,  347,  348,  349,  343,  344,  345,  346,  347,
			  348,  349, 1048, 1048, 1048, 1048,  528, 1048,  343,  344,
			  345,  346,  347,  348,  349,  343,  344,  345,  346,  347,
			  348,  349,  343,  344,  345,  346,  347,  348,  349, 1048,
			  626, 1048, 1048,  165,  165,  165,  165, 1048, 1048, 1048,

			 1048, 1048, 1048,  528, 1048,  165,  165,  343,  344,  345,
			  346,  347,  348,  349,  343,  344,  345,  346,  347,  348,
			  349, 1048,  626, 1048, 1048,  165,  165,  165,  165,  343,
			  344,  345,  346,  347,  348,  349, 1048,  165,  165, 1048,
			 1048,  128,  128,  128,  343,  344,  345,  346,  347,  348,
			  349, 1048,  529,  530,  531,  532,  533,  534,  535,  277,
			  278,  279,  280,  281,  282,  283, 1048, 1048,  128,  128,
			  128,  343,  344,  345,  346,  347,  348,  349,  128,  128,
			  128,  343,  344,  345,  346,  347,  348,  349,  733,  529,
			  530,  531,  532,  533,  534,  535,  942,  942,  942,  942, yy_Dummy>>,
			1, 1000, 3000)
		end

	yy_nxt_template_5 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  128,  128,  128,  343,  344,  345,  346,  347,  348,  349,
			  997,  997,  997,  997, 1048,  600,  600,  600,  343,  344,
			  345,  346,  347,  348,  349, 1002, 1002, 1002, 1002, 1048,
			  601,  601,  601,  343,  344,  345,  346,  347,  348,  349,
			  391,  391,  391,  391, 1048,  624,  949,  949,  949,  949,
			  391,  391,  391,  391,  391,  391,  165,  159,  165,  159,
			  165,  159,  165,  159, 1048,  625,  628, 1048,  165, 1048,
			 1048, 1048,  165, 1048,  159, 1048,  627,  624, 1048, 1048,
			  617, 1048,  391,  391,  391,  391,  391,  391,  165,  165,
			  165,  165,  165,  165,  165,  165, 1048,  626,  628,  159,

			  165, 1048,  632,  159,  165,  159,  165,  631,  628,  159,
			  159,  165, 1048,  165,  159, 1048,  159,  165, 1048,  165,
			 1048, 1048,  159,  165,  634, 1048, 1048,  159,  633,  165,
			 1048,  165, 1048, 1048,  632,  165,  159,  165, 1048,  632,
			  159,  165,  165,  165, 1048,  165,  165, 1048,  165,  165,
			 1048,  165, 1048,  159,  165,  165,  634,  635,  638,  165,
			  634,  165,  637,  165, 1048,  165,  159, 1048,  165,  165,
			  159,  165,  165,  636,  159,  165,  165, 1048,  165,  159,
			 1048,  165,  640, 1048, 1048,  165, 1048,  639,  165,  636,
			  638, 1048,  159, 1048,  638,  165,  159,  165,  165, 1048,

			  159,  165,  165,  165,  643,  636,  165,  165,  165,  159,
			  165,  165,  641,  165,  640, 1048, 1048,  159,  644,  640,
			  165,  165,  159,  165,  165,  165,  645,  165,  165, 1048,
			  642, 1048,  165,  165, 1048, 1048,  644,  165, 1048,  159,
			 1048,  165, 1048,  159,  642, 1048, 1048,  159, 1048,  165,
			  644, 1048, 1048,  165,  165,  165, 1048,  165,  646,  165,
			  159,  646,  642, 1048,  165,  165,  165, 1048,  165,  165,
			  165,  165, 1048,  648,  159,  165,  165, 1048,  159,  165,
			  165,  755,  755,  755,  755, 1048,  159, 1048, 1048, 1048,
			  653,  159,  165,  646,  647,  379,  165,  649,  165, 1048,

			  165,  159,  165,  159, 1048,  648,  165,  165,  165,  165,
			  165,  650,  165, 1048,  159,  658, 1048,  651,  165,  165,
			  159,  380,  654,  165,  159,  654,  648,  379,  165,  651,
			  165,  652,  165,  165,  165,  165, 1048,  159,  655,  165,
			  165,  165, 1048,  652,  165, 1048,  165,  658, 1048,  651,
			 1048,  165,  165, 1048, 1048, 1048,  165,  654, 1048, 1048,
			  165, 1048,  165,  652,  165, 1048,  165, 1048, 1048,  165,
			  656,  165,  165,  165, 1048,  159,  165, 1048,  656,  159,
			  159,  159, 1048,  165,  159,  159, 1048,  165,  661,  165,
			 1048,  663,  159,  659,  657, 1048, 1048,  159,  159,  165,

			 1048,  662,  664,  165,  165,  165,  660,  165, 1048, 1048,
			  656,  165,  165,  165,  165,  165,  165,  165,  159,  165,
			  661,  165,  665,  664,  165,  661,  658, 1048,  159,  165,
			  165,  165,  669,  662,  664,  159,  165, 1048,  662,  159,
			  159, 1048,  666,  159,  159,  159,  165,  667,  673,  165,
			  165,  165,  159, 1048,  666,  671,  159,  159, 1048, 1048,
			  165,  165, 1048,  668,  670,  159,  165,  165,  165, 1048,
			 1048,  165,  165, 1048,  666,  165,  165,  165,  165,  668,
			  674,  165, 1048,  165,  165,  670, 1048,  672,  165,  165,
			 1048, 1048,  165,  165,  165,  668,  674,  165,  165,  165,

			  165,  165, 1048,  672,  165, 1048, 1048,  165,  159,  165,
			  165,  165,  675,  676, 1048, 1048, 1048,  670, 1048,  165,
			  165, 1048,  165, 1048,  165,  159,  165, 1048,  674, 1048,
			  677,  165,  165,  165,  159,  672,  165,  678,  159,  165,
			  165,  165,  159,  165,  676,  676, 1048,  159,  165, 1048,
			  165,  165,  165,  679,  165,  159, 1048,  165, 1048,  165,
			  165,  165,  678,  680,  165, 1048,  165, 1048, 1048,  678,
			  165,  165,  159,  159,  165, 1048,  683,  159, 1048,  165,
			  165,  681,  165,  682, 1048,  680,  165,  165,  165,  159,
			  159,  165,  165,  165, 1048,  680, 1048, 1048,  165, 1048,

			  165, 1048,  165,  165,  165,  165, 1048,  684,  684,  165,
			 1048, 1048,  165,  682,  165,  682,  165, 1048,  165,  159,
			  165,  165,  165,  159, 1048,  165,  165,  165,  686, 1048,
			  165, 1048,  165,  685,  165, 1048,  159,  165, 1048,  684,
			 1004, 1004, 1004, 1004,  165,  159,  165, 1048,  165,  159,
			  159,  165, 1048, 1048,  687,  165, 1048,  165,  165,  165,
			  686, 1048,  159, 1048,  688,  686, 1048,  159,  165,  165,
			  159,  165,  689,  165,  159,  690,  159,  165, 1048, 1048,
			  693,  165,  165,  165,  159, 1048,  688,  159,  695,  691,
			 1048, 1048,  692,  159,  165, 1048,  688, 1048,  165,  165,

			  165,  159,  165,  165,  691,  165,  165,  692,  165,  697,
			  165, 1048,  694,  159,  159,  165,  165, 1048,  159,  165,
			  696,  691, 1048, 1048,  692,  165,  159, 1048, 1048, 1048,
			  165,  159,  165,  165,  699,  159,  159,  701, 1048,  159,
			  159,  698,  165, 1048, 1048,  165,  165, 1048, 1048, 1048,
			  165,  698,  159,  705, 1048,  702, 1048, 1048,  165, 1048,
			 1048,  159,  165,  165,  165,  707,  700,  165,  165,  703,
			  694,  165,  165,  696,  165, 1048, 1048,  165,  159,  165,
			  165, 1048,  165,  698,  165,  706,  165,  704,  165,  165,
			 1048, 1048,  165,  165,  165,  700,  165,  708,  165,  709,

			 1048, 1048,  694,  159,  703,  696,  165, 1048, 1048,  165,
			  165,  165,  165,  165,  165,  165,  159,  165,  165,  165,
			  165,  165,  704,  706,  165,  165, 1048,  700, 1048,  165,
			  165,  710, 1048,  708, 1048,  165,  703, 1048, 1048, 1048,
			  165, 1048,  165, 1048, 1048,  165, 1048,  165,  165,  165,
			 1048,  165,  165,  710,  704,  706,  159,  165, 1048, 1048,
			  159,  165, 1048,  159,  165,  708,  165,  159, 1048,  713,
			 1048,  711,  165,  159,  165,  165,  165,  714,  712, 1048,
			  159,  165, 1048,  165,  165,  710, 1048,  165,  165, 1048,
			 1048, 1048,  165,  165, 1048,  165,  165, 1048,  165,  165,

			  159,  714, 1048,  712,  715,  165, 1048,  165,  165,  714,
			  712,  716,  165,  165,  718,  165, 1048,  159,  165,  165,
			  165,  165,  159,  165,  159,  165,  717,  159,  159, 1048,
			  165,  159,  165,  165, 1048,  721,  716, 1048, 1048,  159,
			  719,  159, 1048,  716,  159, 1048,  718, 1048, 1048,  165,
			  165, 1048,  165,  165,  165,  165,  165, 1048,  718,  165,
			  165, 1048,  165,  165, 1048,  165, 1048,  722, 1048, 1048,
			 1048,  165,  720,  165, 1048,  165,  165,  165,  722, 1048,
			  720,  165,  159,  165, 1048, 1048,  159,  165,  165, 1048,
			  165, 1048, 1048,  165,  159, 1048, 1048, 1048,  159,  159, yy_Dummy>>,
			1, 1000, 4000)
		end

	yy_nxt_template_6 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  165,  724,  723, 1048,  165, 1048,  165,  165, 1048,  165,
			  722,  159,  720,  165,  165,  165,  165,  513,  165,  165,
			  165, 1048,  165,  528,  159,  165,  165,  725,  159,  726,
			  165,  165,  165,  724,  724,  513,  165,  165,  165,  165,
			  159,  159,  513,  165,  159, 1048, 1048,  159,  165,  165,
			  165,  159,  728,  727,  513, 1048,  165,  159, 1048,  726,
			  165,  726,  165,  165,  159,  165,  513, 1048, 1048,  165,
			 1048,  165,  165,  165, 1048,  165,  165,  513, 1048,  165,
			 1048,  165,  165,  165,  728,  728,  528, 1048, 1048,  165,
			  949,  949,  949,  949,  165,  165,  165,  165,  528,  256,

			  257,  258,  259,  260,  261,  262,  738,  165,  528,  529,
			  530,  531,  532,  533,  534,  535,  536,  256,  257,  258,
			  259,  260,  261,  262,  256,  257,  258,  259,  260,  261,
			  262,  528,  999,  999,  999,  999,  256,  257,  258,  259,
			  260,  261,  262,  536, 1048,  729,  729,  729,  256,  257,
			  258,  259,  260,  261,  262,  536,  730,  730,  730,  256,
			  257,  258,  259,  260,  261,  262,  536, 1048, 1048,  734,
			  734,  734,  529,  530,  531,  532,  533,  534,  535,  536,
			 1048,  735,  735, 1048,  529,  530,  531,  532,  533,  534,
			  535,  736,  736,  736,  529,  530,  531,  532,  533,  534,

			  535,  536,  537,  538,  539,  540,  541,  542,  543, 1048,
			 1048,  536, 1048, 1048,  737,  737,  737,  529,  530,  531,
			  532,  533,  534,  535, 1001, 1001, 1001, 1001,  739,  537,
			  538,  539,  540,  541,  542,  543, 1048, 1048,  740,  740,
			  740,  537,  538,  539,  540,  541,  542,  543, 1048,  741,
			  741, 1048,  537,  538,  539,  540,  541,  542,  543, 1048,
			 1048, 1048,  742,  742,  742,  537,  538,  539,  540,  541,
			  542,  543,  286, 1048, 1048,  286, 1048,  293, 1048, 1048,
			  276, 1048, 1048, 1048,  743,  743,  743,  537,  538,  539,
			  540,  541,  542,  543,  744, 1048, 1048,  537,  538,  539,

			  540,  541,  542,  543,  286, 1048, 1048,  286, 1048,  293,
			 1048,  286,  276, 1048,  286,  165,  293,  165,  286,  276,
			 1048,  286,  770,  293, 1048, 1048,  276,  165,  286, 1048,
			 1048,  286, 1048,  293, 1048, 1048,  276, 1048,  286, 1048,
			 1048,  286, 1048,  293, 1048,  287,  276,  165,  287,  165,
			  301, 1048,  287,  276,  770,  287, 1048,  301, 1048,  165,
			  276, 1048, 1048,  294,  295,  296,  297,  298,  299,  300,
			  287, 1048, 1048,  287, 1048,  301, 1048,  287,  276, 1048,
			  287, 1048,  301, 1048, 1048,  276,  277,  278,  279,  280,
			  281,  282,  283, 1048, 1048,  294,  295,  296,  297,  298,

			  299,  300,  294,  295,  296,  297,  298,  299,  300,  294,
			  295,  296,  297,  298,  299,  300,  745,  745,  745,  294,
			  295,  296,  297,  298,  299,  300,  746,  746,  746,  294,
			  295,  296,  297,  298,  299,  300,  302,  303,  304,  305,
			  306,  307,  308,  302,  303,  304,  305,  306,  307,  308,
			  287, 1048, 1048,  287, 1048,  301, 1048, 1048,  276, 1048,
			 1048,  302,  303,  304,  305,  306,  307,  308,  302,  303,
			  304,  305,  306,  307,  308,  287, 1048, 1048,  287, 1048,
			  301, 1048, 1048,  276, 1048, 1048, 1048,  559,  159, 1048,
			  558, 1048,  159, 1048,  108, 1048, 1048,  558,  775, 1048,

			 1048,  108, 1048, 1048,  558,  159, 1048, 1048,  559, 1048,
			 1048,  558, 1048,  120,  749,  749,  749,  749,  108, 1048,
			  165,  558, 1048, 1048,  165,  108, 1048, 1048,  558, 1048,
			  776, 1048,  108, 1048,  120,  558, 1048,  165,  747,  747,
			  747,  302,  303,  304,  305,  306,  307,  308,  108, 1048,
			 1048,  558, 1001, 1001, 1001, 1001, 1048, 1048,  108, 1048,
			 1048,  558, 1048,  748,  748,  748,  302,  303,  304,  305,
			  306,  307,  308,  320,  321,  322,  323,  324,  325,  326,
			  320,  321,  322,  323,  324,  325,  326,  320,  321,  322,
			  323,  324,  325,  326,  320,  321,  322,  323,  324,  325,

			  326, 1048, 1048, 1048,  320,  321,  322,  323,  324,  325,
			  326,  320,  321,  322,  323,  324,  325,  326,  320,  321,
			  322,  323,  324,  325,  326,  108, 1048, 1048,  558, 1035,
			 1035, 1035, 1035, 1048,  320,  321,  322,  323,  324,  325,
			  326,  750,  750,  750,  320,  321,  322,  323,  324,  325,
			  326,  108, 1048, 1048,  109, 1048,  759,  759,  759,  759,
			 1048,  765, 1048,  611,  611,  612,  612, 1048, 1048,  108,
			  607, 1048,  109, 1048,  152, 1048,  108, 1048, 1048,  109,
			 1048, 1048, 1048,  108, 1048, 1048,  109,  766,  766,  766,
			  766, 1048, 1048, 1048, 1048, 1048,  608, 1048, 1048, 1048,

			  110, 1048,  607,  394, 1048, 1048,  152,  528,  751,  751,
			  751,  320,  321,  322,  323,  324,  325,  326,  110, 1048,
			 1048, 1048, 1048,  951, 1048,  951, 1048,  394,  949,  949,
			  949,  949,  111, 1048, 1048, 1048, 1048,  112,  113,  114,
			  115,  116,  117,  118, 1048, 1048, 1048, 1048, 1048, 1048,
			  111,  620,  620,  620,  620,  112,  113,  114,  115,  116,
			  117,  118,  121,  122,  123,  124,  125,  126,  127,  121,
			  122,  123,  124,  125,  126,  127,  343,  344,  345,  346,
			  347,  348,  349,  343,  344,  345,  346,  347,  348,  349,
			 1048,  394, 1048,  529,  530,  531,  532,  533,  534,  535,

			 1048,  343,  344,  345,  346,  347,  348,  349,  343,  344,
			  345,  346,  347,  348,  349,  752,  752,  752,  343,  344,
			  345,  346,  347,  348,  349,  753,  753,  753,  343,  344,
			  345,  346,  347,  348,  349, 1048, 1007, 1007, 1007, 1007,
			 1048, 1048, 1048,  754,  583,  583,  583,  583,  755,  755,
			  755,  755, 1048,  865,  865,  865,  865,  862,  862,  862,
			  862, 1048,  861,  866,  866,  866,  866,  871, 1048,  128,
			  128,  128,  343,  344,  345,  346,  347,  348,  349,  128,
			  128,  128,  343,  344,  345,  346,  347,  348,  349, 1048,
			 1048, 1048,  159,  165,  861,  165,  159,  757,  159,  871,

			 1048,  768,  159,  867, 1048,  165, 1048, 1048, 1048,  159,
			 1048,  767, 1048, 1048, 1048,  159,  769,  343,  344,  345,
			  346,  347,  348,  349,  165,  165, 1048,  165,  165, 1048,
			  165, 1048,  159,  768,  165,  772,  159,  165,  771, 1048,
			  165,  165,  165,  768, 1048, 1048,  159,  165,  770,  159,
			  159, 1048,  165, 1048,  773, 1048,  774, 1048, 1048,  165,
			 1048,  165, 1048,  159,  165, 1048, 1048,  772,  165, 1048,
			  772,  165,  165,  165,  165,  165,  776,  165,  165,  165,
			  778,  165,  165,  159,  165,  165,  774,  159,  774,  165,
			 1048,  165, 1048,  165, 1048,  165, 1037, 1037, 1037, 1037, yy_Dummy>>,
			1, 1000, 5000)
		end

	yy_nxt_template_7 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  159,  777, 1048,  165, 1048,  165,  159,  165,  776,  165,
			  779,  165,  778, 1048, 1048,  165, 1048,  165,  780,  165,
			 1048,  165,  159,  159, 1048,  165,  159,  165,  165, 1048,
			  165,  159,  165,  778, 1048,  783,  782,  165,  165,  159,
			  165,  781,  780, 1048,  786, 1048, 1048, 1048,  159,  165,
			  780,  165, 1048, 1048,  165,  165, 1048,  165,  165,  165,
			  165,  165,  165,  165, 1048, 1048, 1048,  784,  782,  165,
			  784,  165,  165,  782, 1048, 1048,  786,  165,  159,  165,
			  165,  165,  159,  165,  785,  165,  159,  165,  159,  165,
			  159,  788,  159,  165, 1048,  159,  789,  165, 1048, 1048,

			 1048, 1048,  784,  787, 1048,  159, 1048, 1048,  159,  165,
			  165,  165,  159, 1048,  165, 1048,  786,  165,  165,  165,
			  165,  165,  165,  788,  165,  791, 1048,  165,  790,  165,
			 1048,  790, 1048, 1048,  165,  788,  165,  165,  159,  165,
			  165,  165,  159,  159,  165,  792,  165,  159, 1048, 1048,
			  165,  165,  794, 1048, 1048,  795,  793,  792, 1048, 1048,
			  159, 1048,  165,  790, 1048, 1048,  165, 1048,  165, 1048,
			  165,  165, 1048,  165,  165,  165,  159,  792,  165,  165,
			  159,  159,  165,  165,  794,  799, 1048,  796,  794,  165,
			 1048,  165,  165,  797,  165,  796, 1048,  165,  159,  165,

			 1048,  165,  159,  798, 1048, 1048,  159,  800,  165,  165,
			 1048,  159,  165,  165,  165,  159,  165,  800, 1048,  159,
			 1048,  165,  801,  165, 1048,  798,  165,  796,  159,  165,
			  165,  165, 1048,  165,  165,  798, 1048, 1048,  165,  800,
			  165,  165,  165,  165, 1048, 1048,  165,  165,  165,  802,
			 1048,  165,  165,  159,  802, 1048,  804,  803,  165,  165,
			  165,  165, 1048,  165, 1048,  165, 1048, 1048, 1048,  159,
			  159,  165,  165,  159,  165,  165, 1048,  805,  165, 1048,
			  165,  802, 1048,  159,  165,  165,  159,  159,  804,  804,
			  808,  165,  165,  165,  165,  165, 1048,  165, 1048, 1048,

			  159,  165,  165,  165,  810,  165,  807,  165,  806,  806,
			  165,  165,  165,  165, 1048,  165,  159,  159,  165,  165,
			  159,  159,  808,  165,  165,  165,  165,  165, 1048, 1048,
			 1048,  812,  165,  159,  811,  814,  810,  165,  808,  809,
			  806, 1048,  165,  165,  165,  165, 1048,  159,  165,  165,
			 1048,  813,  165,  165,  165,  165,  159,  165, 1048,  165,
			  159, 1048, 1048,  812,  159,  165,  812,  814,  159,  165,
			 1048,  810,  159,  815,  165,  165,  165,  165,  165,  165,
			  165,  816,  818,  814,  165,  159,  165,  165,  165,  159,
			  165,  159,  165,  159,  165,  159,  165, 1048, 1048,  165,

			  165,  165,  817, 1048,  165,  816,  159,  165,  159,  165,
			  165,  165,  165,  816,  818, 1048,  165,  165, 1048,  165,
			 1048,  165,  165,  165,  159,  165,  165,  165,  159,  819,
			 1048,  165, 1048,  165,  818,  159,  820, 1048,  165,  159,
			  165,  159,  165,  165,  165,  165,  822,  165,  165, 1048,
			 1048,  165,  159,  165,  165,  159,  165,  165,  165,  159,
			  165,  820, 1048,  165, 1048,  159,  821,  165,  820,  159,
			 1048,  165,  159,  165,  165, 1048,  165,  165,  822,  165,
			  165, 1048,  159,  165,  165,  165,  165,  165,  159,  165,
			  165,  165,  159, 1048,  838,  165,  165,  165,  822,  159,

			  165,  165,  165,  159,  165,  159,  165,  825,  823,  824,
			  826, 1048,  165,  165,  165,  165,  159, 1048, 1048, 1048,
			  165, 1048, 1048, 1048,  165,  165,  838, 1048,  165, 1048,
			 1048,  165,  165, 1048,  165,  165, 1048,  165,  165,  826,
			  824,  824,  826, 1048,  165,  165,  159,  165,  165,  159,
			  159,  827,  828,  159, 1048, 1048, 1048,  165,  165,  165,
			  165,  165, 1048,  159, 1048,  830,  829, 1048, 1048,  159,
			  165,  165, 1048,  159, 1048, 1048, 1048,  833,  165, 1048,
			 1048,  165,  165,  828,  828,  165,  159,  165,  832,  165,
			  165,  165,  165,  165, 1048,  165,  159,  830,  830,  165,

			  159,  165,  165,  165, 1048,  165, 1048,  834,  831,  834,
			  165, 1048,  165,  159, 1048, 1048, 1048, 1048,  165,  165,
			  832,  165,  165, 1048, 1048, 1048,  159, 1048,  165, 1048,
			  159,  165,  165, 1048, 1048, 1048, 1048, 1048, 1048,  834,
			  832, 1048,  165,  159,  165,  165,  835, 1048,  159, 1048,
			 1048,  165,  159,  165,  165, 1048, 1048,  159,  165,  837,
			  836,  159,  165,  165,  165,  159,  165, 1048, 1048,  159,
			 1048,  841, 1048,  159,  159,  165,  165,  840,  836,  842,
			  165,  839, 1048,  165,  165,  165,  159, 1048,  165,  165,
			  165,  838,  836,  165, 1048,  165,  165,  165,  165, 1048,

			  165,  165, 1048,  842, 1048,  165,  165, 1048,  165,  840,
			  159,  842, 1048,  840,  159, 1048, 1048,  165,  165,  165,
			  165,  159,  165,  844,  159,  159, 1048,  843,  159,  165,
			 1048,  165,  165,  165, 1048,  846,  845, 1048,  159, 1048,
			 1048,  159,  165,  165, 1048, 1048,  165, 1048, 1048,  165,
			  165,  165,  165,  165,  159,  844,  165,  165,  159,  844,
			  165,  165,  165,  165,  165,  165,  165,  846,  846, 1048,
			  165,  159, 1048,  165,  159,  165,  165,  848,  159,  847,
			 1048, 1048,  165,  165,  165,  165,  165, 1048, 1048, 1048,
			  165,  159, 1048, 1048,  165,  165,  165, 1048,  165, 1048,

			 1048,  159,  852,  165,  165,  159,  165, 1048,  165,  848,
			  165,  848, 1048, 1048,  165,  165,  528,  165,  159, 1048,
			  165,  849,  165,  165,  159, 1048,  853,  165,  159,  850,
			  159, 1048,  165,  165,  852,  851,  165,  165,  513, 1048,
			  159,  159, 1048,  159,  159, 1048,  165,  165,  513,  165,
			  165,  528,  165,  850,  165,  854,  165,  159,  854,  165,
			  165,  850,  165,  528,  165,  159,  165,  852,  165,  159,
			 1048, 1048,  165,  165,  528,  165,  165, 1048,  165,  165,
			 1048,  165,  159,  165,  528,  165, 1048,  854, 1048,  165,
			 1048,  165,  536, 1048, 1048,  165, 1048,  165,  165,  536,

			  165,  165,  529,  530,  531,  532,  533,  534,  535,  536,
			  165, 1048, 1048, 1048,  165,  165,  536,  165, 1048, 1048,
			  256,  257,  258,  259,  260,  261,  262,  165,  536, 1048,
			  256,  257,  258,  259,  260,  261,  262,  529,  530,  531,
			  532,  533,  534,  535,  536, 1048, 1048, 1048, 1048,  529,
			  530,  531,  532,  533,  534,  535, 1048,  855,  855,  855,
			  529,  530,  531,  532,  533,  534,  535,  856,  856,  856,
			  529,  530,  531,  532,  533,  534,  535, 1048,  537,  538,
			  539,  540,  541,  542,  543,  537,  538,  539,  540,  541,
			  542,  543, 1048, 1048, 1048,  537,  538,  539,  540,  541, yy_Dummy>>,
			1, 1000, 6000)
		end

	yy_nxt_template_8 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  542,  543,  537,  538,  539,  540,  541,  542,  543, 1048,
			 1048,  857,  857,  857,  537,  538,  539,  540,  541,  542,
			  543,  108, 1048, 1048,  558, 1048, 1048,  858,  858,  858,
			  537,  538,  539,  540,  541,  542,  543,  286, 1048, 1048,
			  286, 1048,  293, 1048,  286,  276, 1048,  286, 1048,  293,
			 1048,  287,  276, 1048,  287,  165,  301,  165,  287,  276,
			 1048,  287, 1048,  301, 1048, 1048,  276,  165, 1048, 1048,
			  108, 1048, 1048,  558, 1048, 1048, 1048,  108, 1048, 1048,
			  558, 1048,  120,  859,  859,  859,  859,  165,  860,  165,
			 1048,  343,  344,  345,  346,  347,  348,  349,  998,  165,

			  998, 1048, 1048,  999,  999,  999,  999,  320,  321,  322,
			  323,  324,  325,  326, 1048, 1048, 1048, 1048, 1048, 1048,
			  343,  344,  345,  346,  347,  348,  349, 1048,  294,  295,
			  296,  297,  298,  299,  300,  294,  295,  296,  297,  298,
			  299,  300,  302,  303,  304,  305,  306,  307,  308,  302,
			  303,  304,  305,  306,  307,  308,  320,  321,  322,  323,
			  324,  325,  326,  320,  321,  322,  323,  324,  325,  326,
			  343,  344,  345,  346,  347,  348,  349,  865,  865,  865,
			  865,  869,  869,  869,  869,  872, 1048,  620,  620,  620,
			  620,  607,  159,  159, 1048, 1048,  159,  159, 1048,  165,

			 1048,  165,  159,  159,  875, 1048,  159,  159, 1048,  159,
			  159,  165, 1048, 1048,  165,  873,  874,  608, 1048,  159,
			  159,  764, 1048,  607,  165,  165,  165,  151,  165,  165,
			 1048,  165, 1048,  165,  165,  165,  876, 1048,  165,  165,
			 1048,  165,  165,  165,  876,  159,  165,  874,  874,  159,
			 1048,  165,  165,  165,  165,  165,  165,  159,  165, 1048,
			 1048,  159,  159, 1048, 1048,  165,  165,  165, 1048,  165,
			 1048,  165, 1048,  884,  159, 1048,  876,  165,  159,  165,
			 1048,  165,  159,  165, 1048,  165,  165,  165,  165,  165,
			  165, 1048,  165,  165,  165,  877,  878,  165,  165,  165,

			  159,  165,  165,  165,  879,  884,  165, 1048,  880,  159,
			  165,  165,  881,  159,  165,  165,  882,  159,  165,  165,
			  165,  165,  165, 1048,  165,  159,  159,  878,  878,  159,
			  165,  165,  165, 1048,  165, 1048,  881, 1048,  883,  159,
			  882,  165,  159,  159,  881,  165, 1048, 1048,  882,  165,
			  165,  165,  165,  165, 1048, 1048,  885,  165,  165, 1048,
			  159,  165,  165,  165,  159,  887,  165, 1048,  165, 1048,
			  884,  165,  886,  888,  165,  165,  159,  159,  165,  165,
			  889,  165, 1048, 1048, 1048, 1048,  159, 1048,  886,  891,
			  159,  165,  165,  159, 1048, 1048,  165,  888,  165, 1048,

			  165, 1048, 1048,  159,  886,  888, 1048,  890,  165,  165,
			  165,  165,  890,  165,  165,  159,  165, 1048,  165,  159,
			  892,  892,  165,  165, 1048,  165,  165, 1048,  165,  165,
			  165,  165,  159, 1048,  893,  165, 1048,  894, 1048,  890,
			  165,  165,  165,  165,  896,  165,  165,  165,  165, 1048,
			 1048,  165,  892,  159,  165,  165, 1048,  159,  165, 1048,
			  165,  165,  165,  165,  165, 1048,  894,  159, 1048,  894,
			  159,  159,  165,  165,  165,  165,  896,  165,  159,  159,
			  895, 1048,  159,  159,  159,  165,  165,  165,  165,  165,
			  165, 1048,  899, 1048,  898,  897,  159, 1048, 1048,  165,

			  165, 1048,  165,  165,  159,  165, 1048,  900,  901, 1048,
			  165,  165,  896, 1048,  165,  165,  165,  165, 1048, 1048,
			  165,  159,  165, 1048,  900, 1048,  898,  898,  165,  165,
			  159,  165,  165, 1048,  159,  902,  165,  165,  903,  900,
			  902,  165,  165,  904,  165, 1048,  165,  159,  165,  165,
			 1048,  159,  159,  165,  165,  159,  159, 1048,  165, 1048,
			  905,  165,  165,  165, 1048, 1048,  165,  902,  159,  159,
			  904, 1048, 1048,  165,  165,  904,  165, 1048,  165,  165,
			  165, 1048, 1048,  165,  165, 1048,  165,  165,  165, 1048,
			  165,  906,  906,  159,  165,  907,  165,  159,  908,  159,

			  165,  165, 1048,  159,  159, 1048,  165,  165,  159,  165,
			  159, 1048,  909, 1048, 1048, 1048,  159,  910, 1048,  165,
			  165,  159,  165,  906, 1048,  165,  165,  908,  165,  165,
			  908,  165,  165,  159, 1048,  165,  165,  159,  165,  165,
			  165,  165,  165,  165,  910,  165, 1048, 1048,  165,  910,
			  159,  165,  165,  165,  165,  165, 1048,  911,  165,  159,
			  165, 1048,  159,  913,  165,  165,  159, 1048, 1048,  165,
			  165,  912, 1048, 1048,  914,  165,  159,  165, 1048,  915,
			 1048,  165,  165,  165, 1048, 1048, 1048,  165, 1048,  912,
			  165,  165,  165,  165,  165,  914, 1048,  159,  165, 1048,

			 1048,  159,  165,  912, 1048,  165,  914,  165,  165, 1048,
			  165,  916,  165,  165,  159,  165,  916,  918, 1048,  159,
			  917, 1048,  165,  159,  159,  165,  159,  919,  921,  165,
			  923, 1048, 1048,  165, 1048,  920,  159,  165,  165,  165,
			  165,  159,  165,  159,  165, 1048,  165, 1048,  916,  918,
			  165,  165,  918, 1048,  165,  165,  165,  922,  165,  920,
			  922, 1048,  924, 1048,  165, 1048,  165,  920,  165, 1048,
			  165,  924,  165,  165, 1048,  165,  165,  159,  165, 1048,
			  165,  159,  165, 1048,  159,  165,  928,  165,  927,  922,
			  165,  926, 1048,  165,  925,  165,  165,  165,  165, 1048,

			 1048,  159, 1048,  924, 1048,  165, 1048, 1048,  165,  165,
			  165,  159,  165,  165, 1048,  159,  165,  165,  928,  165,
			  928, 1048,  165,  926, 1048,  165,  926,  165,  159,  165,
			  929,  159,  165,  165,  165,  159, 1048,  165,  159,  165,
			  930,  165,  159,  165,  165, 1048, 1048,  165,  159, 1048,
			 1048,  165, 1048, 1048, 1048,  159, 1048,  931, 1048, 1048,
			  165,  933,  930,  165,  165,  159,  165,  165,  934, 1048,
			  165,  165,  930,  165,  165, 1048,  165, 1048,  159,  165,
			  165,  165,  165,  165,  165, 1048, 1048,  165,  159,  932,
			  932,  165,  159,  934,  165,  159,  165,  165,  165,  159,

			  934, 1048, 1048,  935,  936,  159, 1048,  165,  165,  165,
			  165,  165,  159,  165,  165, 1048,  165,  159, 1048,  165,
			  165,  937,  932,  165,  165,  528,  165,  165,  165,  159,
			  165,  165,  528,  159,  159,  936,  936,  165,  938,  165,
			  165,  165,  536, 1048,  165,  165,  159,  165,  165,  165,
			  165,  165,  536,  938,  159, 1048, 1048,  165,  159, 1048,
			  165,  165,  165, 1048,  940,  165,  165,  939, 1048,  108,
			  938,  159,  558, 1048,  165, 1048, 1048,  165,  165,  165,
			  165,  120,  165, 1048, 1048, 1048,  165, 1048, 1048,  165,
			  165, 1048,  165,  165,  165,  165,  940, 1048, 1048,  940, yy_Dummy>>,
			1, 1000, 7000)
		end

	yy_nxt_template_9 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 1048, 1048, 1048,  165, 1048,  165,  165,  942,  942,  942,
			  942,  529,  530,  531,  532,  533,  534,  535,  529,  530,
			  531,  532,  533,  534,  535,  165, 1048,  165,  537,  538,
			  539,  540,  541,  542,  543, 1048, 1048,  165,  537,  538,
			  539,  540,  541,  542,  543, 1048, 1048,  757,  865,  865,
			  865,  865, 1048, 1048, 1048,  320,  321,  322,  323,  324,
			  325,  326,  945,  946,  946,  946,  946,  949,  949,  949,
			  949,  953,  953,  953,  953, 1048,  159,  165,  159,  165,
			  159, 1048,  159,  159,  159,  954,  956,  159,  159,  165,
			 1048, 1048, 1048,  159,  945,  159, 1048, 1048,  955, 1048,

			  159,  159,  957,  867, 1048, 1048, 1048,  764,  165,  165,
			  165,  165,  165, 1048,  165,  165,  165,  954,  956,  165,
			  165,  165,  159, 1048, 1048,  165,  159,  165, 1048,  165,
			  956,  165,  165,  165,  958, 1048,  959,  958,  165,  159,
			  165,  165, 1048,  165, 1048,  165,  960,  159, 1048, 1048,
			  165,  159, 1048, 1048,  165,  165, 1048, 1048,  165, 1048,
			 1048,  165, 1048,  165,  159, 1048,  961, 1048,  960,  958,
			  165,  165,  165,  165, 1048,  165,  159,  165,  960,  165,
			  963,  964,  165,  165, 1048, 1048, 1048,  165,  165,  165,
			  165,  165,  165,  159,  165, 1048,  165,  962,  962,  159,

			  165,  165,  159,  159,  165,  165,  159,  165,  165, 1048,
			  159, 1048,  964,  964,  965, 1048,  159,  165, 1048,  159,
			  165,  165,  165,  165,  165,  165,  165,  159, 1048,  962,
			 1048,  165,  165,  165,  165,  165,  165,  165,  165,  165,
			  159,  967,  165,  966,  159,  159,  966, 1048,  165,  165,
			  165,  165,  165,  165, 1048,  165,  968,  159,  159,  165,
			 1048, 1048,  165, 1048,  159,  165,  159,  165,  969,  165,
			  159, 1048,  165,  968, 1048,  966,  165,  165, 1048,  165,
			 1048,  159,  165,  159,  165,  165,  970,  165,  968,  165,
			  165, 1048, 1048,  165,  165,  165,  165,  165,  165,  165,

			  970,  165,  165,  159,  165,  165,  165,  159, 1048, 1048,
			  165,  165,  165,  165, 1048,  165,  165,  972,  970, 1048,
			  159,  971,  165, 1048, 1048,  165, 1048,  165,  159, 1048,
			 1048,  165,  159,  974, 1048,  165,  165,  165,  165,  165,
			 1048,  973,  165,  165,  165,  159, 1048, 1048,  165,  972,
			 1048,  159,  165,  972,  165,  159, 1048, 1048, 1048,  165,
			  165,  165,  159,  165,  165,  974,  159,  976,  159, 1048,
			  975,  165,  165,  974,  165,  165, 1048,  165,  979,  159,
			  978,  977,  159,  165,  165, 1048, 1048,  165,  159, 1048,
			 1048,  165,  159,  165,  165,  159,  980, 1048,  165,  976,

			  165, 1048,  976,  165,  165,  159,  165,  165, 1048,  165,
			  980,  165,  978,  978,  165, 1048,  165, 1048, 1048,  165,
			  165,  165, 1048,  165,  165,  159, 1048,  165,  980,  159,
			  159, 1048, 1048,  165,  159, 1048, 1048,  165,  165,  165,
			  165,  165,  159, 1048,  981, 1048,  982,  159,  983, 1048,
			  165,  165,  165,  165,  165,  165,  159,  165, 1048,  984,
			  159,  165,  165, 1048,  165,  165,  165, 1048, 1048,  165,
			  165,  165,  165,  159,  165,  165,  982,  986,  982,  165,
			  984,  165,  165, 1048,  165,  159,  165,  165,  165,  159,
			 1048,  984,  165,  159, 1048, 1048,  165,  159,  985, 1048,

			 1048,  165,  159,  165, 1048,  165,  987,  165, 1048,  986,
			  159,  159,  165,  165,  988,  159, 1048,  165, 1048,  165,
			  165,  165,  165,  159,  165,  165,  990,  989,  159,  165,
			  986, 1048,  165,  165,  165,  165, 1048, 1048,  988,  165,
			  159,  165,  165,  165,  165,  165,  988,  165, 1048,  159,
			 1048,  165,  165,  159,  165,  165,  165,  159,  990,  990,
			  165,  159, 1048, 1048,  165,  165,  159,  165,  165, 1048,
			  165,  165,  165,  165,  159,  159,  165,  165,  165,  159,
			  165,  165,  159,  165, 1048,  165,  159, 1048,  165,  165,
			 1048, 1048,  159,  165, 1001, 1001, 1001, 1001,  165,  159,

			  165,  991,  165, 1048, 1048,  159,  165,  165,  165,  159,
			  165,  165,  165,  165,  165,  165, 1048, 1048,  165,  159,
			  165,  992,  159,  159,  165,  165,  165,  165,  994,  165,
			 1048,  165,  993,  992,  867, 1048,  159,  165,  165,  165,
			  165,  165,  165, 1048, 1048,  165,  159,  165,  996, 1048,
			  159,  165,  165,  992,  165,  165, 1048,  165,  165,  165,
			  994,  165, 1048,  159,  994,  995, 1048, 1048,  165, 1048,
			  165,  165,  165, 1048,  165, 1048, 1048, 1048,  165, 1048,
			  996, 1000,  165, 1000,  165, 1048, 1001, 1001, 1001, 1001,
			 1005, 1005, 1005, 1005, 1006,  165, 1006,  996, 1048, 1007,

			 1007, 1007, 1007,  159, 1003, 1048,  165,  159,  165,  159,
			 1048, 1048,  159,  159, 1009,  165,  159,  165,  165,  165,
			  159, 1011, 1008, 1048, 1048, 1010,  159,  165, 1048,  159,
			  608,  165, 1048, 1048, 1048,  165, 1003, 1048,  165,  165,
			  165,  165, 1048, 1048,  165,  165, 1009,  165,  165,  165,
			  165,  165,  165, 1011, 1009, 1048,  159, 1011,  165,  165,
			  159,  165,  165,  165,  165,  159,  159, 1013, 1012,  159,
			  159, 1048, 1048,  159,  165,  165,  159,  165, 1048, 1014,
			  159, 1048,  159,  159, 1048, 1048, 1048,  165,  165, 1048,
			 1048, 1048,  165,  159,  165, 1048,  165,  165,  165, 1013,

			 1013,  165,  165, 1048, 1048,  165,  165,  165,  165,  165,
			 1015, 1015,  165, 1048,  165,  165, 1048,  159,  165,  165,
			  165,  159, 1048, 1048, 1017,  165,  165,  165, 1016,  165,
			  165,  159, 1048, 1048,  159,  159,  165,  159, 1048,  165,
			  159,  159, 1015,  165,  159,  165, 1018, 1048,  159,  165,
			  165, 1048,  165,  165,  159,  165, 1017,  159,  165,  165,
			 1017,  165,  165,  165, 1048, 1048,  165,  165,  165,  165,
			 1048,  165,  165,  165, 1019,  165,  165,  165, 1019,  165,
			  165,  165,  165,  165,  165,  165,  165,  165,  159,  165,
			 1048,  165,  159, 1048,  165,  165, 1048,  165,  165, 1021,

			  165, 1025, 1048, 1048, 1048,  159, 1019, 1048,  159,  165,
			  165,  165,  159,  165,  165,  165,  165,  165,  159, 1048,
			  165, 1020, 1022,  165,  165,  159,  165,  165, 1048,  165,
			  165, 1021,  165, 1025,  159,  159, 1023,  165,  159, 1048,
			  165,  165,  165,  165,  165,  165, 1048, 1048, 1024, 1048,
			  165,  159,  159, 1021, 1023,  165, 1026,  165, 1048, 1048,
			 1048,  159, 1048, 1028, 1048,  159,  165,  165, 1023,  159,
			  165, 1048, 1027, 1048, 1048,  165, 1048,  165,  159,  165,
			 1025,  165,  159,  165,  165, 1029,  159,  165, 1027, 1048,
			  165,  165,  165,  165,  165, 1029,  165,  165, 1048,  159, yy_Dummy>>,
			1, 1000, 8000)
		end

	yy_nxt_template_10 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 1048,  165,  165,  159, 1027, 1048,  165, 1030,  159, 1048,
			  165,  165, 1032,  165,  165,  159, 1048, 1029,  165,  159,
			  159, 1048,  165,  165,  165,  159,  165, 1048,  165,  159,
			 1048,  165,  159, 1039,  165,  165, 1031, 1048,  165, 1031,
			  165, 1033, 1048,  165, 1033,  165,  159,  165,  165, 1048,
			  165,  165,  165, 1048,  165,  165,  165,  165, 1048, 1048,
			  165,  165, 1048, 1048,  165, 1040,  165, 1048, 1031, 1034,
			 1034, 1034, 1034, 1033, 1048,  165, 1048,  165,  165, 1048,
			  165, 1048,  165, 1048, 1048, 1048,  165,  165,  165, 1036,
			 1048, 1036,  165, 1048, 1037, 1037, 1037, 1037,  165,  948,

			  948,  948,  948, 1038, 1038, 1038, 1038, 1048, 1040,  757,
			 1048, 1048,  159, 1003, 1048,  165,  159,  165,  165,  159,
			  165,  159,  165,  159,  165,  159, 1048,  165, 1048,  159,
			  165, 1048, 1048, 1048,  165, 1048,  159, 1048,  159,  608,
			 1040, 1048, 1048,  764,  165, 1003, 1048,  165,  165,  165,
			  165,  165,  165,  165,  165,  165,  165,  165, 1048,  165,
			  159,  165,  165,  165,  159,  165,  165,  165,  165,  165,
			  165,  165,  159,  165,  159,  165,  159,  159,  159,  165,
			 1048,  159,  165,  165,  165,  159, 1048, 1048, 1048,  159,
			 1042,  159,  165, 1041,  165,  165,  165,  165,  159,  165,

			  165,  165,  165,  165,  165,  165,  165,  165,  165,  165,
			  165,  165,  165,  165,  165,  165,  165,  165, 1048, 1048,
			  159,  165, 1042,  165,  159, 1042,  165,  165, 1048,  165,
			  165,  159,  165, 1044,  165,  159, 1048, 1043,  165,  165,
			  165,  159, 1048,  159,  165, 1045, 1048,  159,  159, 1048,
			  165, 1048,  165, 1048, 1048, 1046,  165, 1048,  159,  165,
			  159,  165,  165,  165,  165, 1044,  165,  165,  165, 1044,
			  165,  165,  165,  165,  165,  165, 1048, 1046,  165,  165,
			  165,  165,  165,  165,  159, 1048, 1048, 1046,  159, 1048,
			  165, 1048,  165,  165,  165, 1048,  165, 1048,  165, 1048,

			  165,  159,  997,  997,  997,  997,  165,  165, 1048,  165,
			  165, 1048, 1048,  165,  159,  165,  165, 1048,  159,  165,
			  165, 1047, 1047, 1047, 1047,  165, 1004, 1004, 1004, 1004,
			 1048,  159,  159,  165, 1048,  165,  159,  165, 1048,  165,
			  159,  165,  757,  165,  159,  165,  165,  165,  159,  159,
			  165,  165,  159, 1048, 1048,  165, 1048,  159,  165, 1048,
			  165,  867, 1048,  165,  165,  159,  764,  165,  165,  165,
			  165, 1048,  165, 1048, 1048,  165,  165,  165, 1048,  165,
			  165,  165, 1048, 1048,  165, 1048, 1048,  165, 1048,  165,
			  165, 1048,  165, 1035, 1035, 1035, 1035,  165, 1048, 1048,

			 1048, 1048,  165,  147,  147,  147,  147,  147,  147,  147,
			  147,  147,  147,  147,  147,  147,  147,  165,  165,  165,
			  165,  165,  165,  165,  165,  165,  165,  165,  165,  165,
			  165, 1048, 1048,  867,   88,   88,   88,   88,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,  107,  107, 1048,
			  107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
			  107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
			  119, 1048, 1048, 1048, 1048, 1048, 1048,  119,  119,  119,
			  119,  119,  119,  119,  119,  119,  119,  119,  119,  119,

			  119,  119,  119,  120,  120, 1048,  120,  120,  120,  120,
			  120,  120,  120,  120,  120,  120,  120,  120,  120,  120,
			  120,  120,  120,  120,  120,  120,  128,  128, 1048,  128,
			  128,  128,  128, 1048,  128,  128,  128,  128,  128,  128,
			  128,  128,  128,  128,  128,  128,  128,  128,  128,  255,
			  255, 1048,  255,  255,  255, 1048, 1048,  255,  255,  255,
			  255,  255,  255,  255,  255,  255,  255,  255,  255,  255,
			  255,  255,  276, 1048, 1048,  276, 1048,  276,  276,  276,
			  276,  276,  276,  276,  276,  276,  276,  276,  276,  276,
			  276,  276,  276,  276,  276,  290,  290, 1048,  290,  290,

			  290,  290,  290,  290,  290,  290,  290,  290,  290,  290,
			  290,  290,  290,  290,  290,  290,  290,  290,  291,  291,
			 1048,  291,  291,  291,  291,  291,  291,  291,  291,  291,
			  291,  291,  291,  291,  291,  291,  291,  291,  291,  291,
			  291,  315,  315, 1048,  315,  315,  315,  315,  315,  315,
			  315,  315,  315,  315,  315,  315,  315,  315,  315,  315,
			  315,  315,  315,  315,  341, 1048, 1048, 1048, 1048,  341,
			  341,  341,  341,  341,  341,  341,  341,  341,  341,  341,
			  341,  341,  341,  341,  341,  341,  341,  381,  381,  381,
			  381,  381,  381,  381,  381, 1048,  381,  381,  381,  381,

			  381,  381,  381,  381,  381,  381,  381,  381,  381,  381,
			  388,  388,  388,  388,  388,  388,  388,  388,  388,  388,
			  388,  388,  388,  390,  390,  390,  390,  390,  390,  390,
			  390,  390,  390,  390,  390,  390,  392,  392,  392,  392,
			  392,  392,  392,  392,  392,  392,  392,  392,  392,  286,
			  286, 1048,  286,  286,  286, 1048,  286,  286,  286,  286,
			  286,  286,  286,  286,  286,  286,  286,  286,  286,  286,
			  286,  286,  287,  287, 1048,  287,  287,  287, 1048,  287,
			  287,  287,  287,  287,  287,  287,  287,  287,  287,  287,
			  287,  287,  287,  287,  287,  952,  952,  952,  952,  952,

			  952,  952,  952, 1048,  952,  952,  952,  952,  952,  952,
			  952,  952,  952,  952,  952,  952,  952,  952,    5, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,

			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, yy_Dummy>>,
			1, 918, 9000)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 9917)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			yy_chk_template_3 (an_array)
			yy_chk_template_4 (an_array)
			yy_chk_template_5 (an_array)
			yy_chk_template_6 (an_array)
			yy_chk_template_7 (an_array)
			yy_chk_template_8 (an_array)
			yy_chk_template_9 (an_array)
			yy_chk_template_10 (an_array)
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
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

			    3,    3,    3,    3,   22,   23, 1035,   23,   23,   23,
			   23,    4,    4,    4,    4,   22,   24,   26,  147,   26,
			   26,   26,   26, 1004,   24,   30,   30,  152,   12,  864,
			   26,   12,   32,   32,  997,   15,  386,   16,   15,   16,
			   16,   81,   81,   81,   25,   16,   25,   25,   25,   25,
			   83,   83,   83,   84,   84,  864,    3,   25,   25,   26,
			  147,  864,   26,   85,   85,   85,  618,    4,   27,  152,
			   27,   27,   27,   27,   86,   86,   86,   12,  386,   25,
			  171,  171,  171,  173,  173,  173,   25,    3,  616,   25,
			   25,    3,    3,    3,    3,    3,    3,    3,    4,  148,

			  148,  614,    4,    4,    4,    4,    4,    4,    4,   12,
			   27,   25,  174,  174,   12,   12,   12,   12,   12,   12,
			   12,   15,   15,   15,   15,   15,   15,   15,   16,   16,
			   16,   16,   16,   16,   16,   34,   34,   34,   34,  148,
			  175,  175,  175,  266,  266,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,  176,  176,  176,  392,   34,  390,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
			   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,

			   34,   34,   34,  388,  141,  141,  141,  141,   34,   34,
			   34,   34,   34,   34,   34,   35,  352,   35,  141,  288,
			   35,   40,   35,  269,  264,   40,  177,   35,   35,  172,
			  129,   42,  263,  263,  263,   42,  105,  104,   40,   42,
			  103,  149,  149,  149,  141,   42,  102,   35,   42,   35,
			  141,   90,   35,   40,   35,  387,  387,   40,  948,   35,
			   35,   36,   36,   42,   87,   82,   36,   42,   36,   36,
			   40,   42,   36,   36,   36,   36,   37,   42,   55,   37,
			   42,  149,   33,   37,  948,   65,   37,   65,   28,   37,
			  948,   11,   37,   36,   36,  387,   10,   65,   36,    9,

			   36,   36,    8,    7,   36,   36,   36,   36,   37,  613,
			  613,   37,  265,  265,  265,   37,    5,   65,   37,   65,
			   38,   37,   43,    0,   37,   38,   43,   38,    0,   65,
			   44,   39,   38,   38,   44,   39,   43,   38,   39,   43,
			    0,    0,   39,    0,   44,   39,    0,   44,   39,  613,
			    0,   39,   38,    0,   43,    0,    0,   38,   43,   38,
			    0,    0,   44,   39,   38,   38,   44,   39,   43,   38,
			   39,   43,    0,    0,   39,    0,   44,   39,    0,   44,
			   39,   41,    0,   39,   46,   41,   41,    0,   46,    0,
			    0,   45,   45,   41,   41,   45,    0,    0,   41,   41,

			    0,   46,   45,    0,   45,   47,    0,    0,   45,   47,
			    0,    0,   89,   41,   89,   89,   46,   41,   41,    0,
			   46,    0,   47,   45,   45,   41,   41,   45,   48,    0,
			   41,   41,   48,   46,   45,   49,   45,   47,    0,   49,
			   45,   47,   49,   50,   51,   48,    0,   48,   51,   53,
			   50,   50,   49,   53,   47,   52,   50,    0,   51,   52,
			   48,   51,   52,   53,   48,    0,   53,   49,   89,    0,
			    0,   49,   52,    0,   49,   50,   51,   48,    0,   48,
			   51,   53,   50,   50,   49,   53,    0,   52,   50,    0,
			   51,   52,    0,   51,   52,   53,    0,    0,   53,   89,

			  267,  267,  267,   60,   52,   58,   58,   58,   58,   58,
			   58,   58,   59,  268,  268,  268,    0,   59,    0,   59,
			  144,  144,  144,  144,   59,   59,   88,   88,   88,   88,
			   88,   88,   88,    0,  144,   60,   62,   92,    0,   92,
			   92,  270,  270,  270,   59,    0,   62,    0,    0,   59,
			  146,   59,  146,  146,  146,  146,   59,   59,   60,   60,
			   60,   60,   60,   60,   60,    0,  144,    0,   62,   59,
			   59,   59,   59,   59,   59,   59,   61,    0,   62,   67,
			   61,    0,   67,   61,   67,   67,   61,    0,    0,   61,
			    0,    0,  146,   92,   67,   62,   62,   62,   62,   62,

			   62,   62,  271,  271,  271,    0,    0,   63,   61,   63,
			    0,   67,   61,    0,   67,   61,   67,   67,   61,   63,
			    0,   61,    0,    0,   92,    0,   67,  272,  272,  272,
			    0,    0,   61,   61,   61,   61,   61,   61,   61,   63,
			    0,   63,   95,   95,   95,   95,   95,   95,   95,   98,
			   98,   63,   98,   98,   98,   98,   98,   98,   98,   63,
			   63,   63,   63,   63,   63,   63,   64,   66,    0,   68,
			   64,   68,   68,   66,   66,   66,    0,   64,   70,   64,
			   66,   68,    0,   64,   69,   66,   69,   69,   70,   64,
			   70,  273,  273,  273,   70,    0,   69,    0,   64,   66,

			   70,   68,   64,   68,   68,   66,   66,   66,    0,   64,
			   70,   64,   66,   68,    0,   64,   69,   66,   69,   69,
			   70,   64,   70,   71,   72,   71,   70,   73,   69,   71,
			    0,   72,   70,   72,   73,   71,   73,  274,  274,  274,
			    0,    0,   73,   72,   74,    0,   73,    0,   74,    0,
			   74,  275,  275,  275,   74,   71,   72,   71,   76,   73,
			   74,   71,    0,   72,    0,   72,   73,   71,   73,   76,
			    0,   76,   76,    0,   73,   72,   74,   75,   73,   75,
			   74,   76,   74,    0,   75,   91,   74,   91,   91,   75,
			   76,   77,   74,    0,    0,   77,   78,   77,   78,   78,

			    0,   76,    0,   76,   76,    0,    0,   77,   78,   75,
			    0,   75,   93,   76,    0,   93,   75,   93,    0,    0,
			   93,   75,    0,   77,  407,  407,  407,   77,   78,   77,
			   78,   78,    0,  151,    0,  151,  151,  151,  151,   77,
			   78,   91,   94,    0,    0,   94,    0,   94,    0,    0,
			   94,   96,   96,   96,   96,   96,   96,   96,   96,   97,
			   97,   97,   97,   97,   97,   97,   97,   97,   97,    0,
			    0,  107,   91,    0,  107,  151,   91,   91,   91,   91,
			   91,   91,   91,   99,   99,   99,   99,   99,   99,   99,
			   99,   99,   99,  100,  100,  100,  100,  100,  100,  100, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  100,  100,  100,   93,   93,   93,   93,   93,   93,   93,
			  101,    0,    0,  101,  101,  101,  101,  101,  101,  101,
			  107,    0,    0,  110,    0,  110,  110,    0,  110,    0,
			    0,  110,    0,   94,   94,   94,   94,   94,   94,   94,
			    0,  111,    0,  111,  111,    0,  111,    0,  379,  111,
			  379,    0,  107,  379,  379,  379,  379,  107,  107,  107,
			  107,  107,  107,  107,  109,    0,    0,  109,  109,  109,
			  109,  380,  380,  380,  380,    0,  109,  110,    0,  112,
			    0,    0,  112,  109,    0,  109,    0,  109,  109,  109,
			    0,    0,  109,  113,  109,  111,  113,    0,  109,    0,

			  109,    0,    0,  109,  109,  109,  109,  109,  109,  110,
			  114,    0,    0,  114,  110,  110,  110,  110,  110,  110,
			  110,    0,    0,  115,    0,    0,  115,  111,  112,  408,
			  408,  408,  111,  111,  111,  111,  111,  111,  111,  383,
			  116,  383,  113,  116,  383,  383,  383,  383,    0,    0,
			  109,  109,  109,  109,  109,  109,  109,    0,  120,  114,
			  112,  120,  409,  409,  409,  112,  112,  112,  112,  112,
			  112,  112,  115,  117,  113,    0,  117,    0,  113,  113,
			  113,  113,  113,  113,  113,  113,    0,  118,    0,  116,
			  118,  114,    0,  114,  114,  114,  114,  114,  114,  114,

			  114,  114,  114,    0,  115,  121,  115,  115,  121,  115,
			  115,  115,  115,  115,  115,  115,  122,    0,    0,  122,
			    0,  116,  117,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,    0,  123,    0,  118,  123,  410,  410,
			  410,  389,  389,  389,  120,  120,  120,  120,  120,  120,
			  120,    0,  124,    0,  117,  124,  117,  117,  117,  117,
			  117,  117,  117,  117,  117,  117,  125,    0,  118,  125,
			  118,    0,    0,  118,  118,  118,  118,  118,  118,  118,
			  126,  389,    0,  126,  276,  276,  276,  276,  276,  276,
			  276,  121,  121,  121,  121,  121,  121,  121,  128,    0,

			    0,  122,  122,  122,  122,  122,  122,  122,  122,  127,
			    0,    0,  127,  411,  411,  411,    0,  123,  123,  123,
			  123,  123,  123,  123,  123,  123,  123,  277,  277,  277,
			  277,  277,  277,  277,    0,  124,  124,    0,  124,  124,
			  124,  124,  124,  124,  124,  412,  412,  412,    0,  125,
			  125,  125,  125,  125,  125,  125,  125,  125,  125,  520,
			  520,  520,    0,  126,  126,  126,  126,  126,  126,  126,
			  126,  126,  126,  131,  521,  521,  521,  522,  522,  522,
			  128,  128,  128,  128,  128,  128,  128,  132,  523,  523,
			  523,    0,  127,    0,    0,  127,  127,  127,  127,  127,

			  127,  127,  130,    0,    0,  130,  130,  130,  130,  524,
			  524,  524,    0,    0,  130,    0,  133,  525,  525,  525,
			    0,  130,    0,  130,    0,  130,  130,  130,  130,  134,
			  130,  159,  130,    0,    0,  159,  130,    0,  130,  135,
			    0,  130,  130,  130,  130,  130,  130,    0,  159,  136,
			    0,    0,  131,  131,  131,  131,  131,  131,  131,  131,
			  131,  131,  137,  159,  526,  526,  526,  159,  132,  132,
			  132,  132,  132,  132,  132,  132,    0,    0,  280,  280,
			  159,  280,  280,  280,  280,  280,  280,  280,  130,  130,
			  130,  130,  130,  130,  130,  133,  133,  133,  133,  133,

			  133,  133,  133,  133,  133,  527,  527,  527,  134,  134,
			    0,  134,  134,  134,  134,  134,  134,  134,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  135,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,    0,    0,
			  165,  137,  165,    0,  137,  137,  137,  137,  137,  137,
			  137,  145,  165,  145,  145,  145,  145,    0,    0,  284,
			    0,  284,  284,    0,  145,  603,  603,  603,  603,  160,
			    0,    0,  165,  160,  165,  278,  278,  278,  278,  278,
			  278,  278,  278,    0,  165,    0,  160,  162,    0,    0,
			  162,  162,    0,  145,    0,    0,  145,  150,  150,  150,

			  150,  160,    0,    0,  162,  160,    0,  150,  150,  150,
			  150,  150,  150,  161,    0,  284,  163,  161,  160,  162,
			  163,  161,  162,  162,  161,  285,    0,  285,  285,    0,
			  161,    0,    0,  163,  163,    0,  162,  150,    0,  150,
			  150,  150,  150,  150,  150,  161,  284,    0,  163,  161,
			  164,  166,  163,  161,  164,    0,  161,    0,  166,    0,
			  166,    0,  161,    0,    0,  163,  163,  164,  168,  164,
			  166,    0,  167,    0,    0,  167,  168,  167,  168,    0,
			    0,  285,  164,  166,    0,    0,  164,  167,  168,    0,
			  166,  169,  166,  169,  605,  605,  605,  605,  169,  164,

			  168,  164,  166,  169,  167,    0,    0,  167,  168,  167,
			  168,  180,  285,    0,  170,  180,  170,  178,    0,  167,
			  168,  178,  170,  169,    0,  169,  170,    0,  180,  179,
			  169,  179,    0,    0,  178,  169,  178,  179,  181,    0,
			  183,  179,  181,  180,  183,    0,  170,  180,  170,  178,
			  629,  629,  629,  178,  170,  181,    0,  183,  170,    0,
			  180,  179,    0,  179,    0,    0,  178,  182,  178,  179,
			  181,  182,  183,  179,  181,  184,  183,    0,    0,  184,
			  182,  185,  186,    0,  182,    0,    0,  181,  185,  183,
			  185,    0,  184,  186,  187,  186,  187,    0,    0,  182,

			  185,    0,    0,  182,  191,  186,  187,  184,  191,    0,
			  188,  184,  182,  185,  186,    0,  182,  188,    0,  188,
			  185,  191,  185,    0,  184,  186,  187,  186,  187,  188,
			    0,    0,  185,  189,    0,  189,  191,  186,  187,  189,
			  191,    0,  188,  190,  190,  189,  192,  190,  190,  188,
			  192,  188,  193,  191,  193,  194,  192,    0,  192,  194,
			  190,  188,    0,    0,  193,  189,    0,  189,  192,    0,
			    0,  189,  194,  194,    0,  190,  190,  189,  192,  190,
			  190,    0,  192,    0,  193,    0,  193,  194,  192,    0,
			  192,  194,  190,    0,  195,    0,  193,  195,  195,  196,

			  192,    0,  201,  196,  194,  194,  201,    0,  197,    0,
			  197,  195,  195,  198,  196,  197,  196,    0,  196,  201,
			  197,  198,    0,  198,    0,    0,  195,    0,  198,  195,
			  195,  196,    0,  198,  201,  196,    0,  203,  201,  203,
			  197,    0,  197,  195,  195,  198,  196,  197,  196,  203,
			  196,  201,  197,  198,  199,  198,  199,  200,  199,  202,
			  198,  200,  199,  202,  204,  198,  199,    0,  200,  203,
			    0,  203,    0,  202,  200,  204,  202,  204,    0,    0,
			  205,  203,  205,  205,    0,    0,  199,  204,  199,  200,
			  199,  202,  205,  200,  199,  202,  204,    0,  199,  206, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_chk_template_3 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  200,    0,    0,  206,    0,  202,  200,  204,  202,  204,
			    0,    0,  205,  207,  205,  205,  206,  207,    0,  204,
			    0,    0,  209,  208,  205,  208,  209,  208,  207,    0,
			  207,  206,  208,  208,  210,  206,  210,    0,  208,  209,
			  211,  208,  211,    0,  211,  207,  210,    0,  206,  207,
			    0,    0,  211,    0,  209,  208,    0,  208,  209,  208,
			  207,    0,  207,    0,  208,  208,  210,  213,  210,  213,
			  208,  209,  211,  208,  211,  607,  211,  607,  210,  213,
			  607,  607,  607,  607,  211,  212,    0,  212,    0,  212,
			    0,    0,  214,  212,    0,  212,  214,    0,    0,  213,

			  212,  213,  214,  212,    0,  212,  215,    0,  215,  214,
			  215,  213,    0,  216,  216,    0,  216,  212,    0,  212,
			  215,  212,    0,  215,  214,  212,  216,  212,  214,  630,
			  630,  630,  212,    0,  214,  212,    0,  212,  215,    0,
			  215,  214,  215,    0,    0,  216,  216,    0,  216,    0,
			  217,    0,  215,  218,    0,  215,  218,  218,  216,  217,
			    0,  217,  217,    0,  219,    0,    0,  221,    0,  221,
			  218,  217,  219,  220,  219,  221,    0,  220,    0,  221,
			    0,    0,  217,  223,  219,  218,  223,  223,  218,  218,
			  220,  217,  220,  217,  217,    0,  219,    0,    0,  221,

			  223,  221,  218,  217,  219,  220,  219,  221,  222,  220,
			    0,  221,  222,  225,    0,  223,  219,  225,  223,  223,
			    0,    0,  220,    0,  220,  222,  222,    0,  227,  224,
			  225,  224,  223,  224,    0,  226,  227,  226,  227,  229,
			  222,  229,  226,  228,  222,  225,  224,  226,  227,  225,
			    0,  229,  228,    0,  228,  230,    0,  222,  222,  230,
			  227,  224,  225,  224,  228,  224,    0,  226,  227,  226,
			  227,  229,  230,  229,  226,  228,    0,    0,  224,  226,
			  227,  231,    0,  229,  228,    0,  228,  230,  231,    0,
			  231,  230,  232,    0,  232,  234,  228,    0,    0,  234,

			  231,  232,  232,    0,  230,  232,  234,  232,  232,    0,
			  234,    0,  234,  231,  608,  608,  608,  608,    0,    0,
			  231,    0,  231,    0,  232,    0,  232,  234,  615,  615,
			  615,  234,  231,  232,  232,    0,    0,  232,  234,  232,
			  232,  233,  234,  233,  234,    0,  235,    0,    0,  233,
			  235,  233,    0,  237,  233,  237,  233,  233,  236,  237,
			  236,  233,  236,  235,    0,  237,    0,  238,  615,    0,
			  236,  238,    0,  233,    0,  233,    0,  292,  235,  292,
			  292,  233,  235,  233,  238,  237,  233,  237,  233,  233,
			  236,  237,  236,  233,  236,  235,    0,  237,    0,  238,

			  239,    0,  236,  238,  239,  240,  241,    0,  241,    0,
			    0,  396,  240,  396,  240,  241,  238,  239,  241,    0,
			  239,    0,  242,  396,  240,  242,  242,  731,  731,  731,
			  242,  243,  239,  292,    0,  243,  239,  240,  241,  242,
			  241,  242,    0,  396,  240,  396,  240,  241,  243,  239,
			  241,    0,  239,    0,  242,  396,  240,  242,  242,  245,
			    0,    0,  242,  243,  292,    0,  245,  243,  245,  244,
			    0,  242,    0,  242,  244,    0,    0,  244,  245,  244,
			  243,  248,  246,  248,    0,  244,  246,  248,  247,  244,
			  250,  245,  247,  248,  250,    0,  247,    0,  245,  246,

			  245,  244,  732,  732,  732,  247,  244,  250,  255,  244,
			  245,  244,    0,  248,  246,  248,  256,  244,  246,  248,
			  247,  244,  250,    0,  247,  248,  250,  249,  247,  251,
			  249,  246,  249,  257,    0,    0,  251,  247,  251,  250,
			  252,  253,  249,  253,  252,  258,    0,  253,  251,  609,
			  609,  609,  609,  253,    0,  259,    0,  252,    0,  249,
			    0,  251,  249,    0,  249,  260,    0,    0,  251,    0,
			  251,    0,  252,  253,  249,  253,  252,  261,    0,  253,
			  251,  757,  757,  757,  757,  253,    0,  262,    0,  252,
			  255,  255,  255,  255,  255,  255,  255,    0,  256,  256,

			  256,  256,  256,  256,  256,  293,  293,  293,  293,  293,
			  293,  293,    0,    0,  257,  257,  257,  257,  257,  257,
			  257,  257,    0,    0,  258,  258,  258,  258,  258,  258,
			  258,  258,  258,  258,  259,  259,  286,  259,  259,  259,
			  259,  259,  259,  259,  260,  260,  260,  260,  260,  260,
			  260,  260,  260,  260,  287,    0,  261,  261,  261,  261,
			  261,  261,  261,  261,  261,  261,  262,    0,    0,  262,
			  262,  262,  262,  262,  262,  262,  279,  279,  279,  279,
			  279,  279,  279,  279,  279,  279,  281,  281,  281,  281,
			  281,  281,  281,  281,  281,  281,  282,  282,  282,  282,

			  282,  282,  282,  282,  282,  282,  283,    0,    0,  283,
			  283,  283,  283,  283,  283,  283,  289,    0,  289,  289,
			    0,    0,  286,  286,  286,  286,  286,  286,  286,  290,
			    0,    0,  290,    0,  290,    0,    0,  290,    0,    0,
			  287,  287,  287,  287,  287,  287,  287,  291,    0,    0,
			  291,    0,  291,    0,  294,  291,    0,  294,    0,  294,
			    0,    0,  294,  295,    0,    0,  295,    0,  295,    0,
			  397,  295,  289,  296,  397,    0,  296,    0,  296,    0,
			    0,  296,    0,  297,    0,    0,  297,  397,  297,    0,
			    0,  297,    0,  298,    0,    0,  298,    0,  298,    0,

			    0,  298,  397,  289,    0,    0,  397,  289,  289,  289,
			  289,  289,  289,  289,  758,  758,  758,  758,    0,  397,
			  290,  290,  290,  290,  290,  290,  290,  299,    0,    0,
			  299,    0,  299,    0,    0,  299,    0,    0,  291,  291,
			  291,  291,  291,  291,  291,  294,  294,  294,  294,  294,
			  294,  294,    0,  295,  295,  295,  295,  295,  295,  295,
			  295,  296,  296,  296,  296,  296,  296,  296,  296,  296,
			  296,  297,  297,    0,  297,  297,  297,  297,  297,  297,
			  297,  298,  298,  298,  298,  298,  298,  298,  298,  298,
			  298,  300,    0,    0,  300,    0,  300,    0,    0,  300,

			  301,  301,  301,  301,  301,  301,  301,  309,  309,  309,
			  309,  309,  309,  309,    0,  299,  299,  299,  299,  299,
			  299,  299,  299,  299,  299,  302,    0,    0,  302,    0,
			  302,    0,    0,  302,  303,    0,  400,  303,  400,  303,
			    0,    0,  303,    0,  304,    0,    0,  304,  400,  304,
			    0,    0,  304,    0,  305,    0,    0,  305,    0,  305,
			    0,    0,  305,    0,  306,    0,    0,  306,  400,  306,
			  400,    0,  306,  385,    0,  385,  385,  385,  385,  300,
			  400,    0,  300,  300,  300,  300,  300,  300,  300,  307,
			    0,    0,  307,    0,  307,    0,    0,  307,    0,  308, yy_Dummy>>,
			1, 1000, 2000)
		end

	yy_chk_template_4 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    0,  308,    0,  308,    0,    0,  308,  310,  310,
			  310,  310,  310,  310,  310,  385,  302,  302,  302,  302,
			  302,  302,  302,    0,  303,  303,  303,  303,  303,  303,
			  303,  303,  304,  304,  304,  304,  304,  304,  304,  304,
			  304,  304,  305,  305,    0,  305,  305,  305,  305,  305,
			  305,  305,  306,  306,  306,  306,  306,  306,  306,  306,
			  306,  306,  311,  311,  311,  311,  311,  311,  311,  312,
			  312,  312,  312,  312,  312,  312,    0,  307,  307,  307,
			  307,  307,  307,  307,  307,  307,  307,  308,    0,    0,
			  308,  308,  308,  308,  308,  308,  308,  313,  313,  313,

			  313,  313,  313,  313,  313,  313,  313,  314,  314,  314,
			  314,  314,  314,  314,  314,  314,  314,  315,    0,    0,
			  315,    0,    0,    0,  316,    0,    0,  316,    0,    0,
			    0,  317,  398,  395,  317,    0,  398,  395,  318,  401,
			    0,  318,    0,  401,    0,  319,  395,    0,  319,  398,
			  395,  318,  318,  318,  318,  320,  401,  384,  320,  384,
			  384,  384,  384,  321,  398,  395,  321,    0,  398,  395,
			  384,  401,    0,  322,    0,  401,  322,    0,  395,    0,
			    0,  398,  395,  323,    0,    0,  323,    0,  401,  760,
			  760,  760,  760,  324,    0,    0,  324,    0,    0,  384,

			    0,    0,  384,  315,  315,  315,  315,  315,  315,  315,
			  316,  316,  316,  316,  316,  316,  316,  317,  317,  317,
			  317,  317,  317,  317,  318,  318,  318,  318,  318,  318,
			  318,  319,  319,  319,  319,  319,  319,  319,    0,    0,
			    0,  320,  320,  320,  320,  320,  320,  320,  321,  321,
			  321,  321,  321,  321,  321,  321,  322,  322,  322,  322,
			  322,  322,  322,  322,  322,  322,  323,  323,    0,  323,
			  323,  323,  323,  323,  323,  323,  324,  324,  324,  324,
			  324,  324,  324,  324,  324,  324,  325,    0,    0,  325,
			  378,  378,  378,  378,    0,    0,  326,    0,    0,  326,

			    0,    0,    0,  327,  378,  327,  327,  402,  327,  402,
			    0,  327,    0,  382,  382,  382,  382,    0,  393,  402,
			  393,  393,  393,  393,    0,    0,  328,  382,  328,  328,
			  378,  328,    0,    0,  328,    0,  378,    0,    0,  402,
			    0,  402,    0,  329,    0,    0,  329,  762,  762,  762,
			  762,  402,    0,  382,    0,  330,    0,  327,  330,  382,
			  393,  394,    0,  394,  394,  394,  394,    0,    0,  325,
			  325,  325,  325,  325,  325,  325,  325,  325,  325,  326,
			  328,    0,  326,  326,  326,  326,  326,  326,  326,  327,
			  331,    0,  329,  331,  327,  327,  327,  327,  327,  327,

			  327,    0,  332,  394,  330,  332,  764,  764,  764,  764,
			  335,    0,  328,  335,    0,    0,    0,  328,  328,  328,
			  328,  328,  328,  328,  329,  333,    0,    0,  333,  329,
			  329,  329,  329,  329,  329,  329,  330,  334,    0,  331,
			  334,  330,  330,  330,  330,  330,  330,  330,    0,  336,
			    0,  332,  336,    0,    0,    0,  337,    0,    0,  337,
			    0,    0,  861,  338,  861,    0,  338,  861,  861,  861,
			  861,  331,    0,    0,  333,  341,  331,  331,  331,  331,
			  331,  331,  331,  332,  339,    0,  334,  339,  332,  332,
			  332,  332,  332,  332,  332,  343,  335,  335,  335,  335,

			  335,  335,  335,    0,  340,    0,  333,  340,  333,  333,
			  333,  333,  333,  333,  333,  333,  333,  333,  334,  344,
			  334,  334,  334,  334,  334,  334,  334,  334,  334,  334,
			  345,  863,  863,  863,  863,  336,  336,  336,  336,  336,
			  336,  336,  337,  337,  337,  337,  337,  337,  337,  338,
			  338,  338,  338,  338,  338,  338,  346,  341,  341,  341,
			  341,  341,  341,  341,    0,    0,  347,  339,  339,  339,
			  339,  339,  339,  339,  339,  339,  339,  343,  343,  343,
			  343,  343,  343,  343,  348,    0,    0,  340,  340,  340,
			  340,  340,  340,  340,  340,  340,  340,  349,    0,    0,

			  344,  344,  344,  344,  344,  344,  344,  344,  350,  345,
			  345,  345,  345,  345,  345,  345,  345,  345,  345,  351,
			  604,  604,  604,  604,    0,    0,  353,  867,  867,  867,
			  867,    0,    0,  354,    0,  346,  346,    0,  346,  346,
			  346,  346,  346,  346,  346,  347,  347,  347,  347,  347,
			  347,  347,  347,  347,  347,  356,  868,  868,  868,  868,
			  604,    0,  357,  348,  348,  348,  348,  348,  348,  348,
			  348,  348,  348,    0,    0,    0,  349,  355,    0,  349,
			  349,  349,  349,  349,  349,  349,  355,  355,  355,  355,
			  350,  350,  350,  350,  350,  350,  350,  358,    0,    0,

			    0,  351,  351,  351,  351,  351,  351,  351,  353,  353,
			  353,  353,  353,  353,  353,  354,  354,  354,  354,  354,
			  354,  354,  359,  414,    0,  414,    0,    0,    0,  360,
			  610,  610,  610,  610,    0,  414,  361,  356,  356,  356,
			  356,  356,  356,  356,  357,  357,  357,  357,  357,  357,
			  357,  362,    0,    0,    0,  414,    0,  414,  363,  355,
			  355,  355,  355,  355,  355,  355,  364,  414,    0,    0,
			  610,    0,    0,  365,  870,  870,  870,  870,    0,  358,
			  358,  358,  358,  358,  358,  358,  366,  612,    0,  612,
			  612,  612,  612,  367,  941,  941,  941,  941,    0,    0,

			  368,    0,    0,    0,  359,  359,  359,  359,  359,  359,
			  359,  360,  360,  360,  360,  360,  360,  360,  361,  361,
			  361,  361,  361,  361,  361,  369,    0,    0,    0,  612,
			    0,    0,  370,  362,  362,  362,  362,  362,  362,  362,
			  363,  363,  363,  363,  363,  363,  363,  371,  364,  364,
			  364,  364,  364,  364,  364,  365,  365,  365,  365,  365,
			  365,  365,  372,    0,    0,    0,  529,    0,  366,  366,
			  366,  366,  366,  366,  366,  367,  367,  367,  367,  367,
			  367,  367,  368,  368,  368,  368,  368,  368,  368,  373,
			  404,    0,    0,  404,  433,  404,  433,    0,    0,  374,

			    0,    0,    0,  530,    0,  404,  433,  369,  369,  369,
			  369,  369,  369,  369,  370,  370,  370,  370,  370,  370,
			  370,  375,  404,    0,    0,  404,  433,  404,  433,  371,
			  371,  371,  371,  371,  371,  371,  376,  404,  433,    0,
			    0,  372,  372,  372,  372,  372,  372,  372,  372,  372,
			  372,  377,  529,  529,  529,  529,  529,  529,  529,  556,
			  556,  556,  556,  556,  556,  556,    0,    0,  373,  373,
			  373,  373,  373,  373,  373,  373,  373,  373,  374,  374,
			  374,  374,  374,  374,  374,  374,  374,  374,  530,  530,
			  530,  530,  530,  530,  530,  530,  942,  942,  942,  942, yy_Dummy>>,
			1, 1000, 3000)
		end

	yy_chk_template_5 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  375,  375,  375,  375,  375,  375,  375,  375,  375,  375,
			  943,  943,  943,  943,    0,  376,  376,  376,  376,  376,
			  376,  376,  376,  376,  376,  947,  947,  947,  947,    0,
			  377,  377,  377,  377,  377,  377,  377,  377,  377,  377,
			  391,  391,  391,  391,    0,  399,  949,  949,  949,  949,
			  391,  391,  391,  391,  391,  391,  399,  403,  399,  405,
			  406,  403,  406,  405,    0,  403,  406,    0,  399,    0,
			    0,    0,  406,    0,  403,    0,  405,  399,    0,    0,
			  391,    0,  391,  391,  391,  391,  391,  391,  399,  403,
			  399,  405,  406,  403,  406,  405,    0,  403,  406,  413,

			  399,    0,  416,  413,  406,  415,  403,  415,  405,  415,
			  417,  416,    0,  416,  417,    0,  413,  418,    0,  418,
			    0,    0,  415,  416,  418,    0,    0,  417,  417,  418,
			    0,  413,    0,    0,  416,  413,  419,  415,    0,  415,
			  419,  415,  417,  416,    0,  416,  417,    0,  413,  418,
			    0,  418,    0,  419,  415,  416,  418,  419,  422,  417,
			  417,  418,  421,  420,    0,  420,  421,    0,  419,  422,
			  423,  422,  419,  420,  423,  420,  424,    0,  424,  421,
			    0,  422,  424,    0,    0,  419,    0,  423,  424,  419,
			  422,    0,  425,    0,  421,  420,  425,  420,  421,    0,

			  426,  422,  423,  422,  426,  420,  423,  420,  424,  425,
			  424,  421,  425,  422,  424,    0,    0,  426,  428,  423,
			  424,  427,  429,  427,  425,  428,  429,  428,  425,    0,
			  427,    0,  426,  427,    0,    0,  426,  428,    0,  429,
			    0,  425,    0,  431,  425,    0,    0,  431,    0,  426,
			  428,    0,    0,  427,  429,  427,    0,  428,  429,  428,
			  431,  430,  427,    0,  434,  427,  434,    0,  430,  428,
			  430,  429,    0,  434,  432,  431,  434,    0,  432,  431,
			  430,  602,  602,  602,  602,    0,  436,    0,    0,    0,
			  436,  432,  431,  430,  432,  602,  434,  435,  434,    0,

			  430,  435,  430,  436,    0,  434,  432,  442,  434,  442,
			  432,  435,  430,    0,  435,  442,    0,  437,  436,  442,
			  439,  602,  436,  432,  439,  438,  432,  602,  437,  435,
			  437,  437,  438,  435,  438,  436,    0,  439,  439,  442,
			  437,  442,    0,  435,  438,    0,  435,  442,    0,  437,
			    0,  442,  439,    0,    0,    0,  439,  438,    0,    0,
			  437,    0,  437,  437,  438,    0,  438,    0,    0,  439,
			  439,  440,  437,  440,    0,  441,  438,    0,  440,  441,
			  445,  443,    0,  440,  445,  443,    0,  444,  444,  444,
			    0,  445,  441,  443,  441,    0,    0,  445,  443,  444,

			    0,  444,  446,  440,  446,  440,  443,  441,    0,    0,
			  440,  441,  445,  443,  446,  440,  445,  443,  447,  444,
			  444,  444,  447,  445,  441,  443,  441,    0,  449,  445,
			  443,  444,  449,  444,  446,  447,  446,    0,  443,  448,
			  450,    0,  452,  448,  450,  449,  446,  448,  451,  452,
			  447,  452,  451,    0,  447,  450,  448,  450,    0,    0,
			  449,  452,    0,  453,  449,  451,  453,  447,  453,    0,
			    0,  448,  450,    0,  452,  448,  450,  449,  453,  448,
			  451,  452,    0,  452,  451,  454,    0,  450,  448,  450,
			    0,    0,  454,  452,  454,  453,  456,  451,  453,  455,

			  453,  455,    0,  455,  454,    0,    0,  456,  457,  456,
			  453,  455,  457,  458,    0,    0,    0,  454,    0,  456,
			  458,    0,  458,    0,  454,  457,  454,    0,  456,    0,
			  459,  455,  458,  455,  459,  455,  454,  461,  460,  456,
			  457,  456,  460,  455,  457,  458,    0,  459,  461,    0,
			  461,  456,  458,  460,  458,  460,    0,  457,    0,  462,
			  461,  462,  459,  462,  458,    0,  459,    0,    0,  461,
			  460,  462,  465,  463,  460,    0,  465,  463,    0,  459,
			  461,  463,  461,  464,    0,  460,  464,  460,  464,  465,
			  463,  462,  461,  462,    0,  462,    0,    0,  464,    0,

			  470,    0,  470,  462,  465,  463,    0,  466,  465,  463,
			    0,    0,  470,  463,  466,  464,  466,    0,  464,  467,
			  464,  465,  463,  467,    0,  468,  466,  468,  468,    0,
			  464,    0,  470,  467,  470,    0,  467,  468,    0,  466,
			  950,  950,  950,  950,  470,  469,  466,    0,  466,  469,
			  471,  467,    0,    0,  471,  467,    0,  468,  466,  468,
			  468,    0,  469,    0,  472,  467,    0,  471,  467,  468,
			  473,  472,  473,  472,  473,  473,  475,  469,    0,    0,
			  475,  469,  471,  472,  476,    0,  471,  473,  476,  474,
			    0,    0,  474,  475,  469,    0,  472,    0,  474,  471,

			  474,  476,  473,  472,  473,  472,  473,  473,  475,  477,
			  474,    0,  475,  477,  478,  472,  476,    0,  478,  473,
			  476,  474,    0,    0,  474,  475,  477,    0,    0,    0,
			  474,  478,  474,  476,  478,  479,  480,  479,    0,  479,
			  480,  477,  474,    0,    0,  477,  478,    0,    0,    0,
			  478,  483,  479,  480,    0,  479,    0,    0,  477,    0,
			    0,  487,  483,  478,  483,  487,  478,  479,  480,  479,
			  481,  479,  480,  482,  483,    0,    0,  481,  487,  481,
			  482,    0,  482,  483,  479,  480,  484,  479,  484,  481,
			    0,    0,  482,  487,  483,  484,  483,  487,  484,  488,

			    0,    0,  481,  488,  485,  482,  483,    0,    0,  481,
			  487,  481,  482,  485,  482,  485,  488,  486,  484,  486,
			  484,  481,  485,  486,  482,  485,    0,  484,    0,  486,
			  484,  488,    0,  489,    0,  488,  485,    0,    0,    0,
			  489,    0,  489,    0,    0,  485,    0,  485,  488,  486,
			    0,  486,  489,  490,  485,  486,  493,  485,    0,    0,
			  493,  486,    0,  491,  490,  489,  490,  491,    0,  493,
			    0,  491,  489,  493,  489,  494,  490,  494,  492,    0,
			  491,  492,    0,  492,  489,  490,    0,  494,  493,    0,
			    0,    0,  493,  492,    0,  491,  490,    0,  490,  491,

			  495,  493,    0,  491,  495,  493,    0,  494,  490,  494,
			  492,  496,  491,  492,  500,  492,    0,  495,  496,  494,
			  496,  500,  497,  500,  498,  492,  497,  499,  498,    0,
			  496,  499,  495,  500,    0,  499,  495,    0,    0,  497,
			  498,  498,    0,  496,  499,    0,  500,    0,    0,  495,
			  496,    0,  496,  500,  497,  500,  498,    0,  497,  499,
			  498,    0,  496,  499,    0,  500,    0,  499,    0,    0,
			    0,  497,  498,  498,    0,  501,  499,  501,  502,    0,
			  501,  502,  503,  502,    0,    0,  503,  501,  504,    0,
			  504,    0,    0,  502,  505,    0,    0,    0,  505,  503, yy_Dummy>>,
			1, 1000, 4000)
		end

	yy_chk_template_6 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  504,  506,  505,    0,  506,    0,  506,  501,    0,  501,
			  502,  505,  501,  502,  503,  502,  506,  514,  503,  501,
			  504,    0,  504,  535,  507,  502,  505,  507,  507,  508,
			  505,  503,  504,  506,  505,  515,  506,  508,  506,  508,
			  509,  507,  516,  505,  509,    0,    0,  511,  506,  508,
			  510,  511,  510,  509,  517,    0,  507,  509,    0,  507,
			  507,  508,  510,  512,  511,  512,  518,    0,    0,  508,
			    0,  508,  509,  507,    0,  512,  509,  519,    0,  511,
			    0,  508,  510,  511,  510,  509,  531,    0,    0,  509,
			  951,  951,  951,  951,  510,  512,  511,  512,  532,  514,

			  514,  514,  514,  514,  514,  514,  535,  512,  533,  535,
			  535,  535,  535,  535,  535,  535,  537,  515,  515,  515,
			  515,  515,  515,  515,  516,  516,  516,  516,  516,  516,
			  516,  534,  998,  998,  998,  998,  517,  517,  517,  517,
			  517,  517,  517,  538,    0,  518,  518,  518,  518,  518,
			  518,  518,  518,  518,  518,  539,  519,  519,  519,  519,
			  519,  519,  519,  519,  519,  519,  540,    0,    0,  531,
			  531,  531,  531,  531,  531,  531,  531,  531,  531,  541,
			    0,  532,  532,    0,  532,  532,  532,  532,  532,  532,
			  532,  533,  533,  533,  533,  533,  533,  533,  533,  533,

			  533,  542,  537,  537,  537,  537,  537,  537,  537,    0,
			    0,  543,    0,    0,  534,  534,  534,  534,  534,  534,
			  534,  534,  534,  534, 1000, 1000, 1000, 1000,  538,  538,
			  538,  538,  538,  538,  538,  538,    0,    0,  539,  539,
			  539,  539,  539,  539,  539,  539,  539,  539,    0,  540,
			  540,    0,  540,  540,  540,  540,  540,  540,  540,    0,
			    0,    0,  541,  541,  541,  541,  541,  541,  541,  541,
			  541,  541,  544,    0,    0,  544,    0,  544,    0,    0,
			  544,    0,    0,    0,  542,  542,  542,  542,  542,  542,
			  542,  542,  542,  542,  543,    0,    0,  543,  543,  543,

			  543,  543,  543,  543,  545,    0,    0,  545,    0,  545,
			    0,  546,  545,    0,  546,  624,  546,  624,  547,  546,
			    0,  547,  624,  547,    0,    0,  547,  624,  548,    0,
			    0,  548,    0,  548,    0,    0,  548,    0,  549,    0,
			    0,  549,    0,  549,    0,  550,  549,  624,  550,  624,
			  550,    0,  551,  550,  624,  551,    0,  551,    0,  624,
			  551,    0,    0,  544,  544,  544,  544,  544,  544,  544,
			  552,    0,    0,  552,    0,  552,    0,  553,  552,    0,
			  553,    0,  553,    0,    0,  553,  557,  557,  557,  557,
			  557,  557,  557,    0,    0,  545,  545,  545,  545,  545,

			  545,  545,  546,  546,  546,  546,  546,  546,  546,  547,
			  547,  547,  547,  547,  547,  547,  548,  548,  548,  548,
			  548,  548,  548,  548,  548,  548,  549,  549,  549,  549,
			  549,  549,  549,  549,  549,  549,  550,  550,  550,  550,
			  550,  550,  550,  551,  551,  551,  551,  551,  551,  551,
			  554,    0,    0,  554,    0,  554,    0,    0,  554,    0,
			    0,  552,  552,  552,  552,  552,  552,  552,  553,  553,
			  553,  553,  553,  553,  553,  555,    0,    0,  555,    0,
			  555,    0,    0,  555,    0,    0,    0,  558,  631,    0,
			  558,    0,  631,    0,  559,    0,    0,  559,  631,    0,

			    0,  560,    0,    0,  560,  631,    0,    0,  561,    0,
			    0,  561,    0,  560,  560,  560,  560,  560,  562,    0,
			  631,  562,    0,    0,  631,  563,    0,    0,  563,    0,
			  631,    0,  564,    0,  561,  564,    0,  631,  554,  554,
			  554,  554,  554,  554,  554,  554,  554,  554,  565,    0,
			    0,  565, 1001, 1001, 1001, 1001,    0,    0,  566,    0,
			    0,  566,    0,  555,  555,  555,  555,  555,  555,  555,
			  555,  555,  555,  558,  558,  558,  558,  558,  558,  558,
			  559,  559,  559,  559,  559,  559,  559,  560,  560,  560,
			  560,  560,  560,  560,  561,  561,  561,  561,  561,  561,

			  561,    0,    0,    0,  562,  562,  562,  562,  562,  562,
			  562,  563,  563,  563,  563,  563,  563,  563,  564,  564,
			  564,  564,  564,  564,  564,  567,    0,    0,  567, 1002,
			 1002, 1002, 1002,    0,  565,  565,  565,  565,  565,  565,
			  565,  566,  566,  566,  566,  566,  566,  566,  566,  566,
			  566,  568,    0,    0,  568,    0,  606,  606,  606,  606,
			    0,  611,    0,  611,  611,  611,  611,    0,    0,  569,
			  606,    0,  569,    0,  611,    0,  570,    0,    0,  570,
			    0,    0,    0,  571,    0,  619,  571,  619,  619,  619,
			  619,    0,    0,    0,  572,    0,  606,    0,    0,    0,

			  568,  573,  606,  611,    0,    0,  611,  733,  567,  567,
			  567,  567,  567,  567,  567,  567,  567,  567,  569,  574,
			    0,    0,    0,  871,    0,  871,  575,  619,  871,  871,
			  871,  871,  568,    0,    0,    0,  576,  568,  568,  568,
			  568,  568,  568,  568,    0,    0,  577,    0,    0,  620,
			  569,  620,  620,  620,  620,  569,  569,  569,  569,  569,
			  569,  569,  570,  570,  570,  570,  570,  570,  570,  571,
			  571,  571,  571,  571,  571,  571,  572,  572,  572,  572,
			  572,  572,  572,  573,  573,  573,  573,  573,  573,  573,
			  600,  620,    0,  733,  733,  733,  733,  733,  733,  733,

			  601,  574,  574,  574,  574,  574,  574,  574,  575,  575,
			  575,  575,  575,  575,  575,  576,  576,  576,  576,  576,
			  576,  576,  576,  576,  576,  577,  577,  577,  577,  577,
			  577,  577,  577,  577,  577,  583, 1006, 1006, 1006, 1006,
			    0,    0,    0,  583,  583,  583,  583,  583,  755,  755,
			  755,  755,    0,  765,  765,  765,  765,  756,  756,  756,
			  756,    0,  755,  761,  761,  761,  761,  765,    0,  600,
			  600,  600,  600,  600,  600,  600,  600,  600,  600,  601,
			  601,  601,  601,  601,  601,  601,  601,  601,  601,    0,
			    0,    0,  621,  622,  755,  622,  621,  756,  623,  765,

			    0,  622,  623,  761,    0,  622,    0,    0,    0,  621,
			    0,  621,    0,    0,    0,  623,  623,  583,  583,  583,
			  583,  583,  583,  583,  621,  622,    0,  622,  621,    0,
			  623,    0,  625,  622,  623,  626,  625,  622,  625,    0,
			  626,  621,  626,  621,    0,    0,  627,  623,  623,  625,
			  627,    0,  626,    0,  627,    0,  628,    0,    0,  628,
			    0,  628,    0,  627,  625,    0,    0,  626,  625,    0,
			  625,  628,  626,  634,  626,  634,  632,  632,  627,  632,
			  634,  625,  627,  633,  626,  634,  627,  633,  628,  632,
			    0,  628,    0,  628,    0,  627, 1036, 1036, 1036, 1036, yy_Dummy>>,
			1, 1000, 5000)
		end

	yy_chk_template_7 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  633,  633,    0,  628,    0,  634,  635,  634,  632,  632,
			  635,  632,  634,    0,    0,  633,    0,  634,  636,  633,
			    0,  632,  637,  635,    0,  636,  637,  636,  638,    0,
			  638,  639,  633,  633,    0,  639,  638,  636,  635,  637,
			  638,  637,  635,    0,  642,    0,    0,    0,  639,  642,
			  636,  642,    0,    0,  637,  635,    0,  636,  637,  636,
			  638,  642,  638,  639,    0,    0,    0,  639,  638,  636,
			  640,  637,  638,  637,    0,    0,  642,  640,  641,  640,
			  639,  642,  641,  642,  641,  644,  643,  644,  645,  640,
			  643,  644,  645,  642,    0,  641,  645,  644,    0,    0,

			    0,    0,  640,  643,    0,  645,    0,    0,  647,  640,
			  641,  640,  647,    0,  641,    0,  641,  644,  643,  644,
			  645,  640,  643,  644,  645,  647,    0,  641,  645,  644,
			    0,  646,    0,    0,  646,  643,  646,  645,  650,  648,
			  647,  648,  650,  649,  647,  648,  646,  649,    0,    0,
			  651,  648,  651,    0,    0,  650,  649,  647,    0,    0,
			  649,    0,  651,  646,    0,    0,  646,    0,  646,    0,
			  650,  648,    0,  648,  650,  649,  653,  648,  646,  649,
			  653,  655,  651,  648,  651,  655,    0,  650,  649,  652,
			    0,  652,  649,  653,  651,  652,    0,  654,  655,  654,

			    0,  652,  657,  654,    0,    0,  657,  656,  653,  654,
			    0,  659,  653,  655,  656,  659,  656,  655,    0,  657,
			    0,  652,  657,  652,    0,  653,  656,  652,  659,  654,
			  655,  654,    0,  652,  657,  654,    0,    0,  657,  656,
			  658,  654,  658,  659,    0,    0,  656,  659,  656,  658,
			    0,  657,  658,  660,  657,    0,  662,  660,  656,  661,
			  659,  661,    0,  662,    0,  662,    0,    0,    0,  663,
			  660,  661,  658,  663,  658,  662,    0,  663,  666,    0,
			  666,  658,    0,  665,  658,  660,  663,  665,  662,  660,
			  666,  661,  668,  661,  668,  662,    0,  662,    0,    0,

			  665,  663,  660,  661,  668,  663,  665,  662,  664,  663,
			  666,  664,  666,  664,    0,  665,  667,  669,  663,  665,
			  667,  669,  666,  664,  668,  670,  668,  670,    0,    0,
			    0,  670,  665,  667,  669,  672,  668,  670,  665,  667,
			  664,    0,  672,  664,  672,  664,    0,  671,  667,  669,
			    0,  671,  667,  669,  672,  664,  673,  670,    0,  670,
			  673,    0,    0,  670,  671,  667,  669,  672,  675,  670,
			    0,  667,  675,  673,  672,  674,  672,  674,  676,  671,
			  676,  674,  678,  671,  678,  675,  672,  674,  673,  679,
			  676,  677,  673,  679,  678,  677,  671,    0,    0,  680,

			  675,  680,  677,    0,  675,  673,  679,  674,  677,  674,
			  676,  680,  676,  674,  678,    0,  678,  675,    0,  674,
			    0,  679,  676,  677,  681,  679,  678,  677,  681,  681,
			    0,  680,    0,  680,  677,  683,  682,    0,  679,  683,
			  677,  681,  682,  680,  682,  684,  686,  684,  686,    0,
			    0,  688,  683,  688,  682,  685,  681,  684,  686,  685,
			  681,  681,    0,  688,    0,  687,  685,  683,  682,  687,
			    0,  683,  685,  681,  682,    0,  682,  684,  686,  684,
			  686,    0,  687,  688,  683,  688,  682,  685,  689,  684,
			  686,  685,  689,    0,  704,  688,  704,  687,  685,  690,

			  691,  687,  691,  690,  685,  689,  704,  690,  689,  691,
			  692,    0,  691,  692,  687,  692,  690,    0,    0,    0,
			  689,    0,    0,    0,  689,  692,  704,    0,  704,    0,
			    0,  690,  691,    0,  691,  690,    0,  689,  704,  690,
			  689,  691,  692,    0,  691,  692,  693,  692,  690,  695,
			  693,  693,  694,  695,    0,    0,    0,  692,  694,  696,
			  694,  696,    0,  693,    0,  696,  695,    0,    0,  699,
			  694,  696,    0,  699,    0,    0,    0,  699,  693,    0,
			    0,  695,  693,  693,  694,  695,  699,  698,  698,  698,
			  694,  696,  694,  696,    0,  693,  697,  696,  695,  698,

			  697,  699,  694,  696,    0,  699,    0,  700,  697,  699,
			  700,    0,  700,  697,    0,    0,    0,    0,  699,  698,
			  698,  698,  700,    0,    0,    0,  701,    0,  697,    0,
			  701,  698,  697,    0,    0,    0,    0,    0,    0,  700,
			  697,    0,  700,  701,  700,  697,  701,    0,  702,    0,
			    0,  703,  702,  703,  700,    0,    0,  705,  701,  702,
			  703,  705,  701,  703,  706,  702,  706,    0,    0,  707,
			    0,  707,    0,  707,  705,  701,  706,  706,  701,  708,
			  702,  705,    0,  703,  702,  703,  707,    0,  708,  705,
			  708,  702,  703,  705,    0,  703,  706,  702,  706,    0,

			  708,  707,    0,  707,    0,  707,  705,    0,  706,  706,
			  709,  708,    0,  705,  709,    0,    0,  710,  707,  710,
			  708,  711,  708,  710,  713,  711,    0,  709,  713,  710,
			    0,  712,  708,  712,    0,  712,  711,    0,  711,    0,
			    0,  713,  709,  712,    0,    0,  709,    0,    0,  710,
			  714,  710,  714,  711,  715,  710,  713,  711,  715,  709,
			  713,  710,  714,  712,  716,  712,  716,  712,  711,    0,
			  711,  715,    0,  713,  717,  712,  716,  718,  717,  717,
			    0,    0,  714,  718,  714,  718,  715,    0,    0,    0,
			  715,  717,    0,    0,  714,  718,  716,    0,  716,    0,

			    0,  719,  722,  715,  722,  719,  717,    0,  716,  718,
			  717,  717,    0,    0,  722,  718,  734,  718,  719,    0,
			  720,  719,  720,  717,  721,    0,  723,  718,  721,  720,
			  723,    0,  720,  719,  722,  721,  722,  719,  729,    0,
			  725,  721,    0,  723,  725,    0,  722,  726,  730,  726,
			  719,  735,  720,  719,  720,  724,  721,  725,  723,  726,
			  721,  720,  723,  736,  720,  727,  724,  721,  724,  727,
			    0,    0,  725,  721,  737,  723,  725,    0,  724,  726,
			    0,  726,  727,  728,  738,  728,    0,  724,    0,  725,
			    0,  726,  739,    0,    0,  728,    0,  727,  724,  740,

			  724,  727,  734,  734,  734,  734,  734,  734,  734,  741,
			  724,    0,    0,    0,  727,  728,  742,  728,    0,    0,
			  729,  729,  729,  729,  729,  729,  729,  728,  743,    0,
			  730,  730,  730,  730,  730,  730,  730,  735,  735,  735,
			  735,  735,  735,  735,  744,    0,    0,    0,    0,  736,
			  736,  736,  736,  736,  736,  736,    0,  737,  737,  737,
			  737,  737,  737,  737,  737,  737,  737,  738,  738,  738,
			  738,  738,  738,  738,  738,  738,  738,    0,  739,  739,
			  739,  739,  739,  739,  739,  740,  740,  740,  740,  740,
			  740,  740,    0,    0,    0,  741,  741,  741,  741,  741, yy_Dummy>>,
			1, 1000, 6000)
		end

	yy_chk_template_8 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  741,  741,  742,  742,  742,  742,  742,  742,  742,  752,
			    0,  743,  743,  743,  743,  743,  743,  743,  743,  743,
			  743,  750,    0,    0,  750,    0,    0,  744,  744,  744,
			  744,  744,  744,  744,  744,  744,  744,  745,  753,    0,
			  745,    0,  745,    0,  746,  745,    0,  746,    0,  746,
			    0,  747,  746,    0,  747,  768,  747,  768,  748,  747,
			    0,  748,    0,  748,    0,    0,  748,  768,    0,    0,
			  749,    0,    0,  749,    0,    0,    0,  751,    0,    0,
			  751,    0,  749,  749,  749,  749,  749,  768,  754,  768,
			    0,  752,  752,  752,  752,  752,  752,  752,  944,  768,

			  944,    0,    0,  944,  944,  944,  944,  750,  750,  750,
			  750,  750,  750,  750,    0,    0,    0,    0,    0,    0,
			  753,  753,  753,  753,  753,  753,  753,    0,  745,  745,
			  745,  745,  745,  745,  745,  746,  746,  746,  746,  746,
			  746,  746,  747,  747,  747,  747,  747,  747,  747,  748,
			  748,  748,  748,  748,  748,  748,  749,  749,  749,  749,
			  749,  749,  749,  751,  751,  751,  751,  751,  751,  751,
			  754,  754,  754,  754,  754,  754,  754,  759,  759,  759,
			  759,  763,  763,  763,  763,  766,    0,  766,  766,  766,
			  766,  759,  767,  769,    0,    0,  767,  769,    0,  770,

			    0,  770,  771,  773,  773,    0,  771,  773,    0,  767,
			  769,  770,    0,    0,  772,  771,  772,  759,    0,  771,
			  773,  763,    0,  759,  767,  769,  772,  766,  767,  769,
			    0,  770,    0,  770,  771,  773,  773,    0,  771,  773,
			    0,  767,  769,  770,  774,  775,  772,  771,  772,  775,
			    0,  771,  773,  776,  774,  776,  774,  777,  772,    0,
			    0,  777,  775,    0,    0,  776,  774,  778,    0,  778,
			    0,  784,    0,  784,  777,    0,  774,  775,  779,  778,
			    0,  775,  779,  784,    0,  776,  774,  776,  774,  777,
			  780,    0,  780,  777,  775,  779,  780,  776,  774,  778,

			  781,  778,  780,  784,  781,  784,  777,    0,  781,  785,
			  779,  778,  782,  785,  779,  784,  782,  781,  786,  782,
			  786,  782,  780,    0,  780,  783,  785,  779,  780,  783,
			  786,  782,  781,    0,  780,    0,  781,    0,  783,  787,
			  781,  785,  783,  787,  782,  785,    0,    0,  782,  781,
			  786,  782,  786,  782,    0,    0,  787,  783,  785,    0,
			  789,  783,  786,  782,  789,  789,  788,    0,  788,    0,
			  783,  787,  788,  790,  783,  787,  791,  789,  788,  790,
			  791,  790,    0,    0,    0,    0,  793,    0,  787,  793,
			  793,  790,  789,  791,    0,    0,  789,  789,  788,    0,

			  788,    0,    0,  793,  788,  790,    0,  792,  791,  789,
			  788,  790,  791,  790,  792,  795,  792,    0,  793,  795,
			  794,  793,  793,  790,    0,  791,  792,    0,  794,  796,
			  794,  796,  795,    0,  795,  793,    0,  796,    0,  792,
			  794,  796,  798,  800,  798,  800,  792,  795,  792,    0,
			    0,  795,  794,  799,  798,  800,    0,  799,  792,    0,
			  794,  796,  794,  796,  795,    0,  795,  797,    0,  796,
			  799,  797,  794,  796,  798,  800,  798,  800,  801,  803,
			  797,    0,  801,  803,  797,  799,  798,  800,  802,  799,
			  802,    0,  803,    0,  802,  801,  803,    0,    0,  797,

			  802,    0,  799,  797,  805,  804,    0,  804,  805,    0,
			  801,  803,  797,    0,  801,  803,  797,  804,    0,    0,
			  802,  805,  802,    0,  803,    0,  802,  801,  803,  810,
			  807,  810,  802,    0,  807,  806,  805,  804,  807,  804,
			  805,  810,  806,  808,  806,    0,  808,  807,  808,  804,
			    0,  809,  811,  805,  806,  809,  811,    0,  808,    0,
			  811,  810,  807,  810,    0,    0,  807,  806,  809,  811,
			  807,    0,    0,  810,  806,  808,  806,    0,  808,  807,
			  808,    0,    0,  809,  811,    0,  806,  809,  811,    0,
			  808,  812,  811,  813,  812,  813,  812,  813,  814,  817,

			  809,  811,    0,  817,  815,    0,  812,  814,  815,  814,
			  813,    0,  815,    0,    0,    0,  817,  816,    0,  814,
			  816,  815,  816,  812,    0,  813,  812,  813,  812,  813,
			  814,  817,  816,  819,    0,  817,  815,  819,  812,  814,
			  815,  814,  813,  818,  815,  818,    0,    0,  817,  816,
			  819,  814,  816,  815,  816,  818,    0,  819,  820,  821,
			  820,    0,  823,  821,  816,  819,  823,    0,    0,  819,
			  820,  820,    0,    0,  822,  818,  821,  818,    0,  823,
			    0,  822,  819,  822,    0,    0,    0,  818,    0,  819,
			  820,  821,  820,  822,  823,  821,    0,  825,  823,    0,

			    0,  825,  820,  820,    0,  826,  822,  826,  821,    0,
			  824,  823,  824,  822,  825,  822,  824,  826,    0,  827,
			  825,    0,  824,  827,  829,  822,  831,  827,  829,  825,
			  831,    0,    0,  825,    0,  828,  827,  826,  828,  826,
			  828,  829,  824,  831,  824,    0,  825,    0,  824,  826,
			  828,  827,  825,    0,  824,  827,  829,  830,  831,  827,
			  829,    0,  831,    0,  830,    0,  830,  828,  827,    0,
			  828,  832,  828,  829,    0,  831,  830,  833,  832,    0,
			  832,  833,  828,    0,  835,  834,  836,  834,  835,  830,
			  832,  834,    0,  836,  833,  836,  830,  834,  830,    0,

			    0,  835,    0,  832,    0,  836,    0,    0,  830,  833,
			  832,  837,  832,  833,    0,  837,  835,  834,  836,  834,
			  835,    0,  832,  834,    0,  836,  833,  836,  837,  834,
			  837,  839,  838,  835,  838,  839,    0,  836,  841,  840,
			  838,  840,  841,  837,  838,    0,    0,  837,  839,    0,
			    0,  840,    0,    0,    0,  841,    0,  841,    0,    0,
			  837,  843,  837,  839,  838,  843,  838,  839,  844,    0,
			  841,  840,  838,  840,  841,    0,  838,    0,  843,  844,
			  839,  844,  842,  840,  842,    0,    0,  841,  845,  841,
			  842,  844,  845,  843,  842,  847,  846,  843,  846,  847,

			  844,    0,    0,  847,  848,  845,    0,  848,  846,  848,
			  843,  844,  847,  844,  842,    0,  842,  849,    0,  848,
			  845,  849,  842,  844,  845,  855,  842,  847,  846,  851,
			  846,  847,  856,  851,  849,  847,  848,  845,  850,  848,
			  846,  848,  857,    0,  847,  850,  851,  850,  852,  849,
			  852,  848,  858,  849,  853,    0,    0,  850,  853,    0,
			  852,  851,  854,    0,  854,  851,  849,  853,    0,  859,
			  850,  853,  859,    0,  854,    0,    0,  850,  851,  850,
			  852,  859,  852,    0,    0,    0,  853,    0,    0,  850,
			  853,    0,  852,  874,  854,  874,  854,    0,    0,  853, yy_Dummy>>,
			1, 1000, 7000)
		end

	yy_chk_template_9 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    0,    0,  853,    0,  874,  854,  862,  862,  862,
			  862,  855,  855,  855,  855,  855,  855,  855,  856,  856,
			  856,  856,  856,  856,  856,  874,    0,  874,  857,  857,
			  857,  857,  857,  857,  857,    0,    0,  874,  858,  858,
			  858,  858,  858,  858,  858,    0,    0,  862,  865,  865,
			  865,  865,    0,    0,    0,  859,  859,  859,  859,  859,
			  859,  859,  865,  866,  866,  866,  866,  869,  869,  869,
			  869,  872,  872,  872,  872,    0,  873,  876,  875,  876,
			  873,    0,  875,  877,  879,  872,  876,  877,  879,  876,
			    0,    0,    0,  873,  865,  875,    0,    0,  875,    0,

			  877,  879,  877,  866,    0,    0,    0,  869,  873,  876,
			  875,  876,  873,    0,  875,  877,  879,  872,  876,  877,
			  879,  876,  880,    0,    0,  873,  880,  875,    0,  878,
			  875,  878,  877,  879,  877,    0,  880,  878,  881,  880,
			  881,  878,    0,  882,    0,  882,  882,  883,    0,    0,
			  881,  883,    0,    0,  880,  882,    0,    0,  880,    0,
			    0,  878,    0,  878,  883,    0,  883,    0,  880,  878,
			  881,  880,  881,  878,    0,  882,  885,  882,  882,  883,
			  885,  886,  881,  883,    0,    0,    0,  882,  886,  884,
			  886,  884,  888,  885,  888,    0,  883,  884,  883,  887,

			  886,  884,  889,  887,  888,  890,  889,  890,  885,    0,
			  891,    0,  885,  886,  891,    0,  887,  890,    0,  889,
			  886,  884,  886,  884,  888,  885,  888,  891,    0,  884,
			    0,  887,  886,  884,  889,  887,  888,  890,  889,  890,
			  893,  895,  891,  892,  893,  895,  891,    0,  887,  890,
			  892,  889,  892,  894,    0,  894,  896,  893,  895,  891,
			    0,    0,  892,    0,  897,  894,  899,  896,  897,  896,
			  899,    0,  893,  895,    0,  892,  893,  895,    0,  896,
			    0,  897,  892,  899,  892,  894,  898,  894,  896,  893,
			  895,    0,    0,  898,  892,  898,  897,  894,  899,  896,

			  897,  896,  899,  901,  900,  898,  900,  901,    0,    0,
			  902,  896,  902,  897,    0,  899,  900,  902,  898,    0,
			  901,  901,  902,    0,    0,  898,    0,  898,  903,    0,
			    0,  904,  903,  904,    0,  901,  900,  898,  900,  901,
			    0,  903,  902,  904,  902,  903,    0,    0,  900,  902,
			    0,  905,  901,  901,  902,  905,    0,    0,    0,  906,
			  903,  906,  907,  904,  903,  904,  907,  906,  905,    0,
			  905,  906,  908,  903,  908,  904,    0,  903,  909,  907,
			  908,  907,  909,  905,  908,    0,    0,  905,  911,    0,
			    0,  906,  911,  906,  907,  909,  910,    0,  907,  906,

			  905,    0,  905,  906,  908,  911,  908,  910,    0,  910,
			  909,  907,  908,  907,  909,    0,  908,    0,    0,  910,
			  911,  912,    0,  912,  911,  913,    0,  909,  910,  913,
			  915,    0,    0,  912,  915,    0,    0,  911,  914,  910,
			  914,  910,  913,    0,  913,    0,  914,  915,  915,    0,
			  914,  910,  916,  912,  916,  912,  917,  913,    0,  916,
			  917,  913,  915,    0,  916,  912,  915,    0,    0,  918,
			  914,  918,  914,  917,  913,  920,  913,  920,  914,  915,
			  915,  918,  914,    0,  916,  919,  916,  920,  917,  919,
			    0,  916,  917,  921,    0,    0,  916,  921,  919,    0,

			    0,  918,  919,  918,    0,  917,  921,  920,    0,  920,
			  921,  923,  922,  918,  922,  923,    0,  919,    0,  920,
			  924,  919,  924,  925,  922,  921,  926,  925,  923,  921,
			  919,    0,  924,  926,  919,  926,    0,    0,  921,  928,
			  925,  928,  921,  923,  922,  926,  922,  923,    0,  927,
			    0,  928,  924,  927,  924,  925,  922,  929,  926,  925,
			  923,  929,    0,    0,  924,  926,  927,  926,  930,    0,
			  930,  928,  925,  928,  929,  931,  932,  926,  932,  931,
			  930,  927,  933,  928,    0,  927,  933,    0,  932,  929,
			    0,    0,  931,  929,  946,  946,  946,  946,  927,  933,

			  930,  933,  930,    0,    0,  937,  929,  931,  932,  937,
			  932,  931,  930,  934,  933,  934,    0,    0,  933,  935,
			  932,  934,  937,  935,  931,  934,  936,  938,  936,  938,
			    0,  933,  935,  933,  946,    0,  935,  937,  936,  938,
			  940,  937,  940,    0,    0,  934,  939,  934,  940,    0,
			  939,  935,  940,  934,  937,  935,    0,  934,  936,  938,
			  936,  938,    0,  939,  935,  939,    0,    0,  935,    0,
			  936,  938,  940,    0,  940,    0,    0,    0,  939,    0,
			  940,  945,  939,  945,  940,    0,  945,  945,  945,  945,
			  953,  953,  953,  953,  954,  939,  954,  939,    0,  954,

			  954,  954,  954,  955,  953,    0,  956,  955,  956,  957,
			    0,    0,  959,  957,  956,  958,  959,  958,  956,  960,
			  955,  960,  955,    0,    0,  959,  957,  958,    0,  959,
			  953,  960,    0,    0,    0,  955,  953,    0,  956,  955,
			  956,  957,    0,    0,  959,  957,  956,  958,  959,  958,
			  956,  960,  955,  960,  955,    0,  961,  959,  957,  958,
			  961,  959,  962,  960,  962,  963,  969,  964,  963,  963,
			  969,    0,    0,  961,  962,  964,  965,  964,    0,  965,
			  965,    0,  963,  969,    0,    0,    0,  964,  961,    0,
			    0,    0,  961,  965,  962,    0,  962,  963,  969,  964,

			  963,  963,  969,    0,    0,  961,  962,  964,  965,  964,
			  966,  965,  965,    0,  963,  969,    0,  967,  966,  964,
			  966,  967,    0,    0,  968,  965,  968,  970,  967,  970,
			  966,  971,    0,    0,  967,  971,  968,  975,    0,  970,
			  973,  975,  966,  972,  973,  972,  973,    0,  971,  967,
			  966,    0,  966,  967,  975,  972,  968,  973,  968,  970,
			  967,  970,  966,  971,    0,    0,  967,  971,  968,  975,
			    0,  970,  973,  975,  974,  972,  973,  972,  973,  974,
			  971,  974,  976,  978,  976,  978,  975,  972,  977,  973,
			    0,  974,  977,    0,  976,  978,    0,  980,  984,  980,

			  984,  984,    0,    0,    0,  977,  974,    0,  979,  980,
			  984,  974,  979,  974,  976,  978,  976,  978,  981,    0,
			  977,  979,  981,  974,  977,  979,  976,  978,    0,  980,
			  984,  980,  984,  984,  983,  981,  982,  977,  983,    0,
			  979,  980,  984,  982,  979,  982,    0,    0,  983,    0,
			  981,  983,  985,  979,  981,  982,  985,  979,    0,    0,
			    0,  987,    0,  987,    0,  987,  983,  981,  982,  985,
			  983,    0,  986,    0,    0,  982,    0,  982,  987,  986,
			  983,  986,  989,  983,  985,  988,  989,  982,  985,    0,
			  990,  986,  990,  987,  988,  987,  988,  987,    0,  989, yy_Dummy>>,
			1, 1000, 8000)
		end

	yy_chk_template_10 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,  985,  990,  991,  986,    0,  988,  991,  993,    0,
			  987,  986,  993,  986,  989,  995,    0,  988,  989,  995,
			  991,    0,  990,  986,  990,  993,  988,    0,  988, 1008,
			    0,  989,  995, 1008,  990,  991,  992,    0,  988,  991,
			  993,  994,    0,  992,  993,  992, 1008,  995,  994,    0,
			  994,  995,  991,    0,  996,  992,  996,  993,    0,    0,
			  994, 1008,    0,    0,  995, 1008,  996,    0,  992,  999,
			  999,  999,  999,  994,    0,  992,    0,  992, 1008,    0,
			  994,    0,  994,    0,    0,    0,  996,  992,  996, 1003,
			    0, 1003,  994,    0, 1003, 1003, 1003, 1003,  996, 1005,

			 1005, 1005, 1005, 1007, 1007, 1007, 1007,    0, 1009,  999,
			    0,    0, 1010, 1005,    0, 1009, 1010, 1009, 1011, 1012,
			 1011, 1014, 1013, 1012, 1013, 1014,    0, 1009,    0, 1010,
			 1011,    0,    0,    0, 1013,    0, 1012,    0, 1014, 1005,
			 1009,    0,    0, 1007, 1010, 1005,    0, 1009, 1010, 1009,
			 1011, 1012, 1011, 1014, 1013, 1012, 1013, 1014,    0, 1009,
			 1016, 1010, 1011, 1015, 1016, 1015, 1013, 1017, 1012, 1017,
			 1014, 1019, 1018, 1019, 1020, 1015, 1018, 1016, 1020, 1017,
			    0, 1022, 1021, 1019, 1021, 1022,    0,    0,    0, 1018,
			 1021, 1020, 1016, 1020, 1021, 1015, 1016, 1015, 1022, 1017,

			 1023, 1017, 1023, 1019, 1018, 1019, 1020, 1015, 1018, 1016,
			 1020, 1017, 1023, 1022, 1021, 1019, 1021, 1022,    0,    0,
			 1024, 1018, 1021, 1020, 1024, 1020, 1021, 1025,    0, 1025,
			 1022, 1026, 1023, 1025, 1023, 1026,    0, 1024, 1027, 1025,
			 1027, 1028,    0, 1030, 1023, 1028,    0, 1030, 1026,    0,
			 1027,    0, 1024,    0,    0, 1029, 1024,    0, 1028, 1025,
			 1030, 1025, 1029, 1026, 1029, 1025, 1031, 1026, 1031, 1024,
			 1027, 1025, 1027, 1028, 1029, 1030,    0, 1028, 1031, 1030,
			 1026, 1033, 1027, 1033, 1032,    0,    0, 1029, 1032,    0,
			 1028,    0, 1030, 1033, 1029,    0, 1029,    0, 1031,    0,

			 1031, 1032, 1034, 1034, 1034, 1034, 1029, 1040,    0, 1040,
			 1031,    0,    0, 1033, 1039, 1033, 1032,    0, 1039, 1040,
			 1032, 1037, 1037, 1037, 1037, 1033, 1038, 1038, 1038, 1038,
			    0, 1039, 1041, 1032,    0, 1042, 1041, 1042,    0, 1040,
			 1043, 1040, 1034, 1044, 1043, 1044, 1039, 1042, 1045, 1041,
			 1039, 1040, 1045,    0,    0, 1044,    0, 1043, 1046,    0,
			 1046, 1037,    0, 1039, 1041, 1045, 1038, 1042, 1041, 1042,
			 1046,    0, 1043,    0,    0, 1044, 1043, 1044,    0, 1042,
			 1045, 1041,    0,    0, 1045,    0,    0, 1044,    0, 1043,
			 1046,    0, 1046, 1047, 1047, 1047, 1047, 1045,    0,    0,

			    0,    0, 1046, 1054, 1054, 1054, 1054, 1054, 1054, 1054,
			 1054, 1054, 1054, 1054, 1054, 1054, 1054, 1056, 1056, 1056,
			 1056, 1056, 1056, 1056, 1056, 1056, 1056, 1056, 1056, 1056,
			 1056,    0,    0, 1047, 1049, 1049, 1049, 1049, 1049, 1049,
			 1049, 1049, 1049, 1049, 1049, 1049, 1049, 1049, 1049, 1049,
			 1049, 1049, 1049, 1049, 1049, 1049, 1049, 1050, 1050,    0,
			 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050,
			 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050,
			 1051,    0,    0,    0,    0,    0,    0, 1051, 1051, 1051,
			 1051, 1051, 1051, 1051, 1051, 1051, 1051, 1051, 1051, 1051,

			 1051, 1051, 1051, 1052, 1052,    0, 1052, 1052, 1052, 1052,
			 1052, 1052, 1052, 1052, 1052, 1052, 1052, 1052, 1052, 1052,
			 1052, 1052, 1052, 1052, 1052, 1052, 1053, 1053,    0, 1053,
			 1053, 1053, 1053,    0, 1053, 1053, 1053, 1053, 1053, 1053,
			 1053, 1053, 1053, 1053, 1053, 1053, 1053, 1053, 1053, 1055,
			 1055,    0, 1055, 1055, 1055,    0,    0, 1055, 1055, 1055,
			 1055, 1055, 1055, 1055, 1055, 1055, 1055, 1055, 1055, 1055,
			 1055, 1055, 1057,    0,    0, 1057,    0, 1057, 1057, 1057,
			 1057, 1057, 1057, 1057, 1057, 1057, 1057, 1057, 1057, 1057,
			 1057, 1057, 1057, 1057, 1057, 1058, 1058,    0, 1058, 1058,

			 1058, 1058, 1058, 1058, 1058, 1058, 1058, 1058, 1058, 1058,
			 1058, 1058, 1058, 1058, 1058, 1058, 1058, 1058, 1059, 1059,
			    0, 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1059,
			 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1059,
			 1059, 1060, 1060,    0, 1060, 1060, 1060, 1060, 1060, 1060,
			 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1060,
			 1060, 1060, 1060, 1060, 1061,    0,    0,    0,    0, 1061,
			 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061,
			 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1062, 1062, 1062,
			 1062, 1062, 1062, 1062, 1062,    0, 1062, 1062, 1062, 1062,

			 1062, 1062, 1062, 1062, 1062, 1062, 1062, 1062, 1062, 1062,
			 1063, 1063, 1063, 1063, 1063, 1063, 1063, 1063, 1063, 1063,
			 1063, 1063, 1063, 1064, 1064, 1064, 1064, 1064, 1064, 1064,
			 1064, 1064, 1064, 1064, 1064, 1064, 1065, 1065, 1065, 1065,
			 1065, 1065, 1065, 1065, 1065, 1065, 1065, 1065, 1065, 1066,
			 1066,    0, 1066, 1066, 1066,    0, 1066, 1066, 1066, 1066,
			 1066, 1066, 1066, 1066, 1066, 1066, 1066, 1066, 1066, 1066,
			 1066, 1066, 1067, 1067,    0, 1067, 1067, 1067,    0, 1067,
			 1067, 1067, 1067, 1067, 1067, 1067, 1067, 1067, 1067, 1067,
			 1067, 1067, 1067, 1067, 1067, 1068, 1068, 1068, 1068, 1068,

			 1068, 1068, 1068,    0, 1068, 1068, 1068, 1068, 1068, 1068,
			 1068, 1068, 1068, 1068, 1068, 1068, 1068, 1068, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,

			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, yy_Dummy>>,
			1, 918, 9000)
		end

	yy_base_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1068)
			yy_base_template_1 (an_array)
			yy_base_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_base_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    0,    0,   98,  109,  416, 9818,  401,  399,  395,
			  391,  385,  121,    0, 9818,  128,  135, 9818, 9818, 9818,
			 9818, 9818,   87,   87,   97,  126,   99,  150,  361, 9818,
			   99, 9818,  105,  355,  215,  279,  325,  342,  384,  401,
			  291,  451,  301,  392,  400,  461,  454,  475,  498,  505,
			  508,  514,  525,  519, 9818,  321, 9818, 9818,  512,  576,
			  565,  639,  602,  666,  736,  344,  732,  641,  728,  743,
			  747,  782,  790,  793,  807,  836,  828,  854,  855, 9818,
			 9818,   51,  273,   60,   63,   73,   84,  274,  533,  510,
			  348,  883,  635,  910,  940,  649,  859,  869,  659,  893,

			  903,  920,  344,  337,  333,  331, 9818,  964, 9818, 1057,
			 1021, 1039, 1072, 1086, 1103, 1116, 1133, 1166, 1180,    0,
			 1151, 1198, 1209, 1227, 1245, 1259, 1273, 1302, 1287,  319,
			 1395, 1362, 1376, 1405, 1418, 1428, 1438, 1451, 9818, 9818,
			 9818,  284, 9818, 9818,  600, 1533,  632,  100,  179,  321,
			 1577,  915,  109, 9818, 9818, 9818, 9818, 9818, 9818, 1401,
			 1539, 1583, 1557, 1586, 1620, 1499, 1617, 1634, 1635, 1650,
			 1673,   90,  237,   93,  122,  150,  181,  236, 1687, 1688,
			 1681, 1708, 1737, 1710, 1745, 1747, 1752, 1753, 1776, 1792,
			 1813, 1774, 1815, 1811, 1825, 1864, 1869, 1867, 1880, 1913,

			 1927, 1872, 1929, 1896, 1934, 1939, 1969, 1983, 1990, 1992,
			 1993, 1999, 2052, 2026, 2062, 2076, 2073, 2118, 2123, 2131,
			 2143, 2126, 2178, 2153, 2199, 2183, 2194, 2195, 2211, 2198,
			 2225, 2247, 2259, 2308, 2265, 2316, 2317, 2312, 2337, 2370,
			 2371, 2365, 2392, 2401, 2436, 2425, 2452, 2458, 2440, 2489,
			 2460, 2495, 2510, 2500, 9818, 2497, 2505, 2522, 2534, 2544,
			 2554, 2566, 2576,  242,  232,  322,  153,  510,  523,  233,
			  551,  612,  637,  701,  747,  761, 1191, 1234, 1483, 2586,
			 1388, 2596, 2606, 2616, 1557, 1623, 2629, 2647,  316, 2714,
			 2727, 2745, 2375, 2512, 2752, 2761, 2771, 2781, 2791, 2825,

			 2889, 2807, 2923, 2932, 2942, 2952, 2962, 2987, 2997, 2814,
			 2915, 2969, 2976, 3007, 3017, 3110, 3117, 3124, 3131, 3138,
			 3148, 3156, 3166, 3176, 3186, 3279, 3289, 3301, 3324, 3336,
			 3348, 3383, 3395, 3418, 3430, 3403, 3442, 3449, 3456, 3477,
			 3497, 3464, 9818, 3484, 3508, 3519, 3545, 3555, 3573, 3586,
			 3597, 3608,  305, 3615, 3622, 3666, 3644, 3651, 3686, 3711,
			 3718, 3725, 3740, 3747, 3755, 3762, 3775, 3782, 3789, 3814,
			 3821, 3836, 3851, 3878, 3888, 3910, 3925, 3940, 3270, 1033,
			 1051, 9818, 3293, 1124, 3139, 2955,  118,  335,  243, 1221,
			  216, 4020,  214, 3300, 3343, 3103, 2370, 2740, 3102, 4015,

			 2895, 3109, 3266, 4027, 3852, 4029, 4019,  834, 1039, 1072,
			 1148, 1223, 1255, 4069, 3682, 4075, 4070, 4080, 4076, 4106,
			 4122, 4132, 4128, 4140, 4135, 4162, 4170, 4180, 4184, 4192,
			 4227, 4213, 4244, 3853, 4223, 4267, 4256, 4287, 4291, 4290,
			 4330, 4345, 4266, 4351, 4346, 4350, 4361, 4388, 4409, 4398,
			 4410, 4418, 4408, 4425, 4451, 4458, 4466, 4478, 4479, 4500,
			 4508, 4507, 4518, 4543, 4545, 4542, 4573, 4589, 4584, 4615,
			 4559, 4620, 4630, 4640, 4657, 4646, 4654, 4679, 4684, 4705,
			 4706, 4736, 4739, 4721, 4745, 4772, 4776, 4731, 4769, 4799,
			 4823, 4833, 4840, 4826, 4834, 4870, 4877, 4892, 4894, 4897,

			 4880, 4934, 4940, 4952, 4947, 4964, 4963, 4994, 4996, 5010,
			 5009, 5017, 5022, 9818, 5006, 5024, 5031, 5043, 5055, 5066,
			 1269, 1284, 1287, 1298, 1319, 1327, 1374, 1415, 9818, 3859,
			 3896, 5079, 5091, 5101, 5124, 5016, 9818, 5109, 5136, 5148,
			 5159, 5172, 5194, 5204, 5270, 5302, 5309, 5316, 5326, 5336,
			 5343, 5350, 5368, 5375, 5448, 5473, 3866, 5293, 5480, 5487,
			 5494, 5501, 5511, 5518, 5525, 5541, 5551, 5618, 5644, 5662,
			 5669, 5676, 5683, 5690, 5708, 5715, 5725, 5735, 9818, 9818,
			 9818, 9818, 9818, 5824, 9818, 9818, 9818, 9818, 9818, 9818,
			 9818, 9818, 9818, 9818, 9818, 9818, 9818, 9818, 9818, 9818,

			 5779, 5789, 4261, 1545, 3600, 1674, 5636, 2060, 2294, 2529,
			 3710, 5643, 3769,  389,  141, 2308,  128,    0,  106, 5667,
			 5731, 5862, 5852, 5868, 5274, 5902, 5899, 5916, 5918, 1660,
			 2039, 5458, 5936, 5953, 5932, 5976, 5984, 5992, 5987, 6001,
			 6036, 6048, 6008, 6056, 6044, 6058, 6093, 6078, 6098, 6113,
			 6108, 6109, 6148, 6146, 6156, 6151, 6173, 6172, 6199, 6181,
			 6223, 6218, 6222, 6239, 6270, 6253, 6237, 6286, 6251, 6287,
			 6284, 6317, 6301, 6326, 6334, 6338, 6337, 6361, 6341, 6359,
			 6358, 6394, 6401, 6405, 6404, 6425, 6405, 6435, 6410, 6458,
			 6469, 6459, 6472, 6516, 6517, 6519, 6518, 6566, 6546, 6539,

			 6569, 6596, 6618, 6610, 6453, 6627, 6623, 6639, 6647, 6680,
			 6676, 6691, 6690, 6694, 6709, 6724, 6723, 6744, 6742, 6771,
			 6779, 6794, 6761, 6796, 6825, 6810, 6806, 6835, 6842, 6827,
			 6837, 2337, 2412, 5700, 6809, 6844, 6856, 6867, 6877, 6885,
			 6892, 6902, 6909, 6921, 6937, 7035, 7042, 7049, 7056, 7063,
			 7014, 7070, 6998, 7027, 7077, 5828, 5837, 2561, 2794, 7157,
			 3169, 5843, 3327, 7161, 3386, 5833, 7167, 7162, 7014, 7163,
			 7158, 7172, 7173, 7173, 7213, 7215, 7212, 7227, 7226, 7248,
			 7249, 7270, 7278, 7295, 7230, 7279, 7277, 7309, 7325, 7330,
			 7338, 7346, 7373, 7356, 7387, 7385, 7388, 7437, 7401, 7423,

			 7402, 7448, 7447, 7449, 7464, 7474, 7501, 7500, 7505, 7521,
			 7488, 7522, 7553, 7563, 7566, 7574, 7579, 7569, 7602, 7603,
			 7617, 7629, 7640, 7632, 7669, 7667, 7664, 7689, 7697, 7694,
			 7723, 7696, 7737, 7747, 7744, 7754, 7752, 7781, 7791, 7801,
			 7798, 7808, 7841, 7831, 7838, 7858, 7855, 7865, 7866, 7887,
			 7904, 7899, 7907, 7924, 7921, 7918, 7925, 7935, 7945, 7962,
			 9818, 3447, 7987, 3511,   95, 8028, 8043, 3607, 3636, 8047,
			 3754, 5708, 8051, 8046, 7952, 8048, 8036, 8053, 8088, 8054,
			 8092, 8097, 8102, 8117, 8148, 8146, 8147, 8169, 8151, 8172,
			 8164, 8180, 8209, 8210, 8212, 8211, 8226, 8234, 8252, 8236,

			 8263, 8273, 8269, 8298, 8290, 8321, 8318, 8332, 8331, 8348,
			 8366, 8358, 8380, 8395, 8397, 8400, 8411, 8426, 8428, 8455,
			 8434, 8463, 8471, 8481, 8479, 8493, 8492, 8519, 8498, 8527,
			 8527, 8545, 8535, 8552, 8572, 8589, 8585, 8575, 8586, 8616,
			 8599, 3774, 3976, 3990, 7083, 8666, 8574, 4005,  324, 4026,
			 4620, 5070, 9818, 8670, 8679, 8673, 8665, 8679, 8674, 8682,
			 8678, 8726, 8721, 8735, 8734, 8746, 8777, 8787, 8783, 8736,
			 8786, 8801, 8802, 8810, 8838, 8807, 8841, 8858, 8842, 8878,
			 8856, 8888, 8902, 8904, 8857, 8922, 8938, 8931, 8953, 8952,
			 8949, 8973, 9002, 8978, 9007, 8985, 9013,   74, 5112, 9049, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_base_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 5204, 5532, 5609, 9074,   63, 9079, 5816, 9083, 8999, 9074,
			 9082, 9077, 9089, 9081, 9091, 9122, 9130, 9126, 9142, 9130,
			 9144, 9141, 9151, 9159, 9190, 9186, 9201, 9197, 9211, 9221,
			 9213, 9225, 9254, 9240, 9282,   46, 5976, 9301, 9306, 9284,
			 9266, 9302, 9294, 9310, 9302, 9318, 9317, 9373, 9818, 9433,
			 9456, 9479, 9502, 9525, 9394, 9548, 9407, 9571, 9594, 9617,
			 9640, 9663, 9686, 9700, 9713, 9726, 9748, 9771, 9794, yy_Dummy>>,
			1, 69, 1000)
		end

	yy_def_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1068)
			yy_def_template_1 (an_array)
			yy_def_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_def_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0, 1048,    1, 1049, 1049, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1050, 1051, 1048, 1052, 1053, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1054, 1054, 1054, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048,   34,   34,   36,   34,   36,
			   39,   39,   39,   39,   39,   39,   39,   39,   39,   39,
			   41,   39,   39,   39, 1048, 1048, 1048, 1048, 1055, 1056,
			 1056, 1056, 1056, 1056,   63,   63,   63,   63,   63,   63,
			   63,   63,   63,   63,   63,   63,   63,   63,   63, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1057, 1048,
			 1048, 1057, 1048, 1058, 1059, 1057, 1057, 1057, 1057, 1057,

			 1057, 1057, 1048, 1048, 1048, 1048, 1048, 1050, 1048, 1060,
			 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1051,
			 1052, 1052, 1052, 1052, 1052, 1052, 1052, 1052, 1061, 1048,
			 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1048, 1048,
			 1048, 1048, 1048, 1048, 1062, 1054, 1054, 1054, 1063, 1064,
			 1065, 1054, 1054, 1048, 1048, 1048, 1048, 1048, 1048,   39,
			   39,   39,   39,   39,   39,   63,   63,   63,   63,   63,
			   63, 1048, 1048, 1048, 1048, 1048, 1048, 1048,   39,   63,
			   39,   39,   39,   39,   39,   63,   63,   63,   63,   63,
			   39,   39,   63,   63,   39,   39,   39,   63,   63,   63,

			   39,   39,   39,   63,   63,   63,   39,   39,   41,   39,
			   63,   63,   63,   63,   39,   39,   63,   63,   39,   63,
			   39,   63,   39,   39,   39,   39,   63,   63,   63,   63,
			   39,   63,   41,   63,   39,   39,   63,   63,   39,   39,
			   63,   63,   39,   39,   63,   63,   39,   39,   63,   63,
			   39,   63,   39,   63, 1048, 1055, 1055, 1055, 1055, 1055,
			 1055, 1055, 1055, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1057, 1057, 1057, 1057,
			 1057, 1057, 1057, 1057, 1048, 1048, 1066, 1067, 1048, 1057,
			 1058, 1059, 1048, 1057, 1058, 1058, 1058, 1058, 1058, 1058,

			 1058, 1057, 1059, 1059, 1059, 1059, 1059, 1059, 1059, 1057,
			 1057, 1057, 1057, 1057, 1057, 1060, 1052, 1052, 1060, 1060,
			 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1050, 1050, 1050,
			 1050, 1050, 1050, 1050, 1050, 1052, 1052, 1052, 1052, 1052,
			 1052, 1061, 1048, 1061, 1061, 1061, 1061, 1061, 1061, 1061,
			 1061, 1061, 1048, 1061, 1061, 1061, 1061, 1061, 1061, 1061,
			 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061,
			 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1061, 1048, 1048,
			 1048, 1048, 1048, 1048, 1054, 1054, 1054, 1063, 1063, 1064,
			 1064, 1065, 1065, 1054, 1054,   39,   63,   39,   39,   63,

			   63,   39,   63,   39,   63,   39,   63, 1048, 1048, 1048,
			 1048, 1048, 1048,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   39,   63,   63,   39,
			   63,   39,   39,   63,   63,   39,   39,   63,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   39,   39,
			   39,   39,   63,   63,   63,   63,   63,   39,   63,   39,
			   39,   63,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   39,   39,   39,   39,
			   39,   63,   63,   63,   63,   63,   63,   39,   39,   63,
			   63,   39,   63,   39,   63,   39,   63,   39,   39,   39,

			   63,   63,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63, 1048, 1055, 1055, 1055, 1055, 1055, 1055,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1066,
			 1066, 1066, 1066, 1066, 1066, 1066, 1048, 1067, 1067, 1067,
			 1067, 1067, 1067, 1067, 1058, 1058, 1058, 1058, 1058, 1058,
			 1059, 1059, 1059, 1059, 1059, 1059, 1057, 1057, 1060, 1060,
			 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1060, 1050, 1050,
			 1052, 1052, 1061, 1061, 1061, 1061, 1061, 1061, 1048, 1048,
			 1048, 1048, 1048, 1061, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,

			 1061, 1061, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1054, 1054, 1063, 1063, 1064, 1064,  391, 1065, 1054,
			 1054,   39,   63,   39,   63,   39,   63,   39,   63, 1048,
			 1048,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   39,   63,   63,   39,   63,   39,   63,   39,   63,   39,
			   39,   63,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   39,   63,   63,   39,   63,   39,   63,   39,   63,   39,

			   63,   39,   39,   63,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63, 1055,
			 1055, 1048, 1048, 1066, 1066, 1066, 1066, 1066, 1066, 1067,
			 1067, 1067, 1067, 1067, 1067, 1058, 1058, 1059, 1059, 1060,
			 1060, 1060, 1061, 1061, 1061, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1062, 1054,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,

			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63, 1066, 1066, 1067, 1067, 1060,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1068,   39,   63,   39,   63,   39,   63,   39,
			   39,   63,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,

			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63,   39,   63,   39,
			   63,   39,   63,   39,   63,   39,   63, 1048, 1048, 1048, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_def_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,   39,   63,
			   39,   63,   39,   63,   39,   63,   39,   63,   39,   63,
			   39,   63,   39,   63,   39,   63,   39,   63,   39,   63,
			   39,   63,   39,   63, 1048, 1048, 1048, 1048, 1048,   39,
			   63,   39,   63,   39,   63,   39,   63, 1048,    0, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048,
			 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, 1048, yy_Dummy>>,
			1, 69, 1000)
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
			   85,   86,   87,   88,    8,   89,    1,    1,   90,   90,
			   90,   90,   90,   90,   90,   90,   90,   90,   90,   90,
			   90,   90,   90,   90,   91,   91,   91,   91,   91,   91,
			   91,   91,   91,   91,   91,   91,   91,   91,   91,   91,
			   92,   92,   92,   92,   92,   92,   92,   92,   92,   92,
			   92,   92,   92,   92,   92,   92,   92,   92,   92,   92,
			   92,   92,   92,   92,   92,   92,   92,   92,   92,   92,
			   92,   92,    1,    1,   93,   93,   93,   93,   93,   93,

			   93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
			   93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
			   93,   93,   93,   93,   94,   95,   95,   95,   95,   95,
			   95,   95,   95,   95,   95,   95,   95,   96,   97,   97,
			    1,   98,   98,   98,   99,    1,    1,    1,    1,    1,
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
			   10,   10,   14,   15,   16,   17,    1,    1,    1,    1,
			   18,    1,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   19,   20,   21,   22,    1,    1,
			    1,    1,    1,   23,   23,   23,   23,   23,   23,   23, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1049)
			yy_accept_template_1 (an_array)
			yy_accept_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_accept_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    1,    1,    1,    2,    3,    4,    6,    9,   11,
			   14,   17,   20,   23,   26,   29,   32,   34,   37,   40,
			   43,   46,   49,   52,   55,   58,   62,   66,   70,   73,
			   76,   79,   82,   85,   87,   91,   95,   99,  103,  107,
			  111,  115,  119,  123,  127,  131,  135,  139,  143,  147,
			  151,  155,  159,  163,  167,  170,  172,  175,  178,  180,
			  183,  186,  189,  192,  195,  198,  201,  204,  207,  210,
			  213,  216,  219,  222,  225,  228,  231,  234,  237,  240,
			  243,  246,  248,  250,  252,  254,  256,  258,  260,  262,
			  264,  266,  269,  271,  273,  275,  277,  279,  281,  283,

			  285,  287,  289,  290,  291,  292,  293,  294,  295,  296,
			  297,  300,  303,  304,  305,  306,  307,  308,  309,  310,
			  311,  312,  313,  314,  315,  316,  317,  318,  319,  320,
			  320,  321,  322,  323,  324,  325,  326,  327,  328,  329,
			  330,  331,  333,  334,  335,  335,  337,  339,  340,  342,
			  343,  344,  344,  346,  347,  348,  349,  350,  351,  352,
			  354,  356,  358,  360,  363,  365,  366,  367,  368,  369,
			  371,  372,  372,  372,  372,  372,  372,  372,  372,  374,
			  375,  377,  379,  381,  383,  385,  386,  387,  388,  389,
			  390,  392,  395,  396,  398,  400,  402,  404,  405,  406,

			  407,  409,  411,  413,  414,  415,  416,  419,  421,  423,
			  426,  428,  429,  430,  432,  434,  436,  437,  438,  440,
			  441,  443,  444,  446,  448,  450,  453,  454,  455,  456,
			  458,  460,  461,  463,  464,  466,  468,  469,  470,  472,
			  474,  475,  476,  478,  480,  481,  482,  484,  486,  487,
			  488,  490,  491,  493,  494,  495,  495,  495,  495,  495,
			  495,  495,  495,  495,  495,  495,  495,  495,  495,  495,
			  495,  495,  495,  495,  495,  495,  495,  496,  497,  498,
			  499,  500,  501,  502,  503,  504,  504,  504,  504,  505,
			  507,  508,  509,  510,  512,  513,  514,  515,  516,  517,

			  518,  519,  521,  522,  523,  524,  525,  526,  527,  528,
			  529,  530,  531,  532,  533,  534,  534,  536,  538,  538,
			  538,  538,  538,  538,  538,  538,  538,  538,  540,  542,
			  543,  544,  545,  546,  547,  548,  549,  550,  551,  552,
			  553,  554,  555,  556,  557,  558,  559,  560,  561,  562,
			  563,  564,  565,  565,  566,  567,  568,  569,  570,  571,
			  572,  573,  574,  575,  576,  577,  578,  579,  580,  581,
			  582,  583,  584,  585,  586,  587,  588,  589,  590,  592,
			  592,  592,  593,  595,  596,  598,  600,  600,  603,  605,
			  608,  610,  613,  615,  617,  617,  619,  620,  622,  625,

			  626,  628,  631,  633,  635,  636,  638,  639,  639,  639,
			  639,  639,  639,  639,  642,  644,  646,  647,  649,  650,
			  652,  653,  655,  656,  658,  659,  661,  663,  664,  665,
			  667,  668,  671,  673,  675,  676,  678,  680,  681,  682,
			  684,  685,  687,  688,  690,  691,  693,  694,  696,  698,
			  700,  702,  704,  705,  706,  707,  708,  709,  711,  712,
			  714,  716,  717,  718,  720,  721,  724,  726,  728,  729,
			  732,  734,  736,  737,  739,  740,  742,  744,  746,  748,
			  750,  752,  753,  754,  755,  756,  757,  758,  760,  762,
			  763,  764,  766,  767,  769,  770,  772,  773,  775,  777,

			  779,  780,  781,  782,  785,  787,  789,  790,  792,  793,
			  795,  796,  799,  801,  802,  802,  802,  802,  802,  802,
			  802,  802,  802,  802,  802,  802,  802,  802,  802,  803,
			  803,  803,  803,  803,  803,  803,  803,  804,  804,  804,
			  804,  804,  804,  804,  804,  805,  806,  807,  808,  809,
			  810,  811,  812,  813,  814,  815,  816,  817,  818,  819,
			  820,  820,  821,  821,  821,  821,  821,  821,  821,  822,
			  823,  824,  825,  826,  827,  828,  829,  830,  831,  832,
			  833,  834,  835,  836,  837,  838,  839,  840,  841,  842,
			  843,  844,  845,  846,  847,  848,  849,  850,  851,  852,

			  853,  854,  855,  857,  857,  859,  859,  861,  861,  861,
			  861,  863,  865,  867,  867,  867,  867,  867,  867,  867,
			  869,  871,  873,  874,  876,  877,  879,  880,  882,  883,
			  883,  883,  885,  886,  888,  889,  891,  892,  894,  895,
			  897,  898,  900,  901,  903,  904,  907,  909,  911,  912,
			  914,  916,  917,  918,  920,  921,  923,  924,  926,  927,
			  930,  932,  934,  935,  937,  938,  940,  941,  943,  944,
			  946,  947,  949,  950,  952,  953,  956,  958,  960,  961,
			  964,  966,  968,  969,  972,  974,  976,  977,  980,  982,
			  984,  986,  987,  988,  990,  991,  993,  994,  996,  997,

			  999, 1000, 1002, 1004, 1005, 1006, 1008, 1009, 1011, 1012,
			 1014, 1015, 1017, 1018, 1021, 1023, 1026, 1028, 1030, 1031,
			 1033, 1034, 1036, 1037, 1039, 1040, 1043, 1045, 1048, 1050,
			 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050, 1050,
			 1050, 1050, 1050, 1050, 1050, 1050, 1051, 1052, 1053, 1054,
			 1054, 1054, 1054, 1055, 1056, 1057, 1058, 1060, 1060, 1060,
			 1062, 1062, 1066, 1066, 1068, 1068, 1068, 1070, 1073, 1075,
			 1078, 1080, 1082, 1083, 1085, 1086, 1089, 1091, 1094, 1096,
			 1098, 1099, 1101, 1102, 1104, 1105, 1108, 1110, 1112, 1113,
			 1115, 1116, 1118, 1119, 1121, 1122, 1124, 1125, 1127, 1128,

			 1131, 1133, 1135, 1136, 1138, 1139, 1141, 1142, 1144, 1145,
			 1148, 1150, 1152, 1153, 1155, 1156, 1158, 1159, 1162, 1164,
			 1166, 1167, 1169, 1170, 1172, 1173, 1175, 1176, 1178, 1179,
			 1181, 1182, 1184, 1185, 1187, 1188, 1190, 1191, 1193, 1194,
			 1197, 1199, 1201, 1202, 1204, 1205, 1208, 1210, 1212, 1213,
			 1215, 1216, 1219, 1221, 1223, 1224, 1224, 1224, 1224, 1224,
			 1224, 1225, 1225, 1227, 1227, 1228, 1229, 1233, 1233, 1233,
			 1235, 1235, 1236, 1236, 1239, 1241, 1243, 1244, 1246, 1247,
			 1250, 1252, 1254, 1255, 1257, 1258, 1260, 1261, 1264, 1266,
			 1269, 1271, 1273, 1274, 1277, 1279, 1281, 1282, 1284, 1285,

			 1288, 1290, 1292, 1293, 1295, 1296, 1298, 1299, 1301, 1302,
			 1304, 1305, 1308, 1310, 1312, 1313, 1315, 1316, 1319, 1321,
			 1323, 1324, 1326, 1327, 1330, 1332, 1334, 1335, 1338, 1340,
			 1343, 1345, 1348, 1350, 1352, 1353, 1355, 1356, 1359, 1361,
			 1363, 1364, 1364, 1365, 1365, 1365, 1365, 1369, 1369, 1370,
			 1371, 1371, 1371, 1372, 1373, 1374, 1376, 1377, 1380, 1382,
			 1384, 1385, 1388, 1390, 1392, 1393, 1395, 1396, 1398, 1399,
			 1402, 1404, 1407, 1409, 1411, 1412, 1415, 1417, 1420, 1422,
			 1424, 1425, 1427, 1428, 1430, 1431, 1433, 1434, 1436, 1437,
			 1440, 1442, 1444, 1445, 1447, 1448, 1451, 1453, 1454, 1454, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_accept_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 1455, 1455, 1457, 1457, 1457, 1458, 1459, 1459, 1460, 1462,
			 1463, 1466, 1468, 1471, 1473, 1476, 1478, 1481, 1483, 1486,
			 1488, 1490, 1491, 1494, 1496, 1498, 1499, 1502, 1504, 1506,
			 1507, 1510, 1512, 1515, 1517, 1518, 1520, 1520, 1522, 1523,
			 1526, 1528, 1531, 1533, 1536, 1538, 1541, 1543, 1545, 1545, yy_Dummy>>,
			1, 50, 1000)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1544)
			yy_acclist_template_1 (an_array)
			yy_acclist_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_acclist_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,  141,  141,  162,  160,  161,    3,  160,  161,    4,
			  161,    1,  160,  161,    2,  160,  161,   10,  160,  161,
			  143,  160,  161,  108,  160,  161,   17,  160,  161,  143,
			  160,  161,  160,  161,   11,  160,  161,   12,  160,  161,
			   31,  160,  161,   30,  160,  161,    8,  160,  161,   29,
			  160,  161,    6,  160,  161,   32,  160,  161,  145,  152,
			  160,  161,  145,  152,  160,  161,  145,  152,  160,  161,
			    9,  160,  161,    7,  160,  161,   36,  160,  161,   34,
			  160,  161,   35,  160,  161,  160,  161,  106,  107,  160,
			  161,  106,  107,  160,  161,  106,  107,  160,  161,  106,

			  107,  160,  161,  106,  107,  160,  161,  106,  107,  160,
			  161,  106,  107,  160,  161,  106,  107,  160,  161,  106,
			  107,  160,  161,  106,  107,  160,  161,  106,  107,  160,
			  161,  106,  107,  160,  161,  106,  107,  160,  161,  106,
			  107,  160,  161,  106,  107,  160,  161,  106,  107,  160,
			  161,  106,  107,  160,  161,  106,  107,  160,  161,  106,
			  107,  160,  161,  106,  107,  160,  161,   15,  160,  161,
			  160,  161,   16,  160,  161,   33,  160,  161,  160,  161,
			  107,  160,  161,  107,  160,  161,  107,  160,  161,  107,
			  160,  161,  107,  160,  161,  107,  160,  161,  107,  160,

			  161,  107,  160,  161,  107,  160,  161,  107,  160,  161,
			  107,  160,  161,  107,  160,  161,  107,  160,  161,  107,
			  160,  161,  107,  160,  161,  107,  160,  161,  107,  160,
			  161,  107,  160,  161,  107,  160,  161,  107,  160,  161,
			   13,  160,  161,   14,  160,  161,  160,  161,  160,  161,
			  160,  161,  160,  161,  160,  161,  160,  161,  160,  161,
			  141,  161,  139,  161,  140,  161,  135,  141,  161,  138,
			  161,  141,  161,  141,  161,  141,  161,  141,  161,  141,
			  161,  141,  161,  141,  161,  141,  161,  141,  161,    3,
			    4,    1,    2,   37,  143,  142,  142, -133,  143, -294,

			 -134,  143, -295,  143,  143,  143,  143,  143,  143,  143,
			  108,  143,  143,  143,  143,  143,  143,  143,  143,  132,
			  132,  132,  132,  132,  132,  132,  132,  132,    5,   23,
			   24,  155,  158,   18,   20,  145,  152,  145,  152,  152,
			  144,  152,  152,  152,  144,  152,   28,   25,   22,   21,
			   26,   27,  106,  107,  106,  107,  106,  107,  106,  107,
			   42,  106,  107,  106,  107,  107,  107,  107,  107,   42,
			  107,  107,  106,  107,  107,  106,  107,  106,  107,  106,
			  107,  106,  107,  106,  107,  107,  107,  107,  107,  107,
			  106,  107,   54,  106,  107,  107,   54,  107,  106,  107,

			  106,  107,  106,  107,  107,  107,  107,  106,  107,  106,
			  107,  106,  107,  107,  107,  107,   66,  106,  107,  106,
			  107,  106,  107,   73,  106,  107,   66,  107,  107,  107,
			   73,  107,  106,  107,  106,  107,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  106,  107,  106,  107,
			   83,  106,  107,  107,  107,  107,   83,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  106,  107,  107,  107,
			  106,  107,  106,  107,  107,  107,  106,  107,  106,  107,
			  107,  107,  106,  107,  106,  107,  107,  107,  106,  107,
			  107,  106,  107,  107,   19,  141,  141,  141,  141,  141,

			  141,  141,  141,  139,  140,  135,  141,  141,  141,  138,
			  136,  141,  141,  141,  141,  141,  141,  141,  141,  137,
			  141,  141,  141,  141,  141,  141,  141,  141,  141,  141,
			  141,  141,  141,  141,  142,  143,  142,  143, -133,  143,
			 -134,  143,  143,  143,  143,  143,  143,  143,  143,  143,
			  143,  143,  143,  143,  132,  109,  132,  132,  132,  132,
			  132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
			  132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
			  132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
			  155,  158,  153,  155,  158,  153,  145,  152,  145,  152,

			  148,  151,  152,  151,  152,  147,  150,  152,  150,  152,
			  146,  149,  152,  149,  152,  145,  152,  106,  107,  107,
			  106,  107,   40,  106,  107,  107,   40,  107,   41,  106,
			  107,   41,  107,  106,  107,  107,  106,  107,  107,   45,
			  106,  107,   45,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,  106,
			  107,  106,  107,  107,  107,  106,  107,  107,   57,  106,
			  107,  106,  107,   57,  107,  107,  106,  107,  106,  107,
			  107,  107,  106,  107,  107,  106,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  106,  107,  106,  107,

			  106,  107,  106,  107,  107,  107,  107,  107,  107,  106,
			  107,  107,  106,  107,  106,  107,  107,  107,  106,  107,
			  107,   78,  106,  107,   78,  107,  106,  107,  107,   81,
			  106,  107,   81,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  106,  107,  106,  107,  106,  107,  106,  107,
			  106,  107,  107,  107,  107,  107,  107,  107,  106,  107,
			  106,  107,  107,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  107,  106,  107,  106,  107,  106,  107,  107,
			  107,  107,  101,  106,  107,  101,  107,  106,  107,  107,
			  106,  107,  107,  106,  107,  107,  105,  106,  107,  105,

			  107,  159,  136,  137,  141,  141,  141,  141,  141,  141,
			  141,  141,  141,  141,  141,  141,  141,  141,  142,  142,
			  142,  143,  143,  143,  143,  132,  132,  132,  132,  132,
			  132,  126,  124,  125,  127,  128,  132,  129,  130,  110,
			  111,  112,  113,  114,  115,  116,  117,  118,  119,  120,
			  121,  122,  123,  132,  132,  155,  158,  155,  158,  155,
			  158,  154,  157,  145,  152,  145,  152,  145,  152,  145,
			  152,  106,  107,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,  106,
			  107,  107,  106,  107,  107,  106,  107,  107,  106,  107,

			  107,  106,  107,  107,   55,  106,  107,   55,  107,  106,
			  107,  107,  106,  107,  106,  107,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  107,   64,  106,  107,
			  106,  107,   64,  107,  107,  106,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  107,   74,  106,  107,   74,  107,  106,  107,
			  107,   76,  106,  107,   76,  107,  106,  107,  107,   79,
			  106,  107,   79,  107,  106,  107,  107,   82,  106,  107,
			   82,  107,  106,  107,  106,  107,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  107,  106,  107,  107, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_acclist_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  106,  107,  106,  107,  107,  107,  106,  107,  107,  106,
			  107,  107,  106,  107,  107,  106,  107,  107,   96,  106,
			  107,   96,  107,   97,  106,  107,   97,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  107,  106,  107,  107,
			  103,  106,  107,  103,  107,  104,  106,  107,  104,  107,
			  141,  141,  141,  141,  132,  132,  132,  155,  155,  158,
			  155,  158,  154,  155,  157,  158,  154,  157,  145,  152,
			   38,  106,  107,   38,  107,   39,  106,  107,   39,  107,
			  106,  107,  107,  106,  107,  107,   46,  106,  107,   46,
			  107,   47,  106,  107,   47,  107,  106,  107,  107,  106,

			  107,  107,  106,  107,  107,   52,  106,  107,   52,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,  106,
			  107,  107,  106,  107,  107,  106,  107,  107,   62,  106,
			  107,   62,  107,  106,  107,  107,  106,  107,  107,  106,
			  107,  107,  106,  107,  107,   69,  106,  107,   69,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,   75,
			  106,  107,   75,  107,  106,  107,  107,  106,  107,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,  106,
			  107,  107,  106,  107,  107,  106,  107,  107,  106,  107,
			  107,  106,  107,  107,   92,  106,  107,   92,  107,  106,

			  107,  107,  106,  107,  107,   95,  106,  107,   95,  107,
			  106,  107,  107,  106,  107,  107,  100,  106,  107,  100,
			  107,  106,  107,  107,  131,  155,  158,  158,  155,  154,
			  155,  157,  158,  154,  157,  153,   43,  106,  107,   43,
			  107,  106,  107,  107,  106,  107,  107,   49,  106,  107,
			  106,  107,   49,  107,  107,  106,  107,  107,  106,  107,
			  107,   56,  106,  107,   56,  107,   58,  106,  107,   58,
			  107,  106,  107,  107,   60,  106,  107,   60,  107,  106,
			  107,  107,  106,  107,  107,   65,  106,  107,   65,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,  106,

			  107,  107,  106,  107,  107,   77,  106,  107,   77,  107,
			  106,  107,  107,  106,  107,  107,   85,  106,  107,   85,
			  107,  106,  107,  107,  106,  107,  107,   88,  106,  107,
			   88,  107,  106,  107,  107,   90,  106,  107,   90,  107,
			   91,  106,  107,   91,  107,   93,  106,  107,   93,  107,
			  106,  107,  107,  106,  107,  107,   99,  106,  107,   99,
			  107,  106,  107,  107,  155,  154,  155,  157,  158,  158,
			  154,  156,  158,  156,  106,  107,  107,   48,  106,  107,
			   48,  107,  106,  107,  107,   51,  106,  107,   51,  107,
			  106,  107,  107,  106,  107,  107,  106,  107,  107,   63,

			  106,  107,   63,  107,   67,  106,  107,   67,  107,  106,
			  107,  107,   70,  106,  107,   70,  107,   71,  106,  107,
			   71,  107,  106,  107,  107,  106,  107,  107,  106,  107,
			  107,  106,  107,  107,  106,  107,  107,   89,  106,  107,
			   89,  107,  106,  107,  107,  106,  107,  107,  102,  106,
			  107,  102,  107,  158,  158,  154,  155,  157,  158,  157,
			  106,  107,  107,   50,  106,  107,   50,  107,   53,  106,
			  107,   53,  107,   59,  106,  107,   59,  107,   61,  106,
			  107,   61,  107,   68,  106,  107,   68,  107,  106,  107,
			  107,   80,  106,  107,   80,  107,  106,  107,  107,   87,

			  106,  107,   87,  107,  106,  107,  107,   94,  106,  107,
			   94,  107,   98,  106,  107,   98,  107,  158,  157,  158,
			  157,  158,  157,   44,  106,  107,   44,  107,   72,  106,
			  107,   72,  107,   84,  106,  107,   84,  107,   86,  106,
			  107,   86,  107,  157,  158, yy_Dummy>>,
			1, 545, 1000)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 9818
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 1048
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 1049
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
	copyright:	"Copyright (c) 1984-2008, Eiffel Software"
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
