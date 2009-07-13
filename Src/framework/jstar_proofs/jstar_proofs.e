indexing
	description: "Summary description for {JSTAR_PROOFS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSTAR_PROOFS

create
	make

feature

	make (output: PROCEDURE [ANY, TUPLE [STRING_GENERAL]])
		do
			create jimple_code_generator
			output_agent := output
		end

	prove (c: !CLASS_C)
		local
			jimple_code: STRING
		do
			jimple_code_generator.process_class (c)
			jimple_code := jimple_code_generator.jimple_code
			output_agent.call ([jimple_code])
		end

feature {NONE}

	jimple_code_generator: JS_JIMPLE_GENERATOR

	output_agent: PROCEDURE [ANY, TUPLE [STRING_GENERAL]]

end
