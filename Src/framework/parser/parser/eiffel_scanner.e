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
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
 ast_factory.create_break_as (Current)  
when 2 then
	yy_end := yy_end - 2
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
 
				last_break_as_start_position := position
				last_break_as_start_line := line
				last_break_as_start_column := column
				ast_factory.set_buffer (token_buffer2, Current)
				set_start_condition (PRAGMA)					
		
when 3 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				last_line_pragma := ast_factory.new_line_pragma (Current)
			
when 4 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 5 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 6 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_SEMICOLON, Current)
				last_token := TE_SEMICOLON
			
when 8 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_COLON, Current)
				last_token := TE_COLON
			
when 9 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_COMMA, Current)
				last_token := TE_COMMA
			
when 10 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DOTDOT, Current)
				last_token := TE_DOTDOT
			
when 11 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_QUESTION, Current)
				last_token := TE_QUESTION
			
when 12 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_TILDE, Current)
				last_token := TE_TILDE
			
when 13 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_CURLYTILDE, Current)
				last_token := TE_CURLYTILDE
			
when 14 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DOT, Current)
				last_token := TE_DOT
			
when 15 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_ADDRESS, Current)
				last_token := TE_ADDRESS
			
when 16 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_symbol_as_value := ast_factory.new_symbol_as (TE_ASSIGNMENT, Current)
				last_token := TE_ASSIGNMENT
			
when 17 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_ACCEPT, Current)
				last_token := TE_ACCEPT
			
when 18 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_EQ, Current)
				last_token := TE_EQ
			
when 19 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LT, Current)
				last_token := TE_LT
			
when 20 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_GT, Current)
				last_token := TE_GT
			
when 21 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LE, Current)
				last_token := TE_LE
			
when 22 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_GE, Current)
				last_token := TE_GE
			
when 23 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_symbol_as_value := ast_factory.new_symbol_as (TE_NOT_TILDE, Current)
				last_token := TE_NOT_TILDE
			
when 24 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_NE, Current)
				last_token := TE_NE
			
when 25 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LPARAN, Current)
				last_token := TE_LPARAN
			
when 26 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_symbol_as_value := ast_factory.new_symbol_as (TE_RPARAN, Current)
				last_token := TE_RPARAN
			
when 27 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LCURLY, Current)
				last_token := TE_LCURLY
			
when 28 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_RCURLY, Current)
				last_token := TE_RCURLY
			
when 29 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_square_symbol_as (TE_LSQURE, Current)
				last_token := TE_LSQURE
			
when 30 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_square_symbol_as (TE_RSQURE, Current)
				last_token := TE_RSQURE
			
when 31 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_PLUS, Current)
				last_token := TE_PLUS
			
when 32 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_MINUS, Current)
				last_token := TE_MINUS
			
when 33 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_STAR, Current)
				last_token := TE_STAR
			
when 34 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_SLASH, Current)
				last_token := TE_SLASH
			
when 35 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_POWER, Current)
				last_token := TE_POWER
			
when 36 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_CONSTRAIN, Current)
				last_token := TE_CONSTRAIN
			
when 37 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_BANG, Current)
				last_token := TE_BANG
			
when 38 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_LARRAY, Current)
				last_token := TE_LARRAY
			
when 39 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_symbol_as_value := ast_factory.new_symbol_as (TE_RARRAY, Current)
				last_token := TE_RARRAY
			
when 40 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_DIV, Current)
				last_token := TE_DIV
			
when 41 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_symbol_as_value := ast_factory.new_symbol_as (TE_MOD, Current)
				last_token := TE_MOD
			
when 42 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_token := TE_FREE
				process_id_as
			
when 43 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AGENT, Current)
				last_token := TE_AGENT
			
when 44 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ALIAS, Current)
				last_token := TE_ALIAS
			
when 45 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ALL, Current)
				last_token := TE_ALL
			
when 46 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AND, Current)
				last_token := TE_AND
			
when 47 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_AS, Current)
				last_token := TE_AS
			
when 48 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ASSIGN, Current)
				if last_keyword_as_value /= Void then
					last_keyword_as_id_index := last_keyword_as_value.index
				end
				last_token := TE_ASSIGN
			
when 49 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				if is_attribute_keyword then
					last_keyword_as_value := ast_factory.new_keyword_as (TE_ATTRIBUTE, Current)
					last_token := TE_ATTRIBUTE
				else
					process_id_as
					last_token := TE_ID
					if has_syntax_warning then
						report_one_warning (
							create {SYNTAX_WARNING}.make (line, column, filename,
								once "Keyword `attribute' is used as identifier."))
					end
				end
			
when 50 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_BIT, Current)
				last_token := TE_BIT
				if has_syntax_warning then
					report_one_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "The `bit' keyword will be removed in the future according to ECMA Eiffel and should not be used."))
				end
			
when 51 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CHECK, Current)
				last_token := TE_CHECK
			
when 52 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CLASS, Current)
				last_token := TE_CLASS
			
when 53 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CONVERT, Current)
				last_token := TE_CONVERT
			
when 54 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_CREATE, Current)
				last_token := TE_CREATE
			
when 55 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_creation_keyword_as (Current)
				last_token := TE_CREATION				
			
when 56 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_current_as_value := ast_factory.new_current_as (Current)
				last_token := TE_CURRENT
			
when 57 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DEBUG, Current)
				last_token := TE_DEBUG
			
when 58 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_deferred_as_value := ast_factory.new_deferred_as (Current)
				last_token := TE_DEFERRED			
			
when 59 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_DO, Current)
				last_token := TE_DO
			
when 60 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSE, Current)
				last_token := TE_ELSE
			
when 61 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ELSEIF, Current)
				last_token := TE_ELSEIF
			
when 62 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_end_keyword_as (Current)
				last_token := TE_END
			
when 63 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ENSURE, Current)
				last_token := TE_ENSURE
			
when 64 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPANDED, Current)
				last_token := TE_EXPANDED
			
when 65 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXPORT, Current)
				last_token := TE_EXPORT
			
when 66 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_EXTERNAL, Current)
				last_token := TE_EXTERNAL
			
when 67 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (False, Current)
				last_token := TE_FALSE
			
when 68 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FEATURE, Current)
				last_token := TE_FEATURE
			
when 69 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_FROM, Current)
				last_token := TE_FROM
			
when 70 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_frozen_keyword_as (Current)
				last_token := TE_FROZEN
			
when 71 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IF, Current)
				last_token := TE_IF
			
when 72 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IMPLIES, Current)
				last_token := TE_IMPLIES
			
when 73 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				if is_indexing_keyword then
					last_keyword_as_value := ast_factory.new_keyword_as (TE_INDEXING, Current)
					last_token := TE_INDEXING
				else
					process_id_as
					last_token := TE_ID
				end
			
when 74 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_infix_keyword_as (Current)
				last_token := TE_INFIX
			
when 75 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INHERIT, Current)
				last_token := TE_INHERIT
			
when 76 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INSPECT, Current)
				last_token := TE_INSPECT
			
when 77 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_INVARIANT, Current)
				last_token := TE_INVARIANT
			
when 78 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_IS, Current)
				last_token := TE_IS
			
when 79 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LIKE, Current)
				last_token := TE_LIKE
			
when 80 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOCAL, Current)
				last_token := TE_LOCAL
			
when 81 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_LOOP, Current)
				last_token := TE_LOOP
			
when 82 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_MODIFY, Current)
				last_token := TE_MODIFY
			
when 83 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_NOT, Current)
				last_token := TE_NOT
			
when 84 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				if is_note_keyword then
					last_keyword_as_value := ast_factory.new_keyword_as (TE_NOTE, Current)
					last_token := TE_NOTE
				else
					process_id_as
					last_token := TE_ID
					if has_syntax_warning then
						report_one_warning (
							create {SYNTAX_WARNING}.make (line, column, filename,
								once "Keyword `note' is used as identifier."))
					end
				end
			
when 85 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OBSOLETE, Current)
				last_token := TE_OBSOLETE
			
when 86 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OLD, Current)
				last_token := TE_OLD
			
when 87 then
	yy_end := yy_end - 1
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text,  line, column, position, 4)
				last_token := TE_ONCE_STRING
			
when 88 then
	yy_end := yy_end - 1
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_once_string_keyword_as (text_substring (1, 4),  line, column, position, 4)
					-- Assume all trailing characters are in the same line (which would be false if '\n' appears).
				ast_factory.create_break_as_with_data (text_substring (5, text_count), line, column + 4, position + 4, text_count - 4)
				last_token := TE_ONCE_STRING			
			
when 89 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_ONCE, Current)
				last_token := TE_ONCE
			
when 90 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_token := TE_ID
				process_id_as
				if has_syntax_warning then
					report_one_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of `only', possibly a new keyword in future definition of `Eiffel'."))
				end
			
when 91 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_OR, Current)
				last_token := TE_OR
			
when 92 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_PARTIAL_CLASS, Current)
				last_token := TE_PARTIAL_CLASS
			
when 93 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_precursor_keyword_as (Current)
				last_token := TE_PRECURSOR
			
when 94 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_prefix_keyword_as (Current)
				last_token := TE_PREFIX
			
when 95 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REDEFINE, Current)
				last_token := TE_REDEFINE
			
when 96 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REFERENCE, Current)
				last_token := TE_REFERENCE
			
when 97 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RENAME, Current)
				last_token := TE_RENAME
			
when 98 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_REQUIRE, Current)
				last_token := TE_REQUIRE
			
when 99 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_RESCUE, Current)
				last_token := TE_RESCUE
			
when 100 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
					
				last_result_as_value := ast_factory.new_result_as (Current)
				last_token := TE_RESULT
			
when 101 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_retry_as_value := ast_factory.new_retry_as (Current)
				last_token := TE_RETRY
			
when 102 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SELECT, Current)
				last_token := TE_SELECT
			
when 103 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_SEPARATE, Current)
				last_token := TE_SEPARATE
			
when 104 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_STRIP, Current)
				last_token := TE_STRIP
			
when 105 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_THEN, Current)
				last_token := TE_THEN
			
when 106 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_bool_as_value := ast_factory.new_boolean_as (True, Current)
				last_token := TE_TRUE
			
when 107 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_token := TE_TUPLE
				process_id_as
			
when 108 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNDEFINE, Current)
				last_token := TE_UNDEFINE
			
when 109 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_unique_as_value := ast_factory.new_unique_as (Current)
				last_token := TE_UNIQUE
			
when 110 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_UNTIL, Current)
				last_token := TE_UNTIL
			
when 111 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_keyword_as_value := ast_factory.new_keyword_as (TE_USE, Current)
				last_token := TE_USE
			
when 112 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				last_keyword_as_value := ast_factory.new_keyword_as (TE_VARIANT, Current)
				last_token := TE_VARIANT
			
when 113 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_void_as_value := ast_factory.new_void_as (Current)
				last_token := TE_VOID
			
when 114 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_WHEN, Current)
				last_token := TE_WHEN
			
when 115 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				last_keyword_as_value := ast_factory.new_keyword_as (TE_XOR, Current)
				last_token := TE_XOR
			
when 116 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_token := TE_ID
				process_id_as
			
when 117 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				last_token := TE_A_BIT			
				last_id_as_value := ast_factory.new_filled_bit_id_as (Current)

				if has_syntax_warning then
					report_one_warning (
						create {SYNTAX_WARNING}.make (line, column, filename,
							once "Use of bit syntax will be removed in the future according to ECMA Eiffel and should not be used."))
				end
			
when 118 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
		-- Recognizes hexadecimal integer numbers.
				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 121 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
		-- Recognizes octal integer numbers.
				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 122 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
		-- Recognizes binary integer numbers.
				token_buffer.clear_all
				append_text_to_string (token_buffer)				
				last_token := TE_INTEGER
			
when 123 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
		-- Recognizes erronous binary and octal numbers.
				report_invalid_integer_error (token_buffer)
			
when 124 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_to_string (token_buffer)
				token_buffer.to_lower
				last_token := TE_REAL
			
when 125 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character (text_item (2))
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 126 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- This is not correct Eiffel!
				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 127 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%A')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 128 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%B')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 129 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%C')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 130 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%D')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 131 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%F')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 132 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%H')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 133 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%L')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 134 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%N')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 135 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%Q')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 136 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%R')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 137 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%S')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 138 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%T')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 139 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%U')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 140 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%V')
				last_token := TE_CHAR				
				ast_factory.set_buffer (token_buffer2, Current)
			
when 141 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%%')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 142 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%'')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 143 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%"')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 144 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%(')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 145 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%)')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 146 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%<')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 147 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				token_buffer.append_character ('%>')
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 148 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (1, text_count - 1, token_buffer)
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 149 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (1, text_count - 1, token_buffer)
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 150 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (1, text_count - 1, token_buffer)
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 151 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (1, text_count - 1, token_buffer)
				last_token := TE_CHAR
				ast_factory.set_buffer (token_buffer2, Current)
			
when 152 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				report_invalid_integer_error (token_buffer)
			
when 153 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 154 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- Unrecognized character.
					-- (catch-all rules (no backing up))
				report_character_missing_quote_error (text)
			
when 155 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LT
			
when 156 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GT
			
when 157 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
				
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_LE
			
when 158 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end
			
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_GE
			
when 159 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_PLUS
			
when 160 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MINUS
			
when 161 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_STAR
			
when 162 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_SLASH
			
when 163 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_POWER
			
when 164 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_DIV
			
when 165 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_MOD
			
when 166 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_BRACKET
			
when 167 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND
			
when 168 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 9, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_AND_THEN
			
when 169 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_IMPLIES
			
when 170 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_NOT
			
when 171 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 3, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR
			
when 172 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 8, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_OR_ELSE
			
when 173 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, 4, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_XOR
			
when 174 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				token_buffer.clear_all
				append_text_substring_to_string (2, text_count - 1, token_buffer)
				ast_factory.set_buffer (token_buffer2, Current)
				last_token := TE_STR_FREE
				if token_buffer.count > maximum_string_length then
					report_too_long_string (token_buffer)
				end
			
when 175 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- Empty string.
				ast_factory.set_buffer (token_buffer2, Current)
				string_position := position
				last_token := TE_EMPTY_STRING
			
when 176 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
			
when 177 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
			
when 178 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (VERBATIM_STR1)
			
when 179 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
			
when 180 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
							report_one_warning (
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
			
when 181 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (VERBATIM_STR2)
			
when 182 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
			
when 183 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 184 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				if token_buffer.count > 2 and then token_buffer.item (token_buffer.count - 1) = '%R' then
						-- Remove \r in \r\n.
					token_buffer.remove (token_buffer.count - 1)
				end
				set_start_condition (VERBATIM_STR1)
			
when 185 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final bracket-double-quote.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 186 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
			
when 187 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				append_text_to_string (token_buffer)
			
when 188 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%A")
				token_buffer.append_character ('%A')
			
when 189 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%B")
				token_buffer.append_character ('%B')
			
when 190 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%C")
				token_buffer.append_character ('%C')
			
when 191 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%D")
				token_buffer.append_character ('%D')
			
when 192 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%F")
				token_buffer.append_character ('%F')
			
when 193 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%H")
				token_buffer.append_character ('%H')
			
when 194 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%L")
				token_buffer.append_character ('%L')
			
when 195 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%N")
				token_buffer.append_character ('%N')
			
when 196 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%Q")
				token_buffer.append_character ('%Q')
			
when 197 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%R")
				token_buffer.append_character ('%R')
			
when 198 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%S")
				token_buffer.append_character ('%S')
			
when 199 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%T")
				token_buffer.append_character ('%T')
			
when 200 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%U")
				token_buffer.append_character ('%U')
			
when 201 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%V")
				token_buffer.append_character ('%V')
			
when 202 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%%")
				token_buffer.append_character ('%%')
			
when 203 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%'")
				token_buffer.append_character ('%'')
			
when 204 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%%"")
				token_buffer.append_character ('%"')
			
when 205 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%(")
				token_buffer.append_character ('%(')
			
when 206 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%)")
				token_buffer.append_character ('%)')
			
when 207 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%<")
				token_buffer.append_character ('%<')
			
when 208 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_string_to_buffer (token_buffer2, once "%%>")
				token_buffer.append_character ('%>')
			
when 209 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				ast_factory.append_text_to_buffer (token_buffer2, Current)
				process_string_character_code (text_substring (3, text_count - 1).to_integer)
			
when 210 then
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- This regular expression should actually be: %\n[ \t\r]*%
					-- Left as-is for compatibility with previous releases.
			ast_factory.append_text_to_buffer (token_buffer2, Current)
			
when 211 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
			
when 212 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- Bad special character.
				ast_factory.append_text_to_buffer (token_buffer2, Current)
				set_start_condition (INITIAL)
				report_string_bad_special_character_error
			
when 213 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final double-quote.
				set_start_condition (INITIAL)
				report_string_missing_quote_error (token_buffer)
			
when 214 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				report_unknown_token_error (text_item (1))
			
when 215 then
yy_set_line_column
	yy_position := yy_position + 1
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

				terminate
			
when 1 then
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final double-quote.
				set_start_condition (INITIAL)
				report_string_missing_quote_error (token_buffer)
			
when 2 then
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 3 then
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 4 then
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
end

					-- No final bracket-double-quote.
				set_start_condition (INITIAL)
				report_missing_end_of_verbatim_string_error (token_buffer)
			
when 5 then
--|#line <not available> "eiffel.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel.l' at line <not available>")
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
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 2005)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			yy_nxt_template_3 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,   14,   15,   16,   15,   17,   18,   19,   20,   14,
			   19,   21,   22,   23,   24,   25,   26,   27,   28,   29,
			   30,   31,   32,   32,   33,   34,   35,   36,   37,   38,
			   19,   39,   40,   41,   42,   43,   44,   45,   45,   46,
			   45,   45,   47,   48,   49,   50,   51,   45,   52,   53,
			   54,   55,   56,   57,   58,   45,   45,   59,   60,   61,
			   62,   14,   14,   39,   40,   41,   42,   43,   44,   45,
			   45,   46,   45,   45,   47,   48,   49,   50,   51,   45,
			   52,   53,   54,   55,   56,   57,   58,   45,   45,   63,
			   19,   64,   65,   67,   67,  579,   68,   68,  109,   69,

			   69,   71,   72,   71,  618,   73,   71,   72,   71,  110,
			   73,   78,   79,   78,   78,   79,   78,   81,   82,   81,
			   81,   82,   81,   84,   84,   84,   84,   84,   84,  107,
			  136,  108,   83,  125,  126,   83,  127,  128,   85,  113,
			  111,   85,  112,  112,  112,  112,  116,  114,  117,  117,
			  118,  118,  156,  154,  157,  164,  142,  663,   74,  155,
			  119,  120,  136,   74,  617,  116,  143,  117,  117,  118,
			  118,  174,  116,  575,  118,  118,  118,  118,  616,  123,
			  204,  175,  121,  205,  156,  154,  157,  164,  142,  122,
			   74,  155,  119,  120,  663,   74,   87,   88,  143,   89,

			   88,  270,  270,  174,   90,   91,  218,   92,  122,   93,
			  165,  123,  115,  175,  121,  122,   94,  615,   95,  131,
			   88,   96,  611,  137,  132,  166,  133,  138,  162,   97,
			  139,  134,  135,  140,   98,   99,  141,  144,  218,  145,
			  172,  170,  165,  494,  100,  163,  171,  101,  102,  146,
			  103,  131,  568,   96,  173,  137,  132,  166,  133,  138,
			  162,   97,  139,  134,  135,  140,   98,   99,  141,  144,
			  147,  145,  172,  170,  148,  150,  100,  163,  171,  104,
			   88,  146,  151,  152,  158,  167,  173,  149,  153,  204,
			  521,  521,  208,  276,  159,  168,  160,  279,  169,  280,

			  161,  446,  147,  211,  212,  211,  148,  150,  553,  206,
			  204,  206,  520,  205,  151,  152,  158,  167,  574,  149,
			  153,  213,  213,  213,  281,  276,  159,  168,  160,  279,
			  169,  280,  161,  180,  180,  180,  215,  181,  219,   89,
			  182,   89,  183,  184,  185,  213,  213,  213,  220,  221,
			  186,   89,   89,   84,   84,   84,  281,  187,  204,  188,
			  575,  205,  189,  190,  191,  192,  207,  193,   85,  194,
			  282,  222,  516,  195,   89,  196,  265,  386,  197,  198,
			  199,  200,  201,  202,  223,   86,   86,  104,   86,  104,
			  216,  224,  226,   89,   89,   89,  283,  284,  207,  104,

			  104,  215,  282,  384,   89,  215,  215,  215,   89,   89,
			   89,  215,  225,  227,   89,  215,  285,  237,   89,  104,
			   89,  104,  104,  233,  234,  233,  448,  215,  283,  284,
			   89,  104,  104,  286,  263,  263,  263,  263,  287,  228,
			  386,  217,  104,  104,  229,  230,  384,  231,  285,  264,
			  232,  288,  104,  290,  104,  289,  104,  104,  104,  272,
			  272,  272,  104,  373,  372,  286,  104,  236,  104,  277,
			  287,  228,  278,  217,  104,  104,  229,  230,  104,  231,
			  235,  264,  232,  288,  104,  290,  295,  289,  104,  104,
			  104,  211,  212,  211,  104,  233,  234,  233,  104,  215,

			  104,  277,   89,  265,  278,  266,  266,  266,  266,  296,
			  104,  116,  297,  268,  268,  269,  269,  291,  295,  116,
			  267,  269,  269,  269,  269,  123,  274,  274,  274,  274,
			  371,  298,  292,  293,  304,  370,  305,  294,  307,  308,
			  309,  296,  310,  313,  297,  314,  311,  323,  306,  291,
			  104,  369,  267,  324,  122,  312,  578,  123,  368,  325,
			  326,  330,  122,  298,  292,  293,  304,  275,  305,  294,
			  307,  308,  309,  204,  310,  313,  208,  314,  311,  323,
			  306,  367,  104,  240,  366,  324,  241,  312,  242,  243,
			  244,  325,  326,  330,  270,  270,  245,  365,  579,  331,

			  364,  332,  299,  246,  300,  247,  301,  333,  248,  249,
			  250,  251,  321,  252,  363,  253,  322,  302,  334,  254,
			  303,  255,  270,  270,  256,  257,  258,  259,  260,  261,
			  315,  331,  316,  332,  299,  383,  300,  327,  301,  333,
			  317,  362,  328,  318,  321,  319,  320,  361,  322,  302,
			  334,  360,  303,  329,  180,  180,  180,  336,  336,  336,
			  336,  335,  315,  383,  316,  359,  206,  204,  206,  327,
			  205,  358,  317,  340,  328,  318,   89,  319,  320,  213,
			  213,  213,  339,  234,  339,  329,   86,  233,  234,  233,
			  341,  216,  342,   89,   89,   89,  215,  215,  390,   89,

			   89,  215,  355,  349,   89,  346,   89,  347,  215,  354,
			   89,   89,  233,  234,  233,  350,  215,  391,   89,   89,
			  353,  392,  352,  207,  104,  343,  356,  357,  357,  357,
			  390,  374,  374,  374,  374,  351,  344,  218,  393,  394,
			  395,  104,  217,  104,  338,  345,  264,  104,  104,  391,
			  348,  396,  104,  392,  104,  207,  104,  343,  104,  104,
			  210,  377,  377,  377,  377,  397,  104,  104,  344,  218,
			  393,  394,  395,  104,  217,  104,  378,  345,  264,  104,
			  104,  179,  348,  396,  104,  262,  104,  375,  398,  375,
			  104,  104,  376,  376,  376,  376,  239,  397,  104,  104,

			  272,  272,  272,  109,  379,  399,  379,  400,  378,  380,
			  380,  380,  380,  116,  401,  381,  381,  382,  382,  116,
			  398,  382,  382,  382,  382,  402,  387,  123,  388,  388,
			  388,  388,  389,  389,  389,  389,  403,  399,  405,  400,
			  406,  385,  407,  410,  411,  408,  401,  412,  413,  414,
			  404,  415,  416,  417,  418,  419,  122,  402,  409,  123,
			  420,  421,  122,  422,  423,  424,  427,  428,  403,  275,
			  405,  429,  406,  275,  407,  410,  411,  408,  430,  412,
			  413,  414,  404,  415,  416,  417,  418,  419,  425,  431,
			  409,  426,  420,  421,  433,  422,  423,  424,  427,  428,

			  434,  435,  436,  429,  437,  438,  439,  432,  440,  441,
			  430,  442,  443,  444,  445,  446,  447,  447,  447,  447,
			  425,  431,  215,  426,  214,   89,  433,  339,  234,  339,
			  466,  210,  434,  435,  436,  179,  437,  438,  439,  432,
			  440,  441,  467,  442,  443,  444,  445,  449,  452,  450,
			  215,   89,   89,   89,  177,  468,  454,  469,  451,   89,
			  176,  129,  466,  455,  357,  357,  357,  357,  455,  357,
			  357,  357,  357,  104,  467,  124,  456,  457,  663,  453,
			   76,  470,  218,  376,  376,  376,  376,  468,   76,  469,
			  451,  376,  376,  376,  376,  471,  472,  473,  458,  104, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  104,  104,  663,  474,  475,  104,  663,  104,  456,  457,
			  462,  453,  462,  470,  218,  463,  463,  463,  463,  459,
			  459,  459,  459,  461,  461,  461,  461,  471,  472,  473,
			  458,  104,  104,  104,  264,  474,  475,  663,  378,  104,
			  380,  380,  380,  380,  380,  380,  380,  380,  464,  476,
			  381,  381,  382,  382,  464,  477,  382,  382,  382,  382,
			  460,  478,  123,  479,  480,  663,  264,  481,  482,  387,
			  378,  465,  465,  465,  465,  387,  483,  389,  389,  389,
			  389,  476,  484,  485,  486,  487,  663,  477,  488,  489,
			  490,  275,  491,  478,  123,  479,  480,  275,  492,  481,

			  482,  493,  497,  498,  499,  500,  501,  502,  483,  503,
			  504,  505,  275,  506,  484,  485,  486,  487,  275,  507,
			  488,  489,  490,  508,  491,  494,  494,  494,  509,  495,
			  492,  510,  511,  493,  497,  498,  499,  500,  501,  502,
			  496,  503,  504,  505,  512,  506,  513,  514,  531,  215,
			  215,  507,   89,   89,  215,  508,  532,   89,  663,  533,
			  509,  663,  663,  510,  511,  446,  515,  515,  515,  515,
			  523,  523,  523,  271,  271,  271,  512,  663,  513,  514,
			  531,  663,  536,  518,  459,  459,  459,  459,  532,  663,
			  519,  533,  663,  517,  526,  526,  526,  526,  534,  525,

			  104,  104,  535,  537,  538,  104,  527,  527,  527,  527,
			  463,  463,  463,  463,  536,  518,  463,  463,  463,  463,
			  539,  378,  519,  540,  265,  517,  527,  527,  527,  527,
			  534,  525,  104,  104,  535,  537,  538,  104,  541,  542,
			  530,  529,  389,  389,  389,  389,  543,  528,  544,  545,
			  546,  663,  539,  378,  547,  540,  548,  549,  550,  551,
			  494,  494,  494,  554,  552,  555,  556,  557,  558,  559,
			  541,  542,  560,  529,  561,  496,  562,  563,  543,  564,
			  544,  545,  546,  122,  565,  566,  547,  567,  548,  549,
			  550,  551,  589,  215,  590,  554,   89,  555,  556,  557,

			  558,  559,  215,  663,  560,   89,  561,  215,  562,  563,
			   89,  564,  572,  521,  521,  663,  565,  566,  663,  567,
			  576,  523,  523,  523,  589,  569,  590,  580,  591,  580,
			  663,  570,  581,  581,  581,  581,  582,  582,  582,  582,
			  527,  527,  527,  527,  104,  585,  585,  585,  585,  592,
			  571,  583,  593,  104,  573,  584,  594,  569,  104,  586,
			  591,  586,  577,  570,  587,  587,  587,  587,  595,  265,
			  596,  585,  585,  585,  585,  597,  104,  598,  599,  600,
			  601,  592,  571,  583,  593,  104,  588,  584,  594,  602,
			  104,  603,  604,  605,  606,  607,  608,  609,  610,  628,

			  595,  215,  596,  215,   89,  215,   89,  597,   89,  598,
			  599,  600,  601,  581,  581,  581,  581,  629,  588,  630,
			  663,  602,  663,  603,  604,  605,  606,  607,  608,  609,
			  610,  628,  612,  663,  614,  581,  581,  581,  581,  663,
			  619,  619,  619,  619,  613,  624,  624,  624,  624,  629,
			  631,  630,  104,  632,  104,  583,  104,  633,  634,  635,
			  625,  663,  663,  620,  612,  620,  614,  663,  621,  621,
			  621,  621,  622,  638,  622,  663,  613,  623,  623,  623,
			  623,  639,  631,  640,  104,  632,  104,  583,  104,  633,
			  634,  635,  625,  587,  587,  587,  587,  587,  587,  587,

			  587,  626,  641,  626,  642,  638,  627,  627,  627,  627,
			  636,  636,  636,  639,  215,  640,  644,   89,  645,   89,
			  663,   89,  583,  621,  621,  621,  621,  621,  621,  621,
			  621,  649,  650,  663,  641,  663,  642,  623,  623,  623,
			  623,  637,  623,  623,  623,  623,  663,  663,  460,  273,
			  273,  273,  643,  663,  583,  646,  646,  646,  646,  627,
			  627,  627,  627,  649,  650,  104,  652,  104,  653,  104,
			  625,  654,  647,  637,  647,  663,  656,  648,  648,  648,
			  648,  636,  636,  636,  643,  627,  627,  627,  627,  655,
			  625,  657,   89,  648,  648,  648,  648,  104,  652,  104,

			  653,  104,  625,  654,  648,  648,  648,  648,  656,  658,
			  659,  660,  651,  661,  662,  663,  528,  522,  522,  522,
			  663,  663,  625,  657,  105,  663,  105,  663,  105,  105,
			  105,  105,  105,  105,  105,  105,  105,  524,  524,  524,
			  104,  658,  659,  660,  651,  661,  662,  130,  130,  130,
			  130,  130,  130,  130,  130,  130,  178,  663,  178,  178,
			  178,  663,  178,  178,  178,  178,  178,  178,  178,  178,
			  178,  663,  104,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   70,   70,
			   70,   70,   70,   70,   70,   70,   70,   70,   70,   70,

			   70,   70,   70,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   77,   77,
			   77,   77,   77,   77,   77,   77,   77,   77,   77,   77,
			   77,   77,   77,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   86,  663,
			   86,   86,   86,   86,   86,   86,   86,   86,   86,   86,
			   86,   86,   86,  106,  663,  106,  106,  106,  106,  106,
			  106,  106,  106,  106,  106,  106,  106,  106,  203,  203,
			  203,  203,  203,  203,  203,  203,  203,  203,  203,  203,
			  203,  203,  203,  207,  207,  207,  207,  207,  207,  207,

			  207,  207,  207,  207,  207,  207,  207,  207,  209,  209,
			  209,  209,  209,  209,  209,  209,  209,  209,  209,  209,
			  209,  209,  209,   88,  663,   88,   88,   88,   88,   88,
			   88,   88,   88,   88,   88,   88,   88,   88,   89,  663,
			   89,  663,   89,   89,   89,   89,   89,   89,   89,   89,
			   89,   89,   89,  238,  663,  238,  238,  238,  238,  238,
			  238,  238,  238,  238,  238,  238,  238,  238,  337,  663,
			  337,  337,  337,  337,  337,  337,  337,  337,  337,  337,
			  337,  337,  337,  553,  553,  553,  553,  553,  553,  553,
			  553,  553,  553,  553,  553,  553,  553,  553,  611,  663,

			  611,  611,  611,  611,  611,  611,  611,  611,  611,  611,
			  611,  611,  611,   13,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_nxt_template_3 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  663,  663,  663,  663,  663,  663, yy_Dummy>>,
			1, 6, 2000)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 2005)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			yy_chk_template_3 (an_array)
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
			    1,    1,    1,    3,    4,  579,    3,    4,   27,    3,

			    4,    5,    5,    5,  578,    5,    6,    6,    6,   27,
			    6,    9,    9,    9,   10,   10,   10,   11,   11,   11,
			   12,   12,   12,   15,   15,   15,   16,   16,   16,   21,
			   40,   21,   11,   35,   35,   12,   37,   37,   15,   29,
			   28,   16,   28,   28,   28,   28,   30,   29,   30,   30,
			   30,   30,   48,   47,   49,   52,   42,  577,    5,   47,
			   30,   30,   40,    6,  576,   31,   42,   31,   31,   31,
			   31,   57,   32,  575,   32,   32,   32,   32,  574,   31,
			   70,   58,   30,   70,   48,   47,   49,   52,   42,   30,
			    5,   47,   30,   30,  573,    6,   18,   18,   42,   18,

			   18,  119,  119,   57,   18,   18,   89,   18,   31,   18,
			   53,   31,   29,   58,   30,   32,   18,  572,   18,   39,
			   18,   18,  568,   41,   39,   53,   39,   41,   51,   18,
			   41,   39,   39,   41,   18,   18,   41,   43,   89,   43,
			   56,   55,   53,  553,   18,   51,   55,   18,   18,   43,
			   18,   39,  516,   18,   56,   41,   39,   53,   39,   41,
			   51,   18,   41,   39,   39,   41,   18,   18,   41,   43,
			   44,   43,   56,   55,   44,   46,   18,   51,   55,   18,
			   18,   43,   46,   46,   50,   54,   56,   44,   46,   74,
			  456,  456,   74,  131,   50,   54,   50,  133,   54,  134,

			   50,  515,   44,   78,   78,   78,   44,   46,  496,   71,
			   71,   71,  455,   71,   46,   46,   50,   54,  522,   44,
			   46,   81,   81,   81,  135,  131,   50,   54,   50,  133,
			   54,  134,   50,   69,   69,   69,   86,   69,   90,   86,
			   69,   90,   69,   69,   69,   82,   82,   82,   91,   92,
			   69,   91,   92,   84,   84,   84,  135,   69,  203,   69,
			  522,  203,   69,   69,   69,   69,   71,   69,   84,   69,
			  136,   93,  448,   69,   93,   69,  387,  386,   69,   69,
			   69,   69,   69,   69,   93,   88,   88,   86,   88,   90,
			   88,   94,   95,   88,   94,   95,  137,  138,   71,   91,

			   92,   96,  136,  384,   96,   99,   98,   97,   99,   98,
			   97,  100,   94,   95,  100,  102,  139,  103,  102,   86,
			  103,   90,   93,  101,  101,  101,  338,  101,  137,  138,
			  101,   91,   92,  140,  112,  112,  112,  112,  141,   96,
			  273,   88,   94,   95,   97,   98,  271,   99,  139,  112,
			  100,  142,   96,  144,   93,  142,   99,   98,   97,  120,
			  120,  120,  100,  261,  260,  140,  102,  102,  103,  132,
			  141,   96,  132,   88,   94,   95,   97,   98,  101,   99,
			  101,  112,  100,  142,   96,  144,  147,  142,   99,   98,
			   97,  211,  211,  211,  100,  104,  104,  104,  102,  104,

			  103,  132,  104,  116,  132,  116,  116,  116,  116,  148,
			  101,  117,  149,  117,  117,  117,  117,  145,  147,  118,
			  116,  118,  118,  118,  118,  117,  122,  122,  122,  122,
			  259,  151,  145,  146,  154,  258,  155,  146,  156,  157,
			  158,  148,  159,  162,  149,  163,  160,  166,  155,  145,
			  104,  257,  116,  167,  117,  160,  524,  117,  256,  168,
			  169,  171,  118,  151,  145,  146,  154,  122,  155,  146,
			  156,  157,  158,  207,  159,  162,  207,  163,  160,  166,
			  155,  255,  104,  107,  254,  167,  107,  160,  107,  107,
			  107,  168,  169,  171,  270,  270,  107,  253,  524,  172,

			  252,  173,  152,  107,  152,  107,  152,  174,  107,  107,
			  107,  107,  165,  107,  251,  107,  165,  152,  175,  107,
			  152,  107,  383,  383,  107,  107,  107,  107,  107,  107,
			  164,  172,  164,  173,  152,  270,  152,  170,  152,  174,
			  164,  250,  170,  164,  165,  164,  164,  249,  165,  152,
			  175,  248,  152,  170,  180,  180,  180,  186,  186,  186,
			  186,  180,  164,  383,  164,  247,  206,  206,  206,  170,
			  206,  246,  164,  223,  170,  164,  223,  164,  164,  213,
			  213,  213,  218,  218,  218,  170,  217,  217,  217,  217,
			  225,  217,  227,  225,  217,  227,  229,  228,  276,  229,

			  228,  230,  244,  235,  230,  231,  235,  231,  232,  243,
			  231,  232,  233,  233,  233,  236,  233,  277,  236,  233,
			  242,  280,  241,  206,  223,  228,  245,  245,  245,  245,
			  276,  263,  263,  263,  263,  240,  229,  218,  281,  283,
			  284,  225,  217,  227,  214,  230,  263,  229,  228,  277,
			  232,  285,  230,  280,  235,  206,  223,  228,  231,  232,
			  209,  266,  266,  266,  266,  286,  236,  233,  229,  218,
			  281,  283,  284,  225,  217,  227,  266,  230,  263,  229,
			  228,  178,  232,  285,  230,  108,  235,  264,  287,  264,
			  231,  232,  264,  264,  264,  264,  106,  286,  236,  233,

			  272,  272,  272,   85,  267,  288,  267,  289,  266,  267,
			  267,  267,  267,  268,  290,  268,  268,  268,  268,  269,
			  287,  269,  269,  269,  269,  292,  274,  268,  274,  274,
			  274,  274,  275,  275,  275,  275,  293,  288,  294,  289,
			  295,  272,  296,  298,  299,  297,  290,  300,  301,  302,
			  293,  303,  304,  305,  306,  307,  268,  292,  297,  268,
			  308,  309,  269,  311,  312,  313,  315,  316,  293,  274,
			  294,  317,  295,  275,  296,  298,  299,  297,  318,  300,
			  301,  302,  293,  303,  304,  305,  306,  307,  314,  319,
			  297,  314,  308,  309,  320,  311,  312,  313,  315,  316,

			  321,  322,  323,  317,  324,  325,  326,  319,  327,  328,
			  318,  329,  331,  332,  333,  336,  336,  336,  336,  336,
			  314,  319,  344,  314,   83,  344,  320,  339,  339,  339,
			  390,   75,  321,  322,  323,   66,  324,  325,  326,  319,
			  327,  328,  391,  329,  331,  332,  333,  343,  345,  343,
			  346,  345,  343,  346,   64,  392,  348,  393,  344,  348,
			   60,   38,  390,  356,  356,  356,  356,  356,  357,  357,
			  357,  357,  357,  344,  391,   33,  356,  356,   13,  346,
			    8,  394,  339,  375,  375,  375,  375,  392,    7,  393,
			  344,  376,  376,  376,  376,  395,  396,  397,  356,  345, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  343,  346,    0,  398,  399,  344,    0,  348,  356,  356,
			  378,  346,  378,  394,  339,  378,  378,  378,  378,  374,
			  374,  374,  374,  377,  377,  377,  377,  395,  396,  397,
			  356,  345,  343,  346,  374,  398,  399,    0,  377,  348,
			  379,  379,  379,  379,  380,  380,  380,  380,  381,  400,
			  381,  381,  381,  381,  382,  401,  382,  382,  382,  382,
			  374,  402,  381,  403,  404,    0,  374,  405,  406,  388,
			  377,  388,  388,  388,  388,  389,  407,  389,  389,  389,
			  389,  400,  409,  410,  411,  412,    0,  401,  413,  414,
			  415,  381,  417,  402,  381,  403,  404,  382,  419,  405,

			  406,  421,  424,  425,  426,  427,  428,  429,  407,  430,
			  431,  432,  388,  433,  409,  410,  411,  412,  389,  434,
			  413,  414,  415,  435,  417,  422,  422,  422,  436,  422,
			  419,  439,  440,  421,  424,  425,  426,  427,  428,  429,
			  422,  430,  431,  432,  441,  433,  442,  443,  468,  449,
			  451,  434,  449,  451,  453,  435,  469,  453,    0,  472,
			  436,    0,    0,  439,  440,  447,  447,  447,  447,  447,
			  457,  457,  457,  680,  680,  680,  441,    0,  442,  443,
			  468,    0,  474,  451,  459,  459,  459,  459,  469,    0,
			  453,  472,    0,  449,  460,  460,  460,  460,  473,  459,

			  449,  451,  473,  476,  477,  453,  461,  461,  461,  461,
			  462,  462,  462,  462,  474,  451,  463,  463,  463,  463,
			  478,  461,  453,  479,  464,  449,  464,  464,  464,  464,
			  473,  459,  449,  451,  473,  476,  477,  453,  480,  481,
			  465,  464,  465,  465,  465,  465,  483,  461,  484,  485,
			  486,    0,  478,  461,  488,  479,  489,  490,  492,  493,
			  494,  494,  494,  497,  494,  498,  499,  500,  501,  502,
			  480,  481,  503,  464,  504,  494,  505,  507,  483,  508,
			  484,  485,  486,  465,  511,  512,  488,  514,  489,  490,
			  492,  493,  532,  517,  533,  497,  517,  498,  499,  500,

			  501,  502,  518,    0,  503,  518,  504,  519,  505,  507,
			  519,  508,  521,  521,  521,    0,  511,  512,    0,  514,
			  523,  523,  523,  523,  532,  517,  533,  525,  535,  525,
			    0,  518,  525,  525,  525,  525,  526,  526,  526,  526,
			  527,  527,  527,  527,  517,  528,  528,  528,  528,  536,
			  519,  526,  537,  518,  521,  527,  540,  517,  519,  529,
			  535,  529,  523,  518,  529,  529,  529,  529,  542,  530,
			  543,  530,  530,  530,  530,  545,  517,  546,  547,  548,
			  549,  536,  519,  526,  537,  518,  530,  527,  540,  551,
			  519,  554,  555,  557,  558,  560,  564,  565,  567,  589,

			  542,  570,  543,  569,  570,  571,  569,  545,  571,  546,
			  547,  548,  549,  580,  580,  580,  580,  591,  530,  593,
			    0,  551,    0,  554,  555,  557,  558,  560,  564,  565,
			  567,  589,  569,    0,  571,  581,  581,  581,  581,    0,
			  582,  582,  582,  582,  570,  585,  585,  585,  585,  591,
			  594,  593,  570,  595,  569,  582,  571,  598,  601,  602,
			  585,    0,    0,  583,  569,  583,  571,    0,  583,  583,
			  583,  583,  584,  604,  584,    0,  570,  584,  584,  584,
			  584,  605,  594,  606,  570,  595,  569,  582,  571,  598,
			  601,  602,  585,  586,  586,  586,  586,  587,  587,  587,

			  587,  588,  608,  588,  609,  604,  588,  588,  588,  588,
			  603,  603,  603,  605,  612,  606,  613,  612,  614,  613,
			    0,  614,  619,  620,  620,  620,  620,  621,  621,  621,
			  621,  628,  634,    0,  608,    0,  609,  622,  622,  622,
			  622,  603,  623,  623,  623,  623,    0,    0,  619,  681,
			  681,  681,  612,    0,  619,  624,  624,  624,  624,  626,
			  626,  626,  626,  628,  634,  612,  637,  613,  638,  614,
			  624,  640,  625,  603,  625,    0,  651,  625,  625,  625,
			  625,  636,  636,  636,  612,  627,  627,  627,  627,  643,
			  646,  652,  643,  647,  647,  647,  647,  612,  637,  613,

			  638,  614,  624,  640,  648,  648,  648,  648,  651,  656,
			  657,  658,  636,  659,  660,    0,  646,  683,  683,  683,
			    0,    0,  646,  652,  670,    0,  670,    0,  670,  670,
			  670,  670,  670,  670,  670,  670,  670,  684,  684,  684,
			  643,  656,  657,  658,  636,  659,  660,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  673,    0,  673,  673,
			  673,    0,  673,  673,  673,  673,  673,  673,  673,  673,
			  673,    0,  643,  664,  664,  664,  664,  664,  664,  664,
			  664,  664,  664,  664,  664,  664,  664,  664,  665,  665,
			  665,  665,  665,  665,  665,  665,  665,  665,  665,  665,

			  665,  665,  665,  666,  666,  666,  666,  666,  666,  666,
			  666,  666,  666,  666,  666,  666,  666,  666,  667,  667,
			  667,  667,  667,  667,  667,  667,  667,  667,  667,  667,
			  667,  667,  667,  668,  668,  668,  668,  668,  668,  668,
			  668,  668,  668,  668,  668,  668,  668,  668,  669,    0,
			  669,  669,  669,  669,  669,  669,  669,  669,  669,  669,
			  669,  669,  669,  671,    0,  671,  671,  671,  671,  671,
			  671,  671,  671,  671,  671,  671,  671,  671,  674,  674,
			  674,  674,  674,  674,  674,  674,  674,  674,  674,  674,
			  674,  674,  674,  675,  675,  675,  675,  675,  675,  675,

			  675,  675,  675,  675,  675,  675,  675,  675,  676,  676,
			  676,  676,  676,  676,  676,  676,  676,  676,  676,  676,
			  676,  676,  676,  677,    0,  677,  677,  677,  677,  677,
			  677,  677,  677,  677,  677,  677,  677,  677,  678,    0,
			  678,    0,  678,  678,  678,  678,  678,  678,  678,  678,
			  678,  678,  678,  679,    0,  679,  679,  679,  679,  679,
			  679,  679,  679,  679,  679,  679,  679,  679,  682,    0,
			  682,  682,  682,  682,  682,  682,  682,  682,  682,  682,
			  682,  682,  682,  685,  685,  685,  685,  685,  685,  685,
			  685,  685,  685,  685,  685,  685,  685,  685,  686,    0,

			  686,  686,  686,  686,  686,  686,  686,  686,  686,  686,
			  686,  686,  686,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663, yy_Dummy>>,
			1, 1000, 1000)
		end

	yy_chk_template_3 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  663,  663,  663,  663,  663,  663, yy_Dummy>>,
			1, 6, 2000)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,   90,   91,   99,  104,  985,  977,  109,
			  112,  115,  118,  978, 1913,  121,  124, 1913,  190,    0,
			 1913,  120, 1913, 1913, 1913, 1913, 1913,   81,  122,  120,
			  128,  147,  154,  948, 1913,  107, 1913,  109,  934,  182,
			   91,  185,  121,  195,  239,    0,  239,  114,  107,  109,
			  252,  197,  120,  175,  247,  197,  209,  133,  136, 1913,
			  902, 1913, 1913, 1913,  862, 1913,  929, 1913, 1913,  331,
			  177,  307, 1913, 1913,  286,  928, 1913, 1913,  301, 1913,
			 1913,  319,  343,  907,  351,  786,  330, 1913,  384,  149,
			  332,  342,  343,  365,  385,  386,  395,  401,  400,  399,

			  405,  421,  409,  411,  493,    0,  785,  577,  774, 1913,
			 1913, 1913,  414, 1913, 1913, 1913,  485,  493,  501,  181,
			  439,    0,  506, 1913, 1913, 1913, 1913, 1913, 1913, 1913,
			    0,  258,  430,  263,  250,  274,  320,  361,  366,  372,
			  398,  390,  419,    0,  404,  483,  487,  444,  478,  467,
			    0,  485,  568,    0,  493,  503,  504,  489,  491,  508,
			  513,    0,  495,  510,  596,  570,  499,  518,  508,  514,
			  603,  526,  551,  562,  572,  570, 1913, 1913,  775, 1913,
			  652, 1913, 1913, 1913, 1913, 1913,  637, 1913, 1913, 1913,
			 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913,

			 1913, 1913, 1913,  355, 1913, 1913,  664,  570, 1913,  757,
			 1913,  489, 1913,  677,  737, 1913, 1913,  685,  680, 1913,
			 1913, 1913, 1913,  667, 1913,  684, 1913,  686,  691,  690,
			  695,  701,  702,  710, 1913,  697,  709, 1913, 1913, 1913,
			  724,  711,  709,  698,  691,  706,  660,  654,  640,  636,
			  630,  603,  589,  586,  573,  570,  547,  540,  524,  519,
			  453,  452, 1913,  711,  772, 1913,  741,  789,  795,  801,
			  574,  385,  780,  379,  808,  812,  654,  686,    0,    0,
			  682,  690,    0,  706,  691,  699,  734,  740,  754,  772,
			  779,    0,  774,  805,  803,  791,  792,  802,  801,  809,

			  808,  813,  803,  820,  817,  822,  808,  816,  825,  816,
			    0,  828,  809,  815,  855,  831,  832,  840,  827,  856,
			  846,  865,  870,  863,  860,  870,  864,  873,  862,  872,
			    0,  873,  879,  870,    0, 1913,  896,    0,  352,  925,
			 1913, 1913, 1913,  943,  916,  942,  944, 1913,  950, 1913,
			 1913, 1913, 1913, 1913, 1913, 1913,  944,  949, 1913, 1913,
			 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913, 1913,
			 1913, 1913, 1913, 1913,  999,  963,  971, 1003,  995, 1020,
			 1024, 1030, 1036,  602,  342,    0,  316,  358, 1051, 1057,
			  880,  893,  918,  918,  940,  946,  961,  947,  968,  967,

			 1001, 1016, 1013, 1019, 1016, 1019, 1033, 1025,    0, 1047,
			 1044, 1030, 1031, 1040, 1054, 1042,    0, 1050,    0, 1062,
			    0, 1059, 1123,    0, 1063, 1052, 1065, 1069, 1058, 1064,
			 1070, 1059, 1069, 1058, 1086, 1075, 1082,    0,    0, 1096,
			 1096, 1093, 1104, 1116,    0,    0, 1913, 1146,  301, 1143,
			 1913, 1144, 1913, 1148, 1913,  301,  270, 1150,    0, 1164,
			 1174, 1186, 1190, 1196, 1206, 1222,    0,    0, 1104, 1124,
			    0,    0, 1111, 1163, 1138,    0, 1155, 1168, 1185, 1189,
			 1188, 1195,    0, 1198, 1204, 1214, 1211,    0, 1215, 1223,
			 1218,    0, 1203, 1224, 1258, 1913,  291, 1232, 1217, 1212,

			 1228, 1233, 1234, 1224, 1239, 1226,    0, 1227, 1248,    0,
			    0, 1245, 1250,    0, 1243,  282,  176, 1287, 1296, 1301,
			 1913, 1293,  299, 1301,  537, 1312, 1316, 1320, 1325, 1344,
			 1351,    0, 1241, 1244,    0, 1283, 1299, 1317,    0,    0,
			 1321,    0, 1337, 1335,    0, 1326, 1333, 1328, 1329, 1349,
			    0, 1339, 1913,  240, 1349, 1343,    0, 1349, 1350,    0,
			 1360,    0,    0,    0, 1346, 1353,    0, 1348,  155, 1397,
			 1395, 1399,  206,  175,  167,  112,  153,  138,   93,   34,
			 1393, 1415, 1420, 1448, 1457, 1425, 1473, 1477, 1486, 1349,
			    0, 1373,    0, 1385, 1416, 1411,    0,    0, 1420,    0,

			    0, 1414, 1424, 1508, 1428, 1446, 1450,    0, 1467, 1469,
			    0,    0, 1508, 1510, 1512, 1913, 1913, 1913, 1913, 1487,
			 1503, 1507, 1517, 1522, 1535, 1557, 1539, 1565, 1496,    0,
			    0,    0,    0,    0, 1482,    0, 1579, 1524, 1520,    0,
			 1536,    0,    0, 1583, 1913, 1913, 1555, 1573, 1584,    0,
			    0, 1534, 1560,    0,    0, 1913, 1578, 1561, 1562, 1564,
			 1565,    0, 1913, 1913, 1672, 1687, 1702, 1717, 1732, 1747,
			 1621, 1762, 1640, 1655, 1777, 1792, 1807, 1822, 1837, 1852,
			 1166, 1542, 1867, 1610, 1630, 1882, 1897, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  663,    1,  664,  664,  665,  665,  666,  666,  667,
			  667,  668,  668,  663,  663,  663,  663,  663,  669,  670,
			  663,  671,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  663,
			  663,  663,  663,  663,  663,  663,  673,  663,  663,  663,
			  674,  674,  663,  663,  675,  676,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  669,  663,  677,  678,
			  669,  669,  669,  669,  669,  669,  669,  669,  669,  669,

			  669,  669,  669,  669,  669,  670,  679,  679,  679,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  680,
			  680,  681,  663,  663,  663,  663,  663,  663,  663,  663,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  663,  663,  673,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,

			  663,  663,  663,  674,  663,  663,  674,  675,  663,  676,
			  663,  663,  663,  663,  682,  663,  663,  677,  678,  663,
			  663,  663,  663,  669,  663,  669,  663,  669,  669,  669,
			  669,  669,  669,  669,  663,  669,  669,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  680,  680,  680,  681,  663,  663,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,

			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  663,  663,  682,  682,  678,
			  663,  663,  663,  669,  669,  669,  669,  663,  669,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  680,  680,  272,  681,  663,  663,  663,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,

			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  663,  663,  682,  669,
			  663,  669,  663,  669,  663,  663,  683,  683,  684,  663,
			  663,  663,  663,  663,  663,  663,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  663,  663,  663,  672,  672,  672,

			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  663,  682,  669,  669,  669,
			  663,  683,  683,  683,  684,  663,  663,  663,  663,  663,
			  663,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  672,  663,  685,  672,  672,  672,  672,  672,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  682,  669,
			  669,  669,  663,  521,  663,  683,  663,  523,  663,  684,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  672,
			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,

			  672,  672,  672,  672,  672,  672,  672,  672,  672,  672,
			  672,  686,  669,  669,  669,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  672,  672,
			  672,  672,  672,  672,  672,  672,  663,  672,  672,  672,
			  672,  672,  672,  669,  663,  663,  663,  663,  663,  672,
			  672,  663,  672,  672,  672,  663,  663,  672,  663,  672,
			  663,  672,  663,    0,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663,  663,  663,  663,
			  663,  663,  663,  663,  663,  663,  663, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    5,    6,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   22,   22,   22,   22,   22,   23,   23,   24,   25,
			   26,   27,   28,   29,   30,   31,   32,   33,   34,   35,
			   36,   37,   38,   39,   40,   41,   42,   43,   44,   45,
			   46,   47,   48,   49,   50,   51,   52,   53,   54,   55,
			   56,   57,   58,   59,   60,   61,   62,   63,   64,   65,

			   66,   67,   68,   69,   70,   71,   72,   73,   74,   75,
			   76,   77,   78,   79,   80,   81,   82,   83,   84,   85,
			   86,   87,   88,   89,   90,   91,   92,    1,    1,    1,
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
			    7,    7,    8,    9,    3,    3,    3,    3,    3,    3,
			    3,    7,    7,    7,    7,    7,    7,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   11,   12,    3,    3,    3,
			    3,   13,    3,    7,    7,    7,    7,    7,    7,   10,
			   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
			   10,   10,   10,   10,   10,   10,   10,   14,   15,    3,
			    3,    3,    3, yy_Dummy>>)
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
			  232,  232,  232,  232,  233,  234,  235,  236,  237,  238,
			  239,  240,  241,  242,  243,  245,  246,  247,  248,  249,
			  250,  251,  252,  253,  255,  256,  257,  258,  259,  260,
			  261,  263,  264,  265,  267,  268,  269,  270,  271,  272,
			  273,  274,  276,  277,  278,  279,  280,  281,  282,  283,
			  284,  285,  286,  287,  288,  289,  290,  291,  292,  293,
			  294,  294,  295,  296,  297,  298,  299,  299,  300,  301,
			  302,  303,  304,  305,  306,  307,  308,  309,  310,  311,

			  312,  313,  314,  315,  316,  317,  318,  319,  320,  322,
			  323,  324,  324,  325,  326,  327,  328,  330,  332,  333,
			  335,  337,  339,  341,  342,  344,  345,  347,  348,  349,
			  350,  351,  352,  353,  354,  355,  356,  357,  359,  360,
			  362,  363,  364,  365,  366,  367,  368,  369,  370,  371,
			  372,  373,  374,  375,  376,  377,  378,  379,  380,  381,
			  382,  383,  384,  386,  387,  387,  388,  389,  389,  390,
			  391,  393,  394,  396,  397,  398,  398,  399,  400,  402,
			  404,  405,  406,  408,  409,  410,  411,  412,  413,  414,
			  415,  416,  418,  419,  420,  421,  422,  423,  424,  425,

			  426,  427,  428,  429,  430,  431,  432,  433,  434,  436,
			  437,  439,  440,  441,  442,  443,  444,  445,  446,  447,
			  448,  449,  450,  451,  452,  453,  454,  455,  456,  457,
			  458,  460,  461,  462,  463,  465,  466,  466,  467,  468,
			  468,  470,  472,  474,  475,  476,  477,  478,  480,  481,
			  483,  485,  486,  487,  488,  489,  490,  491,  492,  493,
			  494,  495,  496,  497,  498,  499,  500,  501,  502,  503,
			  504,  505,  506,  507,  508,  509,  509,  510,  511,  511,
			  511,  512,  513,  514,  514,  514,  514,  514,  514,  515,
			  516,  517,  518,  519,  520,  521,  522,  523,  524,  525,

			  526,  527,  529,  530,  531,  532,  533,  534,  535,  537,
			  538,  539,  540,  541,  542,  543,  544,  546,  547,  549,
			  550,  552,  553,  555,  557,  558,  559,  560,  561,  562,
			  563,  564,  565,  566,  567,  568,  569,  570,  572,  574,
			  575,  576,  577,  578,  579,  581,  583,  584,  584,  585,
			  586,  588,  589,  591,  592,  594,  595,  595,  595,  595,
			  596,  596,  597,  597,  598,  599,  600,  602,  604,  605,
			  606,  608,  610,  611,  612,  613,  615,  616,  617,  618,
			  619,  620,  621,  623,  624,  625,  626,  627,  629,  630,
			  631,  632,  634,  635,  636,  636,  637,  637,  638,  639,

			  640,  641,  642,  643,  644,  645,  646,  648,  649,  650,
			  652,  654,  655,  656,  658,  659,  659,  660,  661,  662,
			  663,  664,  664,  664,  664,  664,  664,  665,  666,  666,
			  666,  667,  669,  670,  671,  673,  674,  675,  676,  678,
			  680,  681,  683,  684,  685,  687,  688,  689,  690,  691,
			  692,  694,  695,  696,  696,  697,  698,  700,  701,  702,
			  704,  705,  707,  709,  711,  712,  713,  715,  716,  717,
			  718,  719,  720,  720,  720,  720,  720,  720,  720,  720,
			  720,  720,  721,  722,  722,  722,  723,  723,  724,  724,
			  725,  727,  728,  730,  731,  732,  733,  735,  737,  738,

			  740,  742,  743,  744,  745,  746,  747,  748,  750,  751,
			  752,  754,  756,  757,  758,  759,  761,  762,  764,  765,
			  766,  766,  767,  767,  768,  769,  769,  769,  770,  771,
			  773,  775,  777,  779,  781,  782,  784,  784,  785,  786,
			  788,  789,  791,  793,  794,  796,  798,  799,  799,  800,
			  802,  804,  804,  805,  807,  809,  811,  811,  812,  812,
			  813,  813,  815,  816,  816, yy_Dummy>>)
		end

	yy_acclist_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  183,  183,  185,  185,  216,  214,  215,    1,  214,
			  215,    1,  215,   37,  214,  215,  186,  214,  215,   42,
			  214,  215,   15,  214,  215,  153,  214,  215,   25,  214,
			  215,   26,  214,  215,   33,  214,  215,   31,  214,  215,
			    9,  214,  215,   32,  214,  215,   14,  214,  215,   34,
			  214,  215,  118,  214,  215,  118,  214,  215,  118,  214,
			  215,    8,  214,  215,    7,  214,  215,   19,  214,  215,
			   18,  214,  215,   20,  214,  215,   11,  214,  215,  116,
			  214,  215,  116,  214,  215,  116,  214,  215,  116,  214,
			  215,  116,  214,  215,  116,  214,  215,  116,  214,  215,

			  116,  214,  215,  116,  214,  215,  116,  214,  215,  116,
			  214,  215,  116,  214,  215,  116,  214,  215,  116,  214,
			  215,  116,  214,  215,  116,  214,  215,  116,  214,  215,
			  116,  214,  215,  116,  214,  215,  116,  214,  215,   29,
			  214,  215,  214,  215,   30,  214,  215,   35,  214,  215,
			   27,  214,  215,   28,  214,  215,   12,  214,  215,  187,
			  215,  213,  215,  211,  215,  212,  215,  183,  215,  183,
			  215,  182,  215,  181,  215,  183,  215,  185,  215,  184,
			  215,  179,  215,  179,  215,  178,  215,    6,  215,    5,
			    6,  215,    5,  215,    6,  215,    1,  186,  175,  186,

			  186,  186,  186,  186,  186,  186,  186,  186,  186,  186,
			  186,  186, -392,  186,  186,  186, -392,   42,  153,  153,
			  153,    2,   36,   10,  124,   40,   24,   23,  124,  118,
			  118,  117,  117,   16,   38,   21,   22,   39,   17,  116,
			  116,  116,  116,   47,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,   59,  116,  116,  116,  116,  116,  116,
			  116,   71,  116,  116,  116,   78,  116,  116,  116,  116,
			  116,  116,  116,  116,   91,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			   41,   13,  187,  211,  204,  202,  203,  205,  206,  207,

			  208,  188,  189,  190,  191,  192,  193,  194,  195,  196,
			  197,  198,  199,  200,  201,  183,  182,  181,  183,  183,
			  180,  181,  185,  184,  178,    5,    4,  176,  174,  176,
			  186, -392, -392,  161,  176,  159,  176,  160,  176,  162,
			  176,  186,  155,  176,  186,  156,  176,  186,  186,  186,
			  186,  186,  186,  186, -177,  186,  186,  163,  176,  153,
			  125,  153,  153,  153,  153,  153,  153,  153,  153,  153,
			  153,  153,  153,  153,  153,  153,  153,  153,  153,  153,
			  153,  153,  153,  153,  126,  153,  124,  119,  124,  118,
			  118,  122,  123,  123,  121,  123,  120,  118,  116,  116,

			   45,  116,   46,  116,  116,  116,   50,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,   62,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,   83,  116,  116,   86,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  111,  116,
			  116,  116,  116,  115,  116,  210,    4,    4,  164,  176,
			  157,  176,  158,  176,  186,  186,  186,  186,  171,  176,
			  186,  166,  176,  165,  176,  143,  141,  142,  144,  145,
			  154,  154,  146,  147,  127,  128,  129,  130,  131,  132,

			  133,  134,  135,  136,  137,  138,  139,  140,  124,  124,
			  124,  124,  118,  118,  118,  118,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,   60,  116,  116,
			  116,  116,  116,  116,  116,   69,  116,  116,  116,  116,
			  116,  116,  116,  116,   79,  116,  116,   81,  116,  116,
			   84,  116,  116,   89,  116,   90,  116,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  116,  116,  116,  116,
			  105,  116,  106,  116,  116,  116,  116,  116,  116,  113,
			  116,  114,  116,  209,    4,  186,  167,  176,  186,  170,
			  176,  186,  173,  176,  154,  124,  124,  124,  124,  118,

			   43,  116,   44,  116,  116,  116,   51,  116,   52,  116,
			  116,  116,  116,   57,  116,  116,  116,  116,  116,  116,
			  116,   67,  116,  116,  116,  116,  116,   74,  116,  116,
			  116,  116,   80,  116,  116,  116,   87,  116,  116,  116,
			  116,  116,  116,  116,  116,  116,  101,  116,  116,  116,
			  104,  116,  107,  116,  116,  116,  110,  116,  116,    4,
			  186,  186,  186,  148,  124,  124,  124,   48,  116,  116,
			  116,   54,  116,  116,  116,  116,   61,  116,   63,  116,
			  116,   65,  116,  116,  116,   70,  116,  116,  116,  116,
			  116,  116,   82,  116,  116,   88,  116,  116,   94,  116,

			  116,  116,   97,  116,  116,   99,  116,  100,  116,  102,
			  116,  116,  116,  109,  116,  116,    4,  186,  186,  186,
			  124,  124,  124,  124,  116,   53,  116,  116,   56,  116,
			  116,  116,  116,   68,  116,   72,  116,  116,   75,  116,
			   76,  116,  116,  116,  116,  116,  116,  116,   98,  116,
			  116,  116,  112,  116,    3,    4,  186,  186,  186,  151,
			  152,  152,  150,  152,  149,  124,  124,  124,  124,  124,
			  116,   55,  116,   58,  116,   64,  116,   66,  116,   73,
			  116,  116,   85,  116,  116,  116,   95,  116,  116,  103,
			  116,  108,  116,  186,  169,  176,  172,  176,  124,  124,

			   49,  116,   77,  116,  116,   93,  116,   96,  116,  168,
			  176,  116,  116,   92,  116,   92, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 1913
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 663
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 664
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

	yyNb_rules: INTEGER is 215
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 216
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

end -- class EIFFEL_SCANNER
