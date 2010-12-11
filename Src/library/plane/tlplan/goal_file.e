note
	description: "Summary description for {PLAN_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOAL_FILE

inherit
	PRINTABLE

create
	make

feature
	make (dom_name : STRING)
		do
			dom := dom_name
			create state.make
			create goals.make (10)
		end

	state: PLAN_STATE
	goals: ARRAYED_LIST [EXPR]

	full_dom_name: STRING
		do
			Result := dom + "Domain"
		end

	to_printer (p : PRINTER)
		do
			p.add_nl ("(reset-domains)")
			p.add_nl ("(verbose-on)")
			p.add_nl ("(set-trace-level 1)")
			p.add_nl ("(enable pddl-support)")

			p.add_nl ("(def-domain " + full_dom_name +
			        " %"" + "Testing " + dom + " domain.%"" +
			        " %"" + dom + "Domain.tlp.lisp%")"
			      )
--			p.add_nl ("(load-pddl-problem %"" + dom + "Problem.tlp.lisp%")")

			p.add_nl ("(load-domain " + full_dom_name + ")")
			p.add_nl ("(set-plan-name %"planny%")")

			state.to_printer (p)

			p.add_nl ("(set-initial-world)")

			p.add_nl ("(def-defined-predicate (this-goal)")
			goal_print (p)
			p.add_nl (")")

			p.add_nl ("(set-goal-addendum (this-goal))")
			p.add_nl ("(set-goal)")
			p.add_nl ("(plan)")
			p.add_nl ("(exit)")
		end

	goal_print (p : PRINTER)
		local
			big_and: EXPR
		do
			create big_and.make ("and", goals)
			big_and.to_printer (p)
		end


feature {NONE}
	dom : STRING

end
