note
	description: "Summary description for {PLANNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PLANNER [G -> DOMAIN]

feature
	set_domain (a_dom : G)
		do
			dom := a_dom
		end

	dom : G

	construct_plan ( inital_state : PLAN_STATE
	               ; goal_predicate : PLAN_PREDICATE
	               ; restriction : PLAN_PREDICATE
	               )
		deferred
		ensure
			plan_generated: plan /= Void
		end


	plan : EXECUTABLE_PLAN

end
