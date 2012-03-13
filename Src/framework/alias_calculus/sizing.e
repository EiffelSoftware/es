note
	description: "Summary description for {SIZING}."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"


class
	SIZING

feature -- Constants

	Min_expressions: INTEGER = 7
			-- Starting number of expressions.

	Average_aliases: INTEGER = 5
			-- Default number of aliases for an expression.

	Groups_per_line: INTEGER = 2
			-- Number of alias groups to print on a line.


	Default_cached_call_aliases: INTEGER = 10
			-- Default number of cached input aliases for a call.

	Example_estimate: INTEGER = 20
			-- Number of predefined examples.

feature -- Limitations

	Max_dots: INTEGER = 4
			-- Length (minus 1) of longest multidot in program.
			-- Here this is estimated to a constant value; in an
			-- actual program it will be a variable, computed
			-- from an analysis of the program.


end
