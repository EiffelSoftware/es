	indexing
	description	: "Class X"
	author		: "Volkan Arslan, Yann Mueller, Piotr Nienaltowski."
	date		: "$Date: 18.05.2007$"
	revision	: "1.0.0"

class
	X

create
	make

feature -- Basic operations

	f is
			-- Do some computations
		do
			(create {EXECUTION_ENVIRONMENT}).sleep (60 * 1000 * 1000 * 1000)
			io.put_string ("Termination of feature f of X with id " + identifier.out + "%N")
		end

feature {NONE} -- Implementation

	make (an_identifier: INTEGER) is
			-- Creation
		 require
			an_identifier_valid: an_identifier >= 0
		do
			identifier := an_identifier
		ensure
			an_identifier_set: identifier = an_identifier
		end

	identifier: INTEGER

end -- class X
