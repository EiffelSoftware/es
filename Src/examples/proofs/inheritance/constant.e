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
		require
--			a_value > 0
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

--	top: INTEGER

	accept
		do
			top := value
		ensure then
			top = value
		end

invariant
	true
--	value > 0

end
