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
			create jstar_runner
			output_agent := output

			reset_results
		end

	prove (c: !CLASS_C)
		do
			reset_results
			output_agent.call ([""])

			jimple_code_generator.process_class (c)
			jimple_code := jimple_code_generator.jimple_code

			spec_generator.process_class (c)
			specs := spec_generator.generated_specs

			logic_and_abstraction_locator.process_class (c)
			logic_file_name := logic_and_abstraction_locator.logic_file_name
			abs_file_name := logic_and_abstraction_locator.abstraction_file_name

			jstar_runner.run (jimple_code, specs, logic_file_name, abs_file_name)
			output_agent.call ([jstar_runner.output])
		end

feature {NONE}

	reset_results
		do
			jimple_code := "Unavailable"
			specs := "Unavailable"
			logic_file_name := Void
			abs_file_name := Void
		end

	jimple_code_generator: JS_JIMPLE_GENERATOR

	spec_generator: JS_SPEC_GENERATOR

	logic_and_abstraction_locator: JS_LOGIC_AND_ABSTRACTION_LOCATOR

	jstar_runner: JS_JSTAR_RUNNER

	output_agent: PROCEDURE [ANY, TUPLE [STRING_GENERAL]]

feature -- Access

	jimple_code: STRING

	specs: STRING

	logic_file_name: STRING

	abs_file_name: STRING

end
