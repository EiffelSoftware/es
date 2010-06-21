note
	description: "[
		Interface to run the Boogie verifier.
		
		Usage:
			create verifier.make
			verifier.input.add_boogie_file ("file.bpl")
			verifier.input.add_custom_content ("some boogie code")
			verifier.verify
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFIER

create
	make,
	make_remote

feature {NONE} -- Initialization

	make
			-- Initialize Boogie verifier.
		do
			create {E2B_PLATFORM_EXECUTABLE_IMPL} executable
			create output_parser.make
			create input.make
			create last_output.make_empty
			create last_result.make
		end

	make_remote (a_location: ANY)
			-- Initialize remote Boogie verifier.
		require
			False
		do
				-- Todo: implement
			check False end
		end

feature -- Access

	input: attached E2B_INPUT
			-- Input for Boogie verifier.

	last_result: attached E2B_RESULT
			-- Result of last run of Boogie.

	last_output: attached STRING
			-- Output of last run of Boogie.

feature -- Element change

	set_input (a_input: like input)
			-- Set `input' to `a_input'.
		do
			input := a_input
		ensure
			input_set: input = a_input
		end

feature -- Basic operations

	verify
			-- Launch Boogie verifier on input.
		do
			executable.set_input (input)
			executable.run
			last_output := executable.last_output
			output_parser.process (last_output)
			last_result := output_parser.last_result
		ensure
			last_output_set: last_output.is_equal (executable.last_output)
			last_result_set: last_result.is_equal (output_parser.last_result)
		end

feature {NONE} -- Implementation

	executable: attached E2B_EXECUTABLE
			-- Boogie executable.

	output_parser: attached E2B_OUTPUT_PARSER
			-- Output parser.

end
