note
	description: "Generate Boogie code from IV universe."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BOOGIE_GENERATOR

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE)
			-- Initialize Boogie generator with universe `a_boogie_universe'.
		do
			boogie_universe := a_boogie_universe
		ensure
			boogie_universe_set: boogie_universe = a_boogie_universe
		end

feature -- Access

	boogie_universe: IV_UNIVERSE
			-- Boogie universe.

	last_generated_verifier_input: E2B_VERIFIER_INPUT
			-- Verifier input generated from `iv_universe'.

feature -- Basic operations

	generate_verifier_input
			-- Generate verifier input for `boogie_universe'.
		local
			l_printer: IV_BOOGIE_PRINTER
		do
			create last_generated_verifier_input.make

				-- Add background theory
			last_generated_verifier_input.add_boogie_file ("D:\Eiffel\eve\Delivery\studio\tools\autoproof\base_theory.bpl")
			last_generated_verifier_input.add_boogie_file ("D:\Eiffel\eve\Delivery\studio\tools\autoproof\arrays.bpl")

			create l_printer.make
			boogie_universe.process (l_printer)
			last_generated_verifier_input.add_custom_content (l_printer.output.out)
		end

end
