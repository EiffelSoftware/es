%{
--class JS_ASSERTION_PARSER
class JS_PREDICATE_DEFINITION_PARSER

inherit
    YY_PARSER_SKELETON
        rename make as make_parser_skeleton end
    
    JS_SPEC_LEXER
    rename make as make_scanner end
    
create
    make
%}

%token BANG
%token <STRING> CMPLE
%token <STRING> CMPLT
%token <STRING> CMPGE
%token <STRING> CMPGT
%token <STRING> CMPNE
%token COLON
%token COMMA
%token DOT
%token <STRING> EQUALS
%token ERROR_TOK
%token FALSE_TOK
%token <STRING> IDENTIFIER
%token <STRING> INTEGER_CONSTANT
%token L_BRACE
%token L_BRACKET
%token L_PAREN
%token MAPSTO
%token MULT
%token OROR
%token QUESTIONMARK
%token R_BRACE
%token R_BRACKET
%token R_PAREN
%token SEMICOLON
-- TODO: %token <STRING> STRING_CONSTANT
%token TRUE_TOK

%left OROR
%left MULT

--%start formula
%start predicate_definition

%type <JS_PRED_DEF_NODE> predicate_definition
%type <LINKED_LIST [JS_PARAM_NODE]> param_list
%type <LINKED_LIST [JS_PARAM_NODE]> param_list_non_empty
%type <JS_PARAM_NODE> param
%type <JS_ASSERTION_NODE> formula
%type <STRING> binop
%type <LINKED_LIST [JS_ARGUMENT_NODE]> argument_list
%type <LINKED_LIST [JS_ARGUMENT_NODE]> argument_list_non_empty
%type <JS_ARGUMENT_NODE> argument
%type <JS_VARIABLE_NODE> variable
%type <LINKED_LIST [JS_FLD_EQUALITY_NODE]> fldlist
%type <JS_FLD_EQUALITY_NODE> fld_equality
%type <JS_TYPE_NODE> type
%type <JS_FIELD_SIG_NODE> field_signature

%%

predicate_definition: IDENTIFIER L_PAREN variable param_list R_PAREN EQUALS formula      { create $$.make ($1, $3, $4, $7); predicate_definition := $$ }
                    ;

param_list:                                             { create $$.make } -- Empty
          | COMMA L_BRACE param_list_non_empty R_BRACE  { $$ := $3 }
          ;
       
param_list_non_empty: param                                   { create $$.make; $$.put_front ($1) }
                    | param SEMICOLON param_list_non_empty    { $3.put_front ($1); $$ := $3 }
                    ;
       
param: IDENTIFIER EQUALS variable   { create $$.make ($1, $3) }
     ;

formula: TRUE_TOK                                        { create {JS_TRUE_NODE} $$.make; assertion := $$ }
       | FALSE_TOK                                       { create {JS_FALSE_NODE} $$.make; assertion := $$ }
       | argument DOT field_signature MAPSTO argument    { create {JS_MAPSTO_NODE} $$.make ($1, $3, $5); assertion := $$ }
       | BANG IDENTIFIER L_PAREN argument_list R_PAREN   { create {JS_PURE_PREDICATE_NODE} $$.make ($2, $4); assertion := $$ }
       | IDENTIFIER L_PAREN argument_list R_PAREN        { create {JS_SPATIAL_PRED_NODE} $$.make ($1, $3); assertion := $$ }
       | formula MULT formula                            { create {JS_STAR_NODE} $$.make ($1, $3); assertion := $$ }
       | formula OROR formula                            { create {JS_OR_NODE} $$.make ($1, $3); assertion := $$ }
       | argument COLON type                             { create {JS_TYPE_JUDGEMENT_NODE} $$.make ($1, $3); assertion := $$ }
       | argument binop argument                         { create {JS_BINOP_NODE} $$.make ($1, $2, $3); assertion := $$ }
       | L_PAREN formula R_PAREN                         { $$ := $2; assertion := $$ }
       ;

binop: CMPNE  { $$ := $1 } 
     | CMPGT  { $$ := $1 } 
     | CMPGE  { $$ := $1 } 
     | CMPLT  { $$ := $1 } 
     | CMPLE  { $$ := $1 }
     | EQUALS { $$ := $1 }
     ;

argument_list:                             { create $$.make }  -- Empty
             | argument_list_non_empty     { $$ := $1 }
             ;

argument_list_non_empty: argument                                { create $$.make; $$.put_front ($1) }
                       | argument COMMA argument_list_non_empty  { $3.put_front ($1); $$ := $3 }
                       ;

argument: variable                                    { create {JS_VARIABLE_AS_ARG_NODE} $$.make ($1) }
        | IDENTIFIER L_PAREN argument_list R_PAREN    { create {JS_FUNCTION_TERM_AS_ARG_NODE} $$.make ($1, $3) }
        | INTEGER_CONSTANT                            { create {JS_INTEGER_AS_ARG_NODE} $$.make ($1) }
-- TODO      | STRING_CONSTANT
        | L_BRACE fldlist R_BRACE                     { create {JS_FLD_EQ_LIST_AS_ARG_NODE} $$.make ($2) }
        ;
        
variable: IDENTIFIER               { create $$.make ($1) }
        | QUESTIONMARK IDENTIFIER  { create $$.make ("?" + $2) }
        ;
        
fldlist: fld_equality                     { create $$.make; $$.put_front ($1) }
       | fld_equality SEMICOLON fldlist   { $3.put_front ($1); $$ := $3 }
       ;

fld_equality: IDENTIFIER EQUALS argument   { create $$.make ($1, $3) }
            ;

type: IDENTIFIER optional_type_params    { create $$.make ($1) }
    ;

optional_type_params:    -- Empty
                    | L_BRACKET type_list_non_empty R_BRACKET
                    ;
                    
type_list_non_empty: type
                   | type COMMA type_list_non_empty
                   ;

field_signature: CMPLT IDENTIFIER DOT IDENTIFIER CMPGT      { create $$.make ($2, $4) }
               ;

%%
-- User code

    make
        do
            make_scanner
            make_parser_skeleton
        end
    
        -- Only one of the following two attributes will be valid!!!
    assertion: JS_ASSERTION_NODE
    predicate_definition: JS_PRED_DEF_NODE
    
end
