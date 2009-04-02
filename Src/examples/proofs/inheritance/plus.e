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

	make (a_left, a_right: !EXPRESSION)
		require
--			a_left > 0
--			a_right > 0
			a_left /= a_right
		do
			left := a_left
			right := a_right
		ensure
			left_set: left = a_left
			right_set: right = a_right
		end

feature

	left: !EXPRESSION
			-- Value of left side

	right: !EXPRESSION
			-- Value of right side

feature

--	top: INTEGER

	accept
		local
			l1, l2: INTEGER
		do
			left.accept
			l1 := left.top
			right.accept
			l2 := right.top
			top := l1 + l2
		ensure then
			(agent left.accept).postcondition ([])
			(agent right.accept).postcondition ([])
			top = left.top + right.top
		end

--	accept
--		local
--			l1, l2: INTEGER
--		do
--			left.accept
----			l1 := left.top
----			right.accept
----			l2 := right.top
--			top := left.top --+ right.top
--		ensure then
--			a: top = left.sum --+ right.sum
--			left.top = left.top
----			right.top = right.top
--		--	b: top = sum
--		end

	sum: INTEGER
		indexing
			pure: True
		do
			Result := left.sum + right.sum
		ensure then
			Result = left.sum + right.sum
		end

	eval_left
		local
		do
			left.accept
		ensure
			(agent left.accept).postcondition ([])
			left.top = left.top	-- modifies left.top
		end

	visit (a: !EXP_VISITOR)
		do
			a.process_plus (Current)
		ensure then
			(agent a.process_plus).postcondition([Current])
		end

invariant
	left /= right
	left /= right
--	left > 0
--	right > 0

end
