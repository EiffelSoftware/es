indexing
	description: "Summary description for {PLUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLUS

inherit

	EXPRESSION

create
	make

feature

	make (a_left, a_right: INTEGER)
		do
			left := a_left
			right := a_right
		ensure
			left_set: left = a_left
			right_set: right = a_right
		end

feature

	left: INTEGER
			-- Value of left side

	right: INTEGER
			-- Value of right side

feature

	sum: INTEGER
		indexing
			pure: True
		do
			Result := left + right
		ensure then
			Result = left + right
		end

end
