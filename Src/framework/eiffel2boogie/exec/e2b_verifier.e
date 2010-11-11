note
	description: "[
		Interface to run the Boogie verifier.
		
		Usage:
			create verifier.make
			verifier.input.add_boogie_file ("file.bpl")
			verifier.input.add_custom_content ("some boogie code")
			verifier.verify
			verifier.parse_verification_output
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFIER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Boogie verifier.
		do
			create {E2B_PLATFORM_EXECUTABLE_IMPL} executable
--			create {E2B_REMOTE_EXECUTABLE} executable
			create output_parser.make
			create input.make
		end

feature -- Access

	input: attached E2B_VERIFIER_INPUT
			-- Input for Boogie verifier.

	last_result: detachable E2B_RESULT
			-- Result of last run of Boogie.

	last_output: detachable STRING
			-- Output of last run of Boogie.
		do
			Result := executable.last_output
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is Boogie verifier running right now?
		do
			Result := executable.is_running
		end

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
		require
			not_running: not is_running
		do
			last_result := Void
			executable.set_input (input)
			executable.run
		ensure
			not_running: not is_running
			last_output_set: last_output.is_equal (executable.last_output)
			last_result_not_set: last_result = Void
		end

	verify_asynchronous
			-- Launch Boogie verifier on input, without waiting for Boogie to finish.
		require
			not_running: not is_running
		do
			last_result := Void
			executable.set_input (input)
			executable.run_asynchronous
		ensure
			maybe_running: is_running or not is_running
			last_output_not_set: is_running implies last_output = Void
			last_result_not_set: last_result = Void
		end

	cancel
			-- Cancel execution of Boogie.
		do
			executable.cancel
		ensure
			not_running: not is_running
		end

	parse_verification_output
			-- Parse `last_output' and fill `last_result'.
		require
			last_output_set: attached last_output
		do
			output_parser.process (last_output)
			last_result := output_parser.last_result
		ensure
			last_result_set: attached last_result
		end

feature {NONE} -- Implementation

	executable: attached E2B_EXECUTABLE
			-- Boogie executable.

	output_parser: attached E2B_OUTPUT_PARSER
			-- Output parser.

end
