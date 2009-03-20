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
		require
			a_left > 0
			a_right > 0
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

--	top: INTEGER

--	accept
--		local
--			l1, l2: INTEGER
--		do
--			left.accept
--			l1 := left.top
--			right.accept
--			l2 := right.top
--			top := l1 + l2
--		ensure
--			(agent left.accept).postcondition ([])
--			(agent right.accept).postcondition ([])
--			top = left.top + right.top
--		end

	sum: INTEGER
--		indexing
--			pure: True
		do
			Result := left + right
		ensure then
			Result = left + right
		end

invariant
	left > 0
	right > 0

end
