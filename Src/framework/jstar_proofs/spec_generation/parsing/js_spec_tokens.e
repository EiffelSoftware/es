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
			when BANG then
				Result := "BANG"
			when CMPLE then
				Result := "CMPLE"
			when CMPLT then
				Result := "CMPLT"
			when CMPGE then
				Result := "CMPGE"
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
			when FALSE_TOK then
				Result := "FALSE_TOK"
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
			when TRUE_TOK then
				Result := "TRUE_TOK"
			when WHERE then
				Result := "WHERE"
			when IMP then
				Result := "IMP"
			when IFF then
				Result := "IFF"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	BANG: INTEGER is 258
	CMPLE: INTEGER is 259
	CMPLT: INTEGER is 260
	CMPGE: INTEGER is 261
	CMPGT: INTEGER is 262
	CMPNE: INTEGER is 263
	COLON: INTEGER is 264
	COMMA: INTEGER is 265
	DOT: INTEGER is 266
	EQUALS: INTEGER is 267
	ERROR_TOK: INTEGER is 268
	FALSE_TOK: INTEGER is 269
	IDENTIFIER: INTEGER is 270
	INTEGER_CONSTANT: INTEGER is 271
	L_BRACE: INTEGER is 272
	L_BRACKET: INTEGER is 273
	L_PAREN: INTEGER is 274
	MAPSTO: INTEGER is 275
	MULT: INTEGER is 276
	OROR: INTEGER is 277
	QUESTIONMARK: INTEGER is 278
	R_BRACE: INTEGER is 279
	R_BRACKET: INTEGER is 280
	R_PAREN: INTEGER is 281
	SEMICOLON: INTEGER is 282
	TRUE_TOK: INTEGER is 283
	WHERE: INTEGER is 284
	IMP: INTEGER is 285
	IFF: INTEGER is 286

end
