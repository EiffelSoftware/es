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

%token CMPLT
%token CMPGT
%token CMPNE
%token COLON
%token COMMA
%token DOT
%token EQUALS
%token ERROR_TOK
%token <STRING> IDENTIFIER
%token <STRING> INTEGER_CONSTANT
%token L_BRACE
%token L_BRACKET
%token L_PAREN
%token MAPSTO
%token MULT
%token OR_TOK
%token OROR
%token QUESTIONMARK
%token R_BRACE
%token R_BRACKET
%token R_PAREN
%token SEMICOLON
-- TODO: %token <STRING> STRING_CONSTANT
%token WAND

--%start formula
%start predicate_definition

%type <JS_PRED_DEF_NODE> predicate_definition
%type <LINKED_LIST [JS_PARAM_NODE]> param_list
%type <LINKED_LIST [JS_PARAM_NODE]> param_list_non_empty
%type <JS_PARAM_NODE> param
%type <JS_ASSERTION_NODE> formula
%type <LINKED_LIST [JS_PURE_NODE]> pure_list
%type <LINKED_LIST [JS_PURE_NODE]> pure_list_non_empty
%type <JS_PURE_NODE> pure
%type <LINKED_LIST [JS_ARGUMENT_NODE]> argument_list
%type <LINKED_LIST [JS_ARGUMENT_NODE]> argument_list_non_empty
%type <JS_ARGUMENT_NODE> argument
%type <JS_VARIABLE_NODE> variable
%type <LINKED_LIST [JS_FLD_EQUALITY_NODE]> fldlist
%type <JS_FLD_EQUALITY_NODE> fld_equality
%type <JS_TYPE_NODE> type
%type <LINKED_LIST [JS_SPATIAL_NODE]> spatial_list
%type <LINKED_LIST [JS_SPATIAL_NODE]> spatial_list_non_empty
%type <JS_SPATIAL_NODE> spatial
%type <JS_COMBINE_NODE> combine
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

formula: pure_list OR_TOK spatial_list   { create $$.make ($1, $3); assertion := $$ }
       ;

pure_list:                       { create $$.make } -- Empty list
         | pure_list_non_empty   { $$ := $1 }
         ;
         
pure_list_non_empty: pure                           { create $$.make; $$.put_front ($1) }
                   | pure MULT pure_list_non_empty  { $3.put_front ($1); $$ := $3 }
                   ;

pure: IDENTIFIER L_PAREN argument_list R_PAREN    { create {JS_PURE_PREDICATE_NODE} $$.make ($1, $3) }
    | argument EQUALS argument                    { create {JS_PURE_EQUALITY_NODE} $$.make ($1, $3) }
    | argument CMPNE argument                     { create {JS_PURE_INEQUALITY_NODE} $$.make ($1, $3) }
    | argument COLON type                         { create {JS_PURE_TYPE_JUDGEMENT_NODE} $$.make ($1, $3) }
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
                   
spatial_list:                           { create $$.make } -- Empty
            | spatial_list_non_empty    { $$ := $1 }
            ;
            
spatial_list_non_empty: spatial                               { create $$.make; $$.put_front ($1) }
                      | spatial MULT spatial_list_non_empty   { $3.put_front ($1); $$ := $3 }
                      ;
                      
spatial: argument DOT field_signature MAPSTO argument   { create {JS_SPATIAL_MAPSTO_NODE} $$.make ($1, $3, $5) }
       | IDENTIFIER L_PAREN argument_list R_PAREN       { create {JS_SPATIAL_PRED_NODE} $$.make ($1, $3) }
       | L_PAREN combine R_PAREN                        { create {JS_SPATIAL_COMBINE_NODE} $$.make ($2) }
       ;
       
combine: formula OROR formula       { create {JS_COMBINE_OROR_NODE} $$.make ($1, $3) }
       | formula WAND formula       { create {JS_COMBINE_WAND_NODE} $$.make ($1, $3) }
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