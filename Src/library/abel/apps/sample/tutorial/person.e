note
	description: "A simple tutorial class"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class PERSON

create
	make

feature {NONE} -- Initialization

	make (first, last: STRING)
			-- Create a new person
		do
			first_name := first
			last_name := last
			age:= 0
		end

feature -- Basic operations

	celebrate_birthday
			-- Increase age by 1
		do
			age:= age+1
		end

feature -- Access

	first_name: STRING
		-- First name of person
	last_name: STRING
		-- Last name of person

	age: INTEGER
		-- The person's age

end
