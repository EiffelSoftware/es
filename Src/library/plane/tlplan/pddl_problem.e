note
	description: "Summary description for {PDDL_PROBLEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PDDL_PROBLEM

inherit
	PRINTABLE

create
	make

feature
	make (a_dom : STRING; a_objs: LIST [OBJ]; a_inits, a_goals: LIST [EXPR])
		do
			dom := a_dom
			objs := a_objs
			inits := a_inits
			goals := a_goals
		end

	objs: LIST [OBJ]
	inits: LIST [EXPR]
	goals: LIST [EXPR]
	dom : STRING

	to_printer (p : PRINTER)
		do
			p.add ("(define (problem " + dom + "Problem)")

			p.indent
			p.newline

			p.add ("(:domain " + dom + "Domain)")

			p.add ("(:objects")
			print_list_ln_indent (p, objs)
			p.add (")")
			p.newline

			p.add ("(:init")
			print_list_ln_indent (p, inits)
			p.add (")")
			p.newline

			p.add ("(:goal")
			print_list_ln_indent (p, goals)
			p.add (")")

			p.unindent
			p.newline
		end

end
