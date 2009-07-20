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
			create spec_generator.make
			create logic_and_abstraction_locator
			output_agent := output
		end

	prove (c: !CLASS_C)
		local
			jimple_code: STRING
			specs: STRING
		do
			jimple_code_generator.process_class (c)
			jimple_code := jimple_code_generator.jimple_code
			output_agent.call ([jimple_code])
			spec_generator.process_class (c)
			specs := spec_generator.generated_specs
			output_agent.call ([specs])
			logic_and_abstraction_locator.process_class (c)
			output_agent.call ([logic_and_abstraction_locator.logic_file_name])
		end

feature {NONE}

	jimple_code_generator: JS_JIMPLE_GENERATOR

	spec_generator: JS_SPEC_GENERATOR

	logic_and_abstraction_locator: JS_LOGIC_AND_ABSTRACTION_LOCATOR

	output_agent: PROCEDURE [ANY, TUPLE [STRING_GENERAL]]

end
