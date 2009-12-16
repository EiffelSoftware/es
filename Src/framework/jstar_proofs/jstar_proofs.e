indexing
	description: "Summary description for {JSTAR_PROOFS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSTAR_PROOFS

inherit
	KL_SHARED_FILE_SYSTEM
	export {NONE} all end

	SHARED_SERVER
	export {NONE} all end

create
	make

feature

	make
		do
			create jimple_code_generator
			create spec_generator.make
			create logic_and_abstraction_locator
			create jstar_runner

			reset_results
		end

	prove (c: !CLASS_C)
		local
			l_jimple_code: STRING
			l_specs: STRING
			l_output_file_name: STRING
		do
			reset_results

			jimple_code_generator.process_class (c)
			l_jimple_code := jimple_code_generator.jimple_code
			jimple_code_file_name := file_system.pathname (directory, "Code")
			write_file (jimple_code_file_name, l_jimple_code)

			spec_generator.process_class (c)
			l_specs := spec_generator.generated_specs
			specs_file_name := file_system.pathname (directory, "Specs")
			write_file (specs_file_name, l_specs)

			logic_and_abstraction_locator.process_class (c)
			logic_file_name := logic_and_abstraction_locator.logic_file_name
			abs_file_name := logic_and_abstraction_locator.abstraction_file_name
			l_output_file_name := file_system.pathname (directory, "Output")
			file_system.delete_file (l_output_file_name)

			jstar_runner.run (dot_file_directory, jimple_code_file_name, specs_file_name, logic_file_name, abs_file_name, l_output_file_name)
			jstar_output_file_name := l_output_file_name
			cfg_file_name := ".icfg.dot"
			execution_file_name := ".execution_core.dot"
		end

	timed_out: BOOLEAN
		do
			Result := jstar_runner.timed_out
		end

feature {NONE}

	reset_results
		do
			jimple_code_file_name := Void
			specs_file_name := Void
			logic_file_name := Void
			abs_file_name := Void
			cfg_file_name := Void
			execution_file_name := Void
			jstar_output_file_name := Void
		end

	jimple_code_generator: JS_JIMPLE_GENERATOR

	spec_generator: JS_SPEC_GENERATOR

	logic_and_abstraction_locator: JS_LOGIC_AND_ABSTRACTION_LOCATOR

	jstar_runner: JS_JSTAR_RUNNER

feature -- Access

	jimple_code_file_name: STRING

	specs_file_name: STRING

	logic_file_name: STRING

	abs_file_name: STRING

	dot_file_directory: STRING
		do
			Result := directory
		end

	cfg_file_name: STRING

	execution_file_name: STRING

	jstar_output_file_name: STRING

feature {NONE} -- Implementation

	write_file (name: STRING; contents: STRING)
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
		do
			create l_output_file.make (name)
			l_output_file.open_write
			l_output_file.put_string (contents)
			l_output_file.close
		end

	directory: STRING
			-- The directory where the jStar input and output files will be written
		do
			Result := system.eiffel_project.project_directory.target_path
		end

end
