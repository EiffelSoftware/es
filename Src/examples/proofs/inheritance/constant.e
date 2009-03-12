indexing
	description: "Summary description for {CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONSTANT

inherit

	EXPRESSION

create
	make

feature

	make (a_value: INTEGER)
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

feature

	value: INTEGER
			-- Value of constant

feature

	sum: INTEGER
		indexing
			pure: True
		do
			Result := value
		ensure then
			Result = value
		end

end
