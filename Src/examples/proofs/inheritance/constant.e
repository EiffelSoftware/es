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

	set_value (a_value: INTEGER)
		do
			value := a_value
		ensure
			value = a_value
		end


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

	visit (v: !EXP_VISITOR)
		do
			v.process_constant (Current)
		ensure then
			(agent v.process_constant).postcondition([Current])

			value = value
		end

invariant
	true
--	value > 0

end
