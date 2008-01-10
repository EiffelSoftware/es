indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

	some_new_line_char: CHARACTER_8

	make is
		do
			some_new_line_char := '%N'
			bar(some_new_line_char)
		end

	bar(a_char: CHARACTER) is
			-- Fail with a precondition violation.
		require
			precondition: True
		do

		ensure
			postcondition: False
		end

end
