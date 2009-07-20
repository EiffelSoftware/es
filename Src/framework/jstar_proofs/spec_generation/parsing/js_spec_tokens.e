indexing

	description: "Parser token codes"
	generator: "geyacc version 3.9"

class JS_SPEC_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_any_value: ANY
	last_string_value: STRING

feature -- Access

	token_name (a_token: INTEGER): STRING is
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when CMPLT then
				Result := "CMPLT"
			when CMPGT then
				Result := "CMPGT"
			when CMPNE then
				Result := "CMPNE"
			when COLON then
				Result := "COLON"
			when COMMA then
				Result := "COMMA"
			when DOT then
				Result := "DOT"
			when EQUALS then
				Result := "EQUALS"
			when ERROR_TOK then
				Result := "ERROR_TOK"
			when IDENTIFIER then
				Result := "IDENTIFIER"
			when INTEGER_CONSTANT then
				Result := "INTEGER_CONSTANT"
			when L_BRACE then
				Result := "L_BRACE"
			when L_BRACKET then
				Result := "L_BRACKET"
			when L_PAREN then
				Result := "L_PAREN"
			when MAPSTO then
				Result := "MAPSTO"
			when MULT then
				Result := "MULT"
			when OR_TOK then
				Result := "OR_TOK"
			when OROR then
				Result := "OROR"
			when QUESTIONMARK then
				Result := "QUESTIONMARK"
			when R_BRACE then
				Result := "R_BRACE"
			when R_BRACKET then
				Result := "R_BRACKET"
			when R_PAREN then
				Result := "R_PAREN"
			when SEMICOLON then
				Result := "SEMICOLON"
			when WAND then
				Result := "WAND"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	CMPLT: INTEGER is 258
	CMPGT: INTEGER is 259
	CMPNE: INTEGER is 260
	COLON: INTEGER is 261
	COMMA: INTEGER is 262
	DOT: INTEGER is 263
	EQUALS: INTEGER is 264
	ERROR_TOK: INTEGER is 265
	IDENTIFIER: INTEGER is 266
	INTEGER_CONSTANT: INTEGER is 267
	L_BRACE: INTEGER is 268
	L_BRACKET: INTEGER is 269
	L_PAREN: INTEGER is 270
	MAPSTO: INTEGER is 271
	MULT: INTEGER is 272
	OR_TOK: INTEGER is 273
	OROR: INTEGER is 274
	QUESTIONMARK: INTEGER is 275
	R_BRACE: INTEGER is 276
	R_BRACKET: INTEGER is 277
	R_PAREN: INTEGER is 278
	SEMICOLON: INTEGER is 279
	WAND: INTEGER is 280

end
