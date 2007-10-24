indexing

	description: "Scanners for Eiffel parsers"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class EIFFEL_SCANNER

inherit
	EIFFEL_SCANNER_SKELETON

	STRING_HANDLER

create
	make


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= PRAGMA)
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
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 39 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 39")
end
 ast_factory.create_break_as (Current)  
when 2 then
	yy_end := yy_end - 2
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 41 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 41")
end
 
				last_break_as_start_position := position
				last_break_as_start_line := line
				last_break_as_start_column := column
				ast_factory.set_buffer (token_buffer2, Current)
				set_start_condition (PRAGMA)					
		
when 3 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 50 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 50")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				last_line_pragma := ast_factory.new_line_pragma (Current)
			
when 4 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 55 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 55")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 5 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 59 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 59")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 6 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 63 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 63")
end

			less (0)
			ast_factory.create_break_as_with_data (token_buffer2, 
																last_break_as_start_line, 
																last_break_as_start_column, 
																last_break_as_start_position, 
																token_buffer2.count)
			set_start_condition (INITIAL)						
		
when 7 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 85 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 85")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_SEMICOLON, Current)
				last_token := TE_SEMICOLON
			
when 8 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 89 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 89")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_COLON, Current)
				last_token := TE_COLON
			
when 9 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 93 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 93")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_COMMA, Current)
				last_token := TE_COMMA
			
when 10 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 97 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 97")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DOTDOT, Current)
				last_token := TE_DOTDOT
			
when 11 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 101 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 101")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_QUESTION, Current)
				last_token := TE_QUESTION
			
when 12 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 105 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 105")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_TILDE, Current)
				last_token := TE_TILDE
			
when 13 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 109 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 109")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_CURLYTILDE, Current)
				last_token := TE_CURLYTILDE
			
when 14 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 113 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 113")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DOT, Current)
				last_token := TE_DOT
			
when 15 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 117 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 117")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_ADDRESS, Current)
				last_token := TE_ADDRESS
			
when 16 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 121 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 121")
end

				last_symbol_as_value := ast_factory.new_symbol_as (TE_ASSIGNMENT, Current)
				last_token := TE_ASSIGNMENT
			
when 17 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 125 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 125")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_ACCEPT, Current)
				last_token := TE_ACCEPT
			
when 18 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 129 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 129")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_EQ, Current)
				last_token := TE_EQ
			
when 19 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 133 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 133")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LT, Current)
				last_token := TE_LT
			
when 20 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 137 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 137")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_GT, Current)
				last_token := TE_GT
			
when 21 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 141 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 141")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LE, Current)
				last_token := TE_LE
			
when 22 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 145 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 145")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_GE, Current)
				last_token := TE_GE
			
when 23 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 149 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 149")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_NE, Current)
				last_token := TE_NE
			
when 24 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 153 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 153")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LPARAN, Current)
				last_token := TE_LPARAN
			
when 25 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 157 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 157")
end

				last_symbol_as_value := ast_factory.new_symbol_as (TE_RPARAN, Current)
				last_token := TE_RPARAN
			
when 26 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 161 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 161")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LCURLY, Current)
				last_token := TE_LCURLY
			
when 27 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 165 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 165")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_RCURLY, Current)
				last_token := TE_RCURLY
			
when 28 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 169 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 169")
end
				
				last_symbol_as_value := ast_factory.new_square_symbol_as (TE_LSQURE, Current)
				last_token := TE_LSQURE
			
when 29 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 173 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 173")
end
				
				last_symbol_as_value := ast_factory.new_square_symbol_as (TE_RSQURE, Current)
				last_token := TE_RSQURE
			
when 30 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 177 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 177")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_PLUS, Current)
				last_token := TE_PLUS
			
when 31 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 181 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 181")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_MINUS, Current)
				last_token := TE_MINUS
			
when 32 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 185 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 185")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_STAR, Current)
				last_token := TE_STAR
			
when 33 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 189 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 189")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_SLASH, Current)
				last_token := TE_SLASH
			
when 34 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 193 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 193")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_POWER, Current)
				last_token := TE_POWER
			
when 35 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 197 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 197")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_CONSTRAIN, Current)
				last_token := TE_CONSTRAIN
			
when 36 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 201 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 201")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_BANG, Current)
				last_token := TE_BANG
			
when 37 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 205 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 205")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LARRAY, Current)
				last_token := TE_LARRAY
			
when 38 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 209 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 209")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_RARRAY, Current)
				last_token := TE_RARRAY
			
when 39 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 213 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 213")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DIV, Current)
				last_token := TE_DIV
			
when 40 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 217 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 217")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_MOD, Current)
				last_token := TE_MOD
			
when 41 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 225 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 225")
end

				last_token := TE_FREE
				process_id_as
			
when 42 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 233 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 233")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AGENT, Current)
				last_token := TE_AGENT
			
when 43 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 237 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 237")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ALIAS, Current)
				last_token := TE_ALIAS
			
when 44 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 241 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 241")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ALL, Current)
				last_token := TE_ALL
			
when 45 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 245 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 245")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AND, Current)
				last_token := TE_AND
			
when 46 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 249 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 249")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AS, Current)
				last_token := TE_AS
			
when 47 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 253 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 253")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ASSIGN, Current)
				if last_keyword_as_value /= Void then
					last_keyword_as_id_index := last_keyword_as_value.index
				end
				last_token := TE_ASSIGN
			
when 48 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 260 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 260")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					Error_handler.insert_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `attribute', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 49 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 269 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 269")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_BIT, Current)
				last_token := TE_BIT
			
when 50 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 273 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 273")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CHECK, Current)
				last_token := TE_CHECK
			
when 51 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 277 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 277")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CLASS, Current)
				last_token := TE_CLASS
			
when 52 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 281 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 281")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CONVERT, Current)
				last_token := TE_CONVERT
			
when 53 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 285 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 285")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CONFINED, Current)
				last_token := TE_CONFINED
			
when 54 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 289 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 289")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CREATE, Current)
				last_token := TE_CREATE
			
when 55 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 293 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 293")
end
				
				last_keyword_as_value := ast_factory.new_creation_keyword_as (Current)
				last_token := TE_CREATION				
			
when 56 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 297 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 297")
end
				
				last_current_as_value := ast_factory.new_current_as (Current)
				last_token := TE_CURRENT
			
when 57 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 301 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 301")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DEBUG, Current)
				last_token := TE_DEBUG
			
when 58 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 305 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 305")
end
				
				last_deferred_as_value := ast_factory.new_deferred_as (Current)
				last_token := TE_DEFERRED			
			
when 59 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 309 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 309")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DO, Current)
				last_token := TE_DO
			
when 60 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 313 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 313")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSE, Current)
				last_token := TE_ELSE
			
when 61 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 317 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 317")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSEIF, Current)
				last_token := TE_ELSEIF
			
when 62 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 321 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 321")
end
				
				last_keyword_as_value := ast_factory.new_end_keyword_as (Current)
				last_token := TE_END
			
when 63 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 325 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 325")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ENSURE, Current)
				last_token := TE_ENSURE
			
when 64 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 329 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 329")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPANDED, Current)
				last_token := TE_EXPANDED
			
when 65 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 333 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 333")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPORT, Current)
				last_token := TE_EXPORT
			
when 66 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 337 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 337")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXTERNAL, Current)
				last_token := TE_EXTERNAL
			
when 67 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 341 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 341")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (False, Current)
				last_token := TE_FALSE
			
when 68 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 345 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 345")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FEATURE, Current)
				last_token := TE_FEATURE
			
when 69 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 349 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 349")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FROM, Current)
				last_token := TE_FROM
			
when 70 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 353 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 353")
end
				
				last_keyword_as_value := ast_factory.new_frozen_keyword_as (Current)
				last_token := TE_FROZEN
			
when 71 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 357 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 357")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IF, Current)
				last_token := TE_IF
			
when 72 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 361 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 361")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IMPLIES, Current)
				last_token := TE_IMPLIES
			
when 73 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 365 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 365")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INDEXING, Current)
				last_token := TE_INDEXING
			
when 74 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 369 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 369")
end
				
				last_keyword_as_value := ast_factory.new_infix_keyword_as (Current)
				last_token := TE_INFIX
			
when 75 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 373 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 373")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INHERIT, Current)
				last_token := TE_INHERIT
			
when 76 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 377 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 377")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INSPECT, Current)
				last_token := TE_INSPECT
			
when 77 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 381 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 381")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INVARIANT, Current)
				last_token := TE_INVARIANT
			
when 78 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 385 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 385")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IS, Current)
				last_token := TE_IS
			
when 79 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 389 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 389")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LIKE, Current)
				last_token := TE_LIKE
			
when 80 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 393 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 393")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOCAL, Current)
				last_token := TE_LOCAL
			
when 81 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 397 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 397")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOOP, Current)
				last_token := TE_LOOP
			
when 82 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 401 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 401")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_MODIFY, Current)
				last_token := TE_MODIFY
			
when 83 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 405 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 405")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_NOT, Current)
				last_token := TE_NOT
			
when 84 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 409 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 409")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					Error_handler.insert_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `note', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 85 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 418 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 418")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OBSOLETE, Current)
				last_token := TE_OBSOLETE
			
when 86 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 422 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 422")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OLD, Current)
				last_token := TE_OLD
			
when 87 then
	yy_end := yy_end - 1
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 438 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 438")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text,  line, column, position, 4)
				last_token := TE_ONCE_STRING
			
when 88 then
	yy_end := yy_end - 1
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 442 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 442")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text_substring (1, 4),  line, column, position, 4)
					-- Assume all trailing characters are in the same line (which would be false if '\n' appears).
				ast_factory.create_break_as_with_data (text_substring (5, text_count), line, column + 4, position + 4, text_count - 4)
				last_token := TE_ONCE_STRING			
			
when 89 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 449 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 449")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ONCE, Current)
				last_token := TE_ONCE
			
when 90 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 453 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 453")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					Error_handler.insert_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `only', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 91 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 462 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 462")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OR, Current)
				last_token := TE_OR
			
when 92 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 466 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 466")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_PARTIAL_CLASS, Current)
				last_token := TE_PARTIAL_CLASS
			
when 93 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 470 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 470")
end
				
				last_keyword_as_value := ast_factory.new_precursor_keyword_as (Current)
				last_token := TE_PRECURSOR
			
when 94 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 474 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 474")
end
				
				last_keyword_as_value := ast_factory.new_prefix_keyword_as (Current)
				last_token := TE_PREFIX
			
when 95 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 478 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 478")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REDEFINE, Current)
				last_token := TE_REDEFINE
			
when 96 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 482 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 482")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REFERENCE, Current)
				last_token := TE_REFERENCE
			
when 97 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 486 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 486")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RENAME, Current)
				last_token := TE_RENAME
			
when 98 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 490 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 490")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REQUIRE, Current)
				last_token := TE_REQUIRE
			
when 99 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 494 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 494")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RESCUE, Current)
				last_token := TE_RESCUE
			
when 100 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 498 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 498")
end
					
				last_result_as_value := ast_factory.new_result_as (Current)
				last_token := TE_RESULT
			
when 101 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 502 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 502")
end
				
				last_retry_as_value := ast_factory.new_retry_as (Current)
				last_token := TE_RETRY
			
when 102 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 506 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 506")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SELECT, Current)
				last_token := TE_SELECT
			
when 103 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 510 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 510")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SEPARATE, Current)
				last_token := TE_SEPARATE
			
when 104 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 514 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 514")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_STRIP, Current)
				last_token := TE_STRIP
			
when 105 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 518 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 518")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_THEN, Current)
				last_token := TE_THEN
			
when 106 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 522 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 522")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (True, Current)
				last_token := TE_TRUE
			
when 107 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 526 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 526")
end

				last_token := TE_TUPLE
				process_id_as
			
when 108 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 530 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 530")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNDEFINE, Current)
				last_token := TE_UNDEFINE
			
when 109 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 534 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 534")
end
				
				last_unique_as_value := ast_factory.new_unique_as (Current)
				last_token := TE_UNIQUE
			
when 110 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 538 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 538")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNTIL, Current)
				last_token := TE_UNTIL
			
when 111 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 542 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 542")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_USE, Current)
				last_token := TE_USE
			
when 112 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 546 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 546")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_VARIANT, Current)
				last_token := TE_VARIANT
			
when 113 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 550 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 550")
end
				
				last_void_as_value := ast_factory.new_void_as (Current)
				last_token := TE_VOID
			
when 114 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 554 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 554")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_WHEN, Current)
				last_token := TE_WHEN
			
when 115 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 558 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 558")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_XOR, Current)
				last_token := TE_XOR
			
when 116 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 566 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 566")
end

				last_token := TE_ID
				process_id_as
			
when 117 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 573 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 573")
end

				last_token := TE_A_BIT			
				last_id_as_value := ast_factory.new_filled_bit_id_as (Current)
			
when 118 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 581 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 581")
end
		-- This a trick to avoid having:
					--     when 1..2 then
					-- to be be erroneously recognized as:
					--     `when' `1.' `.2' `then'
					-- instead of:
					--     `when' `1' `..' `2' `then'

				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 119 then
	yy_end := yy_end - 2
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 582 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 582")
end
		-- This a trick to avoid having:
					--     when 1..2 then
					-- to be be erroneously recognized as:
					--     `when' `1.' `.2' `then'
					-- instead of:
					--     `when' `1' `..' `2' `then'

				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 120 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 594 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 594")
end
		-- Recognizes hexadecimal integer numbers.
				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 121 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 602 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 602")
end

				token_buffer.clear_all
				append_text_to_string (token_buffer)
				if not Case_sensitive then
					token_buffer.to_lower
				end				
				last_token := TE_REAL
			
when 122 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 614 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 614")
end

				token_buffer.clear_all
				token_buffer.append_character (text_item (2))
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 123 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 620 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 620")
end

					-- This is not correct Eiffel!
				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 124 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 627 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 627")
end

				token_buffer.clear_all
				token_buffer.append_character ('%A')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 125 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 633 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 633")
end

				token_buffer.clear_all
				token_buffer.append_character ('%B')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 126 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 639 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 639")
end

				token_buffer.clear_all
				token_buffer.append_character ('%C')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 127 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 645 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 645")
end

				token_buffer.clear_all
				token_buffer.append_character ('%D')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 128 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 651 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 651")
end

				token_buffer.clear_all
				token_buffer.append_character ('%F')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 129 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 657 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 657")
end

				token_buffer.clear_all
				token_buffer.append_character ('%H')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 130 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 663 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 663")
end

				token_buffer.clear_all
				token_buffer.append_character ('%L')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 131 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 669 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 669")
end

				token_buffer.clear_all
				token_buffer.append_character ('%N')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 132 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 675 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 675")
end

				token_buffer.clear_all
				token_buffer.append_character ('%Q')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 133 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 681 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 681")
end

				token_buffer.clear_all
				token_buffer.append_character ('%R')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 134 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 687 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 687")
end

				token_buffer.clear_all
				token_buffer.append_character ('%S')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 135 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 693 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 693")
end

				token_buffer.clear_all
				token_buffer.append_character ('%T')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 136 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 699 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 699")
end

				token_buffer.clear_all
				token_buffer.append_character ('%U')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 137 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 705 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 705")
end

				token_buffer.clear_all
				token_buffer.append_character ('%V')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 138 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 711 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 711")
end

				token_buffer.clear_all
				token_buffer.append_character ('%%')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 139 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 717 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 717")
end

				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 140 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 723 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 723")
end

				token_buffer.clear_all
				token_buffer.append_character ('%"')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 141 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 729 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 729")
end

				token_buffer.clear_all
				token_buffer.append_character ('%(')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 142 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 735 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 735")
end

				token_buffer.clear_all
				token_buffer.append_character ('%)')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 143 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 741 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 741")
end

				token_buffer.clear_all
				token_buffer.append_character ('%<')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 144 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 747 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 747")
end

				token_buffer.clear_all
				token_buffer.append_character ('%>')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 145 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 753 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 753")
end

				process_character_code (text_substring (4, text_count - 2).to_integer)
			
when 146 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 756 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 756")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 147 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 757 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 757")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 148 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 766 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 766")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LT
			
when 149 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 770 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 770")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GT
			
when 150 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 774 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 774")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LE
			
when 151 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 778 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 778")
end
			
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GE
			
when 152 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 782 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 782")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_PLUS
			
when 153 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 786 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 786")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MINUS
			
when 154 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 790 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 790")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_STAR
			
when 155 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 794 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 794")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_SLASH
			
when 156 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 798 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 798")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_POWER
			
when 157 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 802 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 802")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_DIV
			
when 158 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 806 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 806")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MOD
			
when 159 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 810 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 810")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_BRACKET
			
when 160 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 814 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 814")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND
			
when 161 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 820 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 820")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 9, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND_THEN
			
when 162 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 826 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 826")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_IMPLIES
			
when 163 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 832 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 832")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_NOT
			
when 164 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 838 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 838")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 3, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR
			
when 165 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 844 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 844")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR_ELSE
			
when 166 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 850 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 850")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_XOR
			
when 167 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 856 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 856")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, text_count - 1, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_FREE
				if token_buffer.count > maximum_string_length then
					report_too_long_string (token_buffer)
				end
			
when 168 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 865 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 865")
end

					-- Empty string.
				ast_factory.set_buffer (token_buffer2, Current)
				string_position := position
				last_token := TE_EMPTY_STRING
			
when 169 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 871 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 871")
end

					-- Regular string.
				string_position := position
				token_buffer.clear_all
				append_text_substring_to_string (2, text_count - 1, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STRING
				if token_buffer.count > maximum_string_length then
					report_too_long_string (token_buffer)
				end
			
when 170 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 882 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 882")
end

					-- Verbatim string.
				string_position := position
				verbatim_start_position := position
				token_buffer.clear_all
				verbatim_marker.clear_all
				if text_item (text_count) = '[' then
					verbatim_marker.append_character (']')
				else
					verbatim_marker.append_character ('}')
				end
				ast_factory.set_buffer (token_buffer2, Current)				
				append_text_substring_to_string (2, text_count - 1, verbatim_marker)
				set_start_condition (VERBATIM_STR3)
			
when 171 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 900 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 900")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (VERBATIM_STR1)
			
when 172 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 904 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 904")
end

					-- No final bracket-double-quote.
				append_text_to_string (token_buffer)
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 173 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 924 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 924")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				if is_verbatim_string_closer then
					set_start_condition (INITIAL)
						-- Remove the trailing new-line.
					if token_buffer.count >= 2 then
						check new_line: token_buffer.item (token_buffer.count) = '%N' end
						if token_buffer.item (token_buffer.count - 1) = '%R' then
								-- Under Windows a we have \r\n.
								-- Remove both characters.
							token_buffer.set_count (token_buffer.count - 2)
						else
							token_buffer.set_count (token_buffer.count - 1)
						end
					elseif token_buffer.count = 1 then
						check new_line: token_buffer.item (1) = '%N' end
						token_buffer.clear_all
					end
					if verbatim_marker.item (1) = ']' then
						if not has_old_verbatim_strings then
							align_left (token_buffer)
						end
						if has_old_verbatim_strings_warning then
							Error_handler.insert_warning (
								create {SYNTAX_WARNING}.make (line, column, filename,
									once "Default verbatim string handling is changed to follow standard semantics %
									%with alignment instead of previous non-standard one without alignment."))
						end
					end
					if token_buffer.is_empty then
							-- Empty string.
						last_token := TE_EMPTY_VERBATIM_STRING
					else
						last_token := TE_VERBATIM_STRING
						if token_buffer.count > maximum_string_length then
							report_too_long_string (token_buffer)
						end
					end
				else
					append_text_to_string (token_buffer)
					set_start_condition (VERBATIM_STR2)
				end
			
when 174 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 967 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 967")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (VERBATIM_STR2)
			
when 175 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 972 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 972")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
			
when 176 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 980 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 980")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 177 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 996 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 996")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
				set_start_condition (VERBATIM_STR1)
			
when 178 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1005 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1005")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 179 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1018 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1018")
end

					-- String with special characters.
				ast_factory.set_buffer (token_buffer2, Current)
				string_position := position
				string_start_position := position
				token_buffer.clear_all
				if text_count > 1 then
					append_text_substring_to_string (2, text_count, token_buffer)
				end
				set_start_condition (SPECIAL_STR)
			
when 180 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1030 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1030")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
			
when 181 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1034 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1034")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%A")
				token_buffer.append_character ('%A')
			
when 182 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1038 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1038")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%B")
				token_buffer.append_character ('%B')
			
when 183 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1042 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1042")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%C")
				token_buffer.append_character ('%C')
			
when 184 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1046 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1046")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%D")
				token_buffer.append_character ('%D')
			
when 185 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1050 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1050")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%F")
				token_buffer.append_character ('%F')
			
when 186 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1054 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1054")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%H")
				token_buffer.append_character ('%H')
			
when 187 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1058 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1058")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%L")
				token_buffer.append_character ('%L')
			
when 188 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1062 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1062")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%N")
				token_buffer.append_character ('%N')
			
when 189 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1066 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1066")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%Q")
				token_buffer.append_character ('%Q')
			
when 190 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1070 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1070")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%R")
				token_buffer.append_character ('%R')
			
when 191 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1074 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1074")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%S")
				token_buffer.append_character ('%S')
			
when 192 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1078 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1078")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%T")
				token_buffer.append_character ('%T')
			
when 193 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1082 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1082")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%U")
				token_buffer.append_character ('%U')
			
when 194 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1086 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1086")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%V")
				token_buffer.append_character ('%V')
			
when 195 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1090 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1090")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%%")
				token_buffer.append_character ('%%')
			
when 196 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1094 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1094")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%'")
				token_buffer.append_character ('%'')
			
when 197 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1098 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1098")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%"")
				token_buffer.append_character ('%"')
			
when 198 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1102 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1102")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%(")
				token_buffer.append_character ('%(')
			
when 199 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1106 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1106")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%)")
				token_buffer.append_character ('%)')
			
when 200 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1110 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1110")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%<")
				token_buffer.append_character ('%<')
			
when 201 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1114 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1114")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%>")
				token_buffer.append_character ('%>')
			
when 202 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1118 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1118")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				process_string_character_code (text_substring (3, text_count - 1).to_integer)
			
when 203 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1122 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1122")
end

					-- This regular expression should actually be: %\n[ \t\r]*%
					-- Left as-is for compatibility with previous releases.
			ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 204 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1127 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1127")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				if text_count > 1 then
					append_text_substring_to_string (1, text_count - 1, token_buffer)
				end
				set_start_condition (INITIAL)
				if token_buffer.is_empty then
						-- Empty string.
					last_token := TE_EMPTY_STRING
				else
					last_token := TE_STRING
					if token_buffer.count > maximum_string_length then
						report_too_long_string (token_buffer)
					end
				end
			
when 205 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 1143 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1143")
end

					-- Bad special character.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (INITIAL)
				report_string_bad_special_character_error
			
when 206 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + 1
--|#line 1149 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1149")
end

					-- No final double-quote.
				set_start_condition (INITIAL)
				report_string_missing_quote_error (token_buffer)
			
when 207 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 1167 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1167")
end

				report_unknown_token_error (text_item (1))
			
when 208 then
yy_set_line_column
	yy_position := yy_position + 1
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end
last_token := yyError_token
fatal_error ("scanner jammed")
			else
				last_token := yyError_token
				fatal_error ("fatal scanner internal error: no action found")
			end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end

				terminate
			
when 1 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end

					-- No final double-quote.
				set_start_condition (INITIAL)
				report_string_missing_quote_error (token_buffer)
			
when 2 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 3 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 4 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 5 then
--|#line 0 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 0")
end
					
			ast_factory.create_break_as_with_data (token_buffer2, 
																last_break_as_start_line, 
																last_break_as_start_column, 
																last_break_as_start_position, 
																token_buffer2.count)
			set_start_condition (INITIAL)
			
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   14,   15,   16,   15,   17,   18,   19,   20,   14,
			   19,   21,   22,   23,   24,   25,   26,   27,   28,   29,
			   30,   31,   32,   33,   34,   35,   36,   37,   38,   19,
			   39,   40,   41,   42,   43,   44,   45,   45,   46,   45,
			   45,   47,   48,   49,   50,   51,   45,   52,   53,   54,
			   55,   56,   57,   58,   45,   45,   59,   60,   61,   62,
			   14,   14,   39,   40,   41,   42,   43,   44,   45,   45,
			   46,   45,   45,   47,   48,   49,   50,   51,   45,   52,
			   53,   54,   55,   56,   57,   58,   45,   45,   63,   19,
			   64,   65,   67,   67,  201,   68,   68,  202,   69,   69,

			   71,   72,   71,  590,   73,   71,   72,   71,  483,   73,
			   78,   79,   78,   78,   79,   78,   81,   82,   81,   81,
			   82,   81,   84,   84,   84,   84,   84,   84,  107,  109,
			  108,   83,  122,  123,   83,  113,  554,   85,  133,  110,
			   85,  111,  114,  112,  112,  112,  153,  115,  139,  116,
			  116,  117,  124,  125,  154,  161,   74,  437,  140,  159,
			  118,   74,  201,  539,  115,  205,  116,  116,  117,  115,
			  133,  117,  117,  117,  509,  505,  160,  118,  153,  262,
			  139,  376,  119,  208,  209,  208,  154,  161,   74,  120,
			  140,  159,  118,   74,   87,   88,  439,   89,   88,  210,

			  210,  210,   90,   91,  376,   92,  120,   93,  160,  118,
			  171,  120,  366,   94,  119,   95,  128,   88,   96,  151,
			  134,  129,  162,  130,  135,  152,   97,  136,  131,  132,
			  137,   98,   99,  138,  141,  365,  142,  163,  167,  364,
			  363,  100,  171,  168,  101,  102,  143,  103,  128,  362,
			   96,  151,  134,  129,  162,  130,  135,  152,   97,  136,
			  131,  132,  137,   98,   99,  138,  141,  144,  142,  163,
			  167,  145,  147,  100,  169,  168,  104,   88,  143,  148,
			  149,  155,  164,  172,  146,  150,  212,  215,  170,   89,
			  361,  156,  165,  157,  270,  166,  273,  158,  360,  144,

			  210,  210,  210,  145,  147,  359,  169,   84,   84,   84,
			  358,  148,  149,  155,  164,  172,  146,  150,  201,  215,
			  170,  202,   85,  156,  165,  157,  270,  166,  273,  158,
			  177,  177,  177,  357,  178,  216,  104,  179,   89,  180,
			  181,  182,  203,  201,  203,  217,  202,  183,   89,   86,
			   86,  356,   86,  184,  213,  185,  355,   89,  186,  187,
			  188,  189,  354,  190,  218,  191,  353,   89,  104,  192,
			  219,  193,  352,   89,  194,  195,  196,  197,  198,  199,
			  351,  221,  349,  220,   89,  104,  348,  223,  212,  234,
			   89,   89,   89,  212,  212,  104,   89,   89,  204,  212,

			  347,  222,   89,  212,  214,  212,   89,  224,   89,  346,
			  274,  230,  231,  230,  104,  212,  271,  104,   89,  272,
			  104,  345,  268,  268,  268,  225,  275,  104,  276,  226,
			  204,  104,  227,  260,  260,  260,  214,  104,  104,  104,
			  228,  229,  274,  104,  104,  277,  104,  261,  271,  104,
			  332,  272,  104,  104,  207,  104,  233,  225,  275,  278,
			  276,  226,  269,  104,  227,  104,  176,  232,  259,  104,
			  104,  104,  228,  229,  236,  104,  104,  277,  279,  261,
			  280,  104,  230,  231,  230,  104,  212,  104,  281,   89,
			  262,  278,  263,  263,  263,  282,  284,  104,  115,  283,

			  265,  265,  266,  285,  109,  115,  264,  266,  266,  266,
			  279,  118,  280,  287,  289,  211,  290,  288,  286,  291,
			  281,  292,  298,  207,  301,  176,  302,  282,  284,  303,
			  304,  283,  307,  308,  317,  285,  104,  174,  264,  201,
			  120,  173,  205,  118,  126,  287,  289,  120,  290,  288,
			  286,  291,  318,  292,  298,  293,  301,  294,  302,  295,
			  121,  303,  304,  639,  307,  308,  317,  319,  104,  237,
			  296,  299,  238,  297,  239,  240,  241,   76,  177,  177,
			  177,   76,  242,  300,  318,  329,  639,  293,  243,  294,
			  244,  295,  305,  245,  246,  247,  248,  639,  249,  319,

			  250,  306,  296,  299,  251,  297,  252,  320,  324,  253,
			  254,  255,  256,  257,  258,  300,  309,  315,  310,  325,
			  321,  316,  326,  327,  305,  322,  311,  328,  380,  312,
			  381,  313,  314,  306,  639,  334,  323,  639,   89,  320,
			  324,  330,  330,  330,  208,  209,  208,  382,  309,  315,
			  310,  325,  321,  316,  326,  327,  639,  322,  311,  328,
			  380,  312,  381,  313,  314,  203,  201,  203,  323,  202,
			  210,  210,  210,   86,  230,  231,  230,  335,  213,  382,
			   89,   89,  333,  231,  333,  104,  639,  336,  212,  639,
			   89,   89,  212,  639,  212,   89,  212,   89,  340,   89,

			  341,  639,  639,   89,  230,  231,  230,  343,  212,  383,
			   89,   89,  350,  350,  350,  337,  344,  104,  368,   89,
			  368,  204,  639,  369,  369,  369,  639,  104,  214,  384,
			  115,  338,  374,  374,  375,  342,  215,  104,  104,  339,
			  639,  383,  104,  118,  104,  385,  104,  337,  639,  372,
			  104,  372,  639,  204,  373,  373,  373,  104,  104,  104,
			  214,  384,  639,  338,  639,  639,  104,  342,  215,  104,
			  104,  339,  120,  388,  104,  118,  104,  385,  104,  367,
			  367,  367,  104,  370,  370,  370,  379,  379,  379,  104,
			  104,  386,  115,  261,  375,  375,  375,  371,  104,  377,

			  389,  378,  378,  378,  390,  388,  391,  387,  392,  639,
			  393,  396,  397,  394,  398,  399,  401,  402,  403,  404,
			  405,  406,  407,  386,  408,  261,  269,  395,  400,  371,
			  409,  410,  389,  411,  120,  412,  390,  413,  391,  387,
			  392,  269,  393,  396,  397,  394,  398,  399,  401,  402,
			  403,  404,  405,  406,  407,  414,  408,  415,  416,  395,
			  400,  417,  409,  410,  418,  411,  419,  412,  420,  413,
			  421,  424,  425,  422,  426,  427,  428,  429,  430,  431,
			  432,  433,  434,  435,  436,  443,  639,  414,   89,  415,
			  416,  423,  440,  417,  441,  639,  418,   89,  419,  639,

			  420,  454,  421,  424,  425,  422,  426,  427,  428,  429,
			  430,  431,  432,  433,  434,  435,  436,  437,  438,  438,
			  438,  639,  639,  423,  333,  231,  333,  212,  639,  212,
			   89,  445,   89,  454,   89,  104,  446,  350,  350,  350,
			  447,  447,  447,  455,  104,  369,  369,  369,  369,  369,
			  369,  449,  449,  449,  261,  456,  639,  444,  373,  373,
			  373,  457,  442,  458,  450,  371,  450,  104,  639,  451,
			  451,  451,  373,  373,  373,  455,  104,  104,  215,  104,
			  448,  104,  511,  511,  511,  459,  261,  456,  452,  444,
			  374,  374,  375,  457,  442,  458,  452,  371,  375,  375,

			  375,  118,  377,  460,  453,  453,  453,  461,  462,  104,
			  215,  104,  377,  104,  379,  379,  379,  459,  463,  464,
			  465,  466,  639,  467,  468,  469,  470,  471,  472,  473,
			  269,  474,  475,  118,  476,  460,  477,  478,  269,  461,
			  462,  479,  480,  481,  269,  482,  451,  451,  451,  486,
			  463,  464,  465,  466,  269,  467,  468,  469,  470,  471,
			  472,  473,  487,  474,  475,  488,  476,  489,  477,  478,
			  490,  491,  492,  479,  480,  481,  493,  482,  483,  483,
			  483,  486,  484,  494,  495,  496,  497,  498,  499,  500,
			  501,  502,  503,  485,  487,  212,  639,  488,   89,  489,

			  639,  639,  490,  491,  492,  451,  451,  451,  493,  437,
			  504,  504,  504,  639,  639,  494,  495,  496,  497,  498,
			  499,  500,  501,  502,  503,  212,  212,  516,   89,   89,
			  517,  639,  447,  447,  447,  518,  519,  522,  506,  512,
			  512,  512,  523,  639,  639,  104,  510,  262,  524,  512,
			  512,  512,  515,  371,  379,  379,  379,  507,  525,  516,
			  520,  508,  517,  514,  521,  526,  527,  518,  519,  522,
			  506,  528,  529,  530,  523,  104,  104,  104,  510,  513,
			  524,  531,  532,  533,  534,  371,  535,  536,  537,  507,
			  525,  639,  520,  508,  120,  514,  521,  526,  527,  540,

			  541,  542,  543,  528,  529,  530,  544,  104,  104,  545,
			  546,  547,  548,  531,  532,  533,  534,  549,  535,  536,
			  537,  483,  483,  483,  550,  538,  551,  552,  553,  639,
			  639,  540,  541,  542,  543,  639,  485,  212,  544,  639,
			   89,  545,  546,  547,  548,  212,  639,  212,   89,  549,
			   89,  567,  639,  560,  560,  560,  550,  639,  551,  552,
			  553,  512,  512,  512,  558,  639,  558,  561,  555,  559,
			  559,  559,  639,  556,  568,  562,  563,  563,  563,  564,
			  569,  564,  570,  567,  565,  565,  565,  104,  262,  557,
			  563,  563,  563,  571,  572,  104,  573,  104,  574,  561,

			  555,  575,  576,  577,  566,  556,  568,  562,  578,  579,
			  580,  581,  569,  582,  570,  583,  584,  585,  586,  104,
			  587,  557,  588,  589,  639,  571,  572,  104,  573,  104,
			  574,  639,  639,  575,  576,  577,  566,  559,  559,  559,
			  578,  579,  580,  581,  603,  582,  639,  583,  584,  585,
			  586,  639,  587,  212,  588,  589,   89,  212,  212,  639,
			   89,   89,  559,  559,  559,  594,  594,  594,  595,  639,
			  595,  639,  604,  596,  596,  596,  603,  605,  597,  561,
			  597,  591,  606,  598,  598,  598,  593,  599,  599,  599,
			  565,  565,  565,  565,  565,  565,  607,  608,  609,  592,

			  610,  600,  611,  104,  604,  614,  615,  104,  104,  605,
			  601,  561,  601,  591,  606,  602,  602,  602,  593,  612,
			  612,  612,  616,  617,  618,  561,  639,  639,  607,  608,
			  609,  592,  610,  600,  611,  104,  639,  614,  615,  104,
			  104,  212,  620,  621,   89,   89,   89,  625,  639,  613,
			  631,  448,  639,   89,  616,  617,  618,  561,  596,  596,
			  596,  596,  596,  596,  598,  598,  598,  598,  598,  598,
			  622,  622,  622,  602,  602,  602,  626,  628,  619,  625,
			  623,  613,  623,  629,  600,  624,  624,  624,  602,  602,
			  602,  104,  104,  104,  639,  630,  612,  612,  612,  632,

			  104,  633,  600,  624,  624,  624,  634,  635,  626,  628,
			  619,  624,  624,  624,  636,  629,  600,  637,  638,  267,
			  267,  267,  639,  104,  104,  104,  627,  630,  513,  639,
			  639,  632,  104,  633,  600,  639,  639,  639,  634,  635,
			  639,  639,  639,  639,  639,  639,  636,  639,  639,  637,
			  638,  639,  639,  639,  639,  639,  639,  639,  627,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   70,   70,   70,   70,   70,   70,
			   70,   70,   70,   70,   70,   70,   70,   70,   70,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,

			   75,   75,   75,   75,   77,   77,   77,   77,   77,   77,
			   77,   77,   77,   77,   77,   77,   77,   77,   77,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   86,  639,   86,   86,   86,   86,
			   86,   86,   86,   86,   86,   86,   86,   86,   86,  105,
			  639,  105,  639,  105,  105,  105,  105,  105,  105,  105,
			  105,  105,  106,  639,  106,  106,  106,  106,  106,  106,
			  106,  106,  106,  106,  106,  106,  106,  127,  127,  127,
			  127,  127,  127,  127,  127,  127,  175,  639,  175,  175,
			  175,  639,  175,  175,  175,  175,  175,  175,  175,  175,

			  175,  200,  200,  200,  200,  200,  200,  200,  200,  200,
			  200,  200,  200,  200,  200,  200,  204,  204,  204,  204,
			  204,  204,  204,  204,  204,  204,  204,  204,  204,  204,
			  204,  206,  206,  206,  206,  206,  206,  206,  206,  206,
			  206,  206,  206,  206,  206,  206,   88,  639,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   88,   88,
			   88,   89,  639,   89,  639,   89,   89,   89,   89,   89,
			   89,   89,   89,   89,   89,   89,  235,  639,  235,  235,
			  235,  235,  235,  235,  235,  235,  235,  235,  235,  235,
			  235,  331,  639,  331,  331,  331,  331,  331,  331,  331,

			  331,  331,  331,  331,  331,  331,  539,  539,  539,  539,
			  539,  539,  539,  539,  539,  539,  539,  539,  539,  539,
			  539,  590,  639,  590,  590,  590,  590,  590,  590,  590,
			  590,  590,  590,  590,  590,  590,   13,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,

			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639, yy_Dummy>>)
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
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    3,    4,   70,    3,    4,   70,    3,    4,

			    5,    5,    5,  554,    5,    6,    6,    6,  539,    6,
			    9,    9,    9,   10,   10,   10,   11,   11,   11,   12,
			   12,   12,   15,   15,   15,   16,   16,   16,   21,   27,
			   21,   11,   35,   35,   12,   29,  505,   15,   40,   27,
			   16,   28,   29,   28,   28,   28,   48,   30,   42,   30,
			   30,   30,   37,   37,   49,   52,    5,  504,   42,   51,
			   30,    6,   74,  485,   31,   74,   31,   31,   31,   32,
			   40,   32,   32,   32,  446,  439,   51,   31,   48,  377,
			   42,  376,   30,   78,   78,   78,   49,   52,    5,   30,
			   42,   51,   30,    6,   18,   18,  332,   18,   18,   81,

			   81,   81,   18,   18,  267,   18,   31,   18,   51,   31,
			   57,   32,  258,   18,   30,   18,   39,   18,   18,   47,
			   41,   39,   53,   39,   41,   47,   18,   41,   39,   39,
			   41,   18,   18,   41,   43,  257,   43,   53,   55,  256,
			  255,   18,   57,   55,   18,   18,   43,   18,   39,  254,
			   18,   47,   41,   39,   53,   39,   41,   47,   18,   41,
			   39,   39,   41,   18,   18,   41,   43,   44,   43,   53,
			   55,   44,   46,   18,   56,   55,   18,   18,   43,   46,
			   46,   50,   54,   58,   44,   46,   86,   89,   56,   86,
			  253,   50,   54,   50,  128,   54,  130,   50,  252,   44,

			   82,   82,   82,   44,   46,  251,   56,   84,   84,   84,
			  250,   46,   46,   50,   54,   58,   44,   46,  200,   89,
			   56,  200,   84,   50,   54,   50,  128,   54,  130,   50,
			   69,   69,   69,  249,   69,   90,   86,   69,   90,   69,
			   69,   69,   71,   71,   71,   91,   71,   69,   91,   88,
			   88,  248,   88,   69,   88,   69,  247,   88,   69,   69,
			   69,   69,  246,   69,   92,   69,  245,   92,   86,   69,
			   93,   69,  244,   93,   69,   69,   69,   69,   69,   69,
			  243,   94,  241,   93,   94,   90,  240,   95,   96,  103,
			   95,   96,  103,   97,   98,   91,   97,   98,   71,   99,

			  239,   94,   99,  100,   88,  102,  100,   95,  102,  238,
			  131,  101,  101,  101,   92,  101,  129,   90,  101,  129,
			   93,  237,  120,  120,  120,   96,  132,   91,  133,   97,
			   71,   94,   98,  112,  112,  112,   88,   95,   96,  103,
			   99,  100,  131,   97,   98,  134,   92,  112,  129,   99,
			  211,  129,   93,  100,  206,  102,  102,   96,  132,  135,
			  133,   97,  120,   94,   98,  101,  175,  101,  108,   95,
			   96,  103,   99,  100,  106,   97,   98,  134,  136,  112,
			  137,   99,  104,  104,  104,  100,  104,  102,  138,  104,
			  115,  135,  115,  115,  115,  139,  141,  101,  116,  139,

			  116,  116,  116,  142,   85,  117,  115,  117,  117,  117,
			  136,  116,  137,  143,  144,   83,  145,  143,  142,  146,
			  138,  148,  151,   75,  153,   66,  154,  139,  141,  155,
			  156,  139,  159,  160,  163,  142,  104,   64,  115,  204,
			  116,   60,  204,  116,   38,  143,  144,  117,  145,  143,
			  142,  146,  164,  148,  151,  149,  153,  149,  154,  149,
			   33,  155,  156,   13,  159,  160,  163,  165,  104,  107,
			  149,  152,  107,  149,  107,  107,  107,    8,  177,  177,
			  177,    7,  107,  152,  164,  177,    0,  149,  107,  149,
			  107,  149,  157,  107,  107,  107,  107,    0,  107,  165,

			  107,  157,  149,  152,  107,  149,  107,  166,  168,  107,
			  107,  107,  107,  107,  107,  152,  161,  162,  161,  169,
			  167,  162,  170,  171,  157,  167,  161,  172,  270,  161,
			  271,  161,  161,  157,    0,  220,  167,    0,  220,  166,
			  168,  183,  183,  183,  208,  208,  208,  274,  161,  162,
			  161,  169,  167,  162,  170,  171,    0,  167,  161,  172,
			  270,  161,  271,  161,  161,  203,  203,  203,  167,  203,
			  210,  210,  210,  214,  214,  214,  214,  222,  214,  274,
			  222,  214,  215,  215,  215,  220,    0,  224,  225,    0,
			  224,  225,  226,    0,  229,  226,  227,  229,  228,  227,

			  228,    0,    0,  228,  230,  230,  230,  232,  230,  275,
			  232,  230,  242,  242,  242,  225,  233,  220,  261,  233,
			  261,  203,    0,  261,  261,  261,    0,  222,  214,  277,
			  265,  226,  265,  265,  265,  229,  215,  224,  225,  227,
			    0,  275,  226,  265,  229,  278,  227,  225,    0,  264,
			  228,  264,    0,  203,  264,  264,  264,  232,  230,  222,
			  214,  277,    0,  226,    0,    0,  233,  229,  215,  224,
			  225,  227,  265,  280,  226,  265,  229,  278,  227,  260,
			  260,  260,  228,  263,  263,  263,  269,  269,  269,  232,
			  230,  279,  266,  260,  266,  266,  266,  263,  233,  268,

			  281,  268,  268,  268,  282,  280,  283,  279,  284,    0,
			  286,  288,  289,  287,  290,  291,  292,  293,  294,  295,
			  296,  297,  298,  279,  299,  260,  269,  287,  291,  263,
			  300,  301,  281,  302,  266,  303,  282,  305,  283,  279,
			  284,  268,  286,  288,  289,  287,  290,  291,  292,  293,
			  294,  295,  296,  297,  298,  306,  299,  307,  308,  287,
			  291,  308,  300,  301,  309,  302,  310,  303,  311,  305,
			  312,  314,  315,  313,  316,  317,  318,  319,  320,  321,
			  322,  323,  325,  326,  327,  339,    0,  306,  339,  307,
			  308,  313,  337,  308,  337,    0,  309,  337,  310,    0,

			  311,  380,  312,  314,  315,  313,  316,  317,  318,  319,
			  320,  321,  322,  323,  325,  326,  327,  330,  330,  330,
			  330,    0,    0,  313,  333,  333,  333,  338,    0,  340,
			  338,  342,  340,  380,  342,  339,  350,  350,  350,  350,
			  367,  367,  367,  381,  337,  368,  368,  368,  369,  369,
			  369,  370,  370,  370,  367,  382,    0,  340,  372,  372,
			  372,  383,  338,  384,  371,  370,  371,  339,    0,  371,
			  371,  371,  373,  373,  373,  381,  337,  338,  333,  340,
			  367,  342,  448,  448,  448,  385,  367,  382,  374,  340,
			  374,  374,  374,  383,  338,  384,  375,  370,  375,  375,

			  375,  374,  378,  386,  378,  378,  378,  387,  388,  338,
			  333,  340,  379,  342,  379,  379,  379,  385,  389,  390,
			  391,  392,    0,  393,  394,  395,  396,  397,  398,  400,
			  374,  401,  402,  374,  403,  386,  404,  405,  375,  387,
			  388,  406,  408,  410,  378,  412,  450,  450,  450,  415,
			  389,  390,  391,  392,  379,  393,  394,  395,  396,  397,
			  398,  400,  416,  401,  402,  417,  403,  418,  404,  405,
			  419,  420,  421,  406,  408,  410,  422,  412,  413,  413,
			  413,  415,  413,  423,  424,  425,  426,  427,  430,  431,
			  432,  433,  434,  413,  416,  440,    0,  417,  440,  418,

			    0,    0,  419,  420,  421,  451,  451,  451,  422,  438,
			  438,  438,  438,    0,    0,  423,  424,  425,  426,  427,
			  430,  431,  432,  433,  434,  442,  444,  456,  442,  444,
			  457,    0,  447,  447,  447,  460,  461,  463,  440,  449,
			  449,  449,  465,    0,    0,  440,  447,  452,  466,  452,
			  452,  452,  453,  449,  453,  453,  453,  442,  467,  456,
			  462,  444,  457,  452,  462,  468,  469,  460,  461,  463,
			  440,  470,  472,  473,  465,  442,  444,  440,  447,  449,
			  466,  474,  475,  477,  478,  449,  479,  481,  482,  442,
			  467,    0,  462,  444,  453,  452,  462,  468,  469,  486,

			  487,  488,  489,  470,  472,  473,  490,  442,  444,  491,
			  492,  493,  494,  474,  475,  477,  478,  496,  479,  481,
			  482,  483,  483,  483,  497,  483,  500,  501,  503,    0,
			    0,  486,  487,  488,  489,    0,  483,  506,  490,    0,
			  506,  491,  492,  493,  494,  507,    0,  508,  507,  496,
			  508,  517,    0,  511,  511,  511,  497,    0,  500,  501,
			  503,  512,  512,  512,  510,    0,  510,  511,  506,  510,
			  510,  510,    0,  507,  518,  512,  513,  513,  513,  514,
			  519,  514,  521,  517,  514,  514,  514,  506,  515,  508,
			  515,  515,  515,  522,  523,  507,  526,  508,  528,  511,

			  506,  529,  531,  532,  515,  507,  518,  512,  533,  534,
			  535,  537,  519,  540,  521,  541,  543,  544,  546,  506,
			  550,  508,  551,  553,    0,  522,  523,  507,  526,  508,
			  528,    0,    0,  529,  531,  532,  515,  558,  558,  558,
			  533,  534,  535,  537,  567,  540,    0,  541,  543,  544,
			  546,    0,  550,  555,  551,  553,  555,  556,  557,    0,
			  556,  557,  559,  559,  559,  560,  560,  560,  561,    0,
			  561,    0,  568,  561,  561,  561,  567,  570,  562,  560,
			  562,  555,  572,  562,  562,  562,  557,  563,  563,  563,
			  564,  564,  564,  565,  565,  565,  573,  574,  577,  556,

			  580,  563,  581,  555,  568,  583,  584,  556,  557,  570,
			  566,  560,  566,  555,  572,  566,  566,  566,  557,  582,
			  582,  582,  585,  587,  588,  594,    0,    0,  573,  574,
			  577,  556,  580,  563,  581,  555,    0,  583,  584,  556,
			  557,  591,  592,  593,  591,  592,  593,  603,    0,  582,
			  619,  594,    0,  619,  585,  587,  588,  594,  595,  595,
			  595,  596,  596,  596,  597,  597,  597,  598,  598,  598,
			  599,  599,  599,  601,  601,  601,  610,  613,  591,  603,
			  600,  582,  600,  614,  599,  600,  600,  600,  602,  602,
			  602,  591,  592,  593,    0,  616,  612,  612,  612,  627,

			  619,  628,  622,  623,  623,  623,  632,  633,  610,  613,
			  591,  624,  624,  624,  634,  614,  599,  635,  636,  656,
			  656,  656,    0,  591,  592,  593,  612,  616,  622,    0,
			    0,  627,  619,  628,  622,    0,    0,    0,  632,  633,
			    0,    0,    0,    0,    0,    0,  634,    0,    0,  635,
			  636,    0,    0,    0,    0,    0,    0,    0,  612,  640,
			  640,  640,  640,  640,  640,  640,  640,  640,  640,  640,
			  640,  640,  640,  640,  641,  641,  641,  641,  641,  641,
			  641,  641,  641,  641,  641,  641,  641,  641,  641,  642,
			  642,  642,  642,  642,  642,  642,  642,  642,  642,  642,

			  642,  642,  642,  642,  643,  643,  643,  643,  643,  643,
			  643,  643,  643,  643,  643,  643,  643,  643,  643,  644,
			  644,  644,  644,  644,  644,  644,  644,  644,  644,  644,
			  644,  644,  644,  644,  645,    0,  645,  645,  645,  645,
			  645,  645,  645,  645,  645,  645,  645,  645,  645,  646,
			    0,  646,    0,  646,  646,  646,  646,  646,  646,  646,
			  646,  646,  647,    0,  647,  647,  647,  647,  647,  647,
			  647,  647,  647,  647,  647,  647,  647,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  649,    0,  649,  649,
			  649,    0,  649,  649,  649,  649,  649,  649,  649,  649,

			  649,  650,  650,  650,  650,  650,  650,  650,  650,  650,
			  650,  650,  650,  650,  650,  650,  651,  651,  651,  651,
			  651,  651,  651,  651,  651,  651,  651,  651,  651,  651,
			  651,  652,  652,  652,  652,  652,  652,  652,  652,  652,
			  652,  652,  652,  652,  652,  652,  653,    0,  653,  653,
			  653,  653,  653,  653,  653,  653,  653,  653,  653,  653,
			  653,  654,    0,  654,    0,  654,  654,  654,  654,  654,
			  654,  654,  654,  654,  654,  654,  655,    0,  655,  655,
			  655,  655,  655,  655,  655,  655,  655,  655,  655,  655,
			  655,  657,    0,  657,  657,  657,  657,  657,  657,  657,

			  657,  657,  657,  657,  657,  657,  658,  658,  658,  658,
			  658,  658,  658,  658,  658,  658,  658,  658,  658,  658,
			  658,  659,    0,  659,  659,  659,  659,  659,  659,  659,
			  659,  659,  659,  659,  659,  659,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,

			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   89,   90,   98,  103,  578,  574,  108,
			  111,  114,  117,  563, 1836,  120,  123, 1836,  188,    0,
			 1836,  119, 1836, 1836, 1836, 1836, 1836,  112,  123,  116,
			  129,  146,  151,  534, 1836,  107, 1836,  126,  518,  180,
			  100,  183,  114,  193,  237,    0,  237,  181,  102,  110,
			  250,  129,  121,  188,  245,  195,  244,  173,  239, 1836,
			  484, 1836, 1836, 1836,  446, 1836,  519, 1836, 1836,  328,
			   91,  340, 1836, 1836,  159,  520, 1836, 1836,  181, 1836,
			 1836,  197,  298,  498,  305,  487,  280, 1836,  348,  231,
			  329,  339,  358,  364,  375,  381,  382,  387,  388,  393,

			  397,  409,  399,  383,  480,    0,  463,  563,  457, 1836,
			 1836, 1836,  413, 1836, 1836,  472,  480,  487, 1836,    0,
			  402, 1836, 1836, 1836, 1836, 1836, 1836,    0,  260,  378,
			  263,  362,  377,  379,  411,  429,  435,  446,  441,  464,
			    0,  448,  470,  468,  473,  486,  475,    0,  476,  522,
			    0,  482,  539,  491,  477,  481,  497,  560,    0,  485,
			  499,  583,  576,  487,  518,  517,  562,  587,  574,  572,
			  584,  589,  580, 1836, 1836,  460, 1836,  576, 1836, 1836,
			 1836, 1836, 1836,  621, 1836, 1836, 1836, 1836, 1836, 1836,
			 1836, 1836, 1836, 1836, 1836, 1836, 1836, 1836, 1836, 1836,

			  315, 1836, 1836,  663,  536, 1836,  451, 1836,  642, 1836,
			  668,  443, 1836, 1836,  672,  680, 1836, 1836, 1836, 1836,
			  629, 1836,  671, 1836,  681,  682,  686,  690,  694,  688,
			  702, 1836,  701,  710, 1836, 1836, 1836,  410,  398,  389,
			  375,  371,  692,  369,  361,  355,  351,  345,  340,  322,
			  299,  294,  287,  279,  238,  229,  228,  224,  201, 1836,
			  759,  703, 1836,  763,  734,  712,  774,  144,  781,  766,
			  585,  600,    0,    0,  609,  662,    0,  697,  697,  756,
			  743,  753,  754,  772,  774,    0,  760,  783,  777,  764,
			  765,  773,  775,  783,  780,  785,  775,  791,  788,  794,

			  785,  793,  799,  791,    0,  803,  801,  808,  826,  830,
			  832,  838,  820,  841,  824,  838,  844,  837,  833,  843,
			  837,  845,  834,  843,    0,  844,  850,  841,    0, 1836,
			  898,    0,  123,  922, 1836, 1836, 1836,  888,  921,  879,
			  923, 1836,  925, 1836, 1836, 1836, 1836, 1836, 1836, 1836,
			  917, 1836, 1836, 1836, 1836, 1836, 1836, 1836, 1836, 1836,
			 1836, 1836, 1836, 1836, 1836, 1836, 1836,  920,  925,  928,
			  931,  949,  938,  952,  970,  978,  121,  161,  984,  994,
			  852,  895,  919,  923,  923,  937,  965,  973,  959,  984,
			  983,  973,  983,  976,  981,  978,  979,  993,  978,    0,

			  995,  993,  979,  981,  989, 1003,  994,    0, 1001,    0,
			 1008,    0, 1004, 1076,    0, 1011, 1012, 1027, 1032, 1023,
			 1029, 1034, 1026, 1042, 1030, 1053, 1039, 1042,    0,    0,
			 1054, 1054, 1040, 1050, 1062,    0,    0, 1836, 1090,  105,
			 1089, 1836, 1119, 1836, 1120, 1836,  163, 1112,  962, 1119,
			 1026, 1085, 1129, 1134,    0,    0, 1084, 1099,    0,    0,
			 1092, 1089, 1126, 1094,    0, 1095, 1113, 1124, 1132, 1117,
			 1128,    0, 1125, 1130, 1147, 1144,    0, 1145, 1152, 1148,
			    0, 1133, 1154, 1219, 1836,  146, 1169, 1153, 1148, 1164,
			 1172, 1175, 1163, 1177, 1163,    0, 1168, 1194,    0,    0,

			 1188, 1193,    0, 1185,  138,   61, 1231, 1239, 1241, 1836,
			 1249, 1233, 1241, 1256, 1264, 1270,    0, 1201, 1240, 1231,
			    0, 1238, 1244, 1260,    0,    0, 1262,    0, 1268, 1267,
			    0, 1254, 1260, 1259, 1260, 1280,    0, 1262, 1836,  105,
			 1272, 1267,    0, 1273, 1274,    0, 1284,    0,    0,    0,
			 1271, 1279,    0, 1274,   37, 1347, 1351, 1352, 1317, 1342,
			 1345, 1353, 1363, 1367, 1370, 1373, 1395, 1295, 1339,    0,
			 1334,    0, 1349, 1363, 1356,    0,    0, 1362,    0,    0,
			 1357, 1368, 1417, 1361, 1372, 1390,    0, 1389, 1390,    0,
			    0, 1435, 1436, 1437, 1391, 1438, 1441, 1444, 1447, 1450,

			 1465, 1453, 1468, 1413,    0,    0,    0,    0,    0,    0,
			 1427,    0, 1494, 1436, 1436,    0, 1461,    0,    0, 1444,
			 1836, 1836, 1468, 1483, 1491,    0,    0, 1458, 1471,    0,
			    0, 1836, 1476, 1459, 1466, 1469, 1470,    0, 1836, 1836,
			 1558, 1573, 1588, 1603, 1618, 1633, 1646, 1661, 1670, 1685,
			 1700, 1715, 1730, 1745, 1760, 1775, 1512, 1790, 1805, 1820, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  639,    1,  640,  640,  641,  641,  642,  642,  643,
			  643,  644,  644,  639,  639,  639,  639,  639,  645,  646,
			  639,  647,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  639,
			  639,  639,  639,  639,  639,  639,  649,  639,  639,  639,
			  650,  650,  639,  639,  651,  652,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  645,  639,  653,  654,
			  645,  645,  645,  645,  645,  645,  645,  645,  645,  645,

			  645,  645,  645,  645,  645,  646,  655,  655,  655,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  656,
			  639,  639,  639,  639,  639,  639,  639,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  639,  639,  649,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,

			  650,  639,  639,  650,  651,  639,  652,  639,  639,  639,
			  639,  657,  639,  639,  653,  654,  639,  639,  639,  639,
			  645,  639,  645,  639,  645,  645,  645,  645,  645,  645,
			  645,  639,  645,  645,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  656,  639,  639,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,

			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  639,
			  639,  657,  657,  654,  639,  639,  639,  645,  645,  645,
			  645,  639,  645,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  656,  639,  639,  639,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,

			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  639,  639,  657,
			  645,  639,  645,  639,  645,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  639,  639,  639,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,

			  648,  648,  648,  648,  639,  657,  645,  645,  645,  639,
			  639,  639,  639,  639,  639,  639,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  639,  658,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  657,  645,  645,  645,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  659,  645,  645,  645,  639,  639,  639,  639,  639,  639,

			  639,  639,  639,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  639,  648,  648,  648,  648,  648,  648,  645,
			  639,  639,  639,  639,  639,  648,  648,  639,  648,  648,
			  648,  639,  639,  648,  639,  648,  639,  648,  639,    0,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  639,  639, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    5,    6,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   22,   22,   22,   22,   22,   22,   22,   23,   24,
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,
			   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,
			   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,

			   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
			   75,   76,   77,   78,   79,   80,   81,   82,   83,   84,
			   85,   86,   87,   88,   89,   90,   91,    1,    1,    1,
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
			    0,    1,    1,    2,    1,    3,    4,    3,    5,    6,
			    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
			    7,    8,    9,    3,    3,    3,    3,    3,    3,    3,
			    7,    7,    7,    7,    7,    7,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   11,   12,    3,    3,    3,    3,
			   13,    3,    7,    7,    7,    7,    7,    7,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   14,   15,    3,    3,
			    3,    3, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    2,    3,    4,    5,
			    5,    5,    5,    5,    6,    8,   11,   13,   16,   19,
			   22,   25,   28,   31,   34,   37,   40,   43,   46,   49,
			   52,   55,   58,   61,   64,   67,   70,   73,   76,   79,
			   82,   85,   88,   91,   94,   97,  100,  103,  106,  109,
			  112,  115,  118,  121,  124,  127,  130,  133,  136,  139,
			  142,  144,  147,  150,  153,  156,  159,  161,  163,  165,
			  167,  169,  171,  173,  175,  177,  179,  181,  183,  185,
			  187,  189,  192,  194,  196,  197,  197,  198,  199,  200,
			  200,  201,  202,  203,  204,  205,  206,  207,  208,  209,

			  210,  211,  213,  214,  215,  217,  218,  219,  220,  221,
			  222,  223,  224,  225,  226,  227,  228,  229,  230,  231,
			  231,  231,  232,  233,  234,  235,  236,  237,  238,  239,
			  240,  241,  243,  244,  245,  246,  247,  248,  249,  250,
			  251,  253,  254,  255,  256,  257,  258,  259,  261,  262,
			  263,  265,  266,  267,  268,  269,  270,  271,  272,  274,
			  275,  276,  277,  278,  279,  280,  281,  282,  283,  284,
			  285,  286,  287,  288,  289,  290,  291,  292,  292,  293,
			  294,  295,  296,  297,  297,  298,  299,  300,  301,  302,
			  303,  304,  305,  306,  307,  308,  309,  310,  311,  312,

			  313,  314,  315,  316,  317,  318,  320,  321,  322,  322,
			  323,  324,  325,  326,  328,  330,  331,  333,  335,  337,
			  339,  340,  342,  343,  345,  346,  347,  348,  349,  350,
			  351,  352,  353,  354,  355,  357,  358,  360,  361,  362,
			  363,  364,  365,  366,  367,  368,  369,  370,  371,  372,
			  373,  374,  375,  376,  377,  378,  379,  380,  381,  382,
			  384,  385,  385,  386,  387,  387,  388,  389,  390,  391,
			  391,  392,  393,  395,  397,  398,  399,  401,  402,  403,
			  404,  405,  406,  407,  408,  409,  411,  412,  413,  414,
			  415,  416,  417,  418,  419,  420,  421,  422,  423,  424,

			  425,  426,  427,  429,  430,  432,  433,  434,  435,  436,
			  437,  438,  439,  440,  441,  442,  443,  444,  445,  446,
			  447,  448,  449,  450,  451,  453,  454,  455,  456,  458,
			  459,  459,  460,  461,  461,  463,  465,  467,  468,  469,
			  470,  471,  473,  474,  476,  478,  479,  480,  481,  482,
			  483,  484,  485,  486,  487,  488,  489,  490,  491,  492,
			  493,  494,  495,  496,  497,  498,  499,  500,  501,  501,
			  502,  503,  503,  503,  504,  505,  506,  506,  506,  507,
			  508,  509,  510,  511,  512,  513,  514,  515,  516,  517,
			  518,  519,  520,  522,  523,  524,  525,  526,  527,  528,

			  530,  531,  532,  533,  534,  535,  536,  537,  539,  540,
			  542,  543,  545,  546,  548,  550,  551,  552,  553,  554,
			  555,  556,  557,  558,  559,  560,  561,  562,  563,  565,
			  567,  568,  569,  570,  571,  572,  574,  576,  577,  577,
			  578,  579,  581,  582,  584,  585,  587,  588,  589,  589,
			  590,  590,  591,  592,  593,  595,  597,  598,  599,  601,
			  603,  604,  605,  606,  607,  609,  610,  611,  612,  613,
			  614,  615,  617,  618,  619,  620,  621,  623,  624,  625,
			  626,  628,  629,  630,  630,  631,  631,  632,  633,  634,
			  635,  636,  637,  638,  639,  640,  642,  643,  644,  646,

			  648,  649,  650,  652,  653,  653,  654,  655,  656,  657,
			  658,  658,  659,  660,  660,  660,  661,  663,  664,  665,
			  666,  668,  669,  670,  671,  673,  675,  676,  678,  679,
			  680,  682,  683,  684,  685,  686,  687,  689,  690,  691,
			  691,  692,  693,  695,  696,  697,  699,  700,  702,  704,
			  706,  707,  708,  710,  711,  712,  713,  714,  715,  715,
			  716,  717,  717,  717,  718,  718,  719,  719,  720,  721,
			  723,  724,  726,  727,  728,  729,  731,  733,  734,  736,
			  738,  739,  740,  741,  742,  743,  744,  746,  747,  748,
			  750,  752,  753,  754,  755,  756,  756,  757,  757,  758,

			  759,  759,  759,  760,  761,  763,  765,  767,  769,  771,
			  773,  774,  776,  776,  777,  778,  780,  781,  783,  785,
			  786,  788,  790,  791,  791,  792,  794,  796,  796,  797,
			  799,  801,  803,  803,  804,  804,  805,  805,  807,  808,
			  808, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  176,  176,  178,  178,  209,  207,  208,    1,  207,
			  208,    1,  208,   36,  207,  208,  179,  207,  208,   41,
			  207,  208,   15,  207,  208,  146,  207,  208,   24,  207,
			  208,   25,  207,  208,   32,  207,  208,   30,  207,  208,
			    9,  207,  208,   31,  207,  208,   14,  207,  208,   33,
			  207,  208,  118,  207,  208,  118,  207,  208,  118,  207,
			  208,    8,  207,  208,    7,  207,  208,   19,  207,  208,
			   18,  207,  208,   20,  207,  208,   11,  207,  208,  116,
			  207,  208,  116,  207,  208,  116,  207,  208,  116,  207,
			  208,  116,  207,  208,  116,  207,  208,  116,  207,  208,

			  116,  207,  208,  116,  207,  208,  116,  207,  208,  116,
			  207,  208,  116,  207,  208,  116,  207,  208,  116,  207,
			  208,  116,  207,  208,  116,  207,  208,  116,  207,  208,
			  116,  207,  208,  116,  207,  208,  116,  207,  208,   28,
			  207,  208,  207,  208,   29,  207,  208,   34,  207,  208,
			   26,  207,  208,   27,  207,  208,   12,  207,  208,  180,
			  208,  206,  208,  204,  208,  205,  208,  176,  208,  176,
			  208,  175,  208,  174,  208,  176,  208,  178,  208,  177,
			  208,  172,  208,  172,  208,  171,  208,    6,  208,    5,
			    6,  208,    5,  208,    6,  208,    1,  179,  168,  179,

			  179,  179,  179,  179,  179,  179,  179,  179,  179,  179,
			  179,  179, -378,  179,  179,  179, -378,   41,  146,  146,
			  146,    2,   35,   10,  121,   39,   23,  121,  118,  118,
			  117,   16,   37,   21,   22,   38,   17,  116,  116,  116,
			  116,   46,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,   59,  116,  116,  116,  116,  116,  116,  116,   71,
			  116,  116,  116,   78,  116,  116,  116,  116,  116,  116,
			  116,  116,   91,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,   40,   13,
			  180,  204,  197,  195,  196,  198,  199,  200,  201,  181,

			  182,  183,  184,  185,  186,  187,  188,  189,  190,  191,
			  192,  193,  194,  176,  175,  174,  176,  176,  173,  174,
			  178,  177,  171,    5,    4,  169,  167,  169,  179, -378,
			 -378,  154,  169,  152,  169,  153,  169,  155,  169,  179,
			  148,  169,  179,  149,  169,  179,  179,  179,  179,  179,
			  179,  179, -170,  179,  179,  156,  169,  146,  122,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  123,  146,  121,  119,  121,  118,  118,  120,
			  118,  116,  116,   44,  116,   45,  116,  116,  116,   49,

			  116,  116,  116,  116,  116,  116,  116,  116,  116,   62,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,   83,  116,  116,
			   86,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  111,  116,  116,  116,  116,  115,  116,  203,    4,
			    4,  157,  169,  150,  169,  151,  169,  179,  179,  179,
			  179,  164,  169,  179,  159,  169,  158,  169,  140,  138,
			  139,  141,  142,  147,  143,  144,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,  135,  136,  137,

			  121,  121,  121,  121,  118,  118,  118,  118,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			   60,  116,  116,  116,  116,  116,  116,  116,   69,  116,
			  116,  116,  116,  116,  116,  116,  116,   79,  116,  116,
			   81,  116,  116,   84,  116,  116,   89,  116,   90,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  105,  116,  106,  116,  116,  116,  116,
			  116,  116,  113,  116,  114,  116,  202,    4,  179,  160,
			  169,  179,  163,  169,  179,  166,  169,  147,  121,  121,
			  121,  121,  118,   42,  116,   43,  116,  116,  116,   50,

			  116,   51,  116,  116,  116,  116,  116,   57,  116,  116,
			  116,  116,  116,  116,  116,   67,  116,  116,  116,  116,
			  116,   74,  116,  116,  116,  116,   80,  116,  116,  116,
			   87,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  101,  116,  116,  116,  104,  116,  107,  116,  116,  116,
			  110,  116,  116,    4,  179,  179,  179,  145,  121,  121,
			  121,   47,  116,  116,  116,  116,   54,  116,  116,  116,
			  116,   61,  116,   63,  116,  116,   65,  116,  116,  116,
			   70,  116,  116,  116,  116,  116,  116,   82,  116,  116,
			   88,  116,  116,   94,  116,  116,  116,   97,  116,  116,

			   99,  116,  100,  116,  102,  116,  116,  116,  109,  116,
			  116,    4,  179,  179,  179,  121,  121,  121,  121,  116,
			  116,   52,  116,  116,   56,  116,  116,  116,  116,   68,
			  116,   72,  116,  116,   75,  116,   76,  116,  116,  116,
			  116,  116,  116,  116,   98,  116,  116,  116,  112,  116,
			    3,    4,  179,  179,  179,  121,  121,  121,  121,  121,
			  116,   53,  116,   55,  116,   58,  116,   64,  116,   66,
			  116,   73,  116,  116,   85,  116,  116,  116,   95,  116,
			  116,  103,  116,  108,  116,  179,  162,  169,  165,  169,
			  121,  121,   48,  116,   77,  116,  116,   93,  116,   96,

			  116,  161,  169,  116,  116,   92,  116,   92, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 1836
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 639
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 640
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

	yyNb_rules: INTEGER is 208
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 209
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is true
			-- Is `position' used?

	INITIAL: INTEGER is 0
	SPECIAL_STR: INTEGER is 1
	VERBATIM_STR1: INTEGER is 2
	VERBATIM_STR2: INTEGER is 3
	VERBATIM_STR3: INTEGER is 4
	PRAGMA: INTEGER is 5
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

end -- class EIFFEL_SCANNER