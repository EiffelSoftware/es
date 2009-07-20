%{
class JS_SPEC_LEXER

inherit
    YY_COMPRESSED_SCANNER_SKELETON
    
    JS_SPEC_TOKENS
    export {NONE} all end
    
create
    make
%}

LETTER_OR_UNDERSCORE     [a-zA-Z_]
DIGIT                    [0-9]

ID      {LETTER_OR_UNDERSCORE}({LETTER_OR_UNDERSCORE}|{DIGIT}|"$")*
INT     "-"?{DIGIT}+

%%

[ \t]+      -- Whitespace. Do nothing.

"<"         { last_token := CMPLT }
">"         { last_token := CMPGT }
"/="        { last_token := CMPNE }
":"         { last_token := COLON }
","         { last_token := COMMA }
"."         { last_token := DOT }
"="         { last_token := EQUALS }
{ID}        { last_token := IDENTIFIER; last_string_value := text }
{INT}       { last_token := INTEGER_CONSTANT; last_string_value := text }
"{"         { last_token := L_BRACE }
"["         { last_token := L_BRACKET }
"("         { last_token := L_PAREN }
"|->"       { last_token := MAPSTO }
"*"         { last_token := MULT }
"|"         { last_token := OR_TOK }
"||"        { last_token := OROR }
"?"         { last_token := QUESTIONMARK }
"}"         { last_token := R_BRACE }
"]"         { last_token := R_BRACKET }
")"         { last_token := R_PAREN }
";"         { last_token := SEMICOLON }
-- TODO: STRING_CONSTANT
"-*"        { last_token := WAND }

.           { last_token := ERROR_TOK }

%%

end