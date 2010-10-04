note
	description: "Summary description for {ADL_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADL_ACTION

inherit
	PRINTABLE

create
	make

feature
	make (a_name: STRING; parms: LIST [STRING];
	      ps: PRE_SECTION; es: LIST [EXPR]
	      )
		do
			pre_sect := ps
			exprs := es
			name := a_name
			params := parms
		end

	pre_sect: PRE_SECTION
	exprs: LIST [EXPR]
	name: STRING
	params: LIST [STRING]

	to_printer (p : PRINTER)
		do
			p.add ("(def-adl-operator")
			p.indent
			p.newline

			print_head (p)
			p.newline
			pre_sect.to_printer (p)
			p.newline
			print_exprs (p)

			p.unindent
			p.newline
			p.add (")")
			p.newline
		end

feature {NONE}

	print_exprs (p : PRINTER)
		do
			from exprs.start
			until exprs.after
			loop
				exprs.item.to_printer (p)
				exprs.forth

				if not exprs.after then
					p.newline
				end
			end
		end

	print_head (p : PRINTER)
		do
			p.add ("(")
			p.add (name)
			p.space
			print_params (p)
			p.add (")")
		end

	print_params (p : PRINTER)
		do
			from params.start
			until params.after
			loop
				p.add ("?")
				p.add (params.item)
				params.forth

				if not params.after then
					p.space
				end
			end
		end


end
