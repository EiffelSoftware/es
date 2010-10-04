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
		end

	to_printer (p : PRINTER)
		do
			p.add ("(reset-domains)")
			p.newline
			p.add ("(enable pddl-support)")
			p.newline
			p.add ("(def-domain " + dom + "Domain" +
			        " %"" + "Testing " + dom + " domain.%"" +
			        " %"" + dom + "Domain.tlp.lisp%")"
			      )
			p.newline
			p.add ("(load-pddl-problem %"" + dom + "Problem.tlp.lisp%")")
			p.newline
			p.add ("(plan)")
			p.newline
			p.add ("(exit)")
			p.newline
		end


feature {NONE}
	dom : STRING

end
