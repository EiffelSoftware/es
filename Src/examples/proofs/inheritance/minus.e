class
	MINUS

inherit

	EXPRESSION

create
	make

feature

	make (a_exp: !EXPRESSION)
		require
			a_exp /= Current
		do
			exp := a_exp
		ensure
			value_set: exp = a_exp
		end

	exp: !EXPRESSION

feature

	sum: INTEGER
		indexing
			pure: True
		do
			Result := - exp.sum
		ensure then
			Result = - exp.sum
		end


	accept
		do
			exp.accept
			top := - exp.top
		ensure then
			(agent exp.accept).postcondition ([])
			top = - exp.top
		end

	visit (v: !EXP_VISITOR)
		do
			v.process_minus (Current)
		ensure then
			(agent v.process_minus).postcondition([Current])

		end

invariant
	Current /= exp

end
