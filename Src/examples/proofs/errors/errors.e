indexing
	description: "Summary description for {ERRORS}."
	date: "$Date$"
	revision: "$Revision$"

class
	ERRORS

feature

	target_not_attached
		local
			a: ANY
		do
			a.do_nothing
		end

	precondition_violation
		do
			check_violation (0)
		end

	weakend_precondition_violation
		local
			a: !CHILD
		do
			a.f (-1)
		end

	postcondition_violation: INTEGER
		do
		ensure
			Result > 0
			negative: Result < 0
		end

	check_violation (a: INTEGER)
		require
			negative: a < 0
		do
			check positive: a > 0 end
		end

	invariant_violation
		do
			-- TODO: fix invariant checking
		end

	loop_invariant_violation
		local
			a: INTEGER
		do
			from
				a := 0
			invariant
				a > 0 and a < 10
			until
				a < 10
			loop
				a := a + 1
			end
		end

	frame_violation
		do
			-- TODO: implement frame condition
		end

end
