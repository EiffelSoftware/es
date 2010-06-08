#!/usr/bin/env ruby

def generate_parsers()
	parts = [['JS_PREDICATE_DEFINITION_PARSER','predicate_definition'],['JS_ASSERTION_PARSER','formula'],['JS_EXPORTS_CLAUSE_PARSER','exports_clause'],['JS_AXIOMS_CLAUSE_PARSER','axioms_clause']]
	filename = "temp.y"
	parts.each do
		|eclass,startsymbol|
		puts("Generating: " + eclass)
		system('echo \'' + '%{\n' + 'class ' + eclass + '\n' + '\' > ' + filename)
		system("cat parser_part1 >> " + filename)
		system('echo \'' + '%start ' + startsymbol + '\n' + '\' >> ' + filename)
		system("cat parser_part2 >> " + filename)
		system("geyacc -t JS_SPEC_TOKENS " + filename + " > " + eclass.downcase + ".e")
		puts("Done with " + eclass + "\n\n")
	end
end

system("gelex lexer.l > js_spec_lexer.e")
generate_parsers()

