gelex lexer.l > js_spec_lexer.e
geyacc -t JS_SPEC_TOKENS parser.y > js_predicate_definition_parser.e