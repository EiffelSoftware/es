class
	INCREASE_VISITOR

inherit
	EXP_VISITOR

create
	make

feature

	make
		do
			sum := 0
		ensure
			sum = 0
		end

--	sum: INTEGER

	process_constant (a: !CONSTANT)
		do
			a.set_value (a.value + 1)
		ensure then
			a.value = old(a.value) + 1
		end

	process_plus (a: !PLUS)
		do
			a.left.visit (Current)
			a.right.visit (Current)
		ensure then
			left: (agent (a.left).visit).postcondition([Current])
			right: (agent (a.right).visit).postcondition([Current])
		end

	process_minus (a: !MINUS)
		do
			a.exp.visit (Current)
		ensure then
			exp: (agent (a.exp).visit).postcondition([Current])
		end
end
