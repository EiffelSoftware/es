note
	description:"Scanners for textual BON parsers."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author:     "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk> based on work by Arnaud Pichery and Eric Bezault"
	date:       "$Date$"
	revision:   "$Revision$"

class EDITOR_TEXTUAL_BON_SCANNER

inherit

	EDITOR_TEXTUAL_BON_SCANNER_SKELETON	

create
	make

feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= VERBATIM_STR1)
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
			yy_acclist := yy_acclist_template
		end

	yy_execute_action (yy_act: INTEGER)
			-- Execute semantic action.
		do
if yy_act <= 77 then
if yy_act <= 39 then
if yy_act <= 20 then
if yy_act <= 10 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
--|#line 43 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 43")
end
-- Ignore carriage return
else
--|#line 44 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 44")
end

					curr_token := new_space (text_count)
					update_token_list
					
end
else
--|#line 48 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 48")
end

					if not in_comments then
						curr_token := new_tabulation (text_count)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 4 then
--|#line 56 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 56")
end

					from i_ := 1 until i_ > text_count loop
						curr_token := new_eol
						update_token_list
						i_ := i_ + 1
					end
					in_comments := False
					
else
--|#line 68 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 68")
end
 
						-- comments
					curr_token := new_comment (text)
					in_comments := True	
					update_token_list					
				
end
end
else
if yy_act <= 8 then
if yy_act <= 7 then
if yy_act = 6 then
--|#line 77 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 77")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 78 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 78")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 79 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 79")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 9 then
--|#line 80 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 80")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 81 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 81")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
end
else
if yy_act <= 15 then
if yy_act <= 13 then
if yy_act <= 12 then
if yy_act = 11 then
--|#line 82 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 82")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 83 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 83")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 84 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 84")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 14 then
--|#line 85 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 85")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 86 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 86")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
else
if yy_act <= 18 then
if yy_act <= 17 then
if yy_act = 16 then
--|#line 87 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 87")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 88 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 88")
end

						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 98 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 98")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 19 then
--|#line 99 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 99")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 100 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 100")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
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
--|#line 101 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 101")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 102 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 102")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 103 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 103")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 24 then
--|#line 104 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 104")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 105 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 105")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
else
if yy_act <= 28 then
if yy_act <= 27 then
if yy_act = 26 then
--|#line 106 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 106")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 107 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 107")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 108 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 108")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 29 then
--|#line 109 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 109")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 110 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 110")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
end
else
if yy_act <= 35 then
if yy_act <= 33 then
if yy_act <= 32 then
if yy_act = 31 then
--|#line 111 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 111")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 112 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 112")
end
 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 124 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 124")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 34 then
--|#line 125 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 125")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 126 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 126")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 37 then
if yy_act = 36 then
--|#line 127 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 127")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 128 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 128")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 38 then
--|#line 129 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 129")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 130 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 130")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
end
end
else
if yy_act <= 58 then
if yy_act <= 49 then
if yy_act <= 44 then
if yy_act <= 42 then
if yy_act <= 41 then
if yy_act = 40 then
--|#line 131 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 131")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 132 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 132")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 133 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 133")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 43 then
--|#line 134 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 134")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 135 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 135")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 47 then
if yy_act <= 46 then
if yy_act = 45 then
--|#line 136 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 136")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 137 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 137")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 138 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 138")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 48 then
--|#line 139 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 139")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 140 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 140")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
else
if yy_act <= 54 then
if yy_act <= 52 then
if yy_act <= 51 then
if yy_act = 50 then
--|#line 141 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 141")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 142 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 142")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 143 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 143")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 53 then
--|#line 144 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 144")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 145 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 145")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 56 then
if yy_act = 55 then
--|#line 146 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 146")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 147 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 147")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 57 then
--|#line 148 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 148")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 149 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 149")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
end
else
if yy_act <= 68 then
if yy_act <= 63 then
if yy_act <= 61 then
if yy_act <= 60 then
if yy_act = 59 then
--|#line 150 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 150")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 151 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 151")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 152 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 152")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 62 then
--|#line 153 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 153")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 154 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 154")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 66 then
if yy_act <= 65 then
if yy_act = 64 then
--|#line 155 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 155")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 156 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 156")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 157 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 157")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 67 then
--|#line 158 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 158")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 159 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 159")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
else
if yy_act <= 73 then
if yy_act <= 71 then
if yy_act <= 70 then
if yy_act = 69 then
--|#line 160 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 160")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 161 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 161")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 162 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 162")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 72 then
--|#line 163 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 163")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 164 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 164")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 75 then
if yy_act = 74 then
--|#line 165 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 165")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 166 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 166")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 76 then
--|#line 167 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 167")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 168 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 168")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
end
end
end
else
if yy_act <= 116 then
if yy_act <= 97 then
if yy_act <= 87 then
if yy_act <= 82 then
if yy_act <= 80 then
if yy_act <= 79 then
if yy_act = 78 then
--|#line 169 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 169")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 170 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 170")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 171 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 171")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 81 then
--|#line 172 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 172")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 173 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 173")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 85 then
if yy_act <= 84 then
if yy_act = 83 then
--|#line 174 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 174")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 175 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 175")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 176 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 176")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 86 then
--|#line 177 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 177")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 178 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 178")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
else
if yy_act <= 92 then
if yy_act <= 90 then
if yy_act <= 89 then
if yy_act = 88 then
--|#line 179 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 179")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 180 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 180")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 181 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 181")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 91 then
--|#line 182 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 182")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 183 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 183")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
else
if yy_act <= 95 then
if yy_act <= 94 then
if yy_act = 93 then
--|#line 184 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 184")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 185 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 185")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
--|#line 186 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 186")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 96 then
--|#line 187 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 187")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 188 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 188")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
end
end
end
else
if yy_act <= 107 then
if yy_act <= 102 then
if yy_act <= 100 then
if yy_act <= 99 then
if yy_act = 98 then
--|#line 189 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 189")
end

										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 202 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 202")
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
										
end
else
--|#line 222 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 222")
end

										if not in_comments then
											curr_token := new_text (text)											
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
end
else
if yy_act = 101 then
--|#line 234 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 234")
end

										if not in_comments then
											curr_token := new_text (text)										
										else
											curr_token := new_comment (text)
										end
										update_token_list
										
else
--|#line 248 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 248")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
else
if yy_act <= 105 then
if yy_act <= 104 then
if yy_act = 103 then
--|#line 249 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 249")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 250 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 250")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 251 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 251")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 106 then
--|#line 252 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 252")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 253 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 253")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
end
else
if yy_act <= 112 then
if yy_act <= 110 then
if yy_act <= 109 then
if yy_act = 108 then
--|#line 254 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 254")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 255 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 255")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 256 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 256")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 111 then
--|#line 257 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 257")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 258 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 258")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
else
if yy_act <= 114 then
if yy_act = 113 then
--|#line 259 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 259")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 260 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 260")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 115 then
--|#line 261 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 261")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 262 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 262")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
end
end
end
else
if yy_act <= 135 then
if yy_act <= 126 then
if yy_act <= 121 then
if yy_act <= 119 then
if yy_act <= 118 then
if yy_act = 117 then
--|#line 263 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 263")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 264 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 264")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 265 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 265")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
if yy_act = 120 then
--|#line 266 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 266")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 267 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 267")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
else
if yy_act <= 124 then
if yy_act <= 123 then
if yy_act = 122 then
--|#line 268 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 268")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 269 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 269")
end

					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 278 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 278")
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
					
end
else
if yy_act = 125 then
--|#line 293 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 293")
end

					-- Character error. Catch-all rules (no backing up)
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 315 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 315")
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
			
end
end
end
else
if yy_act <= 131 then
if yy_act <= 129 then
if yy_act <= 128 then
if yy_act = 127 then
--|#line 329 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 329")
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
			
else
--|#line 344 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 344")
end
-- Ignore carriage return
end
else
--|#line 345 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 345")
end

							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
end
else
if yy_act = 130 then
--|#line 354 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 354")
end

							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					
else
--|#line 363 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 363")
end

						curr_token := new_space (text_count)
						update_token_list						
					
end
end
else
if yy_act <= 133 then
if yy_act = 132 then
--|#line 368 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 368")
end
						
						curr_token := new_tabulation (text_count)
						update_token_list						
					
else
--|#line 373 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 373")
end

						from i_ := 1 until i_ > text_count loop
							curr_token := new_eol
							update_token_list
							i_ := i_ + 1
						end						
					
end
else
if yy_act = 134 then
--|#line 381 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 381")
end

						curr_token := new_string (text)
						update_token_list
					
else
--|#line 387 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 387")
end

					-- Eiffel String
					if not in_comments then						
						curr_token := new_string (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
end
end
end
else
if yy_act <= 145 then
if yy_act <= 140 then
if yy_act <= 138 then
if yy_act <= 137 then
if yy_act = 136 then
--|#line 388 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 388")
end

					-- Eiffel String
					if not in_comments then						
						curr_token := new_string (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
else
--|#line 400 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 400")
end

					-- Eiffel Bit
					if not in_comments then
						curr_token := new_number (text)						
					else
						curr_token := new_comment (text)
					end
					update_token_list
					
end
else
--|#line 412 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 412")
end

						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
else
if yy_act = 139 then
--|#line 413 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 413")
end

						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 414 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 414")
end

						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
end
else
if yy_act <= 143 then
if yy_act <= 142 then
if yy_act = 141 then
--|#line 415 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 415")
end

						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 426 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 426")
end

						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
else
--|#line 427 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 427")
end

						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
else
if yy_act = 144 then
--|#line 428 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 428")
end

						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 429 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 429")
end

						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
end
end
else
if yy_act <= 150 then
if yy_act <= 148 then
if yy_act <= 147 then
if yy_act = 146 then
	yy_end := yy_end - 1
--|#line 441 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 441")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 442 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 442")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
else
--|#line 443 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 443")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
else
if yy_act = 149 then
	yy_end := yy_end - 1
--|#line 444 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 444")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 445 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 445")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
end
end
else
if yy_act <= 152 then
if yy_act = 151 then
--|#line 446 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 446")
end

							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						
else
--|#line 462 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 462")
end

					curr_token := new_text (text)
					update_token_list
					
end
else
if yy_act = 153 then
--|#line 470 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 470")
end

					-- Error (considered as text)
				if not in_comments then
					curr_token := new_text (text)
				else
					curr_token := new_comment (text)
				end
				update_token_list
				
else
--|#line 0 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 0")
end
default_action
end
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
when 0, 1 then
--|#line 0 "editor_textual_bon_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'editor_textual_bon_scanner.l' at line 0")
end
terminate
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER]
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make_filled (0, 0, 6719)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			yy_nxt_template_3 (an_array)
			yy_nxt_template_4 (an_array)
			yy_nxt_template_5 (an_array)
			yy_nxt_template_6 (an_array)
			yy_nxt_template_7 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			    0,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   27,   28,   29,   30,   31,   32,   33,
			   33,   34,   33,   33,   33,   33,   33,   33,   33,   33,
			   35,   33,   33,   33,   36,   33,   37,   38,   39,   40,
			    6,   41,   42,   43,   44,   45,   46,   47,   43,   43,
			   48,   43,   49,   43,   50,   51,   52,   53,   54,   55,
			   56,   57,   43,   43,   43,   58,   43,   43,   59,   60,
			    6,    6,    6,   61,   62,   63,   64,   65,   66,   67,
			   69,   70,   71,   72,  117,  119,  119,  119,  119,  120,

			  646,   69,   70,   71,   72,  118,  131,  121,  122,  878,
			  123,  123,  124,  124,  202,  202,  132,  878,   87,  583,
			  130,   88,  134,  134,  134,   87,  576,  108,   88,  108,
			  108,  201,  201,  201,  491,  109,   73,  203,  203,  203,
			  129,  316,  489,  130,  204,  204,  204,   73,  122,  316,
			  124,  124,  124,  124,  134,  134,  134,   89,  148,  149,
			  150,  151,  152,  153,  154,  328,  328,   74,  327,  327,
			  327,   75,   76,   77,   78,   79,   80,   81,   74,  487,
			  129,  491,   75,   76,   77,   78,   79,   80,   81,   90,
			  878,  317,  317,  489,   91,   92,   93,   94,   95,   96,

			   97,  100,  101,  102,  103,  104,  105,  106,  110,  111,
			  112,  113,  114,  115,  116,  122,  487,  123,  123,  124,
			  124,  316,  316,  155,  329,  329,  329,  126,  127,  319,
			  319,  319,  164,  453,  156,  157,  158,  159,  160,  161,
			  162,  163,  128,  165,  346,  346,  166,  129,  218,  167,
			  126,  127,  157,  158,  159,  160,  161,  162,  163,  316,
			  330,  330,  330,  157,  158,  159,  160,  161,  162,  163,
			  349,  344,  128,  134,  134,  134,  134,  135,  135,  135,
			  331,  326,  134,  134,  134,  134,  134,  134,  134,  134,
			  134,  134,  134,  134,  134,  134,  134,  134,  134,  345,

			  345,  345,  325,  134,  272,  135,  135,  135,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  135,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  135,  135,  135,
			  135,  347,  347,  347,   85,  182,  136,  137,  138,  139,
			  140,  141,  142,  135,   84,  135,  135,  168,   83,  183,
			  171,  169,  135,   82,  135,  218,  135,  135,  172,  135,
			  135,  175,  135,  135,  205,  176,  173,  170,  174,  348,
			  348,  348,  135,  200,  135,  177,  178,  135,  135,  135,
			  135,  135,  179,  180,  146,  181,  135,  184,  145,  144,
			  135,  700,  135,  135,  143,  135,  135,  185,  135,  135,

			  135,  188,  133,  186,   85,  189,  187,   84,  310,  135,
			  135,   83,  135,  135,  700,  135,  135,  135,  190,  191,
			  135,  192,  135,  135,  194,   82,  198,  214,  135,  215,
			  215,  193,  878,  135,  135,  216,  135,  135,  216,  135,
			  223,  195,  196,  206,  878,  878,  197,  215,  135,  219,
			  215,  199,  878,  878,  135,  207,  208,  209,  210,  211,
			  212,  213,  215,  217,  215,  222,  217,  878,  231,  878,
			  878,  206,  878,  216,  207,  208,  209,  210,  211,  212,
			  213,  239,  207,  208,  209,  210,  211,  212,  213,  134,
			  134,  134,  878,  220,  240,  240,  240,  207,  208,  209,

			  210,  211,  212,  213,  217,  878,  241,  241,  216,  207,
			  208,  209,  210,  211,  212,  213,  224,  225,  226,  227,
			  228,  229,  230,   87,  221,  878,   88,  878,  207,  208,
			  209,  210,  211,  212,  213,   87,  878,  878,   88,  217,
			  134,  134,  134,  878,  232,  233,  234,  235,  236,  237,
			  238,  242,  242,  242,  207,  208,  209,  210,  211,  212,
			  213,  243,  243,  243,  207,  208,  209,  210,  211,  212,
			  213,  244,  878,  878,  207,  208,  209,  210,  211,  212,
			  213,   87,  878,  878,   88,  312,  312,  312,  312,  134,
			  134,  134,  878,  308,  308,  308,  308,  878,  313,  100,

			  101,  102,  103,  104,  105,  106,  309,  134,  134,  134,
			  878,  100,  101,  102,  103,  104,  105,  106,  878,  878,
			   89,  313,  122,  310,  315,  315,  315,  315,  878,  309,
			  135,  878,   87,  878,  878,   88,  323,  323,  323,  323,
			  878,  135,  878,  878,  135,   87,  878,  135,   88,  399,
			  399,  399,   90,  878,  129,  878,  878,   91,   92,   93,
			   94,   95,   96,   97,  246,  878,  324,  247,   99,   99,
			   99,   89,  400,  400,  400,  878,  248,  478,  478,  478,
			  478,  878,  878,   99,   89,   99,   99,   99,  249,   87,
			  878,   99,   88,   99,   99,   99,   99,   99,   99,   99,

			   99,   99,   87,   90,  878,   88,  878,  878,   91,   92,
			   93,   94,   95,   96,   97,  878,   90,  878,  135,  878,
			  259,   91,   92,   93,   94,   95,   96,   97,   89,  135,
			  878,  878,  135,   87,  878,  332,   88,  135,  878,  878,
			  250,  251,  252,  253,  254,  255,  256,  257,  135,  257,
			  257,  135,   87,  878,  135,   88,  342,  317,  317,  878,
			   90,  878,  261,  261,  878,   91,   92,   93,   94,   95,
			   96,   97,   89,   87,  878,  135,   88,  265,  100,  101,
			  102,  103,  104,  105,  106,   87,  135,  486,   88,  135,
			  878,   89,  135,  333,  476,   87,  476,  878,   88,  477,

			  477,  477,  477,  755,   90,   87,  264,  135,   88,   91,
			   92,   93,   94,   95,   96,   97,   87,  878,  350,   88,
			  481,  135,  878,   90,  135,  135,  755,  272,   91,   92,
			   93,   94,   95,   96,   97,  258,  368,  258,  258,  135,
			   87,  878,  135,   88,  878,  878,  266,  266,  266,  100,
			  101,  102,  103,  104,  105,  106,  878,  878,  267,  267,
			  272,  100,  101,  102,  103,  104,  105,  106,  268,  268,
			  268,  100,  101,  102,  103,  104,  105,  106,  270,   89,
			  272,  100,  101,  102,  103,  104,  105,  106,  878,  269,
			  269,  269,  100,  101,  102,  103,  104,  105,  106,  273,

			  274,  275,  276,  277,  278,  279,  272,  134,  134,  134,
			  878,   90,  878,  878,  335,  878,   91,   92,   93,   94,
			   95,   96,   97,   87,  878,  878,   88,  878,  369,  107,
			  107,  107,  273,  274,  275,  276,  277,  278,  279,  135,
			  878,  272,  135,  878,  878,  135,  878,  878,  335,  878,
			  135,  302,  273,  274,  275,  276,  277,  278,  279,  272,
			  878,  135,   89,  361,  135,  317,  317,  135,  134,  134,
			  134,  134,  134,  134,  272,  303,  303,  303,  273,  274,
			  275,  276,  277,  278,  279,  272,  148,  149,  150,  151,
			  152,  153,  154,  878,   90,  486,  260,  260,  260,   91, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			   92,   93,   94,   95,   96,   97,   87,  878,  878,   88,
			  304,  304,  878,  273,  274,  275,  276,  277,  278,  279,
			  148,  149,  150,  151,  152,  153,  154,  878,  305,  305,
			  305,  273,  274,  275,  276,  277,  278,  279,  335,  878,
			  319,  319,  319,  307,  878,   89,  273,  274,  275,  276,
			  277,  278,  279,  878,  306,  306,  306,  273,  274,  275,
			  276,  277,  278,  279,  122,  335,  314,  314,  315,  315,
			  488,  134,  134,  134,  878,  335,  130,   90,  878,  262,
			  262,  262,   91,   92,   93,   94,   95,   96,   97,   87,
			  135,  135,   88,  878,  343,  878,  129,  878,  334,  130,

			  878,  135,  135,  878,  135,  135,  135,  135,  135,  336,
			  148,  149,  150,  151,  152,  153,  154,  135,  354,  355,
			  135,  878,  878,  135,  482,  878,  482,  878,   89,  483,
			  483,  483,  483,  878,  337,  337,  337,  148,  149,  150,
			  151,  152,  153,  154,  338,  338,  335,  148,  149,  150,
			  151,  152,  153,  154,  878,  878,  335,  494,  494,  494,
			   90,  878,  263,  263,  263,   91,   92,   93,   94,   95,
			   96,   97,  280,  878,  878,  281,  282,  283,  284,  495,
			  495,  495,  878,  878,  285,  135,  135,  135,  135,  135,
			  135,  286,  878,  287,  288,  289,  290,  291,  878,  292,

			  878,  293,  294,  295,  296,  297,  298,  299,  300,  301,
			  135,  135,  135,  878,  878,  339,  339,  339,  148,  149,
			  150,  151,  152,  153,  154,  340,  340,  340,  148,  149,
			  150,  151,  152,  153,  154,  335,  207,  208,  209,  210,
			  211,  212,  213,  135,  135,  135,  878,  878,  273,  274,
			  275,  276,  277,  278,  279,  321,  321,  321,  321,  878,
			  135,  135,  351,  360,  321,  321,  321,  321,  321,  321,
			  352,  135,  135,  135,  135,  135,  135,  370,  135,  135,
			  878,  878,  353,  135,  878,  316,  363,  321,  321,  321,
			  321,  321,  321,  214,  135,  215,  215,  135,  878,  878,

			  135,  364,  878,  377,  341,  135,  878,  148,  149,  150,
			  151,  152,  153,  154,  135,  135,  135,  878,  356,  135,
			  357,  878,  135,  135,  878,  135,  358,  365,  135,  135,
			  135,  135,  135,  359,  135,  362,  878,  135,  135,  216,
			  135,  135,  878,  878,  135,  878,  366,  135,  878,  135,
			  878,  878,  135,  367,  135,  135,  371,  372,  878,  373,
			  878,  374,  878,  135,  878,  135,  878,  135,  135,  878,
			  217,  135,  135,  375,  135,  376,  878,  135,  135,  379,
			  135,  135,  135,  135,  135,  878,  135,  378,  878,  135,
			  878,  381,  135,  135,  380,  878,  135,  135,  878,  135,

			  383,  382,  135,  135,  135,  878,  135,  878,  135,  135,
			  878,  135,  878,  135,  135,  135,  135,  135,  135,  135,
			  878,  135,  135,  384,  878,  878,  135,  878,  135,  878,
			  387,  135,  878,  135,  385,  878,  135,  135,  135,  386,
			  135,  878,  388,  135,  878,  135,  135,  878,  878,  135,
			  878,  878,  135,  878,  878,  135,  135,  135,  878,  135,
			  391,  389,  135,  135,  135,  390,  393,  878,  392,  878,
			  878,  135,  878,  395,  878,  135,  135,  135,  135,  878,
			  135,  135,  135,  394,  135,  135,  135,  135,  135,  878,
			  135,  878,  878,  135,  396,  135,  878,  135,  135,  401,

			  135,  135,  878,  398,  397,  207,  208,  209,  210,  211,
			  212,  213,  239,  207,  208,  209,  210,  211,  212,  213,
			  240,  240,  240,  207,  208,  209,  210,  211,  212,  213,
			  241,  241,  409,  207,  208,  209,  210,  211,  212,  213,
			  242,  242,  242,  207,  208,  209,  210,  211,  212,  213,
			  243,  243,  243,  207,  208,  209,  210,  211,  212,  213,
			  244,  878,  878,  207,  208,  209,  210,  211,  212,  213,
			  215,  878,  215,  215,  878,  402,  403,  404,  405,  406,
			  407,  408,  215,  878,  219,  215,  502,  502,  502,  216,
			  878,  878,  216,  878,  223,  878,  217,  206,  878,  217,

			  878,  231,  878,  878,  206,  503,  503,  503,  410,  411,
			  412,  413,  414,  415,  416,  215,  216,  215,  222,  207,
			  208,  209,  210,  211,  212,  213,  216,  878,  220,  216,
			  878,  223,  878,  878,  206,  216,  878,  135,  216,  135,
			  223,  878,  498,  206,  134,  134,  134,  217,  135,  878,
			  135,  135,  216,  135,  496,  216,  135,  223,  878,  221,
			  206,  216,  878,  207,  208,  209,  210,  211,  212,  213,
			  224,  225,  226,  227,  228,  229,  230,  232,  233,  234,
			  235,  236,  237,  238,  878,  216,  878,  878,  216,  878,
			  223,  878,  217,  206,  207,  208,  209,  210,  211,  212,

			  213,  134,  134,  134,  134,  134,  134,  224,  225,  226,
			  227,  228,  229,  230,  878,  417,  224,  225,  226,  227,
			  228,  229,  230,  216,  878,  878,  216,  878,  223,  878,
			  422,  206,  878,  224,  225,  226,  227,  228,  229,  230,
			  217,  878,  135,  217,  135,  231,  878,  878,  206,  217,
			  878,  878,  217,  135,  231,  135,  135,  206,  135,  135,
			  878,  135,  497,  419,  419,  878,  224,  225,  226,  227,
			  228,  229,  230,  217,  878,  878,  217,  878,  231,  878,
			  878,  206,  878,  217,  878,  878,  217,  878,  231,  878,
			  878,  206,  207,  208,  209,  210,  211,  212,  213,  878,

			  878,  418,  418,  418,  224,  225,  226,  227,  228,  229,
			  230,  216,  878,  878,  216,  878,  223,  878,  878,  206,
			  878,  232,  233,  234,  235,  236,  237,  238,  878,  423,
			  232,  233,  234,  235,  236,  237,  238,  207,  208,  209,
			  210,  211,  212,  213,  207,  208,  209,  210,  211,  212,
			  213,  425,  425,  878,  232,  233,  234,  235,  236,  237,
			  238,  428,  878,  878,  232,  233,  234,  235,  236,  237,
			  238,  207,  208,  209,  210,  211,  212,  213,  429,  429,
			  429,  207,  208,  209,  210,  211,  212,  213,  878,  420,
			  420,  420,  224,  225,  226,  227,  228,  229,  230,  216,

			  878,  878,  216,  878,  223,  878,  878,  206,  430,  430,
			  430,  207,  208,  209,  210,  211,  212,  213,  135,  878,
			   87,  878,  135,  431,  878,  878,  501,   87,  878,  135,
			   88,  878,  135,  504,  432,  135,  135,   88,  878,  135,
			  878,   87,  878,  878,  431,  134,  134,  134,   87,  878,
			  878,  434,  878,  135,  433,  433,  433,  433,   87,  878,
			  878,  431,  878,  878,  135,  878,   87,  135,  878,  431,
			  135,  505,  477,  477,  477,  477,  878,  421,  421,  421,
			  224,  225,  226,  227,  228,  229,  230,  217,  878,  878,
			  217,  878,  231,  878,  878,  206,  250,  251,  252,  253, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_nxt_template_3 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  254,  255,  256,  100,  101,  102,  103,  104,  105,  106,
			  100,  101,  102,  103,  104,  105,  106,  250,  251,  252,
			  253,  254,  255,  256,  250,  251,  252,  253,  254,  255,
			  256,  319,  319,  319,  250,  251,  252,  253,  254,  255,
			  256,  435,  250,  251,  252,  253,  254,  255,  256,   87,
			  878,  878,  431,  577,  577,  577,  577,  878,  878,   87,
			  878,  488,  431,  878,  878,  424,  424,  424,  232,  233,
			  234,  235,  236,  237,  238,  217,  878,  878,  217,  878,
			  231,  878,  878,  206,  475,  475,  475,  475,  878,  122,
			  878,  485,  485,  485,  485,  878,  135,  309,  878,   87,

			  506,  878,  431,  581,  581,  581,  581,  135,  878,   87,
			  135,  878,  431,  135,  310,  483,  483,  483,  483,  878,
			  309,  129,  436,  436,  436,  250,  251,  252,  253,  254,
			  255,  256,  437,  437,  878,  250,  251,  252,  253,  254,
			  255,  256,   87,  878,  878,  431,  207,  208,  209,  210,
			  211,  212,  213,  426,  426,  426,  232,  233,  234,  235,
			  236,  237,  238,  217,  878,  878,  217,  878,  231,  878,
			  878,  206,  438,  438,  438,  250,  251,  252,  253,  254,
			  255,  256,  439,  439,  439,  250,  251,  252,  253,  254,
			  255,  256,   87,  878,  878,   88,  878,  479,  479,  479,

			  479,  878,  878,  878,  492,  492,  492,  492,  878,   87,
			  480,  878,   88,  878,  878,  440,  878,  878,  250,  251,
			  252,  253,  254,  255,  256,   87,  878,  481,   88,  878,
			  878,   89,  878,  480,  324,  878,  878,   87,  878,  878,
			   88,  427,  427,  427,  232,  233,  234,  235,  236,  237,
			  238,  257,  878,  257,  257,  878,   87,  878,  878,   88,
			  135,  135,  135,   90,   89,  878,  512,  878,   91,   92,
			   93,   94,   95,   96,   97,  878,   89,  135,  878,  878,
			  135,   87,  878,  135,   88,  100,  101,  102,  103,  104,
			  105,  106,  878,  878,   87,   89,   90,   88,  135,  135,

			  135,   91,   92,   93,   94,   95,   96,   97,   90,   87,
			  878,  135,   88,   91,   92,   93,   94,   95,   96,   97,
			   89,   87,  135,  878,   88,  135,  878,   90,  135,  507,
			  878,  878,   91,   92,   93,   94,   95,   96,   97,  258,
			  878,  258,  258,  878,   87,  878,  878,   88,  493,  493,
			  493,  493,   90,  642,  642,  642,  642,   91,   92,   93,
			   94,   95,   96,   97,   87,  878,  878,   88,  878,  878,
			  100,  101,  102,  103,  104,  105,  106,   87,  324,  878,
			   88,  878,  878,   89,  878,  100,  101,  102,  103,  104,
			  105,  106,  878,  878,  135,  878,  517,  100,  101,  102,

			  103,  104,  105,  106,  878,  135,  508,  135,  135,  509,
			  135,  135,  878,  135,  878,   90,  878,  135,  878,  510,
			   91,   92,   93,   94,   95,   96,   97,   87,  135,  878,
			   88,  135,  878,  878,  135,  511,  878,  443,  443,  443,
			  100,  101,  102,  103,  104,  105,  106,  878,  878,  878,
			  444,  444,  444,  100,  101,  102,  103,  104,  105,  106,
			  878,  878,  575,  575,  575,  575,   89,  273,  274,  275,
			  276,  277,  278,  279,  878,  878,  273,  274,  275,  276,
			  277,  278,  279,  445,  273,  274,  275,  276,  277,  278,
			  279,  878,  576,  643,  643,  643,  643,  878,   90,  451,

			  441,  441,  441,   91,   92,   93,   94,   95,   96,   97,
			   87,  878,  878,   88,  878,  878,  446,  446,  446,  273,
			  274,  275,  276,  277,  278,  279,  878,  878,  878,  447,
			  447,  135,  273,  274,  275,  276,  277,  278,  279,  878,
			  135,  135,  135,  515,  513,  135,  452,  878,  135,   89,
			  514,  135,  135,  454,  135,  135,  878,  135,  135,  878,
			  448,  448,  448,  273,  274,  275,  276,  277,  278,  279,
			  455,  273,  274,  275,  276,  277,  278,  279,  878,  878,
			  878,   90,  457,  442,  442,  442,   91,   92,   93,   94,
			   95,   96,   97,  458,  878,  449,  449,  449,  273,  274,

			  275,  276,  277,  278,  279,  459,  878,  878,  450,  878,
			  878,  273,  274,  275,  276,  277,  278,  279,  273,  274,
			  275,  276,  277,  278,  279,  273,  274,  275,  276,  277,
			  278,  279,  460,  207,  208,  209,  210,  211,  212,  213,
			  878,  878,  273,  274,  275,  276,  277,  278,  279,  456,
			  456,  456,  456,  461,  273,  274,  275,  276,  277,  278,
			  279,  462,  878,  878,  878,  273,  274,  275,  276,  277,
			  278,  279,  463,  878,  878,  135,  135,  273,  274,  275,
			  276,  277,  278,  279,  464,  135,  135,  135,  878,  135,
			  135,  465,  135,  135,  516,  878,  135,  878,  466,  135,

			  878,  878,  135,  521,  273,  274,  275,  276,  277,  278,
			  279,  467,  273,  274,  275,  276,  277,  278,  279,  468,
			  580,  580,  580,  580,  878,  273,  274,  275,  276,  277,
			  278,  279,  469,  273,  274,  275,  276,  277,  278,  279,
			  470,  878,  878,  878,  273,  274,  275,  276,  277,  278,
			  279,  471,  582,  582,  582,  582,  273,  274,  275,  276,
			  277,  278,  279,  273,  274,  275,  276,  277,  278,  279,
			  273,  274,  275,  276,  277,  278,  279,  472,  647,  647,
			  647,  647,  583,  273,  274,  275,  276,  277,  278,  279,
			  878,  273,  274,  275,  276,  277,  278,  279,  878,  878,

			  878,  878,  878,  878,  273,  274,  275,  276,  277,  278,
			  279,  878,  273,  274,  275,  276,  277,  278,  279,  135,
			  878,  878,  878,  273,  274,  275,  276,  277,  278,  279,
			  135,  878,  878,  135,  878,  878,  135,  878,  579,  519,
			  579,  878,  878,  580,  580,  580,  580,  878,  878,  273,
			  274,  275,  276,  277,  278,  279,  878,  878,  878,  107,
			  107,  107,  273,  274,  275,  276,  277,  278,  279,  107,
			  107,  107,  273,  274,  275,  276,  277,  278,  279,  878,
			  107,  107,  107,  273,  274,  275,  276,  277,  278,  279,
			  107,  107,  107,  273,  274,  275,  276,  277,  278,  279,

			  473,  473,  473,  273,  274,  275,  276,  277,  278,  279,
			  474,  474,  474,  273,  274,  275,  276,  277,  278,  279,
			  122,  878,  484,  484,  485,  485,  335,  135,  135,  878,
			  878,  518,  130,  335,  878,  878,  878,  135,  135,  522,
			  335,  135,  135,  878,  135,  135,  878,  335,  135,  878,
			  520,  135,  129,  878,  135,  130,  321,  321,  321,  321,
			  335,  135,  878,  135,  878,  321,  321,  321,  321,  321,
			  321,  335,  135,  878,  135,  135,  878,  135,  135,  523,
			  135,  878,  524,  878,  878,  878,  490,  878,  321,  321,
			  321,  321,  321,  321,  649,  649,  649,  649,  148,  149, yy_Dummy>>,
			1, 1000, 2000)
		end

	yy_nxt_template_4 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  150,  151,  152,  153,  154,  148,  149,  150,  151,  152,
			  153,  154,  148,  149,  150,  151,  152,  153,  154,  148,
			  149,  150,  151,  152,  153,  154,  878,  878,  878,  499,
			  499,  499,  148,  149,  150,  151,  152,  153,  154,  878,
			  500,  500,  500,  148,  149,  150,  151,  152,  153,  154,
			  525,  135,  135,  135,  878,  878,  878,  527,  699,  699,
			  699,  699,  135,  135,  135,  526,  135,  135,  135,  135,
			  135,  135,  135,  135,  878,  878,  529,  530,  878,  528,
			  531,  878,  135,  135,  135,  135,  135,  135,  135,  135,
			  135,  135,  135,  135,  532,  878,  878,  135,  878,  533,

			  135,  535,  878,  135,  135,  878,  135,  135,  135,  135,
			  135,  135,  536,  135,  135,  534,  878,  135,  878,  135,
			  135,  878,  135,  878,  135,  135,  878,  135,  135,  135,
			  135,  135,  537,  135,  135,  538,  878,  135,  878,  135,
			  135,  878,  135,  135,  135,  135,  135,  135,  135,  878,
			  135,  878,  539,  135,  878,  878,  878,  135,  541,  135,
			  878,  135,  135,  878,  135,  135,  540,  135,  135,  135,
			  135,  135,  135,  401,  542,  135,  878,  135,  135,  878,
			  135,  543,  401,  135,  135,  878,  135,  544,  135,  135,
			  878,  135,  401,  878,  135,  135,  545,  546,  135,  135,

			  135,  135,  401,  135,  135,  878,  135,  548,  547,  135,
			  135,  549,  401,  135,  878,  135,  135,  878,  135,  878,
			  135,  135,  401,  135,  135,  135,  135,  878,  550,  551,
			  878,  878,  401,  878,  878,  135,  135,  878,  135,  135,
			  409,  135,  135,  703,  703,  703,  703,  878,  409,  402,
			  403,  404,  405,  406,  407,  408,  878,  552,  402,  403,
			  404,  405,  406,  407,  408,  553,  553,  553,  402,  403,
			  404,  405,  406,  407,  408,  554,  554,  409,  402,  403,
			  404,  405,  406,  407,  408,  555,  555,  555,  402,  403,
			  404,  405,  406,  407,  408,  556,  556,  556,  402,  403,

			  404,  405,  406,  407,  408,  557,  409,  878,  402,  403,
			  404,  405,  406,  407,  408,  878,  410,  411,  412,  413,
			  414,  415,  416,  558,  410,  411,  412,  413,  414,  415,
			  416,  409,  584,  878,  485,  485,  485,  485,  878,  878,
			  878,  409,  878,  878,  878,  585,  585,  585,  585,  878,
			  559,  559,  559,  410,  411,  412,  413,  414,  415,  416,
			  409,  878,  216,  878,  324,  216,  878,  223,  878,  216,
			  206,  878,  216,  878,  223,  324,  878,  206,  878,  560,
			  560,  878,  410,  411,  412,  413,  414,  415,  416,  216,
			  878,  878,  216,  878,  223,  878,  878,  206,  493,  493,

			  493,  493,  878,  878,  561,  561,  561,  410,  411,  412,
			  413,  414,  415,  416,  562,  562,  562,  410,  411,  412,
			  413,  414,  415,  416,  216,  878,  878,  216,  324,  223,
			  878,  878,  206,  563,  878,  878,  410,  411,  412,  413,
			  414,  415,  416,  224,  225,  226,  227,  228,  229,  230,
			  224,  225,  226,  227,  228,  229,  230,  217,  878,  878,
			  217,  697,  231,  697,  878,  206,  698,  698,  698,  698,
			  224,  225,  226,  227,  228,  229,  230,  217,  878,  878,
			  217,  878,  231,  878,  217,  206,  878,  217,  878,  231,
			  878,  217,  206,  878,  217,  878,  231,  878,  878,  206,

			  878,  574,  574,  574,  574,  224,  225,  226,  227,  228,
			  229,  230,  216,  135,  309,  216,  878,  223,  135,  878,
			  206,  878,  586,  878,  587,  878,  878,  135,  878,  135,
			  135,  310,  135,  432,  878,  135,  431,  309,  232,  233,
			  234,  235,  236,  237,  238,   87,  878,  878,  431,  704,
			  704,  704,  704,  878,  432,  878,  878,  431,  232,  233,
			  234,  235,  236,  237,  238,  232,  233,  234,  235,  236,
			  237,  238,  232,  233,  234,  235,  236,  237,  238,   99,
			   87,  878,  878,  431,  706,  706,  706,  706,  878,  878,
			  564,  564,  564,  224,  225,  226,  227,  228,  229,  230,

			  216,  878,  878,  216,  878,  223,  878,  878,  206,  250,
			  251,  252,  253,  254,  255,  256,  578,  578,  578,  578,
			  878,  250,  251,  252,  253,  254,  255,  256,  878,  480,
			  250,  251,  252,  253,  254,  255,  256,   87,  878,  878,
			  431,  878,  878,  878,   87,  878,  481,  431,  878,  878,
			  878,   87,  480,  135,  431,  878,  250,  251,  252,  253,
			  254,  255,  256,   87,  135,  878,  431,  135,  878,  878,
			  135,  878,  878,   87,  878,  878,  431,  878,  565,  565,
			  565,  224,  225,  226,  227,  228,  229,  230,  217,  878,
			  878,  217,  878,  231,  878,  878,  206,  878,  878,  878,

			  273,  274,  275,  276,  277,  278,  279,  878,  878,   87,
			  878,  878,   88,  250,  251,  252,  253,  254,  255,  256,
			  250,  251,  252,  253,  254,  255,  256,  250,  251,  252,
			  253,  254,  255,  256,  878,  878,  569,  569,  569,  250,
			  251,  252,  253,  254,  255,  256,  570,  570,  570,  250,
			  251,  252,  253,  254,  255,  256,   87,  878,  878,   88,
			  698,  698,  698,  698,  878,  878,  566,  566,  566,  232,
			  233,  234,  235,  236,  237,  238,  217,  878,  878,  217,
			  878,  231,  878,  135,  206,  100,  101,  102,  103,  104,
			  105,  106,  135,   87,  135,   89,   88,  588,  878,  878,

			  135,  878,  878,  135,  878,  591,  135,  878,  135,  135,
			   87,  878,  584,   88,  484,  484,  485,  485,  878,  135,
			  878,  878,  135,  878,  130,  135,  589,   90,  878,  135,
			  878,  878,   91,   92,   93,   94,   95,   96,   97,  878,
			  135,  878,  878,  135,  324,  878,  135,  130,  592,   89,
			  878,  878,  878,  878,  567,  567,  567,  232,  233,  234,
			  235,  236,  237,  238,   87,  878,  878,  431,  878,  100,
			  101,  102,  103,  104,  105,  106,   99,  568,  568,  568,
			  568,   90,  878,  878,  878,  878,   91,   92,   93,   94,
			   95,   96,   97,  273,  274,  275,  276,  277,  278,  279,

			  273,  274,  275,  276,  277,  278,  279,  878,  878,  878,
			  878,  273,  274,  275,  276,  277,  278,  279,  878,  571,
			  571,  571,  273,  274,  275,  276,  277,  278,  279,  335,
			  878,  878,  641,  641,  641,  641,  335,  878,  878,  401,
			  250,  251,  252,  253,  254,  255,  256,  878,  878,  878,
			  878,  572,  572,  572,  273,  274,  275,  276,  277,  278,
			  279,  878,  576,  698,  698,  698,  698,  878,  878,  573,
			  456,  456,  456,  456,  878,  878,  107,  107,  107,  273,
			  274,  275,  276,  277,  278,  279,  878,  107,  107,  107,
			  273,  274,  275,  276,  277,  278,  279,  878,  401,  878, yy_Dummy>>,
			1, 1000, 3000)
		end

	yy_nxt_template_5 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  878,  148,  149,  150,  151,  152,  153,  154,  148,  149,
			  150,  151,  152,  153,  154,  402,  403,  404,  405,  406,
			  407,  408,  273,  274,  275,  276,  277,  278,  279,  135,
			  878,  593,  878,  273,  274,  275,  276,  277,  278,  279,
			  135,  135,  135,  135,  878,  135,  135,  590,  135,  595,
			  135,  135,  135,  878,  878,  594,  878,  878,  135,  878,
			  135,  135,  135,  135,  135,  135,  135,  135,  135,  596,
			  597,  135,  599,  135,  402,  403,  404,  405,  406,  407,
			  408,  135,  135,  135,  135,  135,  135,  135,  598,  135,
			  600,  135,  135,  602,  878,  135,  135,  878,  135,  601,

			  135,  135,  135,  603,  878,  135,  878,  135,  135,  135,
			  135,  135,  135,  604,  135,  135,  607,  135,  135,  605,
			  135,  135,  878,  135,  878,  608,  135,  135,  606,  135,
			  135,  610,  135,  135,  878,  135,  878,  878,  135,  135,
			  135,  135,  135,  135,  878,  135,  135,  878,  135,  609,
			  135,  611,  135,  135,  135,  135,  135,  878,  135,  135,
			  878,  135,  878,  878,  612,  135,  878,  878,  135,  135,
			  135,  135,  135,  135,  135,  135,  614,  613,  615,  135,
			  135,  135,  878,  135,  878,  617,  616,  878,  135,  135,
			  135,  135,  135,  618,  878,  619,  135,  135,  135,  878,

			  621,  620,  135,  135,  622,  878,  135,  135,  135,  135,
			  878,  135,  878,  135,  135,  878,  135,  135,  135,  135,
			  135,  623,  135,  135,  135,  624,  135,  135,  135,  135,
			  625,  135,  401,  135,  135,  878,  135,  627,  135,  135,
			  135,  135,  401,  135,  135,  135,  135,  135,  878,  628,
			  878,  626,  629,  401,  878,  878,  135,  135,  135,  135,
			  409,  135,  135,  135,  135,  630,  135,  135,  135,  135,
			  632,  135,  135,  401,  135,  878,  878,  878,  135,  135,
			  631,  135,  409,  135,  135,  878,  135,  135,  878,  135,
			  135,  633,  409,  135,  878,  878,  135,  878,  135,  409,

			  878,  135,  878,  878,  135,  878,  878,  878,  402,  403,
			  404,  405,  406,  407,  408,  409,  878,  878,  402,  403,
			  404,  405,  406,  407,  408,  409,  634,  634,  634,  402,
			  403,  404,  405,  406,  407,  408,  410,  411,  412,  413,
			  414,  415,  416,  878,  878,  878,  635,  635,  635,  402,
			  403,  404,  405,  406,  407,  408,  878,  878,  410,  411,
			  412,  413,  414,  415,  416,  878,  878,  878,  410,  411,
			  412,  413,  414,  415,  416,  410,  411,  412,  413,  414,
			  415,  416,   87,  878,  878,  431,  878,  878,  636,  636,
			  636,  410,  411,  412,  413,  414,  415,  416,  637,  637,

			  637,  410,  411,  412,  413,  414,  415,  416,  216,  639,
			  878,  216,  878,  223,  878,  216,  206,  878,  216,  878,
			  223,  878,  217,  206,  878,  217,  878,  231,  878,  217,
			  206,  878,  217,  878,  231,  878,  878,  206,  273,  274,
			  275,  276,  277,  278,  279,   87,  878,  878,  431,  878,
			  878,  878,  574,  574,  574,  574,  135,  135,  250,  251,
			  252,  253,  254,  255,  256,  640,  878,  135,  135,  652,
			  135,  135,  878,  135,  135,  878,  653,  749,  749,  749,
			  749,  273,  274,  275,  276,  277,  278,  279,  640,  224,
			  225,  226,  227,  228,  229,  230,  224,  225,  226,  227,

			  228,  229,  230,  232,  233,  234,  235,  236,  237,  238,
			  232,  233,  234,  235,  236,  237,  238,   87,  878,  878,
			  431,  250,  251,  252,  253,  254,  255,  256,  878,   99,
			  638,  638,  638,  638,  644,  644,  644,  644,  645,  645,
			  645,  645,  648,  648,  648,  648,  878,  480,  644,  644,
			  644,  644,  135,  651,  878,  493,  493,  493,  493,  878,
			  135,  650,  878,  135,  481,  654,  135,  878,  646,  135,
			  480,  135,  583,  655,  135,  135,  878,  135,  698,  698,
			  698,  698,  878,  878,  650,  129,  135,  878,  878,  135,
			  135,  878,  135,  250,  251,  252,  253,  254,  255,  256,

			  878,  135,  135,  135,  135,  878,  657,  135,  576,  656,
			  135,  878,  878,  135,  135,  135,  135,  135,  878,  135,
			  135,  135,  660,  658,  135,  135,  135,  135,  659,  135,
			  135,  878,  135,  878,  662,  135,  135,  135,  663,  135,
			  878,  135,  661,  878,  664,  135,  135,  135,  135,  135,
			  135,  135,  665,  666,  135,  135,  135,  135,  878,  135,
			  878,  135,  135,  668,  667,  878,  135,  135,  135,  135,
			  878,  135,  135,  135,  135,  135,  669,  670,  671,  878,
			  135,  878,  878,  878,  135,  135,  135,  135,  878,  135,
			  135,  135,  135,  672,  135,  135,  135,  135,  673,  135,

			  135,  878,  135,  878,  135,  135,  135,  878,  878,  135,
			  878,  135,  135,  676,  135,  675,  135,  674,  135,  135,
			  135,  135,  135,  878,  135,  135,  878,  878,  677,  878,
			  878,  135,  135,  678,  135,  135,  135,  135,  135,  135,
			  135,  135,  135,  135,  135,  679,  135,  878,  135,  135,
			  878,  135,  680,  681,  135,  135,  135,  135,  135,  682,
			  135,  135,  135,  878,  135,  135,  878,  135,  685,  135,
			  135,  135,  878,  683,  135,  135,  135,  684,  135,  878,
			  135,  135,  878,  135,  687,  135,  135,  135,  686,  401,
			  135,  878,  878,  135,  135,  135,  135,  401,  878,  135,

			  878,  878,  135,  688,  135,  135,  135,  409,  135,  135,
			  878,  135,  135,  135,  135,  135,  691,  689,  135,  409,
			  878,  690,  878,  878,  135,  135,   87,  135,  135,  431,
			  135,  692,  135,  135,  693,  878,  878,  135,   99,  694,
			  878,  135,  878,  135,  135,  878,  135,  135,  135,  135,
			  135,  135,  135,  696,  135,  135,  695,  878,  135,  878,
			  702,  702,  702,  702,  878,  402,  403,  404,  405,  406,
			  407,  408,  878,  402,  403,  404,  405,  406,  407,  408,
			  878,  878,  878,  410,  411,  412,  413,  414,  415,  416,
			  646,  705,  705,  705,  705,  410,  411,  412,  413,  414,

			  415,  416,  250,  251,  252,  253,  254,  255,  256,  644,
			  644,  644,  644,  878,  709,  709,  709,  709,  707,  135,
			  707,  583,  701,  705,  705,  705,  705,  710,  878,  135,
			  135,  878,  878,  135,  878,  878,  135,  135,  711,  878,
			  135,  135,  135,  135,  712,  701,  135,  878,  135,  135,
			  710,  135,  135,  135,  135,  135,  135,  878,  135,  135,
			  135,  135,  878,  135,  714,  135,  713,  878,  878,  715,
			  135,  878,  135,  878,  716,  135,  135,  717,  135,  135,
			  878,  135,  135,  878,  135,  135,  878,  135,  135,  878,
			  135,  135,  878,  878,  135,  135,  135,  878,  878,  135, yy_Dummy>>,
			1, 1000, 4000)
		end

	yy_nxt_template_6 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  878,  135,  135,  718,  719,  135,  135,  135,  878,  135,
			  135,  878,  720,  878,  721,  135,  135,  878,  878,  135,
			  722,  135,  135,  135,  135,  724,  135,  135,  723,  135,
			  135,  135,  135,  878,  135,  878,  878,  135,  725,  135,
			  135,  135,  135,  878,  135,  135,  878,  135,  135,  135,
			  135,  726,  878,  135,  727,  878,  135,  878,  135,  135,
			  135,  878,  728,  135,  878,  135,  135,  135,  135,  135,
			  729,  135,  135,  135,  135,  135,  135,  878,  135,  135,
			  730,  135,  878,  733,  135,  135,  878,  731,  135,  878,
			  135,  135,  734,  135,  135,  878,  135,  135,  732,  135,

			  135,  135,  736,  135,  878,  735,  135,  878,  135,  135,
			  135,  737,  135,  135,  878,  135,  135,  878,  135,  135,
			  878,  738,  135,  135,  135,  135,  754,  754,  754,  754,
			  740,  878,  135,  878,  135,  135,  878,  135,  135,  135,
			  135,  135,  739,  135,  135,  878,  135,  878,  135,  135,
			  135,  878,  741,  135,  878,  135,  135,  878,  135,  135,
			  135,  135,  135,  742,  743,  135,  878,  135,  135,  878,
			  745,  135,  135,  878,  135,  878,  744,  135,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  747,  746,  135,
			  135,  135,  878,  748,  135,  135,  878,  135,  878,  878,

			  878,  135,  878,  878,  135,  878,  135,  135,  750,  135,
			  750,  878,  135,  751,  751,  751,  751,  752,  878,  752,
			  878,  878,  753,  753,  753,  753,  753,  753,  753,  753,
			  705,  705,  705,  705,  756,  756,  756,  756,  705,  705,
			  705,  705,  757,  757,  757,  757,  758,  135,  758,  878,
			  878,  759,  759,  759,  759,  755,  646,  135,  135,  135,
			  878,  135,  878,  878,  135,  878,  760,  761,  135,  135,
			  135,  135,  481,  135,  135,  878,  135,  135,  755,  878,
			  135,  878,  135,  135,  878,  878,  135,  135,  135,  135,
			  762,  135,  878,  135,  135,  763,  135,  764,  135,  135,

			  135,  135,  135,  135,  135,  878,  135,  135,  878,  135,
			  878,  135,  766,  135,  878,  765,  135,  878,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  768,  135,  769,
			  767,  135,  135,  751,  751,  751,  751,  878,  135,  878,
			  135,  135,  135,  135,  135,  135,  135,  771,  135,  135,
			  135,  135,  878,  770,  135,  878,  878,  135,  878,  135,
			  135,  135,  878,  878,  135,  878,  878,  135,  878,  772,
			  135,  135,  135,  135,  135,  878,  135,  135,  773,  135,
			  135,  878,  878,  135,  878,  774,  135,  878,  135,  135,
			  135,  135,  878,  135,  135,  878,  135,  135,  135,  135,

			  775,  776,  135,  135,  878,  135,  878,  878,  135,  135,
			  878,  779,  135,  135,  135,  135,  878,  135,  135,  135,
			  135,  777,  135,  135,  135,  135,  778,  135,  878,  135,
			  135,  878,  780,  135,  135,  135,  878,  135,  135,  782,
			  135,  781,  135,  878,  135,  878,  135,  135,  784,  135,
			  135,  783,  135,  135,  135,  135,  135,  135,  785,  135,
			  786,  135,  135,  135,  787,  135,  789,  878,  135,  878,
			  878,  135,  135,  135,  788,  135,  135,  135,  135,  135,
			  135,  878,  135,  135,  790,  791,  791,  791,  791,  753,
			  753,  753,  753,  135,  878,  878,  135,  878,  878,  135,

			  753,  753,  753,  753,  792,  792,  792,  792,  878,  878,
			  878,  793,  878,  793,  878,  576,  794,  794,  794,  794,
			  704,  704,  704,  704,  759,  759,  759,  759,  795,  795,
			  795,  795,  796,  755,  135,  878,  797,  878,  749,  749,
			  749,  749,  878,  135,  878,  135,  135,  878,  135,  135,
			  481,  135,  135,  799,  878,  878,  755,  878,  583,  878,
			  801,  135,  135,  135,  135,  878,  135,  135,  576,  135,
			  135,  798,  135,  135,  800,  135,  135,  135,  135,  135,
			  878,  135,  135,  794,  794,  794,  794,  878,  135,  802,
			  878,  135,  135,  135,  135,  135,  135,  135,  135,  803,

			  804,  135,  806,  878,  878,  805,  878,  878,  135,  135,
			  135,  135,  135,  135,  135,  135,  135,  807,  135,  135,
			  135,  135,  135,  135,  135,  878,  135,  135,  878,  135,
			  135,  878,  878,  135,  808,  878,  135,  878,  135,  135,
			  135,  135,  135,  135,  135,  878,  135,  135,  809,  135,
			  135,  878,  135,  135,  878,  135,  135,  135,  135,  135,
			  878,  135,  811,  878,  135,  810,  135,  135,  135,  135,
			  135,  135,  135,  878,  135,  135,  878,  135,  878,  135,
			  135,  135,  878,  812,  135,  878,  135,  135,  878,  813,
			  135,  878,  815,  135,  135,  878,  135,  135,  135,  814,

			  135,  878,  817,  135,  878,  135,  816,  135,  135,  135,
			  878,  135,  135,  135,  878,  135,  135,  878,  135,  135,
			  135,  135,  878,  878,  135,  878,  818,  819,  878,  878,
			  878,  135,  878,  878,  135,  135,  878,  135,  820,  820,
			  820,  820,  756,  756,  756,  756,  135,  135,  135,  135,
			  878,  878,  821,  878,  822,  878,  135,  878,  135,  135,
			  135,  135,  135,  878,  135,  135,  878,  135,  646,  135,
			  135,  135,  583,  135,  135,  823,  135,  135,  825,  824,
			  135,  135,  878,  826,  878,  135,  135,  135,  878,  135,
			  135,  878,  135,  135,  878,  135,  135,  828,  135,  135,

			  135,  135,  135,  135,  878,  827,  135,  878,  135,  135,
			  135,  878,  135,  831,  878,  135,  878,  135,  829,  135,
			  135,  135,  830,  135,  135,  135,  135,  135,  135,  135,
			  135,  135,  878,  878,  832,  878,  878,  834,  135,  878,
			  135,  135,  878,  135,  833,  878,  135,  135,  135,  135,
			  878,  135,  135,  878,  135,  135,  135,  835,  836,  878,
			  837,  135,  878,  878,  878,  135,  878,  135,  878,  839,
			  135,  135,  135,  135,  135,  135,  135,  135,  838,  135,
			  135,  135,  135,  135,  878,  841,  135,  792,  792,  792,
			  792,  878,  135,  135,  135,  135,  135,  878,  135,  135,

			  840,  135,  135,  878,  135,  135,  878,  842,  135,  135,
			  135,  135,  135,  135,  844,  135,  843,  646,  135,  878,
			  135,  845,  135,  135,  135,  878,  135,  135,  878,  135,
			  135,  878,  135,  135,  135,  135,  135,  878,  135,  135,
			  135,  846,  847,  135,  135,  135,  135,  878,  135,  135,
			  878,  135,  878,  848,  135,  135,  850,  878,  135,  135,
			  135,  135,  878,  135,  849,  135,  135,  135,  135,  135,
			  135,  135,  878,  135,  851,  852,  135,  135,  135,  135,
			  135,  135,  878,  135,  135,  878,  135,  853,  135,  135,
			  135,  135,  878,  135,  135,  878,  854,  135,  135,  857, yy_Dummy>>,
			1, 1000, 5000)
		end

	yy_nxt_template_7 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  135,  878,  878,  135,  878,  878,  135,  135,  135,  135,
			  135,  135,  135,  135,  855,  856,  135,  135,  135,  135,
			  878,  135,  878,  858,  135,  878,  135,  135,  135,  878,
			  135,  135,  859,  135,  135,  135,  135,  135,  135,  878,
			  135,  135,  878,  135,  135,  135,  135,  862,  878,  135,
			  860,  878,  135,  878,  135,  861,  135,  878,  135,  135,
			  878,  135,  135,  135,  135,  135,  878,  878,  135,  878,
			  878,  863,  135,  135,  135,  878,  878,  135,  878,  878,
			  135,  864,  135,  135,  135,  878,  135,  135,  878,  135,
			  135,  865,  866,  135,  135,  135,  135,  878,  878,  135,

			  878,  878,  135,  135,  135,  135,  135,  878,  135,  135,
			  869,  867,  868,  135,  135,  135,  135,  135,  135,  135,
			  135,  135,  135,  871,  135,  878,  878,  878,  878,  878,
			  878,  135,  135,  135,  135,  135,  135,  135,  135,  870,
			  135,  135,  135,  135,  135,  135,  135,  878,  135,  135,
			  878,  873,  878,  135,  878,  135,  878,  878,  135,  878,
			  135,  135,  135,  872,  135,  135,  878,  135,  135,  135,
			  135,  135,  878,  135,  135,  878,  874,  135,  135,  875,
			  135,  876,  135,  135,  135,  878,  135,  135,  878,  135,
			  135,  135,  135,  135,  877,  135,  135,  878,  135,  135,

			  135,  878,  135,  878,  878,  135,  878,  878,  135,  135,
			  878,  135,  135,  878,  135,  135,  878,  135,   68,   68,
			   68,   68,   68,   68,   68,   68,   68,   68,   68,   68,
			   68,   68,   68,   68,   68,   68,   68,   68,   68,   68,
			   68,   86,   86,  878,   86,   86,   86,   86,   86,   86,
			   86,   86,   86,   86,   86,   86,   86,   86,   86,   86,
			   86,   86,   86,   86,   98,  878,  878,  878,  878,  878,
			  878,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   98,   98,   98,   98,   98,   99,   99,  878,
			   99,   99,   99,   99,   99,   99,   99,   99,   99,   99,

			   99,   99,   99,   99,   99,   99,   99,   99,   99,   99,
			  107,  107,  878,  107,  107,  107,  107,  878,  107,  107,
			  107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
			  107,  107,  107,  125,  125,  125,  125,  125,  125,  125,
			  125,  125,  125,  125,  125,  125,  125,  147,  147,  878,
			  147,  147,  147,  878,  878,  147,  147,  147,  147,  147,
			  147,  147,  147,  147,  147,  147,  147,  147,  147,  147,
			  135,  135,  135,  135,  135,  135,  135,  135,  135,  135,
			  135,  135,  135,  135,  206,  878,  878,  206,  878,  206,
			  206,  206,  206,  206,  206,  206,  206,  206,  206,  206,

			  206,  206,  206,  206,  206,  206,  206,  220,  220,  878,
			  220,  220,  220,  220,  220,  220,  220,  220,  220,  220,
			  220,  220,  220,  220,  220,  220,  220,  220,  220,  220,
			  221,  221,  878,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
			  221,  221,  221,  245,  245,  878,  245,  245,  245,  245,
			  245,  245,  245,  245,  245,  245,  245,  245,  245,  245,
			  245,  245,  245,  245,  245,  245,  271,  878,  878,  878,
			  878,  271,  271,  271,  271,  271,  271,  271,  271,  271,
			  271,  271,  271,  271,  271,  271,  271,  271,  271,  311,

			  311,  311,  311,  311,  311,  311,  311,  878,  311,  311,
			  311,  311,  311,  311,  311,  311,  311,  311,  311,  311,
			  311,  311,  318,  318,  318,  318,  318,  318,  318,  318,
			  318,  318,  318,  318,  318,  320,  320,  320,  320,  320,
			  320,  320,  320,  320,  320,  320,  320,  320,  322,  322,
			  322,  322,  322,  322,  322,  322,  322,  322,  322,  322,
			  322,  216,  216,  878,  216,  216,  216,  878,  216,  216,
			  216,  216,  216,  216,  216,  216,  216,  216,  216,  216,
			  216,  216,  216,  216,  217,  217,  878,  217,  217,  217,
			  878,  217,  217,  217,  217,  217,  217,  217,  217,  217,

			  217,  217,  217,  217,  217,  217,  217,  708,  708,  708,
			  708,  708,  708,  708,  708,  878,  708,  708,  708,  708,
			  708,  708,  708,  708,  708,  708,  708,  708,  708,  708,
			    5,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,

			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878, yy_Dummy>>,
			1, 720, 6000)
		end

	yy_chk_template: SPECIAL [INTEGER]
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make_filled (0, 0, 6719)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			yy_chk_template_3 (an_array)
			yy_chk_template_4 (an_array)
			yy_chk_template_5 (an_array)
			yy_chk_template_6 (an_array)
			yy_chk_template_7 (an_array)
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
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    3,    3,    3,    3,   22,   23,   23,   23,   23,   24,

			  792,    4,    4,    4,    4,   22,   30,   24,   26,  125,
			   26,   26,   26,   26,   64,   64,   30,  130,   12,  756,
			   26,   12,   61,   61,   61,   15,  749,   16,   15,   16,
			   16,   63,   63,   63,  491,   16,    3,   65,   65,   65,
			   26,  125,  489,   26,   66,   66,   66,    4,   27,  130,
			   27,   27,   27,   27,  136,  136,  136,   12,   41,   41,
			   41,   41,   41,   41,   41,  139,  139,    3,  138,  138,
			  138,    3,    3,    3,    3,    3,    3,    3,    4,  487,
			   27,  322,    4,    4,    4,    4,    4,    4,    4,   12,
			  316,  126,  126,  320,   12,   12,   12,   12,   12,   12,

			   12,   15,   15,   15,   15,   15,   15,   15,   16,   16,
			   16,   16,   16,   16,   16,   25,  318,   25,   25,   25,
			   25,  126,  316,   42,  140,  140,  140,   25,   25,  127,
			  127,  127,   44,  282,   42,   43,   43,   43,   43,   43,
			   43,   43,   25,   44,  160,  160,   44,   25,  218,   44,
			   25,   25,   42,   42,   42,   42,   42,   42,   42,  127,
			  141,  141,  141,   44,   44,   44,   44,   44,   44,   44,
			  163,  158,   25,   33,   33,   33,   33,  157,  157,  157,
			  142,  137,   33,   33,   33,   33,   33,   33,   33,   33,
			   33,   33,   33,   33,   33,   33,   33,   33,   33,  159,

			  159,  159,  131,   33,  108,   33,   33,   33,   33,   33,
			   33,   33,   33,   33,   33,   33,   33,   33,   33,   33,
			   33,   33,   33,   33,   33,   33,   33,   33,   33,   33,
			   33,  161,  161,  161,   85,   51,   33,   33,   33,   33,
			   33,   33,   33,   45,   84,   46,   51,   45,   83,   51,
			   46,   45,   51,   82,   45,   70,   46,   45,   46,   46,
			   45,   47,   46,   48,   67,   47,   46,   45,   46,  162,
			  162,  162,   47,   62,   48,   47,   48,   48,   47,   49,
			   48,   50,   48,   49,   38,   50,   52,   52,   36,   35,
			   49,  643,   50,   49,   34,   50,   49,   52,   50,   54,

			   52,   53,   32,   52,   10,   53,   52,    9,  643,   57,
			   54,    8,   53,   54,  643,   53,   54,   55,   53,   54,
			   57,   55,   56,   57,   56,    7,   57,   69,   55,   69,
			   69,   55,    5,   56,   55,   73,   56,   58,   73,   56,
			   73,   56,   56,   73,    0,    0,   56,   71,   58,   71,
			   71,   58,    0,    0,   58,   68,   68,   68,   68,   68,
			   68,   68,   72,   74,   72,   72,   74,    0,   74,    0,
			    0,   74,    0,   69,   75,   75,   75,   75,   75,   75,
			   75,   76,   76,   76,   76,   76,   76,   76,   76,  200,
			  200,  200,    0,   71,   77,   77,   77,   77,   77,   77,

			   77,   77,   77,   77,   69,    0,   78,   78,   72,   78,
			   78,   78,   78,   78,   78,   78,   73,   73,   73,   73,
			   73,   73,   73,   99,   71,    0,   99,    0,   71,   71,
			   71,   71,   71,   71,   71,  100,    0,    0,  100,   72,
			  201,  201,  201,    0,   74,   74,   74,   74,   74,   74,
			   74,   79,   79,   79,   79,   79,   79,   79,   79,   79,
			   79,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   81,    0,    0,   81,   81,   81,   81,   81,   81,
			   81,   86,    0,    0,   86,  122,  122,  122,  122,  202,
			  202,  202,    0,  119,  119,  119,  119,    0,  122,   99,

			   99,   99,   99,   99,   99,   99,  119,  203,  203,  203,
			    0,  100,  100,  100,  100,  100,  100,  100,    0,    0,
			   86,  122,  124,  119,  124,  124,  124,  124,    0,  119,
			  135,    0,   91,    0,  129,   91,  129,  129,  129,  129,
			    0,  135,    0,    0,  135,   92,    0,  135,   92,  204,
			  204,  204,   86,    0,  124,    0,    0,   86,   86,   86,
			   86,   86,   86,   86,   88,    0,  129,   88,   88,   88,
			   88,   91,  205,  205,  205,    0,   88,  310,  310,  310,
			  310,    0,    0,   88,   92,   88,   88,   88,   88,   94,
			    0,   88,   94,   88,   88,   88,   88,   88,   88,   88,

			   88,   88,  101,   91,    0,  101,    0,    0,   91,   91,
			   91,   91,   91,   91,   91,    0,   92,    0,  143,    0,
			   92,   92,   92,   92,   92,   92,   92,   92,   94,  143,
			    0,    0,  143,   97,    0,  143,   97,  155,    0,    0,
			   88,   88,   88,   88,   88,   88,   88,   89,  155,   89,
			   89,  155,   89,    0,  155,   89,  155,  317,  317,    0,
			   94,    0,   94,   94,    0,   94,   94,   94,   94,   94,
			   94,   94,   97,  102,    0,  144,  102,  101,  101,  101,
			  101,  101,  101,  101,  101,  103,  144,  317,  103,  144,
			    0,   89,  144,  144,  309,  104,  309,    0,  104,  309,

			  309,  309,  309,  704,   97,  106,   97,  164,  106,   97,
			   97,   97,   97,   97,   97,   97,  105,    0,  164,  105,
			  704,  164,    0,   89,  164,  175,  704,  107,   89,   89,
			   89,   89,   89,   89,   89,   90,  175,   90,   90,  175,
			   90,    0,  175,   90,    0,    0,  102,  102,  102,  102,
			  102,  102,  102,  102,  102,  102,    0,    0,  103,  103,
			  110,  103,  103,  103,  103,  103,  103,  103,  104,  104,
			  104,  104,  104,  104,  104,  104,  104,  104,  106,   90,
			  111,  106,  106,  106,  106,  106,  106,  106,    0,  105,
			  105,  105,  105,  105,  105,  105,  105,  105,  105,  107,

			  107,  107,  107,  107,  107,  107,  112,  326,  326,  326,
			    0,   90,    0,    0,  147,    0,   90,   90,   90,   90,
			   90,   90,   90,   93,    0,    0,   93,    0,  176,  110,
			  110,  110,  110,  110,  110,  110,  110,  110,  110,  176,
			    0,  113,  176,    0,    0,  176,    0,    0,  148,    0,
			  170,  111,  111,  111,  111,  111,  111,  111,  111,  114,
			    0,  170,   93,  170,  170,  486,  486,  170,  327,  327,
			  327,  328,  328,  328,  116,  112,  112,  112,  112,  112,
			  112,  112,  112,  112,  112,  115,  147,  147,  147,  147,
			  147,  147,  147,    0,   93,  486,   93,   93,   93,   93, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			   93,   93,   93,   93,   93,   93,   95,    0,    0,   95,
			  113,  113,    0,  113,  113,  113,  113,  113,  113,  113,
			  148,  148,  148,  148,  148,  148,  148,    0,  114,  114,
			  114,  114,  114,  114,  114,  114,  114,  114,  149,    0,
			  319,  319,  319,  116,    0,   95,  116,  116,  116,  116,
			  116,  116,  116,    0,  115,  115,  115,  115,  115,  115,
			  115,  115,  115,  115,  123,  150,  123,  123,  123,  123,
			  319,  329,  329,  329,    0,  151,  123,   95,    0,   95,
			   95,   95,   95,   95,   95,   95,   95,   95,   95,   96,
			  145,  156,   96,    0,  156,    0,  123,    0,  145,  123,

			    0,  145,  156,    0,  145,  156,  166,  145,  156,  149,
			  149,  149,  149,  149,  149,  149,  149,  166,  166,  166,
			  166,    0,    0,  166,  313,    0,  313,    0,   96,  313,
			  313,  313,  313,    0,  150,  150,  150,  150,  150,  150,
			  150,  150,  150,  150,  151,  151,  152,  151,  151,  151,
			  151,  151,  151,  151,    0,    0,  153,  330,  330,  330,
			   96,    0,   96,   96,   96,   96,   96,   96,   96,   96,
			   96,   96,  109,    0,    0,  109,  109,  109,  109,  331,
			  331,  331,    0,    0,  109,  344,  344,  344,  345,  345,
			  345,  109,    0,  109,  109,  109,  109,  109,    0,  109,

			    0,  109,  109,  109,  109,  109,  109,  109,  109,  109,
			  346,  346,  346,    0,    0,  152,  152,  152,  152,  152,
			  152,  152,  152,  152,  152,  153,  153,  153,  153,  153,
			  153,  153,  153,  153,  153,  154,  206,  206,  206,  206,
			  206,  206,  206,  347,  347,  347,    0,    0,  109,  109,
			  109,  109,  109,  109,  109,  128,  128,  128,  128,    0,
			  177,  169,  165,  169,  128,  128,  128,  128,  128,  128,
			  165,  177,  169,  165,  177,  169,  165,  177,  169,  165,
			    0,    0,  165,  172,    0,  128,  172,  128,  128,  128,
			  128,  128,  128,  214,  172,  214,  214,  172,    0,    0,

			  172,  172,    0,  179,  154,  179,    0,  154,  154,  154,
			  154,  154,  154,  154,  167,  168,  179,    0,  167,  179,
			  168,    0,  179,  173,    0,  167,  168,  173,  167,  168,
			  171,  167,  168,  168,  173,  171,    0,  173,  174,  214,
			  173,  171,    0,    0,  171,    0,  174,  171,    0,  174,
			    0,    0,  174,  174,  178,  174,  178,  178,    0,  178,
			    0,  178,    0,  180,    0,  178,    0,  181,  178,    0,
			  214,  178,  183,  178,  180,  178,    0,  180,  181,  181,
			  180,  181,  182,  183,  181,    0,  183,  180,    0,  183,
			    0,  183,  184,  182,  182,    0,  182,  185,    0,  182,

			  185,  184,  186,  184,  187,    0,  184,    0,  185,  184,
			    0,  185,    0,  186,  185,  187,  186,  188,  187,  186,
			    0,  187,  189,  187,    0,    0,  190,    0,  188,    0,
			  190,  188,    0,  189,  188,    0,  189,  190,  191,  189,
			  190,    0,  191,  190,    0,  192,  193,    0,    0,  191,
			    0,    0,  191,    0,    0,  191,  192,  193,    0,  192,
			  193,  192,  192,  193,  194,  192,  195,    0,  194,    0,
			    0,  196,    0,  196,    0,  194,  197,  195,  194,    0,
			  195,  194,  196,  195,  198,  196,  199,  197,  196,    0,
			  197,    0,    0,  197,  197,  198,    0,  199,  198,  216,

			  199,  198,    0,  199,  198,  207,  207,  207,  207,  207,
			  207,  207,  208,  208,  208,  208,  208,  208,  208,  208,
			  209,  209,  209,  209,  209,  209,  209,  209,  209,  209,
			  210,  210,  217,  210,  210,  210,  210,  210,  210,  210,
			  211,  211,  211,  211,  211,  211,  211,  211,  211,  211,
			  212,  212,  212,  212,  212,  212,  212,  212,  212,  212,
			  213,    0,    0,  213,  213,  213,  213,  213,  213,  213,
			  215,    0,  215,  215,    0,  216,  216,  216,  216,  216,
			  216,  216,  219,    0,  219,  219,  348,  348,  348,  220,
			    0,    0,  220,    0,  220,    0,  221,  220,    0,  221,

			    0,  221,    0,    0,  221,  349,  349,  349,  217,  217,
			  217,  217,  217,  217,  217,  222,  215,  222,  222,  223,
			  223,  223,  223,  223,  223,  223,  224,    0,  219,  224,
			    0,  224,    0,    0,  224,  225,    0,  332,  225,  334,
			  225,    0,  334,  225,  399,  399,  399,  215,  332,    0,
			  334,  332,  230,  334,  332,  230,  334,  230,    0,  219,
			  230,  222,    0,  219,  219,  219,  219,  219,  219,  219,
			  220,  220,  220,  220,  220,  220,  220,  221,  221,  221,
			  221,  221,  221,  221,    0,  227,    0,    0,  227,    0,
			  227,    0,  222,  227,  231,  231,  231,  231,  231,  231,

			  231,  400,  400,  400,  494,  494,  494,  224,  224,  224,
			  224,  224,  224,  224,    0,  225,  225,  225,  225,  225,
			  225,  225,  225,  226,    0,    0,  226,    0,  226,    0,
			  230,  226,    0,  230,  230,  230,  230,  230,  230,  230,
			  232,    0,  333,  232,  343,  232,    0,    0,  232,  233,
			    0,    0,  233,  333,  233,  343,  333,  233,  343,  333,
			    0,  343,  333,  227,  227,    0,  227,  227,  227,  227,
			  227,  227,  227,  235,    0,    0,  235,    0,  235,    0,
			    0,  235,    0,  238,    0,    0,  238,    0,  238,    0,
			    0,  238,  239,  239,  239,  239,  239,  239,  239,    0,

			    0,  226,  226,  226,  226,  226,  226,  226,  226,  226,
			  226,  228,    0,    0,  228,    0,  228,    0,    0,  228,
			    0,  232,  232,  232,  232,  232,  232,  232,    0,  233,
			  233,  233,  233,  233,  233,  233,  233,  240,  240,  240,
			  240,  240,  240,  240,  241,  241,  241,  241,  241,  241,
			  241,  235,  235,    0,  235,  235,  235,  235,  235,  235,
			  235,  238,    0,    0,  238,  238,  238,  238,  238,  238,
			  238,  242,  242,  242,  242,  242,  242,  242,  243,  243,
			  243,  243,  243,  243,  243,  243,  243,  243,    0,  228,
			  228,  228,  228,  228,  228,  228,  228,  228,  228,  229,

			    0,    0,  229,    0,  229,    0,    0,  229,  244,  244,
			  244,  244,  244,  244,  244,  244,  244,  244,  342,    0,
			  245,    0,  350,  245,    0,    0,  342,  246,    0,  342,
			  246,    0,  342,  350,  247,  342,  350,  247,    0,  350,
			    0,  248,    0,    0,  248,  495,  495,  495,  249,    0,
			    0,  249,    0,  351,  248,  248,  248,  248,  250,    0,
			    0,  250,    0,    0,  351,    0,  251,  351,    0,  251,
			  351,  351,  476,  476,  476,  476,    0,  229,  229,  229,
			  229,  229,  229,  229,  229,  229,  229,  234,    0,    0,
			  234,    0,  234,    0,    0,  234,  245,  245,  245,  245, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_chk_template_3 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  245,  245,  245,  246,  246,  246,  246,  246,  246,  246,
			  247,  247,  247,  247,  247,  247,  247,  248,  248,  248,
			  248,  248,  248,  248,  249,  249,  249,  249,  249,  249,
			  249,  488,  488,  488,  250,  250,  250,  250,  250,  250,
			  250,  251,  251,  251,  251,  251,  251,  251,  251,  252,
			    0,    0,  252,  478,  478,  478,  478,    0,    0,  253,
			    0,  488,  253,    0,    0,  234,  234,  234,  234,  234,
			  234,  234,  234,  234,  234,  236,    0,    0,  236,    0,
			  236,    0,    0,  236,  308,  308,  308,  308,    0,  315,
			    0,  315,  315,  315,  315,    0,  352,  308,    0,  254,

			  352,    0,  254,  481,  481,  481,  481,  352,    0,  255,
			  352,    0,  255,  352,  308,  482,  482,  482,  482,    0,
			  308,  315,  252,  252,  252,  252,  252,  252,  252,  252,
			  252,  252,  253,  253,    0,  253,  253,  253,  253,  253,
			  253,  253,  256,    0,    0,  256,  429,  429,  429,  429,
			  429,  429,  429,  236,  236,  236,  236,  236,  236,  236,
			  236,  236,  236,  237,    0,    0,  237,    0,  237,    0,
			    0,  237,  254,  254,  254,  254,  254,  254,  254,  254,
			  254,  254,  255,  255,  255,  255,  255,  255,  255,  255,
			  255,  255,  259,    0,    0,  259,    0,  312,  312,  312,

			  312,    0,  323,    0,  323,  323,  323,  323,    0,  265,
			  312,    0,  265,    0,    0,  256,    0,    0,  256,  256,
			  256,  256,  256,  256,  256,  260,    0,  312,  260,    0,
			    0,  259,    0,  312,  323,    0,    0,  261,    0,    0,
			  261,  237,  237,  237,  237,  237,  237,  237,  237,  237,
			  237,  257,    0,  257,  257,    0,  257,    0,    0,  257,
			  502,  502,  502,  259,  260,    0,  356,    0,  259,  259,
			  259,  259,  259,  259,  259,    0,  261,  356,    0,    0,
			  356,  262,    0,  356,  262,  265,  265,  265,  265,  265,
			  265,  265,    0,    0,  266,  257,  260,  266,  503,  503,

			  503,  260,  260,  260,  260,  260,  260,  260,  261,  267,
			    0,  353,  267,  261,  261,  261,  261,  261,  261,  261,
			  262,  268,  353,    0,  268,  353,    0,  257,  353,  353,
			    0,    0,  257,  257,  257,  257,  257,  257,  257,  258,
			    0,  258,  258,    0,  258,    0,  324,  258,  324,  324,
			  324,  324,  262,  576,  576,  576,  576,  262,  262,  262,
			  262,  262,  262,  262,  269,    0,    0,  269,    0,    0,
			  266,  266,  266,  266,  266,  266,  266,  270,  324,    0,
			  270,    0,    0,  258,    0,  267,  267,  267,  267,  267,
			  267,  267,    0,    0,  354,  271,  361,  268,  268,  268,

			  268,  268,  268,  268,  273,  354,  354,  361,  354,  354,
			  361,  354,  274,  361,    0,  258,    0,  355,    0,  355,
			  258,  258,  258,  258,  258,  258,  258,  263,  355,    0,
			  263,  355,    0,    0,  355,  355,    0,  269,  269,  269,
			  269,  269,  269,  269,  269,  269,  269,  275,    0,    0,
			  270,  270,  270,  270,  270,  270,  270,  270,  270,  270,
			  276,    0,  477,  477,  477,  477,  263,  271,  271,  271,
			  271,  271,  271,  271,    0,    0,  273,  273,  273,  273,
			  273,  273,  273,  274,  274,  274,  274,  274,  274,  274,
			  274,  277,  477,  577,  577,  577,  577,    0,  263,  280,

			  263,  263,  263,  263,  263,  263,  263,  263,  263,  263,
			  264,    0,    0,  264,    0,    0,  275,  275,  275,  275,
			  275,  275,  275,  275,  275,  275,  278,    0,    0,  276,
			  276,  358,  276,  276,  276,  276,  276,  276,  276,  279,
			  357,  359,  358,  359,  357,  358,  281,    0,  358,  264,
			  358,  357,  359,  283,  357,  359,    0,  357,  359,    0,
			  277,  277,  277,  277,  277,  277,  277,  277,  277,  277,
			  284,  280,  280,  280,  280,  280,  280,  280,    0,    0,
			    0,  264,  286,  264,  264,  264,  264,  264,  264,  264,
			  264,  264,  264,  287,    0,  278,  278,  278,  278,  278,

			  278,  278,  278,  278,  278,  288,    0,    0,  279,    0,
			    0,  279,  279,  279,  279,  279,  279,  279,  281,  281,
			  281,  281,  281,  281,  281,  283,  283,  283,  283,  283,
			  283,  283,  289,  430,  430,  430,  430,  430,  430,  430,
			  285,    0,  284,  284,  284,  284,  284,  284,  284,  285,
			  285,  285,  285,  290,  286,  286,  286,  286,  286,  286,
			  286,  291,    0,    0,    0,  287,  287,  287,  287,  287,
			  287,  287,  292,    0,    0,  360,  363,  288,  288,  288,
			  288,  288,  288,  288,  293,  366,  360,  363,    0,  360,
			  363,  294,  360,  363,  360,    0,  366,    0,  295,  366,

			    0,    0,  366,  366,  289,  289,  289,  289,  289,  289,
			  289,  296,  285,  285,  285,  285,  285,  285,  285,  297,
			  579,  579,  579,  579,    0,  290,  290,  290,  290,  290,
			  290,  290,  298,  291,  291,  291,  291,  291,  291,  291,
			  299,    0,    0,    0,  292,  292,  292,  292,  292,  292,
			  292,  300,  483,  483,  483,  483,  293,  293,  293,  293,
			  293,  293,  293,  294,  294,  294,  294,  294,  294,  294,
			  295,  295,  295,  295,  295,  295,  295,  301,  581,  581,
			  581,  581,  483,  296,  296,  296,  296,  296,  296,  296,
			  302,  297,  297,  297,  297,  297,  297,  297,    0,    0,

			  303,    0,    0,    0,  298,  298,  298,  298,  298,  298,
			  298,  304,  299,  299,  299,  299,  299,  299,  299,  364,
			    0,  305,    0,  300,  300,  300,  300,  300,  300,  300,
			  364,  306,    0,  364,    0,    0,  364,    0,  480,  364,
			  480,  307,    0,  480,  480,  480,  480,    0,    0,  301,
			  301,  301,  301,  301,  301,  301,    0,    0,    0,  302,
			  302,  302,  302,  302,  302,  302,  302,  302,  302,  303,
			  303,  303,  303,  303,  303,  303,  303,  303,  303,    0,
			  304,  304,  304,  304,  304,  304,  304,  304,  304,  304,
			  305,  305,  305,  305,  305,  305,  305,  305,  305,  305,

			  306,  306,  306,  306,  306,  306,  306,  306,  306,  306,
			  307,  307,  307,  307,  307,  307,  307,  307,  307,  307,
			  314,    0,  314,  314,  314,  314,  336,  362,  367,    0,
			    0,  362,  314,  337,    0,    0,    0,  365,  362,  367,
			  338,  362,  367,    0,  362,  367,    0,  339,  365,    0,
			  365,  365,  314,    0,  365,  314,  321,  321,  321,  321,
			  340,  368,    0,  369,    0,  321,  321,  321,  321,  321,
			  321,  341,  368,    0,  369,  368,    0,  369,  368,  368,
			  369,    0,  369,    0,    0,    0,  321,    0,  321,  321,
			  321,  321,  321,  321,  583,  583,  583,  583,  336,  336, yy_Dummy>>,
			1, 1000, 2000)
		end

	yy_chk_template_4 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  336,  336,  336,  336,  336,  337,  337,  337,  337,  337,
			  337,  337,  338,  338,  338,  338,  338,  338,  338,  339,
			  339,  339,  339,  339,  339,  339,    0,    0,    0,  340,
			  340,  340,  340,  340,  340,  340,  340,  340,  340,    0,
			  341,  341,  341,  341,  341,  341,  341,  341,  341,  341,
			  370,  371,  370,  372,    0,    0,    0,  372,  642,  642,
			  642,  642,  371,  370,  372,  371,  370,  372,  371,  370,
			  372,  373,  374,  375,    0,    0,  374,  375,    0,  373,
			  376,    0,  373,  374,  375,  373,  374,  375,  373,  374,
			  375,  376,  377,  378,  376,    0,    0,  376,    0,  377,

			  379,  379,    0,  377,  378,    0,  377,  378,  380,  377,
			  378,  379,  380,  381,  379,  378,    0,  379,    0,  380,
			  383,    0,  380,    0,  381,  380,    0,  381,  382,  384,
			  381,  383,  382,  385,  383,  384,    0,  383,    0,  382,
			  384,    0,  382,  384,  385,  382,  384,  385,  386,    0,
			  385,    0,  385,  387,    0,    0,    0,  388,  387,  386,
			    0,  389,  386,    0,  387,  386,  386,  387,  388,  390,
			  387,  388,  389,  402,  388,  389,    0,  391,  389,    0,
			  390,  389,  403,  390,  392,    0,  390,  390,  391,  393,
			    0,  391,  404,    0,  391,  392,  391,  392,  392,  394,

			  393,  392,  405,  393,  395,    0,  393,  394,  393,  396,
			  394,  395,  406,  394,    0,  395,  394,    0,  395,    0,
			  396,  395,  407,  396,  398,  397,  396,    0,  396,  397,
			    0,    0,  408,    0,    0,  398,  397,    0,  398,  397,
			  410,  398,  397,  646,  646,  646,  646,    0,  411,  402,
			  402,  402,  402,  402,  402,  402,    0,  403,  403,  403,
			  403,  403,  403,  403,  403,  404,  404,  404,  404,  404,
			  404,  404,  404,  404,  404,  405,  405,  412,  405,  405,
			  405,  405,  405,  405,  405,  406,  406,  406,  406,  406,
			  406,  406,  406,  406,  406,  407,  407,  407,  407,  407,

			  407,  407,  407,  407,  407,  408,  413,    0,  408,  408,
			  408,  408,  408,  408,  408,    0,  410,  410,  410,  410,
			  410,  410,  410,  411,  411,  411,  411,  411,  411,  411,
			  411,  414,  485,    0,  485,  485,  485,  485,    0,    0,
			    0,  415,    0,  492,    0,  492,  492,  492,  492,    0,
			  412,  412,  412,  412,  412,  412,  412,  412,  412,  412,
			  416,    0,  417,    0,  485,  417,    0,  417,    0,  418,
			  417,    0,  418,    0,  418,  492,    0,  418,    0,  413,
			  413,    0,  413,  413,  413,  413,  413,  413,  413,  419,
			    0,    0,  419,    0,  419,    0,  493,  419,  493,  493,

			  493,  493,    0,    0,  414,  414,  414,  414,  414,  414,
			  414,  414,  414,  414,  415,  415,  415,  415,  415,  415,
			  415,  415,  415,  415,  420,    0,    0,  420,  493,  420,
			    0,    0,  420,  416,    0,    0,  416,  416,  416,  416,
			  416,  416,  416,  417,  417,  417,  417,  417,  417,  417,
			  418,  418,  418,  418,  418,  418,  418,  423,    0,    0,
			  423,  640,  423,  640,    0,  423,  640,  640,  640,  640,
			  419,  419,  419,  419,  419,  419,  419,  424,    0,    0,
			  424,    0,  424,    0,  425,  424,    0,  425,    0,  425,
			    0,  426,  425,    0,  426,    0,  426,    0,    0,  426,

			    0,  475,  475,  475,  475,  420,  420,  420,  420,  420,
			  420,  420,  421,  497,  475,  421,    0,  421,  496,    0,
			  421,    0,  496,    0,  497,    0,    0,  497,    0,  496,
			  497,  475,  496,  431,    0,  496,  431,  475,  423,  423,
			  423,  423,  423,  423,  423,  432,    0,    0,  432,  647,
			  647,  647,  647,    0,  434,    0,    0,  434,  424,  424,
			  424,  424,  424,  424,  424,  425,  425,  425,  425,  425,
			  425,  425,  426,  426,  426,  426,  426,  426,  426,  434,
			  435,    0,    0,  435,  649,  649,  649,  649,    0,    0,
			  421,  421,  421,  421,  421,  421,  421,  421,  421,  421,

			  422,    0,    0,  422,    0,  422,    0,    0,  422,  431,
			  431,  431,  431,  431,  431,  431,  479,  479,  479,  479,
			    0,  432,  432,  432,  432,  432,  432,  432,  445,  479,
			  434,  434,  434,  434,  434,  434,  434,  436,    0,    0,
			  436,    0,    0,    0,  437,    0,  479,  437,    0,    0,
			    0,  438,  479,  498,  438,    0,  435,  435,  435,  435,
			  435,  435,  435,  439,  498,    0,  439,  498,    0,    0,
			  498,    0,    0,  440,    0,    0,  440,    0,  422,  422,
			  422,  422,  422,  422,  422,  422,  422,  422,  427,    0,
			    0,  427,    0,  427,    0,    0,  427,    0,    0,    0,

			  445,  445,  445,  445,  445,  445,  445,    0,    0,  443,
			    0,    0,  443,  436,  436,  436,  436,  436,  436,  436,
			  437,  437,  437,  437,  437,  437,  437,  438,  438,  438,
			  438,  438,  438,  438,    0,    0,  439,  439,  439,  439,
			  439,  439,  439,  439,  439,  439,  440,  440,  440,  440,
			  440,  440,  440,  440,  440,  440,  441,    0,    0,  441,
			  697,  697,  697,  697,    0,    0,  427,  427,  427,  427,
			  427,  427,  427,  427,  427,  427,  428,    0,    0,  428,
			    0,  428,    0,  501,  428,  443,  443,  443,  443,  443,
			  443,  443,  506,  444,  501,  441,  444,  501,    0,    0,

			  501,    0,    0,  506,    0,  506,  506,    0,  504,  506,
			  442,    0,  484,  442,  484,  484,  484,  484,    0,  504,
			    0,  446,  504,    0,  484,  504,  504,  441,  447,  507,
			    0,    0,  441,  441,  441,  441,  441,  441,  441,  448,
			  507,    0,    0,  507,  484,    0,  507,  484,  507,  442,
			  449,    0,    0,    0,  428,  428,  428,  428,  428,  428,
			  428,  428,  428,  428,  433,    0,    0,  433,    0,  444,
			  444,  444,  444,  444,  444,  444,  433,  433,  433,  433,
			  433,  442,  450,    0,    0,    0,  442,  442,  442,  442,
			  442,  442,  442,  446,  446,  446,  446,  446,  446,  446,

			  447,  447,  447,  447,  447,  447,  447,  473,    0,    0,
			    0,  448,  448,  448,  448,  448,  448,  448,  474,  449,
			  449,  449,  449,  449,  449,  449,  449,  449,  449,  499,
			    0,    0,  575,  575,  575,  575,  500,    0,    0,  552,
			  433,  433,  433,  433,  433,  433,  433,    0,    0,    0,
			  571,  450,  450,  450,  450,  450,  450,  450,  450,  450,
			  450,  456,  575,  698,  698,  698,  698,    0,    0,  456,
			  456,  456,  456,  456,    0,    0,  473,  473,  473,  473,
			  473,  473,  473,  473,  473,  473,    0,  474,  474,  474,
			  474,  474,  474,  474,  474,  474,  474,    0,  553,    0, yy_Dummy>>,
			1, 1000, 3000)
		end

	yy_chk_template_5 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			    0,  499,  499,  499,  499,  499,  499,  499,  500,  500,
			  500,  500,  500,  500,  500,  552,  552,  552,  552,  552,
			  552,  552,  571,  571,  571,  571,  571,  571,  571,  505,
			    0,  508,    0,  456,  456,  456,  456,  456,  456,  456,
			  505,  509,  508,  505,    0,  508,  505,  505,  508,  510,
			  511,  512,  509,    0,    0,  509,    0,    0,  509,    0,
			  510,  511,  512,  510,  511,  512,  510,  511,  512,  511,
			  512,  513,  514,  515,  553,  553,  553,  553,  553,  553,
			  553,  517,  513,  514,  515,  513,  514,  515,  513,  514,
			  515,  516,  517,  517,    0,  517,  519,    0,  517,  516,

			  520,  518,  516,  518,    0,  516,    0,  519,  516,  521,
			  519,  520,  518,  519,  520,  518,  522,  520,  518,  520,
			  521,  523,    0,  521,    0,  523,  521,  522,  521,  524,
			  522,  525,  523,  522,    0,  523,    0,    0,  523,  526,
			  524,  527,  525,  524,    0,  525,  524,    0,  525,  524,
			  526,  526,  527,  526,  528,  527,  526,    0,  527,  529,
			    0,  530,    0,    0,  527,  528,    0,    0,  528,  531,
			  529,  528,  530,  529,  532,  530,  529,  528,  530,  533,
			  531,  534,    0,  531,    0,  532,  531,    0,  532,  536,
			  533,  532,  534,  533,    0,  534,  533,  535,  534,    0,

			  536,  535,  537,  536,  537,    0,  536,  538,  535,  539,
			    0,  535,    0,  537,  535,    0,  537,  540,  538,  537,
			  539,  538,  541,  539,  538,  540,  539,  542,  540,  543,
			  541,  540,  554,  541,  540,    0,  541,  543,  542,  541,
			  543,  542,  555,  543,  542,  544,  543,  545,    0,  544,
			    0,  542,  546,  556,    0,    0,  544,  547,  545,  544,
			  558,  545,  544,  546,  545,  547,  546,  548,  547,  546,
			  549,  547,  549,  557,  547,    0,    0,    0,  548,  551,
			  548,  548,  559,  549,  548,    0,  549,  550,    0,  549,
			  551,  550,  560,  551,    0,    0,  551,    0,  550,  561,

			    0,  550,    0,    0,  550,    0,    0,    0,  554,  554,
			  554,  554,  554,  554,  554,  562,    0,    0,  555,  555,
			  555,  555,  555,  555,  555,  563,  556,  556,  556,  556,
			  556,  556,  556,  556,  556,  556,  558,  558,  558,  558,
			  558,  558,  558,    0,    0,    0,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,    0,    0,  559,  559,
			  559,  559,  559,  559,  559,    0,  572,    0,  560,  560,
			  560,  560,  560,  560,  560,  561,  561,  561,  561,  561,
			  561,  561,  569,    0,    0,  569,    0,    0,  562,  562,
			  562,  562,  562,  562,  562,  562,  562,  562,  563,  563,

			  563,  563,  563,  563,  563,  563,  563,  563,  564,  573,
			    0,  564,    0,  564,    0,  565,  564,    0,  565,    0,
			  565,    0,  566,  565,    0,  566,    0,  566,    0,  567,
			  566,    0,  567,    0,  567,    0,    0,  567,  572,  572,
			  572,  572,  572,  572,  572,  570,    0,    0,  570,    0,
			    0,    0,  574,  574,  574,  574,  586,  587,  569,  569,
			  569,  569,  569,  569,  569,  574,    0,  586,  587,  586,
			  586,  587,    0,  586,  587,    0,  587,  699,  699,  699,
			  699,  573,  573,  573,  573,  573,  573,  573,  574,  564,
			  564,  564,  564,  564,  564,  564,  565,  565,  565,  565,

			  565,  565,  565,  566,  566,  566,  566,  566,  566,  566,
			  567,  567,  567,  567,  567,  567,  567,  568,    0,    0,
			  568,  570,  570,  570,  570,  570,  570,  570,    0,  568,
			  568,  568,  568,  568,  578,  578,  578,  578,  580,  580,
			  580,  580,  582,  582,  582,  582,    0,  578,  584,  584,
			  584,  584,  588,  585,    0,  585,  585,  585,  585,    0,
			  589,  584,    0,  588,  578,  588,  588,    0,  580,  588,
			  578,  589,  582,  590,  589,  590,    0,  589,  641,  641,
			  641,  641,    0,    0,  584,  585,  590,    0,    0,  590,
			  591,    0,  590,  568,  568,  568,  568,  568,  568,  568,

			    0,  591,  592,  595,  591,    0,  592,  591,  641,  591,
			  593,    0,    0,  592,  595,  594,  592,  595,    0,  592,
			  595,  593,  595,  593,  593,  596,  594,  593,  594,  594,
			  597,    0,  594,    0,  597,  598,  596,  599,  597,  596,
			    0,  597,  596,    0,  597,  600,  598,  597,  599,  598,
			  601,  599,  598,  600,  599,  602,  600,  603,    0,  600,
			    0,  601,  600,  602,  601,    0,  602,  601,  603,  602,
			    0,  603,  602,  604,  603,  606,  603,  604,  605,    0,
			  605,    0,    0,    0,  604,  607,  606,  604,    0,  606,
			  604,  605,  606,  606,  605,  608,  607,  605,  607,  607,

			  609,    0,  607,    0,  610,  611,  608,    0,    0,  608,
			    0,  609,  608,  611,  609,  610,  611,  609,  610,  611,
			  612,  610,  611,    0,  613,  614,    0,    0,  612,    0,
			    0,  612,  617,  614,  612,  613,  614,  612,  613,  614,
			  615,  613,  614,  617,  616,  615,  617,    0,  618,  617,
			    0,  615,  616,  617,  615,  616,  619,  615,  616,  618,
			  620,  616,  618,    0,  621,  618,    0,  619,  621,  622,
			  619,  620,    0,  619,  620,  621,  623,  620,  621,    0,
			  622,  621,    0,  622,  623,  624,  622,  623,  622,  634,
			  623,    0,    0,  623,  625,  626,  624,  635,    0,  624,

			    0,    0,  624,  624,  627,  625,  626,  636,  625,  626,
			    0,  625,  626,  628,  629,  627,  628,  625,  627,  637,
			    0,  627,    0,    0,  628,  629,  638,  628,  629,  638,
			  628,  629,  630,  631,  630,    0,    0,  632,  638,  631,
			    0,  633,    0,  630,  631,    0,  630,  631,  632,  630,
			  631,  632,  633,  633,  632,  633,  632,    0,  633,    0,
			  645,  645,  645,  645,    0,  634,  634,  634,  634,  634,
			  634,  634,    0,  635,  635,  635,  635,  635,  635,  635,
			    0,    0,    0,  636,  636,  636,  636,  636,  636,  636,
			  645,  648,  648,  648,  648,  637,  637,  637,  637,  637,

			  637,  637,  638,  638,  638,  638,  638,  638,  638,  644,
			  644,  644,  644,    0,  651,  651,  651,  651,  650,  652,
			  650,  648,  644,  650,  650,  650,  650,  651,    0,  653,
			  652,    0,    0,  652,    0,    0,  652,  654,  652,    0,
			  653,  656,  655,  653,  655,  644,  653,    0,  654,  657,
			  651,  654,  656,  655,  654,  656,  655,    0,  656,  655,
			  657,  658,    0,  657,  658,  659,  657,    0,    0,  659,
			  660,    0,  658,    0,  660,  658,  659,  661,  658,  659,
			    0,  660,  659,    0,  660,  662,    0,  660,  661,    0,
			  663,  661,    0,    0,  661,  664,  662,    0,    0,  662, yy_Dummy>>,
			1, 1000, 4000)
		end

	yy_chk_template_6 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			    0,  663,  662,  662,  663,  666,  664,  663,    0,  664,
			  665,    0,  664,    0,  665,  667,  666,    0,    0,  666,
			  666,  665,  666,  668,  665,  668,  667,  665,  667,  667,
			  669,  670,  667,    0,  668,    0,    0,  668,  669,  672,
			  668,  669,  670,    0,  669,  670,    0,  669,  670,  671,
			  672,  671,    0,  672,  673,    0,  672,    0,  674,  675,
			  671,    0,  674,  671,    0,  673,  671,  676,  673,  674,
			  675,  673,  674,  675,  677,  674,  675,    0,  676,  678,
			  676,  676,    0,  679,  676,  677,    0,  677,  677,    0,
			  678,  677,  680,  678,  679,    0,  678,  679,  678,  682,

			  679,  681,  682,  680,    0,  681,  680,    0,  683,  680,
			  682,  683,  681,  682,    0,  681,  682,    0,  681,  683,
			    0,  684,  683,  684,  685,  683,  703,  703,  703,  703,
			  686,    0,  686,    0,  684,  685,    0,  684,  685,  687,
			  684,  685,  685,  686,  688,    0,  686,    0,  689,  686,
			  687,    0,  687,  687,    0,  688,  687,    0,  688,  689,
			  690,  688,  689,  688,  690,  689,    0,  691,  692,    0,
			  693,  690,  693,    0,  690,    0,  692,  690,  691,  692,
			  695,  691,  692,  693,  691,  692,  693,  695,  694,  693,
			  694,  695,    0,  696,  695,  696,    0,  695,    0,    0,

			    0,  694,    0,    0,  694,    0,  696,  694,  700,  696,
			  700,    0,  696,  700,  700,  700,  700,  701,    0,  701,
			    0,    0,  701,  701,  701,  701,  702,  702,  702,  702,
			  705,  705,  705,  705,  706,  706,  706,  706,  707,  707,
			  707,  707,  709,  709,  709,  709,  710,  711,  710,    0,
			    0,  710,  710,  710,  710,  709,  702,  714,  711,  712,
			    0,  711,    0,    0,  711,    0,  712,  713,  714,  713,
			  712,  714,  709,  712,  714,    0,  712,  715,  709,    0,
			  713,    0,  716,  713,    0,    0,  713,  718,  715,  717,
			  715,  715,    0,  716,  715,  716,  716,  717,  718,  716,

			  717,  718,  719,  717,  718,    0,  717,  720,    0,  721,
			    0,  722,  721,  719,    0,  719,  719,    0,  720,  719,
			  721,  720,  722,  721,  720,  722,  721,  723,  722,  724,
			  722,  724,  725,  750,  750,  750,  750,    0,  723,    0,
			  726,  723,  724,  725,  723,  724,  725,  726,  724,  725,
			  727,  726,    0,  725,  726,    0,    0,  726,    0,  728,
			  729,  727,    0,    0,  727,    0,    0,  727,    0,  727,
			  728,  729,  730,  728,  729,    0,  728,  729,  730,  731,
			  732,    0,    0,  730,    0,  731,  730,    0,  734,  730,
			  731,  732,    0,  731,  732,    0,  731,  732,  733,  734,

			  733,  734,  734,  735,    0,  734,    0,    0,  736,  733,
			    0,  737,  733,  737,  735,  733,    0,  735,  738,  736,
			  735,  735,  736,  739,  737,  736,  736,  737,    0,  738,
			  737,    0,  738,  740,  739,  738,    0,  739,  743,  740,
			  739,  739,  741,    0,  740,    0,  744,  740,  741,  743,
			  740,  740,  743,  741,  742,  743,  741,  744,  742,  741,
			  744,  745,  746,  744,  745,  742,  747,    0,  742,    0,
			    0,  742,  745,  746,  746,  745,  746,  747,  745,  746,
			  747,    0,  748,  747,  748,  751,  751,  751,  751,  752,
			  752,  752,  752,  748,    0,    0,  748,    0,    0,  748,

			  753,  753,  753,  753,  754,  754,  754,  754,    0,    0,
			    0,  755,    0,  755,    0,  751,  755,  755,  755,  755,
			  757,  757,  757,  757,  758,  758,  758,  758,  759,  759,
			  759,  759,  760,  757,  761,    0,  761,    0,  791,  791,
			  791,  791,    0,  760,    0,  761,  760,    0,  761,  760,
			  757,  761,  762,  763,    0,    0,  757,    0,  759,    0,
			  765,  764,  765,  762,  763,    0,  762,  763,  791,  762,
			  763,  762,  764,  765,  764,  764,  765,  766,  764,  765,
			    0,  767,  768,  793,  793,  793,  793,    0,  766,  767,
			    0,  766,  767,  768,  766,  767,  768,  769,  767,  768,

			  769,  770,  771,    0,    0,  770,    0,    0,  769,  772,
			  773,  769,  770,  771,  769,  770,  771,  772,  770,  771,
			  772,  773,  774,  772,  773,    0,  772,  773,    0,  776,
			  775,    0,    0,  774,  775,    0,  774,    0,  777,  774,
			  776,  775,  778,  776,  775,    0,  776,  775,  776,  777,
			  779,    0,  777,  778,    0,  777,  778,  780,  781,  778,
			    0,  779,  780,    0,  779,  779,  782,  779,  780,  781,
			  783,  780,  781,    0,  780,  781,    0,  782,    0,  784,
			  782,  783,    0,  782,  783,    0,  785,  783,    0,  783,
			  784,    0,  786,  784,  786,    0,  784,  785,  787,  785,

			  785,    0,  788,  785,    0,  786,  787,  789,  786,  787,
			    0,  786,  787,  788,    0,  787,  788,    0,  789,  788,
			  790,  789,    0,    0,  789,    0,  789,  790,    0,    0,
			    0,  790,    0,    0,  790,  796,    0,  790,  794,  794,
			  794,  794,  795,  795,  795,  795,  796,  797,  798,  796,
			    0,    0,  796,    0,  797,    0,  799,    0,  797,  798,
			  800,  797,  798,    0,  797,  798,    0,  799,  794,  802,
			  799,  800,  795,  799,  800,  799,  801,  800,  801,  800,
			  802,  803,    0,  802,    0,  805,  802,  801,    0,  804,
			  801,    0,  803,  801,    0,  803,  805,  804,  803,  805,

			  804,  806,  805,  804,    0,  803,  804,    0,  807,  809,
			  808,    0,  806,  808,    0,  806,    0,  810,  806,  807,
			  809,  808,  807,  809,  808,  807,  809,  808,  810,  811,
			  812,  810,    0,    0,  810,    0,    0,  813,  814,    0,
			  811,  812,    0,  811,  812,    0,  811,  812,  813,  814,
			    0,  813,  814,    0,  813,  814,  815,  814,  815,    0,
			  816,  817,    0,    0,    0,  818,    0,  815,    0,  819,
			  815,  816,  817,  815,  816,  817,  818,  816,  817,  818,
			  819,  821,  818,  819,    0,  822,  819,  820,  820,  820,
			  820,    0,  821,  823,  824,  821,  822,    0,  821,  822,

			  821,  826,  822,    0,  823,  824,    0,  823,  824,  825,
			  823,  824,  826,  827,  826,  826,  825,  820,  826,    0,
			  825,  828,  829,  825,  827,    0,  825,  827,    0,  830,
			  827,    0,  828,  829,  831,  828,  829,    0,  828,  829,
			  830,  829,  830,  830,  833,  831,  830,    0,  831,  832,
			    0,  831,    0,  832,  834,  833,  834,    0,  833,  835,
			  832,  833,    0,  832,  833,  834,  832,  836,  834,  837,
			  835,  834,    0,  835,  836,  837,  835,  838,  836,  839,
			  837,  836,    0,  837,  836,    0,  837,  838,  838,  840,
			  839,  838,    0,  839,  838,    0,  839,  841,  842,  843, yy_Dummy>>,
			1, 1000, 5000)
		end

	yy_chk_template_7 (an_array: ARRAY [INTEGER])
		do
			yy_array_subcopy (an_array, <<
			  840,    0,    0,  840,    0,    0,  840,  844,  841,  842,
			  843,  841,  842,  843,  841,  842,  843,  845,  844,  846,
			    0,  844,    0,  845,  844,    0,  847,  848,  845,    0,
			  846,  845,  848,  846,  845,  849,  846,  847,  848,    0,
			  847,  848,    0,  847,  848,  850,  849,  851,    0,  849,
			  849,    0,  849,    0,  852,  850,  850,    0,  851,  850,
			    0,  851,  850,  853,  851,  852,    0,    0,  852,    0,
			    0,  852,  854,  855,  853,    0,    0,  853,    0,    0,
			  853,  853,  856,  854,  855,    0,  854,  855,    0,  854,
			  855,  854,  855,  856,  857,  858,  856,    0,    0,  856,

			    0,    0,  859,  860,  861,  857,  858,    0,  857,  858,
			  859,  857,  858,  859,  860,  861,  859,  860,  861,  859,
			  860,  861,  862,  863,  864,    0,    0,    0,    0,    0,
			    0,  865,  866,  862,  863,  864,  862,  863,  864,  862,
			  863,  864,  865,  866,  867,  865,  866,    0,  865,  866,
			    0,  868,    0,  869,    0,  867,    0,    0,  867,    0,
			  870,  867,  868,  867,  869,  868,    0,  869,  868,  871,
			  869,  870,    0,  872,  870,    0,  869,  870,  874,  870,
			  871,  871,  873,  871,  872,    0,  871,  872,    0,  874,
			  872,  875,  874,  873,  873,  874,  873,    0,  876,  873,

			  877,    0,  875,    0,    0,  875,    0,    0,  875,  876,
			    0,  877,  876,    0,  877,  876,    0,  877,  879,  879,
			  879,  879,  879,  879,  879,  879,  879,  879,  879,  879,
			  879,  879,  879,  879,  879,  879,  879,  879,  879,  879,
			  879,  880,  880,    0,  880,  880,  880,  880,  880,  880,
			  880,  880,  880,  880,  880,  880,  880,  880,  880,  880,
			  880,  880,  880,  880,  881,    0,    0,    0,    0,    0,
			    0,  881,  881,  881,  881,  881,  881,  881,  881,  881,
			  881,  881,  881,  881,  881,  881,  881,  882,  882,    0,
			  882,  882,  882,  882,  882,  882,  882,  882,  882,  882,

			  882,  882,  882,  882,  882,  882,  882,  882,  882,  882,
			  883,  883,    0,  883,  883,  883,  883,    0,  883,  883,
			  883,  883,  883,  883,  883,  883,  883,  883,  883,  883,
			  883,  883,  883,  884,  884,  884,  884,  884,  884,  884,
			  884,  884,  884,  884,  884,  884,  884,  885,  885,    0,
			  885,  885,  885,    0,    0,  885,  885,  885,  885,  885,
			  885,  885,  885,  885,  885,  885,  885,  885,  885,  885,
			  886,  886,  886,  886,  886,  886,  886,  886,  886,  886,
			  886,  886,  886,  886,  887,    0,    0,  887,    0,  887,
			  887,  887,  887,  887,  887,  887,  887,  887,  887,  887,

			  887,  887,  887,  887,  887,  887,  887,  888,  888,    0,
			  888,  888,  888,  888,  888,  888,  888,  888,  888,  888,
			  888,  888,  888,  888,  888,  888,  888,  888,  888,  888,
			  889,  889,    0,  889,  889,  889,  889,  889,  889,  889,
			  889,  889,  889,  889,  889,  889,  889,  889,  889,  889,
			  889,  889,  889,  890,  890,    0,  890,  890,  890,  890,
			  890,  890,  890,  890,  890,  890,  890,  890,  890,  890,
			  890,  890,  890,  890,  890,  890,  891,    0,    0,    0,
			    0,  891,  891,  891,  891,  891,  891,  891,  891,  891,
			  891,  891,  891,  891,  891,  891,  891,  891,  891,  892,

			  892,  892,  892,  892,  892,  892,  892,    0,  892,  892,
			  892,  892,  892,  892,  892,  892,  892,  892,  892,  892,
			  892,  892,  893,  893,  893,  893,  893,  893,  893,  893,
			  893,  893,  893,  893,  893,  894,  894,  894,  894,  894,
			  894,  894,  894,  894,  894,  894,  894,  894,  895,  895,
			  895,  895,  895,  895,  895,  895,  895,  895,  895,  895,
			  895,  896,  896,    0,  896,  896,  896,    0,  896,  896,
			  896,  896,  896,  896,  896,  896,  896,  896,  896,  896,
			  896,  896,  896,  896,  897,  897,    0,  897,  897,  897,
			    0,  897,  897,  897,  897,  897,  897,  897,  897,  897,

			  897,  897,  897,  897,  897,  897,  897,  898,  898,  898,
			  898,  898,  898,  898,  898,    0,  898,  898,  898,  898,
			  898,  898,  898,  898,  898,  898,  898,  898,  898,  898,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,

			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878, yy_Dummy>>,
			1, 720, 6000)
		end

	yy_base_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   88,   99,  432, 6630,  423,  408,  403,
			  399, 6630,  111,    0, 6630,  118,  125, 6630, 6630, 6630,
			 6630, 6630,   77,   75,   80,  197,   90,  130, 6630, 6630,
			   89, 6630,  375,  253,  322,  333,  322, 6630,  337, 6630,
			 6630,   75,  169,  152,  180,  291,  293,  309,  311,  327,
			  329,  283,  334,  349,  347,  365,  370,  357,  385, 6630,
			 6630,   42,  291,   51,   34,   57,   64,  284,  372,  425,
			  352,  445,  460,  433,  461,  391,  399,  414,  426,  471,
			  481,  491,  351,  345,  340,  329,  574, 6630,  657,  745,
			  833,  625,  638,  916,  682,  999, 1082,  726,    0,  516,

			  528,  695,  766,  778,  788,  809,  798,  816,  293, 1165,
			  849,  869,  895,  930,  948,  974,  963, 6630, 6630,  573,
			 6630, 6630,  565, 1046,  604,   91,  171,  209, 1235,  616,
			   99,  274, 6630, 6630,    0,  578,   74,  199,   88,   85,
			  144,  180,  200,  666,  723, 1038, 6630,  903,  937, 1027,
			 1054, 1064, 1135, 1145, 1224,  685, 1039,  197,  189,  219,
			  164,  251,  289,  190,  755, 1210, 1054, 1262, 1263, 1209,
			  898, 1278, 1231, 1271, 1286,  773,  876, 1208, 1302, 1253,
			 1311, 1315, 1330, 1320, 1340, 1345, 1350, 1352, 1365, 1370,
			 1374, 1386, 1393, 1394, 1412, 1414, 1419, 1424, 1432, 1434,

			  409,  460,  509,  527,  569,  592, 1153, 1422, 1430, 1440,
			 1450, 1460, 1470, 1480, 1291, 1568, 1492, 1525,  245, 1580,
			 1587, 1594, 1613, 1536, 1624, 1633, 1721, 1683, 1809, 1897,
			 1650, 1611, 1738, 1747, 1985, 1771, 2073, 2161, 1781, 1709,
			 1754, 1761, 1788, 1798, 1828, 1913, 1920, 1927, 1934, 1941,
			 1951, 1959, 2042, 2052, 2092, 2102, 2135, 2249, 2337, 2185,
			 2218, 2230, 2274, 2420, 2503, 2202, 2287, 2302, 2314, 2357,
			 2370, 2384, 6630, 2393, 2401, 2436, 2449, 2480, 2515, 2528,
			 2488, 2535,  222, 2542, 2559, 2629, 2571, 2582, 2594, 2621,
			 2642, 2650, 2661, 2673, 2680, 2687, 2700, 2708, 2721, 2729,

			 2740, 2766, 2779, 2789, 2800, 2810, 2820, 2830, 2064,  779,
			  657, 6630, 2177, 1109, 2902, 2071,  172,  737,  166, 1020,
			  143, 2936,  131, 2184, 2328, 6630,  827,  888,  891,  991,
			 1077, 1099, 1585, 1690, 1587, 6630, 2915, 2922, 2929, 2936,
			 2949, 2960, 1866, 1692, 1105, 1108, 1130, 1163, 1506, 1525,
			 1870, 1901, 2044, 2259, 2342, 2365, 2214, 2488, 2479, 2489,
			 2623, 2344, 2875, 2624, 2767, 2885, 2633, 2876, 2909, 2911,
			 3000, 2999, 3001, 3019, 3020, 3021, 3028, 3040, 3041, 3048,
			 3056, 3061, 3076, 3068, 3077, 3081, 3096, 3101, 3105, 3109,
			 3117, 3125, 3132, 3137, 3147, 3152, 3157, 3173, 3172, 1564,

			 1621, 6630, 3166, 3175, 3185, 3195, 3205, 3215, 3225, 6630,
			 3233, 3241, 3270, 3299, 3324, 3334, 3353, 3360, 3367, 3387,
			 3422, 3510, 3598, 3455, 3475, 3482, 3489, 3686, 3774, 2063,
			 2550, 3526, 3538, 3857, 3547, 3573, 3630, 3637, 3644, 3656,
			 3666, 3749, 3803, 3702, 3786, 3617, 3810, 3817, 3828, 3839,
			 3871, 6630, 6630, 6630, 6630, 6630, 3950, 6630, 6630, 6630,
			 6630, 6630, 6630, 6630, 6630, 6630, 6630, 6630, 6630, 6630,
			 6630, 6630, 6630, 3896, 3907, 3481, 1952, 2442, 2033, 3596,
			 2823, 2083, 2095, 2732, 3794, 3314,  945,  129, 2011,   92,
			    0,   84, 3325, 3378, 1624, 1865, 3466, 3461, 3601, 3918,

			 3925, 3731, 2180, 2218, 3756, 3977, 3740, 3777, 3979, 3989,
			 3997, 3998, 3999, 4019, 4020, 4021, 4039, 4029, 4049, 4044,
			 4048, 4057, 4064, 4069, 4077, 4079, 4087, 4089, 4102, 4107,
			 4109, 4117, 4122, 4127, 4129, 4145, 4137, 4150, 4155, 4157,
			 4165, 4170, 4175, 4177, 4193, 4195, 4200, 4205, 4215, 4220,
			 4235, 4227, 3932, 3991, 4225, 4235, 4246, 4266, 4253, 4275,
			 4285, 4292, 4308, 4318, 4406, 4413, 4420, 4427, 4510, 4375,
			 4438, 3939, 4355, 4398, 4432, 3912, 2333, 2473, 4514, 2700,
			 4518, 2758, 4522, 2974, 4528, 4535, 4404, 4405, 4500, 4508,
			 4523, 4538, 4550, 4558, 4563, 4551, 4573, 4578, 4583, 4585,

			 4593, 4598, 4603, 4605, 4621, 4628, 4623, 4633, 4643, 4648,
			 4652, 4653, 4668, 4672, 4673, 4688, 4692, 4680, 4696, 4704,
			 4708, 4712, 4717, 4724, 4733, 4742, 4743, 4752, 4761, 4762,
			 4780, 4781, 4785, 4789, 4782, 4790, 4800, 4812, 4819, 6630,
			 3446, 4558, 3038,  358, 4889, 4840, 3223, 3529, 4871, 3564,
			 4903, 4894, 4867, 4877, 4885, 4890, 4889, 4897, 4909, 4913,
			 4918, 4925, 4933, 4938, 4943, 4958, 4953, 4963, 4971, 4978,
			 4979, 4997, 4987, 5002, 5006, 5007, 5015, 5022, 5027, 5031,
			 5040, 5049, 5047, 5056, 5071, 5072, 5080, 5087, 5092, 5096,
			 5108, 5115, 5116, 5120, 5138, 5128, 5143, 3740, 3943, 4457,

			 5193, 5202, 5206, 5106,  770, 5210, 5214, 5218, 6630, 5222,
			 5231, 5195, 5207, 5217, 5205, 5225, 5230, 5237, 5235, 5250,
			 5255, 5257, 5259, 5275, 5279, 5280, 5288, 5298, 5307, 5308,
			 5320, 5327, 5328, 5346, 5336, 5351, 5356, 5361, 5366, 5371,
			 5381, 5390, 5402, 5386, 5394, 5409, 5410, 5414, 5430,   76,
			 5313, 5465, 5469, 5480, 5484, 5496,   69, 5500, 5504, 5508,
			 5480, 5482, 5500, 5501, 5509, 5510, 5525, 5529, 5530, 5545,
			 5549, 5550, 5557, 5558, 5570, 5578, 5577, 5586, 5590, 5598,
			 5605, 5606, 5614, 5618, 5627, 5634, 5642, 5646, 5650, 5655,
			 5668, 5518,   50, 5563, 5718, 5722, 5683, 5695, 5696, 5704,

			 5708, 5724, 5717, 5729, 5737, 5733, 5749, 5756, 5758, 5757,
			 5765, 5777, 5778, 5785, 5786, 5804, 5808, 5809, 5813, 5817,
			 5867, 5829, 5833, 5841, 5842, 5857, 5849, 5861, 5869, 5870,
			 5877, 5882, 5897, 5892, 5902, 5907, 5915, 5917, 5925, 5927,
			 5937, 5945, 5946, 5947, 5955, 5965, 5967, 5974, 5975, 5983,
			 5993, 5995, 6002, 6011, 6020, 6021, 6030, 6042, 6043, 6050,
			 6051, 6052, 6070, 6071, 6072, 6079, 6080, 6092, 6099, 6101,
			 6108, 6117, 6121, 6130, 6126, 6139, 6146, 6148, 6630, 6217,
			 6240, 6263, 6286, 6309, 6324, 6346, 6360, 6383, 6406, 6429,
			 6452, 6475, 6498, 6512, 6525, 6538, 6560, 6583, 6606, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,  878,    1,  879,  879,  878,  878,  878,  878,  878,
			  878,  878,  880,  881,  878,  882,  883,  878,  878,  878,
			  878,  878,  878,  878,  878,  884,  884,  884,  878,  878,
			  878,  878,  878,  878,   33,   33,   33,  878,  878,  878,
			  878,  885,  886,  886,  886,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  887,  878,
			  878,  887,  878,  888,  889,  887,  887,  887,  887,  887,
			  887,  887,  878,  878,  878,  878,  880,  878,  890,  880,
			  880,  880,  880,  880,  880,  880,  880,  880,  881,  882,

			  882,  882,  882,  882,  882,  882,  882,  891,  878,  891,
			  891,  891,  891,  891,  891,  891,  891,  878,  878,  878,
			  878,  878,  892,  884,  884,  884,  893,  894,  895,  884,
			  884,  878,  878,  878,   33,   44,  878,  878,  878,  878,
			  878,  878,  878,   44,   44,   44,  878,  885,  885,  885,
			  885,  885,  885,  885,  885,   44,   44,  878,  878,  878,
			  878,  878,  878,  878,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,

			  878,  878,  878,  878,  878,  878,  887,  887,  887,  887,
			  887,  887,  887,  887,  878,  878,  896,  897,  878,  887,
			  888,  889,  878,  887,  888,  888,  888,  888,  888,  888,
			  888,  887,  889,  889,  889,  889,  889,  889,  889,  887,
			  887,  887,  887,  887,  887,  890,  882,  882,  890,  890,
			  890,  890,  890,  890,  890,  890,  890,  880,  880,  880,
			  880,  880,  880,  880,  880,  882,  882,  882,  882,  882,
			  882,  891,  878,  891,  891,  891,  891,  891,  891,  891,
			  891,  891,  878,  891,  891,  891,  891,  891,  891,  891,
			  891,  891,  891,  891,  891,  891,  891,  891,  891,  891,

			  891,  891,  891,  891,  891,  891,  891,  891,  878,  878,
			  878,  878,  878,  878,  884,  884,  884,  893,  893,  894,
			  894,  895,  895,  884,  884,  878,  878,  878,  878,  878,
			  878,  878,   44,   44,   44,  878,  885,  885,  885,  885,
			  885,  885,   44,   44,  878,  878,  878,  878,  878,  878,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,  878,

			  878,  878,  896,  896,  896,  896,  896,  896,  896,  878,
			  897,  897,  897,  897,  897,  897,  897,  888,  888,  888,
			  888,  888,  888,  889,  889,  889,  889,  889,  889,  887,
			  887,  890,  890,  890,  890,  890,  890,  890,  890,  890,
			  890,  880,  880,  882,  882,  891,  891,  891,  891,  891,
			  891,  878,  878,  878,  878,  878,  891,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  891,  891,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  884,  884,  893,  893,  894,  894,
			  321,  895,  884,  884,  878,  878,   44,   44,   44,  885,

			  885,   44,  878,  878,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,  896,  896,  896,  896,  896,  896,  897,  897,
			  897,  897,  897,  897,  888,  888,  889,  889,  890,  890,
			  890,  891,  891,  891,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  892,  884,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,

			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,  896,  896,  897,  897,  890,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  898,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,  878,  878,  878,

			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,  878,  878,  878,  878,  878,   44,   44,   44,   44,

			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			  878,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
			   44,   44,   44,   44,   44,   44,   44,   44,    0,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878,  878,
			  878,  878,  878,  878,  878,  878,  878,  878,  878, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    5,    6,    7,    8,    9,   10,    8,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   22,   22,   22,   22,   22,   23,   23,   24,   25,
			   26,   27,   28,    1,    8,   29,   30,   31,   32,   33,
			   34,   35,   36,   35,   35,   35,   37,   35,   38,   35,
			   35,   39,   40,   41,   42,   43,   44,   35,   45,   35,
			   35,   46,   47,   48,   49,   50,   51,   52,   53,   54,

			   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,
			   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
			   75,   76,   77,   78,    8,   79,    1,    1,   80,   80,
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
			   85,   85,   85,   85,   85,   85,   85,   86,   87,   87,
			    1,   88,   88,   88,   89,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    1,    2,    3,    4,    5,    1,    6,    1,    1,
			    7,    8,    1,    1,    1,    1,    1,    1,    9,    1,
			   10,   11,   12,   13,    1,    1,    1,    1,    1,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   14,   15,   16,   17,    1,    1,    1,    1,
			   18,    1,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   19,   20,   21,   22,    1,    1,
			    1,    1,    1,   23,   23,   23,   23,   23,   23,   23, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    2,    3,    4,    6,    9,   11,
			   14,   17,   20,   23,   26,   29,   32,   34,   37,   40,
			   43,   46,   49,   52,   55,   58,   62,   66,   70,   73,
			   76,   79,   82,   85,   89,   93,   97,  101,  104,  106,
			  109,  112,  114,  117,  120,  123,  126,  129,  132,  135,
			  138,  141,  144,  147,  150,  153,  156,  159,  162,  165,
			  168,  171,  173,  175,  177,  179,  181,  183,  185,  187,
			  189,  191,  194,  196,  198,  200,  202,  204,  206,  208,
			  210,  212,  214,  215,  216,  217,  218,  219,  220,  221,
			  224,  227,  228,  229,  230,  231,  232,  233,  234,  235,

			  236,  237,  238,  239,  240,  241,  242,  243,  244,  244,
			  245,  246,  247,  248,  249,  250,  251,  252,  253,  254,
			  256,  257,  258,  258,  260,  262,  263,  265,  266,  267,
			  267,  269,  269,  270,  271,  273,  274,  274,  274,  274,
			  274,  274,  274,  274,  275,  276,  277,  278,  278,  278,
			  278,  278,  278,  278,  278,  278,  279,  280,  280,  280,
			  280,  280,  280,  280,  280,  281,  282,  283,  284,  285,
			  286,  287,  288,  289,  290,  291,  292,  293,  294,  295,
			  296,  297,  298,  299,  300,  301,  302,  304,  305,  306,
			  307,  308,  309,  310,  311,  312,  313,  314,  315,  316,

			  317,  317,  317,  317,  317,  317,  317,  318,  319,  320,
			  321,  322,  323,  324,  325,  326,  326,  326,  326,  327,
			  329,  330,  331,  332,  334,  335,  336,  337,  338,  339,
			  340,  341,  343,  344,  345,  346,  347,  348,  349,  350,
			  351,  352,  353,  354,  355,  356,  356,  358,  360,  360,
			  360,  360,  360,  360,  360,  360,  360,  360,  362,  364,
			  365,  366,  367,  368,  369,  370,  371,  372,  373,  374,
			  375,  376,  377,  378,  379,  380,  381,  382,  383,  384,
			  385,  386,  387,  387,  388,  389,  390,  391,  392,  393,
			  394,  395,  396,  397,  398,  399,  400,  401,  402,  403,

			  404,  405,  406,  407,  408,  409,  410,  411,  412,  414,
			  414,  414,  415,  417,  418,  420,  422,  422,  425,  427,
			  430,  432,  435,  437,  439,  439,  440,  440,  440,  440,
			  440,  440,  440,  441,  442,  443,  444,  444,  444,  444,
			  444,  444,  444,  445,  447,  447,  447,  447,  447,  447,
			  447,  448,  449,  450,  451,  452,  453,  454,  455,  456,
			  457,  458,  459,  460,  462,  463,  464,  465,  466,  467,
			  468,  469,  470,  471,  472,  473,  474,  475,  476,  477,
			  478,  479,  481,  482,  484,  485,  486,  487,  488,  489,
			  490,  491,  492,  493,  494,  495,  496,  497,  498,  500,

			  500,  500,  501,  501,  501,  501,  501,  501,  501,  501,
			  502,  502,  502,  502,  502,  502,  502,  502,  503,  504,
			  505,  506,  507,  508,  509,  510,  511,  512,  513,  514,
			  515,  516,  517,  518,  518,  519,  519,  519,  519,  519,
			  519,  519,  520,  521,  522,  523,  524,  525,  526,  527,
			  528,  529,  530,  531,  532,  533,  534,  535,  536,  537,
			  538,  539,  540,  541,  542,  543,  544,  545,  546,  547,
			  548,  549,  550,  551,  552,  553,  555,  555,  557,  557,
			  559,  559,  559,  559,  561,  563,  565,  565,  565,  565,
			  565,  565,  565,  567,  569,  569,  569,  570,  571,  573,

			  573,  573,  574,  574,  574,  575,  576,  577,  578,  579,
			  580,  581,  582,  583,  584,  585,  586,  587,  588,  589,
			  590,  591,  592,  593,  594,  595,  596,  597,  598,  599,
			  600,  601,  602,  603,  604,  605,  606,  607,  608,  609,
			  611,  612,  613,  614,  615,  616,  618,  619,  620,  621,
			  622,  623,  625,  625,  625,  625,  625,  625,  625,  625,
			  625,  625,  625,  625,  625,  626,  627,  628,  629,  629,
			  629,  629,  630,  631,  632,  633,  635,  635,  635,  637,
			  637,  641,  641,  643,  643,  643,  645,  646,  647,  648,
			  650,  652,  653,  654,  655,  656,  657,  658,  659,  660,

			  662,  663,  664,  665,  666,  667,  669,  670,  671,  673,
			  674,  675,  676,  677,  679,  680,  681,  682,  683,  684,
			  685,  686,  687,  688,  689,  690,  691,  693,  694,  695,
			  696,  697,  698,  699,  700,  700,  700,  700,  700,  700,
			  701,  701,  703,  703,  704,  705,  709,  709,  709,  711,
			  711,  712,  712,  713,  715,  717,  718,  720,  721,  722,
			  723,  724,  725,  726,  727,  728,  729,  730,  731,  732,
			  733,  735,  736,  738,  739,  740,  741,  742,  743,  744,
			  745,  746,  747,  748,  749,  750,  751,  753,  754,  755,
			  757,  758,  760,  761,  762,  763,  764,  765,  765,  766,

			  766,  766,  766,  770,  770,  771,  772,  772,  772,  773,
			  774,  775,  777,  778,  780,  782,  783,  784,  785,  787,
			  788,  790,  791,  792,  793,  794,  795,  796,  797,  799,
			  801,  802,  803,  805,  806,  807,  808,  809,  810,  811,
			  812,  813,  814,  815,  817,  818,  819,  820,  821,  822,
			  823,  823,  824,  824,  826,  826,  826,  827,  828,  828,
			  829,  830,  831,  832,  833,  834,  835,  837,  838,  839,
			  840,  841,  842,  843,  845,  847,  848,  849,  851,  853,
			  854,  855,  857,  858,  859,  861,  862,  864,  865,  866,
			  867,  868,  869,  871,  871,  873,  874,  875,  876,  878,

			  879,  880,  881,  882,  883,  884,  886,  887,  888,  889,
			  891,  892,  894,  895,  896,  897,  898,  899,  900,  902,
			  903,  905,  906,  907,  908,  910,  911,  912,  914,  915,
			  916,  917,  919,  920,  921,  922,  924,  925,  926,  927,
			  928,  930,  931,  932,  933,  935,  936,  938,  940,  941,
			  942,  943,  944,  945,  946,  947,  948,  950,  951,  952,
			  953,  955,  957,  958,  959,  961,  963,  965,  966,  967,
			  968,  969,  970,  972,  973,  975,  977,  979,  981,  981, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER]
		once
			Result := yy_fixed_array (<<
			    0,  134,  134,  155,  153,  154,    3,  153,  154,    4,
			  154,    1,  153,  154,    2,  153,  154,   10,  153,  154,
			  136,  153,  154,  101,  153,  154,   17,  153,  154,  136,
			  153,  154,  153,  154,   11,  153,  154,   12,  153,  154,
			   26,  153,  154,   25,  153,  154,    8,  153,  154,   24,
			  153,  154,    6,  153,  154,   27,  153,  154,  138,  145,
			  153,  154,  138,  145,  153,  154,  138,  145,  153,  154,
			    9,  153,  154,    7,  153,  154,   31,  153,  154,   29,
			  153,  154,   30,  153,  154,   99,  100,  153,  154,   99,
			  100,  153,  154,   99,  100,  153,  154,   99,  100,  153,

			  154,   15,  153,  154,  153,  154,   16,  153,  154,   28,
			  153,  154,  153,  154,  100,  153,  154,  100,  153,  154,
			  100,  153,  154,  100,  153,  154,  100,  153,  154,  100,
			  153,  154,  100,  153,  154,  100,  153,  154,  100,  153,
			  154,  100,  153,  154,  100,  153,  154,  100,  153,  154,
			  100,  153,  154,  100,  153,  154,  100,  153,  154,  100,
			  153,  154,  100,  153,  154,   13,  153,  154,   14,  153,
			  154,  153,  154,  153,  154,  153,  154,  153,  154,  153,
			  154,  153,  154,  153,  154,  134,  154,  132,  154,  133,
			  154,  128,  134,  154,  131,  154,  134,  154,  134,  154,

			  134,  154,  134,  154,  134,  154,  134,  154,  134,  154,
			  134,  154,  134,  154,    3,    4,    1,    2,  136,  135,
			  135, -126,  136, -280, -127,  136, -281,  136,  136,  136,
			  136,  136,  136,  136,  101,  136,  136,  136,  136,  136,
			  136,  136,  136,  125,  125,  125,  125,  125,  125,  125,
			  125,  125,    5,   23,  148,  151,   18,   20,  138,  145,
			  138,  145,  145,  137,  145,  145,  145,  137,  145,   22,
			   21,   99,  100,  100,  100,  100,  100,   19,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,

			  100,  100,   80,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  134,  134,  134,
			  134,  134,  134,  134,  134,  132,  133,  128,  134,  134,
			  134,  131,  129,  134,  134,  134,  134,  134,  134,  134,
			  134,  130,  134,  134,  134,  134,  134,  134,  134,  134,
			  134,  134,  134,  134,  134,  134,  135,  136,  135,  136,
			 -126,  136, -127,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  125,  102,  125,  125,
			  125,  125,  125,  125,  125,  125,  125,  125,  125,  125,
			  125,  125,  125,  125,  125,  125,  125,  125,  125,  125,

			  125,  125,  125,  125,  125,  125,  125,  125,  125,  125,
			  125,  125,  148,  151,  146,  148,  151,  146,  138,  145,
			  138,  145,  141,  144,  145,  144,  145,  140,  143,  145,
			  143,  145,  139,  142,  145,  142,  145,  138,  145,   32,
			  100,  100,  100,  152,  100,   34,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			   55,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,   75,
			  100,  100,   79,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,   98,  100,

			  129,  130,  134,  134,  134,  134,  134,  134,  134,  134,
			  134,  134,  134,  134,  134,  134,  135,  135,  135,  136,
			  136,  136,  136,  125,  125,  125,  125,  125,  125,  119,
			  117,  118,  120,  121,  125,  122,  123,  103,  104,  105,
			  106,  107,  108,  109,  110,  111,  112,  113,  114,  115,
			  116,  125,  125,  148,  151,  148,  151,  148,  151,  147,
			  150,  138,  145,  138,  145,  138,  145,  138,  145,  100,
			  100,   97,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,

			  100,  100,  100,  100,  100,  100,  100,  100,  100,   82,
			  100,  100,  100,  100,  100,  100,   89,  100,  100,  100,
			  100,  100,  100,   96,  100,  134,  134,  134,  134,  125,
			  125,  125,  148,  148,  151,  148,  151,  147,  148,  150,
			  151,  147,  150,  138,  145,  100,  100,  100,   35,  100,
			   36,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			   50,  100,  100,  100,  100,  100,  100,   57,  100,  100,
			  100,   61,  100,  100,  100,  100,  100,   66,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,   85,  100,  100,  100,  100,  100,  100,  100,  100,

			  124,  148,  151,  151,  148,  147,  148,  150,  151,  147,
			  150,  146,  100,   87,  100,   33,  100,  100,   38,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,   56,  100,  100,   59,  100,  100,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
			  100,   76,  100,  100,  100,   84,  100,  100,   88,  100,
			  100,  100,  100,  100,  100,  148,  147,  148,  150,  151,
			  151,  147,  149,  151,  149,   48,  100,  100,   39,  100,
			   41,  100,  100,  100,  100,   45,  100,  100,   47,  100,
			  100,  100,  100,  100,  100,  100,  100,   62,  100,   63,

			  100,  100,  100,   67,  100,  100,  100,  100,  100,  100,
			  100,  100,  100,  100,  100,   86,  100,  100,  100,  100,
			  100,  100,  151,  151,  147,  148,  150,  151,  150,  100,
			  100,  100,  100,  100,  100,   49,  100,  100,  100,  100,
			  100,  100,  100,   64,  100,   65,  100,  100,  100,   70,
			  100,   71,  100,  100,  100,   74,  100,  100,  100,   81,
			  100,  100,   90,  100,  100,  100,  100,  100,  151,  150,
			  151,  150,  151,  150,  100,  100,   42,  100,  100,  100,
			  100,  100,  100,  100,   54,  100,  100,  100,  100,   69,
			  100,  100,   73,  100,  100,  100,  100,  100,  100,  100,

			   94,  100,  100,  150,  151,  100,  100,  100,   44,  100,
			  100,  100,   52,  100,  100,  100,  100,   68,  100,  100,
			  100,  100,   83,  100,  100,  100,  100,  100,   37,  100,
			  100,  100,  100,   51,  100,  100,   58,  100,   60,  100,
			  100,  100,  100,  100,  100,  100,  100,  100,   43,  100,
			  100,  100,  100,   77,  100,   78,  100,  100,  100,   93,
			  100,   95,  100,   40,  100,  100,  100,  100,  100,  100,
			   46,  100,  100,   72,  100,   91,  100,   92,  100,   53,
			  100, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER = 6630
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER = 878
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER = 879
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER = 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN = false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN = true
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN = true
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER = 154
			-- Number of rules

	yyEnd_of_buffer: INTEGER = 155
			-- End of buffer rule code

	yyLine_used: BOOLEAN = false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN = false
			-- Is `position' used?

	INITIAL: INTEGER = 0
	VERBATIM_STR1: INTEGER = 1
			-- Start condition codes

feature -- User-defined features



note
	copyright:	"Copyright (c) 1984-2011, Eiffel Software"
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
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- EDITOR_TEXTUAL_BON_SCANNER
