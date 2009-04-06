class
	SUM_VISITOR

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
			a.set_top (a.value)
--			sum := a.value
		ensure then
--			sum = a.value
			a.top = a.value
		end

	process_plus (a: !PLUS)
		do
--			a.left.visit (Current)
--			a.right.visit (Current)
		ensure then

		end

	process_minus (a: !MINUS)
		do
			a.exp.visit (Current)
			a.set_top (a.exp.top)
			check
				a.exp /= a

			end
--			sum := -sum
		ensure then
			a: (agent (a.exp).visit).postcondition([Current])
			b: a.top = -a.exp.top
		end
end
