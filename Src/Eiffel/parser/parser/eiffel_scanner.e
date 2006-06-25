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
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 285 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 285")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CREATE, Current)
				last_token := TE_CREATE
			
when 54 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 289 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 289")
end
				
				last_keyword_as_value := ast_factory.new_creation_keyword_as (Current)
				last_token := TE_CREATION				
			
when 55 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 293 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 293")
end
				
				last_current_as_value := ast_factory.new_current_as (Current)
				last_token := TE_CURRENT
			
when 56 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 297 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 297")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DEBUG, Current)
				last_token := TE_DEBUG
			
when 57 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 301 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 301")
end
				
				last_deferred_as_value := ast_factory.new_deferred_as (Current)
				last_token := TE_DEFERRED			
			
when 58 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 305 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 305")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DO, Current)
				last_token := TE_DO
			
when 59 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 309 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 309")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSE, Current)
				last_token := TE_ELSE
			
when 60 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 313 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 313")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSEIF, Current)
				last_token := TE_ELSEIF
			
when 61 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 317 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 317")
end
				
				last_keyword_as_value := ast_factory.new_end_keyword_as (Current)
				last_token := TE_END
			
when 62 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 321 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 321")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ENSURE, Current)
				last_token := TE_ENSURE
			
when 63 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 325 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 325")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPANDED, Current)
				last_token := TE_EXPANDED
			
when 64 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 329 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 329")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPORT, Current)
				last_token := TE_EXPORT
			
when 65 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 333 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 333")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXTERNAL, Current)
				last_token := TE_EXTERNAL
			
when 66 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 337 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 337")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (False, Current)
				last_token := TE_FALSE
			
when 67 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 341 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 341")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FEATURE, Current)
				last_token := TE_FEATURE
			
when 68 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 345 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 345")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FROM, Current)
				last_token := TE_FROM
			
when 69 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 349 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 349")
end
				
				last_keyword_as_value := ast_factory.new_frozen_keyword_as (Current)
				last_token := TE_FROZEN
			
when 70 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 353 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 353")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IF, Current)
				last_token := TE_IF
			
when 71 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 357 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 357")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IMPLIES, Current)
				last_token := TE_IMPLIES
			
when 72 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 361 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 361")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INDEXING, Current)
				last_token := TE_INDEXING
			
when 73 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 365 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 365")
end
				
				last_keyword_as_value := ast_factory.new_infix_keyword_as (Current)
				last_token := TE_INFIX
			
when 74 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 369 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 369")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INHERIT, Current)
				last_token := TE_INHERIT
			
when 75 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 373 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 373")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INSPECT, Current)
				last_token := TE_INSPECT
			
when 76 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 377 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 377")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INVARIANT, Current)
				last_token := TE_INVARIANT
			
when 77 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 381 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 381")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IS, Current)
				last_token := TE_IS
			
when 78 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 385 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 385")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LIKE, Current)
				last_token := TE_LIKE
			
when 79 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 389 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 389")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOCAL, Current)
				last_token := TE_LOCAL
			
when 80 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 393 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 393")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOOP, Current)
				last_token := TE_LOOP
			
when 81 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 397 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 397")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_NOT, Current)
				last_token := TE_NOT
			
when 82 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 401 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 401")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					Error_handler.insert_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `note', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 83 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 410 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 410")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OBSOLETE, Current)
				last_token := TE_OBSOLETE
			
when 84 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 414 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 414")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OLD, Current)
				last_token := TE_OLD
			
when 85 then
	yy_end := yy_end - 1
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 430 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 430")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text,  line, column, position, 4)
				last_token := TE_ONCE_STRING
			
when 86 then
	yy_end := yy_end - 1
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 434 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 434")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text_substring (1, 4),  line, column, position, 4)
					-- Assume all trailing characters are in the same line (which would be false if '\n' appears).
				ast_factory.create_break_as_with_data (text_substring (5, text_count), line, column + 4, position + 4, text_count - 4)
				last_token := TE_ONCE_STRING			
			
when 87 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 441 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 441")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ONCE, Current)
				last_token := TE_ONCE
			
when 88 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 445 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 445")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					Error_handler.insert_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `only', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 89 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 454 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 454")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OR, Current)
				last_token := TE_OR
			
when 90 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 458 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 458")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_PARTIAL_CLASS, Current)
				last_token := TE_PARTIAL_CLASS
			
when 91 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 462 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 462")
end
				
				last_keyword_as_value := ast_factory.new_precursor_keyword_as (Current)
				last_token := TE_PRECURSOR
			
when 92 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 466 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 466")
end
				
				last_keyword_as_value := ast_factory.new_prefix_keyword_as (Current)
				last_token := TE_PREFIX
			
when 93 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 470 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 470")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REDEFINE, Current)
				last_token := TE_REDEFINE
			
when 94 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 474 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 474")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REFERENCE, Current)
				last_token := TE_REFERENCE
			
when 95 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 478 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 478")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RENAME, Current)
				last_token := TE_RENAME
			
when 96 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 482 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 482")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REQUIRE, Current)
				last_token := TE_REQUIRE
			
when 97 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 486 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 486")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RESCUE, Current)
				last_token := TE_RESCUE
			
when 98 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 490 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 490")
end
					
				last_result_as_value := ast_factory.new_result_as (Current)
				last_token := TE_RESULT
			
when 99 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 494 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 494")
end
				
				last_retry_as_value := ast_factory.new_retry_as (Current)
				last_token := TE_RETRY
			
when 100 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 498 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 498")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SELECT, Current)
				last_token := TE_SELECT
			
when 101 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 502 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 502")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SEPARATE, Current)
				last_token := TE_SEPARATE
			
when 102 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 506 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 506")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_STRIP, Current)
				last_token := TE_STRIP
			
when 103 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 510 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 510")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_THEN, Current)
				last_token := TE_THEN
			
when 104 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 514 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 514")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (True, Current)
				last_token := TE_TRUE
			
when 105 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 518 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 518")
end

				last_token := TE_TUPLE
				process_id_as
			
when 106 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 522 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 522")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNDEFINE, Current)
				last_token := TE_UNDEFINE
			
when 107 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 526 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 526")
end
				
				last_unique_as_value := ast_factory.new_unique_as (Current)
				last_token := TE_UNIQUE
			
when 108 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 530 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 530")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNTIL, Current)
				last_token := TE_UNTIL
			
when 109 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 534 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 534")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_VARIANT, Current)
				last_token := TE_VARIANT
			
when 110 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 538 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 538")
end
				
				last_void_as_value := ast_factory.new_void_as (Current)
				last_token := TE_VOID
			
when 111 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 542 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 542")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_WHEN, Current)
				last_token := TE_WHEN
			
when 112 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 546 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 546")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_XOR, Current)
				last_token := TE_XOR
			
when 113 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 554 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 554")
end

				last_token := TE_ID
				process_id_as
			
when 114 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 561 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 561")
end

				last_token := TE_A_BIT			
				last_id_as_value := ast_factory.new_filled_bit_id_as (Current)
			
when 115 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 569 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 569")
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
			
when 116 then
	yy_end := yy_end - 2
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 570 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 570")
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
			
when 117 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 582 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 582")
end
		-- Recognizes hexadecimal integer numbers.
				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 118 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 590 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 590")
end

				token_buffer.clear_all
				append_text_to_string (token_buffer)
				if not Case_sensitive then
					token_buffer.to_lower
				end				
				last_token := TE_REAL
			
when 119 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 601 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 601")
end

				last_token := TE_BAD_ID
			
when 120 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 607 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 607")
end

				token_buffer.clear_all
				token_buffer.append_character (text_item (2))
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 121 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 613 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 613")
end

					-- This is not correct Eiffel!
				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 122 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 620 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 620")
end

				token_buffer.clear_all
				token_buffer.append_character ('%A')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 123 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 626 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 626")
end

				token_buffer.clear_all
				token_buffer.append_character ('%B')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 124 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 632 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 632")
end

				token_buffer.clear_all
				token_buffer.append_character ('%C')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 125 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 638 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 638")
end

				token_buffer.clear_all
				token_buffer.append_character ('%D')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 126 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 644 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 644")
end

				token_buffer.clear_all
				token_buffer.append_character ('%F')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 127 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 650 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 650")
end

				token_buffer.clear_all
				token_buffer.append_character ('%H')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 128 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 656 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 656")
end

				token_buffer.clear_all
				token_buffer.append_character ('%L')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 129 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 662 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 662")
end

				token_buffer.clear_all
				token_buffer.append_character ('%N')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 130 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 668 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 668")
end

				token_buffer.clear_all
				token_buffer.append_character ('%Q')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 131 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 674 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 674")
end

				token_buffer.clear_all
				token_buffer.append_character ('%R')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 132 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 680 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 680")
end

				token_buffer.clear_all
				token_buffer.append_character ('%S')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 133 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 686 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 686")
end

				token_buffer.clear_all
				token_buffer.append_character ('%T')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 134 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 692 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 692")
end

				token_buffer.clear_all
				token_buffer.append_character ('%U')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 135 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 698 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 698")
end

				token_buffer.clear_all
				token_buffer.append_character ('%V')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 136 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 704 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 704")
end

				token_buffer.clear_all
				token_buffer.append_character ('%%')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 137 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 710 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 710")
end

				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 138 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 716 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 716")
end

				token_buffer.clear_all
				token_buffer.append_character ('%"')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 139 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 722 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 722")
end

				token_buffer.clear_all
				token_buffer.append_character ('%(')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 140 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 728 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 728")
end

				token_buffer.clear_all
				token_buffer.append_character ('%)')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 141 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 734 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 734")
end

				token_buffer.clear_all
				token_buffer.append_character ('%<')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 142 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 740 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 740")
end

				token_buffer.clear_all
				token_buffer.append_character ('%>')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 143 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 746 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 746")
end

				process_character_code (text_substring (4, text_count - 2).to_integer)
			
when 144 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 749 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 749")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 145 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 750 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 750")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 146 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 759 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 759")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LT
			
when 147 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 763 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 763")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GT
			
when 148 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 767 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 767")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LE
			
when 149 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 771 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 771")
end
			
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GE
			
when 150 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 775 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 775")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_PLUS
			
when 151 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 779 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 779")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MINUS
			
when 152 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 783 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 783")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_STAR
			
when 153 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 787 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 787")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_SLASH
			
when 154 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 791 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 791")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_POWER
			
when 155 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 795 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 795")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_DIV
			
when 156 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 799 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 799")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MOD
			
when 157 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 803 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 803")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_BRACKET
			
when 158 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 807 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 807")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND
			
when 159 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 813 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 813")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 9, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND_THEN
			
when 160 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 819 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 819")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_IMPLIES
			
when 161 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 825 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 825")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_NOT
			
when 162 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 831 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 831")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 3, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR
			
when 163 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 837 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 837")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR_ELSE
			
when 164 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 843 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 843")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_XOR
			
when 165 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 849 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 849")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, text_count - 1, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_FREE
				if token_buffer.count > maximum_string_length then
					report_too_long_string (token_buffer)
				end
			
when 166 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 858 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 858")
end

					-- Empty string.
				ast_factory.set_buffer (token_buffer2, Current)
				string_position := position
				last_token := TE_EMPTY_STRING
			
when 167 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 864 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 864")
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
			
when 168 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 875 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 875")
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
			
when 169 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 893 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 893")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (VERBATIM_STR1)
			
when 170 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 897 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 897")
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
			
when 171 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 917 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 917")
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
			
when 172 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 960 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 960")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (VERBATIM_STR2)
			
when 173 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 965 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 965")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
			
when 174 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 973 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 973")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 175 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 989 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 989")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
				set_start_condition (VERBATIM_STR1)
			
when 176 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 998 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 998")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 177 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1011 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1011")
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
			
when 178 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1023 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1023")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
			
when 179 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1027 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1027")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%A")
				token_buffer.append_character ('%A')
			
when 180 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1031 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1031")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%B")
				token_buffer.append_character ('%B')
			
when 181 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1035 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1035")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%C")
				token_buffer.append_character ('%C')
			
when 182 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1039 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1039")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%D")
				token_buffer.append_character ('%D')
			
when 183 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1043 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1043")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%F")
				token_buffer.append_character ('%F')
			
when 184 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1047 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1047")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%H")
				token_buffer.append_character ('%H')
			
when 185 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1051 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1051")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%L")
				token_buffer.append_character ('%L')
			
when 186 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1055 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1055")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%N")
				token_buffer.append_character ('%N')
			
when 187 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1059 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1059")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%Q")
				token_buffer.append_character ('%Q')
			
when 188 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1063 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1063")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%R")
				token_buffer.append_character ('%R')
			
when 189 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1067 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1067")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%S")
				token_buffer.append_character ('%S')
			
when 190 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1071 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1071")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%T")
				token_buffer.append_character ('%T')
			
when 191 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1075 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1075")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%U")
				token_buffer.append_character ('%U')
			
when 192 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1079 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1079")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%V")
				token_buffer.append_character ('%V')
			
when 193 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1083 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1083")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%%")
				token_buffer.append_character ('%%')
			
when 194 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1087 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1087")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%'")
				token_buffer.append_character ('%'')
			
when 195 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1091 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1091")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%"")
				token_buffer.append_character ('%"')
			
when 196 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1095 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1095")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%(")
				token_buffer.append_character ('%(')
			
when 197 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1099 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1099")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%)")
				token_buffer.append_character ('%)')
			
when 198 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1103 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1103")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%<")
				token_buffer.append_character ('%<')
			
when 199 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 1107 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1107")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%>")
				token_buffer.append_character ('%>')
			
when 200 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1111 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1111")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				process_string_character_code (text_substring (3, text_count - 1).to_integer)
			
when 201 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1115 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1115")
end

					-- This regular expression should actually be: %\n[ \t\r]*%
					-- Left as-is for compatibility with previous releases.
			ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 202 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 1120 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1120")
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
			
when 203 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 1136 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1136")
end

					-- Bad special character.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (INITIAL)
				report_string_bad_special_character_error
			
when 204 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + 1
--|#line 1142 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1142")
end

					-- No final double-quote.
				set_start_condition (INITIAL)
				report_string_missing_quote_error (token_buffer)
			
when 205 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 1160 "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line 1160")
end

				report_unknown_token_error (text_item (1))
			
when 206 then
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
			   45,   47,   45,   48,   49,   50,   45,   51,   52,   53,
			   54,   55,   56,   57,   45,   45,   58,   59,   60,   61,
			   62,   14,   39,   40,   41,   42,   43,   44,   45,   45,
			   46,   45,   45,   47,   45,   48,   49,   50,   45,   51,
			   52,   53,   54,   55,   56,   57,   45,   45,   63,   19,
			   64,   65,   67,   67,  200,   68,   68,  201,   69,   69,

			   71,   72,   71,  580,   73,   71,   72,   71,  476,   73,
			   78,   79,   78,   78,   79,   78,   81,   82,   81,   81,
			   82,   81,   84,   84,   84,   84,   84,   84,  107,  109,
			  108,   83,  123,  124,   83,  113,  545,   85,  134,  110,
			   85,  111,  114,  112,  112,  112,  154,  115,  140,  116,
			  116,  117,  125,  126,  161,  167,   74,  432,  141,  159,
			  119,   74,  200,  530,  115,  204,  116,  116,  117,  115,
			  134,  117,  117,  117,  502,  498,  160,  119,  154,  261,
			  140,  373,  120,  207,  208,  207,  161,  167,   74,  121,
			  141,  159,  119,   74,   87,   88,  434,   89,   88,  209,

			  209,  209,   90,   91,  373,   92,  121,   93,  160,  119,
			  170,  121,  363,   94,  120,   95,  129,   88,   96,  152,
			  135,  130,  162,  131,  136,  153,   97,  137,  132,  133,
			  138,   98,   99,  139,  142,  362,  143,  163,  171,  361,
			  360,  100,  170,  214,  101,  102,  144,  103,  129,  359,
			   96,  152,  135,  130,  162,  131,  136,  153,   97,  137,
			  132,  133,  138,   98,   99,  139,  142,  145,  143,  163,
			  171,  146,  148,  100,  168,  214,  104,   88,  144,  149,
			  150,  155,  164,  269,  147,  151,  211,  272,  169,   89,
			  358,  156,  165,  157,  273,  166,  274,  158,  357,  145,

			  209,  209,  209,  146,  148,  356,  168,   84,   84,   84,
			  355,  149,  150,  155,  164,  269,  147,  151,  200,  272,
			  169,  201,   85,  156,  165,  157,  273,  166,  274,  158,
			  176,  176,  176,  354,  177,  215,  104,  178,   89,  179,
			  180,  181,  202,  200,  202,  216,  201,  182,   89,   86,
			   86,  353,   86,  183,  212,  184,  352,   89,  185,  186,
			  187,  188,  351,  189,  217,  190,  350,   89,  104,  191,
			  218,  192,  349,   89,  193,  194,  195,  196,  197,  198,
			  348,  220,  346,  219,   89,  104,  345,  222,  211,  233,
			   89,   89,   89,  211,  211,  104,   89,   89,  203,  211,

			  344,  221,   89,  211,  213,  211,   89,  223,   89,  343,
			  275,  229,  230,  229,  104,  211,  270,  104,   89,  271,
			  104,  200,  276,  342,  204,  224,  277,  104,  278,  225,
			  203,  104,  226,  259,  259,  259,  213,  104,  104,  104,
			  227,  228,  275,  104,  104,  279,  104,  260,  270,  104,
			  329,  271,  104,  104,  276,  104,  232,  224,  277,  280,
			  278,  225,  206,  104,  226,  104,  175,  231,  628,  104,
			  104,  104,  227,  228,  628,  104,  104,  279,  258,  260,
			  235,  104,  229,  230,  229,  104,  211,  104,  283,   89,
			  261,  280,  262,  262,  262,  281,  288,  104,  115,  282,

			  264,  264,  265,  284,  109,  115,  263,  265,  265,  265,
			  628,  119,  267,  267,  267,  210,  289,  286,  285,  290,
			  283,  287,  291,  206,  297,  175,  300,  281,  288,  301,
			  302,  282,  305,  298,  306,  284,  104,  173,  263,  628,
			  121,  172,  127,  119,  122,  299,  315,  121,  289,  286,
			  285,  290,  268,  287,  291,  292,  297,  293,  300,  294,
			  628,  301,  302,   76,  305,  298,  306,  313,  104,  236,
			  295,  314,  237,  296,  238,  239,  240,  299,  315,  176,
			  176,  176,  241,   76,  316,  628,  326,  292,  242,  293,
			  243,  294,  303,  244,  245,  246,  247,  628,  248,  313,

			  249,  304,  295,  314,  250,  296,  251,  317,  318,  252,
			  253,  254,  255,  256,  257,  628,  316,  266,  266,  266,
			  322,  319,  323,  324,  303,  325,  320,  266,  266,  266,
			  266,  266,  266,  304,  307,  377,  308,  321,  628,  317,
			  318,  327,  327,  327,  309,  331,  628,  310,   89,  311,
			  312,  628,  322,  319,  323,  324,  628,  325,  320,  266,
			  266,  266,  266,  266,  266,  628,  307,  377,  308,  321,
			  202,  200,  202,  628,  201,  332,  309,  628,   89,  310,
			  628,  311,  312,  207,  208,  207,  209,  209,  209,   86,
			  229,  230,  229,  333,  212,  104,   89,   89,  330,  230,

			  330,  211,  628,  211,   89,  211,   89,  337,   89,  338,
			  628,  340,   89,  211,   89,  378,   89,  229,  230,  229,
			  341,  211,  628,   89,   89,  104,  203,  104,  334,  347,
			  347,  347,  364,  364,  364,  367,  367,  367,  628,  628,
			  379,  380,  335,  104,  213,  381,  260,  378,  336,  368,
			  382,  104,  214,  104,  339,  104,  383,  104,  203,  104,
			  334,  104,  365,  104,  365,  628,  628,  366,  366,  366,
			  104,  104,  379,  380,  335,  104,  213,  381,  260,  628,
			  336,  368,  382,  104,  214,  104,  339,  104,  383,  628,
			  384,  104,  369,  104,  369,  104,  385,  370,  370,  370,

			  386,  387,  104,  104,  115,  388,  371,  371,  372,  115,
			  389,  372,  372,  372,  628,  390,  374,  119,  375,  375,
			  375,  628,  384,  376,  376,  376,  628,  392,  385,  391,
			  393,  628,  386,  387,  394,  395,  397,  388,  398,  399,
			  400,  401,  389,  402,  403,  404,  121,  390,  396,  119,
			  405,  121,  406,  407,  408,  409,  410,  411,  268,  392,
			  412,  391,  393,  268,  413,  414,  394,  395,  397,  415,
			  398,  399,  400,  401,  416,  402,  403,  404,  419,  420,
			  396,  417,  405,  421,  406,  407,  408,  409,  410,  411,
			  422,  423,  412,  424,  425,  426,  413,  414,  427,  418,

			  428,  415,  429,  430,  431,  628,  416,  330,  230,  330,
			  419,  420,  628,  417,  449,  421,  432,  433,  433,  433,
			  628,  211,  422,  423,   89,  424,  425,  426,  628,  628,
			  427,  418,  428,  628,  429,  430,  431,  435,  628,  436,
			  438,  211,   89,   89,   89,  440,  449,  628,   89,  441,
			  347,  347,  347,  366,  366,  366,  437,  628,  442,  442,
			  442,  214,  366,  366,  366,  444,  444,  444,  445,  439,
			  445,  104,  260,  446,  446,  446,  370,  370,  370,  368,
			  370,  370,  370,  447,  450,  371,  371,  372,  437,  104,
			  104,  104,  451,  214,  452,  104,  119,  453,  443,  454,

			  455,  439,  456,  104,  260,  447,  457,  372,  372,  372,
			  374,  368,  448,  448,  448,  374,  450,  376,  376,  376,
			  628,  104,  104,  104,  451,  268,  452,  104,  119,  453,
			  458,  454,  455,  459,  456,  460,  461,  462,  457,  463,
			  464,  465,  466,  467,  468,  469,  470,  268,  471,  472,
			  473,  474,  268,  475,  504,  504,  504,  268,  628,  479,
			  480,  481,  458,  482,  483,  459,  484,  460,  461,  462,
			  485,  463,  464,  465,  466,  467,  468,  469,  470,  486,
			  471,  472,  473,  474,  487,  475,  476,  476,  476,  488,
			  477,  479,  480,  481,  489,  482,  483,  490,  484,  491,

			  492,  478,  485,  493,  494,  495,  496,  432,  497,  497,
			  497,  486,  211,  509,  211,   89,  487,   89,  510,  211,
			  511,  488,   89,  446,  446,  446,  489,  628,  628,  490,
			  628,  491,  492,  514,  515,  493,  494,  495,  496,  442,
			  442,  442,  505,  505,  505,  509,  500,  446,  446,  446,
			  510,  516,  511,  503,  501,  499,  368,  261,  517,  505,
			  505,  505,  104,  512,  104,  514,  515,  513,  508,  104,
			  376,  376,  376,  507,  518,  519,  520,  521,  500,  522,
			  523,  524,  506,  516,  525,  503,  501,  499,  368,  526,
			  517,  527,  528,  531,  104,  512,  104,  532,  533,  513,

			  534,  104,  535,  536,  537,  507,  518,  519,  520,  521,
			  121,  522,  523,  524,  538,  539,  525,  540,  476,  476,
			  476,  526,  529,  527,  528,  531,  541,  542,  543,  532,
			  533,  544,  534,  478,  535,  536,  537,  211,  211,  211,
			   89,   89,   89,  554,  554,  554,  538,  539,  549,  540,
			  549,  628,  558,  550,  550,  550,  628,  628,  541,  542,
			  543,  559,  560,  544,  628,  628,  547,  561,  546,  551,
			  551,  551,  505,  505,  505,  261,  562,  554,  554,  554,
			  563,  548,  564,  552,  558,  565,  553,  104,  104,  104,
			  555,  557,  555,  559,  560,  556,  556,  556,  547,  561,

			  546,  566,  567,  568,  569,  570,  571,  572,  562,  573,
			  574,  575,  563,  548,  564,  552,  576,  565,  553,  104,
			  104,  104,  577,  557,  578,  579,  211,  211,  628,   89,
			   89,  628,  628,  566,  567,  568,  569,  570,  571,  572,
			  628,  573,  574,  575,  211,  628,  628,   89,  576,  550,
			  550,  550,  628,  628,  577,  581,  578,  579,  550,  550,
			  550,  584,  584,  584,  585,  628,  585,  593,  582,  586,
			  586,  586,  583,  594,  595,  552,  104,  104,  587,  596,
			  587,  597,  598,  588,  588,  588,  599,  581,  589,  589,
			  589,  556,  556,  556,  104,  556,  556,  556,  600,  593,

			  582,  603,  590,  604,  583,  594,  595,  552,  104,  104,
			  591,  596,  591,  597,  598,  592,  592,  592,  599,  601,
			  601,  601,  605,  606,  607,  211,  104,  552,   89,  609,
			  600,  628,   89,  603,  590,  604,  610,  614,  615,   89,
			  586,  586,  586,  586,  586,  586,  588,  588,  588,  602,
			  588,  588,  588,  443,  605,  606,  607,  628,  628,  552,
			  628,  617,  608,  611,  611,  611,  612,  618,  612,  614,
			  615,  613,  613,  613,  619,  104,  590,  590,  621,  104,
			  628,  602,  592,  592,  592,  622,  104,  592,  592,  592,
			  601,  601,  601,  617,  608,  620,  623,  624,   89,  618,

			  625,  626,  506,  613,  613,  613,  619,  104,  590,  590,
			  621,  104,  613,  613,  613,  627,  628,  622,  104,  628,
			  616,  628,  628,  628,  628,  628,  628,  628,  623,  624,
			  628,  628,  625,  626,  118,  118,  118,  118,  118,  118,
			  118,  118,  118,  628,  628,  104,  628,  627,  628,  105,
			  628,  105,  616,  105,  105,  105,  105,  105,  105,  105,
			  105,  105,  128,  128,  128,  128,  128,  128,  128,  128,
			  628,  628,  628,  628,  628,  628,  628,  104,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   70,   70,   70,   70,   70,   70,   70,

			   70,   70,   70,   70,   70,   70,   70,   70,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   77,   77,   77,   77,   77,   77,   77,
			   77,   77,   77,   77,   77,   77,   77,   77,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   86,  628,   86,   86,   86,   86,   86,
			   86,   86,   86,   86,   86,   86,   86,   86,  106,  628,
			  106,  106,  106,  106,  106,  106,  106,  106,  106,  106,
			  106,  106,  106,  174,  628,  174,  174,  174,  628,  174,
			  174,  174,  174,  174,  174,  174,  174,  174,  199,  199,

			  199,  199,  199,  199,  199,  199,  199,  199,  199,  199,
			  199,  199,  199,  203,  203,  203,  203,  203,  203,  203,
			  203,  203,  203,  203,  203,  203,  203,  203,  205,  205,
			  205,  205,  205,  205,  205,  205,  205,  205,  205,  205,
			  205,  205,  205,   88,  628,   88,   88,   88,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   89,  628,
			   89,  628,   89,   89,   89,   89,   89,   89,   89,   89,
			   89,   89,   89,  234,  628,  234,  234,  234,  234,  234,
			  234,  234,  234,  234,  234,  234,  234,  234,  328,  628,
			  328,  328,  328,  328,  328,  328,  328,  328,  328,  328,

			  328,  328,  328,  530,  530,  530,  530,  530,  530,  530,
			  530,  530,  530,  530,  530,  530,  530,  530,  580,  628,
			  580,  580,  580,  580,  580,  580,  580,  580,  580,  580,
			  580,  580,  580,   13,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,

			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628, yy_Dummy>>)
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

			    5,    5,    5,  545,    5,    6,    6,    6,  530,    6,
			    9,    9,    9,   10,   10,   10,   11,   11,   11,   12,
			   12,   12,   15,   15,   15,   16,   16,   16,   21,   27,
			   21,   11,   35,   35,   12,   29,  498,   15,   40,   27,
			   16,   28,   29,   28,   28,   28,   48,   30,   42,   30,
			   30,   30,   37,   37,   51,   54,    5,  497,   42,   50,
			   30,    6,   74,  478,   31,   74,   31,   31,   31,   32,
			   40,   32,   32,   32,  441,  434,   50,   31,   48,  374,
			   42,  373,   30,   78,   78,   78,   51,   54,    5,   30,
			   42,   50,   30,    6,   18,   18,  329,   18,   18,   81,

			   81,   81,   18,   18,  266,   18,   31,   18,   50,   31,
			   56,   32,  257,   18,   30,   18,   39,   18,   18,   47,
			   41,   39,   52,   39,   41,   47,   18,   41,   39,   39,
			   41,   18,   18,   41,   43,  256,   43,   52,   57,  255,
			  254,   18,   56,   89,   18,   18,   43,   18,   39,  253,
			   18,   47,   41,   39,   52,   39,   41,   47,   18,   41,
			   39,   39,   41,   18,   18,   41,   43,   44,   43,   52,
			   57,   44,   46,   18,   55,   89,   18,   18,   43,   46,
			   46,   49,   53,  129,   44,   46,   86,  131,   55,   86,
			  252,   49,   53,   49,  132,   53,  133,   49,  251,   44,

			   82,   82,   82,   44,   46,  250,   55,   84,   84,   84,
			  249,   46,   46,   49,   53,  129,   44,   46,  199,  131,
			   55,  199,   84,   49,   53,   49,  132,   53,  133,   49,
			   69,   69,   69,  248,   69,   90,   86,   69,   90,   69,
			   69,   69,   71,   71,   71,   91,   71,   69,   91,   88,
			   88,  247,   88,   69,   88,   69,  246,   88,   69,   69,
			   69,   69,  245,   69,   92,   69,  244,   92,   86,   69,
			   93,   69,  243,   93,   69,   69,   69,   69,   69,   69,
			  242,   94,  240,   93,   94,   90,  239,   95,   96,  103,
			   95,   96,  103,   97,   98,   91,   97,   98,   71,   99,

			  238,   94,   99,  100,   88,  102,  100,   95,  102,  237,
			  134,  101,  101,  101,   92,  101,  130,   90,  101,  130,
			   93,  203,  135,  236,  203,   96,  136,   91,  137,   97,
			   71,   94,   98,  112,  112,  112,   88,   95,   96,  103,
			   99,  100,  134,   97,   98,  138,   92,  112,  130,   99,
			  210,  130,   93,  100,  135,  102,  102,   96,  136,  139,
			  137,   97,  205,   94,   98,  101,  174,  101,  119,   95,
			   96,  103,   99,  100,  118,   97,   98,  138,  108,  112,
			  106,   99,  104,  104,  104,  100,  104,  102,  142,  104,
			  115,  139,  115,  115,  115,  140,  145,  101,  116,  140,

			  116,  116,  116,  143,   85,  117,  115,  117,  117,  117,
			  121,  116,  121,  121,  121,   83,  146,  144,  143,  147,
			  142,  144,  149,   75,  152,   66,  154,  140,  145,  155,
			  156,  140,  159,  153,  160,  143,  104,   64,  115,   62,
			  116,   59,   38,  116,   33,  153,  163,  117,  146,  144,
			  143,  147,  121,  144,  149,  150,  152,  150,  154,  150,
			   13,  155,  156,    8,  159,  153,  160,  162,  104,  107,
			  150,  162,  107,  150,  107,  107,  107,  153,  163,  176,
			  176,  176,  107,    7,  164,    0,  176,  150,  107,  150,
			  107,  150,  157,  107,  107,  107,  107,    0,  107,  162,

			  107,  157,  150,  162,  107,  150,  107,  165,  166,  107,
			  107,  107,  107,  107,  107,  120,  164,  120,  120,  120,
			  168,  167,  169,  170,  157,  171,  167,  120,  120,  120,
			  120,  120,  120,  157,  161,  269,  161,  167,    0,  165,
			  166,  182,  182,  182,  161,  219,    0,  161,  219,  161,
			  161,    0,  168,  167,  169,  170,    0,  171,  167,  120,
			  120,  120,  120,  120,  120,    0,  161,  269,  161,  167,
			  202,  202,  202,    0,  202,  221,  161,    0,  221,  161,
			    0,  161,  161,  207,  207,  207,  209,  209,  209,  213,
			  213,  213,  213,  223,  213,  219,  223,  213,  214,  214,

			  214,  224,    0,  225,  224,  226,  225,  227,  226,  227,
			    0,  231,  227,  228,  231,  270,  228,  229,  229,  229,
			  232,  229,    0,  232,  229,  221,  202,  219,  224,  241,
			  241,  241,  259,  259,  259,  262,  262,  262,    0,    0,
			  273,  274,  225,  223,  213,  276,  259,  270,  226,  262,
			  277,  224,  214,  225,  228,  226,  278,  221,  202,  227,
			  224,  231,  260,  228,  260,    0,    0,  260,  260,  260,
			  232,  229,  273,  274,  225,  223,  213,  276,  259,    0,
			  226,  262,  277,  224,  214,  225,  228,  226,  278,    0,
			  279,  227,  263,  231,  263,  228,  280,  263,  263,  263,

			  281,  282,  232,  229,  264,  283,  264,  264,  264,  265,
			  285,  265,  265,  265,    0,  286,  267,  264,  267,  267,
			  267,  268,  279,  268,  268,  268,    0,  287,  280,  286,
			  288,    0,  281,  282,  289,  290,  291,  283,  292,  293,
			  294,  295,  285,  296,  297,  298,  264,  286,  290,  264,
			  299,  265,  300,  301,  303,  304,  305,  306,  267,  287,
			  306,  286,  288,  268,  307,  308,  289,  290,  291,  309,
			  292,  293,  294,  295,  310,  296,  297,  298,  312,  313,
			  290,  311,  299,  314,  300,  301,  303,  304,  305,  306,
			  315,  316,  306,  317,  318,  319,  307,  308,  320,  311,

			  321,  309,  322,  323,  324,    0,  310,  330,  330,  330,
			  312,  313,    0,  311,  377,  314,  327,  327,  327,  327,
			    0,  335,  315,  316,  335,  317,  318,  319,    0,    0,
			  320,  311,  321,    0,  322,  323,  324,  334,    0,  334,
			  336,  337,  334,  336,  337,  339,  377,    0,  339,  347,
			  347,  347,  347,  365,  365,  365,  335,    0,  364,  364,
			  364,  330,  366,  366,  366,  367,  367,  367,  368,  337,
			  368,  335,  364,  368,  368,  368,  369,  369,  369,  367,
			  370,  370,  370,  371,  378,  371,  371,  371,  335,  334,
			  336,  337,  379,  330,  380,  339,  371,  381,  364,  382,

			  383,  337,  384,  335,  364,  372,  385,  372,  372,  372,
			  375,  367,  375,  375,  375,  376,  378,  376,  376,  376,
			    0,  334,  336,  337,  379,  371,  380,  339,  371,  381,
			  386,  382,  383,  387,  384,  388,  389,  390,  385,  391,
			  392,  393,  394,  396,  397,  398,  399,  372,  400,  401,
			  402,  404,  375,  407,  443,  443,  443,  376,    0,  410,
			  411,  412,  386,  413,  414,  387,  415,  388,  389,  390,
			  416,  391,  392,  393,  394,  396,  397,  398,  399,  417,
			  400,  401,  402,  404,  418,  407,  408,  408,  408,  419,
			  408,  410,  411,  412,  420,  413,  414,  421,  415,  422,

			  425,  408,  416,  426,  427,  428,  429,  433,  433,  433,
			  433,  417,  435,  451,  437,  435,  418,  437,  452,  439,
			  455,  419,  439,  445,  445,  445,  420,    0,    0,  421,
			    0,  422,  425,  457,  459,  426,  427,  428,  429,  442,
			  442,  442,  444,  444,  444,  451,  437,  446,  446,  446,
			  452,  460,  455,  442,  439,  435,  444,  447,  461,  447,
			  447,  447,  435,  456,  437,  457,  459,  456,  448,  439,
			  448,  448,  448,  447,  462,  463,  464,  466,  437,  467,
			  468,  469,  444,  460,  471,  442,  439,  435,  444,  472,
			  461,  473,  475,  479,  435,  456,  437,  480,  481,  456,

			  482,  439,  483,  484,  485,  447,  462,  463,  464,  466,
			  448,  467,  468,  469,  486,  487,  471,  489,  476,  476,
			  476,  472,  476,  473,  475,  479,  490,  493,  494,  480,
			  481,  496,  482,  476,  483,  484,  485,  499,  500,  501,
			  499,  500,  501,  506,  506,  506,  486,  487,  503,  489,
			  503,    0,  510,  503,  503,  503,    0,    0,  490,  493,
			  494,  511,  513,  496,    0,    0,  500,  514,  499,  504,
			  504,  504,  505,  505,  505,  508,  515,  508,  508,  508,
			  518,  501,  520,  504,  510,  521,  505,  499,  500,  501,
			  507,  508,  507,  511,  513,  507,  507,  507,  500,  514,

			  499,  523,  524,  525,  526,  527,  528,  531,  515,  532,
			  534,  535,  518,  501,  520,  504,  537,  521,  505,  499,
			  500,  501,  541,  508,  542,  544,  547,  546,    0,  547,
			  546,    0,    0,  523,  524,  525,  526,  527,  528,  531,
			    0,  532,  534,  535,  548,    0,    0,  548,  537,  549,
			  549,  549,    0,    0,  541,  546,  542,  544,  550,  550,
			  550,  551,  551,  551,  552,    0,  552,  558,  547,  552,
			  552,  552,  548,  560,  562,  551,  547,  546,  553,  563,
			  553,  564,  567,  553,  553,  553,  570,  546,  554,  554,
			  554,  555,  555,  555,  548,  556,  556,  556,  571,  558,

			  547,  573,  554,  574,  548,  560,  562,  551,  547,  546,
			  557,  563,  557,  564,  567,  557,  557,  557,  570,  572,
			  572,  572,  575,  577,  578,  581,  548,  584,  581,  582,
			  571,    0,  582,  573,  554,  574,  583,  593,  599,  583,
			  585,  585,  585,  586,  586,  586,  587,  587,  587,  572,
			  588,  588,  588,  584,  575,  577,  578,    0,    0,  584,
			    0,  602,  581,  589,  589,  589,  590,  603,  590,  593,
			  599,  590,  590,  590,  605,  581,  611,  589,  616,  582,
			    0,  572,  591,  591,  591,  617,  583,  592,  592,  592,
			  601,  601,  601,  602,  581,  608,  621,  622,  608,  603,

			  623,  624,  611,  612,  612,  612,  605,  581,  611,  589,
			  616,  582,  613,  613,  613,  625,    0,  617,  583,    0,
			  601,    0,    0,    0,    0,    0,    0,    0,  621,  622,
			    0,    0,  623,  624,  637,  637,  637,  637,  637,  637,
			  637,  637,  637,    0,    0,  608,    0,  625,    0,  635,
			    0,  635,  601,  635,  635,  635,  635,  635,  635,  635,
			  635,  635,  638,  638,  638,  638,  638,  638,  638,  638,
			    0,    0,    0,    0,    0,    0,    0,  608,  629,  629,
			  629,  629,  629,  629,  629,  629,  629,  629,  629,  629,
			  629,  629,  629,  630,  630,  630,  630,  630,  630,  630,

			  630,  630,  630,  630,  630,  630,  630,  630,  631,  631,
			  631,  631,  631,  631,  631,  631,  631,  631,  631,  631,
			  631,  631,  631,  632,  632,  632,  632,  632,  632,  632,
			  632,  632,  632,  632,  632,  632,  632,  632,  633,  633,
			  633,  633,  633,  633,  633,  633,  633,  633,  633,  633,
			  633,  633,  633,  634,    0,  634,  634,  634,  634,  634,
			  634,  634,  634,  634,  634,  634,  634,  634,  636,    0,
			  636,  636,  636,  636,  636,  636,  636,  636,  636,  636,
			  636,  636,  636,  639,    0,  639,  639,  639,    0,  639,
			  639,  639,  639,  639,  639,  639,  639,  639,  640,  640,

			  640,  640,  640,  640,  640,  640,  640,  640,  640,  640,
			  640,  640,  640,  641,  641,  641,  641,  641,  641,  641,
			  641,  641,  641,  641,  641,  641,  641,  641,  642,  642,
			  642,  642,  642,  642,  642,  642,  642,  642,  642,  642,
			  642,  642,  642,  643,    0,  643,  643,  643,  643,  643,
			  643,  643,  643,  643,  643,  643,  643,  643,  644,    0,
			  644,    0,  644,  644,  644,  644,  644,  644,  644,  644,
			  644,  644,  644,  645,    0,  645,  645,  645,  645,  645,
			  645,  645,  645,  645,  645,  645,  645,  645,  646,    0,
			  646,  646,  646,  646,  646,  646,  646,  646,  646,  646,

			  646,  646,  646,  647,  647,  647,  647,  647,  647,  647,
			  647,  647,  647,  647,  647,  647,  647,  647,  648,    0,
			  648,  648,  648,  648,  648,  648,  648,  648,  648,  648,
			  648,  648,  648,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,

			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   89,   90,   98,  103,  580,  560,  108,
			  111,  114,  117,  560, 1833,  120,  123, 1833,  188,    0,
			 1833,  119, 1833, 1833, 1833, 1833, 1833,  112,  123,  116,
			  129,  146,  151,  518, 1833,  107, 1833,  126,  516,  180,
			  100,  183,  114,  193,  237,    0,  237,  181,  102,  250,
			  129,  120,  188,  245,  112,  244,  173,  194, 1833,  484,
			 1833, 1833,  521, 1833,  446, 1833,  519, 1833, 1833,  328,
			   91,  340, 1833, 1833,  159,  520, 1833, 1833,  181, 1833,
			 1833,  197,  298,  498,  305,  487,  280, 1833,  348,  187,
			  329,  339,  358,  364,  375,  381,  382,  387,  388,  393,

			  397,  409,  399,  383,  480,    0,  469,  563,  467, 1833,
			 1833, 1833,  413, 1833, 1833,  472,  480,  487,  456,  450,
			  597,  492, 1833, 1833, 1833, 1833, 1833, 1833,    0,  249,
			  378,  254,  246,  247,  361,  388,  396,  385,  411,  412,
			  464,    0,  440,  470,  472,  455,  486,  475,    0,  477,
			  522,    0,  484,  501,  477,  481,  497,  560,    0,  485,
			  500,  601,  526,  499,  550,  557,  563,  588,  573,  584,
			  589,  578, 1833, 1833,  460, 1833,  577, 1833, 1833, 1833,
			 1833, 1833,  621, 1833, 1833, 1833, 1833, 1833, 1833, 1833,
			 1833, 1833, 1833, 1833, 1833, 1833, 1833, 1833, 1833,  315,

			 1833, 1833,  668,  418, 1833,  459, 1833,  681, 1833,  684,
			  443, 1833, 1833,  688,  696, 1833, 1833, 1833, 1833,  639,
			 1833,  669, 1833,  687,  695,  697,  699,  703,  707,  715,
			 1833,  705,  714, 1833, 1833, 1833,  412,  398,  389,  375,
			  371,  709,  369,  361,  355,  351,  345,  340,  322,  299,
			  294,  287,  279,  238,  229,  228,  224,  201, 1833,  712,
			  747, 1833,  715,  777,  786,  791,  144,  798,  803,  592,
			  685,    0,    0,  702,  694,    0,  713,  702,  705,  760,
			  749,  750,  767,  771,    0,  760,  785,  793,  782,  785,
			  793,  795,  804,  801,  806,  796,  813,  810,  815,  805,

			  818,  809,    0,  820,  801,  807,  825,  830,  831,  839,
			  824,  849,  831,  845,  853,  852,  848,  859,  853,  861,
			  852,  862,  864,  870,  861,    0, 1833,  897,    0,  123,
			  905, 1833, 1833, 1833,  933,  915,  934,  935, 1833,  939,
			 1833, 1833, 1833, 1833, 1833, 1833, 1833,  930, 1833, 1833,
			 1833, 1833, 1833, 1833, 1833, 1833, 1833, 1833, 1833, 1833,
			 1833, 1833, 1833, 1833,  938,  933,  942,  945,  953,  956,
			  960,  965,  987,  121,  161,  992,  997,  865,  936,  956,
			  956,  957,  951,  966,  953,  972,  994,  986,  997,  989,
			  994,  992,  993, 1007,  992,    0, 1009, 1006,  992,  993,

			 1001, 1015, 1003,    0, 1010,    0,    0, 1012, 1084,    0,
			 1021, 1010, 1023, 1028, 1017, 1024, 1032, 1029, 1043, 1035,
			 1062, 1050, 1054,    0,    0, 1066, 1068, 1054, 1064, 1076,
			    0,    0, 1833, 1088,  105, 1106, 1833, 1108, 1833, 1113,
			 1833,  163, 1119, 1034, 1122, 1103, 1127, 1139, 1150,    0,
			    0, 1070, 1087,    0,    0, 1073, 1129, 1090,    0, 1087,
			 1116, 1124, 1141, 1126, 1133,    0, 1130, 1136, 1146, 1143,
			    0, 1146, 1157, 1153,    0, 1158, 1216, 1833,  146, 1163,
			 1150, 1145, 1162, 1168, 1169, 1157, 1180, 1166,    0, 1168,
			 1196,    0,    0, 1189, 1194,    0, 1188,  138,   61, 1231,

			 1232, 1233, 1833, 1233, 1249, 1252, 1223, 1275, 1257,    0,
			 1202, 1212,    0, 1218, 1218, 1242,    0,    0, 1246,    0,
			 1252, 1251,    0, 1253, 1259, 1254, 1255, 1275, 1257, 1833,
			  105, 1266, 1261,    0, 1267, 1268,    0, 1282,    0,    0,
			    0, 1273, 1281,    0, 1276,   37, 1321, 1320, 1338, 1329,
			 1338, 1341, 1349, 1363, 1368, 1371, 1375, 1395, 1318,    0,
			 1330,    0, 1341, 1346, 1340,    0,    0, 1346,    0,    0,
			 1343, 1364, 1417, 1357, 1369, 1390,    0, 1389, 1390,    0,
			    0, 1419, 1423, 1430, 1393, 1420, 1423, 1426, 1430, 1443,
			 1451, 1462, 1467, 1403,    0,    0,    0,    0,    0, 1389,

			    0, 1488, 1420, 1420,    0, 1440,    0,    0, 1489, 1833,
			 1833, 1442, 1483, 1492,    0,    0, 1437, 1455,    0,    0,
			 1833, 1466, 1449, 1452, 1453, 1467,    0, 1833, 1833, 1577,
			 1592, 1607, 1622, 1637, 1652, 1546, 1667, 1527, 1554, 1682,
			 1697, 1712, 1727, 1742, 1757, 1772, 1787, 1802, 1817, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  628,    1,  629,  629,  630,  630,  631,  631,  632,
			  632,  633,  633,  628,  628,  628,  628,  628,  634,  635,
			  628,  636,  628,  628,  628,  628,  628,  628,  628,  628,
			  637,  637,  637,  628,  628,  628,  628,  628,  628,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  628,  628,
			  628,  628,  637,  628,  628,  628,  639,  628,  628,  628,
			  640,  640,  628,  628,  641,  642,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  634,  628,  643,  644,
			  634,  634,  634,  634,  634,  634,  634,  634,  634,  634,

			  634,  634,  634,  634,  634,  635,  645,  645,  645,  628,
			  628,  628,  628,  628,  628,  628,  637,  637,  637,  637,
			  637,  637,  628,  628,  628,  628,  628,  628,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  628,  628,  639,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  640,

			  628,  628,  640,  641,  628,  642,  628,  628,  628,  628,
			  646,  628,  628,  643,  644,  628,  628,  628,  628,  634,
			  628,  634,  628,  634,  634,  634,  634,  634,  634,  634,
			  628,  634,  634,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  637,  637,  120,  637,  637,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,

			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  628,  628,  646,  646,
			  644,  628,  628,  628,  634,  634,  634,  634,  628,  634,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  637,  637,  120,  628,  637,  637,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,

			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  628,  628,  646,  634,  628,  634,  628,  634,
			  628,  628,  628,  628,  628,  628,  628,  628,  637,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  628,  628,  628,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  628,  646,  634,

			  634,  634,  628,  628,  628,  628,  628,  628,  628,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  628,
			  647,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  646,  634,  634,  634,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  638,  638,  638,  638,  638,  638,  638,  638,  638,  638,
			  648,  634,  634,  634,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  638,  638,  638,  638,  638,  638,  638,

			  638,  628,  638,  638,  638,  638,  638,  638,  634,  628,
			  628,  628,  628,  628,  638,  638,  628,  638,  638,  638,
			  628,  628,  638,  628,  638,  628,  638,  628,    0,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628,  628,
			  628,  628,  628,  628,  628,  628,  628,  628,  628, yy_Dummy>>)
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
			    3,    3,    3,    3,    3,    3,    3,    3,    7,    3,
			    8,    9,   10,    3,    3,    3,    3,    3,    3,    3,
			    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
			    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
			    8,    8,    8,    8,   11,   12,    3,    3,    3,    3,
			   13,    3,    8,    8,    8,    8,    8,    8,    8,    8,
			    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
			    8,    8,    8,    8,    8,    8,   14,   15,    3,    3,
			    3,    3, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    2,    3,    4,    5,
			    5,    5,    5,    5,    6,    8,   11,   13,   16,   19,
			   22,   25,   28,   31,   34,   37,   40,   43,   46,   49,
			   52,   56,   60,   64,   67,   70,   73,   76,   79,   82,
			   86,   90,   94,   98,  102,  106,  110,  114,  118,  122,
			  126,  130,  134,  138,  142,  146,  150,  154,  158,  161,
			  163,  166,  169,  172,  175,  178,  181,  183,  185,  187,
			  189,  191,  193,  195,  197,  199,  201,  203,  205,  207,
			  209,  211,  214,  216,  218,  219,  219,  220,  221,  222,
			  222,  223,  224,  225,  226,  227,  228,  229,  230,  231,

			  232,  233,  235,  236,  237,  239,  240,  241,  242,  243,
			  244,  245,  246,  247,  248,  249,  250,  252,  254,  255,
			  257,  258,  259,  260,  261,  262,  263,  264,  265,  267,
			  269,  271,  273,  276,  278,  280,  282,  284,  286,  288,
			  290,  292,  295,  297,  299,  301,  303,  305,  307,  310,
			  312,  314,  317,  319,  321,  323,  325,  327,  329,  332,
			  334,  336,  338,  340,  342,  344,  346,  348,  350,  352,
			  354,  356,  358,  359,  360,  361,  362,  362,  363,  364,
			  365,  366,  367,  367,  368,  369,  370,  371,  372,  373,
			  374,  375,  376,  377,  378,  379,  380,  381,  382,  383,

			  384,  385,  386,  387,  388,  390,  391,  392,  392,  393,
			  394,  395,  396,  398,  400,  401,  403,  405,  407,  409,
			  410,  412,  413,  415,  416,  417,  418,  419,  420,  421,
			  422,  423,  424,  425,  427,  428,  430,  431,  432,  433,
			  434,  435,  436,  437,  438,  439,  440,  441,  442,  443,
			  444,  445,  446,  447,  448,  449,  450,  451,  452,  454,
			  455,  455,  456,  457,  457,  459,  461,  463,  465,  466,
			  468,  470,  473,  476,  478,  480,  483,  485,  487,  489,
			  491,  493,  495,  497,  499,  502,  504,  506,  508,  510,
			  512,  514,  516,  518,  520,  522,  524,  526,  528,  530,

			  532,  535,  537,  540,  542,  544,  546,  548,  550,  552,
			  554,  556,  558,  560,  562,  564,  566,  568,  570,  572,
			  574,  576,  578,  580,  582,  584,  587,  588,  588,  589,
			  590,  590,  592,  594,  596,  597,  598,  599,  600,  602,
			  603,  605,  607,  608,  609,  610,  611,  612,  613,  614,
			  615,  616,  617,  618,  619,  620,  621,  622,  623,  624,
			  625,  626,  627,  628,  629,  630,  630,  631,  632,  632,
			  632,  633,  635,  637,  638,  638,  640,  642,  644,  646,
			  648,  650,  652,  654,  656,  658,  660,  662,  664,  667,
			  669,  671,  673,  675,  677,  679,  682,  684,  686,  688,

			  690,  692,  694,  696,  699,  701,  704,  707,  709,  712,
			  715,  717,  719,  721,  723,  725,  727,  729,  731,  733,
			  735,  737,  739,  741,  744,  747,  749,  751,  753,  755,
			  757,  760,  763,  764,  764,  765,  766,  768,  769,  771,
			  772,  774,  775,  776,  776,  777,  777,  778,  779,  781,
			  784,  787,  789,  791,  794,  797,  799,  801,  803,  806,
			  808,  810,  812,  814,  816,  818,  821,  823,  825,  827,
			  829,  832,  834,  836,  838,  841,  843,  843,  844,  844,
			  846,  848,  850,  852,  854,  856,  858,  860,  862,  865,
			  867,  869,  872,  875,  877,  879,  882,  884,  884,  885,

			  886,  887,  888,  889,  889,  890,  891,  891,  891,  892,
			  895,  897,  899,  902,  904,  906,  908,  911,  914,  916,
			  919,  921,  923,  926,  928,  930,  932,  934,  936,  938,
			  939,  939,  941,  943,  946,  948,  950,  953,  955,  958,
			  961,  964,  966,  968,  971,  973,  974,  975,  976,  977,
			  977,  978,  979,  979,  979,  980,  980,  981,  981,  983,
			  986,  988,  991,  993,  995,  997, 1000, 1003, 1005, 1008,
			 1011, 1013, 1015, 1017, 1019, 1021, 1023, 1026, 1028, 1030,
			 1033, 1035, 1036, 1037, 1038, 1039, 1039, 1040, 1040, 1041,
			 1042, 1042, 1042, 1043, 1045, 1048, 1051, 1054, 1057, 1060,

			 1062, 1065, 1065, 1067, 1069, 1072, 1074, 1077, 1080, 1081,
			 1083, 1085, 1086, 1086, 1087, 1090, 1093, 1093, 1095, 1098,
			 1101, 1103, 1103, 1105, 1105, 1107, 1107, 1110, 1111, 1111, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  174,  174,  176,  176,  207,  205,  206,    1,  205,
			  206,    1,  206,   36,  205,  206,  177,  205,  206,   41,
			  205,  206,   15,  205,  206,  144,  205,  206,   24,  205,
			  206,   25,  205,  206,   32,  205,  206,   30,  205,  206,
			    9,  205,  206,   31,  205,  206,   14,  205,  206,   33,
			  205,  206,  115,  119,  205,  206,  115,  119,  205,  206,
			  115,  119,  205,  206,    8,  205,  206,    7,  205,  206,
			   19,  205,  206,   18,  205,  206,   20,  205,  206,   11,
			  205,  206,  113,  119,  205,  206,  113,  119,  205,  206,
			  113,  119,  205,  206,  113,  119,  205,  206,  113,  119,

			  205,  206,  113,  119,  205,  206,  113,  119,  205,  206,
			  113,  119,  205,  206,  113,  119,  205,  206,  113,  119,
			  205,  206,  113,  119,  205,  206,  113,  119,  205,  206,
			  113,  119,  205,  206,  113,  119,  205,  206,  113,  119,
			  205,  206,  113,  119,  205,  206,  113,  119,  205,  206,
			  113,  119,  205,  206,  113,  119,  205,  206,   28,  205,
			  206,  205,  206,   29,  205,  206,   34,  205,  206,  119,
			  205,  206,   26,  205,  206,   27,  205,  206,   12,  205,
			  206,  178,  206,  204,  206,  202,  206,  203,  206,  174,
			  206,  174,  206,  173,  206,  172,  206,  174,  206,  176,

			  206,  175,  206,  170,  206,  170,  206,  169,  206,    6,
			  206,    5,    6,  206,    5,  206,    6,  206,    1,  177,
			  166,  177,  177,  177,  177,  177,  177,  177,  177,  177,
			  177,  177,  177,  177, -374,  177,  177,  177, -374,   41,
			  144,  144,  144,    2,   35,   10,  118,   39,   23,  118,
			  115,  119,  115,  119,  119,  114,  119,  119,  119,   16,
			   37,   21,   22,   38,   17,  113,  119,  113,  119,  113,
			  119,  113,  119,   46,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,   58,  113,  119,  113,  119,  113,  119,  113,

			  119,  113,  119,  113,  119,  113,  119,   70,  113,  119,
			  113,  119,  113,  119,   77,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,   89,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,   40,   13,
			  178,  202,  195,  193,  194,  196,  197,  198,  199,  179,
			  180,  181,  182,  183,  184,  185,  186,  187,  188,  189,
			  190,  191,  192,  174,  173,  172,  174,  174,  171,  172,
			  176,  175,  169,    5,    4,  167,  165,  167,  177, -374,

			 -374,  152,  167,  150,  167,  151,  167,  153,  167,  177,
			  146,  167,  177,  147,  167,  177,  177,  177,  177,  177,
			  177,  177, -168,  177,  177,  154,  167,  144,  120,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  121,  144,  118,  116,  118,  115,  119,  115,
			  119,  117,  119,  115,  119,  119,  113,  119,  113,  119,
			   44,  113,  119,   45,  113,  119,  113,  119,  113,  119,
			   49,  113,  119,  113,  119,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,   61,

			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,   81,  113,  119,  113,  119,   84,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  112,  113,  119,  201,    4,    4,
			  155,  167,  148,  167,  149,  167,  177,  177,  177,  177,

			  162,  167,  177,  157,  167,  156,  167,  138,  136,  137,
			  139,  140,  145,  141,  142,  122,  123,  124,  125,  126,
			  127,  128,  129,  130,  131,  132,  133,  134,  135,  118,
			  118,  118,  118,  115,  119,  115,  119,  119,  115,  119,
			  115,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,   59,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,   68,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,   78,  113,  119,  113,

			  119,   80,  113,  119,   82,  113,  119,  113,  119,   87,
			  113,  119,   88,  113,  119,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,  113,
			  119,  103,  113,  119,  104,  113,  119,  113,  119,  113,
			  119,  113,  119,  113,  119,  113,  119,  110,  113,  119,
			  111,  113,  119,  200,    4,  177,  158,  167,  177,  161,
			  167,  177,  164,  167,  145,  118,  118,  118,  118,  115,
			  119,   42,  113,  119,   43,  113,  119,  113,  119,  113,
			  119,   50,  113,  119,   51,  113,  119,  113,  119,  113,

			  119,  113,  119,   56,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,   66,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,   73,
			  113,  119,  113,  119,  113,  119,  113,  119,   79,  113,
			  119,  113,  119,   85,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,  113,  119,
			  113,  119,   99,  113,  119,  113,  119,  113,  119,  102,
			  113,  119,  105,  113,  119,  113,  119,  113,  119,  108,
			  113,  119,  113,  119,    4,  177,  177,  177,  143,  118,
			  118,  118,   47,  113,  119,  113,  119,  113,  119,   53,

			  113,  119,  113,  119,  113,  119,  113,  119,   60,  113,
			  119,   62,  113,  119,  113,  119,   64,  113,  119,  113,
			  119,  113,  119,   69,  113,  119,  113,  119,  113,  119,
			  113,  119,  113,  119,  113,  119,  113,  119,   86,  113,
			  119,  113,  119,   92,  113,  119,  113,  119,  113,  119,
			   95,  113,  119,  113,  119,   97,  113,  119,   98,  113,
			  119,  100,  113,  119,  113,  119,  113,  119,  107,  113,
			  119,  113,  119,    4,  177,  177,  177,  118,  118,  118,
			  118,  113,  119,   52,  113,  119,  113,  119,   55,  113,
			  119,  113,  119,  113,  119,  113,  119,   67,  113,  119,

			   71,  113,  119,  113,  119,   74,  113,  119,   75,  113,
			  119,  113,  119,  113,  119,  113,  119,  113,  119,  113,
			  119,  113,  119,   96,  113,  119,  113,  119,  113,  119,
			  109,  113,  119,    3,    4,  177,  177,  177,  118,  118,
			  118,  118,  118,  113,  119,   54,  113,  119,   57,  113,
			  119,   63,  113,  119,   65,  113,  119,   72,  113,  119,
			  113,  119,   83,  113,  119,  113,  119,  113,  119,   93,
			  113,  119,  113,  119,  101,  113,  119,  106,  113,  119,
			  177,  160,  167,  163,  167,  118,  118,   48,  113,  119,
			   76,  113,  119,  113,  119,   91,  113,  119,   94,  113,

			  119,  159,  167,  113,  119,  113,  119,   90,  113,  119,
			   90, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 1833
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 628
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 629
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

	yyNb_rules: INTEGER is 206
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 207
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
