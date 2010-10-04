note
	description: "Summary description for {TL_PLANNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TL_PLANNER

inherit
	PLANNER [TL_DOMAIN]

create
	make

feature
	make (a_dom : TL_DOMAIN)
		do
			set_domain (a_dom)
		end

	construct_plan ( inital_state : PLAN_STATE
	               ; goal_predicate : PLAN_PREDICATE
	               ; restriction : PLAN_PREDICATE
	               )
		do
			create plan.make

			
		end

end
