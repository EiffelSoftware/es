note
	description: "Summary description for {PLAN_RUNNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_RUNNER

feature

	env : PLAN_ENV

	run_plan (plan : EXECUTABLE_PLAN)
		local
			i : INTEGER
		do
			from i := 1
			until i > plan.count
			loop
				plan.list [i].execute (env).do_nothing
			end

		end

end
